#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

extern void sigret_caller_end(void);
extern void sigret_caller_start(void);
void copySigHandlers(void** new_sighandlers, void** old_sighandlers);
void setDefaultHandlers();
int sigcont_handler();

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}




int
allocpid(void)
{
 
  int pid;
  // acquire(&ptable.lock);
  // pid = nextpid++;
  // release(&ptable.lock);
  pushcli();
  do {
    pid = nextpid;
  } while (!cas((int*)&nextpid, pid, pid + 1));
  // popcli();
  return pid + 1;
  popcli();
}


//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

pushcli();
do {
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      break;
  if (p == &ptable.proc[NPROC]) {
    popcli();
    return 0; // ptable is full
  }
} while (!cas((int*)&p->state, UNUSED, EMBRYO));
popcli();

//   acquire(&ptable.lock);

//   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
//     if(p->state == UNUSED)
//       goto found;

//   release(&ptable.lock);
//   return 0;

// found:
//   p->state = EMBRYO;
//   release(&ptable.lock);

  p->pid = allocpid();

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  p->psignals = 0;
  p->sigmask = 0;

  for (int i = SIG_MIN; i <= SIG_MAX; i++) // setting all sig handlers to default
    p->sig_handlers[i] = SIG_DFL;
  
  return p;
}


//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{

  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  
  // pushcli();
  //  if(!cas((int*)&p->state, EMBRYO, RUNNABLE))
  //   panic("cas failed in userinit");
  // popcli();
  p->state = RUNNABLE;

  cprintf("p->state: %d\n", p->state);

}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}


// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // assignment 2
  np->sigmask = curproc->sigmask;
  copySigHandlers((void**)&np->sig_handlers, (void**)&curproc->sig_handlers);

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  // acquire(&ptable.lock);

pushcli();
if(!cas((int*)&np->state, EMBRYO, RUNNABLE))
  panic("cas failed in fork");
popcli();
  
  // release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  //acquire(&ptable.lock);
  pushcli();
  if(!cas((int*)&curproc->state, RUNNING, MINUS_ZOMBIE))
    panic("cas failed in exit");

  // Parent might be sleeping in wait().
  // wakeup1(curproc->parent); the parent was waken up in the schduler function already

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  //curproc->state = ZOMBIE;  reduant because we take care of it in the scheduler
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  //acquire(&ptable.lock);
  pushcli();
  for(;;){
    if (!cas((int*)&curproc->state, RUNNING, MINUS_SLEEPING)) {
      panic("cas failed in scheduler");
    }
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(cas((int*)&p->state, ZOMBIE, UNUSED)){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        // p->state = UNUSED;
        cas((int*)&curproc->state, MINUS_SLEEPING, RUNNING);
        //release(&ptable.lock);
        //cas(&p->state, MINUS_UNUSED, UNUSED);
        popcli();
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      //release(&ptable.lock);
      if (!cas((int*)&curproc->state, MINUS_SLEEPING, RUNNING))
        panic("wait: CAS from NEG_SLEEPING to RUNNING failed");
      popcli();
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    //sleep(curproc, &ptable.lock);  //DOC: wait-sleep
    sched();
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    //acquire(&ptable.lock);
    pushcli();
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){

        if(!cas((int*)&p->state, RUNNABLE, RUNNING)) {
          continue;
        }


      if(p->frozen) 
      {
        if(p->psignals & (1 << SIGCONT)) // received cont
        {
          p->frozen = 0;
          p->psignals ^= 1 << SIGCONT;

        }
        else{
            p->state = RUNNABLE; //the process can't run because its frozen! so it's states cant't remain running.
            continue;
        } 
         
      }

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);

      //p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      if (cas((int*)&p->state, MINUS_SLEEPING, SLEEPING)) {
        if (cas((int*)&p->killed, 1, 0))
          p->state = RUNNABLE;
      }

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
      cas((int*)&p->state, MINUS_RUNNABLE, RUNNABLE);

      if (p->state == MINUS_ZOMBIE) {
          kfree(p->kstack);
          p->kstack = 0;
          freevm(p->pgdir);
          p->killed = 0;
          p->chan = 0;
        if (cas((int*)&p->state, MINUS_ZOMBIE, ZOMBIE))
          wakeup1(p->parent);
      }

    }
    //release(&ptable.lock);
    popcli();
  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  // if(!holding(&ptable.lock))
  //   panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
     
  intena = mycpu()->intena;

  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  //acquire(&ptable.lock);  //DOC: yieldlock
  pushcli();
  if(!cas((int*)&myproc()->state, RUNNING, MINUS_RUNNABLE))
    panic("cas failed in yield!");
  sched();
  popcli();
  //release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  pushcli();
  p->chan = chan;

  if (!cas((int*)&p->state, RUNNING, MINUS_SLEEPING))
    panic("sleep: cas failed");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    // acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  // p->chan = chan;
  // p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    // release(&ptable.lock);
    acquire(lk);
  }
  popcli();
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  
    if (p->chan == chan && (p->state == SLEEPING || p->state == MINUS_SLEEPING)) {
      while (p->state == MINUS_SLEEPING) {
        // we wait until the process become on it's absolute state (sleeping).
      }

    if (cas((int*)&p->state, SLEEPING, MINUS_RUNNABLE)) {
      // if the process become on it's absolute state then we can change the p's chan, and update process state to runnable.
        p->chan = 0;
        if (!cas((int*)&p->state, MINUS_RUNNABLE, RUNNABLE))
          panic("wakeup1: cas failed");
    }
  }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  // acquire(&ptable.lock);
  pushcli();
  wakeup1(chan);
  popcli();
  // release(&ptable.lock);
}



// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
// assignment 2 - modified
int
kill(int pid, int signum)
{
  if(signum < SIG_MIN || signum > SIG_MAX)
    return -1;
  struct proc *p;
  //acquire(&ptable.lock);
  uint psignals = 0;
  do {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->pid == pid){
        break;
        //release(&ptable.lock);
        return 0;
      psignals = p->psignals;
      }
    }} while(!cas((int*)&p->psignals, psignals, p->psignals | (1 << signum)));
  //release(&ptable.lock);
  return -1;
}

// system call: updating the process signal mask ass2
uint
sigprocmask(uint mask)
{
  struct proc *curproc = myproc();
  uint old = curproc -> sigmask;
  curproc->sigmask = mask;
  return old;
}


//restorting the process to its original workflow, ass2
// uint sigret(void)
// {

// }


//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]            "unused",
  [MINUS_UNUSED]      "minus_unused",
  [EMBRYO]            "embryo",
  [SLEEPING]          "sleep ",
  [MINUS_SLEEPING]    "minus_sleeping",
  [RUNNABLE]          "runble",
  [MINUS_RUNNABLE]    "minus_runnable",
  [RUNNING]           "run   ",
  [ZOMBIE]            "zombie",
  [MINUS_ZOMBIE]      "minus_zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// implmntation of SIGKILL, will cause the process to be killed (similar to orig xv6 kill) ass2
int
sigkill_handler(){
  //cprintf("sigkill handler was fired\n");
  struct proc *p = myproc();
  p->killed = 1;
  // Wake process from sleep if necessary.
  if(p->state == SLEEPING)
    p->state = RUNNABLE;
  return 0;
}

int
sigstop_handler(){
  struct proc *p = myproc();
  if(p-> state == SLEEPING)
    return 1;

  p->frozen = 1;
  return 0;
}

int
sigcont_handler(){
  struct proc* p = myproc();
  p->frozen = 0;
  return 0;
}

void 
copySigHandlers(void** new_sighandlers, void** old_sighandlers) {
  int i;
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
    new_sighandlers[i] = old_sighandlers[i];
  }
}

int 
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact) 
{
  struct proc* curproc = myproc();

  if(signum == SIGSTOP || signum == SIGKILL) // they cannot be modified, blocked or ignored
    return 1;

  if(oldact != null) {
    oldact->sa_handler = ((struct sigaction*)&curproc->sig_handlers[signum])->sa_handler;              // old handler
    oldact->sigmask = ((struct sigaction*)&curproc->sig_handlers[signum])->sigmask;                    // old sigmask
  }

  ((struct sigaction*)&curproc->sig_handlers[signum])->sa_handler = act->sa_handler;
  ((struct sigaction*)&curproc->sig_handlers[signum])->sigmask = act->sigmask;

  if(act->sigmask <= 0) // sigmask must be positive
    return 1;

  return 0;
}

void
user_handler(struct proc* p, uint sig)
{

    char *sigret_caller_addr;
    uint sigret_size;

    // back-up trap frame
    memmove(p->kstack, p->tf, sizeof(*p->tf));
    p->tf_backup = (struct trapframe*)p->kstack;

    // changing the user space stack
    sigret_size = sigret_caller_end - sigret_caller_start;
    p->tf->esp = p->tf->esp - sigret_size; // make room for sigret code

    sigret_caller_addr = (char*)p->tf->esp;

    memmove((char*)p->tf->esp, sigret_caller_start, sigret_size);

    // pushing signum
    p->tf->esp = p->tf->esp-UINT_SIZE;
    *((uint*)(p->tf->esp)) = sig;

    // pushing sigret caller
    p->tf->esp = p->tf->esp-UINT_SIZE;
    *((uint*)(p->tf->esp)) = (uint)sigret_caller_addr;

    // updating user eip to user handler's address
    p->tf->eip = (uint)&((struct sigaction*)p->sig_handlers[sig])->sa_handler;
    return;
}

void
handleSignal (int sig) {
  struct proc *p = myproc();
  if(p->sig_handlers[sig] == SIG_IGN)
  {
    // do nothing
  }

  else if(p->sig_handlers[sig] == SIG_DFL)
  {
    switch (sig) 
    {
      case SIGCONT:
        sigcont_handler();
        break;
      case SIGSTOP:
        sigstop_handler();
        break;
      case SIGKILL:
        sigkill_handler();
        break;
      default:
        if(sig != SIGKILL && sig != SIGSTOP && sig != SIGCONT) {
          sigkill_handler();
        }
        break;
      
    }
  }

  else
    user_handler(p, sig);
}

void
handle_signals (){
  struct proc *p = myproc();
  uint sig;

  if(p == 0)
    return;

  //acquire(&ptable.lock);
  
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
  //signal sig is pending and is not blocked
  
    if((p->psignals & (1 << sig))  && !(p->sigmask & (1 << sig))) {
      handleSignal(sig);           // handle it
      uint psignals;
      do {
        psignals = p->psignals;
      } while(!cas((int*)&p->psignals, psignals, psignals ^ (1 << sig)));
    }
  }
  //release(&ptable.lock);
  return;
}

int
sigret(void) {
  struct proc* p = myproc();
  memmove(p->tf, p->tf_backup, sizeof(struct trapframe)); // trapframe restore
  return 0;
}