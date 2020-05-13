
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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  //   : "memory"); // clobbered list
  
  // return output;

  int ret_val = 1;
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
  11:	8d 5d e0             	lea    -0x20(%ebp),%ebx
  14:	be 03 00 00 00       	mov    $0x3,%esi
  19:	83 ec 34             	sub    $0x34,%esp
  int a, b, c,ret;
  a = 1; b = 2; c = 3;
  1c:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  int i=1;
  printf(1,"a %d b %d c %d\n",a,b,c);
  23:	6a 03                	push   $0x3
  25:	6a 02                	push   $0x2
  27:	6a 01                	push   $0x1
  29:	68 18 0a 00 00       	push   $0xa18
  2e:	6a 01                	push   $0x1
  30:	e8 8b 06 00 00       	call   6c0 <printf>
  int ret_val = 1;
  35:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
  3c:	b8 02 00 00 00       	mov    $0x2,%eax
  41:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  45:	74 07                	je     4e <pass48>
  47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

0000004e <pass48>:
                "movl $0, %0\n\t"
                "pass%=:\n\t"
                : "+m"(ret_val)
                : "a"(expected), "b"(addr), "r"(newval)
                : "memory");
  return ret_val;
  4e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  51:	83 c4 20             	add    $0x20,%esp
  54:	ff 75 e0             	pushl  -0x20(%ebp)
  57:	57                   	push   %edi
  58:	68 28 0a 00 00       	push   $0xa28
  5d:	6a 01                	push   $0x1
  5f:	e8 5c 06 00 00       	call   6c0 <printf>
  if(ret){
  64:	83 c4 10             	add    $0x10,%esp
  67:	85 ff                	test   %edi,%edi
  69:	74 14                	je     7f <pass48+0x31>
    printf(1,"Case %d Fail\n ",i);
  6b:	50                   	push   %eax
  6c:	6a 01                	push   $0x1
  6e:	68 38 0a 00 00       	push   $0xa38
  73:	6a 01                	push   $0x1
  75:	e8 46 06 00 00       	call   6c0 <printf>
    exit();
  7a:	e8 e3 04 00 00       	call   562 <exit>
  }
  i++;
  a = 2; b = 2; c = 3;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  7f:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 2; c = 3;
  82:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
  89:	6a 03                	push   $0x3
  8b:	6a 02                	push   $0x2
  8d:	6a 02                	push   $0x2
  8f:	68 18 0a 00 00       	push   $0xa18
  94:	6a 01                	push   $0x1
  96:	e8 25 06 00 00       	call   6c0 <printf>
  int ret_val = 1;
  9b:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
  a2:	b8 02 00 00 00       	mov    $0x2,%eax
  a7:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
  ab:	74 07                	je     b4 <pass97>
  ad:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

000000b4 <pass97>:
  return ret_val;
  b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  b7:	83 c4 20             	add    $0x20,%esp
  ba:	ff 75 e0             	pushl  -0x20(%ebp)
  bd:	50                   	push   %eax
  be:	68 28 0a 00 00       	push   $0xa28
  c3:	6a 01                	push   $0x1
  c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  c8:	e8 f3 05 00 00       	call   6c0 <printf>
  if(!ret){
  cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  d0:	83 c4 10             	add    $0x10,%esp
  d3:	85 c0                	test   %eax,%eax
  d5:	75 14                	jne    eb <pass97+0x37>
    printf(1,"Case %d Fail\n ",i);
  d7:	50                   	push   %eax
  d8:	6a 02                	push   $0x2
  da:	68 38 0a 00 00       	push   $0xa38
  df:	6a 01                	push   $0x1
  e1:	e8 da 05 00 00       	call   6c0 <printf>
    exit();
  e6:	e8 77 04 00 00       	call   562 <exit>
  }
  i++;
  a = 3; b = 2; c = 3;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  eb:	83 ec 0c             	sub    $0xc,%esp
  a = 3; b = 2; c = 3;
  ee:	c7 45 e0 03 00 00 00 	movl   $0x3,-0x20(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
  f5:	6a 03                	push   $0x3
  f7:	6a 02                	push   $0x2
  f9:	6a 03                	push   $0x3
  fb:	68 18 0a 00 00       	push   $0xa18
 100:	6a 01                	push   $0x1
 102:	e8 b9 05 00 00       	call   6c0 <printf>
  int ret_val = 1;
 107:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 10e:	b8 02 00 00 00       	mov    $0x2,%eax
 113:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
 117:	74 07                	je     120 <pass148>
 119:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

00000120 <pass148>:
  return ret_val;
 120:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 123:	83 c4 20             	add    $0x20,%esp
 126:	ff 75 e0             	pushl  -0x20(%ebp)
 129:	57                   	push   %edi
 12a:	68 28 0a 00 00       	push   $0xa28
 12f:	6a 01                	push   $0x1
 131:	e8 8a 05 00 00       	call   6c0 <printf>
  if(ret){
 136:	83 c4 10             	add    $0x10,%esp
 139:	85 ff                	test   %edi,%edi
 13b:	75 6e                	jne    1ab <pass190+0x37>
    exit();
  }
  i++;
  a = 3; b = 3; c = 30;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 13d:	83 ec 0c             	sub    $0xc,%esp
  a = 3; b = 3; c = 30;
 140:	c7 45 e0 03 00 00 00 	movl   $0x3,-0x20(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 147:	bf 1e 00 00 00       	mov    $0x1e,%edi
  printf(1,"a %d b %d c %d\n",a,b,c);
 14c:	6a 1e                	push   $0x1e
 14e:	6a 03                	push   $0x3
 150:	6a 03                	push   $0x3
 152:	68 18 0a 00 00       	push   $0xa18
 157:	6a 01                	push   $0x1
 159:	e8 62 05 00 00       	call   6c0 <printf>
  int ret_val = 1;
 15e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 165:	89 f0                	mov    %esi,%eax
 167:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
 16b:	74 07                	je     174 <pass190>
 16d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

00000174 <pass190>:
  return ret_val;
 174:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 177:	83 c4 20             	add    $0x20,%esp
 17a:	ff 75 e0             	pushl  -0x20(%ebp)
 17d:	50                   	push   %eax
 17e:	68 28 0a 00 00       	push   $0xa28
 183:	6a 01                	push   $0x1
 185:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 188:	e8 33 05 00 00       	call   6c0 <printf>
  if(!ret){
 18d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 190:	83 c4 10             	add    $0x10,%esp
 193:	85 c0                	test   %eax,%eax
 195:	75 28                	jne    1bf <pass190+0x4b>
    printf(1,"Case %d Fail\n ",i);
 197:	56                   	push   %esi
 198:	6a 04                	push   $0x4
 19a:	68 38 0a 00 00       	push   $0xa38
 19f:	6a 01                	push   $0x1
 1a1:	e8 1a 05 00 00       	call   6c0 <printf>
    exit();
 1a6:	e8 b7 03 00 00       	call   562 <exit>
    printf(1,"Case %d Fail\n ",i);
 1ab:	57                   	push   %edi
 1ac:	6a 03                	push   $0x3
 1ae:	68 38 0a 00 00       	push   $0xa38
 1b3:	6a 01                	push   $0x1
 1b5:	e8 06 05 00 00       	call   6c0 <printf>
    exit();
 1ba:	e8 a3 03 00 00       	call   562 <exit>
  }
  i++;
  a = 2; b = 4; c = 3;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 1bf:	83 ec 0c             	sub    $0xc,%esp
  a = 2; b = 4; c = 3;
 1c2:	c7 45 e0 02 00 00 00 	movl   $0x2,-0x20(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 1c9:	6a 03                	push   $0x3
 1cb:	6a 04                	push   $0x4
 1cd:	6a 02                	push   $0x2
 1cf:	68 18 0a 00 00       	push   $0xa18
 1d4:	6a 01                	push   $0x1
 1d6:	e8 e5 04 00 00       	call   6c0 <printf>
  int ret_val = 1;
 1db:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 1e2:	b8 04 00 00 00       	mov    $0x4,%eax
 1e7:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
 1eb:	74 07                	je     1f4 <pass260>
 1ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

000001f4 <pass260>:
  return ret_val;
 1f4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 1f7:	83 c4 20             	add    $0x20,%esp
 1fa:	ff 75 e0             	pushl  -0x20(%ebp)
 1fd:	56                   	push   %esi
 1fe:	68 28 0a 00 00       	push   $0xa28
 203:	6a 01                	push   $0x1
 205:	e8 b6 04 00 00       	call   6c0 <printf>
  if(ret){
 20a:	83 c4 10             	add    $0x10,%esp
 20d:	85 f6                	test   %esi,%esi
 20f:	75 66                	jne    277 <pass297+0x31>
    exit();
  }
  i++;
   a = 3; b = 4; c = 30;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 211:	83 ec 0c             	sub    $0xc,%esp
   a = 3; b = 4; c = 30;
 214:	c7 45 e0 03 00 00 00 	movl   $0x3,-0x20(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 21b:	6a 1e                	push   $0x1e
 21d:	6a 04                	push   $0x4
 21f:	6a 03                	push   $0x3
 221:	68 18 0a 00 00       	push   $0xa18
 226:	6a 01                	push   $0x1
 228:	e8 93 04 00 00       	call   6c0 <printf>
  int ret_val = 1;
 22d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 234:	b8 04 00 00 00       	mov    $0x4,%eax
 239:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
 23d:	74 07                	je     246 <pass297>
 23f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

00000246 <pass297>:
  return ret_val;
 246:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 249:	83 c4 20             	add    $0x20,%esp
 24c:	ff 75 e0             	pushl  -0x20(%ebp)
 24f:	56                   	push   %esi
 250:	68 28 0a 00 00       	push   $0xa28
 255:	6a 01                	push   $0x1
 257:	e8 64 04 00 00       	call   6c0 <printf>
  if(ret){
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	85 f6                	test   %esi,%esi
 261:	74 28                	je     28b <pass297+0x45>
    printf(1,"Case %d Fail\n ",i);
 263:	51                   	push   %ecx
 264:	6a 06                	push   $0x6
 266:	68 38 0a 00 00       	push   $0xa38
 26b:	6a 01                	push   $0x1
 26d:	e8 4e 04 00 00       	call   6c0 <printf>
    exit();
 272:	e8 eb 02 00 00       	call   562 <exit>
    printf(1,"Case i %d Fail\n ",i);
 277:	53                   	push   %ebx
 278:	6a 05                	push   $0x5
 27a:	68 47 0a 00 00       	push   $0xa47
 27f:	6a 01                	push   $0x1
 281:	e8 3a 04 00 00       	call   6c0 <printf>
    exit();
 286:	e8 d7 02 00 00       	call   562 <exit>
  }
  i++;
   a = 4; b = 4; c = 30;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
 28b:	83 ec 0c             	sub    $0xc,%esp
   a = 4; b = 4; c = 30;
 28e:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
  printf(1,"a %d b %d c %d\n",a,b,c);
 295:	6a 1e                	push   $0x1e
 297:	6a 04                	push   $0x4
 299:	6a 04                	push   $0x4
 29b:	68 18 0a 00 00       	push   $0xa18
 2a0:	6a 01                	push   $0x1
 2a2:	e8 19 04 00 00       	call   6c0 <printf>
  int ret_val = 1;
 2a7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
 2ae:	b8 04 00 00 00       	mov    $0x4,%eax
 2b3:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
 2b7:	74 07                	je     2c0 <pass362>
 2b9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

000002c0 <pass362>:
  return ret_val;
 2c0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
 2c3:	83 c4 20             	add    $0x20,%esp
 2c6:	ff 75 e0             	pushl  -0x20(%ebp)
 2c9:	53                   	push   %ebx
 2ca:	68 28 0a 00 00       	push   $0xa28
 2cf:	6a 01                	push   $0x1
 2d1:	e8 ea 03 00 00       	call   6c0 <printf>
  if(!ret){
 2d6:	83 c4 10             	add    $0x10,%esp
 2d9:	85 db                	test   %ebx,%ebx
 2db:	75 14                	jne    2f1 <pass362+0x31>
    printf(1,"Case %d Fail\n ",i);
 2dd:	52                   	push   %edx
 2de:	6a 07                	push   $0x7
 2e0:	68 38 0a 00 00       	push   $0xa38
 2e5:	6a 01                	push   $0x1
 2e7:	e8 d4 03 00 00       	call   6c0 <printf>
    exit();
 2ec:	e8 71 02 00 00       	call   562 <exit>
  }
  printf(1,"All Tests passed\n");
 2f1:	50                   	push   %eax
 2f2:	50                   	push   %eax
 2f3:	68 58 0a 00 00       	push   $0xa58
 2f8:	6a 01                	push   $0x1
 2fa:	e8 c1 03 00 00       	call   6c0 <printf>
  exit();
 2ff:	e8 5e 02 00 00       	call   562 <exit>
 304:	66 90                	xchg   %ax,%ax
 306:	66 90                	xchg   %ax,%ax
 308:	66 90                	xchg   %ax,%ax
 30a:	66 90                	xchg   %ax,%ax
 30c:	66 90                	xchg   %ax,%ax
 30e:	66 90                	xchg   %ax,%ax

00000310 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	53                   	push   %ebx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 31a:	89 c2                	mov    %eax,%edx
 31c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 320:	83 c1 01             	add    $0x1,%ecx
 323:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 327:	83 c2 01             	add    $0x1,%edx
 32a:	84 db                	test   %bl,%bl
 32c:	88 5a ff             	mov    %bl,-0x1(%edx)
 32f:	75 ef                	jne    320 <strcpy+0x10>
    ;
  return os;
}
 331:	5b                   	pop    %ebx
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    
 334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 33a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000340 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	53                   	push   %ebx
 344:	8b 55 08             	mov    0x8(%ebp),%edx
 347:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 34a:	0f b6 02             	movzbl (%edx),%eax
 34d:	0f b6 19             	movzbl (%ecx),%ebx
 350:	84 c0                	test   %al,%al
 352:	75 1c                	jne    370 <strcmp+0x30>
 354:	eb 2a                	jmp    380 <strcmp+0x40>
 356:	8d 76 00             	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 360:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 363:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 366:	83 c1 01             	add    $0x1,%ecx
 369:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 36c:	84 c0                	test   %al,%al
 36e:	74 10                	je     380 <strcmp+0x40>
 370:	38 d8                	cmp    %bl,%al
 372:	74 ec                	je     360 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 374:	29 d8                	sub    %ebx,%eax
}
 376:	5b                   	pop    %ebx
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 380:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 382:	29 d8                	sub    %ebx,%eax
}
 384:	5b                   	pop    %ebx
 385:	5d                   	pop    %ebp
 386:	c3                   	ret    
 387:	89 f6                	mov    %esi,%esi
 389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000390 <strlen>:

uint
strlen(const char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 396:	80 39 00             	cmpb   $0x0,(%ecx)
 399:	74 15                	je     3b0 <strlen+0x20>
 39b:	31 d2                	xor    %edx,%edx
 39d:	8d 76 00             	lea    0x0(%esi),%esi
 3a0:	83 c2 01             	add    $0x1,%edx
 3a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 3a7:	89 d0                	mov    %edx,%eax
 3a9:	75 f5                	jne    3a0 <strlen+0x10>
    ;
  return n;
}
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 3b0:	31 c0                	xor    %eax,%eax
}
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret    
 3b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
 3c4:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("cld; rep stosb" :
 3c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cd:	89 d7                	mov    %edx,%edi
 3cf:	fc                   	cld    
 3d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3d2:	89 d0                	mov    %edx,%eax
 3d4:	5f                   	pop    %edi
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret    
 3d7:	89 f6                	mov    %esi,%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003e0 <strchr>:

char*
strchr(const char *s, char c)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	53                   	push   %ebx
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 3ea:	0f b6 10             	movzbl (%eax),%edx
 3ed:	84 d2                	test   %dl,%dl
 3ef:	74 1d                	je     40e <strchr+0x2e>
    if(*s == c)
 3f1:	38 d3                	cmp    %dl,%bl
 3f3:	89 d9                	mov    %ebx,%ecx
 3f5:	75 0d                	jne    404 <strchr+0x24>
 3f7:	eb 17                	jmp    410 <strchr+0x30>
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 400:	38 ca                	cmp    %cl,%dl
 402:	74 0c                	je     410 <strchr+0x30>
  for(; *s; s++)
 404:	83 c0 01             	add    $0x1,%eax
 407:	0f b6 10             	movzbl (%eax),%edx
 40a:	84 d2                	test   %dl,%dl
 40c:	75 f2                	jne    400 <strchr+0x20>
      return (char*)s;
  return 0;
 40e:	31 c0                	xor    %eax,%eax
}
 410:	5b                   	pop    %ebx
 411:	5d                   	pop    %ebp
 412:	c3                   	ret    
 413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <gets>:

char*
gets(char *buf, int max)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	57                   	push   %edi
 424:	56                   	push   %esi
 425:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 426:	31 f6                	xor    %esi,%esi
 428:	89 f3                	mov    %esi,%ebx
{
 42a:	83 ec 1c             	sub    $0x1c,%esp
 42d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 430:	eb 2f                	jmp    461 <gets+0x41>
 432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 438:	8d 45 e7             	lea    -0x19(%ebp),%eax
 43b:	83 ec 04             	sub    $0x4,%esp
 43e:	6a 01                	push   $0x1
 440:	50                   	push   %eax
 441:	6a 00                	push   $0x0
 443:	e8 32 01 00 00       	call   57a <read>
    if(cc < 1)
 448:	83 c4 10             	add    $0x10,%esp
 44b:	85 c0                	test   %eax,%eax
 44d:	7e 1c                	jle    46b <gets+0x4b>
      break;
    buf[i++] = c;
 44f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 453:	83 c7 01             	add    $0x1,%edi
 456:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 459:	3c 0a                	cmp    $0xa,%al
 45b:	74 23                	je     480 <gets+0x60>
 45d:	3c 0d                	cmp    $0xd,%al
 45f:	74 1f                	je     480 <gets+0x60>
  for(i=0; i+1 < max; ){
 461:	83 c3 01             	add    $0x1,%ebx
 464:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 467:	89 fe                	mov    %edi,%esi
 469:	7c cd                	jl     438 <gets+0x18>
 46b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 470:	c6 03 00             	movb   $0x0,(%ebx)
}
 473:	8d 65 f4             	lea    -0xc(%ebp),%esp
 476:	5b                   	pop    %ebx
 477:	5e                   	pop    %esi
 478:	5f                   	pop    %edi
 479:	5d                   	pop    %ebp
 47a:	c3                   	ret    
 47b:	90                   	nop
 47c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 480:	8b 75 08             	mov    0x8(%ebp),%esi
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	01 de                	add    %ebx,%esi
 488:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 48a:	c6 03 00             	movb   $0x0,(%ebx)
}
 48d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 490:	5b                   	pop    %ebx
 491:	5e                   	pop    %esi
 492:	5f                   	pop    %edi
 493:	5d                   	pop    %ebp
 494:	c3                   	ret    
 495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	56                   	push   %esi
 4a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4a5:	83 ec 08             	sub    $0x8,%esp
 4a8:	6a 00                	push   $0x0
 4aa:	ff 75 08             	pushl  0x8(%ebp)
 4ad:	e8 f0 00 00 00       	call   5a2 <open>
  if(fd < 0)
 4b2:	83 c4 10             	add    $0x10,%esp
 4b5:	85 c0                	test   %eax,%eax
 4b7:	78 27                	js     4e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 4b9:	83 ec 08             	sub    $0x8,%esp
 4bc:	ff 75 0c             	pushl  0xc(%ebp)
 4bf:	89 c3                	mov    %eax,%ebx
 4c1:	50                   	push   %eax
 4c2:	e8 f3 00 00 00       	call   5ba <fstat>
  close(fd);
 4c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4ca:	89 c6                	mov    %eax,%esi
  close(fd);
 4cc:	e8 b9 00 00 00       	call   58a <close>
  return r;
 4d1:	83 c4 10             	add    $0x10,%esp
}
 4d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4d7:	89 f0                	mov    %esi,%eax
 4d9:	5b                   	pop    %ebx
 4da:	5e                   	pop    %esi
 4db:	5d                   	pop    %ebp
 4dc:	c3                   	ret    
 4dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 4e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4e5:	eb ed                	jmp    4d4 <stat+0x34>
 4e7:	89 f6                	mov    %esi,%esi
 4e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004f0 <atoi>:

int
atoi(const char *s)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	53                   	push   %ebx
 4f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4f7:	0f be 11             	movsbl (%ecx),%edx
 4fa:	8d 42 d0             	lea    -0x30(%edx),%eax
 4fd:	3c 09                	cmp    $0x9,%al
  n = 0;
 4ff:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 504:	77 1f                	ja     525 <atoi+0x35>
 506:	8d 76 00             	lea    0x0(%esi),%esi
 509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 510:	8d 04 80             	lea    (%eax,%eax,4),%eax
 513:	83 c1 01             	add    $0x1,%ecx
 516:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 51a:	0f be 11             	movsbl (%ecx),%edx
 51d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 520:	80 fb 09             	cmp    $0x9,%bl
 523:	76 eb                	jbe    510 <atoi+0x20>
  return n;
}
 525:	5b                   	pop    %ebx
 526:	5d                   	pop    %ebp
 527:	c3                   	ret    
 528:	90                   	nop
 529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000530 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	56                   	push   %esi
 534:	53                   	push   %ebx
 535:	8b 5d 10             	mov    0x10(%ebp),%ebx
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 53e:	85 db                	test   %ebx,%ebx
 540:	7e 14                	jle    556 <memmove+0x26>
 542:	31 d2                	xor    %edx,%edx
 544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 548:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 54c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 54f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 552:	39 d3                	cmp    %edx,%ebx
 554:	75 f2                	jne    548 <memmove+0x18>
  return vdst;
}
 556:	5b                   	pop    %ebx
 557:	5e                   	pop    %esi
 558:	5d                   	pop    %ebp
 559:	c3                   	ret    

0000055a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 55a:	b8 01 00 00 00       	mov    $0x1,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <exit>:
SYSCALL(exit)
 562:	b8 02 00 00 00       	mov    $0x2,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <wait>:
SYSCALL(wait)
 56a:	b8 03 00 00 00       	mov    $0x3,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <pipe>:
SYSCALL(pipe)
 572:	b8 04 00 00 00       	mov    $0x4,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <read>:
SYSCALL(read)
 57a:	b8 05 00 00 00       	mov    $0x5,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <write>:
SYSCALL(write)
 582:	b8 10 00 00 00       	mov    $0x10,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <close>:
SYSCALL(close)
 58a:	b8 15 00 00 00       	mov    $0x15,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <kill>:
SYSCALL(kill)
 592:	b8 06 00 00 00       	mov    $0x6,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <exec>:
SYSCALL(exec)
 59a:	b8 07 00 00 00       	mov    $0x7,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <open>:
SYSCALL(open)
 5a2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <mknod>:
SYSCALL(mknod)
 5aa:	b8 11 00 00 00       	mov    $0x11,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <unlink>:
SYSCALL(unlink)
 5b2:	b8 12 00 00 00       	mov    $0x12,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <fstat>:
SYSCALL(fstat)
 5ba:	b8 08 00 00 00       	mov    $0x8,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <link>:
SYSCALL(link)
 5c2:	b8 13 00 00 00       	mov    $0x13,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <mkdir>:
SYSCALL(mkdir)
 5ca:	b8 14 00 00 00       	mov    $0x14,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <chdir>:
SYSCALL(chdir)
 5d2:	b8 09 00 00 00       	mov    $0x9,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <dup>:
SYSCALL(dup)
 5da:	b8 0a 00 00 00       	mov    $0xa,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <getpid>:
SYSCALL(getpid)
 5e2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <sbrk>:
SYSCALL(sbrk)
 5ea:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <sleep>:
SYSCALL(sleep)
 5f2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <uptime>:
SYSCALL(uptime)
 5fa:	b8 0e 00 00 00       	mov    $0xe,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <sigprocmask>:
SYSCALL(sigprocmask)
 602:	b8 16 00 00 00       	mov    $0x16,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <sigaction>:
SYSCALL(sigaction)
 60a:	b8 17 00 00 00       	mov    $0x17,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <sigret>:
SYSCALL(sigret)
 612:	b8 18 00 00 00       	mov    $0x18,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    
 61a:	66 90                	xchg   %ax,%ax
 61c:	66 90                	xchg   %ax,%ax
 61e:	66 90                	xchg   %ax,%ax

00000620 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 629:	85 d2                	test   %edx,%edx
{
 62b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 62e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 630:	79 76                	jns    6a8 <printint+0x88>
 632:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 636:	74 70                	je     6a8 <printint+0x88>
    x = -xx;
 638:	f7 d8                	neg    %eax
    neg = 1;
 63a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 641:	31 f6                	xor    %esi,%esi
 643:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 646:	eb 0a                	jmp    652 <printint+0x32>
 648:	90                   	nop
 649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 650:	89 fe                	mov    %edi,%esi
 652:	31 d2                	xor    %edx,%edx
 654:	8d 7e 01             	lea    0x1(%esi),%edi
 657:	f7 f1                	div    %ecx
 659:	0f b6 92 74 0a 00 00 	movzbl 0xa74(%edx),%edx
  }while((x /= base) != 0);
 660:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 662:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 665:	75 e9                	jne    650 <printint+0x30>
  if(neg)
 667:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 66a:	85 c0                	test   %eax,%eax
 66c:	74 08                	je     676 <printint+0x56>
    buf[i++] = '-';
 66e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 673:	8d 7e 02             	lea    0x2(%esi),%edi
 676:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 67a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 67d:	8d 76 00             	lea    0x0(%esi),%esi
 680:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 683:	83 ec 04             	sub    $0x4,%esp
 686:	83 ee 01             	sub    $0x1,%esi
 689:	6a 01                	push   $0x1
 68b:	53                   	push   %ebx
 68c:	57                   	push   %edi
 68d:	88 45 d7             	mov    %al,-0x29(%ebp)
 690:	e8 ed fe ff ff       	call   582 <write>

  while(--i >= 0)
 695:	83 c4 10             	add    $0x10,%esp
 698:	39 de                	cmp    %ebx,%esi
 69a:	75 e4                	jne    680 <printint+0x60>
    putc(fd, buf[i]);
}
 69c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69f:	5b                   	pop    %ebx
 6a0:	5e                   	pop    %esi
 6a1:	5f                   	pop    %edi
 6a2:	5d                   	pop    %ebp
 6a3:	c3                   	ret    
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6a8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 6af:	eb 90                	jmp    641 <printint+0x21>
 6b1:	eb 0d                	jmp    6c0 <printf>
 6b3:	90                   	nop
 6b4:	90                   	nop
 6b5:	90                   	nop
 6b6:	90                   	nop
 6b7:	90                   	nop
 6b8:	90                   	nop
 6b9:	90                   	nop
 6ba:	90                   	nop
 6bb:	90                   	nop
 6bc:	90                   	nop
 6bd:	90                   	nop
 6be:	90                   	nop
 6bf:	90                   	nop

000006c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6c9:	8b 75 0c             	mov    0xc(%ebp),%esi
 6cc:	0f b6 1e             	movzbl (%esi),%ebx
 6cf:	84 db                	test   %bl,%bl
 6d1:	0f 84 b3 00 00 00    	je     78a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 6d7:	8d 45 10             	lea    0x10(%ebp),%eax
 6da:	83 c6 01             	add    $0x1,%esi
  state = 0;
 6dd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 6df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6e2:	eb 2f                	jmp    713 <printf+0x53>
 6e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 6e8:	83 f8 25             	cmp    $0x25,%eax
 6eb:	0f 84 a7 00 00 00    	je     798 <printf+0xd8>
  write(fd, &c, 1);
 6f1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 6f4:	83 ec 04             	sub    $0x4,%esp
 6f7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 6fa:	6a 01                	push   $0x1
 6fc:	50                   	push   %eax
 6fd:	ff 75 08             	pushl  0x8(%ebp)
 700:	e8 7d fe ff ff       	call   582 <write>
 705:	83 c4 10             	add    $0x10,%esp
 708:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 70b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 70f:	84 db                	test   %bl,%bl
 711:	74 77                	je     78a <printf+0xca>
    if(state == 0){
 713:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 715:	0f be cb             	movsbl %bl,%ecx
 718:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 71b:	74 cb                	je     6e8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 71d:	83 ff 25             	cmp    $0x25,%edi
 720:	75 e6                	jne    708 <printf+0x48>
      if(c == 'd'){
 722:	83 f8 64             	cmp    $0x64,%eax
 725:	0f 84 05 01 00 00    	je     830 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 72b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 731:	83 f9 70             	cmp    $0x70,%ecx
 734:	74 72                	je     7a8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 736:	83 f8 73             	cmp    $0x73,%eax
 739:	0f 84 99 00 00 00    	je     7d8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 73f:	83 f8 63             	cmp    $0x63,%eax
 742:	0f 84 08 01 00 00    	je     850 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 748:	83 f8 25             	cmp    $0x25,%eax
 74b:	0f 84 ef 00 00 00    	je     840 <printf+0x180>
  write(fd, &c, 1);
 751:	8d 45 e7             	lea    -0x19(%ebp),%eax
 754:	83 ec 04             	sub    $0x4,%esp
 757:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 75b:	6a 01                	push   $0x1
 75d:	50                   	push   %eax
 75e:	ff 75 08             	pushl  0x8(%ebp)
 761:	e8 1c fe ff ff       	call   582 <write>
 766:	83 c4 0c             	add    $0xc,%esp
 769:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 76c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 76f:	6a 01                	push   $0x1
 771:	50                   	push   %eax
 772:	ff 75 08             	pushl  0x8(%ebp)
 775:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 778:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 77a:	e8 03 fe ff ff       	call   582 <write>
  for(i = 0; fmt[i]; i++){
 77f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 783:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 786:	84 db                	test   %bl,%bl
 788:	75 89                	jne    713 <printf+0x53>
    }
  }
}
 78a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 78d:	5b                   	pop    %ebx
 78e:	5e                   	pop    %esi
 78f:	5f                   	pop    %edi
 790:	5d                   	pop    %ebp
 791:	c3                   	ret    
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 798:	bf 25 00 00 00       	mov    $0x25,%edi
 79d:	e9 66 ff ff ff       	jmp    708 <printf+0x48>
 7a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 7a8:	83 ec 0c             	sub    $0xc,%esp
 7ab:	b9 10 00 00 00       	mov    $0x10,%ecx
 7b0:	6a 00                	push   $0x0
 7b2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 7b5:	8b 45 08             	mov    0x8(%ebp),%eax
 7b8:	8b 17                	mov    (%edi),%edx
 7ba:	e8 61 fe ff ff       	call   620 <printint>
        ap++;
 7bf:	89 f8                	mov    %edi,%eax
 7c1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7c4:	31 ff                	xor    %edi,%edi
        ap++;
 7c6:	83 c0 04             	add    $0x4,%eax
 7c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 7cc:	e9 37 ff ff ff       	jmp    708 <printf+0x48>
 7d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 7d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7db:	8b 08                	mov    (%eax),%ecx
        ap++;
 7dd:	83 c0 04             	add    $0x4,%eax
 7e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 7e3:	85 c9                	test   %ecx,%ecx
 7e5:	0f 84 8e 00 00 00    	je     879 <printf+0x1b9>
        while(*s != 0){
 7eb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 7ee:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 7f0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 7f2:	84 c0                	test   %al,%al
 7f4:	0f 84 0e ff ff ff    	je     708 <printf+0x48>
 7fa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 7fd:	89 de                	mov    %ebx,%esi
 7ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
 802:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 805:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 808:	83 ec 04             	sub    $0x4,%esp
          s++;
 80b:	83 c6 01             	add    $0x1,%esi
 80e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 811:	6a 01                	push   $0x1
 813:	57                   	push   %edi
 814:	53                   	push   %ebx
 815:	e8 68 fd ff ff       	call   582 <write>
        while(*s != 0){
 81a:	0f b6 06             	movzbl (%esi),%eax
 81d:	83 c4 10             	add    $0x10,%esp
 820:	84 c0                	test   %al,%al
 822:	75 e4                	jne    808 <printf+0x148>
 824:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 827:	31 ff                	xor    %edi,%edi
 829:	e9 da fe ff ff       	jmp    708 <printf+0x48>
 82e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 830:	83 ec 0c             	sub    $0xc,%esp
 833:	b9 0a 00 00 00       	mov    $0xa,%ecx
 838:	6a 01                	push   $0x1
 83a:	e9 73 ff ff ff       	jmp    7b2 <printf+0xf2>
 83f:	90                   	nop
  write(fd, &c, 1);
 840:	83 ec 04             	sub    $0x4,%esp
 843:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 846:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 849:	6a 01                	push   $0x1
 84b:	e9 21 ff ff ff       	jmp    771 <printf+0xb1>
        putc(fd, *ap);
 850:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 853:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 856:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 858:	6a 01                	push   $0x1
        ap++;
 85a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 85d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 860:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 863:	50                   	push   %eax
 864:	ff 75 08             	pushl  0x8(%ebp)
 867:	e8 16 fd ff ff       	call   582 <write>
        ap++;
 86c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 86f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 872:	31 ff                	xor    %edi,%edi
 874:	e9 8f fe ff ff       	jmp    708 <printf+0x48>
          s = "(null)";
 879:	bb 6a 0a 00 00       	mov    $0xa6a,%ebx
        while(*s != 0){
 87e:	b8 28 00 00 00       	mov    $0x28,%eax
 883:	e9 72 ff ff ff       	jmp    7fa <printf+0x13a>
 888:	66 90                	xchg   %ax,%ax
 88a:	66 90                	xchg   %ax,%ax
 88c:	66 90                	xchg   %ax,%ax
 88e:	66 90                	xchg   %ax,%ax

00000890 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 890:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 891:	a1 24 0d 00 00       	mov    0xd24,%eax
{
 896:	89 e5                	mov    %esp,%ebp
 898:	57                   	push   %edi
 899:	56                   	push   %esi
 89a:	53                   	push   %ebx
 89b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 89e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 8a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a8:	39 c8                	cmp    %ecx,%eax
 8aa:	8b 10                	mov    (%eax),%edx
 8ac:	73 32                	jae    8e0 <free+0x50>
 8ae:	39 d1                	cmp    %edx,%ecx
 8b0:	72 04                	jb     8b6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b2:	39 d0                	cmp    %edx,%eax
 8b4:	72 32                	jb     8e8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8b6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8b9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8bc:	39 fa                	cmp    %edi,%edx
 8be:	74 30                	je     8f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8c3:	8b 50 04             	mov    0x4(%eax),%edx
 8c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8c9:	39 f1                	cmp    %esi,%ecx
 8cb:	74 3a                	je     907 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8cd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8cf:	a3 24 0d 00 00       	mov    %eax,0xd24
}
 8d4:	5b                   	pop    %ebx
 8d5:	5e                   	pop    %esi
 8d6:	5f                   	pop    %edi
 8d7:	5d                   	pop    %ebp
 8d8:	c3                   	ret    
 8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e0:	39 d0                	cmp    %edx,%eax
 8e2:	72 04                	jb     8e8 <free+0x58>
 8e4:	39 d1                	cmp    %edx,%ecx
 8e6:	72 ce                	jb     8b6 <free+0x26>
{
 8e8:	89 d0                	mov    %edx,%eax
 8ea:	eb bc                	jmp    8a8 <free+0x18>
 8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 8f0:	03 72 04             	add    0x4(%edx),%esi
 8f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f6:	8b 10                	mov    (%eax),%edx
 8f8:	8b 12                	mov    (%edx),%edx
 8fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8fd:	8b 50 04             	mov    0x4(%eax),%edx
 900:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 903:	39 f1                	cmp    %esi,%ecx
 905:	75 c6                	jne    8cd <free+0x3d>
    p->s.size += bp->s.size;
 907:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 90a:	a3 24 0d 00 00       	mov    %eax,0xd24
    p->s.size += bp->s.size;
 90f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 912:	8b 53 f8             	mov    -0x8(%ebx),%edx
 915:	89 10                	mov    %edx,(%eax)
}
 917:	5b                   	pop    %ebx
 918:	5e                   	pop    %esi
 919:	5f                   	pop    %edi
 91a:	5d                   	pop    %ebp
 91b:	c3                   	ret    
 91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000920 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	57                   	push   %edi
 924:	56                   	push   %esi
 925:	53                   	push   %ebx
 926:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 929:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 92c:	8b 15 24 0d 00 00    	mov    0xd24,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 932:	8d 78 07             	lea    0x7(%eax),%edi
 935:	c1 ef 03             	shr    $0x3,%edi
 938:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 93b:	85 d2                	test   %edx,%edx
 93d:	0f 84 9d 00 00 00    	je     9e0 <malloc+0xc0>
 943:	8b 02                	mov    (%edx),%eax
 945:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 948:	39 cf                	cmp    %ecx,%edi
 94a:	76 6c                	jbe    9b8 <malloc+0x98>
 94c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 952:	bb 00 10 00 00       	mov    $0x1000,%ebx
 957:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 95a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 961:	eb 0e                	jmp    971 <malloc+0x51>
 963:	90                   	nop
 964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 96a:	8b 48 04             	mov    0x4(%eax),%ecx
 96d:	39 f9                	cmp    %edi,%ecx
 96f:	73 47                	jae    9b8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 971:	39 05 24 0d 00 00    	cmp    %eax,0xd24
 977:	89 c2                	mov    %eax,%edx
 979:	75 ed                	jne    968 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 97b:	83 ec 0c             	sub    $0xc,%esp
 97e:	56                   	push   %esi
 97f:	e8 66 fc ff ff       	call   5ea <sbrk>
  if(p == (char*)-1)
 984:	83 c4 10             	add    $0x10,%esp
 987:	83 f8 ff             	cmp    $0xffffffff,%eax
 98a:	74 1c                	je     9a8 <malloc+0x88>
  hp->s.size = nu;
 98c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 98f:	83 ec 0c             	sub    $0xc,%esp
 992:	83 c0 08             	add    $0x8,%eax
 995:	50                   	push   %eax
 996:	e8 f5 fe ff ff       	call   890 <free>
  return freep;
 99b:	8b 15 24 0d 00 00    	mov    0xd24,%edx
      if((p = morecore(nunits)) == 0)
 9a1:	83 c4 10             	add    $0x10,%esp
 9a4:	85 d2                	test   %edx,%edx
 9a6:	75 c0                	jne    968 <malloc+0x48>
        return 0;
  }
}
 9a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9ab:	31 c0                	xor    %eax,%eax
}
 9ad:	5b                   	pop    %ebx
 9ae:	5e                   	pop    %esi
 9af:	5f                   	pop    %edi
 9b0:	5d                   	pop    %ebp
 9b1:	c3                   	ret    
 9b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 9b8:	39 cf                	cmp    %ecx,%edi
 9ba:	74 54                	je     a10 <malloc+0xf0>
        p->s.size -= nunits;
 9bc:	29 f9                	sub    %edi,%ecx
 9be:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 9c1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 9c4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 9c7:	89 15 24 0d 00 00    	mov    %edx,0xd24
}
 9cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9d0:	83 c0 08             	add    $0x8,%eax
}
 9d3:	5b                   	pop    %ebx
 9d4:	5e                   	pop    %esi
 9d5:	5f                   	pop    %edi
 9d6:	5d                   	pop    %ebp
 9d7:	c3                   	ret    
 9d8:	90                   	nop
 9d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 9e0:	c7 05 24 0d 00 00 28 	movl   $0xd28,0xd24
 9e7:	0d 00 00 
 9ea:	c7 05 28 0d 00 00 28 	movl   $0xd28,0xd28
 9f1:	0d 00 00 
    base.s.size = 0;
 9f4:	b8 28 0d 00 00       	mov    $0xd28,%eax
 9f9:	c7 05 2c 0d 00 00 00 	movl   $0x0,0xd2c
 a00:	00 00 00 
 a03:	e9 44 ff ff ff       	jmp    94c <malloc+0x2c>
 a08:	90                   	nop
 a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 a10:	8b 08                	mov    (%eax),%ecx
 a12:	89 0a                	mov    %ecx,(%edx)
 a14:	eb b1                	jmp    9c7 <malloc+0xa7>
