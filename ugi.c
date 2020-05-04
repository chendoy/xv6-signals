#include "types.h"
#include "stat.h"
#include "user.h"


void
test_22()
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

void
test_23()
{
    int pid;
    int sigs[] = {SIGSTOP, SIGCONT};

    if((pid = fork()) == 0) {
        while (1) {
            printf(1, "hi");
            sleep(10);
        }
        
    }
    else
    {  

        for (int i = 0; i < 20; i++)
        {
            if (i % 2)
            {
                printf(1, "\n%d: CONT!!!\n", i);
            } 
            else
            {
                printf(1, "\n%d: STOP!!!\n", i);    
            }
            
            kill(pid, sigs[i%2]);
            sleep(30);
        }

        printf(1, "\nKILL!!!\n");
        kill(pid, SIGKILL);
        wait();
    }

}

void
test_24() {

int pid;
if((pid = fork()) == 0) {
    while (1) {
        printf(1, "i'm child\n");
    }
}
else
{
        sleep(100);
        printf(1, "\nSTOP!!!\n");
        kill(pid, SIGSTOP);
        sleep(100);
        printf(1, "\nCONT!!!\n");
        kill(pid, SIGCONT);
        sleep(100);
        printf(1, "\nKILL!!!\n");
        kill(pid, SIGKILL);
        wait();
}
}
    

int main(int argc, char const *argv[])
{
    test_23();
    exit();
}

