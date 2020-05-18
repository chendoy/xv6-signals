
_ugi:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        exit();
    }
}

int main()
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    test_3();
  11:	e8 2a 04 00 00       	call   440 <test_3>
  16:	66 90                	xchg   %ax,%ax
  18:	66 90                	xchg   %ax,%ax
  1a:	66 90                	xchg   %ax,%ax
  1c:	66 90                	xchg   %ax,%ax
  1e:	66 90                	xchg   %ax,%ax

00000020 <custom_handler>:
{
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	83 ec 10             	sub    $0x10,%esp
    printf(1, "child: CUSTOM HANDLER WAS FIRED!!\n");
  26:	68 08 0c 00 00       	push   $0xc08
  2b:	6a 01                	push   $0x1
  2d:	e8 7e 08 00 00       	call   8b0 <printf>
    return;
  32:	83 c4 10             	add    $0x10,%esp
}
  35:	c9                   	leave  
  36:	c3                   	ret    
  37:	89 f6                	mov    %esi,%esi
  39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000040 <test_1>:
{
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	56                   	push   %esi
  44:	53                   	push   %ebx
    for(i = 1; i < 10; i++) {
  45:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  4a:	83 ec 10             	sub    $0x10,%esp
  4d:	8d 76 00             	lea    0x0(%esi),%esi
        omask = sigprocmask(mask);
  50:	83 ec 0c             	sub    $0xc,%esp
  53:	53                   	push   %ebx
  54:	e8 99 07 00 00       	call   7f2 <sigprocmask>
        printf(1, "need to be %d = %d\n", i-1 ,omask);
  59:	50                   	push   %eax
  5a:	8d 43 ff             	lea    -0x1(%ebx),%eax
    for(i = 1; i < 10; i++) {
  5d:	83 c3 01             	add    $0x1,%ebx
        printf(1, "need to be %d = %d\n", i-1 ,omask);
  60:	50                   	push   %eax
  61:	68 2c 0c 00 00       	push   $0xc2c
  66:	6a 01                	push   $0x1
  68:	e8 43 08 00 00       	call   8b0 <printf>
    for(i = 1; i < 10; i++) {
  6d:	83 c4 20             	add    $0x20,%esp
  70:	83 fb 0a             	cmp    $0xa,%ebx
  73:	75 db                	jne    50 <test_1+0x10>
    sigaction(12, &newact, &oldact);
  75:	8d 5d e8             	lea    -0x18(%ebp),%ebx
  78:	8d 75 f0             	lea    -0x10(%ebp),%esi
  7b:	83 ec 04             	sub    $0x4,%esp
    newact.sa_handler = SIG_IGN;
  7e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    newact.sigmask = 12;
  85:	c7 45 f4 0c 00 00 00 	movl   $0xc,-0xc(%ebp)
    sigaction(12, &newact, &oldact);
  8c:	53                   	push   %ebx
  8d:	56                   	push   %esi
  8e:	6a 0c                	push   $0xc
  90:	e8 65 07 00 00       	call   7fa <sigaction>
    printf(1, "Need to be 0,0 = %d,%d\n", (uint)oldact.sa_handler, oldact.sigmask);
  95:	ff 75 ec             	pushl  -0x14(%ebp)
  98:	ff 75 e8             	pushl  -0x18(%ebp)
  9b:	68 40 0c 00 00       	push   $0xc40
  a0:	6a 01                	push   $0x1
  a2:	e8 09 08 00 00       	call   8b0 <printf>
    sigaction(12, &oldact, &newact);
  a7:	83 c4 1c             	add    $0x1c,%esp
  aa:	56                   	push   %esi
  ab:	53                   	push   %ebx
  ac:	6a 0c                	push   $0xc
  ae:	e8 47 07 00 00       	call   7fa <sigaction>
    printf(1, "Need to be 1,12 = %d,%d\n", (uint)newact.sa_handler, newact.sigmask);
  b3:	ff 75 f4             	pushl  -0xc(%ebp)
  b6:	ff 75 f0             	pushl  -0x10(%ebp)
  b9:	68 58 0c 00 00       	push   $0xc58
  be:	6a 01                	push   $0x1
  c0:	e8 eb 07 00 00       	call   8b0 <printf>
}
  c5:	83 c4 20             	add    $0x20,%esp
  c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  cb:	5b                   	pop    %ebx
  cc:	5e                   	pop    %esi
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    
  cf:	90                   	nop

000000d0 <test_2>:
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	57                   	push   %edi
  d4:	56                   	push   %esi
  d5:	53                   	push   %ebx
  d6:	83 ec 1c             	sub    $0x1c,%esp
    int sigs[] = {SIGSTOP, SIGCONT};
  d9:	c7 45 e0 11 00 00 00 	movl   $0x11,-0x20(%ebp)
  e0:	c7 45 e4 13 00 00 00 	movl   $0x13,-0x1c(%ebp)
    if((pid = fork()) == 0) {
  e7:	e8 5e 06 00 00       	call   74a <fork>
  ec:	85 c0                	test   %eax,%eax
  ee:	74 70                	je     160 <test_2+0x90>
  f0:	89 c6                	mov    %eax,%esi
  f2:	bf 11 00 00 00       	mov    $0x11,%edi
        for (int i = 0; i < 20; i++)
  f7:	31 db                	xor    %ebx,%ebx
  f9:	eb 41                	jmp    13c <test_2+0x6c>
                printf(2, "\n%d: CONT!!!\n", i);
  fb:	83 ec 04             	sub    $0x4,%esp
  fe:	53                   	push   %ebx
  ff:	68 a5 0c 00 00       	push   $0xca5
 104:	6a 02                	push   $0x2
 106:	e8 a5 07 00 00       	call   8b0 <printf>
 10b:	83 c4 10             	add    $0x10,%esp
            kill(pid, sigs[i%2]);
 10e:	83 ec 08             	sub    $0x8,%esp
        for (int i = 0; i < 20; i++)
 111:	83 c3 01             	add    $0x1,%ebx
            kill(pid, sigs[i%2]);
 114:	57                   	push   %edi
 115:	56                   	push   %esi
 116:	e8 67 06 00 00       	call   782 <kill>
            sleep(150);
 11b:	c7 04 24 96 00 00 00 	movl   $0x96,(%esp)
 122:	e8 bb 06 00 00       	call   7e2 <sleep>
        for (int i = 0; i < 20; i++)
 127:	83 c4 10             	add    $0x10,%esp
 12a:	83 fb 14             	cmp    $0x14,%ebx
 12d:	0f 84 d7 02 00 00    	je     40a <test_2+0x33a>
 133:	89 d8                	mov    %ebx,%eax
 135:	83 e0 01             	and    $0x1,%eax
 138:	8b 7c 85 e0          	mov    -0x20(%ebp,%eax,4),%edi
            if (i % 2)
 13c:	f6 c3 01             	test   $0x1,%bl
 13f:	75 ba                	jne    fb <test_2+0x2b>
                printf(2, "\n%d: STOP!!!\n", i);    
 141:	83 ec 04             	sub    $0x4,%esp
 144:	53                   	push   %ebx
 145:	68 b3 0c 00 00       	push   $0xcb3
 14a:	6a 02                	push   $0x2
 14c:	e8 5f 07 00 00       	call   8b0 <printf>
 151:	83 c4 10             	add    $0x10,%esp
 154:	eb b8                	jmp    10e <test_2+0x3e>
 156:	8d 76 00             	lea    0x0(%esi),%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            sleep(5);printf(1, "a");sleep(5);printf(1, "b");sleep(5);printf(1, "c");sleep(5);printf(1, "d");
 160:	83 ec 0c             	sub    $0xc,%esp
 163:	6a 05                	push   $0x5
 165:	e8 78 06 00 00       	call   7e2 <sleep>
 16a:	59                   	pop    %ecx
 16b:	5b                   	pop    %ebx
 16c:	68 71 0c 00 00       	push   $0xc71
 171:	6a 01                	push   $0x1
 173:	e8 38 07 00 00       	call   8b0 <printf>
 178:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 17f:	e8 5e 06 00 00       	call   7e2 <sleep>
 184:	5e                   	pop    %esi
 185:	5f                   	pop    %edi
 186:	68 73 0c 00 00       	push   $0xc73
 18b:	6a 01                	push   $0x1
 18d:	e8 1e 07 00 00       	call   8b0 <printf>
 192:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 199:	e8 44 06 00 00       	call   7e2 <sleep>
 19e:	58                   	pop    %eax
 19f:	5a                   	pop    %edx
 1a0:	68 75 0c 00 00       	push   $0xc75
 1a5:	6a 01                	push   $0x1
 1a7:	e8 04 07 00 00       	call   8b0 <printf>
 1ac:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1b3:	e8 2a 06 00 00       	call   7e2 <sleep>
 1b8:	59                   	pop    %ecx
 1b9:	5b                   	pop    %ebx
 1ba:	68 77 0c 00 00       	push   $0xc77
 1bf:	6a 01                	push   $0x1
 1c1:	e8 ea 06 00 00       	call   8b0 <printf>
            sleep(5);printf(1, "e");sleep(5);printf(1, "f");sleep(5);printf(1, "g");sleep(5);printf(1, "h");
 1c6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1cd:	e8 10 06 00 00       	call   7e2 <sleep>
 1d2:	5e                   	pop    %esi
 1d3:	5f                   	pop    %edi
 1d4:	68 79 0c 00 00       	push   $0xc79
 1d9:	6a 01                	push   $0x1
 1db:	e8 d0 06 00 00       	call   8b0 <printf>
 1e0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1e7:	e8 f6 05 00 00       	call   7e2 <sleep>
 1ec:	58                   	pop    %eax
 1ed:	5a                   	pop    %edx
 1ee:	68 7b 0c 00 00       	push   $0xc7b
 1f3:	6a 01                	push   $0x1
 1f5:	e8 b6 06 00 00       	call   8b0 <printf>
 1fa:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 201:	e8 dc 05 00 00       	call   7e2 <sleep>
 206:	59                   	pop    %ecx
 207:	5b                   	pop    %ebx
 208:	68 7d 0c 00 00       	push   $0xc7d
 20d:	6a 01                	push   $0x1
 20f:	e8 9c 06 00 00       	call   8b0 <printf>
 214:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 21b:	e8 c2 05 00 00       	call   7e2 <sleep>
 220:	5e                   	pop    %esi
 221:	5f                   	pop    %edi
 222:	68 7f 0c 00 00       	push   $0xc7f
 227:	6a 01                	push   $0x1
 229:	e8 82 06 00 00       	call   8b0 <printf>
            sleep(5);printf(1, "i");sleep(5);printf(1, "j");sleep(5);printf(1, "k");sleep(5);printf(1, "l");
 22e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 235:	e8 a8 05 00 00       	call   7e2 <sleep>
 23a:	58                   	pop    %eax
 23b:	5a                   	pop    %edx
 23c:	68 81 0c 00 00       	push   $0xc81
 241:	6a 01                	push   $0x1
 243:	e8 68 06 00 00       	call   8b0 <printf>
 248:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 24f:	e8 8e 05 00 00       	call   7e2 <sleep>
 254:	59                   	pop    %ecx
 255:	5b                   	pop    %ebx
 256:	68 83 0c 00 00       	push   $0xc83
 25b:	6a 01                	push   $0x1
 25d:	e8 4e 06 00 00       	call   8b0 <printf>
 262:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 269:	e8 74 05 00 00       	call   7e2 <sleep>
 26e:	5e                   	pop    %esi
 26f:	5f                   	pop    %edi
 270:	68 85 0c 00 00       	push   $0xc85
 275:	6a 01                	push   $0x1
 277:	e8 34 06 00 00       	call   8b0 <printf>
 27c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 283:	e8 5a 05 00 00       	call   7e2 <sleep>
 288:	58                   	pop    %eax
 289:	5a                   	pop    %edx
 28a:	68 87 0c 00 00       	push   $0xc87
 28f:	6a 01                	push   $0x1
 291:	e8 1a 06 00 00       	call   8b0 <printf>
            sleep(5);printf(1, "m");sleep(5);printf(1, "n");sleep(5);printf(1, "o");sleep(5);printf(1, "p");
 296:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 29d:	e8 40 05 00 00       	call   7e2 <sleep>
 2a2:	59                   	pop    %ecx
 2a3:	5b                   	pop    %ebx
 2a4:	68 89 0c 00 00       	push   $0xc89
 2a9:	6a 01                	push   $0x1
 2ab:	e8 00 06 00 00       	call   8b0 <printf>
 2b0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2b7:	e8 26 05 00 00       	call   7e2 <sleep>
 2bc:	5e                   	pop    %esi
 2bd:	5f                   	pop    %edi
 2be:	68 8b 0c 00 00       	push   $0xc8b
 2c3:	6a 01                	push   $0x1
 2c5:	e8 e6 05 00 00       	call   8b0 <printf>
 2ca:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2d1:	e8 0c 05 00 00       	call   7e2 <sleep>
 2d6:	58                   	pop    %eax
 2d7:	5a                   	pop    %edx
 2d8:	68 8d 0c 00 00       	push   $0xc8d
 2dd:	6a 01                	push   $0x1
 2df:	e8 cc 05 00 00       	call   8b0 <printf>
 2e4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2eb:	e8 f2 04 00 00       	call   7e2 <sleep>
 2f0:	59                   	pop    %ecx
 2f1:	5b                   	pop    %ebx
 2f2:	68 8f 0c 00 00       	push   $0xc8f
 2f7:	6a 01                	push   $0x1
 2f9:	e8 b2 05 00 00       	call   8b0 <printf>
            sleep(5);printf(1, "q");sleep(5);printf(1, "r");sleep(5);printf(1, "s");sleep(5);printf(1, "t");
 2fe:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 305:	e8 d8 04 00 00       	call   7e2 <sleep>
 30a:	5e                   	pop    %esi
 30b:	5f                   	pop    %edi
 30c:	68 91 0c 00 00       	push   $0xc91
 311:	6a 01                	push   $0x1
 313:	e8 98 05 00 00       	call   8b0 <printf>
 318:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 31f:	e8 be 04 00 00       	call   7e2 <sleep>
 324:	58                   	pop    %eax
 325:	5a                   	pop    %edx
 326:	68 93 0c 00 00       	push   $0xc93
 32b:	6a 01                	push   $0x1
 32d:	e8 7e 05 00 00       	call   8b0 <printf>
 332:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 339:	e8 a4 04 00 00       	call   7e2 <sleep>
 33e:	59                   	pop    %ecx
 33f:	5b                   	pop    %ebx
 340:	68 95 0c 00 00       	push   $0xc95
 345:	6a 01                	push   $0x1
 347:	e8 64 05 00 00       	call   8b0 <printf>
 34c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 353:	e8 8a 04 00 00       	call   7e2 <sleep>
 358:	5e                   	pop    %esi
 359:	5f                   	pop    %edi
 35a:	68 97 0c 00 00       	push   $0xc97
 35f:	6a 01                	push   $0x1
 361:	e8 4a 05 00 00       	call   8b0 <printf>
            sleep(5);printf(1, "u");sleep(5);printf(1, "v");sleep(5);printf(1, "w");sleep(5);printf(1, "x");
 366:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 36d:	e8 70 04 00 00       	call   7e2 <sleep>
 372:	58                   	pop    %eax
 373:	5a                   	pop    %edx
 374:	68 99 0c 00 00       	push   $0xc99
 379:	6a 01                	push   $0x1
 37b:	e8 30 05 00 00       	call   8b0 <printf>
 380:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 387:	e8 56 04 00 00       	call   7e2 <sleep>
 38c:	59                   	pop    %ecx
 38d:	5b                   	pop    %ebx
 38e:	68 9b 0c 00 00       	push   $0xc9b
 393:	6a 01                	push   $0x1
 395:	e8 16 05 00 00       	call   8b0 <printf>
 39a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 3a1:	e8 3c 04 00 00       	call   7e2 <sleep>
 3a6:	5e                   	pop    %esi
 3a7:	5f                   	pop    %edi
 3a8:	68 9d 0c 00 00       	push   $0xc9d
 3ad:	6a 01                	push   $0x1
 3af:	e8 fc 04 00 00       	call   8b0 <printf>
 3b4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 3bb:	e8 22 04 00 00       	call   7e2 <sleep>
 3c0:	58                   	pop    %eax
 3c1:	5a                   	pop    %edx
 3c2:	68 9f 0c 00 00       	push   $0xc9f
 3c7:	6a 01                	push   $0x1
 3c9:	e8 e2 04 00 00       	call   8b0 <printf>
            sleep(5);printf(1, "y");sleep(5);printf(1, "z");
 3ce:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 3d5:	e8 08 04 00 00       	call   7e2 <sleep>
 3da:	59                   	pop    %ecx
 3db:	5b                   	pop    %ebx
 3dc:	68 a1 0c 00 00       	push   $0xca1
 3e1:	6a 01                	push   $0x1
 3e3:	e8 c8 04 00 00       	call   8b0 <printf>
 3e8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 3ef:	e8 ee 03 00 00       	call   7e2 <sleep>
 3f4:	5e                   	pop    %esi
 3f5:	5f                   	pop    %edi
 3f6:	68 a3 0c 00 00       	push   $0xca3
 3fb:	6a 01                	push   $0x1
 3fd:	e8 ae 04 00 00       	call   8b0 <printf>
 402:	83 c4 10             	add    $0x10,%esp
 405:	e9 56 fd ff ff       	jmp    160 <test_2+0x90>
        printf(1, "\nKILL!!!\n");
 40a:	83 ec 08             	sub    $0x8,%esp
 40d:	68 c1 0c 00 00       	push   $0xcc1
 412:	6a 01                	push   $0x1
 414:	e8 97 04 00 00       	call   8b0 <printf>
        kill(pid, SIGKILL);
 419:	58                   	pop    %eax
 41a:	5a                   	pop    %edx
 41b:	6a 09                	push   $0x9
 41d:	56                   	push   %esi
 41e:	e8 5f 03 00 00       	call   782 <kill>
        wait();
 423:	83 c4 10             	add    $0x10,%esp
}
 426:	8d 65 f4             	lea    -0xc(%ebp),%esp
 429:	5b                   	pop    %ebx
 42a:	5e                   	pop    %esi
 42b:	5f                   	pop    %edi
 42c:	5d                   	pop    %ebp
        wait();
 42d:	e9 28 03 00 00       	jmp    75a <wait>
 432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000440 <test_3>:
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	53                   	push   %ebx
 444:	83 ec 14             	sub    $0x14,%esp
    act.sa_handler = &custom_handler;
 447:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
    act.sigmask = mask;
 44e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if((pid = fork()) == 0) 
 455:	e8 f0 02 00 00       	call   74a <fork>
 45a:	85 c0                	test   %eax,%eax
 45c:	75 3a                	jne    498 <test_3+0x58>
        sigaction(SIGTEST, &act, null); // register custom handler
 45e:	8d 45 f0             	lea    -0x10(%ebp),%eax
 461:	83 ec 04             	sub    $0x4,%esp
 464:	6a 00                	push   $0x0
 466:	50                   	push   %eax
 467:	6a 14                	push   $0x14
 469:	e8 8c 03 00 00       	call   7fa <sigaction>
 46e:	83 c4 10             	add    $0x10,%esp
 471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(1, "child: waiting...\n");
 478:	83 ec 08             	sub    $0x8,%esp
 47b:	68 cb 0c 00 00       	push   $0xccb
 480:	6a 01                	push   $0x1
 482:	e8 29 04 00 00       	call   8b0 <printf>
            sleep(30);
 487:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
 48e:	e8 4f 03 00 00       	call   7e2 <sleep>
 493:	83 c4 10             	add    $0x10,%esp
 496:	eb e0                	jmp    478 <test_3+0x38>
        sleep(300); // let child print some lines
 498:	83 ec 0c             	sub    $0xc,%esp
 49b:	89 c3                	mov    %eax,%ebx
 49d:	68 2c 01 00 00       	push   $0x12c
 4a2:	e8 3b 03 00 00       	call   7e2 <sleep>
        printf(1, "parent: kill(child, SIGTEST)\n");
 4a7:	58                   	pop    %eax
 4a8:	5a                   	pop    %edx
 4a9:	68 de 0c 00 00       	push   $0xcde
 4ae:	6a 01                	push   $0x1
 4b0:	e8 fb 03 00 00       	call   8b0 <printf>
        sleep(5);
 4b5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 4bc:	e8 21 03 00 00       	call   7e2 <sleep>
        kill(pid, SIGTEST);
 4c1:	59                   	pop    %ecx
 4c2:	58                   	pop    %eax
 4c3:	6a 14                	push   $0x14
 4c5:	53                   	push   %ebx
 4c6:	e8 b7 02 00 00       	call   782 <kill>
        sleep(50);
 4cb:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
 4d2:	e8 0b 03 00 00       	call   7e2 <sleep>
        printf(1, "parent: kill(child, SIGKILL)\n");
 4d7:	58                   	pop    %eax
 4d8:	5a                   	pop    %edx
 4d9:	68 fc 0c 00 00       	push   $0xcfc
 4de:	6a 01                	push   $0x1
 4e0:	e8 cb 03 00 00       	call   8b0 <printf>
        kill(pid, SIGKILL);
 4e5:	59                   	pop    %ecx
 4e6:	58                   	pop    %eax
 4e7:	6a 09                	push   $0x9
 4e9:	53                   	push   %ebx
 4ea:	e8 93 02 00 00       	call   782 <kill>
        wait();
 4ef:	e8 66 02 00 00       	call   75a <wait>
        exit();
 4f4:	e8 59 02 00 00       	call   752 <exit>
 4f9:	66 90                	xchg   %ax,%ax
 4fb:	66 90                	xchg   %ax,%ax
 4fd:	66 90                	xchg   %ax,%ax
 4ff:	90                   	nop

00000500 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	53                   	push   %ebx
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 50a:	89 c2                	mov    %eax,%edx
 50c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 510:	83 c1 01             	add    $0x1,%ecx
 513:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 517:	83 c2 01             	add    $0x1,%edx
 51a:	84 db                	test   %bl,%bl
 51c:	88 5a ff             	mov    %bl,-0x1(%edx)
 51f:	75 ef                	jne    510 <strcpy+0x10>
    ;
  return os;
}
 521:	5b                   	pop    %ebx
 522:	5d                   	pop    %ebp
 523:	c3                   	ret    
 524:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 52a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000530 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	53                   	push   %ebx
 534:	8b 55 08             	mov    0x8(%ebp),%edx
 537:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 53a:	0f b6 02             	movzbl (%edx),%eax
 53d:	0f b6 19             	movzbl (%ecx),%ebx
 540:	84 c0                	test   %al,%al
 542:	75 1c                	jne    560 <strcmp+0x30>
 544:	eb 2a                	jmp    570 <strcmp+0x40>
 546:	8d 76 00             	lea    0x0(%esi),%esi
 549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 550:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 553:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 556:	83 c1 01             	add    $0x1,%ecx
 559:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 55c:	84 c0                	test   %al,%al
 55e:	74 10                	je     570 <strcmp+0x40>
 560:	38 d8                	cmp    %bl,%al
 562:	74 ec                	je     550 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 564:	29 d8                	sub    %ebx,%eax
}
 566:	5b                   	pop    %ebx
 567:	5d                   	pop    %ebp
 568:	c3                   	ret    
 569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 570:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 572:	29 d8                	sub    %ebx,%eax
}
 574:	5b                   	pop    %ebx
 575:	5d                   	pop    %ebp
 576:	c3                   	ret    
 577:	89 f6                	mov    %esi,%esi
 579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000580 <strlen>:

uint
strlen(const char *s)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 586:	80 39 00             	cmpb   $0x0,(%ecx)
 589:	74 15                	je     5a0 <strlen+0x20>
 58b:	31 d2                	xor    %edx,%edx
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	83 c2 01             	add    $0x1,%edx
 593:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 597:	89 d0                	mov    %edx,%eax
 599:	75 f5                	jne    590 <strlen+0x10>
    ;
  return n;
}
 59b:	5d                   	pop    %ebp
 59c:	c3                   	ret    
 59d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 5a0:	31 c0                	xor    %eax,%eax
}
 5a2:	5d                   	pop    %ebp
 5a3:	c3                   	ret    
 5a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000005b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bd:	89 d7                	mov    %edx,%edi
 5bf:	fc                   	cld    
 5c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5c2:	89 d0                	mov    %edx,%eax
 5c4:	5f                   	pop    %edi
 5c5:	5d                   	pop    %ebp
 5c6:	c3                   	ret    
 5c7:	89 f6                	mov    %esi,%esi
 5c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005d0 <strchr>:

char*
strchr(const char *s, char c)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	53                   	push   %ebx
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 5da:	0f b6 10             	movzbl (%eax),%edx
 5dd:	84 d2                	test   %dl,%dl
 5df:	74 1d                	je     5fe <strchr+0x2e>
    if(*s == c)
 5e1:	38 d3                	cmp    %dl,%bl
 5e3:	89 d9                	mov    %ebx,%ecx
 5e5:	75 0d                	jne    5f4 <strchr+0x24>
 5e7:	eb 17                	jmp    600 <strchr+0x30>
 5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f0:	38 ca                	cmp    %cl,%dl
 5f2:	74 0c                	je     600 <strchr+0x30>
  for(; *s; s++)
 5f4:	83 c0 01             	add    $0x1,%eax
 5f7:	0f b6 10             	movzbl (%eax),%edx
 5fa:	84 d2                	test   %dl,%dl
 5fc:	75 f2                	jne    5f0 <strchr+0x20>
      return (char*)s;
  return 0;
 5fe:	31 c0                	xor    %eax,%eax
}
 600:	5b                   	pop    %ebx
 601:	5d                   	pop    %ebp
 602:	c3                   	ret    
 603:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000610 <gets>:

char*
gets(char *buf, int max)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 616:	31 f6                	xor    %esi,%esi
 618:	89 f3                	mov    %esi,%ebx
{
 61a:	83 ec 1c             	sub    $0x1c,%esp
 61d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 620:	eb 2f                	jmp    651 <gets+0x41>
 622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 628:	8d 45 e7             	lea    -0x19(%ebp),%eax
 62b:	83 ec 04             	sub    $0x4,%esp
 62e:	6a 01                	push   $0x1
 630:	50                   	push   %eax
 631:	6a 00                	push   $0x0
 633:	e8 32 01 00 00       	call   76a <read>
    if(cc < 1)
 638:	83 c4 10             	add    $0x10,%esp
 63b:	85 c0                	test   %eax,%eax
 63d:	7e 1c                	jle    65b <gets+0x4b>
      break;
    buf[i++] = c;
 63f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 643:	83 c7 01             	add    $0x1,%edi
 646:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 649:	3c 0a                	cmp    $0xa,%al
 64b:	74 23                	je     670 <gets+0x60>
 64d:	3c 0d                	cmp    $0xd,%al
 64f:	74 1f                	je     670 <gets+0x60>
  for(i=0; i+1 < max; ){
 651:	83 c3 01             	add    $0x1,%ebx
 654:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 657:	89 fe                	mov    %edi,%esi
 659:	7c cd                	jl     628 <gets+0x18>
 65b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 660:	c6 03 00             	movb   $0x0,(%ebx)
}
 663:	8d 65 f4             	lea    -0xc(%ebp),%esp
 666:	5b                   	pop    %ebx
 667:	5e                   	pop    %esi
 668:	5f                   	pop    %edi
 669:	5d                   	pop    %ebp
 66a:	c3                   	ret    
 66b:	90                   	nop
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 670:	8b 75 08             	mov    0x8(%ebp),%esi
 673:	8b 45 08             	mov    0x8(%ebp),%eax
 676:	01 de                	add    %ebx,%esi
 678:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 67a:	c6 03 00             	movb   $0x0,(%ebx)
}
 67d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 680:	5b                   	pop    %ebx
 681:	5e                   	pop    %esi
 682:	5f                   	pop    %edi
 683:	5d                   	pop    %ebp
 684:	c3                   	ret    
 685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000690 <stat>:

int
stat(const char *n, struct stat *st)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	56                   	push   %esi
 694:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 695:	83 ec 08             	sub    $0x8,%esp
 698:	6a 00                	push   $0x0
 69a:	ff 75 08             	pushl  0x8(%ebp)
 69d:	e8 f0 00 00 00       	call   792 <open>
  if(fd < 0)
 6a2:	83 c4 10             	add    $0x10,%esp
 6a5:	85 c0                	test   %eax,%eax
 6a7:	78 27                	js     6d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 6a9:	83 ec 08             	sub    $0x8,%esp
 6ac:	ff 75 0c             	pushl  0xc(%ebp)
 6af:	89 c3                	mov    %eax,%ebx
 6b1:	50                   	push   %eax
 6b2:	e8 f3 00 00 00       	call   7aa <fstat>
  close(fd);
 6b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6ba:	89 c6                	mov    %eax,%esi
  close(fd);
 6bc:	e8 b9 00 00 00       	call   77a <close>
  return r;
 6c1:	83 c4 10             	add    $0x10,%esp
}
 6c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6c7:	89 f0                	mov    %esi,%eax
 6c9:	5b                   	pop    %ebx
 6ca:	5e                   	pop    %esi
 6cb:	5d                   	pop    %ebp
 6cc:	c3                   	ret    
 6cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 6d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6d5:	eb ed                	jmp    6c4 <stat+0x34>
 6d7:	89 f6                	mov    %esi,%esi
 6d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006e0 <atoi>:

int
atoi(const char *s)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	53                   	push   %ebx
 6e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6e7:	0f be 11             	movsbl (%ecx),%edx
 6ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 6ed:	3c 09                	cmp    $0x9,%al
  n = 0;
 6ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 6f4:	77 1f                	ja     715 <atoi+0x35>
 6f6:	8d 76 00             	lea    0x0(%esi),%esi
 6f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 700:	8d 04 80             	lea    (%eax,%eax,4),%eax
 703:	83 c1 01             	add    $0x1,%ecx
 706:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 70a:	0f be 11             	movsbl (%ecx),%edx
 70d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 710:	80 fb 09             	cmp    $0x9,%bl
 713:	76 eb                	jbe    700 <atoi+0x20>
  return n;
}
 715:	5b                   	pop    %ebx
 716:	5d                   	pop    %ebp
 717:	c3                   	ret    
 718:	90                   	nop
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000720 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	56                   	push   %esi
 724:	53                   	push   %ebx
 725:	8b 5d 10             	mov    0x10(%ebp),%ebx
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 72e:	85 db                	test   %ebx,%ebx
 730:	7e 14                	jle    746 <memmove+0x26>
 732:	31 d2                	xor    %edx,%edx
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 738:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 73c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 73f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 742:	39 d3                	cmp    %edx,%ebx
 744:	75 f2                	jne    738 <memmove+0x18>
  return vdst;
}
 746:	5b                   	pop    %ebx
 747:	5e                   	pop    %esi
 748:	5d                   	pop    %ebp
 749:	c3                   	ret    

0000074a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 74a:	b8 01 00 00 00       	mov    $0x1,%eax
 74f:	cd 40                	int    $0x40
 751:	c3                   	ret    

00000752 <exit>:
SYSCALL(exit)
 752:	b8 02 00 00 00       	mov    $0x2,%eax
 757:	cd 40                	int    $0x40
 759:	c3                   	ret    

0000075a <wait>:
SYSCALL(wait)
 75a:	b8 03 00 00 00       	mov    $0x3,%eax
 75f:	cd 40                	int    $0x40
 761:	c3                   	ret    

00000762 <pipe>:
SYSCALL(pipe)
 762:	b8 04 00 00 00       	mov    $0x4,%eax
 767:	cd 40                	int    $0x40
 769:	c3                   	ret    

0000076a <read>:
SYSCALL(read)
 76a:	b8 05 00 00 00       	mov    $0x5,%eax
 76f:	cd 40                	int    $0x40
 771:	c3                   	ret    

00000772 <write>:
SYSCALL(write)
 772:	b8 10 00 00 00       	mov    $0x10,%eax
 777:	cd 40                	int    $0x40
 779:	c3                   	ret    

0000077a <close>:
SYSCALL(close)
 77a:	b8 15 00 00 00       	mov    $0x15,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <kill>:
SYSCALL(kill)
 782:	b8 06 00 00 00       	mov    $0x6,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <exec>:
SYSCALL(exec)
 78a:	b8 07 00 00 00       	mov    $0x7,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <open>:
SYSCALL(open)
 792:	b8 0f 00 00 00       	mov    $0xf,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <mknod>:
SYSCALL(mknod)
 79a:	b8 11 00 00 00       	mov    $0x11,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <unlink>:
SYSCALL(unlink)
 7a2:	b8 12 00 00 00       	mov    $0x12,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <fstat>:
SYSCALL(fstat)
 7aa:	b8 08 00 00 00       	mov    $0x8,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <link>:
SYSCALL(link)
 7b2:	b8 13 00 00 00       	mov    $0x13,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <mkdir>:
SYSCALL(mkdir)
 7ba:	b8 14 00 00 00       	mov    $0x14,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <chdir>:
SYSCALL(chdir)
 7c2:	b8 09 00 00 00       	mov    $0x9,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <dup>:
SYSCALL(dup)
 7ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <getpid>:
SYSCALL(getpid)
 7d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <sbrk>:
SYSCALL(sbrk)
 7da:	b8 0c 00 00 00       	mov    $0xc,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <sleep>:
SYSCALL(sleep)
 7e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <uptime>:
SYSCALL(uptime)
 7ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <sigprocmask>:
SYSCALL(sigprocmask)
 7f2:	b8 16 00 00 00       	mov    $0x16,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <sigaction>:
SYSCALL(sigaction)
 7fa:	b8 17 00 00 00       	mov    $0x17,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <sigret>:
SYSCALL(sigret)
 802:	b8 18 00 00 00       	mov    $0x18,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    
 80a:	66 90                	xchg   %ax,%ax
 80c:	66 90                	xchg   %ax,%ax
 80e:	66 90                	xchg   %ax,%ax

00000810 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 810:	55                   	push   %ebp
 811:	89 e5                	mov    %esp,%ebp
 813:	57                   	push   %edi
 814:	56                   	push   %esi
 815:	53                   	push   %ebx
 816:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 819:	85 d2                	test   %edx,%edx
{
 81b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 81e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 820:	79 76                	jns    898 <printint+0x88>
 822:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 826:	74 70                	je     898 <printint+0x88>
    x = -xx;
 828:	f7 d8                	neg    %eax
    neg = 1;
 82a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 831:	31 f6                	xor    %esi,%esi
 833:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 836:	eb 0a                	jmp    842 <printint+0x32>
 838:	90                   	nop
 839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 840:	89 fe                	mov    %edi,%esi
 842:	31 d2                	xor    %edx,%edx
 844:	8d 7e 01             	lea    0x1(%esi),%edi
 847:	f7 f1                	div    %ecx
 849:	0f b6 92 24 0d 00 00 	movzbl 0xd24(%edx),%edx
  }while((x /= base) != 0);
 850:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 852:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 855:	75 e9                	jne    840 <printint+0x30>
  if(neg)
 857:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 85a:	85 c0                	test   %eax,%eax
 85c:	74 08                	je     866 <printint+0x56>
    buf[i++] = '-';
 85e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 863:	8d 7e 02             	lea    0x2(%esi),%edi
 866:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 86a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 86d:	8d 76 00             	lea    0x0(%esi),%esi
 870:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 873:	83 ec 04             	sub    $0x4,%esp
 876:	83 ee 01             	sub    $0x1,%esi
 879:	6a 01                	push   $0x1
 87b:	53                   	push   %ebx
 87c:	57                   	push   %edi
 87d:	88 45 d7             	mov    %al,-0x29(%ebp)
 880:	e8 ed fe ff ff       	call   772 <write>

  while(--i >= 0)
 885:	83 c4 10             	add    $0x10,%esp
 888:	39 de                	cmp    %ebx,%esi
 88a:	75 e4                	jne    870 <printint+0x60>
    putc(fd, buf[i]);
}
 88c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 88f:	5b                   	pop    %ebx
 890:	5e                   	pop    %esi
 891:	5f                   	pop    %edi
 892:	5d                   	pop    %ebp
 893:	c3                   	ret    
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 898:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 89f:	eb 90                	jmp    831 <printint+0x21>
 8a1:	eb 0d                	jmp    8b0 <printf>
 8a3:	90                   	nop
 8a4:	90                   	nop
 8a5:	90                   	nop
 8a6:	90                   	nop
 8a7:	90                   	nop
 8a8:	90                   	nop
 8a9:	90                   	nop
 8aa:	90                   	nop
 8ab:	90                   	nop
 8ac:	90                   	nop
 8ad:	90                   	nop
 8ae:	90                   	nop
 8af:	90                   	nop

000008b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	57                   	push   %edi
 8b4:	56                   	push   %esi
 8b5:	53                   	push   %ebx
 8b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8b9:	8b 75 0c             	mov    0xc(%ebp),%esi
 8bc:	0f b6 1e             	movzbl (%esi),%ebx
 8bf:	84 db                	test   %bl,%bl
 8c1:	0f 84 b3 00 00 00    	je     97a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 8c7:	8d 45 10             	lea    0x10(%ebp),%eax
 8ca:	83 c6 01             	add    $0x1,%esi
  state = 0;
 8cd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 8cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 8d2:	eb 2f                	jmp    903 <printf+0x53>
 8d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 8d8:	83 f8 25             	cmp    $0x25,%eax
 8db:	0f 84 a7 00 00 00    	je     988 <printf+0xd8>
  write(fd, &c, 1);
 8e1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 8e4:	83 ec 04             	sub    $0x4,%esp
 8e7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 8ea:	6a 01                	push   $0x1
 8ec:	50                   	push   %eax
 8ed:	ff 75 08             	pushl  0x8(%ebp)
 8f0:	e8 7d fe ff ff       	call   772 <write>
 8f5:	83 c4 10             	add    $0x10,%esp
 8f8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 8fb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 8ff:	84 db                	test   %bl,%bl
 901:	74 77                	je     97a <printf+0xca>
    if(state == 0){
 903:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 905:	0f be cb             	movsbl %bl,%ecx
 908:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 90b:	74 cb                	je     8d8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 90d:	83 ff 25             	cmp    $0x25,%edi
 910:	75 e6                	jne    8f8 <printf+0x48>
      if(c == 'd'){
 912:	83 f8 64             	cmp    $0x64,%eax
 915:	0f 84 05 01 00 00    	je     a20 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 91b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 921:	83 f9 70             	cmp    $0x70,%ecx
 924:	74 72                	je     998 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 926:	83 f8 73             	cmp    $0x73,%eax
 929:	0f 84 99 00 00 00    	je     9c8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 92f:	83 f8 63             	cmp    $0x63,%eax
 932:	0f 84 08 01 00 00    	je     a40 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 938:	83 f8 25             	cmp    $0x25,%eax
 93b:	0f 84 ef 00 00 00    	je     a30 <printf+0x180>
  write(fd, &c, 1);
 941:	8d 45 e7             	lea    -0x19(%ebp),%eax
 944:	83 ec 04             	sub    $0x4,%esp
 947:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 94b:	6a 01                	push   $0x1
 94d:	50                   	push   %eax
 94e:	ff 75 08             	pushl  0x8(%ebp)
 951:	e8 1c fe ff ff       	call   772 <write>
 956:	83 c4 0c             	add    $0xc,%esp
 959:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 95c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 95f:	6a 01                	push   $0x1
 961:	50                   	push   %eax
 962:	ff 75 08             	pushl  0x8(%ebp)
 965:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 968:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 96a:	e8 03 fe ff ff       	call   772 <write>
  for(i = 0; fmt[i]; i++){
 96f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 973:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 976:	84 db                	test   %bl,%bl
 978:	75 89                	jne    903 <printf+0x53>
    }
  }
}
 97a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 97d:	5b                   	pop    %ebx
 97e:	5e                   	pop    %esi
 97f:	5f                   	pop    %edi
 980:	5d                   	pop    %ebp
 981:	c3                   	ret    
 982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 988:	bf 25 00 00 00       	mov    $0x25,%edi
 98d:	e9 66 ff ff ff       	jmp    8f8 <printf+0x48>
 992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 998:	83 ec 0c             	sub    $0xc,%esp
 99b:	b9 10 00 00 00       	mov    $0x10,%ecx
 9a0:	6a 00                	push   $0x0
 9a2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 9a5:	8b 45 08             	mov    0x8(%ebp),%eax
 9a8:	8b 17                	mov    (%edi),%edx
 9aa:	e8 61 fe ff ff       	call   810 <printint>
        ap++;
 9af:	89 f8                	mov    %edi,%eax
 9b1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9b4:	31 ff                	xor    %edi,%edi
        ap++;
 9b6:	83 c0 04             	add    $0x4,%eax
 9b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 9bc:	e9 37 ff ff ff       	jmp    8f8 <printf+0x48>
 9c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 9c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 9cb:	8b 08                	mov    (%eax),%ecx
        ap++;
 9cd:	83 c0 04             	add    $0x4,%eax
 9d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 9d3:	85 c9                	test   %ecx,%ecx
 9d5:	0f 84 8e 00 00 00    	je     a69 <printf+0x1b9>
        while(*s != 0){
 9db:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 9de:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 9e0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 9e2:	84 c0                	test   %al,%al
 9e4:	0f 84 0e ff ff ff    	je     8f8 <printf+0x48>
 9ea:	89 75 d0             	mov    %esi,-0x30(%ebp)
 9ed:	89 de                	mov    %ebx,%esi
 9ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 9f2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 9f5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 9f8:	83 ec 04             	sub    $0x4,%esp
          s++;
 9fb:	83 c6 01             	add    $0x1,%esi
 9fe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 a01:	6a 01                	push   $0x1
 a03:	57                   	push   %edi
 a04:	53                   	push   %ebx
 a05:	e8 68 fd ff ff       	call   772 <write>
        while(*s != 0){
 a0a:	0f b6 06             	movzbl (%esi),%eax
 a0d:	83 c4 10             	add    $0x10,%esp
 a10:	84 c0                	test   %al,%al
 a12:	75 e4                	jne    9f8 <printf+0x148>
 a14:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 a17:	31 ff                	xor    %edi,%edi
 a19:	e9 da fe ff ff       	jmp    8f8 <printf+0x48>
 a1e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 a20:	83 ec 0c             	sub    $0xc,%esp
 a23:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a28:	6a 01                	push   $0x1
 a2a:	e9 73 ff ff ff       	jmp    9a2 <printf+0xf2>
 a2f:	90                   	nop
  write(fd, &c, 1);
 a30:	83 ec 04             	sub    $0x4,%esp
 a33:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 a36:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 a39:	6a 01                	push   $0x1
 a3b:	e9 21 ff ff ff       	jmp    961 <printf+0xb1>
        putc(fd, *ap);
 a40:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 a43:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a46:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 a48:	6a 01                	push   $0x1
        ap++;
 a4a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 a4d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 a50:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 a53:	50                   	push   %eax
 a54:	ff 75 08             	pushl  0x8(%ebp)
 a57:	e8 16 fd ff ff       	call   772 <write>
        ap++;
 a5c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 a5f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a62:	31 ff                	xor    %edi,%edi
 a64:	e9 8f fe ff ff       	jmp    8f8 <printf+0x48>
          s = "(null)";
 a69:	bb 1a 0d 00 00       	mov    $0xd1a,%ebx
        while(*s != 0){
 a6e:	b8 28 00 00 00       	mov    $0x28,%eax
 a73:	e9 72 ff ff ff       	jmp    9ea <printf+0x13a>
 a78:	66 90                	xchg   %ax,%ax
 a7a:	66 90                	xchg   %ax,%ax
 a7c:	66 90                	xchg   %ax,%ax
 a7e:	66 90                	xchg   %ax,%ax

00000a80 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a80:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a81:	a1 5c 10 00 00       	mov    0x105c,%eax
{
 a86:	89 e5                	mov    %esp,%ebp
 a88:	57                   	push   %edi
 a89:	56                   	push   %esi
 a8a:	53                   	push   %ebx
 a8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 a8e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a98:	39 c8                	cmp    %ecx,%eax
 a9a:	8b 10                	mov    (%eax),%edx
 a9c:	73 32                	jae    ad0 <free+0x50>
 a9e:	39 d1                	cmp    %edx,%ecx
 aa0:	72 04                	jb     aa6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa2:	39 d0                	cmp    %edx,%eax
 aa4:	72 32                	jb     ad8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 aa6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 aa9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 aac:	39 fa                	cmp    %edi,%edx
 aae:	74 30                	je     ae0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 ab0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ab3:	8b 50 04             	mov    0x4(%eax),%edx
 ab6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ab9:	39 f1                	cmp    %esi,%ecx
 abb:	74 3a                	je     af7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 abd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 abf:	a3 5c 10 00 00       	mov    %eax,0x105c
}
 ac4:	5b                   	pop    %ebx
 ac5:	5e                   	pop    %esi
 ac6:	5f                   	pop    %edi
 ac7:	5d                   	pop    %ebp
 ac8:	c3                   	ret    
 ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ad0:	39 d0                	cmp    %edx,%eax
 ad2:	72 04                	jb     ad8 <free+0x58>
 ad4:	39 d1                	cmp    %edx,%ecx
 ad6:	72 ce                	jb     aa6 <free+0x26>
{
 ad8:	89 d0                	mov    %edx,%eax
 ada:	eb bc                	jmp    a98 <free+0x18>
 adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 ae0:	03 72 04             	add    0x4(%edx),%esi
 ae3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ae6:	8b 10                	mov    (%eax),%edx
 ae8:	8b 12                	mov    (%edx),%edx
 aea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 aed:	8b 50 04             	mov    0x4(%eax),%edx
 af0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 af3:	39 f1                	cmp    %esi,%ecx
 af5:	75 c6                	jne    abd <free+0x3d>
    p->s.size += bp->s.size;
 af7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 afa:	a3 5c 10 00 00       	mov    %eax,0x105c
    p->s.size += bp->s.size;
 aff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b02:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b05:	89 10                	mov    %edx,(%eax)
}
 b07:	5b                   	pop    %ebx
 b08:	5e                   	pop    %esi
 b09:	5f                   	pop    %edi
 b0a:	5d                   	pop    %ebp
 b0b:	c3                   	ret    
 b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b10 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b10:	55                   	push   %ebp
 b11:	89 e5                	mov    %esp,%ebp
 b13:	57                   	push   %edi
 b14:	56                   	push   %esi
 b15:	53                   	push   %ebx
 b16:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b19:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b1c:	8b 15 5c 10 00 00    	mov    0x105c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b22:	8d 78 07             	lea    0x7(%eax),%edi
 b25:	c1 ef 03             	shr    $0x3,%edi
 b28:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 b2b:	85 d2                	test   %edx,%edx
 b2d:	0f 84 9d 00 00 00    	je     bd0 <malloc+0xc0>
 b33:	8b 02                	mov    (%edx),%eax
 b35:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b38:	39 cf                	cmp    %ecx,%edi
 b3a:	76 6c                	jbe    ba8 <malloc+0x98>
 b3c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 b42:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b47:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 b4a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 b51:	eb 0e                	jmp    b61 <malloc+0x51>
 b53:	90                   	nop
 b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b58:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b5a:	8b 48 04             	mov    0x4(%eax),%ecx
 b5d:	39 f9                	cmp    %edi,%ecx
 b5f:	73 47                	jae    ba8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b61:	39 05 5c 10 00 00    	cmp    %eax,0x105c
 b67:	89 c2                	mov    %eax,%edx
 b69:	75 ed                	jne    b58 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 b6b:	83 ec 0c             	sub    $0xc,%esp
 b6e:	56                   	push   %esi
 b6f:	e8 66 fc ff ff       	call   7da <sbrk>
  if(p == (char*)-1)
 b74:	83 c4 10             	add    $0x10,%esp
 b77:	83 f8 ff             	cmp    $0xffffffff,%eax
 b7a:	74 1c                	je     b98 <malloc+0x88>
  hp->s.size = nu;
 b7c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 b7f:	83 ec 0c             	sub    $0xc,%esp
 b82:	83 c0 08             	add    $0x8,%eax
 b85:	50                   	push   %eax
 b86:	e8 f5 fe ff ff       	call   a80 <free>
  return freep;
 b8b:	8b 15 5c 10 00 00    	mov    0x105c,%edx
      if((p = morecore(nunits)) == 0)
 b91:	83 c4 10             	add    $0x10,%esp
 b94:	85 d2                	test   %edx,%edx
 b96:	75 c0                	jne    b58 <malloc+0x48>
        return 0;
  }
}
 b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 b9b:	31 c0                	xor    %eax,%eax
}
 b9d:	5b                   	pop    %ebx
 b9e:	5e                   	pop    %esi
 b9f:	5f                   	pop    %edi
 ba0:	5d                   	pop    %ebp
 ba1:	c3                   	ret    
 ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 ba8:	39 cf                	cmp    %ecx,%edi
 baa:	74 54                	je     c00 <malloc+0xf0>
        p->s.size -= nunits;
 bac:	29 f9                	sub    %edi,%ecx
 bae:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 bb1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 bb4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 bb7:	89 15 5c 10 00 00    	mov    %edx,0x105c
}
 bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 bc0:	83 c0 08             	add    $0x8,%eax
}
 bc3:	5b                   	pop    %ebx
 bc4:	5e                   	pop    %esi
 bc5:	5f                   	pop    %edi
 bc6:	5d                   	pop    %ebp
 bc7:	c3                   	ret    
 bc8:	90                   	nop
 bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 bd0:	c7 05 5c 10 00 00 60 	movl   $0x1060,0x105c
 bd7:	10 00 00 
 bda:	c7 05 60 10 00 00 60 	movl   $0x1060,0x1060
 be1:	10 00 00 
    base.s.size = 0;
 be4:	b8 60 10 00 00       	mov    $0x1060,%eax
 be9:	c7 05 64 10 00 00 00 	movl   $0x0,0x1064
 bf0:	00 00 00 
 bf3:	e9 44 ff ff ff       	jmp    b3c <malloc+0x2c>
 bf8:	90                   	nop
 bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 c00:	8b 08                	mov    (%eax),%ecx
 c02:	89 0a                	mov    %ecx,(%edx)
 c04:	eb b1                	jmp    bb7 <malloc+0xa7>
