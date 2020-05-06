typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;
typedef uint pde_t;

// handlers

#define SIG_DFL (void (*)()) 0
#define SIG_IGN (void (*)()) 1

// sig nums

#define SIGKILL 9
#define SIGSTOP 17
#define SIGCONT 19
#define SIGTEST 20

// some useful constants

#define null 0
#define SIG_HANDLERS_NUM 32
#define SIG_MAX 31
#define SIG_MIN 0
#define UINT_SIZE 4

struct sigaction {
    void (*sa_handler) (int);
    uint sigmask;
};