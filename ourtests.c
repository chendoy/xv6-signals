#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#define ITER_SIGPROCMASK_TEST 10

// sigprocmask, sigaction
void
sigprocmask_test()
{
    uint i;
    uint mask, omask;
    struct sigaction newact;
    struct sigaction oldact;

    for(i = 1; i < ITER_SIGPROCMASK_TEST; i++) {
        mask = i;
        omask = sigprocmask(mask);
        printf(1, "should be %d = %d\n", i-1 ,omask);
    }

    newact.sa_handler = SIG_IGN;
    newact.sigmask = 12;
    sigaction(12, &newact, &oldact);
    printf(1, "should be 0,0 = %d,%d\n", (uint)oldact.sa_handler, oldact.sigmask);
    sigaction(12, &oldact, &newact);
    printf(1, "should be 1,12 = %d,%d\n", (uint)newact.sa_handler, newact.sigmask);
}

// kernel space handlers (stop, cont, kill)
void
cont_stop_kill_abc_test()
{
    int pid;
    int sigs[] = {SIGSTOP, SIGCONT};

    if((pid = fork()) == 0) {
        while (1) {
            sleep(5);printf(1, "a");sleep(5);printf(1, "b");sleep(5);printf(1, "c");sleep(5);printf(1, "d");
            sleep(5);printf(1, "e");sleep(5);printf(1, "f");sleep(5);printf(1, "g");sleep(5);printf(1, "h");
            sleep(5);printf(1, "i");sleep(5);printf(1, "j");sleep(5);printf(1, "k");sleep(5);printf(1, "l");
            sleep(5);printf(1, "m");sleep(5);printf(1, "n");sleep(5);printf(1, "o");sleep(5);printf(1, "p");
            sleep(5);printf(1, "q");sleep(5);printf(1, "r");sleep(5);printf(1, "s");sleep(5);printf(1, "t");
            sleep(5);printf(1, "u");sleep(5);printf(1, "v");sleep(5);printf(1, "w");sleep(5);printf(1, "x");
            sleep(5);printf(1, "y");sleep(5);printf(1, "z");

        }
    } 
    else
    {  
        for (int i = 0; i < 20; i++)
        {
            if (i % 2)
            {
                printf(2, "\n%d: SENT: CONT\n", i);
            } 
            else
            {
                printf(2, "\n%d: SENT: STOP\n", i);    
            }
            
            kill(pid, sigs[i%2]);
            sleep(50);
        }

        printf(1, "\nSENT: KILL!\n");
        kill(pid, SIGKILL);
        wait();
    }
}

void
custom_handler(int signum)
{
    printf(1, "child: CUSTOM HANDLER WAS FIRED!!\n");
    return;
}

// user space handlers
void
user_handler_test()
{
    struct sigaction act;
    uint mask = 0;
    uint pid;

    act.sa_handler = &custom_handler;
    act.sigmask = mask;

    if((pid = fork()) == 0) 
    {
        sigaction(SIGTEST, &act, null); // register custom handler

        while(1)
        {
            printf(1, "child: waiting...\n");
            sleep(30);
        }
    }

    else
    {
        sleep(300); // let child print some lines
        printf(1, "parent: kill(child, SIGTEST)\n");
        sleep(5);
        kill(pid, SIGTEST);
        sleep(50);
        printf(1, "parent: kill(child, SIGKILL)\n");
        kill(pid, SIGKILL);
        wait();
        return;
    }
}

//This Test will check if sa handlers and masks changing acording 
//To the sigaction
//Input: Single process and 4 sigactions
//Output: Each Time we modify we will check the modification executed correctly
//And will print the results.
void
simple_sigaction_test()
{
    //At First we will check that sigprocmask is working
    printf(0,"mask: %d\n",sigprocmask(0));
    printf(0,"mask: %d\n",sigprocmask(100));
    printf(0,"mask: %d\n",sigprocmask(0));
    printf(0,"Start SigactionTetss\n");
    //Allocate First struct of sigaction
    struct sigaction *FIrstSigAct = malloc(sizeof(struct sigaction));
    FIrstSigAct->sa_handler = (void (*)())14;
    FIrstSigAct->sigmask=7;
    printf(0,"Create SigAction1 with handler(int 14) and mask (int 7)\n");
    struct sigaction *SecondSigAct = malloc(sizeof(struct sigaction));
    SecondSigAct->sa_handler = (void (*)())22;
    SecondSigAct->sigmask=8;
    printf(0,"Create SigAction2 with handler(int 22) and mask (int 8)\n");
    printf(0,"Check SigAct1 handler number: %d\n",FIrstSigAct->sa_handler);
    printf(0,"Performing First sigaction assign to signum 4 SigAction1\n");
    sigaction(4,FIrstSigAct,null);
    struct sigaction *ThirdSigAct = malloc(sizeof(struct sigaction));
    printf(0,"Creating SigAction3 to hold the old action hander\n");
    sigaction(4, SecondSigAct, ThirdSigAct);
    printf(0,"Changed signum 4 to hold SigAction2 and Sigaction 3 will hold SigAction1\n");
    printf(0,"SigAction3 handler should be 14: %d\n",ThirdSigAct->sa_handler);
    printf(0,"SigAction3 mask should be 7: %d\n",ThirdSigAct->sigmask);
    sigaction(4,SecondSigAct,null);
    printf(0,"SigAction3 handler should be 14: %d\n",ThirdSigAct->sa_handler);
    printf(0,"SigAction3 mask should be 7: %d\n",ThirdSigAct->sigmask);
    struct sigaction *ForthSigAct = malloc(sizeof(struct sigaction));
    ForthSigAct->sa_handler = (void (*)())28;
    ForthSigAct->sigmask=4;
    printf(0,"Create SigAction4 with handler(int 28) and mask (int 4)\n");
    sigaction(4, ForthSigAct, null);
    printf(0,"Changed signum 4 to hold SigAction4 and do not save old\n");
    sigaction(4, ForthSigAct, FIrstSigAct);
    printf(0,"Changed signum 4 to hold SigAction4 and FirstSigact will hold the old (sig4)\n");
    printf(0,"SigAction1 handler should be 28: %d\n",FIrstSigAct->sa_handler);
    printf(0,"SigAction1 mask should be 4: %d\n",FIrstSigAct->sigmask);
    printf(0,"Error Tests - Will check things that should not changed are working\n");
    printf(0,"Try to Change signum kill\n");
    sigaction(SIGKILL, ForthSigAct, ThirdSigAct);
    printf(0,"Try to Change signum 43 (do not exist\n");
    sigaction(43, ForthSigAct, ThirdSigAct);
    printf(0,"SigAction3 handler should be 14: %d\n",ThirdSigAct->sa_handler);
    printf(0,"SigAction3 mask should be 7: %d\n",ThirdSigAct->sigmask);
    printf(0,"Finished\n");
    return;
}

int
kill_self_test()
{
    kill(getpid(),SIGKILL);
    return 0;
}
void
user_handler_signal(int signum)
{
    printf(0,"pid : %d is Using User Handler Signal - %d!!!!WOrks!!!\n", getpid(),signum);
    return;
}
int
kill_other(int child_kill, int signum)
{
    kill(child_kill,signum);
    return 0;
}
//This Test will check the Kernel and User handers Signal1
//should kill one process with itself - done
//should kill one process with other - done
//use a function as a handler - done
//Input: int[4] childs;
void
SignalTests1()
{
    int child_pid[4];
    /* Start children. */
    if((child_pid[0]=fork()) == 0)
    {
        printf(0,"Trying to self kill the process\n");
        kill_self_test();
        sleep(50);
        printf(0,"Process 1 Should have benn Killed Already!\n");
        exit();
    }
    else
    {
        if((child_pid[1]=fork()) == 0)
        {
            struct sigaction *UserHandlerSignal = malloc(sizeof(struct sigaction));
            UserHandlerSignal->sa_handler = user_handler_signal;
            UserHandlerSignal->sigmask=0;
            printf(0,"Created User Handler Signal with mask that is 0\n");

            sigaction(22,UserHandlerSignal,null);
            printf(0,"Assigned User Handler Signal to signum 22\n");
            printf(0,"Starting Loop\n");
            for(;;)
            {
                printf(0,"pid - %d child two\n",getpid());
                sleep(50);
            }
            exit();
        }
        else
        {
            if((child_pid[2]=fork()) == 0)
            {
                sleep(150);
                printf(0,"Run User Handler Signal Second Child\n");
                kill_other(child_pid[1],22);
                sleep(450);
                exit();
            }
            else
            {
                if((child_pid[3]=fork()) == 0)
                {
                    sleep(250);
                    printf(0,"signal kill to second child\n");
                    kill(child_pid[1],SIGKILL);
                    sleep(100);
                    exit();
                }
            }
        }
        
    }
    //wait for children
    
    wait();
    wait();
    wait();
    wait();
    printf(0,"parent\n");
    return;

}

//This Test will check the Kernel and User handers Signal
//mask ignore test - done
//mask ignore kill - done
//Input: int[4] childs;
void
SignalTests2()
{
    int child_pid[4];
    /* Start children. */
    if((child_pid[0]=fork()) == 0)
    {
        printf(0,"Trying to self kill the process even while Mask is Blocking\n");
        //Kill Mask is 256
        //We will do 1kill1 = 896
        sigprocmask(896);
        kill_self_test();
        sleep(250);
        for(;;)
        {
            printf(0,"Process 1 Should have benn Killed Alreadyyyyy!\n");
        }
        exit();
    }
    else
    {
        if((child_pid[1]=fork()) == 0)
        {
            //Ignore All check if we ignore Cont
            printf(0,"Trying to Ignore All\n");
            sigprocmask(4294967295);
            
            struct sigaction *SigAction1 = malloc(sizeof(struct sigaction));
            SigAction1->sa_handler = (void (*)())SIGKILL;
            SigAction1->sigmask=4294967295;
            printf(0,"Creating sinum 4 handler is SIGKILL and mask is Ignore ALl\n");
            sigaction(4,SigAction1,null);
            for(;;)
            {
                printf(0,"pid - %d child two\n",getpid());
                sleep(50);
            }
            exit();
        }
        else
        {
            if((child_pid[2]=fork()) == 0)
            {
                sleep(250);
                kill_other(child_pid[1],4);
                printf(0,"Should Ignore Signla 4\n");
                sleep(550);
                exit();
            }
            else
            {
                if((child_pid[3]=fork()) == 0)
                {
                    sleep(480);
                    //Seconf Test
                    printf(0,"signal kill\n");
                    kill(child_pid[1],SIGKILL);
                    sleep(100);
                    exit();
                }
            }
        }
        
    }
    //wait for children
    wait();
    wait();
    wait();
    wait();
    printf(0,"parent\n");
    return;

}

//This Test will check the Kernel and User handers Signal1
//should stop one process with other - done
//should cont one process with other - done
//sigaction kill - done
//Input: int[4] childs;
void
SignalTests3()
{
    int child_pid[4];
    /* Start children. */
    if((child_pid[0]=fork()) == 0)
    {
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
        KillHAndlerSignal->sa_handler = (void (*)())SIGKILL;
        KillHAndlerSignal->sigmask = 0;
        printf(0,"Created KillHAndlerSignal (KILL) with mask that is 0\n");
        sigaction(4,KillHAndlerSignal,null);
        printf(0,"Sending KillHAndlerSignal (22)to process\n");
        kill_self_test(4);
        sleep(1250);
        for(;;)
        {
            printf(0,"Process 1 should have been killed already!\n");
            sleep(100);
        }
        exit();
    }
    else
    {
        if((child_pid[1]=fork()) == 0)
        {
            printf(0,"Starting Loop\n");
            for(;;)
            {
                printf(0,"pid - %d child two\n",getpid());
                sleep(50);
            }
            exit();
        }
        else
        {
            if((child_pid[2]=fork()) == 0)
            {
                printf(0, "child 3 pid: %d\n", getpid());
                sleep(30);
                printf(0,"Run SigSTOP Second Child\n");
                kill_other(child_pid[1],SIGSTOP);
                printf(0, "@@@@@1\n");
                sleep(20);
                printf(0, "@@@@@2\n");
                printf(0,"Send SIGCONT child two\n");
                kill_other(child_pid[1],SIGCONT);
                sleep(20);
                printf(0,"Send SIGSTOP child2 AGAIN\n");
                kill_other(child_pid[1],SIGSTOP);
                printf(0, "@@@@@1\n");
                sleep(20);
                printf(0, "@@@@@2\n");
                printf(0,"Send SIGKILL to child2\n");
                kill_other(child_pid[1],SIGKILL);
                sleep(30);
                printf(0,"Send SIGCONT to child2\n");
                kill_other(child_pid[1],SIGCONT);
                sleep(30);
                exit();
            }
            else
            {
                if((child_pid[3]=fork()) == 0)
                {
                    exit();
                }
            }
        }
        
    }
    //wait for children
    
    wait();
    wait();
    wait();
    wait();
    printf(0,"parent\n");
    return;

}

void sleepTest() {
    int child_pid[4];
    /* Start children. */
    if((child_pid[0]=fork()) == 0)
    {
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
        KillHAndlerSignal->sa_handler = (void (*)())SIGKILL;
        KillHAndlerSignal->sigmask = 0;
        printf(0,"Created KillHAndlerSignal (KILL) with mask that is 0\n");
        sigaction(4,KillHAndlerSignal,null);
        printf(0,"Sending KillHAndlerSignal (22)to process\n");
        kill_self_test(4);
        sleep(1250);
        for(;;)
        {
            printf(0,"Process 1 should have been killed already!\n");
            sleep(100);
        }
        exit();
    }
    else
    {
        if((child_pid[1]=fork()) == 0)
        {
            printf(0,"Starting Loop\n");
            for(;;)
            {
                printf(0,"pid - %d child two\n",getpid());
                sleep(50);
            }
            exit();
        }
        else
        {
            if((child_pid[2]=fork()) == 0)
            {
                sleep(250);
                printf(0,"Run SigSTOP Second Child\n");
                //kill_other(child_pid[1],SIGSTOP);
                printf(0, "@@@@@1\n");
                sleep(200);
                printf(0, "@@@@@2\n");
                printf(0,"Send SIGCONT child two\n");
                //kill_other(child_pid[1],SIGCONT);
                sleep(200);
                printf(0,"Send SIGSTOP child2 AGAIN\n");
                //kill_other(child_pid[1],SIGSTOP);
                printf(0, "@@@@@1\n");
                sleep(200);
                printf(0, "@@@@@2\n");
                printf(0,"Send SIGKILL to child2\n");
                //kill_other(child_pid[1],SIGKILL);
                sleep(400);
                printf(0,"Send SIGCONT to child2\n");
                //kill_other(child_pid[1],SIGCONT);
                sleep(450);
                exit();
            }
            else
            {
                if((child_pid[3]=fork()) == 0)
                {
                    exit();
                }
            }
        }
        
    }
    //wait for children
    
    wait();
    wait();
    wait();
    wait();
    printf(0,"parent\n");
    return;

}

int main()
{
    printf(0,"--------- SIGPROCMASK TEST ---------\n");
    sigprocmask_test();
    printf(0,"--------- STOP_CONT_KILL_ABC TEST ---------\n");
    cont_stop_kill_abc_test();
    printf(0,"--------- CUSTOM USER HANDLER TEST ---------\n");
    user_handler_test();
    printf(0,"\n");
    printf(0,"--------- SIGACTION TESTS ---------\n");
    simple_sigaction_test();
    printf(0,"\n");
    printf(0,"--------- SIGNAL TESTS 1 --------- \n");
    SignalTests1();
    printf(0,"\n");
    printf(0,"---------  SIGNAL TESTS 2 --------- \n");
    SignalTests2();
    printf(0,"\n");
    printf(0,"---------  SIGNAL TESTS 3 --------- \n");
    SignalTests3();
    printf(0,"\n");
    printf(0,"Done TESTS\n");
    exit();
}