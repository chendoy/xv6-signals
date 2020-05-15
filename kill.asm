
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 07                	jle    25 <main+0x25>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	eb 30                	jmp    55 <main+0x55>
    printf(2, "usage: kill pid...\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 f8 05 00 00       	push   $0x5f8
  2d:	6a 02                	push   $0x2
  2f:	e8 09 03 00 00       	call   33d <printf>
    exit();
  34:	e8 b2 01 00 00       	call   1eb <exit>
    kill(atoi(argv[i]), SIGKILL);
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	ff 34 9f             	pushl  (%edi,%ebx,4)
  3f:	e8 49 01 00 00       	call   18d <atoi>
  44:	83 c4 08             	add    $0x8,%esp
  47:	6a 09                	push   $0x9
  49:	50                   	push   %eax
  4a:	e8 cc 01 00 00       	call   21b <kill>
  for(i=1; i<argc; i++)
  4f:	83 c3 01             	add    $0x1,%ebx
  52:	83 c4 10             	add    $0x10,%esp
  55:	39 f3                	cmp    %esi,%ebx
  57:	7c e0                	jl     39 <main+0x39>
  exit();
  59:	e8 8d 01 00 00       	call   1eb <exit>

0000005e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5e:	55                   	push   %ebp
  5f:	89 e5                	mov    %esp,%ebp
  61:	53                   	push   %ebx
  62:	8b 45 08             	mov    0x8(%ebp),%eax
  65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	89 c2                	mov    %eax,%edx
  6a:	0f b6 19             	movzbl (%ecx),%ebx
  6d:	88 1a                	mov    %bl,(%edx)
  6f:	8d 52 01             	lea    0x1(%edx),%edx
  72:	8d 49 01             	lea    0x1(%ecx),%ecx
  75:	84 db                	test   %bl,%bl
  77:	75 f1                	jne    6a <strcpy+0xc>
    ;
  return os;
}
  79:	5b                   	pop    %ebx
  7a:	5d                   	pop    %ebp
  7b:	c3                   	ret    

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  82:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  85:	eb 06                	jmp    8d <strcmp+0x11>
    p++, q++;
  87:	83 c1 01             	add    $0x1,%ecx
  8a:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  8d:	0f b6 01             	movzbl (%ecx),%eax
  90:	84 c0                	test   %al,%al
  92:	74 04                	je     98 <strcmp+0x1c>
  94:	3a 02                	cmp    (%edx),%al
  96:	74 ef                	je     87 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  98:	0f b6 c0             	movzbl %al,%eax
  9b:	0f b6 12             	movzbl (%edx),%edx
  9e:	29 d0                	sub    %edx,%eax
}
  a0:	5d                   	pop    %ebp
  a1:	c3                   	ret    

000000a2 <strlen>:

uint
strlen(const char *s)
{
  a2:	55                   	push   %ebp
  a3:	89 e5                	mov    %esp,%ebp
  a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a8:	ba 00 00 00 00       	mov    $0x0,%edx
  ad:	eb 03                	jmp    b2 <strlen+0x10>
  af:	83 c2 01             	add    $0x1,%edx
  b2:	89 d0                	mov    %edx,%eax
  b4:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  b8:	75 f5                	jne    af <strlen+0xd>
    ;
  return n;
}
  ba:	5d                   	pop    %ebp
  bb:	c3                   	ret    

000000bc <memset>:

void*
memset(void *dst, int c, uint n)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	57                   	push   %edi
  c0:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c3:	89 d7                	mov    %edx,%edi
  c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  cb:	fc                   	cld    
  cc:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  ce:	89 d0                	mov    %edx,%eax
  d0:	5f                   	pop    %edi
  d1:	5d                   	pop    %ebp
  d2:	c3                   	ret    

000000d3 <strchr>:

char*
strchr(const char *s, char c)
{
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  dd:	0f b6 10             	movzbl (%eax),%edx
  e0:	84 d2                	test   %dl,%dl
  e2:	74 09                	je     ed <strchr+0x1a>
    if(*s == c)
  e4:	38 ca                	cmp    %cl,%dl
  e6:	74 0a                	je     f2 <strchr+0x1f>
  for(; *s; s++)
  e8:	83 c0 01             	add    $0x1,%eax
  eb:	eb f0                	jmp    dd <strchr+0xa>
      return (char*)s;
  return 0;
  ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  f2:	5d                   	pop    %ebp
  f3:	c3                   	ret    

000000f4 <gets>:

char*
gets(char *buf, int max)
{
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	57                   	push   %edi
  f8:	56                   	push   %esi
  f9:	53                   	push   %ebx
  fa:	83 ec 1c             	sub    $0x1c,%esp
  fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 100:	bb 00 00 00 00       	mov    $0x0,%ebx
 105:	8d 73 01             	lea    0x1(%ebx),%esi
 108:	3b 75 0c             	cmp    0xc(%ebp),%esi
 10b:	7d 2e                	jge    13b <gets+0x47>
    cc = read(0, &c, 1);
 10d:	83 ec 04             	sub    $0x4,%esp
 110:	6a 01                	push   $0x1
 112:	8d 45 e7             	lea    -0x19(%ebp),%eax
 115:	50                   	push   %eax
 116:	6a 00                	push   $0x0
 118:	e8 e6 00 00 00       	call   203 <read>
    if(cc < 1)
 11d:	83 c4 10             	add    $0x10,%esp
 120:	85 c0                	test   %eax,%eax
 122:	7e 17                	jle    13b <gets+0x47>
      break;
    buf[i++] = c;
 124:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 128:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 12b:	3c 0a                	cmp    $0xa,%al
 12d:	0f 94 c2             	sete   %dl
 130:	3c 0d                	cmp    $0xd,%al
 132:	0f 94 c0             	sete   %al
    buf[i++] = c;
 135:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 137:	08 c2                	or     %al,%dl
 139:	74 ca                	je     105 <gets+0x11>
      break;
  }
  buf[i] = '\0';
 13b:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 13f:	89 f8                	mov    %edi,%eax
 141:	8d 65 f4             	lea    -0xc(%ebp),%esp
 144:	5b                   	pop    %ebx
 145:	5e                   	pop    %esi
 146:	5f                   	pop    %edi
 147:	5d                   	pop    %ebp
 148:	c3                   	ret    

00000149 <stat>:

int
stat(const char *n, struct stat *st)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	56                   	push   %esi
 14d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 14e:	83 ec 08             	sub    $0x8,%esp
 151:	6a 00                	push   $0x0
 153:	ff 75 08             	pushl  0x8(%ebp)
 156:	e8 d0 00 00 00       	call   22b <open>
  if(fd < 0)
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	85 c0                	test   %eax,%eax
 160:	78 24                	js     186 <stat+0x3d>
 162:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 164:	83 ec 08             	sub    $0x8,%esp
 167:	ff 75 0c             	pushl  0xc(%ebp)
 16a:	50                   	push   %eax
 16b:	e8 d3 00 00 00       	call   243 <fstat>
 170:	89 c6                	mov    %eax,%esi
  close(fd);
 172:	89 1c 24             	mov    %ebx,(%esp)
 175:	e8 99 00 00 00       	call   213 <close>
  return r;
 17a:	83 c4 10             	add    $0x10,%esp
}
 17d:	89 f0                	mov    %esi,%eax
 17f:	8d 65 f8             	lea    -0x8(%ebp),%esp
 182:	5b                   	pop    %ebx
 183:	5e                   	pop    %esi
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    
    return -1;
 186:	be ff ff ff ff       	mov    $0xffffffff,%esi
 18b:	eb f0                	jmp    17d <stat+0x34>

0000018d <atoi>:

int
atoi(const char *s)
{
 18d:	55                   	push   %ebp
 18e:	89 e5                	mov    %esp,%ebp
 190:	53                   	push   %ebx
 191:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 194:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 199:	eb 10                	jmp    1ab <atoi+0x1e>
    n = n*10 + *s++ - '0';
 19b:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
 19e:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
 1a1:	83 c1 01             	add    $0x1,%ecx
 1a4:	0f be d2             	movsbl %dl,%edx
 1a7:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  while('0' <= *s && *s <= '9')
 1ab:	0f b6 11             	movzbl (%ecx),%edx
 1ae:	8d 5a d0             	lea    -0x30(%edx),%ebx
 1b1:	80 fb 09             	cmp    $0x9,%bl
 1b4:	76 e5                	jbe    19b <atoi+0xe>
  return n;
}
 1b6:	5b                   	pop    %ebx
 1b7:	5d                   	pop    %ebp
 1b8:	c3                   	ret    

000001b9 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1b9:	55                   	push   %ebp
 1ba:	89 e5                	mov    %esp,%ebp
 1bc:	56                   	push   %esi
 1bd:	53                   	push   %ebx
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1c4:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 1c7:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 1c9:	eb 0d                	jmp    1d8 <memmove+0x1f>
    *dst++ = *src++;
 1cb:	0f b6 13             	movzbl (%ebx),%edx
 1ce:	88 11                	mov    %dl,(%ecx)
 1d0:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1d3:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 1d6:	89 f2                	mov    %esi,%edx
 1d8:	8d 72 ff             	lea    -0x1(%edx),%esi
 1db:	85 d2                	test   %edx,%edx
 1dd:	7f ec                	jg     1cb <memmove+0x12>
  return vdst;
}
 1df:	5b                   	pop    %ebx
 1e0:	5e                   	pop    %esi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1e3:	b8 01 00 00 00       	mov    $0x1,%eax
 1e8:	cd 40                	int    $0x40
 1ea:	c3                   	ret    

000001eb <exit>:
SYSCALL(exit)
 1eb:	b8 02 00 00 00       	mov    $0x2,%eax
 1f0:	cd 40                	int    $0x40
 1f2:	c3                   	ret    

000001f3 <wait>:
SYSCALL(wait)
 1f3:	b8 03 00 00 00       	mov    $0x3,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	ret    

000001fb <pipe>:
SYSCALL(pipe)
 1fb:	b8 04 00 00 00       	mov    $0x4,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	ret    

00000203 <read>:
SYSCALL(read)
 203:	b8 05 00 00 00       	mov    $0x5,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	ret    

0000020b <write>:
SYSCALL(write)
 20b:	b8 10 00 00 00       	mov    $0x10,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	ret    

00000213 <close>:
SYSCALL(close)
 213:	b8 15 00 00 00       	mov    $0x15,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret    

0000021b <kill>:
SYSCALL(kill)
 21b:	b8 06 00 00 00       	mov    $0x6,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <exec>:
SYSCALL(exec)
 223:	b8 07 00 00 00       	mov    $0x7,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <open>:
SYSCALL(open)
 22b:	b8 0f 00 00 00       	mov    $0xf,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <mknod>:
SYSCALL(mknod)
 233:	b8 11 00 00 00       	mov    $0x11,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <unlink>:
SYSCALL(unlink)
 23b:	b8 12 00 00 00       	mov    $0x12,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <fstat>:
SYSCALL(fstat)
 243:	b8 08 00 00 00       	mov    $0x8,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <link>:
SYSCALL(link)
 24b:	b8 13 00 00 00       	mov    $0x13,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <mkdir>:
SYSCALL(mkdir)
 253:	b8 14 00 00 00       	mov    $0x14,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <chdir>:
SYSCALL(chdir)
 25b:	b8 09 00 00 00       	mov    $0x9,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <dup>:
SYSCALL(dup)
 263:	b8 0a 00 00 00       	mov    $0xa,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <getpid>:
SYSCALL(getpid)
 26b:	b8 0b 00 00 00       	mov    $0xb,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <sbrk>:
SYSCALL(sbrk)
 273:	b8 0c 00 00 00       	mov    $0xc,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <sleep>:
SYSCALL(sleep)
 27b:	b8 0d 00 00 00       	mov    $0xd,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <uptime>:
SYSCALL(uptime)
 283:	b8 0e 00 00 00       	mov    $0xe,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <sigprocmask>:
SYSCALL(sigprocmask)
 28b:	b8 16 00 00 00       	mov    $0x16,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <sigaction>:
SYSCALL(sigaction)
 293:	b8 17 00 00 00       	mov    $0x17,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <sigret>:
SYSCALL(sigret)
 29b:	b8 18 00 00 00       	mov    $0x18,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 1c             	sub    $0x1c,%esp
 2a9:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2ac:	6a 01                	push   $0x1
 2ae:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2b1:	52                   	push   %edx
 2b2:	50                   	push   %eax
 2b3:	e8 53 ff ff ff       	call   20b <write>
}
 2b8:	83 c4 10             	add    $0x10,%esp
 2bb:	c9                   	leave  
 2bc:	c3                   	ret    

000002bd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	57                   	push   %edi
 2c1:	56                   	push   %esi
 2c2:	53                   	push   %ebx
 2c3:	83 ec 2c             	sub    $0x2c,%esp
 2c6:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2cc:	0f 95 c3             	setne  %bl
 2cf:	89 d0                	mov    %edx,%eax
 2d1:	c1 e8 1f             	shr    $0x1f,%eax
 2d4:	84 c3                	test   %al,%bl
 2d6:	74 10                	je     2e8 <printint+0x2b>
    neg = 1;
    x = -xx;
 2d8:	f7 da                	neg    %edx
    neg = 1;
 2da:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2e1:	be 00 00 00 00       	mov    $0x0,%esi
 2e6:	eb 0b                	jmp    2f3 <printint+0x36>
  neg = 0;
 2e8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 2ef:	eb f0                	jmp    2e1 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 2f1:	89 c6                	mov    %eax,%esi
 2f3:	89 d0                	mov    %edx,%eax
 2f5:	ba 00 00 00 00       	mov    $0x0,%edx
 2fa:	f7 f1                	div    %ecx
 2fc:	89 c3                	mov    %eax,%ebx
 2fe:	8d 46 01             	lea    0x1(%esi),%eax
 301:	0f b6 92 14 06 00 00 	movzbl 0x614(%edx),%edx
 308:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 30c:	89 da                	mov    %ebx,%edx
 30e:	85 db                	test   %ebx,%ebx
 310:	75 df                	jne    2f1 <printint+0x34>
 312:	89 c3                	mov    %eax,%ebx
  if(neg)
 314:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 318:	74 16                	je     330 <printint+0x73>
    buf[i++] = '-';
 31a:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 31f:	8d 5e 02             	lea    0x2(%esi),%ebx
 322:	eb 0c                	jmp    330 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 324:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 329:	89 f8                	mov    %edi,%eax
 32b:	e8 73 ff ff ff       	call   2a3 <putc>
  while(--i >= 0)
 330:	83 eb 01             	sub    $0x1,%ebx
 333:	79 ef                	jns    324 <printint+0x67>
}
 335:	83 c4 2c             	add    $0x2c,%esp
 338:	5b                   	pop    %ebx
 339:	5e                   	pop    %esi
 33a:	5f                   	pop    %edi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    

0000033d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	57                   	push   %edi
 341:	56                   	push   %esi
 342:	53                   	push   %ebx
 343:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 346:	8d 45 10             	lea    0x10(%ebp),%eax
 349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 34c:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 351:	bb 00 00 00 00       	mov    $0x0,%ebx
 356:	eb 14                	jmp    36c <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 358:	89 fa                	mov    %edi,%edx
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	e8 41 ff ff ff       	call   2a3 <putc>
 362:	eb 05                	jmp    369 <printf+0x2c>
      }
    } else if(state == '%'){
 364:	83 fe 25             	cmp    $0x25,%esi
 367:	74 25                	je     38e <printf+0x51>
  for(i = 0; fmt[i]; i++){
 369:	83 c3 01             	add    $0x1,%ebx
 36c:	8b 45 0c             	mov    0xc(%ebp),%eax
 36f:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 373:	84 c0                	test   %al,%al
 375:	0f 84 23 01 00 00    	je     49e <printf+0x161>
    c = fmt[i] & 0xff;
 37b:	0f be f8             	movsbl %al,%edi
 37e:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 381:	85 f6                	test   %esi,%esi
 383:	75 df                	jne    364 <printf+0x27>
      if(c == '%'){
 385:	83 f8 25             	cmp    $0x25,%eax
 388:	75 ce                	jne    358 <printf+0x1b>
        state = '%';
 38a:	89 c6                	mov    %eax,%esi
 38c:	eb db                	jmp    369 <printf+0x2c>
      if(c == 'd'){
 38e:	83 f8 64             	cmp    $0x64,%eax
 391:	74 49                	je     3dc <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 393:	83 f8 78             	cmp    $0x78,%eax
 396:	0f 94 c1             	sete   %cl
 399:	83 f8 70             	cmp    $0x70,%eax
 39c:	0f 94 c2             	sete   %dl
 39f:	08 d1                	or     %dl,%cl
 3a1:	75 63                	jne    406 <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3a3:	83 f8 73             	cmp    $0x73,%eax
 3a6:	0f 84 84 00 00 00    	je     430 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3ac:	83 f8 63             	cmp    $0x63,%eax
 3af:	0f 84 b7 00 00 00    	je     46c <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3b5:	83 f8 25             	cmp    $0x25,%eax
 3b8:	0f 84 cc 00 00 00    	je     48a <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3be:	ba 25 00 00 00       	mov    $0x25,%edx
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	e8 d8 fe ff ff       	call   2a3 <putc>
        putc(fd, c);
 3cb:	89 fa                	mov    %edi,%edx
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
 3d0:	e8 ce fe ff ff       	call   2a3 <putc>
      }
      state = 0;
 3d5:	be 00 00 00 00       	mov    $0x0,%esi
 3da:	eb 8d                	jmp    369 <printf+0x2c>
        printint(fd, *ap, 10, 1);
 3dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3df:	8b 17                	mov    (%edi),%edx
 3e1:	83 ec 0c             	sub    $0xc,%esp
 3e4:	6a 01                	push   $0x1
 3e6:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3eb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ee:	e8 ca fe ff ff       	call   2bd <printint>
        ap++;
 3f3:	83 c7 04             	add    $0x4,%edi
 3f6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3fc:	be 00 00 00 00       	mov    $0x0,%esi
 401:	e9 63 ff ff ff       	jmp    369 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 406:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 409:	8b 17                	mov    (%edi),%edx
 40b:	83 ec 0c             	sub    $0xc,%esp
 40e:	6a 00                	push   $0x0
 410:	b9 10 00 00 00       	mov    $0x10,%ecx
 415:	8b 45 08             	mov    0x8(%ebp),%eax
 418:	e8 a0 fe ff ff       	call   2bd <printint>
        ap++;
 41d:	83 c7 04             	add    $0x4,%edi
 420:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 423:	83 c4 10             	add    $0x10,%esp
      state = 0;
 426:	be 00 00 00 00       	mov    $0x0,%esi
 42b:	e9 39 ff ff ff       	jmp    369 <printf+0x2c>
        s = (char*)*ap;
 430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 433:	8b 30                	mov    (%eax),%esi
        ap++;
 435:	83 c0 04             	add    $0x4,%eax
 438:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 43b:	85 f6                	test   %esi,%esi
 43d:	75 28                	jne    467 <printf+0x12a>
          s = "(null)";
 43f:	be 0c 06 00 00       	mov    $0x60c,%esi
 444:	8b 7d 08             	mov    0x8(%ebp),%edi
 447:	eb 0d                	jmp    456 <printf+0x119>
          putc(fd, *s);
 449:	0f be d2             	movsbl %dl,%edx
 44c:	89 f8                	mov    %edi,%eax
 44e:	e8 50 fe ff ff       	call   2a3 <putc>
          s++;
 453:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 456:	0f b6 16             	movzbl (%esi),%edx
 459:	84 d2                	test   %dl,%dl
 45b:	75 ec                	jne    449 <printf+0x10c>
      state = 0;
 45d:	be 00 00 00 00       	mov    $0x0,%esi
 462:	e9 02 ff ff ff       	jmp    369 <printf+0x2c>
 467:	8b 7d 08             	mov    0x8(%ebp),%edi
 46a:	eb ea                	jmp    456 <printf+0x119>
        putc(fd, *ap);
 46c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 46f:	0f be 17             	movsbl (%edi),%edx
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	e8 29 fe ff ff       	call   2a3 <putc>
        ap++;
 47a:	83 c7 04             	add    $0x4,%edi
 47d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 480:	be 00 00 00 00       	mov    $0x0,%esi
 485:	e9 df fe ff ff       	jmp    369 <printf+0x2c>
        putc(fd, c);
 48a:	89 fa                	mov    %edi,%edx
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	e8 0f fe ff ff       	call   2a3 <putc>
      state = 0;
 494:	be 00 00 00 00       	mov    $0x0,%esi
 499:	e9 cb fe ff ff       	jmp    369 <printf+0x2c>
    }
  }
}
 49e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a1:	5b                   	pop    %ebx
 4a2:	5e                   	pop    %esi
 4a3:	5f                   	pop    %edi
 4a4:	5d                   	pop    %ebp
 4a5:	c3                   	ret    

000004a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4a6:	55                   	push   %ebp
 4a7:	89 e5                	mov    %esp,%ebp
 4a9:	57                   	push   %edi
 4aa:	56                   	push   %esi
 4ab:	53                   	push   %ebx
 4ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4af:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4b2:	a1 b8 08 00 00       	mov    0x8b8,%eax
 4b7:	eb 02                	jmp    4bb <free+0x15>
 4b9:	89 d0                	mov    %edx,%eax
 4bb:	39 c8                	cmp    %ecx,%eax
 4bd:	73 04                	jae    4c3 <free+0x1d>
 4bf:	39 08                	cmp    %ecx,(%eax)
 4c1:	77 12                	ja     4d5 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4c3:	8b 10                	mov    (%eax),%edx
 4c5:	39 c2                	cmp    %eax,%edx
 4c7:	77 f0                	ja     4b9 <free+0x13>
 4c9:	39 c8                	cmp    %ecx,%eax
 4cb:	72 08                	jb     4d5 <free+0x2f>
 4cd:	39 ca                	cmp    %ecx,%edx
 4cf:	77 04                	ja     4d5 <free+0x2f>
 4d1:	89 d0                	mov    %edx,%eax
 4d3:	eb e6                	jmp    4bb <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4d5:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4d8:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4db:	8b 10                	mov    (%eax),%edx
 4dd:	39 d7                	cmp    %edx,%edi
 4df:	74 19                	je     4fa <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4e1:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4e4:	8b 50 04             	mov    0x4(%eax),%edx
 4e7:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4ea:	39 ce                	cmp    %ecx,%esi
 4ec:	74 1b                	je     509 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4ee:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4f0:	a3 b8 08 00 00       	mov    %eax,0x8b8
}
 4f5:	5b                   	pop    %ebx
 4f6:	5e                   	pop    %esi
 4f7:	5f                   	pop    %edi
 4f8:	5d                   	pop    %ebp
 4f9:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4fa:	03 72 04             	add    0x4(%edx),%esi
 4fd:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 500:	8b 10                	mov    (%eax),%edx
 502:	8b 12                	mov    (%edx),%edx
 504:	89 53 f8             	mov    %edx,-0x8(%ebx)
 507:	eb db                	jmp    4e4 <free+0x3e>
    p->s.size += bp->s.size;
 509:	03 53 fc             	add    -0x4(%ebx),%edx
 50c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 50f:	8b 53 f8             	mov    -0x8(%ebx),%edx
 512:	89 10                	mov    %edx,(%eax)
 514:	eb da                	jmp    4f0 <free+0x4a>

00000516 <morecore>:

static Header*
morecore(uint nu)
{
 516:	55                   	push   %ebp
 517:	89 e5                	mov    %esp,%ebp
 519:	53                   	push   %ebx
 51a:	83 ec 04             	sub    $0x4,%esp
 51d:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 51f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 524:	77 05                	ja     52b <morecore+0x15>
    nu = 4096;
 526:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 52b:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 532:	83 ec 0c             	sub    $0xc,%esp
 535:	50                   	push   %eax
 536:	e8 38 fd ff ff       	call   273 <sbrk>
  if(p == (char*)-1)
 53b:	83 c4 10             	add    $0x10,%esp
 53e:	83 f8 ff             	cmp    $0xffffffff,%eax
 541:	74 1c                	je     55f <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 543:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 546:	83 c0 08             	add    $0x8,%eax
 549:	83 ec 0c             	sub    $0xc,%esp
 54c:	50                   	push   %eax
 54d:	e8 54 ff ff ff       	call   4a6 <free>
  return freep;
 552:	a1 b8 08 00 00       	mov    0x8b8,%eax
 557:	83 c4 10             	add    $0x10,%esp
}
 55a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 55d:	c9                   	leave  
 55e:	c3                   	ret    
    return 0;
 55f:	b8 00 00 00 00       	mov    $0x0,%eax
 564:	eb f4                	jmp    55a <morecore+0x44>

00000566 <malloc>:

void*
malloc(uint nbytes)
{
 566:	55                   	push   %ebp
 567:	89 e5                	mov    %esp,%ebp
 569:	53                   	push   %ebx
 56a:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 56d:	8b 45 08             	mov    0x8(%ebp),%eax
 570:	8d 58 07             	lea    0x7(%eax),%ebx
 573:	c1 eb 03             	shr    $0x3,%ebx
 576:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 579:	8b 0d b8 08 00 00    	mov    0x8b8,%ecx
 57f:	85 c9                	test   %ecx,%ecx
 581:	74 04                	je     587 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 583:	8b 01                	mov    (%ecx),%eax
 585:	eb 4d                	jmp    5d4 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 587:	c7 05 b8 08 00 00 bc 	movl   $0x8bc,0x8b8
 58e:	08 00 00 
 591:	c7 05 bc 08 00 00 bc 	movl   $0x8bc,0x8bc
 598:	08 00 00 
    base.s.size = 0;
 59b:	c7 05 c0 08 00 00 00 	movl   $0x0,0x8c0
 5a2:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5a5:	b9 bc 08 00 00       	mov    $0x8bc,%ecx
 5aa:	eb d7                	jmp    583 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5ac:	39 da                	cmp    %ebx,%edx
 5ae:	74 1a                	je     5ca <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5b0:	29 da                	sub    %ebx,%edx
 5b2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5b5:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5b8:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5bb:	89 0d b8 08 00 00    	mov    %ecx,0x8b8
      return (void*)(p + 1);
 5c1:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5c4:	83 c4 04             	add    $0x4,%esp
 5c7:	5b                   	pop    %ebx
 5c8:	5d                   	pop    %ebp
 5c9:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5ca:	8b 10                	mov    (%eax),%edx
 5cc:	89 11                	mov    %edx,(%ecx)
 5ce:	eb eb                	jmp    5bb <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5d0:	89 c1                	mov    %eax,%ecx
 5d2:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5d4:	8b 50 04             	mov    0x4(%eax),%edx
 5d7:	39 da                	cmp    %ebx,%edx
 5d9:	73 d1                	jae    5ac <malloc+0x46>
    if(p == freep)
 5db:	39 05 b8 08 00 00    	cmp    %eax,0x8b8
 5e1:	75 ed                	jne    5d0 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 5e3:	89 d8                	mov    %ebx,%eax
 5e5:	e8 2c ff ff ff       	call   516 <morecore>
 5ea:	85 c0                	test   %eax,%eax
 5ec:	75 e2                	jne    5d0 <malloc+0x6a>
        return 0;
 5ee:	b8 00 00 00 00       	mov    $0x0,%eax
 5f3:	eb cf                	jmp    5c4 <malloc+0x5e>
