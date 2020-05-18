#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"



struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;




static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);
//global vars of memory address
extern void inject_start(void);
extern void inject_end(void);

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

  do{
      pid = nextpid;
      
  }while(!cas(&nextpid,pid,pid+1));
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


//   acquire(&ptable.lock);

//   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
//     if(p->state == UNUSED)
//       goto found;

//   release(&ptable.lock);
//   return 0;

// found:
//   p->state = EMBRYO;
//   release(&ptable.lock);


//We look in ptable for unused proc
//if we found we try to set is state to EMBRYO from UNUSED with cas mechanism
//else we don't found return 0

  pushcli();
  int found = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  { 
    if(p->state == UNUSED)
    {
      if (cas(&p->state,UNUSED,EMBRYO))
      {
        found =1;
        break;
      }
    }
  }
  popcli();
  if (!found)
  {
    return 0;
  }

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
  memset(p->signals_handlers, SIG_DFL, sizeof *p->signals_handlers);
  memset(p->signals_handlers_mask, 0, sizeof *p->signals_handlers_mask);
  p->context->eip = (uint)forkret;
  p->pending_signals = 0;
  p->mask_signals = 0;
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

  //state: embryo->runnable
  // pushcli();

  // cas(&p->state,EMBRYO,RUNNABLE);

  // popcli();


  //acquire(&ptable.lock);
  
  p->state = RUNNABLE;

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

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
  np->mask_signals = curproc->mask_signals;
  memmove(np->signals_handlers,curproc->signals_handlers,sizeof *curproc->signals_handlers);
  pid = np->pid;

//state: embryo->runnable
  pushcli();

  cas(&np->state,EMBRYO,RUNNABLE);
  
  popcli();
  //acquire(&ptable.lock);
  
  // p->state = RUNNABLE;

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
  
  // Parent might be sleeping in wait().
  //dont need it we wakeup in the scheduler
  //wakeup1(curproc->parent);

  //state: runnig->zombie 
  pushcli();

  cas(&curproc->state, RUNNING,X_ZOMBIE);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  
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

  //state: ZOMBIE ->UNUSED 
  //acquire(&ptable.lock);

  pushcli();

  for(;;){
    //We keep that the chan will not change
    cas(&curproc->state,RUNNING,X_SLEEPING);

    curproc->chan=curproc;
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(cas(&p->state,ZOMBIE,X_UNUSED)){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        cas(&curproc->state,X_SLEEPING,RUNNING);
        cas(&p->state,X_UNUSED,UNUSED);
        
        //release(&ptable.lock);
        popcli();
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      //release(&ptable.lock);
      curproc->chan = 0;
      cas(&curproc->state,X_SLEEPING,RUNNING);
      popcli();
      return -1;
    }

    sched();
  }
}
int
check_stop(struct proc *p)
{
  return (((p->pending_signals >> SIGSTOP) & 1U) == 1) && (((p->pending_signals >> SIGCONT) & 1U) == 0);
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
    //state: runnable-> runnig 
    //acquire(&ptable.lock);
    pushcli();
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      
      if(check_stop(p))
      {
        continue;
      }
      if(cas(&p->state,RUNNABLE, RUNNING))
      {
        c->proc = p;
        switchuvm(p);
        swtch(&(c->scheduler), p->context);
        switchkvm();

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
        if (cas(&p->state, X_SLEEPING, SLEEPING))
        {
          if(p->killed == 1)
          {
            cas(&p->state, SLEEPING, RUNNABLE);
          }
        }
        if (cas(&p->state, X_RUNNABLE, RUNNABLE))
        {
         
        }
        if (p->state== X_ZOMBIE)
        {
          p->chan = 0;
          if (cas(&p->state, X_ZOMBIE, ZOMBIE))
          {
            wakeup1(p->parent);
          }
        }
        
        
        
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

//state: runnig->runnable 
// Give up the CPU for one scheduling round.
void
yield(void)
{
  // acquire(&ptable.lock);  //DOC: yieldlock
  // myproc()->state = RUNNABLE;
  // sched();
  // release(&ptable.lock);

  pushcli();
  cas(&myproc()->state,RUNNING,X_RUNNABLE);
  sched();
  popcli();
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  //release(&ptable.lock);
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
  p->chan = chan;
  cas(&p->state,RUNNING,X_SLEEPING);
  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  
  //state: runnig->sleep 
  if(lk != &ptable.lock){  //DOC: sleeplock0
    //acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.

  sched();

  // Tidy up.
  // p->chan = 0;
  
  // Reacquire original lock.
  if(lk != 0){  //DOC: sleeplock2
    //release(&ptable.lock);
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

  //proc that enter wakeup can be in three state
  //two build in state (X_SLEEPING,SLEEPING) 
  //and one state (RUNNING) that can be change dynamiclay
  //we will enter the if only if the proc is acctually sleeping
  //and the chan is relevant
  //after the if the state may change dynamiclay 
  //so we will busy wait until the proc will finish X_SLEEPING
  //but if the proc changet dynamiclay 
  //we dont need to wake him up. 

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->chan == chan && (p->state == X_SLEEPING || p->state == SLEEPING))
    {
      // while(p->state == X_SLEEPING)
      // {
      //   cprintf("");
      // }
      // if (cas(&p->state,SLEEPING,X_RUNNABLE))
      // {
      //   p->chan = 0;
      //   cas(&p->state,X_RUNNABLE,RUNNABLE);
      // }
      while(!cas(&p->state,SLEEPING,X_RUNNABLE))
      {
        if (p->state == RUNNING)
        {
          break;
        }
        
      }
      if (p->state !=RUNNING)
      {
        p->chan = 0;
        cas(&p->state,X_RUNNABLE,RUNNABLE);
      }
      
    }
  }
  popcli();
    
}

// Wake up all processes sleeping on chan.
//state: sleeping ->runabble 
void
wakeup(void *chan)
{
  //acquire(&ptable.lock);
  pushcli();
  wakeup1(chan);
  popcli();
  //release(&ptable.lock);
}

int
kill_handler(struct proc *p)
{
  p->killed = 1;
  //clearing the SIGSTOP bit for run time
  p->pending_signals &= ~(1UL << SIGSTOP);
  // Wake process from sleep if necessary.
  //stat: sleeping->runnable
  if(p->state == SLEEPING)
    //p->state = RUNNABLE;  
    cas(&p->state,SLEEPING,RUNNABLE);
  return 0;

}

int
stop_handler(struct proc *p)
{
  //checking the SIGCONT bit
  if (((p->pending_signals >> SIGCONT) & 1U) == 1)
  {
    //clearing the SIGCONT bit
    p->pending_signals &= ~(1UL << SIGCONT);
  }
  //Wake process from sleep if necessary.
  //stat: sleeping->runnable
  if(p->state == SLEEPING)
    //p->state = RUNNABLE;  
    cas(&p->state,SLEEPING,RUNNABLE);
  return 0;
}

int
cont_handler(struct proc *p)
{
 //checking the SIGSTOP bit
  if (((p->pending_signals >> SIGSTOP) & 1U) == 1)
  {
    //clearing the SIGSTOP bit
     p->pending_signals &= ~(1UL << SIGSTOP);
  }
  return 0;

}
 
void
handlers_default(int signum, struct proc *p)
{
  switch (signum)
  {
  case SIGSTOP:
    stop_handler(p);
    break;
  case SIGCONT:
    cont_handler(p);
    break; 
  default:
    kill_handler(p);
    break;
  }
}
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).

int 
kill(int pid, int signum)
{
  if (signum < 0 || signum > ARRAY_SIZE - 1)
  {
    cprintf("ERROR  : signum must be in 0-31 rage\n");
    return -1;
  }
  struct proc *p;
  //acquire(&ptable.lock);
  pushcli();
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
    // Setting a bit
    // Use the bitwise OR operator (|) to set a bit
    if (signum == SIGCONT && ((p->pending_signals >> SIGSTOP) & 1U) == 1)
    {
      if(!(((p->mask_signals >> SIGCONT) & 1U) == 1))
      {
        p->pending_signals |= 1UL << SIGCONT;
      }
    } 
    else if (signum != SIGCONT)
    {
      p->pending_signals |= 1UL << signum;
    }
    //release(&ptable.lock);
    popcli();
    return 0;
    }
  }
  //release(&ptable.lock);
  popcli();
  return -1;
}



//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]      "unused",
  [X_UNUSED]   "x_unused",
  [EMBRYO]      "embryo",
  [X_EMBRYO]   "x_embryo",
  [SLEEPING]    "sleep",
  [X_SLEEPING] "x_sleep ",
  [RUNNABLE]    "runble",
  [X_RUNNABLE] "x_runble",
  [RUNNING]     "run",
  [X_RUNNING]  "x_run",
  [ZOMBIE]      "zombie",
  [X_ZOMBIE]   "x_zombie"

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

uint
sigprocmask(uint sig_mask)
{
  struct proc *p = myproc();
  uint old_mask = p->mask_signals;
  p->mask_signals = sig_mask;
  return old_mask;
}

int
sigaction(int signum, const sigaction_s *act, sigaction_s *oldact)
{
  struct proc *p = myproc();
  if (signum == SIGKILL || signum == SIGSTOP)
  {
    cprintf("ERROR : SIGKILL or SIGSTOP cannot be modified\n");
    return -1;
  }
  if (signum < 0 || signum > 31)
  {
    cprintf("ERROR : signum must be in 0-31 range\n");
    return -1;
  }
  if (oldact != null)
  {
    oldact->sa_handler =(sa_handler)p->signals_handlers[signum];
    oldact->sig_mask = p->signals_handlers_mask[signum];
  }
  p->signals_handlers[signum]=(sa_handler)act->sa_handler;
  p->signals_handlers_mask[signum] = act->sig_mask;
  return 0;
}

void 
check_signals_pending(struct trapframe *tf)
{
  struct proc *p = myproc();
  int i;
  int signum = -1;
  if (p == null)
  {
    return;
  }
  if ((tf->cs & 3) != DPL_USER)
    return; // CPU isn't at privilege level 3, hence in user mode
   
  //find the first pending signal
  for (i = 0; i < ARRAY_SIZE; i++)
  {
    if (((p->pending_signals >> i) & 1U) == 1)
    {
      
      signum = i;

      //ignore the signal by mask signal
      if (signum != SIGKILL && (signum != SIGSTOP) && ((p->mask_signals >> signum) & 1U) == 1)
      {
        //clear the signal bit
        p->pending_signals &= ~(1UL << signum);
      }
      
      //default handler for SIG_DFL - kernel
      else if ( p->signals_handlers[signum] == (sa_handler)SIG_DFL)
      {
        handlers_default(signum,p);
        //clear the signal bit
        p->pending_signals &= ~(1UL << signum);
      }
      //clear the signal bit, and ignore 
      else if ((p->signals_handlers[signum]) == (sa_handler)SIG_IGN )
      {
        p->pending_signals &= ~(1UL << signum);
      }
      //default handler for SIGKILL || SIGSTOP || SIGCONT - kernel
      else if (p->signals_handlers[signum] == (sa_handler)SIGKILL || p->signals_handlers[signum] == (sa_handler)SIGSTOP || p->signals_handlers[signum] == (sa_handler)SIGCONT)
      {
        int new_signum =(int)p->signals_handlers[signum];
        handlers_default(new_signum,p);
        //clear the signal bit
        p->pending_signals &= ~(1UL << signum);
      }
      // handler for userspace
      else
      {
        //clear the signal bit
        p->pending_signals &= ~(1UL << signum);
        //backing up trap frame
        memmove(&p->tf_backup, p->tf, sizeof(struct trapframe));
        p->mask_signals_backup = sigprocmask(p->signals_handlers_mask[signum]);
        p->tf->esp -= (uint)&inject_end - (uint)&inject_start;
        memmove((void*)p->tf->esp, inject_start, (uint)&inject_end - (uint)&inject_start);
        *((int*)(p->tf->esp - 4)) = signum;
        *((int*)(p->tf->esp - 8)) = p->tf->esp;
        p->tf->esp -= 8;
        p->tf->eip = (uint)p->signals_handlers[signum]; // jump to signal handler
      }      
    }
  }
  return;
}


void
sigret()
{
  struct proc *p = myproc();
  memmove(p->tf, &p->tf_backup ,sizeof(struct trapframe));//backing up trap frame
  p->mask_signals = p->mask_signals_backup;
  check_signals_pending(p->tf);
  return;
}



