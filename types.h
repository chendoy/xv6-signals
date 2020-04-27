typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;

#define SIG_DFL 0
#define SIG_IGN 1
#define SIGKILL 9
#define SIGSTOP 17
#define SIGCONT 19
#define null 0
#define SIG_HANDLERS_NUM 32
#define SIG_MAX 31
#define SIG_MIN 0

struct sigaction {
    void (*sa_handler) (int);
    uint sigmask;
};