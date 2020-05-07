#include "types.h"
#include "stat.h"
#include "user.h"

// sigprocmask, sigaction
void
test_1()
{
    uint i;
    uint mask, omask;
    struct sigaction oldact;
    struct sigaction newact;

    for(i = 1; i < 10; i++) {
        mask = i;
        omask = sigprocmask(mask);
        printf(1, "need to be %d = %d\n", i-1 ,omask);
    }

    newact.sa_handler = SIG_IGN;
    newact.sigmask = 12;
    sigaction(12, &newact, &oldact);
    printf(1, "Need to be 0,0 = %d,%d\n", (uint)oldact.sa_handler, oldact.sigmask);
    sigaction(12, &oldact, &newact);
    printf(1, "Need to be 1,12 = %d,%d\n", (uint)newact.sa_handler, newact.sigmask);
}

// kernel space handlers (stop, cont, kill)
void
test_2()
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
                printf(2, "\n%d: CONT!!!\n", i);
            } 
            else
            {
                printf(2, "\n%d: STOP!!!\n", i);    
            }
            
            kill(pid, sigs[i%2]);
            sleep(150);
        }

        printf(1, "\nKILL!!!\n");
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
test_3()
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
        exit();
    }
}

int main()
{
    test_3();
    exit();
}

