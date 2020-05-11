
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
        test_2(); 
  11:	e8 ba 00 00 00       	call   d0 <test_2>
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
  26:	68 f8 0b 00 00       	push   $0xbf8
  2b:	6a 01                	push   $0x1
  2d:	e8 6e 08 00 00       	call   8a0 <printf>
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
  54:	e8 89 07 00 00       	call   7e2 <sigprocmask>
        printf(1, "need to be %d = %d\n", i-1 ,omask);
  59:	50                   	push   %eax
  5a:	8d 43 ff             	lea    -0x1(%ebx),%eax
    for(i = 1; i < 10; i++) {
  5d:	83 c3 01             	add    $0x1,%ebx
        printf(1, "need to be %d = %d\n", i-1 ,omask);
  60:	50                   	push   %eax
  61:	68 1c 0c 00 00       	push   $0xc1c
  66:	6a 01                	push   $0x1
  68:	e8 33 08 00 00       	call   8a0 <printf>
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
  90:	e8 55 07 00 00       	call   7ea <sigaction>
    printf(1, "Need to be 0,0 = %d,%d\n", (uint)oldact.sa_handler, oldact.sigmask);
  95:	ff 75 ec             	pushl  -0x14(%ebp)
  98:	ff 75 e8             	pushl  -0x18(%ebp)
  9b:	68 30 0c 00 00       	push   $0xc30
  a0:	6a 01                	push   $0x1
  a2:	e8 f9 07 00 00       	call   8a0 <printf>
    sigaction(12, &oldact, &newact);
  a7:	83 c4 1c             	add    $0x1c,%esp
  aa:	56                   	push   %esi
  ab:	53                   	push   %ebx
  ac:	6a 0c                	push   $0xc
  ae:	e8 37 07 00 00       	call   7ea <sigaction>
    printf(1, "Need to be 1,12 = %d,%d\n", (uint)newact.sa_handler, newact.sigmask);
  b3:	ff 75 f4             	pushl  -0xc(%ebp)
  b6:	ff 75 f0             	pushl  -0x10(%ebp)
  b9:	68 48 0c 00 00       	push   $0xc48
  be:	6a 01                	push   $0x1
  c0:	e8 db 07 00 00       	call   8a0 <printf>
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
  e7:	e8 4e 06 00 00       	call   73a <fork>
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
  ff:	68 95 0c 00 00       	push   $0xc95
 104:	6a 02                	push   $0x2
 106:	e8 95 07 00 00       	call   8a0 <printf>
 10b:	83 c4 10             	add    $0x10,%esp
            kill(pid, sigs[i%2]);
 10e:	83 ec 08             	sub    $0x8,%esp
        for (int i = 0; i < 20; i++)
 111:	83 c3 01             	add    $0x1,%ebx
            kill(pid, sigs[i%2]);
 114:	57                   	push   %edi
 115:	56                   	push   %esi
 116:	e8 57 06 00 00       	call   772 <kill>
            sleep(30);
 11b:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
 122:	e8 ab 06 00 00       	call   7d2 <sleep>
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
 145:	68 a3 0c 00 00       	push   $0xca3
 14a:	6a 02                	push   $0x2
 14c:	e8 4f 07 00 00       	call   8a0 <printf>
 151:	83 c4 10             	add    $0x10,%esp
 154:	eb b8                	jmp    10e <test_2+0x3e>
 156:	8d 76 00             	lea    0x0(%esi),%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            sleep(5);printf(1, "a");sleep(5);printf(1, "b");sleep(5);printf(1, "c");sleep(5);printf(1, "d");
 160:	83 ec 0c             	sub    $0xc,%esp
 163:	6a 05                	push   $0x5
 165:	e8 68 06 00 00       	call   7d2 <sleep>
 16a:	59                   	pop    %ecx
 16b:	5b                   	pop    %ebx
 16c:	68 61 0c 00 00       	push   $0xc61
 171:	6a 01                	push   $0x1
 173:	e8 28 07 00 00       	call   8a0 <printf>
 178:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 17f:	e8 4e 06 00 00       	call   7d2 <sleep>
 184:	5e                   	pop    %esi
 185:	5f                   	pop    %edi
 186:	68 63 0c 00 00       	push   $0xc63
 18b:	6a 01                	push   $0x1
 18d:	e8 0e 07 00 00       	call   8a0 <printf>
 192:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 199:	e8 34 06 00 00       	call   7d2 <sleep>
 19e:	58                   	pop    %eax
 19f:	5a                   	pop    %edx
 1a0:	68 65 0c 00 00       	push   $0xc65
 1a5:	6a 01                	push   $0x1
 1a7:	e8 f4 06 00 00       	call   8a0 <printf>
 1ac:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1b3:	e8 1a 06 00 00       	call   7d2 <sleep>
 1b8:	59                   	pop    %ecx
 1b9:	5b                   	pop    %ebx
 1ba:	68 67 0c 00 00       	push   $0xc67
 1bf:	6a 01                	push   $0x1
 1c1:	e8 da 06 00 00       	call   8a0 <printf>
            sleep(5);printf(1, "e");sleep(5);printf(1, "f");sleep(5);printf(1, "g");sleep(5);printf(1, "h");
 1c6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1cd:	e8 00 06 00 00       	call   7d2 <sleep>
 1d2:	5e                   	pop    %esi
 1d3:	5f                   	pop    %edi
 1d4:	68 69 0c 00 00       	push   $0xc69
 1d9:	6a 01                	push   $0x1
 1db:	e8 c0 06 00 00       	call   8a0 <printf>
 1e0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1e7:	e8 e6 05 00 00       	call   7d2 <sleep>
 1ec:	58                   	pop    %eax
 1ed:	5a                   	pop    %edx
 1ee:	68 6b 0c 00 00       	push   $0xc6b
 1f3:	6a 01                	push   $0x1
 1f5:	e8 a6 06 00 00       	call   8a0 <printf>
 1fa:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 201:	e8 cc 05 00 00       	call   7d2 <sleep>
 206:	59                   	pop    %ecx
 207:	5b                   	pop    %ebx
 208:	68 6d 0c 00 00       	push   $0xc6d
 20d:	6a 01                	push   $0x1
 20f:	e8 8c 06 00 00       	call   8a0 <printf>
 214:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 21b:	e8 b2 05 00 00       	call   7d2 <sleep>
 220:	5e                   	pop    %esi
 221:	5f                   	pop    %edi
 222:	68 6f 0c 00 00       	push   $0xc6f
 227:	6a 01                	push   $0x1
 229:	e8 72 06 00 00       	call   8a0 <printf>
            sleep(5);printf(1, "i");sleep(5);printf(1, "j");sleep(5);printf(1, "k");sleep(5);printf(1, "l");
 22e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 235:	e8 98 05 00 00       	call   7d2 <sleep>
 23a:	58                   	pop    %eax
 23b:	5a                   	pop    %edx
 23c:	68 71 0c 00 00       	push   $0xc71
 241:	6a 01                	push   $0x1
 243:	e8 58 06 00 00       	call   8a0 <printf>
 248:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 24f:	e8 7e 05 00 00       	call   7d2 <sleep>
 254:	59                   	pop    %ecx
 255:	5b                   	pop    %ebx
 256:	68 73 0c 00 00       	push   $0xc73
 25b:	6a 01                	push   $0x1
 25d:	e8 3e 06 00 00       	call   8a0 <printf>
 262:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 269:	e8 64 05 00 00       	call   7d2 <sleep>
 26e:	5e                   	pop    %esi
 26f:	5f                   	pop    %edi
 270:	68 75 0c 00 00       	push   $0xc75
 275:	6a 01                	push   $0x1
 277:	e8 24 06 00 00       	call   8a0 <printf>
 27c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 283:	e8 4a 05 00 00       	call   7d2 <sleep>
 288:	58                   	pop    %eax
 289:	5a                   	pop    %edx
 28a:	68 77 0c 00 00       	push   $0xc77
 28f:	6a 01                	push   $0x1
 291:	e8 0a 06 00 00       	call   8a0 <printf>
            sleep(5);printf(1, "m");sleep(5);printf(1, "n");sleep(5);printf(1, "o");sleep(5);printf(1, "p");
 296:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 29d:	e8 30 05 00 00       	call   7d2 <sleep>
 2a2:	59                   	pop    %ecx
 2a3:	5b                   	pop    %ebx
 2a4:	68 79 0c 00 00       	push   $0xc79
 2a9:	6a 01                	push   $0x1
 2ab:	e8 f0 05 00 00       	call   8a0 <printf>
 2b0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2b7:	e8 16 05 00 00       	call   7d2 <sleep>
 2bc:	5e                   	pop    %esi
 2bd:	5f                   	pop    %edi
 2be:	68 7b 0c 00 00       	push   $0xc7b
 2c3:	6a 01                	push   $0x1
 2c5:	e8 d6 05 00 00       	call   8a0 <printf>
 2ca:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2d1:	e8 fc 04 00 00       	call   7d2 <sleep>
 2d6:	58                   	pop    %eax
 2d7:	5a                   	pop    %edx
 2d8:	68 7d 0c 00 00       	push   $0xc7d
 2dd:	6a 01                	push   $0x1
 2df:	e8 bc 05 00 00       	call   8a0 <printf>
 2e4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2eb:	e8 e2 04 00 00       	call   7d2 <sleep>
 2f0:	59                   	pop    %ecx
 2f1:	5b                   	pop    %ebx
 2f2:	68 7f 0c 00 00       	push   $0xc7f
 2f7:	6a 01                	push   $0x1
 2f9:	e8 a2 05 00 00       	call   8a0 <printf>
            sleep(5);printf(1, "q");sleep(5);printf(1, "r");sleep(5);printf(1, "s");sleep(5);printf(1, "t");
 2fe:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 305:	e8 c8 04 00 00       	call   7d2 <sleep>
 30a:	5e                   	pop    %esi
 30b:	5f                   	pop    %edi
 30c:	68 81 0c 00 00       	push   $0xc81
 311:	6a 01                	push   $0x1
 313:	e8 88 05 00 00       	call   8a0 <printf>
 318:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 31f:	e8 ae 04 00 00       	call   7d2 <sleep>
 324:	58                   	pop    %eax
 325:	5a                   	pop    %edx
 326:	68 83 0c 00 00       	push   $0xc83
 32b:	6a 01                	push   $0x1
 32d:	e8 6e 05 00 00       	call   8a0 <printf>
 332:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 339:	e8 94 04 00 00       	call   7d2 <sleep>
 33e:	59                   	pop    %ecx
 33f:	5b                   	pop    %ebx
 340:	68 85 0c 00 00       	push   $0xc85
 345:	6a 01                	push   $0x1
 347:	e8 54 05 00 00       	call   8a0 <printf>
 34c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 353:	e8 7a 04 00 00       	call   7d2 <sleep>
 358:	5e                   	pop    %esi
 359:	5f                   	pop    %edi
 35a:	68 87 0c 00 00       	push   $0xc87
 35f:	6a 01                	push   $0x1
 361:	e8 3a 05 00 00       	call   8a0 <printf>
            sleep(5);printf(1, "u");sleep(5);printf(1, "v");sleep(5);printf(1, "w");sleep(5);printf(1, "x");
 366:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 36d:	e8 60 04 00 00       	call   7d2 <sleep>
 372:	58                   	pop    %eax
 373:	5a                   	pop    %edx
 374:	68 89 0c 00 00       	push   $0xc89
 379:	6a 01                	push   $0x1
 37b:	e8 20 05 00 00       	call   8a0 <printf>
 380:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 387:	e8 46 04 00 00       	call   7d2 <sleep>
 38c:	59                   	pop    %ecx
 38d:	5b                   	pop    %ebx
 38e:	68 8b 0c 00 00       	push   $0xc8b
 393:	6a 01                	push   $0x1
 395:	e8 06 05 00 00       	call   8a0 <printf>
 39a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 3a1:	e8 2c 04 00 00       	call   7d2 <sleep>
 3a6:	5e                   	pop    %esi
 3a7:	5f                   	pop    %edi
 3a8:	68 8d 0c 00 00       	push   $0xc8d
 3ad:	6a 01                	push   $0x1
 3af:	e8 ec 04 00 00       	call   8a0 <printf>
 3b4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 3bb:	e8 12 04 00 00       	call   7d2 <sleep>
 3c0:	58                   	pop    %eax
 3c1:	5a                   	pop    %edx
 3c2:	68 8f 0c 00 00       	push   $0xc8f
 3c7:	6a 01                	push   $0x1
 3c9:	e8 d2 04 00 00       	call   8a0 <printf>
            sleep(5);printf(1, "y");sleep(5);printf(1, "z");
 3ce:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 3d5:	e8 f8 03 00 00       	call   7d2 <sleep>
 3da:	59                   	pop    %ecx
 3db:	5b                   	pop    %ebx
 3dc:	68 91 0c 00 00       	push   $0xc91
 3e1:	6a 01                	push   $0x1
 3e3:	e8 b8 04 00 00       	call   8a0 <printf>
 3e8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 3ef:	e8 de 03 00 00       	call   7d2 <sleep>
 3f4:	5e                   	pop    %esi
 3f5:	5f                   	pop    %edi
 3f6:	68 93 0c 00 00       	push   $0xc93
 3fb:	6a 01                	push   $0x1
 3fd:	e8 9e 04 00 00       	call   8a0 <printf>
 402:	83 c4 10             	add    $0x10,%esp
 405:	e9 56 fd ff ff       	jmp    160 <test_2+0x90>
        printf(1, "\nKILL pid : %d!!!\n", pid);
 40a:	83 ec 04             	sub    $0x4,%esp
 40d:	56                   	push   %esi
 40e:	68 b1 0c 00 00       	push   $0xcb1
 413:	6a 01                	push   $0x1
 415:	e8 86 04 00 00       	call   8a0 <printf>
        kill(pid, SIGKILL);
 41a:	58                   	pop    %eax
 41b:	5a                   	pop    %edx
 41c:	6a 09                	push   $0x9
 41e:	56                   	push   %esi
 41f:	e8 4e 03 00 00       	call   772 <kill>
        wait();
 424:	e8 21 03 00 00       	call   74a <wait>
        exit();
 429:	e8 14 03 00 00       	call   742 <exit>
 42e:	66 90                	xchg   %ax,%ax

00000430 <test_3>:
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	53                   	push   %ebx
 434:	83 ec 14             	sub    $0x14,%esp
    act.sa_handler = &custom_handler;
 437:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
    act.sigmask = mask;
 43e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if((pid = fork()) == 0) 
 445:	e8 f0 02 00 00       	call   73a <fork>
 44a:	85 c0                	test   %eax,%eax
 44c:	75 3a                	jne    488 <test_3+0x58>
        sigaction(SIGTEST, &act, null); // register custom handler
 44e:	8d 45 f0             	lea    -0x10(%ebp),%eax
 451:	83 ec 04             	sub    $0x4,%esp
 454:	6a 00                	push   $0x0
 456:	50                   	push   %eax
 457:	6a 14                	push   $0x14
 459:	e8 8c 03 00 00       	call   7ea <sigaction>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(1, "child: waiting...\n");
 468:	83 ec 08             	sub    $0x8,%esp
 46b:	68 c4 0c 00 00       	push   $0xcc4
 470:	6a 01                	push   $0x1
 472:	e8 29 04 00 00       	call   8a0 <printf>
            sleep(30);
 477:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
 47e:	e8 4f 03 00 00       	call   7d2 <sleep>
 483:	83 c4 10             	add    $0x10,%esp
 486:	eb e0                	jmp    468 <test_3+0x38>
        sleep(300); // let child print some lines
 488:	83 ec 0c             	sub    $0xc,%esp
 48b:	89 c3                	mov    %eax,%ebx
 48d:	68 2c 01 00 00       	push   $0x12c
 492:	e8 3b 03 00 00       	call   7d2 <sleep>
        printf(1, "parent: kill(child, SIGTEST)\n");
 497:	58                   	pop    %eax
 498:	5a                   	pop    %edx
 499:	68 d7 0c 00 00       	push   $0xcd7
 49e:	6a 01                	push   $0x1
 4a0:	e8 fb 03 00 00       	call   8a0 <printf>
        sleep(5);
 4a5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 4ac:	e8 21 03 00 00       	call   7d2 <sleep>
        kill(pid, SIGTEST);
 4b1:	59                   	pop    %ecx
 4b2:	58                   	pop    %eax
 4b3:	6a 14                	push   $0x14
 4b5:	53                   	push   %ebx
 4b6:	e8 b7 02 00 00       	call   772 <kill>
        sleep(50);
 4bb:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
 4c2:	e8 0b 03 00 00       	call   7d2 <sleep>
        printf(1, "parent: kill(child, SIGKILL)\n");
 4c7:	58                   	pop    %eax
 4c8:	5a                   	pop    %edx
 4c9:	68 f5 0c 00 00       	push   $0xcf5
 4ce:	6a 01                	push   $0x1
 4d0:	e8 cb 03 00 00       	call   8a0 <printf>
        kill(pid, SIGKILL);
 4d5:	59                   	pop    %ecx
 4d6:	58                   	pop    %eax
 4d7:	6a 09                	push   $0x9
 4d9:	53                   	push   %ebx
 4da:	e8 93 02 00 00       	call   772 <kill>
        wait();
 4df:	e8 66 02 00 00       	call   74a <wait>
        exit();
 4e4:	e8 59 02 00 00       	call   742 <exit>
 4e9:	66 90                	xchg   %ax,%ax
 4eb:	66 90                	xchg   %ax,%ax
 4ed:	66 90                	xchg   %ax,%ax
 4ef:	90                   	nop

000004f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	53                   	push   %ebx
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4fa:	89 c2                	mov    %eax,%edx
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 500:	83 c1 01             	add    $0x1,%ecx
 503:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 507:	83 c2 01             	add    $0x1,%edx
 50a:	84 db                	test   %bl,%bl
 50c:	88 5a ff             	mov    %bl,-0x1(%edx)
 50f:	75 ef                	jne    500 <strcpy+0x10>
    ;
  return os;
}
 511:	5b                   	pop    %ebx
 512:	5d                   	pop    %ebp
 513:	c3                   	ret    
 514:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 51a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000520 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	53                   	push   %ebx
 524:	8b 55 08             	mov    0x8(%ebp),%edx
 527:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 52a:	0f b6 02             	movzbl (%edx),%eax
 52d:	0f b6 19             	movzbl (%ecx),%ebx
 530:	84 c0                	test   %al,%al
 532:	75 1c                	jne    550 <strcmp+0x30>
 534:	eb 2a                	jmp    560 <strcmp+0x40>
 536:	8d 76 00             	lea    0x0(%esi),%esi
 539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 540:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 543:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 546:	83 c1 01             	add    $0x1,%ecx
 549:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 54c:	84 c0                	test   %al,%al
 54e:	74 10                	je     560 <strcmp+0x40>
 550:	38 d8                	cmp    %bl,%al
 552:	74 ec                	je     540 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 554:	29 d8                	sub    %ebx,%eax
}
 556:	5b                   	pop    %ebx
 557:	5d                   	pop    %ebp
 558:	c3                   	ret    
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 560:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 562:	29 d8                	sub    %ebx,%eax
}
 564:	5b                   	pop    %ebx
 565:	5d                   	pop    %ebp
 566:	c3                   	ret    
 567:	89 f6                	mov    %esi,%esi
 569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000570 <strlen>:

uint
strlen(const char *s)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 576:	80 39 00             	cmpb   $0x0,(%ecx)
 579:	74 15                	je     590 <strlen+0x20>
 57b:	31 d2                	xor    %edx,%edx
 57d:	8d 76 00             	lea    0x0(%esi),%esi
 580:	83 c2 01             	add    $0x1,%edx
 583:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 587:	89 d0                	mov    %edx,%eax
 589:	75 f5                	jne    580 <strlen+0x10>
    ;
  return n;
}
 58b:	5d                   	pop    %ebp
 58c:	c3                   	ret    
 58d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 590:	31 c0                	xor    %eax,%eax
}
 592:	5d                   	pop    %ebp
 593:	c3                   	ret    
 594:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 59a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000005a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ad:	89 d7                	mov    %edx,%edi
 5af:	fc                   	cld    
 5b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5b2:	89 d0                	mov    %edx,%eax
 5b4:	5f                   	pop    %edi
 5b5:	5d                   	pop    %ebp
 5b6:	c3                   	ret    
 5b7:	89 f6                	mov    %esi,%esi
 5b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005c0 <strchr>:

char*
strchr(const char *s, char c)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	53                   	push   %ebx
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 5ca:	0f b6 10             	movzbl (%eax),%edx
 5cd:	84 d2                	test   %dl,%dl
 5cf:	74 1d                	je     5ee <strchr+0x2e>
    if(*s == c)
 5d1:	38 d3                	cmp    %dl,%bl
 5d3:	89 d9                	mov    %ebx,%ecx
 5d5:	75 0d                	jne    5e4 <strchr+0x24>
 5d7:	eb 17                	jmp    5f0 <strchr+0x30>
 5d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5e0:	38 ca                	cmp    %cl,%dl
 5e2:	74 0c                	je     5f0 <strchr+0x30>
  for(; *s; s++)
 5e4:	83 c0 01             	add    $0x1,%eax
 5e7:	0f b6 10             	movzbl (%eax),%edx
 5ea:	84 d2                	test   %dl,%dl
 5ec:	75 f2                	jne    5e0 <strchr+0x20>
      return (char*)s;
  return 0;
 5ee:	31 c0                	xor    %eax,%eax
}
 5f0:	5b                   	pop    %ebx
 5f1:	5d                   	pop    %ebp
 5f2:	c3                   	ret    
 5f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000600 <gets>:

char*
gets(char *buf, int max)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	57                   	push   %edi
 604:	56                   	push   %esi
 605:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 606:	31 f6                	xor    %esi,%esi
 608:	89 f3                	mov    %esi,%ebx
{
 60a:	83 ec 1c             	sub    $0x1c,%esp
 60d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 610:	eb 2f                	jmp    641 <gets+0x41>
 612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 618:	8d 45 e7             	lea    -0x19(%ebp),%eax
 61b:	83 ec 04             	sub    $0x4,%esp
 61e:	6a 01                	push   $0x1
 620:	50                   	push   %eax
 621:	6a 00                	push   $0x0
 623:	e8 32 01 00 00       	call   75a <read>
    if(cc < 1)
 628:	83 c4 10             	add    $0x10,%esp
 62b:	85 c0                	test   %eax,%eax
 62d:	7e 1c                	jle    64b <gets+0x4b>
      break;
    buf[i++] = c;
 62f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 633:	83 c7 01             	add    $0x1,%edi
 636:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 639:	3c 0a                	cmp    $0xa,%al
 63b:	74 23                	je     660 <gets+0x60>
 63d:	3c 0d                	cmp    $0xd,%al
 63f:	74 1f                	je     660 <gets+0x60>
  for(i=0; i+1 < max; ){
 641:	83 c3 01             	add    $0x1,%ebx
 644:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 647:	89 fe                	mov    %edi,%esi
 649:	7c cd                	jl     618 <gets+0x18>
 64b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 650:	c6 03 00             	movb   $0x0,(%ebx)
}
 653:	8d 65 f4             	lea    -0xc(%ebp),%esp
 656:	5b                   	pop    %ebx
 657:	5e                   	pop    %esi
 658:	5f                   	pop    %edi
 659:	5d                   	pop    %ebp
 65a:	c3                   	ret    
 65b:	90                   	nop
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 660:	8b 75 08             	mov    0x8(%ebp),%esi
 663:	8b 45 08             	mov    0x8(%ebp),%eax
 666:	01 de                	add    %ebx,%esi
 668:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 66a:	c6 03 00             	movb   $0x0,(%ebx)
}
 66d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 670:	5b                   	pop    %ebx
 671:	5e                   	pop    %esi
 672:	5f                   	pop    %edi
 673:	5d                   	pop    %ebp
 674:	c3                   	ret    
 675:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000680 <stat>:

int
stat(const char *n, struct stat *st)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	56                   	push   %esi
 684:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 685:	83 ec 08             	sub    $0x8,%esp
 688:	6a 00                	push   $0x0
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 f0 00 00 00       	call   782 <open>
  if(fd < 0)
 692:	83 c4 10             	add    $0x10,%esp
 695:	85 c0                	test   %eax,%eax
 697:	78 27                	js     6c0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	ff 75 0c             	pushl  0xc(%ebp)
 69f:	89 c3                	mov    %eax,%ebx
 6a1:	50                   	push   %eax
 6a2:	e8 f3 00 00 00       	call   79a <fstat>
  close(fd);
 6a7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6aa:	89 c6                	mov    %eax,%esi
  close(fd);
 6ac:	e8 b9 00 00 00       	call   76a <close>
  return r;
 6b1:	83 c4 10             	add    $0x10,%esp
}
 6b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6b7:	89 f0                	mov    %esi,%eax
 6b9:	5b                   	pop    %ebx
 6ba:	5e                   	pop    %esi
 6bb:	5d                   	pop    %ebp
 6bc:	c3                   	ret    
 6bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 6c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6c5:	eb ed                	jmp    6b4 <stat+0x34>
 6c7:	89 f6                	mov    %esi,%esi
 6c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000006d0 <atoi>:

int
atoi(const char *s)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	53                   	push   %ebx
 6d4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6d7:	0f be 11             	movsbl (%ecx),%edx
 6da:	8d 42 d0             	lea    -0x30(%edx),%eax
 6dd:	3c 09                	cmp    $0x9,%al
  n = 0;
 6df:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 6e4:	77 1f                	ja     705 <atoi+0x35>
 6e6:	8d 76 00             	lea    0x0(%esi),%esi
 6e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 6f0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 6f3:	83 c1 01             	add    $0x1,%ecx
 6f6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 6fa:	0f be 11             	movsbl (%ecx),%edx
 6fd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 700:	80 fb 09             	cmp    $0x9,%bl
 703:	76 eb                	jbe    6f0 <atoi+0x20>
  return n;
}
 705:	5b                   	pop    %ebx
 706:	5d                   	pop    %ebp
 707:	c3                   	ret    
 708:	90                   	nop
 709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000710 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	56                   	push   %esi
 714:	53                   	push   %ebx
 715:	8b 5d 10             	mov    0x10(%ebp),%ebx
 718:	8b 45 08             	mov    0x8(%ebp),%eax
 71b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 71e:	85 db                	test   %ebx,%ebx
 720:	7e 14                	jle    736 <memmove+0x26>
 722:	31 d2                	xor    %edx,%edx
 724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 728:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 72c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 72f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 732:	39 d3                	cmp    %edx,%ebx
 734:	75 f2                	jne    728 <memmove+0x18>
  return vdst;
}
 736:	5b                   	pop    %ebx
 737:	5e                   	pop    %esi
 738:	5d                   	pop    %ebp
 739:	c3                   	ret    

0000073a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 73a:	b8 01 00 00 00       	mov    $0x1,%eax
 73f:	cd 40                	int    $0x40
 741:	c3                   	ret    

00000742 <exit>:
SYSCALL(exit)
 742:	b8 02 00 00 00       	mov    $0x2,%eax
 747:	cd 40                	int    $0x40
 749:	c3                   	ret    

0000074a <wait>:
SYSCALL(wait)
 74a:	b8 03 00 00 00       	mov    $0x3,%eax
 74f:	cd 40                	int    $0x40
 751:	c3                   	ret    

00000752 <pipe>:
SYSCALL(pipe)
 752:	b8 04 00 00 00       	mov    $0x4,%eax
 757:	cd 40                	int    $0x40
 759:	c3                   	ret    

0000075a <read>:
SYSCALL(read)
 75a:	b8 05 00 00 00       	mov    $0x5,%eax
 75f:	cd 40                	int    $0x40
 761:	c3                   	ret    

00000762 <write>:
SYSCALL(write)
 762:	b8 10 00 00 00       	mov    $0x10,%eax
 767:	cd 40                	int    $0x40
 769:	c3                   	ret    

0000076a <close>:
SYSCALL(close)
 76a:	b8 15 00 00 00       	mov    $0x15,%eax
 76f:	cd 40                	int    $0x40
 771:	c3                   	ret    

00000772 <kill>:
SYSCALL(kill)
 772:	b8 06 00 00 00       	mov    $0x6,%eax
 777:	cd 40                	int    $0x40
 779:	c3                   	ret    

0000077a <exec>:
SYSCALL(exec)
 77a:	b8 07 00 00 00       	mov    $0x7,%eax
 77f:	cd 40                	int    $0x40
 781:	c3                   	ret    

00000782 <open>:
SYSCALL(open)
 782:	b8 0f 00 00 00       	mov    $0xf,%eax
 787:	cd 40                	int    $0x40
 789:	c3                   	ret    

0000078a <mknod>:
SYSCALL(mknod)
 78a:	b8 11 00 00 00       	mov    $0x11,%eax
 78f:	cd 40                	int    $0x40
 791:	c3                   	ret    

00000792 <unlink>:
SYSCALL(unlink)
 792:	b8 12 00 00 00       	mov    $0x12,%eax
 797:	cd 40                	int    $0x40
 799:	c3                   	ret    

0000079a <fstat>:
SYSCALL(fstat)
 79a:	b8 08 00 00 00       	mov    $0x8,%eax
 79f:	cd 40                	int    $0x40
 7a1:	c3                   	ret    

000007a2 <link>:
SYSCALL(link)
 7a2:	b8 13 00 00 00       	mov    $0x13,%eax
 7a7:	cd 40                	int    $0x40
 7a9:	c3                   	ret    

000007aa <mkdir>:
SYSCALL(mkdir)
 7aa:	b8 14 00 00 00       	mov    $0x14,%eax
 7af:	cd 40                	int    $0x40
 7b1:	c3                   	ret    

000007b2 <chdir>:
SYSCALL(chdir)
 7b2:	b8 09 00 00 00       	mov    $0x9,%eax
 7b7:	cd 40                	int    $0x40
 7b9:	c3                   	ret    

000007ba <dup>:
SYSCALL(dup)
 7ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 7bf:	cd 40                	int    $0x40
 7c1:	c3                   	ret    

000007c2 <getpid>:
SYSCALL(getpid)
 7c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 7c7:	cd 40                	int    $0x40
 7c9:	c3                   	ret    

000007ca <sbrk>:
SYSCALL(sbrk)
 7ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <sleep>:
SYSCALL(sleep)
 7d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <uptime>:
SYSCALL(uptime)
 7da:	b8 0e 00 00 00       	mov    $0xe,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <sigprocmask>:
SYSCALL(sigprocmask)
 7e2:	b8 16 00 00 00       	mov    $0x16,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <sigaction>:
SYSCALL(sigaction)
 7ea:	b8 17 00 00 00       	mov    $0x17,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <sigret>:
SYSCALL(sigret)
 7f2:	b8 18 00 00 00       	mov    $0x18,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    
 7fa:	66 90                	xchg   %ax,%ax
 7fc:	66 90                	xchg   %ax,%ax
 7fe:	66 90                	xchg   %ax,%ax

00000800 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	57                   	push   %edi
 804:	56                   	push   %esi
 805:	53                   	push   %ebx
 806:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 809:	85 d2                	test   %edx,%edx
{
 80b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 80e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 810:	79 76                	jns    888 <printint+0x88>
 812:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 816:	74 70                	je     888 <printint+0x88>
    x = -xx;
 818:	f7 d8                	neg    %eax
    neg = 1;
 81a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 821:	31 f6                	xor    %esi,%esi
 823:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 826:	eb 0a                	jmp    832 <printint+0x32>
 828:	90                   	nop
 829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 830:	89 fe                	mov    %edi,%esi
 832:	31 d2                	xor    %edx,%edx
 834:	8d 7e 01             	lea    0x1(%esi),%edi
 837:	f7 f1                	div    %ecx
 839:	0f b6 92 1c 0d 00 00 	movzbl 0xd1c(%edx),%edx
  }while((x /= base) != 0);
 840:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 842:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 845:	75 e9                	jne    830 <printint+0x30>
  if(neg)
 847:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 84a:	85 c0                	test   %eax,%eax
 84c:	74 08                	je     856 <printint+0x56>
    buf[i++] = '-';
 84e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 853:	8d 7e 02             	lea    0x2(%esi),%edi
 856:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 85a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 85d:	8d 76 00             	lea    0x0(%esi),%esi
 860:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 863:	83 ec 04             	sub    $0x4,%esp
 866:	83 ee 01             	sub    $0x1,%esi
 869:	6a 01                	push   $0x1
 86b:	53                   	push   %ebx
 86c:	57                   	push   %edi
 86d:	88 45 d7             	mov    %al,-0x29(%ebp)
 870:	e8 ed fe ff ff       	call   762 <write>

  while(--i >= 0)
 875:	83 c4 10             	add    $0x10,%esp
 878:	39 de                	cmp    %ebx,%esi
 87a:	75 e4                	jne    860 <printint+0x60>
    putc(fd, buf[i]);
}
 87c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 87f:	5b                   	pop    %ebx
 880:	5e                   	pop    %esi
 881:	5f                   	pop    %edi
 882:	5d                   	pop    %ebp
 883:	c3                   	ret    
 884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 888:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 88f:	eb 90                	jmp    821 <printint+0x21>
 891:	eb 0d                	jmp    8a0 <printf>
 893:	90                   	nop
 894:	90                   	nop
 895:	90                   	nop
 896:	90                   	nop
 897:	90                   	nop
 898:	90                   	nop
 899:	90                   	nop
 89a:	90                   	nop
 89b:	90                   	nop
 89c:	90                   	nop
 89d:	90                   	nop
 89e:	90                   	nop
 89f:	90                   	nop

000008a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	57                   	push   %edi
 8a4:	56                   	push   %esi
 8a5:	53                   	push   %ebx
 8a6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8a9:	8b 75 0c             	mov    0xc(%ebp),%esi
 8ac:	0f b6 1e             	movzbl (%esi),%ebx
 8af:	84 db                	test   %bl,%bl
 8b1:	0f 84 b3 00 00 00    	je     96a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 8b7:	8d 45 10             	lea    0x10(%ebp),%eax
 8ba:	83 c6 01             	add    $0x1,%esi
  state = 0;
 8bd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 8bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 8c2:	eb 2f                	jmp    8f3 <printf+0x53>
 8c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 8c8:	83 f8 25             	cmp    $0x25,%eax
 8cb:	0f 84 a7 00 00 00    	je     978 <printf+0xd8>
  write(fd, &c, 1);
 8d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 8d4:	83 ec 04             	sub    $0x4,%esp
 8d7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 8da:	6a 01                	push   $0x1
 8dc:	50                   	push   %eax
 8dd:	ff 75 08             	pushl  0x8(%ebp)
 8e0:	e8 7d fe ff ff       	call   762 <write>
 8e5:	83 c4 10             	add    $0x10,%esp
 8e8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 8eb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 8ef:	84 db                	test   %bl,%bl
 8f1:	74 77                	je     96a <printf+0xca>
    if(state == 0){
 8f3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 8f5:	0f be cb             	movsbl %bl,%ecx
 8f8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 8fb:	74 cb                	je     8c8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 8fd:	83 ff 25             	cmp    $0x25,%edi
 900:	75 e6                	jne    8e8 <printf+0x48>
      if(c == 'd'){
 902:	83 f8 64             	cmp    $0x64,%eax
 905:	0f 84 05 01 00 00    	je     a10 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 90b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 911:	83 f9 70             	cmp    $0x70,%ecx
 914:	74 72                	je     988 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 916:	83 f8 73             	cmp    $0x73,%eax
 919:	0f 84 99 00 00 00    	je     9b8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 91f:	83 f8 63             	cmp    $0x63,%eax
 922:	0f 84 08 01 00 00    	je     a30 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 928:	83 f8 25             	cmp    $0x25,%eax
 92b:	0f 84 ef 00 00 00    	je     a20 <printf+0x180>
  write(fd, &c, 1);
 931:	8d 45 e7             	lea    -0x19(%ebp),%eax
 934:	83 ec 04             	sub    $0x4,%esp
 937:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 93b:	6a 01                	push   $0x1
 93d:	50                   	push   %eax
 93e:	ff 75 08             	pushl  0x8(%ebp)
 941:	e8 1c fe ff ff       	call   762 <write>
 946:	83 c4 0c             	add    $0xc,%esp
 949:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 94c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 94f:	6a 01                	push   $0x1
 951:	50                   	push   %eax
 952:	ff 75 08             	pushl  0x8(%ebp)
 955:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 958:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 95a:	e8 03 fe ff ff       	call   762 <write>
  for(i = 0; fmt[i]; i++){
 95f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 963:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 966:	84 db                	test   %bl,%bl
 968:	75 89                	jne    8f3 <printf+0x53>
    }
  }
}
 96a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 96d:	5b                   	pop    %ebx
 96e:	5e                   	pop    %esi
 96f:	5f                   	pop    %edi
 970:	5d                   	pop    %ebp
 971:	c3                   	ret    
 972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 978:	bf 25 00 00 00       	mov    $0x25,%edi
 97d:	e9 66 ff ff ff       	jmp    8e8 <printf+0x48>
 982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 988:	83 ec 0c             	sub    $0xc,%esp
 98b:	b9 10 00 00 00       	mov    $0x10,%ecx
 990:	6a 00                	push   $0x0
 992:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 995:	8b 45 08             	mov    0x8(%ebp),%eax
 998:	8b 17                	mov    (%edi),%edx
 99a:	e8 61 fe ff ff       	call   800 <printint>
        ap++;
 99f:	89 f8                	mov    %edi,%eax
 9a1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9a4:	31 ff                	xor    %edi,%edi
        ap++;
 9a6:	83 c0 04             	add    $0x4,%eax
 9a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 9ac:	e9 37 ff ff ff       	jmp    8e8 <printf+0x48>
 9b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 9b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 9bb:	8b 08                	mov    (%eax),%ecx
        ap++;
 9bd:	83 c0 04             	add    $0x4,%eax
 9c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 9c3:	85 c9                	test   %ecx,%ecx
 9c5:	0f 84 8e 00 00 00    	je     a59 <printf+0x1b9>
        while(*s != 0){
 9cb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 9ce:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 9d0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 9d2:	84 c0                	test   %al,%al
 9d4:	0f 84 0e ff ff ff    	je     8e8 <printf+0x48>
 9da:	89 75 d0             	mov    %esi,-0x30(%ebp)
 9dd:	89 de                	mov    %ebx,%esi
 9df:	8b 5d 08             	mov    0x8(%ebp),%ebx
 9e2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 9e5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 9e8:	83 ec 04             	sub    $0x4,%esp
          s++;
 9eb:	83 c6 01             	add    $0x1,%esi
 9ee:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 9f1:	6a 01                	push   $0x1
 9f3:	57                   	push   %edi
 9f4:	53                   	push   %ebx
 9f5:	e8 68 fd ff ff       	call   762 <write>
        while(*s != 0){
 9fa:	0f b6 06             	movzbl (%esi),%eax
 9fd:	83 c4 10             	add    $0x10,%esp
 a00:	84 c0                	test   %al,%al
 a02:	75 e4                	jne    9e8 <printf+0x148>
 a04:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 a07:	31 ff                	xor    %edi,%edi
 a09:	e9 da fe ff ff       	jmp    8e8 <printf+0x48>
 a0e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 a10:	83 ec 0c             	sub    $0xc,%esp
 a13:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a18:	6a 01                	push   $0x1
 a1a:	e9 73 ff ff ff       	jmp    992 <printf+0xf2>
 a1f:	90                   	nop
  write(fd, &c, 1);
 a20:	83 ec 04             	sub    $0x4,%esp
 a23:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 a26:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 a29:	6a 01                	push   $0x1
 a2b:	e9 21 ff ff ff       	jmp    951 <printf+0xb1>
        putc(fd, *ap);
 a30:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 a33:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a36:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 a38:	6a 01                	push   $0x1
        ap++;
 a3a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 a3d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 a40:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 a43:	50                   	push   %eax
 a44:	ff 75 08             	pushl  0x8(%ebp)
 a47:	e8 16 fd ff ff       	call   762 <write>
        ap++;
 a4c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 a4f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a52:	31 ff                	xor    %edi,%edi
 a54:	e9 8f fe ff ff       	jmp    8e8 <printf+0x48>
          s = "(null)";
 a59:	bb 13 0d 00 00       	mov    $0xd13,%ebx
        while(*s != 0){
 a5e:	b8 28 00 00 00       	mov    $0x28,%eax
 a63:	e9 72 ff ff ff       	jmp    9da <printf+0x13a>
 a68:	66 90                	xchg   %ax,%ax
 a6a:	66 90                	xchg   %ax,%ax
 a6c:	66 90                	xchg   %ax,%ax
 a6e:	66 90                	xchg   %ax,%ax

00000a70 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a70:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a71:	a1 44 10 00 00       	mov    0x1044,%eax
{
 a76:	89 e5                	mov    %esp,%ebp
 a78:	57                   	push   %edi
 a79:	56                   	push   %esi
 a7a:	53                   	push   %ebx
 a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 a7e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a88:	39 c8                	cmp    %ecx,%eax
 a8a:	8b 10                	mov    (%eax),%edx
 a8c:	73 32                	jae    ac0 <free+0x50>
 a8e:	39 d1                	cmp    %edx,%ecx
 a90:	72 04                	jb     a96 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a92:	39 d0                	cmp    %edx,%eax
 a94:	72 32                	jb     ac8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a96:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a99:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a9c:	39 fa                	cmp    %edi,%edx
 a9e:	74 30                	je     ad0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 aa0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 aa3:	8b 50 04             	mov    0x4(%eax),%edx
 aa6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 aa9:	39 f1                	cmp    %esi,%ecx
 aab:	74 3a                	je     ae7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 aad:	89 08                	mov    %ecx,(%eax)
  freep = p;
 aaf:	a3 44 10 00 00       	mov    %eax,0x1044
}
 ab4:	5b                   	pop    %ebx
 ab5:	5e                   	pop    %esi
 ab6:	5f                   	pop    %edi
 ab7:	5d                   	pop    %ebp
 ab8:	c3                   	ret    
 ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ac0:	39 d0                	cmp    %edx,%eax
 ac2:	72 04                	jb     ac8 <free+0x58>
 ac4:	39 d1                	cmp    %edx,%ecx
 ac6:	72 ce                	jb     a96 <free+0x26>
{
 ac8:	89 d0                	mov    %edx,%eax
 aca:	eb bc                	jmp    a88 <free+0x18>
 acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 ad0:	03 72 04             	add    0x4(%edx),%esi
 ad3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ad6:	8b 10                	mov    (%eax),%edx
 ad8:	8b 12                	mov    (%edx),%edx
 ada:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 add:	8b 50 04             	mov    0x4(%eax),%edx
 ae0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ae3:	39 f1                	cmp    %esi,%ecx
 ae5:	75 c6                	jne    aad <free+0x3d>
    p->s.size += bp->s.size;
 ae7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 aea:	a3 44 10 00 00       	mov    %eax,0x1044
    p->s.size += bp->s.size;
 aef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 af2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 af5:	89 10                	mov    %edx,(%eax)
}
 af7:	5b                   	pop    %ebx
 af8:	5e                   	pop    %esi
 af9:	5f                   	pop    %edi
 afa:	5d                   	pop    %ebp
 afb:	c3                   	ret    
 afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b00 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b00:	55                   	push   %ebp
 b01:	89 e5                	mov    %esp,%ebp
 b03:	57                   	push   %edi
 b04:	56                   	push   %esi
 b05:	53                   	push   %ebx
 b06:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b09:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b0c:	8b 15 44 10 00 00    	mov    0x1044,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b12:	8d 78 07             	lea    0x7(%eax),%edi
 b15:	c1 ef 03             	shr    $0x3,%edi
 b18:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 b1b:	85 d2                	test   %edx,%edx
 b1d:	0f 84 9d 00 00 00    	je     bc0 <malloc+0xc0>
 b23:	8b 02                	mov    (%edx),%eax
 b25:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 b28:	39 cf                	cmp    %ecx,%edi
 b2a:	76 6c                	jbe    b98 <malloc+0x98>
 b2c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 b32:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b37:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 b3a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 b41:	eb 0e                	jmp    b51 <malloc+0x51>
 b43:	90                   	nop
 b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b48:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 b4a:	8b 48 04             	mov    0x4(%eax),%ecx
 b4d:	39 f9                	cmp    %edi,%ecx
 b4f:	73 47                	jae    b98 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b51:	39 05 44 10 00 00    	cmp    %eax,0x1044
 b57:	89 c2                	mov    %eax,%edx
 b59:	75 ed                	jne    b48 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 b5b:	83 ec 0c             	sub    $0xc,%esp
 b5e:	56                   	push   %esi
 b5f:	e8 66 fc ff ff       	call   7ca <sbrk>
  if(p == (char*)-1)
 b64:	83 c4 10             	add    $0x10,%esp
 b67:	83 f8 ff             	cmp    $0xffffffff,%eax
 b6a:	74 1c                	je     b88 <malloc+0x88>
  hp->s.size = nu;
 b6c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 b6f:	83 ec 0c             	sub    $0xc,%esp
 b72:	83 c0 08             	add    $0x8,%eax
 b75:	50                   	push   %eax
 b76:	e8 f5 fe ff ff       	call   a70 <free>
  return freep;
 b7b:	8b 15 44 10 00 00    	mov    0x1044,%edx
      if((p = morecore(nunits)) == 0)
 b81:	83 c4 10             	add    $0x10,%esp
 b84:	85 d2                	test   %edx,%edx
 b86:	75 c0                	jne    b48 <malloc+0x48>
        return 0;
  }
}
 b88:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 b8b:	31 c0                	xor    %eax,%eax
}
 b8d:	5b                   	pop    %ebx
 b8e:	5e                   	pop    %esi
 b8f:	5f                   	pop    %edi
 b90:	5d                   	pop    %ebp
 b91:	c3                   	ret    
 b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 b98:	39 cf                	cmp    %ecx,%edi
 b9a:	74 54                	je     bf0 <malloc+0xf0>
        p->s.size -= nunits;
 b9c:	29 f9                	sub    %edi,%ecx
 b9e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 ba1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 ba4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 ba7:	89 15 44 10 00 00    	mov    %edx,0x1044
}
 bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 bb0:	83 c0 08             	add    $0x8,%eax
}
 bb3:	5b                   	pop    %ebx
 bb4:	5e                   	pop    %esi
 bb5:	5f                   	pop    %edi
 bb6:	5d                   	pop    %ebp
 bb7:	c3                   	ret    
 bb8:	90                   	nop
 bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 bc0:	c7 05 44 10 00 00 48 	movl   $0x1048,0x1044
 bc7:	10 00 00 
 bca:	c7 05 48 10 00 00 48 	movl   $0x1048,0x1048
 bd1:	10 00 00 
    base.s.size = 0;
 bd4:	b8 48 10 00 00       	mov    $0x1048,%eax
 bd9:	c7 05 4c 10 00 00 00 	movl   $0x0,0x104c
 be0:	00 00 00 
 be3:	e9 44 ff ff ff       	jmp    b2c <malloc+0x2c>
 be8:	90                   	nop
 be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 bf0:	8b 08                	mov    (%eax),%ecx
 bf2:	89 0a                	mov    %ecx,(%edx)
 bf4:	eb b1                	jmp    ba7 <malloc+0xa7>
