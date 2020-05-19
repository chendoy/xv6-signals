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
void sigcont_handler();

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
  // pushcli();

  // acquire(&ptable.lock);
  // pushcli();
  do{
    pid = nextpid;
  }while(!cas((int*)(&nextpid), pid, pid + 1));
  // popcli();
  // release(&ptable.lock);


  return pid;
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

  // acquire(&ptable.lock);

  pushcli();
  do {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      if(p->state == UNUSED)
        break;
    if (p == &ptable.proc[NPROC]) {
      popcli();
        // release(&ptable.lock);
      return 0; // err no space in ptable
    }
  } while (!cas((int*)(&p->state), UNUSED, EMBRYO));
  popcli();

  // release(&ptable.lock);
  

// found:
  // p->state = EMBRYO;
  // release(&ptable.lock);

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
  
  // acquire(&ptable.lock);
  // pushcli();
  // if(!cas((int*)(&p->state), EMBRYO, RUNNABLE)) // TODO: THIS CAUSE SOME PROBLEMS~! (pushcli, popcli reduant?)
  //   panic("cas failed in userinit");
  // popcli();


  // acquire(&ptable.lock);
  // pushcli();
  // if(!cas((int*)(&p->state), EMBRYO, RUNNABLE)){
  //    panic("err in userinit: np state not embryo");
  // }
  // pushcli();
  p->state = RUNNABLE;
  // popcli();
  // cprintf("should br runnable %d", p->state);
  // popcli();
  // release(&ptable.lock);
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


// // Create a new process copying p as the parent.
// // Sets up stack to return as if from system call.
// // Caller must set state of returned proc to RUNNABLE.
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
  // pushcli();
  //  if(!cas((int*)(&np->state), EMBRYO, RUNNABLE)) // TODO: THIS CAUSE SOME PROBLEMS~! (pushcli, popcli reduant?)
  //   panic("cas failed in userinit");
  // popcli();

  // acquire(&ptable.lock);
  // pushcli();
  // if(!cas((int*)(&np->state), EMBRYO, RUNNABLE))
  // {
  //   panic("err in fork: np state npt embryo");
  // }
  pushcli();
  cas((int*)(&np->state), EMBRYO, RUNNABLE);
  popcli();
  // release(&ptable.lock);
  // popcli();
  // cprintf("should be runnable %d", np->state);
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

  // acquire(&ptable.lock); lock_c
  pushcli();
 
   // Parent might be sleeping in wait().
  // wakeup1(curproc->parent); //we will wake up parent only in shceduler, when process become zombie! u_check


  if(!cas((int*)(&curproc->state), RUNNING, MINUS_ZOMBIE))
    {
      panic("process should be at running state!");
    }else{
    } //c_check
  // Jump into the scheduler, never to return.
  // curproc->state = ZOMBIE;  // u_check


   // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  sched();
  panic("zombie exit");
}

// // Wait for a child process to exit and return its pid.
// // Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  // acquire(&ptable.lock);
  pushcli();
  for(;;){
    if (!cas((int*)(&curproc->state), RUNNING, MINUS_SLEEPING)) {
      panic("wait: failed  process should be running!");
      } // we going simulate the sleeping function here! doing steps as in sleep
    curproc->chan = curproc; // setting the proc chan


//     // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      
      if(cas((int*)(&p->state), ZOMBIE, MINUS_UNUSED)){//c_check -> TODO: problem with this transition at usertests!
        // if((p->state == ZOMBIE)){  // u_check
        // Found one.
        // cprintf("found zombie!");
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0; 
        curproc->chan = 0; //reseting cur proc chan because wern't going to sleep!
        cas((int*)(&curproc->state), MINUS_SLEEPING, RUNNING);
        cas((int*)(&p->state), MINUS_UNUSED, UNUSED);
        // curproc->state = RUNNING; //reseting cur proc chan because wern't going to sleep!
        // p->state = UNUSED; //u_check
        // release(&ptable.lock);
        popcli();
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){

      // cas((int*)(&curproc->state), MINUS_SLEEPING, RUNNING); // process not going to sleep so it should stay running!
      curproc->chan = 0; //reseting cur proc chan because wern't going to sleep!
      if(!cas((int*)(&curproc->state), MINUS_SLEEPING, RUNNING))
      {
        panic("should be minus sleeping!");
      }
      // curproc->state = RUNNING; //reseting cur proc chan because wern't going to sleep!
      popcli();
      // release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    // popcli();
    // sleep(curproc, &ptable.lock);  // we just need call sched now!
    sched();
  }
}

int
canRunEvenIfFrozen(struct proc* p)
{

  uint sig;
  void* handler;

  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
    if(p->psignals & (1 << sig)) {
      handler = ((struct sigaction*)&p->sig_handlers[sig])->sa_handler;

      if(handler == SIG_DFL && (sig == SIGCONT || sig == SIGKILL))
        return 1;
      
      if(handler == (void (*)())SIGCONT || handler == (void (*)())SIGKILL)
        return 1;
    }
  }
  return 0;
}


// //PAGEBREAK: 42
// // Per-CPU process scheduler.
// // Each CPU calls scheduler() after setting itself up.
// // Scheduler never returns.  It loops, doing:
// //  - choose a process to run
// //  - swtch to start running that process
// //  - eventually that process transfers control
// //      via swtch back to the scheduler.
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
      // acquire(&ptable.lock);
    pushcli();
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){

      if(!cas((int*)(&p->state), RUNNABLE, RUNNING)) // this line elminate from 2 cpu's run the same process!
      {
        continue;
      }

      if(p->frozen)
      {
        if(canRunEvenIfFrozen(p))
        {
          //let p run
        }
        else
        {
          cas((int*)(&p->state), RUNNING, RUNNABLE);
          continue;
        }

      }
        // if(p->state != RUNNABLE)   // u_check
        // {
        //     continue;
        // }

      

        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        c->proc = p;
        switchuvm(p);
        // p->state = RUNNING; // u_check

        // if(!cas((int*)(&p->state), RUNNABLE, RUNNING)){
        //   panic("process should be runnable!");
        // }

        swtch(&(c->scheduler), p->context);
        switchkvm();
        c->proc = 0;


        if (cas((int*)(&p->state), MINUS_SLEEPING, SLEEPING)) {
          if (p->killed == 1)
          {
             cas((int*)(&p->state), SLEEPING, RUNNABLE);
          }
          
        } //c_check
  
        cas((int*)(&p->state), MINUS_RUNNABLE, RUNNABLE); //c_check

        if(p->state == MINUS_ZOMBIE){
          p->chan = 0; // all this transition is instead of the transion in wait from zombie to unused!

          if (cas((int*)(&p->state), MINUS_ZOMBIE, ZOMBIE)) //c_check
          {
            wakeup1(p->parent); // DELAYED WAKEUP UNTIL process is actually zombie!
          }

        }
        
      

        // Process is done running for now.
        // It should have changed its p->state before coming back.
    }
    // release(&ptable.lock);
    popcli();

  }
}

// // Enter scheduler.  Must hold only ptable.lock
// // and have changed proc->state. Saves and restores
// // intena because intena is a property of this
// // kernel thread, not this CPU. It should
// // be proc->intena and proc->ncli, but that would
// // break in the few places where a lock is held but
// // there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  // if(!holding(&ptable.lock))
  //   panic("sched ptable.lock"); // u_check
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

// // Give up the CPU for one scheduling round.
void
yield(void)
{
  // acquire(&ptable.lock);  //DOC: yieldlock
  pushcli();
  if(!cas((int*)(&myproc()->state), RUNNING, MINUS_RUNNABLE)){
    panic("cas failed at yiled, process state should be running!");
  } //c_check
  // myproc()->state = RUNNABLE; //u_check
  sched();
  popcli();
  // release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  // release(&ptable.lock);
  popcli();

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

  //moving the cas befoe release lock solved problems as explained in meeting hours
    // Go to sleep.
  p->chan = chan;
  // p->state = SLEEPING; // u_check
  if(!cas((int*)(&p->state), RUNNING, MINUS_SLEEPING)) // c_check
  {
    panic("cas failed at sleeping, should be running state!");
  }

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


  sched();

  // Tidy up.
  // p->chan = 0; // u_check we want the process channel become 0 when he at minus_runnable state! (that happen on weakup1)
  //              otherwise he his state can be set to 'runnable' and he can be executed before his chan set to 0!

  // Reacquire original lock.
  if(lk != 0){  //DOC: sleeplock2
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
  pushcli();
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if((p->state == SLEEPING || p->state == MINUS_SLEEPING) && p->chan == chan)
    {
        // while(p->state == MINUS_SLEEPING){
        //   //wating until process will become sleeping and then we will put it as runnable!
        // }

        // if(cas((int*)(&p->state), SLEEPING, MINUS_RUNNABLE)){
        //   p->chan = 0; //reseting process's chan now to prevent it from running the process with not 0 chanel!
        //   if(!cas((int*)(&p->state), MINUS_RUNNABLE, RUNNABLE)){
        //     panic("error at wakeup1, process should be minus_runnable!");
        //   }
        // }
        
      while(!cas(&p->state,SLEEPING,MINUS_RUNNABLE))
      {

        if (p->state == RUNNING)
        {
          break;
        }    
      }

      if (p->state !=RUNNING)
      {
        cas(&p->state,MINUS_RUNNABLE,RUNNABLE);
      }
      
    } 
  }
  popcli();
  // c_check
  // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  // {
  //   if((p->state == SLEEPING && p->chan == chan)){  
  //       p->state = RUNNABLE; 
  //     }
  // } u check
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
  pushcli();
  // acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->pid == pid)
    {
      int expected_on = p->psignals | (1 << signum);
      if(!cas((int*)(&p->psignals), expected_on, expected_on))
      {
        if(signum != 1)
        {
          p->psignals |= (1 << signum);
        }
        // popcli();
        // release(&ptable.lock);
        popcli();
        return 0;
      }
      popcli();
    }
  }
  // release(&ptable.lock);
  popcli();
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


// //PAGEBREAK: 36
// // Print a process listing to console.  For debugging.
// // Runs when user types ^P on console.
// // No lock to avoid wedging a stuck machine further.
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
  [MINUS_ZOMBIE] "minus_zombie"
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
void
sigkill_handler(){
  //cprintf("sigkill handler was fired\n");
  struct proc *p = myproc();
  p->killed = 1;
  // Wake process from sleep if necessary.
  if(p->state == SLEEPING)
    cas((int*)(&p->state), SLEEPING, RUNNABLE);
  return;
}

void
sigstop_handler(){
  struct proc *p = myproc();

  if(p-> state == SLEEPING)
    return;

  p->frozen = 1;
  
  // {
  //   cas((int*)(&p->state),SLEEPING,RUNNABLE); //TODO: why not ignore on this situation? why to runnable?
  // }
  return;


  // release(&ptable.lock);
  // yield();
  // acquire(&ptable.lock);
}

void
sigcont_handler(){
  struct proc* p = myproc();
  p->frozen = 0;
  return;
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

  if(signum > SIG_MAX || signum < SIG_MIN) // trying to change wierd signal number
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
    p->sigmask_backup = sigprocmask(((struct sigaction*)p->sig_handlers[sig])->sigmask);

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
handle_signals (struct trapframe *tf){
  struct proc *p = myproc();
  uint sig;

  if(p == 0)
    return;
  
  if ((tf->cs & 3) != DPL_USER)
    return; // CPU isn't at privilege level 3, hence in user mode. facebook comment!
   

  // acquire(&ptable.lock);
  //pushcli();
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
    int expected = p->psignals | (1 << sig) ;
  //signal sig is pending and is not blocked
    if(p->sigmask & (1 << sig) && sig != SIGSTOP && sig != SIGKILL) { // signal is blocked by mask and is not SIGSTOP or SIGKILL because they
      if(cas((int*)(&p->psignals), expected, expected ^ (1 << sig)))  // cannot be blocked
        continue;
    }
    
    
    if(cas((int*)(&p->psignals), expected, expected ^ (1 << sig)))
      handleSignal(sig);           
      
  // if((p->psignals & (1 << sig))  && !(p->sigmask & (1 << sig))) {
  //   handleSignal(sig);           // handle it
  //   p->psignals ^= 1 << sig;     // turn off this bit
  //   }
  }
  //popcli();
  // release(&ptable.lock);
  return;
}

int
sigret(void) {
  struct proc* p = myproc();
  memmove(p->tf, p->tf_backup, sizeof(struct trapframe)); // trapframe restore
  p->sigmask = p->sigmask_backup;
  handle_signals(p->tf);
  return 0;
}