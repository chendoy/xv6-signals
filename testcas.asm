
_testcas:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "x86.h"


int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 1c             	sub    $0x1c,%esp
  int a, b, c,ret;
  a = 1; b = 2; c = 3;
  12:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int i=1;
  printf(1,"a %d b %d c %d\n",a,b,c);
  19:	6a 03                	push   $0x3
  1b:	6a 02                	push   $0x2
  1d:	6a 01                	push   $0x1
  1f:	68 cc 08 00 00       	push   $0x8cc
  24:	6a 01                	push   $0x1
  26:	e8 e7 05 00 00       	call   612 <printf>

  static inline int
cas(volatile void *addr, int expected, int newval)
{
  
  int ret_val = 1;
  2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
  32:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  35:	b8 02 00 00 00       	mov    $0x2,%eax
  3a:	ba 03 00 00 00       	mov    $0x3,%edx
  3f:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
  43:	74 07                	je     4c <pass40>
  45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

0000004c <pass40>:
                "movl $0, %0\n\t"
                "pass%=:\n\t"
                : "+m"(ret_val)
                : "a"(expected), "b"(addr), "r"(newval)
                : "memory");
  return ret_val;
  4c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  4f:	83 c4 20             	add    $0x20,%esp
  52:	ff 75 f4             	pushl  -0xc(%ebp)
  55:	53                   	push   %ebx
  56:	68 dc 08 00 00       	push   $0x8dc
  5b:	6a 01                	push   $0x1
  5d:	e8 b0 05 00 00       	call   612 <printf>
  if(ret){
  62:	83 c4 10             	add    $0x10,%esp
  65:	85 db                	test   %ebx,%ebx
  67:	74 16                	je     7f <pass40+0x33>
    printf(1,"Case %d Fail\n ",i);
  69:	83 ec 04             	sub    $0x4,%esp
  6c:	6a 01                	push   $0x1
  6e:	68 ec 08 00 00       	push   $0x8ec
  73:	6a 01                	push   $0x1
  75:	e8 98 05 00 00       	call   612 <printf>
    exit();
  7a:	e8 41 04 00 00       	call   4c0 <exit>
  }
  i++;
  a = 2; b = 2; c = 3;
  7f:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  86:	83 ec 0c             	sub    $0xc,%esp
  89:	6a 03                	push   $0x3
  8b:	6a 02                	push   $0x2
  8d:	6a 02                	push   $0x2
  8f:	68 cc 08 00 00       	push   $0x8cc
  94:	6a 01                	push   $0x1
  96:	e8 77 05 00 00       	call   612 <printf>
  int ret_val = 1;
  9b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
  a2:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  a5:	b8 02 00 00 00       	mov    $0x2,%eax
  aa:	ba 03 00 00 00       	mov    $0x3,%edx
  af:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
  b3:	74 07                	je     bc <pass92>
  b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

000000bc <pass92>:
  return ret_val;
  bc:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  bf:	83 c4 20             	add    $0x20,%esp
  c2:	ff 75 f4             	pushl  -0xc(%ebp)
  c5:	53                   	push   %ebx
  c6:	68 dc 08 00 00       	push   $0x8dc
  cb:	6a 01                	push   $0x1
  cd:	e8 40 05 00 00       	call   612 <printf>
  if(!ret){
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	85 db                	test   %ebx,%ebx
  d7:	75 16                	jne    ef <pass92+0x33>
    printf(1,"Case %d Fail\n ",i);
  d9:	83 ec 04             	sub    $0x4,%esp
  dc:	6a 02                	push   $0x2
  de:	68 ec 08 00 00       	push   $0x8ec
  e3:	6a 01                	push   $0x1
  e5:	e8 28 05 00 00       	call   612 <printf>
    exit();
  ea:	e8 d1 03 00 00       	call   4c0 <exit>
  }
  i++;
  a = 3; b = 2; c = 3;
  ef:	c7 45 f4 03 00 00 00 	movl   $0x3,-0xc(%ebp)
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  f6:	83 ec 0c             	sub    $0xc,%esp
  f9:	6a 03                	push   $0x3
  fb:	6a 02                	push   $0x2
  fd:	6a 03                	push   $0x3
  ff:	68 cc 08 00 00       	push   $0x8cc
 104:	6a 01                	push   $0x1
 106:	e8 07 05 00 00       	call   612 <printf>
  int ret_val = 1;
 10b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 112:	8d 5d f4             	lea    -0xc(%ebp),%ebx
 115:	b8 02 00 00 00       	mov    $0x2,%eax
 11a:	ba 03 00 00 00       	mov    $0x3,%edx
 11f:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
 123:	74 07                	je     12c <pass144>
 125:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

0000012c <pass144>:
  return ret_val;
 12c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 12f:	83 c4 20             	add    $0x20,%esp
 132:	ff 75 f4             	pushl  -0xc(%ebp)
 135:	53                   	push   %ebx
 136:	68 dc 08 00 00       	push   $0x8dc
 13b:	6a 01                	push   $0x1
 13d:	e8 d0 04 00 00       	call   612 <printf>
  if(ret){
 142:	83 c4 10             	add    $0x10,%esp
 145:	85 db                	test   %ebx,%ebx
 147:	74 16                	je     15f <pass144+0x33>
    printf(1,"Case %d Fail\n ",i);
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	6a 03                	push   $0x3
 14e:	68 ec 08 00 00       	push   $0x8ec
 153:	6a 01                	push   $0x1
 155:	e8 b8 04 00 00       	call   612 <printf>
    exit();
 15a:	e8 61 03 00 00       	call   4c0 <exit>
  }
  i++;
  a = 3; b = 3; c = 30;
 15f:	c7 45 f4 03 00 00 00 	movl   $0x3,-0xc(%ebp)
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 166:	83 ec 0c             	sub    $0xc,%esp
 169:	6a 1e                	push   $0x1e
 16b:	6a 03                	push   $0x3
 16d:	6a 03                	push   $0x3
 16f:	68 cc 08 00 00       	push   $0x8cc
 174:	6a 01                	push   $0x1
 176:	e8 97 04 00 00       	call   612 <printf>
  int ret_val = 1;
 17b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 182:	8d 5d f4             	lea    -0xc(%ebp),%ebx
 185:	b8 03 00 00 00       	mov    $0x3,%eax
 18a:	ba 1e 00 00 00       	mov    $0x1e,%edx
 18f:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
 193:	74 07                	je     19c <pass196>
 195:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

0000019c <pass196>:
  return ret_val;
 19c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 19f:	83 c4 20             	add    $0x20,%esp
 1a2:	ff 75 f4             	pushl  -0xc(%ebp)
 1a5:	53                   	push   %ebx
 1a6:	68 dc 08 00 00       	push   $0x8dc
 1ab:	6a 01                	push   $0x1
 1ad:	e8 60 04 00 00       	call   612 <printf>
  if(!ret){
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	85 db                	test   %ebx,%ebx
 1b7:	75 16                	jne    1cf <pass196+0x33>
    printf(1,"Case %d Fail\n ",i);
 1b9:	83 ec 04             	sub    $0x4,%esp
 1bc:	6a 04                	push   $0x4
 1be:	68 ec 08 00 00       	push   $0x8ec
 1c3:	6a 01                	push   $0x1
 1c5:	e8 48 04 00 00       	call   612 <printf>
    exit();
 1ca:	e8 f1 02 00 00       	call   4c0 <exit>
  }
  i++;
  a = 2; b = 4; c = 3;
 1cf:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 1d6:	83 ec 0c             	sub    $0xc,%esp
 1d9:	6a 03                	push   $0x3
 1db:	6a 04                	push   $0x4
 1dd:	6a 02                	push   $0x2
 1df:	68 cc 08 00 00       	push   $0x8cc
 1e4:	6a 01                	push   $0x1
 1e6:	e8 27 04 00 00       	call   612 <printf>
  int ret_val = 1;
 1eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 1f2:	8d 5d f4             	lea    -0xc(%ebp),%ebx
 1f5:	b8 04 00 00 00       	mov    $0x4,%eax
 1fa:	ba 03 00 00 00       	mov    $0x3,%edx
 1ff:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
 203:	74 07                	je     20c <pass248>
 205:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

0000020c <pass248>:
  return ret_val;
 20c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 20f:	83 c4 20             	add    $0x20,%esp
 212:	ff 75 f4             	pushl  -0xc(%ebp)
 215:	53                   	push   %ebx
 216:	68 dc 08 00 00       	push   $0x8dc
 21b:	6a 01                	push   $0x1
 21d:	e8 f0 03 00 00       	call   612 <printf>
  if(ret){
 222:	83 c4 10             	add    $0x10,%esp
 225:	85 db                	test   %ebx,%ebx
 227:	74 16                	je     23f <pass248+0x33>
    printf(1,"Case i %d Fail\n ",i);
 229:	83 ec 04             	sub    $0x4,%esp
 22c:	6a 05                	push   $0x5
 22e:	68 fb 08 00 00       	push   $0x8fb
 233:	6a 01                	push   $0x1
 235:	e8 d8 03 00 00       	call   612 <printf>
    exit();
 23a:	e8 81 02 00 00       	call   4c0 <exit>
  }
  i++;
   a = 3; b = 4; c = 30;
 23f:	c7 45 f4 03 00 00 00 	movl   $0x3,-0xc(%ebp)
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 246:	83 ec 0c             	sub    $0xc,%esp
 249:	6a 1e                	push   $0x1e
 24b:	6a 04                	push   $0x4
 24d:	6a 03                	push   $0x3
 24f:	68 cc 08 00 00       	push   $0x8cc
 254:	6a 01                	push   $0x1
 256:	e8 b7 03 00 00       	call   612 <printf>
  int ret_val = 1;
 25b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 262:	8d 5d f4             	lea    -0xc(%ebp),%ebx
 265:	b8 04 00 00 00       	mov    $0x4,%eax
 26a:	ba 1e 00 00 00       	mov    $0x1e,%edx
 26f:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
 273:	74 07                	je     27c <pass300>
 275:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

0000027c <pass300>:
  return ret_val;
 27c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 27f:	83 c4 20             	add    $0x20,%esp
 282:	ff 75 f4             	pushl  -0xc(%ebp)
 285:	53                   	push   %ebx
 286:	68 dc 08 00 00       	push   $0x8dc
 28b:	6a 01                	push   $0x1
 28d:	e8 80 03 00 00       	call   612 <printf>
  if(ret){
 292:	83 c4 10             	add    $0x10,%esp
 295:	85 db                	test   %ebx,%ebx
 297:	74 16                	je     2af <pass300+0x33>
    printf(1,"Case %d Fail\n ",i);
 299:	83 ec 04             	sub    $0x4,%esp
 29c:	6a 06                	push   $0x6
 29e:	68 ec 08 00 00       	push   $0x8ec
 2a3:	6a 01                	push   $0x1
 2a5:	e8 68 03 00 00       	call   612 <printf>
    exit();
 2aa:	e8 11 02 00 00       	call   4c0 <exit>
  }
  i++;
   a = 4; b = 4; c = 30;
 2af:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 2b6:	83 ec 0c             	sub    $0xc,%esp
 2b9:	6a 1e                	push   $0x1e
 2bb:	6a 04                	push   $0x4
 2bd:	6a 04                	push   $0x4
 2bf:	68 cc 08 00 00       	push   $0x8cc
 2c4:	6a 01                	push   $0x1
 2c6:	e8 47 03 00 00       	call   612 <printf>
  int ret_val = 1;
 2cb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 2d2:	8d 5d f4             	lea    -0xc(%ebp),%ebx
 2d5:	b8 04 00 00 00       	mov    $0x4,%eax
 2da:	ba 1e 00 00 00       	mov    $0x1e,%edx
 2df:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
 2e3:	74 07                	je     2ec <pass352>
 2e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

000002ec <pass352>:
  return ret_val;
 2ec:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 2ef:	83 c4 20             	add    $0x20,%esp
 2f2:	ff 75 f4             	pushl  -0xc(%ebp)
 2f5:	53                   	push   %ebx
 2f6:	68 dc 08 00 00       	push   $0x8dc
 2fb:	6a 01                	push   $0x1
 2fd:	e8 10 03 00 00       	call   612 <printf>
  if(!ret){
 302:	83 c4 10             	add    $0x10,%esp
 305:	85 db                	test   %ebx,%ebx
 307:	75 16                	jne    31f <pass352+0x33>
    printf(1,"Case %d Fail\n ",i);
 309:	83 ec 04             	sub    $0x4,%esp
 30c:	6a 07                	push   $0x7
 30e:	68 ec 08 00 00       	push   $0x8ec
 313:	6a 01                	push   $0x1
 315:	e8 f8 02 00 00       	call   612 <printf>
    exit();
 31a:	e8 a1 01 00 00       	call   4c0 <exit>
  }
  printf(1,"All Tests passed\n");
 31f:	83 ec 08             	sub    $0x8,%esp
 322:	68 0c 09 00 00       	push   $0x90c
 327:	6a 01                	push   $0x1
 329:	e8 e4 02 00 00       	call   612 <printf>
  exit();
 32e:	e8 8d 01 00 00       	call   4c0 <exit>

00000333 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 333:	55                   	push   %ebp
 334:	89 e5                	mov    %esp,%ebp
 336:	53                   	push   %ebx
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 33d:	89 c2                	mov    %eax,%edx
 33f:	0f b6 19             	movzbl (%ecx),%ebx
 342:	88 1a                	mov    %bl,(%edx)
 344:	8d 52 01             	lea    0x1(%edx),%edx
 347:	8d 49 01             	lea    0x1(%ecx),%ecx
 34a:	84 db                	test   %bl,%bl
 34c:	75 f1                	jne    33f <strcpy+0xc>
    ;
  return os;
}
 34e:	5b                   	pop    %ebx
 34f:	5d                   	pop    %ebp
 350:	c3                   	ret    

00000351 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
 354:	8b 4d 08             	mov    0x8(%ebp),%ecx
 357:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 35a:	eb 06                	jmp    362 <strcmp+0x11>
    p++, q++;
 35c:	83 c1 01             	add    $0x1,%ecx
 35f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 362:	0f b6 01             	movzbl (%ecx),%eax
 365:	84 c0                	test   %al,%al
 367:	74 04                	je     36d <strcmp+0x1c>
 369:	3a 02                	cmp    (%edx),%al
 36b:	74 ef                	je     35c <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 36d:	0f b6 c0             	movzbl %al,%eax
 370:	0f b6 12             	movzbl (%edx),%edx
 373:	29 d0                	sub    %edx,%eax
}
 375:	5d                   	pop    %ebp
 376:	c3                   	ret    

00000377 <strlen>:

uint
strlen(const char *s)
{
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
 37a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 37d:	ba 00 00 00 00       	mov    $0x0,%edx
 382:	eb 03                	jmp    387 <strlen+0x10>
 384:	83 c2 01             	add    $0x1,%edx
 387:	89 d0                	mov    %edx,%eax
 389:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 38d:	75 f5                	jne    384 <strlen+0xd>
    ;
  return n;
}
 38f:	5d                   	pop    %ebp
 390:	c3                   	ret    

00000391 <memset>:

void*
memset(void *dst, int c, uint n)
{
 391:	55                   	push   %ebp
 392:	89 e5                	mov    %esp,%ebp
 394:	57                   	push   %edi
 395:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("cld; rep stosb" :
 398:	89 d7                	mov    %edx,%edi
 39a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39d:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a0:	fc                   	cld    
 3a1:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3a3:	89 d0                	mov    %edx,%eax
 3a5:	5f                   	pop    %edi
 3a6:	5d                   	pop    %ebp
 3a7:	c3                   	ret    

000003a8 <strchr>:

char*
strchr(const char *s, char c)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3b2:	0f b6 10             	movzbl (%eax),%edx
 3b5:	84 d2                	test   %dl,%dl
 3b7:	74 09                	je     3c2 <strchr+0x1a>
    if(*s == c)
 3b9:	38 ca                	cmp    %cl,%dl
 3bb:	74 0a                	je     3c7 <strchr+0x1f>
  for(; *s; s++)
 3bd:	83 c0 01             	add    $0x1,%eax
 3c0:	eb f0                	jmp    3b2 <strchr+0xa>
      return (char*)s;
  return 0;
 3c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3c7:	5d                   	pop    %ebp
 3c8:	c3                   	ret    

000003c9 <gets>:

char*
gets(char *buf, int max)
{
 3c9:	55                   	push   %ebp
 3ca:	89 e5                	mov    %esp,%ebp
 3cc:	57                   	push   %edi
 3cd:	56                   	push   %esi
 3ce:	53                   	push   %ebx
 3cf:	83 ec 1c             	sub    $0x1c,%esp
 3d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d5:	bb 00 00 00 00       	mov    $0x0,%ebx
 3da:	8d 73 01             	lea    0x1(%ebx),%esi
 3dd:	3b 75 0c             	cmp    0xc(%ebp),%esi
 3e0:	7d 2e                	jge    410 <gets+0x47>
    cc = read(0, &c, 1);
 3e2:	83 ec 04             	sub    $0x4,%esp
 3e5:	6a 01                	push   $0x1
 3e7:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3ea:	50                   	push   %eax
 3eb:	6a 00                	push   $0x0
 3ed:	e8 e6 00 00 00       	call   4d8 <read>
    if(cc < 1)
 3f2:	83 c4 10             	add    $0x10,%esp
 3f5:	85 c0                	test   %eax,%eax
 3f7:	7e 17                	jle    410 <gets+0x47>
      break;
    buf[i++] = c;
 3f9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3fd:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 400:	3c 0a                	cmp    $0xa,%al
 402:	0f 94 c2             	sete   %dl
 405:	3c 0d                	cmp    $0xd,%al
 407:	0f 94 c0             	sete   %al
    buf[i++] = c;
 40a:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 40c:	08 c2                	or     %al,%dl
 40e:	74 ca                	je     3da <gets+0x11>
      break;
  }
  buf[i] = '\0';
 410:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 414:	89 f8                	mov    %edi,%eax
 416:	8d 65 f4             	lea    -0xc(%ebp),%esp
 419:	5b                   	pop    %ebx
 41a:	5e                   	pop    %esi
 41b:	5f                   	pop    %edi
 41c:	5d                   	pop    %ebp
 41d:	c3                   	ret    

0000041e <stat>:

int
stat(const char *n, struct stat *st)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	56                   	push   %esi
 422:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 423:	83 ec 08             	sub    $0x8,%esp
 426:	6a 00                	push   $0x0
 428:	ff 75 08             	pushl  0x8(%ebp)
 42b:	e8 d0 00 00 00       	call   500 <open>
  if(fd < 0)
 430:	83 c4 10             	add    $0x10,%esp
 433:	85 c0                	test   %eax,%eax
 435:	78 24                	js     45b <stat+0x3d>
 437:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 439:	83 ec 08             	sub    $0x8,%esp
 43c:	ff 75 0c             	pushl  0xc(%ebp)
 43f:	50                   	push   %eax
 440:	e8 d3 00 00 00       	call   518 <fstat>
 445:	89 c6                	mov    %eax,%esi
  close(fd);
 447:	89 1c 24             	mov    %ebx,(%esp)
 44a:	e8 99 00 00 00       	call   4e8 <close>
  return r;
 44f:	83 c4 10             	add    $0x10,%esp
}
 452:	89 f0                	mov    %esi,%eax
 454:	8d 65 f8             	lea    -0x8(%ebp),%esp
 457:	5b                   	pop    %ebx
 458:	5e                   	pop    %esi
 459:	5d                   	pop    %ebp
 45a:	c3                   	ret    
    return -1;
 45b:	be ff ff ff ff       	mov    $0xffffffff,%esi
 460:	eb f0                	jmp    452 <stat+0x34>

00000462 <atoi>:

int
atoi(const char *s)
{
 462:	55                   	push   %ebp
 463:	89 e5                	mov    %esp,%ebp
 465:	53                   	push   %ebx
 466:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 469:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 46e:	eb 10                	jmp    480 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 470:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
 473:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
 476:	83 c1 01             	add    $0x1,%ecx
 479:	0f be d2             	movsbl %dl,%edx
 47c:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  while('0' <= *s && *s <= '9')
 480:	0f b6 11             	movzbl (%ecx),%edx
 483:	8d 5a d0             	lea    -0x30(%edx),%ebx
 486:	80 fb 09             	cmp    $0x9,%bl
 489:	76 e5                	jbe    470 <atoi+0xe>
  return n;
}
 48b:	5b                   	pop    %ebx
 48c:	5d                   	pop    %ebp
 48d:	c3                   	ret    

0000048e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 48e:	55                   	push   %ebp
 48f:	89 e5                	mov    %esp,%ebp
 491:	56                   	push   %esi
 492:	53                   	push   %ebx
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 499:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 49c:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 49e:	eb 0d                	jmp    4ad <memmove+0x1f>
    *dst++ = *src++;
 4a0:	0f b6 13             	movzbl (%ebx),%edx
 4a3:	88 11                	mov    %dl,(%ecx)
 4a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
 4a8:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 4ab:	89 f2                	mov    %esi,%edx
 4ad:	8d 72 ff             	lea    -0x1(%edx),%esi
 4b0:	85 d2                	test   %edx,%edx
 4b2:	7f ec                	jg     4a0 <memmove+0x12>
  return vdst;
}
 4b4:	5b                   	pop    %ebx
 4b5:	5e                   	pop    %esi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    

000004b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4b8:	b8 01 00 00 00       	mov    $0x1,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <exit>:
SYSCALL(exit)
 4c0:	b8 02 00 00 00       	mov    $0x2,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <wait>:
SYSCALL(wait)
 4c8:	b8 03 00 00 00       	mov    $0x3,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <pipe>:
SYSCALL(pipe)
 4d0:	b8 04 00 00 00       	mov    $0x4,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <read>:
SYSCALL(read)
 4d8:	b8 05 00 00 00       	mov    $0x5,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <write>:
SYSCALL(write)
 4e0:	b8 10 00 00 00       	mov    $0x10,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <close>:
SYSCALL(close)
 4e8:	b8 15 00 00 00       	mov    $0x15,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <kill>:
SYSCALL(kill)
 4f0:	b8 06 00 00 00       	mov    $0x6,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <exec>:
SYSCALL(exec)
 4f8:	b8 07 00 00 00       	mov    $0x7,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <open>:
SYSCALL(open)
 500:	b8 0f 00 00 00       	mov    $0xf,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <mknod>:
SYSCALL(mknod)
 508:	b8 11 00 00 00       	mov    $0x11,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <unlink>:
SYSCALL(unlink)
 510:	b8 12 00 00 00       	mov    $0x12,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <fstat>:
SYSCALL(fstat)
 518:	b8 08 00 00 00       	mov    $0x8,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <link>:
SYSCALL(link)
 520:	b8 13 00 00 00       	mov    $0x13,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <mkdir>:
SYSCALL(mkdir)
 528:	b8 14 00 00 00       	mov    $0x14,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <chdir>:
SYSCALL(chdir)
 530:	b8 09 00 00 00       	mov    $0x9,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <dup>:
SYSCALL(dup)
 538:	b8 0a 00 00 00       	mov    $0xa,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <getpid>:
SYSCALL(getpid)
 540:	b8 0b 00 00 00       	mov    $0xb,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <sbrk>:
SYSCALL(sbrk)
 548:	b8 0c 00 00 00       	mov    $0xc,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <sleep>:
SYSCALL(sleep)
 550:	b8 0d 00 00 00       	mov    $0xd,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <uptime>:
SYSCALL(uptime)
 558:	b8 0e 00 00 00       	mov    $0xe,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <sigprocmask>:
SYSCALL(sigprocmask)
 560:	b8 16 00 00 00       	mov    $0x16,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <sigaction>:
SYSCALL(sigaction)
 568:	b8 17 00 00 00       	mov    $0x17,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <sigret>:
SYSCALL(sigret)
 570:	b8 18 00 00 00       	mov    $0x18,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	83 ec 1c             	sub    $0x1c,%esp
 57e:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 581:	6a 01                	push   $0x1
 583:	8d 55 f4             	lea    -0xc(%ebp),%edx
 586:	52                   	push   %edx
 587:	50                   	push   %eax
 588:	e8 53 ff ff ff       	call   4e0 <write>
}
 58d:	83 c4 10             	add    $0x10,%esp
 590:	c9                   	leave  
 591:	c3                   	ret    

00000592 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 592:	55                   	push   %ebp
 593:	89 e5                	mov    %esp,%ebp
 595:	57                   	push   %edi
 596:	56                   	push   %esi
 597:	53                   	push   %ebx
 598:	83 ec 2c             	sub    $0x2c,%esp
 59b:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 59d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 5a1:	0f 95 c3             	setne  %bl
 5a4:	89 d0                	mov    %edx,%eax
 5a6:	c1 e8 1f             	shr    $0x1f,%eax
 5a9:	84 c3                	test   %al,%bl
 5ab:	74 10                	je     5bd <printint+0x2b>
    neg = 1;
    x = -xx;
 5ad:	f7 da                	neg    %edx
    neg = 1;
 5af:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5b6:	be 00 00 00 00       	mov    $0x0,%esi
 5bb:	eb 0b                	jmp    5c8 <printint+0x36>
  neg = 0;
 5bd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 5c4:	eb f0                	jmp    5b6 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 5c6:	89 c6                	mov    %eax,%esi
 5c8:	89 d0                	mov    %edx,%eax
 5ca:	ba 00 00 00 00       	mov    $0x0,%edx
 5cf:	f7 f1                	div    %ecx
 5d1:	89 c3                	mov    %eax,%ebx
 5d3:	8d 46 01             	lea    0x1(%esi),%eax
 5d6:	0f b6 92 28 09 00 00 	movzbl 0x928(%edx),%edx
 5dd:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 5e1:	89 da                	mov    %ebx,%edx
 5e3:	85 db                	test   %ebx,%ebx
 5e5:	75 df                	jne    5c6 <printint+0x34>
 5e7:	89 c3                	mov    %eax,%ebx
  if(neg)
 5e9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 5ed:	74 16                	je     605 <printint+0x73>
    buf[i++] = '-';
 5ef:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 5f4:	8d 5e 02             	lea    0x2(%esi),%ebx
 5f7:	eb 0c                	jmp    605 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 5f9:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 5fe:	89 f8                	mov    %edi,%eax
 600:	e8 73 ff ff ff       	call   578 <putc>
  while(--i >= 0)
 605:	83 eb 01             	sub    $0x1,%ebx
 608:	79 ef                	jns    5f9 <printint+0x67>
}
 60a:	83 c4 2c             	add    $0x2c,%esp
 60d:	5b                   	pop    %ebx
 60e:	5e                   	pop    %esi
 60f:	5f                   	pop    %edi
 610:	5d                   	pop    %ebp
 611:	c3                   	ret    

00000612 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 612:	55                   	push   %ebp
 613:	89 e5                	mov    %esp,%ebp
 615:	57                   	push   %edi
 616:	56                   	push   %esi
 617:	53                   	push   %ebx
 618:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 61b:	8d 45 10             	lea    0x10(%ebp),%eax
 61e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 621:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 626:	bb 00 00 00 00       	mov    $0x0,%ebx
 62b:	eb 14                	jmp    641 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 62d:	89 fa                	mov    %edi,%edx
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	e8 41 ff ff ff       	call   578 <putc>
 637:	eb 05                	jmp    63e <printf+0x2c>
      }
    } else if(state == '%'){
 639:	83 fe 25             	cmp    $0x25,%esi
 63c:	74 25                	je     663 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 63e:	83 c3 01             	add    $0x1,%ebx
 641:	8b 45 0c             	mov    0xc(%ebp),%eax
 644:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 648:	84 c0                	test   %al,%al
 64a:	0f 84 23 01 00 00    	je     773 <printf+0x161>
    c = fmt[i] & 0xff;
 650:	0f be f8             	movsbl %al,%edi
 653:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 656:	85 f6                	test   %esi,%esi
 658:	75 df                	jne    639 <printf+0x27>
      if(c == '%'){
 65a:	83 f8 25             	cmp    $0x25,%eax
 65d:	75 ce                	jne    62d <printf+0x1b>
        state = '%';
 65f:	89 c6                	mov    %eax,%esi
 661:	eb db                	jmp    63e <printf+0x2c>
      if(c == 'd'){
 663:	83 f8 64             	cmp    $0x64,%eax
 666:	74 49                	je     6b1 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 668:	83 f8 78             	cmp    $0x78,%eax
 66b:	0f 94 c1             	sete   %cl
 66e:	83 f8 70             	cmp    $0x70,%eax
 671:	0f 94 c2             	sete   %dl
 674:	08 d1                	or     %dl,%cl
 676:	75 63                	jne    6db <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 678:	83 f8 73             	cmp    $0x73,%eax
 67b:	0f 84 84 00 00 00    	je     705 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 681:	83 f8 63             	cmp    $0x63,%eax
 684:	0f 84 b7 00 00 00    	je     741 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 68a:	83 f8 25             	cmp    $0x25,%eax
 68d:	0f 84 cc 00 00 00    	je     75f <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 693:	ba 25 00 00 00       	mov    $0x25,%edx
 698:	8b 45 08             	mov    0x8(%ebp),%eax
 69b:	e8 d8 fe ff ff       	call   578 <putc>
        putc(fd, c);
 6a0:	89 fa                	mov    %edi,%edx
 6a2:	8b 45 08             	mov    0x8(%ebp),%eax
 6a5:	e8 ce fe ff ff       	call   578 <putc>
      }
      state = 0;
 6aa:	be 00 00 00 00       	mov    $0x0,%esi
 6af:	eb 8d                	jmp    63e <printf+0x2c>
        printint(fd, *ap, 10, 1);
 6b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6b4:	8b 17                	mov    (%edi),%edx
 6b6:	83 ec 0c             	sub    $0xc,%esp
 6b9:	6a 01                	push   $0x1
 6bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6c0:	8b 45 08             	mov    0x8(%ebp),%eax
 6c3:	e8 ca fe ff ff       	call   592 <printint>
        ap++;
 6c8:	83 c7 04             	add    $0x4,%edi
 6cb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6ce:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6d1:	be 00 00 00 00       	mov    $0x0,%esi
 6d6:	e9 63 ff ff ff       	jmp    63e <printf+0x2c>
        printint(fd, *ap, 16, 0);
 6db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6de:	8b 17                	mov    (%edi),%edx
 6e0:	83 ec 0c             	sub    $0xc,%esp
 6e3:	6a 00                	push   $0x0
 6e5:	b9 10 00 00 00       	mov    $0x10,%ecx
 6ea:	8b 45 08             	mov    0x8(%ebp),%eax
 6ed:	e8 a0 fe ff ff       	call   592 <printint>
        ap++;
 6f2:	83 c7 04             	add    $0x4,%edi
 6f5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 6f8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6fb:	be 00 00 00 00       	mov    $0x0,%esi
 700:	e9 39 ff ff ff       	jmp    63e <printf+0x2c>
        s = (char*)*ap;
 705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 708:	8b 30                	mov    (%eax),%esi
        ap++;
 70a:	83 c0 04             	add    $0x4,%eax
 70d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 710:	85 f6                	test   %esi,%esi
 712:	75 28                	jne    73c <printf+0x12a>
          s = "(null)";
 714:	be 1e 09 00 00       	mov    $0x91e,%esi
 719:	8b 7d 08             	mov    0x8(%ebp),%edi
 71c:	eb 0d                	jmp    72b <printf+0x119>
          putc(fd, *s);
 71e:	0f be d2             	movsbl %dl,%edx
 721:	89 f8                	mov    %edi,%eax
 723:	e8 50 fe ff ff       	call   578 <putc>
          s++;
 728:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 72b:	0f b6 16             	movzbl (%esi),%edx
 72e:	84 d2                	test   %dl,%dl
 730:	75 ec                	jne    71e <printf+0x10c>
      state = 0;
 732:	be 00 00 00 00       	mov    $0x0,%esi
 737:	e9 02 ff ff ff       	jmp    63e <printf+0x2c>
 73c:	8b 7d 08             	mov    0x8(%ebp),%edi
 73f:	eb ea                	jmp    72b <printf+0x119>
        putc(fd, *ap);
 741:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 744:	0f be 17             	movsbl (%edi),%edx
 747:	8b 45 08             	mov    0x8(%ebp),%eax
 74a:	e8 29 fe ff ff       	call   578 <putc>
        ap++;
 74f:	83 c7 04             	add    $0x4,%edi
 752:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 755:	be 00 00 00 00       	mov    $0x0,%esi
 75a:	e9 df fe ff ff       	jmp    63e <printf+0x2c>
        putc(fd, c);
 75f:	89 fa                	mov    %edi,%edx
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	e8 0f fe ff ff       	call   578 <putc>
      state = 0;
 769:	be 00 00 00 00       	mov    $0x0,%esi
 76e:	e9 cb fe ff ff       	jmp    63e <printf+0x2c>
    }
  }
}
 773:	8d 65 f4             	lea    -0xc(%ebp),%esp
 776:	5b                   	pop    %ebx
 777:	5e                   	pop    %esi
 778:	5f                   	pop    %edi
 779:	5d                   	pop    %ebp
 77a:	c3                   	ret    

0000077b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 77b:	55                   	push   %ebp
 77c:	89 e5                	mov    %esp,%ebp
 77e:	57                   	push   %edi
 77f:	56                   	push   %esi
 780:	53                   	push   %ebx
 781:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 784:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 787:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 78c:	eb 02                	jmp    790 <free+0x15>
 78e:	89 d0                	mov    %edx,%eax
 790:	39 c8                	cmp    %ecx,%eax
 792:	73 04                	jae    798 <free+0x1d>
 794:	39 08                	cmp    %ecx,(%eax)
 796:	77 12                	ja     7aa <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	8b 10                	mov    (%eax),%edx
 79a:	39 c2                	cmp    %eax,%edx
 79c:	77 f0                	ja     78e <free+0x13>
 79e:	39 c8                	cmp    %ecx,%eax
 7a0:	72 08                	jb     7aa <free+0x2f>
 7a2:	39 ca                	cmp    %ecx,%edx
 7a4:	77 04                	ja     7aa <free+0x2f>
 7a6:	89 d0                	mov    %edx,%eax
 7a8:	eb e6                	jmp    790 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7aa:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7ad:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7b0:	8b 10                	mov    (%eax),%edx
 7b2:	39 d7                	cmp    %edx,%edi
 7b4:	74 19                	je     7cf <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7b6:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7b9:	8b 50 04             	mov    0x4(%eax),%edx
 7bc:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7bf:	39 ce                	cmp    %ecx,%esi
 7c1:	74 1b                	je     7de <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7c3:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7c5:	a3 c4 0b 00 00       	mov    %eax,0xbc4
}
 7ca:	5b                   	pop    %ebx
 7cb:	5e                   	pop    %esi
 7cc:	5f                   	pop    %edi
 7cd:	5d                   	pop    %ebp
 7ce:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 7cf:	03 72 04             	add    0x4(%edx),%esi
 7d2:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d5:	8b 10                	mov    (%eax),%edx
 7d7:	8b 12                	mov    (%edx),%edx
 7d9:	89 53 f8             	mov    %edx,-0x8(%ebx)
 7dc:	eb db                	jmp    7b9 <free+0x3e>
    p->s.size += bp->s.size;
 7de:	03 53 fc             	add    -0x4(%ebx),%edx
 7e1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e4:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7e7:	89 10                	mov    %edx,(%eax)
 7e9:	eb da                	jmp    7c5 <free+0x4a>

000007eb <morecore>:

static Header*
morecore(uint nu)
{
 7eb:	55                   	push   %ebp
 7ec:	89 e5                	mov    %esp,%ebp
 7ee:	53                   	push   %ebx
 7ef:	83 ec 04             	sub    $0x4,%esp
 7f2:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 7f4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 7f9:	77 05                	ja     800 <morecore+0x15>
    nu = 4096;
 7fb:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 800:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 807:	83 ec 0c             	sub    $0xc,%esp
 80a:	50                   	push   %eax
 80b:	e8 38 fd ff ff       	call   548 <sbrk>
  if(p == (char*)-1)
 810:	83 c4 10             	add    $0x10,%esp
 813:	83 f8 ff             	cmp    $0xffffffff,%eax
 816:	74 1c                	je     834 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 818:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 81b:	83 c0 08             	add    $0x8,%eax
 81e:	83 ec 0c             	sub    $0xc,%esp
 821:	50                   	push   %eax
 822:	e8 54 ff ff ff       	call   77b <free>
  return freep;
 827:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 82c:	83 c4 10             	add    $0x10,%esp
}
 82f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 832:	c9                   	leave  
 833:	c3                   	ret    
    return 0;
 834:	b8 00 00 00 00       	mov    $0x0,%eax
 839:	eb f4                	jmp    82f <morecore+0x44>

0000083b <malloc>:

void*
malloc(uint nbytes)
{
 83b:	55                   	push   %ebp
 83c:	89 e5                	mov    %esp,%ebp
 83e:	53                   	push   %ebx
 83f:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 842:	8b 45 08             	mov    0x8(%ebp),%eax
 845:	8d 58 07             	lea    0x7(%eax),%ebx
 848:	c1 eb 03             	shr    $0x3,%ebx
 84b:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 84e:	8b 0d c4 0b 00 00    	mov    0xbc4,%ecx
 854:	85 c9                	test   %ecx,%ecx
 856:	74 04                	je     85c <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	8b 01                	mov    (%ecx),%eax
 85a:	eb 4d                	jmp    8a9 <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 85c:	c7 05 c4 0b 00 00 c8 	movl   $0xbc8,0xbc4
 863:	0b 00 00 
 866:	c7 05 c8 0b 00 00 c8 	movl   $0xbc8,0xbc8
 86d:	0b 00 00 
    base.s.size = 0;
 870:	c7 05 cc 0b 00 00 00 	movl   $0x0,0xbcc
 877:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 87a:	b9 c8 0b 00 00       	mov    $0xbc8,%ecx
 87f:	eb d7                	jmp    858 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 881:	39 da                	cmp    %ebx,%edx
 883:	74 1a                	je     89f <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 885:	29 da                	sub    %ebx,%edx
 887:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 88d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 890:	89 0d c4 0b 00 00    	mov    %ecx,0xbc4
      return (void*)(p + 1);
 896:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 899:	83 c4 04             	add    $0x4,%esp
 89c:	5b                   	pop    %ebx
 89d:	5d                   	pop    %ebp
 89e:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 89f:	8b 10                	mov    (%eax),%edx
 8a1:	89 11                	mov    %edx,(%ecx)
 8a3:	eb eb                	jmp    890 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a5:	89 c1                	mov    %eax,%ecx
 8a7:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 8a9:	8b 50 04             	mov    0x4(%eax),%edx
 8ac:	39 da                	cmp    %ebx,%edx
 8ae:	73 d1                	jae    881 <malloc+0x46>
    if(p == freep)
 8b0:	39 05 c4 0b 00 00    	cmp    %eax,0xbc4
 8b6:	75 ed                	jne    8a5 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 8b8:	89 d8                	mov    %ebx,%eax
 8ba:	e8 2c ff ff ff       	call   7eb <morecore>
 8bf:	85 c0                	test   %eax,%eax
 8c1:	75 e2                	jne    8a5 <malloc+0x6a>
        return 0;
 8c3:	b8 00 00 00 00       	mov    $0x0,%eax
 8c8:	eb cf                	jmp    899 <malloc+0x5e>
