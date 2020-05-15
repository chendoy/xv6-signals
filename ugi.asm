
_ugi:     file format elf32-i386


Disassembly of section .text:

00000000 <custom_handler>:
    }
}

void
custom_handler(int signum)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 10             	sub    $0x10,%esp
    printf(1, "child: CUSTOM HANDLER WAS FIRED!!\n");
   6:	68 3c 0b 00 00       	push   $0xb3c
   b:	6a 01                	push   $0x1
   d:	e8 71 08 00 00       	call   883 <printf>
    return;
  12:	83 c4 10             	add    $0x10,%esp
}
  15:	c9                   	leave  
  16:	c3                   	ret    

00000017 <test_1>:
{
  17:	55                   	push   %ebp
  18:	89 e5                	mov    %esp,%ebp
  1a:	56                   	push   %esi
  1b:	53                   	push   %ebx
  1c:	83 ec 10             	sub    $0x10,%esp
    for(i = 1; i < 10; i++) {
  1f:	bb 01 00 00 00       	mov    $0x1,%ebx
  24:	eb 20                	jmp    46 <test_1+0x2f>
        omask = sigprocmask(mask);
  26:	83 ec 0c             	sub    $0xc,%esp
  29:	53                   	push   %ebx
  2a:	e8 a2 07 00 00       	call   7d1 <sigprocmask>
        printf(1, "need to be %d = %d\n", i-1 ,omask);
  2f:	50                   	push   %eax
  30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  33:	50                   	push   %eax
  34:	68 60 0b 00 00       	push   $0xb60
  39:	6a 01                	push   $0x1
  3b:	e8 43 08 00 00       	call   883 <printf>
    for(i = 1; i < 10; i++) {
  40:	83 c3 01             	add    $0x1,%ebx
  43:	83 c4 20             	add    $0x20,%esp
  46:	83 fb 09             	cmp    $0x9,%ebx
  49:	76 db                	jbe    26 <test_1+0xf>
    newact.sa_handler = SIG_IGN;
  4b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    newact.sigmask = 12;
  52:	c7 45 ec 0c 00 00 00 	movl   $0xc,-0x14(%ebp)
    sigaction(12, &newact, &oldact);
  59:	83 ec 04             	sub    $0x4,%esp
  5c:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  5f:	53                   	push   %ebx
  60:	8d 75 e8             	lea    -0x18(%ebp),%esi
  63:	56                   	push   %esi
  64:	6a 0c                	push   $0xc
  66:	e8 6e 07 00 00       	call   7d9 <sigaction>
    printf(1, "Need to be 0,0 = %d,%d\n", (uint)oldact.sa_handler, oldact.sigmask);
  6b:	ff 75 f4             	pushl  -0xc(%ebp)
  6e:	ff 75 f0             	pushl  -0x10(%ebp)
  71:	68 74 0b 00 00       	push   $0xb74
  76:	6a 01                	push   $0x1
  78:	e8 06 08 00 00       	call   883 <printf>
    sigaction(12, &oldact, &newact);
  7d:	83 c4 1c             	add    $0x1c,%esp
  80:	56                   	push   %esi
  81:	53                   	push   %ebx
  82:	6a 0c                	push   $0xc
  84:	e8 50 07 00 00       	call   7d9 <sigaction>
    printf(1, "Need to be 1,12 = %d,%d\n", (uint)newact.sa_handler, newact.sigmask);
  89:	ff 75 ec             	pushl  -0x14(%ebp)
  8c:	ff 75 e8             	pushl  -0x18(%ebp)
  8f:	68 8c 0b 00 00       	push   $0xb8c
  94:	6a 01                	push   $0x1
  96:	e8 e8 07 00 00       	call   883 <printf>
}
  9b:	83 c4 20             	add    $0x20,%esp
  9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  a1:	5b                   	pop    %ebx
  a2:	5e                   	pop    %esi
  a3:	5d                   	pop    %ebp
  a4:	c3                   	ret    

000000a5 <test_2>:
{
  a5:	55                   	push   %ebp
  a6:	89 e5                	mov    %esp,%ebp
  a8:	56                   	push   %esi
  a9:	53                   	push   %ebx
  aa:	83 ec 10             	sub    $0x10,%esp
    int sigs[] = {SIGSTOP, SIGCONT};
  ad:	c7 45 f0 11 00 00 00 	movl   $0x11,-0x10(%ebp)
  b4:	c7 45 f4 13 00 00 00 	movl   $0x13,-0xc(%ebp)
    if((pid = fork()) == 0) {
  bb:	e8 69 06 00 00       	call   729 <fork>
  c0:	85 c0                	test   %eax,%eax
  c2:	0f 85 22 03 00 00    	jne    3ea <test_2+0x345>
            sleep(5);printf(1, "a");sleep(5);printf(1, "b");sleep(5);printf(1, "c");sleep(5);printf(1, "d");
  c8:	83 ec 0c             	sub    $0xc,%esp
  cb:	6a 05                	push   $0x5
  cd:	e8 ef 06 00 00       	call   7c1 <sleep>
  d2:	83 c4 08             	add    $0x8,%esp
  d5:	68 a5 0b 00 00       	push   $0xba5
  da:	6a 01                	push   $0x1
  dc:	e8 a2 07 00 00       	call   883 <printf>
  e1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  e8:	e8 d4 06 00 00       	call   7c1 <sleep>
  ed:	83 c4 08             	add    $0x8,%esp
  f0:	68 a7 0b 00 00       	push   $0xba7
  f5:	6a 01                	push   $0x1
  f7:	e8 87 07 00 00       	call   883 <printf>
  fc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 103:	e8 b9 06 00 00       	call   7c1 <sleep>
 108:	83 c4 08             	add    $0x8,%esp
 10b:	68 a9 0b 00 00       	push   $0xba9
 110:	6a 01                	push   $0x1
 112:	e8 6c 07 00 00       	call   883 <printf>
 117:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 11e:	e8 9e 06 00 00       	call   7c1 <sleep>
 123:	83 c4 08             	add    $0x8,%esp
 126:	68 ab 0b 00 00       	push   $0xbab
 12b:	6a 01                	push   $0x1
 12d:	e8 51 07 00 00       	call   883 <printf>
            sleep(5);printf(1, "e");sleep(5);printf(1, "f");sleep(5);printf(1, "g");sleep(5);printf(1, "h");
 132:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 139:	e8 83 06 00 00       	call   7c1 <sleep>
 13e:	83 c4 08             	add    $0x8,%esp
 141:	68 ad 0b 00 00       	push   $0xbad
 146:	6a 01                	push   $0x1
 148:	e8 36 07 00 00       	call   883 <printf>
 14d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 154:	e8 68 06 00 00       	call   7c1 <sleep>
 159:	83 c4 08             	add    $0x8,%esp
 15c:	68 af 0b 00 00       	push   $0xbaf
 161:	6a 01                	push   $0x1
 163:	e8 1b 07 00 00       	call   883 <printf>
 168:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 16f:	e8 4d 06 00 00       	call   7c1 <sleep>
 174:	83 c4 08             	add    $0x8,%esp
 177:	68 b1 0b 00 00       	push   $0xbb1
 17c:	6a 01                	push   $0x1
 17e:	e8 00 07 00 00       	call   883 <printf>
 183:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 18a:	e8 32 06 00 00       	call   7c1 <sleep>
 18f:	83 c4 08             	add    $0x8,%esp
 192:	68 b3 0b 00 00       	push   $0xbb3
 197:	6a 01                	push   $0x1
 199:	e8 e5 06 00 00       	call   883 <printf>
            sleep(5);printf(1, "i");sleep(5);printf(1, "j");sleep(5);printf(1, "k");sleep(5);printf(1, "l");
 19e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1a5:	e8 17 06 00 00       	call   7c1 <sleep>
 1aa:	83 c4 08             	add    $0x8,%esp
 1ad:	68 b5 0b 00 00       	push   $0xbb5
 1b2:	6a 01                	push   $0x1
 1b4:	e8 ca 06 00 00       	call   883 <printf>
 1b9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1c0:	e8 fc 05 00 00       	call   7c1 <sleep>
 1c5:	83 c4 08             	add    $0x8,%esp
 1c8:	68 b7 0b 00 00       	push   $0xbb7
 1cd:	6a 01                	push   $0x1
 1cf:	e8 af 06 00 00       	call   883 <printf>
 1d4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1db:	e8 e1 05 00 00       	call   7c1 <sleep>
 1e0:	83 c4 08             	add    $0x8,%esp
 1e3:	68 b9 0b 00 00       	push   $0xbb9
 1e8:	6a 01                	push   $0x1
 1ea:	e8 94 06 00 00       	call   883 <printf>
 1ef:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1f6:	e8 c6 05 00 00       	call   7c1 <sleep>
 1fb:	83 c4 08             	add    $0x8,%esp
 1fe:	68 bb 0b 00 00       	push   $0xbbb
 203:	6a 01                	push   $0x1
 205:	e8 79 06 00 00       	call   883 <printf>
            sleep(5);printf(1, "m");sleep(5);printf(1, "n");sleep(5);printf(1, "o");sleep(5);printf(1, "p");
 20a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 211:	e8 ab 05 00 00       	call   7c1 <sleep>
 216:	83 c4 08             	add    $0x8,%esp
 219:	68 bd 0b 00 00       	push   $0xbbd
 21e:	6a 01                	push   $0x1
 220:	e8 5e 06 00 00       	call   883 <printf>
 225:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 22c:	e8 90 05 00 00       	call   7c1 <sleep>
 231:	83 c4 08             	add    $0x8,%esp
 234:	68 bf 0b 00 00       	push   $0xbbf
 239:	6a 01                	push   $0x1
 23b:	e8 43 06 00 00       	call   883 <printf>
 240:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 247:	e8 75 05 00 00       	call   7c1 <sleep>
 24c:	83 c4 08             	add    $0x8,%esp
 24f:	68 c1 0b 00 00       	push   $0xbc1
 254:	6a 01                	push   $0x1
 256:	e8 28 06 00 00       	call   883 <printf>
 25b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 262:	e8 5a 05 00 00       	call   7c1 <sleep>
 267:	83 c4 08             	add    $0x8,%esp
 26a:	68 c3 0b 00 00       	push   $0xbc3
 26f:	6a 01                	push   $0x1
 271:	e8 0d 06 00 00       	call   883 <printf>
            sleep(5);printf(1, "q");sleep(5);printf(1, "r");sleep(5);printf(1, "s");sleep(5);printf(1, "t");
 276:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 27d:	e8 3f 05 00 00       	call   7c1 <sleep>
 282:	83 c4 08             	add    $0x8,%esp
 285:	68 c5 0b 00 00       	push   $0xbc5
 28a:	6a 01                	push   $0x1
 28c:	e8 f2 05 00 00       	call   883 <printf>
 291:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 298:	e8 24 05 00 00       	call   7c1 <sleep>
 29d:	83 c4 08             	add    $0x8,%esp
 2a0:	68 c7 0b 00 00       	push   $0xbc7
 2a5:	6a 01                	push   $0x1
 2a7:	e8 d7 05 00 00       	call   883 <printf>
 2ac:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2b3:	e8 09 05 00 00       	call   7c1 <sleep>
 2b8:	83 c4 08             	add    $0x8,%esp
 2bb:	68 c9 0b 00 00       	push   $0xbc9
 2c0:	6a 01                	push   $0x1
 2c2:	e8 bc 05 00 00       	call   883 <printf>
 2c7:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2ce:	e8 ee 04 00 00       	call   7c1 <sleep>
 2d3:	83 c4 08             	add    $0x8,%esp
 2d6:	68 cb 0b 00 00       	push   $0xbcb
 2db:	6a 01                	push   $0x1
 2dd:	e8 a1 05 00 00       	call   883 <printf>
            sleep(5);printf(1, "u");sleep(5);printf(1, "v");sleep(5);printf(1, "w");sleep(5);printf(1, "x");
 2e2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2e9:	e8 d3 04 00 00       	call   7c1 <sleep>
 2ee:	83 c4 08             	add    $0x8,%esp
 2f1:	68 cd 0b 00 00       	push   $0xbcd
 2f6:	6a 01                	push   $0x1
 2f8:	e8 86 05 00 00       	call   883 <printf>
 2fd:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 304:	e8 b8 04 00 00       	call   7c1 <sleep>
 309:	83 c4 08             	add    $0x8,%esp
 30c:	68 cf 0b 00 00       	push   $0xbcf
 311:	6a 01                	push   $0x1
 313:	e8 6b 05 00 00       	call   883 <printf>
 318:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 31f:	e8 9d 04 00 00       	call   7c1 <sleep>
 324:	83 c4 08             	add    $0x8,%esp
 327:	68 d1 0b 00 00       	push   $0xbd1
 32c:	6a 01                	push   $0x1
 32e:	e8 50 05 00 00       	call   883 <printf>
 333:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 33a:	e8 82 04 00 00       	call   7c1 <sleep>
 33f:	83 c4 08             	add    $0x8,%esp
 342:	68 d3 0b 00 00       	push   $0xbd3
 347:	6a 01                	push   $0x1
 349:	e8 35 05 00 00       	call   883 <printf>
            sleep(5);printf(1, "y");sleep(5);printf(1, "z");
 34e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 355:	e8 67 04 00 00       	call   7c1 <sleep>
 35a:	83 c4 08             	add    $0x8,%esp
 35d:	68 d5 0b 00 00       	push   $0xbd5
 362:	6a 01                	push   $0x1
 364:	e8 1a 05 00 00       	call   883 <printf>
 369:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 370:	e8 4c 04 00 00       	call   7c1 <sleep>
 375:	83 c4 08             	add    $0x8,%esp
 378:	68 d7 0b 00 00       	push   $0xbd7
 37d:	6a 01                	push   $0x1
 37f:	e8 ff 04 00 00       	call   883 <printf>
 384:	83 c4 10             	add    $0x10,%esp
 387:	e9 3c fd ff ff       	jmp    c8 <test_2+0x23>
                printf(2, "\n%d: STOP!!!\n", i);    
 38c:	83 ec 04             	sub    $0x4,%esp
 38f:	53                   	push   %ebx
 390:	68 e7 0b 00 00       	push   $0xbe7
 395:	6a 02                	push   $0x2
 397:	e8 e7 04 00 00       	call   883 <printf>
 39c:	83 c4 10             	add    $0x10,%esp
            kill(pid, sigs[i%2]);
 39f:	89 da                	mov    %ebx,%edx
 3a1:	c1 ea 1f             	shr    $0x1f,%edx
 3a4:	8d 04 13             	lea    (%ebx,%edx,1),%eax
 3a7:	83 e0 01             	and    $0x1,%eax
 3aa:	29 d0                	sub    %edx,%eax
 3ac:	83 ec 08             	sub    $0x8,%esp
 3af:	ff 74 85 f0          	pushl  -0x10(%ebp,%eax,4)
 3b3:	56                   	push   %esi
 3b4:	e8 a8 03 00 00       	call   761 <kill>
            sleep(30);
 3b9:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
 3c0:	e8 fc 03 00 00       	call   7c1 <sleep>
        for (int i = 0; i < 20; i++)
 3c5:	83 c3 01             	add    $0x1,%ebx
 3c8:	83 c4 10             	add    $0x10,%esp
 3cb:	83 fb 13             	cmp    $0x13,%ebx
 3ce:	7f 23                	jg     3f3 <test_2+0x34e>
            if (i % 2)
 3d0:	f6 c3 01             	test   $0x1,%bl
 3d3:	74 b7                	je     38c <test_2+0x2e7>
                printf(2, "\n%d: CONT!!!\n", i);
 3d5:	83 ec 04             	sub    $0x4,%esp
 3d8:	53                   	push   %ebx
 3d9:	68 d9 0b 00 00       	push   $0xbd9
 3de:	6a 02                	push   $0x2
 3e0:	e8 9e 04 00 00       	call   883 <printf>
 3e5:	83 c4 10             	add    $0x10,%esp
 3e8:	eb b5                	jmp    39f <test_2+0x2fa>
 3ea:	89 c6                	mov    %eax,%esi
        for (int i = 0; i < 20; i++)
 3ec:	bb 00 00 00 00       	mov    $0x0,%ebx
 3f1:	eb d8                	jmp    3cb <test_2+0x326>
        printf(1, "\nKILL pid : %d!!!\n", pid);
 3f3:	83 ec 04             	sub    $0x4,%esp
 3f6:	56                   	push   %esi
 3f7:	68 f5 0b 00 00       	push   $0xbf5
 3fc:	6a 01                	push   $0x1
 3fe:	e8 80 04 00 00       	call   883 <printf>
        kill(pid, SIGKILL);
 403:	83 c4 08             	add    $0x8,%esp
 406:	6a 09                	push   $0x9
 408:	56                   	push   %esi
 409:	e8 53 03 00 00       	call   761 <kill>
        wait();
 40e:	e8 26 03 00 00       	call   739 <wait>
        exit();
 413:	e8 19 03 00 00       	call   731 <exit>

00000418 <test_3>:

// user space handlers
void
test_3()
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	53                   	push   %ebx
 41c:	83 ec 14             	sub    $0x14,%esp
    struct sigaction act;
    uint mask = 0;
    uint pid;

    act.sa_handler = &custom_handler;
 41f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    act.sigmask = mask;
 426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    if((pid = fork()) == 0) 
 42d:	e8 f7 02 00 00       	call   729 <fork>
 432:	85 c0                	test   %eax,%eax
 434:	75 33                	jne    469 <test_3+0x51>
    {
        sigaction(SIGTEST, &act, null); // register custom handler
 436:	83 ec 04             	sub    $0x4,%esp
 439:	6a 00                	push   $0x0
 43b:	8d 45 f0             	lea    -0x10(%ebp),%eax
 43e:	50                   	push   %eax
 43f:	6a 14                	push   $0x14
 441:	e8 93 03 00 00       	call   7d9 <sigaction>
 446:	83 c4 10             	add    $0x10,%esp

        while(1)
        {
            printf(1, "child: waiting...\n");
 449:	83 ec 08             	sub    $0x8,%esp
 44c:	68 08 0c 00 00       	push   $0xc08
 451:	6a 01                	push   $0x1
 453:	e8 2b 04 00 00       	call   883 <printf>
            sleep(30);
 458:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
 45f:	e8 5d 03 00 00       	call   7c1 <sleep>
 464:	83 c4 10             	add    $0x10,%esp
 467:	eb e0                	jmp    449 <test_3+0x31>
 469:	89 c3                	mov    %eax,%ebx
        }
    }

    else
    {
        sleep(300); // let child print some lines
 46b:	83 ec 0c             	sub    $0xc,%esp
 46e:	68 2c 01 00 00       	push   $0x12c
 473:	e8 49 03 00 00       	call   7c1 <sleep>
        printf(1, "parent: kill(child, SIGTEST)\n");
 478:	83 c4 08             	add    $0x8,%esp
 47b:	68 1b 0c 00 00       	push   $0xc1b
 480:	6a 01                	push   $0x1
 482:	e8 fc 03 00 00       	call   883 <printf>
        sleep(5);
 487:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 48e:	e8 2e 03 00 00       	call   7c1 <sleep>
        kill(pid, SIGTEST);
 493:	83 c4 08             	add    $0x8,%esp
 496:	6a 14                	push   $0x14
 498:	53                   	push   %ebx
 499:	e8 c3 02 00 00       	call   761 <kill>
        sleep(50);
 49e:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
 4a5:	e8 17 03 00 00       	call   7c1 <sleep>
        printf(1, "parent: kill(child, SIGKILL)\n");
 4aa:	83 c4 08             	add    $0x8,%esp
 4ad:	68 39 0c 00 00       	push   $0xc39
 4b2:	6a 01                	push   $0x1
 4b4:	e8 ca 03 00 00       	call   883 <printf>
        kill(pid, SIGKILL);
 4b9:	83 c4 08             	add    $0x8,%esp
 4bc:	6a 09                	push   $0x9
 4be:	53                   	push   %ebx
 4bf:	e8 9d 02 00 00       	call   761 <kill>
        wait();
 4c4:	e8 70 02 00 00       	call   739 <wait>
        exit();
 4c9:	e8 63 02 00 00       	call   731 <exit>

000004ce <test_4>:
}

// SIG_IGN test
void
test_4()
{
 4ce:	55                   	push   %ebp
 4cf:	89 e5                	mov    %esp,%ebp
 4d1:	53                   	push   %ebx
 4d2:	83 ec 14             	sub    $0x14,%esp
    struct sigaction act;
    uint mask = 0;
    uint pid;

    act.sa_handler = SIG_IGN;
 4d5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    act.sigmask = mask;
 4dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    if((pid = fork()) == 0) 
 4e3:	e8 41 02 00 00       	call   729 <fork>
 4e8:	85 c0                	test   %eax,%eax
 4ea:	75 33                	jne    51f <test_4+0x51>
    {
        sigaction(SIGTEST, &act, null); // register custom handler
 4ec:	83 ec 04             	sub    $0x4,%esp
 4ef:	6a 00                	push   $0x0
 4f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
 4f4:	50                   	push   %eax
 4f5:	6a 14                	push   $0x14
 4f7:	e8 dd 02 00 00       	call   7d9 <sigaction>
 4fc:	83 c4 10             	add    $0x10,%esp

        while(1)
        {
            printf(1, "child: waiting...\n");
 4ff:	83 ec 08             	sub    $0x8,%esp
 502:	68 08 0c 00 00       	push   $0xc08
 507:	6a 01                	push   $0x1
 509:	e8 75 03 00 00       	call   883 <printf>
            sleep(30);
 50e:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
 515:	e8 a7 02 00 00       	call   7c1 <sleep>
 51a:	83 c4 10             	add    $0x10,%esp
 51d:	eb e0                	jmp    4ff <test_4+0x31>
 51f:	89 c3                	mov    %eax,%ebx
        }
    }

    else
    {
        sleep(300); // let child print some lines
 521:	83 ec 0c             	sub    $0xc,%esp
 524:	68 2c 01 00 00       	push   $0x12c
 529:	e8 93 02 00 00       	call   7c1 <sleep>
        printf(1, "parent: kill(child, SIGTEST)\n");
 52e:	83 c4 08             	add    $0x8,%esp
 531:	68 1b 0c 00 00       	push   $0xc1b
 536:	6a 01                	push   $0x1
 538:	e8 46 03 00 00       	call   883 <printf>
        sleep(5);
 53d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 544:	e8 78 02 00 00       	call   7c1 <sleep>
        kill(pid, SIGTEST);
 549:	83 c4 08             	add    $0x8,%esp
 54c:	6a 14                	push   $0x14
 54e:	53                   	push   %ebx
 54f:	e8 0d 02 00 00       	call   761 <kill>
        sleep(50);
 554:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
 55b:	e8 61 02 00 00       	call   7c1 <sleep>
        printf(1, "parent: kill(child, SIGKILL)\n");
 560:	83 c4 08             	add    $0x8,%esp
 563:	68 39 0c 00 00       	push   $0xc39
 568:	6a 01                	push   $0x1
 56a:	e8 14 03 00 00       	call   883 <printf>
        kill(pid, SIGKILL);
 56f:	83 c4 08             	add    $0x8,%esp
 572:	6a 09                	push   $0x9
 574:	53                   	push   %ebx
 575:	e8 e7 01 00 00       	call   761 <kill>
        wait();
 57a:	e8 ba 01 00 00       	call   739 <wait>
        exit();
 57f:	e8 ad 01 00 00       	call   731 <exit>

00000584 <test_5>:
}

// sigmask test
void
test_5()
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp

}
 587:	5d                   	pop    %ebp
 588:	c3                   	ret    

00000589 <test_6>:

// multiple user handlers test
void
test_6()
{
 589:	55                   	push   %ebp
 58a:	89 e5                	mov    %esp,%ebp

}
 58c:	5d                   	pop    %ebp
 58d:	c3                   	ret    

0000058e <main>:


int main()
{
 58e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 592:	83 e4 f0             	and    $0xfffffff0,%esp
 595:	ff 71 fc             	pushl  -0x4(%ecx)
 598:	55                   	push   %ebp
 599:	89 e5                	mov    %esp,%ebp
 59b:	51                   	push   %ecx
 59c:	83 ec 04             	sub    $0x4,%esp
        // test_1();
        test_2(); 
 59f:	e8 01 fb ff ff       	call   a5 <test_2>

000005a4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	53                   	push   %ebx
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5ae:	89 c2                	mov    %eax,%edx
 5b0:	0f b6 19             	movzbl (%ecx),%ebx
 5b3:	88 1a                	mov    %bl,(%edx)
 5b5:	8d 52 01             	lea    0x1(%edx),%edx
 5b8:	8d 49 01             	lea    0x1(%ecx),%ecx
 5bb:	84 db                	test   %bl,%bl
 5bd:	75 f1                	jne    5b0 <strcpy+0xc>
    ;
  return os;
}
 5bf:	5b                   	pop    %ebx
 5c0:	5d                   	pop    %ebp
 5c1:	c3                   	ret    

000005c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5c2:	55                   	push   %ebp
 5c3:	89 e5                	mov    %esp,%ebp
 5c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 5cb:	eb 06                	jmp    5d3 <strcmp+0x11>
    p++, q++;
 5cd:	83 c1 01             	add    $0x1,%ecx
 5d0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 5d3:	0f b6 01             	movzbl (%ecx),%eax
 5d6:	84 c0                	test   %al,%al
 5d8:	74 04                	je     5de <strcmp+0x1c>
 5da:	3a 02                	cmp    (%edx),%al
 5dc:	74 ef                	je     5cd <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 5de:	0f b6 c0             	movzbl %al,%eax
 5e1:	0f b6 12             	movzbl (%edx),%edx
 5e4:	29 d0                	sub    %edx,%eax
}
 5e6:	5d                   	pop    %ebp
 5e7:	c3                   	ret    

000005e8 <strlen>:

uint
strlen(const char *s)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 5ee:	ba 00 00 00 00       	mov    $0x0,%edx
 5f3:	eb 03                	jmp    5f8 <strlen+0x10>
 5f5:	83 c2 01             	add    $0x1,%edx
 5f8:	89 d0                	mov    %edx,%eax
 5fa:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 5fe:	75 f5                	jne    5f5 <strlen+0xd>
    ;
  return n;
}
 600:	5d                   	pop    %ebp
 601:	c3                   	ret    

00000602 <memset>:

void*
memset(void *dst, int c, uint n)
{
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
 605:	57                   	push   %edi
 606:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 609:	89 d7                	mov    %edx,%edi
 60b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 60e:	8b 45 0c             	mov    0xc(%ebp),%eax
 611:	fc                   	cld    
 612:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 614:	89 d0                	mov    %edx,%eax
 616:	5f                   	pop    %edi
 617:	5d                   	pop    %ebp
 618:	c3                   	ret    

00000619 <strchr>:

char*
strchr(const char *s, char c)
{
 619:	55                   	push   %ebp
 61a:	89 e5                	mov    %esp,%ebp
 61c:	8b 45 08             	mov    0x8(%ebp),%eax
 61f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 623:	0f b6 10             	movzbl (%eax),%edx
 626:	84 d2                	test   %dl,%dl
 628:	74 09                	je     633 <strchr+0x1a>
    if(*s == c)
 62a:	38 ca                	cmp    %cl,%dl
 62c:	74 0a                	je     638 <strchr+0x1f>
  for(; *s; s++)
 62e:	83 c0 01             	add    $0x1,%eax
 631:	eb f0                	jmp    623 <strchr+0xa>
      return (char*)s;
  return 0;
 633:	b8 00 00 00 00       	mov    $0x0,%eax
}
 638:	5d                   	pop    %ebp
 639:	c3                   	ret    

0000063a <gets>:

char*
gets(char *buf, int max)
{
 63a:	55                   	push   %ebp
 63b:	89 e5                	mov    %esp,%ebp
 63d:	57                   	push   %edi
 63e:	56                   	push   %esi
 63f:	53                   	push   %ebx
 640:	83 ec 1c             	sub    $0x1c,%esp
 643:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 646:	bb 00 00 00 00       	mov    $0x0,%ebx
 64b:	8d 73 01             	lea    0x1(%ebx),%esi
 64e:	3b 75 0c             	cmp    0xc(%ebp),%esi
 651:	7d 2e                	jge    681 <gets+0x47>
    cc = read(0, &c, 1);
 653:	83 ec 04             	sub    $0x4,%esp
 656:	6a 01                	push   $0x1
 658:	8d 45 e7             	lea    -0x19(%ebp),%eax
 65b:	50                   	push   %eax
 65c:	6a 00                	push   $0x0
 65e:	e8 e6 00 00 00       	call   749 <read>
    if(cc < 1)
 663:	83 c4 10             	add    $0x10,%esp
 666:	85 c0                	test   %eax,%eax
 668:	7e 17                	jle    681 <gets+0x47>
      break;
    buf[i++] = c;
 66a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 66e:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 671:	3c 0a                	cmp    $0xa,%al
 673:	0f 94 c2             	sete   %dl
 676:	3c 0d                	cmp    $0xd,%al
 678:	0f 94 c0             	sete   %al
    buf[i++] = c;
 67b:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 67d:	08 c2                	or     %al,%dl
 67f:	74 ca                	je     64b <gets+0x11>
      break;
  }
  buf[i] = '\0';
 681:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 685:	89 f8                	mov    %edi,%eax
 687:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68a:	5b                   	pop    %ebx
 68b:	5e                   	pop    %esi
 68c:	5f                   	pop    %edi
 68d:	5d                   	pop    %ebp
 68e:	c3                   	ret    

0000068f <stat>:

int
stat(const char *n, struct stat *st)
{
 68f:	55                   	push   %ebp
 690:	89 e5                	mov    %esp,%ebp
 692:	56                   	push   %esi
 693:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 694:	83 ec 08             	sub    $0x8,%esp
 697:	6a 00                	push   $0x0
 699:	ff 75 08             	pushl  0x8(%ebp)
 69c:	e8 d0 00 00 00       	call   771 <open>
  if(fd < 0)
 6a1:	83 c4 10             	add    $0x10,%esp
 6a4:	85 c0                	test   %eax,%eax
 6a6:	78 24                	js     6cc <stat+0x3d>
 6a8:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 6aa:	83 ec 08             	sub    $0x8,%esp
 6ad:	ff 75 0c             	pushl  0xc(%ebp)
 6b0:	50                   	push   %eax
 6b1:	e8 d3 00 00 00       	call   789 <fstat>
 6b6:	89 c6                	mov    %eax,%esi
  close(fd);
 6b8:	89 1c 24             	mov    %ebx,(%esp)
 6bb:	e8 99 00 00 00       	call   759 <close>
  return r;
 6c0:	83 c4 10             	add    $0x10,%esp
}
 6c3:	89 f0                	mov    %esi,%eax
 6c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6c8:	5b                   	pop    %ebx
 6c9:	5e                   	pop    %esi
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret    
    return -1;
 6cc:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6d1:	eb f0                	jmp    6c3 <stat+0x34>

000006d3 <atoi>:

int
atoi(const char *s)
{
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	53                   	push   %ebx
 6d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 6da:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 6df:	eb 10                	jmp    6f1 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 6e1:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
 6e4:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
 6e7:	83 c1 01             	add    $0x1,%ecx
 6ea:	0f be d2             	movsbl %dl,%edx
 6ed:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  while('0' <= *s && *s <= '9')
 6f1:	0f b6 11             	movzbl (%ecx),%edx
 6f4:	8d 5a d0             	lea    -0x30(%edx),%ebx
 6f7:	80 fb 09             	cmp    $0x9,%bl
 6fa:	76 e5                	jbe    6e1 <atoi+0xe>
  return n;
}
 6fc:	5b                   	pop    %ebx
 6fd:	5d                   	pop    %ebp
 6fe:	c3                   	ret    

000006ff <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6ff:	55                   	push   %ebp
 700:	89 e5                	mov    %esp,%ebp
 702:	56                   	push   %esi
 703:	53                   	push   %ebx
 704:	8b 45 08             	mov    0x8(%ebp),%eax
 707:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 70a:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 70d:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 70f:	eb 0d                	jmp    71e <memmove+0x1f>
    *dst++ = *src++;
 711:	0f b6 13             	movzbl (%ebx),%edx
 714:	88 11                	mov    %dl,(%ecx)
 716:	8d 5b 01             	lea    0x1(%ebx),%ebx
 719:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 71c:	89 f2                	mov    %esi,%edx
 71e:	8d 72 ff             	lea    -0x1(%edx),%esi
 721:	85 d2                	test   %edx,%edx
 723:	7f ec                	jg     711 <memmove+0x12>
  return vdst;
}
 725:	5b                   	pop    %ebx
 726:	5e                   	pop    %esi
 727:	5d                   	pop    %ebp
 728:	c3                   	ret    

00000729 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 729:	b8 01 00 00 00       	mov    $0x1,%eax
 72e:	cd 40                	int    $0x40
 730:	c3                   	ret    

00000731 <exit>:
SYSCALL(exit)
 731:	b8 02 00 00 00       	mov    $0x2,%eax
 736:	cd 40                	int    $0x40
 738:	c3                   	ret    

00000739 <wait>:
SYSCALL(wait)
 739:	b8 03 00 00 00       	mov    $0x3,%eax
 73e:	cd 40                	int    $0x40
 740:	c3                   	ret    

00000741 <pipe>:
SYSCALL(pipe)
 741:	b8 04 00 00 00       	mov    $0x4,%eax
 746:	cd 40                	int    $0x40
 748:	c3                   	ret    

00000749 <read>:
SYSCALL(read)
 749:	b8 05 00 00 00       	mov    $0x5,%eax
 74e:	cd 40                	int    $0x40
 750:	c3                   	ret    

00000751 <write>:
SYSCALL(write)
 751:	b8 10 00 00 00       	mov    $0x10,%eax
 756:	cd 40                	int    $0x40
 758:	c3                   	ret    

00000759 <close>:
SYSCALL(close)
 759:	b8 15 00 00 00       	mov    $0x15,%eax
 75e:	cd 40                	int    $0x40
 760:	c3                   	ret    

00000761 <kill>:
SYSCALL(kill)
 761:	b8 06 00 00 00       	mov    $0x6,%eax
 766:	cd 40                	int    $0x40
 768:	c3                   	ret    

00000769 <exec>:
SYSCALL(exec)
 769:	b8 07 00 00 00       	mov    $0x7,%eax
 76e:	cd 40                	int    $0x40
 770:	c3                   	ret    

00000771 <open>:
SYSCALL(open)
 771:	b8 0f 00 00 00       	mov    $0xf,%eax
 776:	cd 40                	int    $0x40
 778:	c3                   	ret    

00000779 <mknod>:
SYSCALL(mknod)
 779:	b8 11 00 00 00       	mov    $0x11,%eax
 77e:	cd 40                	int    $0x40
 780:	c3                   	ret    

00000781 <unlink>:
SYSCALL(unlink)
 781:	b8 12 00 00 00       	mov    $0x12,%eax
 786:	cd 40                	int    $0x40
 788:	c3                   	ret    

00000789 <fstat>:
SYSCALL(fstat)
 789:	b8 08 00 00 00       	mov    $0x8,%eax
 78e:	cd 40                	int    $0x40
 790:	c3                   	ret    

00000791 <link>:
SYSCALL(link)
 791:	b8 13 00 00 00       	mov    $0x13,%eax
 796:	cd 40                	int    $0x40
 798:	c3                   	ret    

00000799 <mkdir>:
SYSCALL(mkdir)
 799:	b8 14 00 00 00       	mov    $0x14,%eax
 79e:	cd 40                	int    $0x40
 7a0:	c3                   	ret    

000007a1 <chdir>:
SYSCALL(chdir)
 7a1:	b8 09 00 00 00       	mov    $0x9,%eax
 7a6:	cd 40                	int    $0x40
 7a8:	c3                   	ret    

000007a9 <dup>:
SYSCALL(dup)
 7a9:	b8 0a 00 00 00       	mov    $0xa,%eax
 7ae:	cd 40                	int    $0x40
 7b0:	c3                   	ret    

000007b1 <getpid>:
SYSCALL(getpid)
 7b1:	b8 0b 00 00 00       	mov    $0xb,%eax
 7b6:	cd 40                	int    $0x40
 7b8:	c3                   	ret    

000007b9 <sbrk>:
SYSCALL(sbrk)
 7b9:	b8 0c 00 00 00       	mov    $0xc,%eax
 7be:	cd 40                	int    $0x40
 7c0:	c3                   	ret    

000007c1 <sleep>:
SYSCALL(sleep)
 7c1:	b8 0d 00 00 00       	mov    $0xd,%eax
 7c6:	cd 40                	int    $0x40
 7c8:	c3                   	ret    

000007c9 <uptime>:
SYSCALL(uptime)
 7c9:	b8 0e 00 00 00       	mov    $0xe,%eax
 7ce:	cd 40                	int    $0x40
 7d0:	c3                   	ret    

000007d1 <sigprocmask>:
SYSCALL(sigprocmask)
 7d1:	b8 16 00 00 00       	mov    $0x16,%eax
 7d6:	cd 40                	int    $0x40
 7d8:	c3                   	ret    

000007d9 <sigaction>:
SYSCALL(sigaction)
 7d9:	b8 17 00 00 00       	mov    $0x17,%eax
 7de:	cd 40                	int    $0x40
 7e0:	c3                   	ret    

000007e1 <sigret>:
SYSCALL(sigret)
 7e1:	b8 18 00 00 00       	mov    $0x18,%eax
 7e6:	cd 40                	int    $0x40
 7e8:	c3                   	ret    

000007e9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7e9:	55                   	push   %ebp
 7ea:	89 e5                	mov    %esp,%ebp
 7ec:	83 ec 1c             	sub    $0x1c,%esp
 7ef:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 7f2:	6a 01                	push   $0x1
 7f4:	8d 55 f4             	lea    -0xc(%ebp),%edx
 7f7:	52                   	push   %edx
 7f8:	50                   	push   %eax
 7f9:	e8 53 ff ff ff       	call   751 <write>
}
 7fe:	83 c4 10             	add    $0x10,%esp
 801:	c9                   	leave  
 802:	c3                   	ret    

00000803 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 803:	55                   	push   %ebp
 804:	89 e5                	mov    %esp,%ebp
 806:	57                   	push   %edi
 807:	56                   	push   %esi
 808:	53                   	push   %ebx
 809:	83 ec 2c             	sub    $0x2c,%esp
 80c:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 80e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 812:	0f 95 c3             	setne  %bl
 815:	89 d0                	mov    %edx,%eax
 817:	c1 e8 1f             	shr    $0x1f,%eax
 81a:	84 c3                	test   %al,%bl
 81c:	74 10                	je     82e <printint+0x2b>
    neg = 1;
    x = -xx;
 81e:	f7 da                	neg    %edx
    neg = 1;
 820:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 827:	be 00 00 00 00       	mov    $0x0,%esi
 82c:	eb 0b                	jmp    839 <printint+0x36>
  neg = 0;
 82e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 835:	eb f0                	jmp    827 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 837:	89 c6                	mov    %eax,%esi
 839:	89 d0                	mov    %edx,%eax
 83b:	ba 00 00 00 00       	mov    $0x0,%edx
 840:	f7 f1                	div    %ecx
 842:	89 c3                	mov    %eax,%ebx
 844:	8d 46 01             	lea    0x1(%esi),%eax
 847:	0f b6 92 60 0c 00 00 	movzbl 0xc60(%edx),%edx
 84e:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 852:	89 da                	mov    %ebx,%edx
 854:	85 db                	test   %ebx,%ebx
 856:	75 df                	jne    837 <printint+0x34>
 858:	89 c3                	mov    %eax,%ebx
  if(neg)
 85a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 85e:	74 16                	je     876 <printint+0x73>
    buf[i++] = '-';
 860:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 865:	8d 5e 02             	lea    0x2(%esi),%ebx
 868:	eb 0c                	jmp    876 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 86a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 86f:	89 f8                	mov    %edi,%eax
 871:	e8 73 ff ff ff       	call   7e9 <putc>
  while(--i >= 0)
 876:	83 eb 01             	sub    $0x1,%ebx
 879:	79 ef                	jns    86a <printint+0x67>
}
 87b:	83 c4 2c             	add    $0x2c,%esp
 87e:	5b                   	pop    %ebx
 87f:	5e                   	pop    %esi
 880:	5f                   	pop    %edi
 881:	5d                   	pop    %ebp
 882:	c3                   	ret    

00000883 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 883:	55                   	push   %ebp
 884:	89 e5                	mov    %esp,%ebp
 886:	57                   	push   %edi
 887:	56                   	push   %esi
 888:	53                   	push   %ebx
 889:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 88c:	8d 45 10             	lea    0x10(%ebp),%eax
 88f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 892:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 897:	bb 00 00 00 00       	mov    $0x0,%ebx
 89c:	eb 14                	jmp    8b2 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 89e:	89 fa                	mov    %edi,%edx
 8a0:	8b 45 08             	mov    0x8(%ebp),%eax
 8a3:	e8 41 ff ff ff       	call   7e9 <putc>
 8a8:	eb 05                	jmp    8af <printf+0x2c>
      }
    } else if(state == '%'){
 8aa:	83 fe 25             	cmp    $0x25,%esi
 8ad:	74 25                	je     8d4 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 8af:	83 c3 01             	add    $0x1,%ebx
 8b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 8b5:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 8b9:	84 c0                	test   %al,%al
 8bb:	0f 84 23 01 00 00    	je     9e4 <printf+0x161>
    c = fmt[i] & 0xff;
 8c1:	0f be f8             	movsbl %al,%edi
 8c4:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 8c7:	85 f6                	test   %esi,%esi
 8c9:	75 df                	jne    8aa <printf+0x27>
      if(c == '%'){
 8cb:	83 f8 25             	cmp    $0x25,%eax
 8ce:	75 ce                	jne    89e <printf+0x1b>
        state = '%';
 8d0:	89 c6                	mov    %eax,%esi
 8d2:	eb db                	jmp    8af <printf+0x2c>
      if(c == 'd'){
 8d4:	83 f8 64             	cmp    $0x64,%eax
 8d7:	74 49                	je     922 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 8d9:	83 f8 78             	cmp    $0x78,%eax
 8dc:	0f 94 c1             	sete   %cl
 8df:	83 f8 70             	cmp    $0x70,%eax
 8e2:	0f 94 c2             	sete   %dl
 8e5:	08 d1                	or     %dl,%cl
 8e7:	75 63                	jne    94c <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 8e9:	83 f8 73             	cmp    $0x73,%eax
 8ec:	0f 84 84 00 00 00    	je     976 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8f2:	83 f8 63             	cmp    $0x63,%eax
 8f5:	0f 84 b7 00 00 00    	je     9b2 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 8fb:	83 f8 25             	cmp    $0x25,%eax
 8fe:	0f 84 cc 00 00 00    	je     9d0 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 904:	ba 25 00 00 00       	mov    $0x25,%edx
 909:	8b 45 08             	mov    0x8(%ebp),%eax
 90c:	e8 d8 fe ff ff       	call   7e9 <putc>
        putc(fd, c);
 911:	89 fa                	mov    %edi,%edx
 913:	8b 45 08             	mov    0x8(%ebp),%eax
 916:	e8 ce fe ff ff       	call   7e9 <putc>
      }
      state = 0;
 91b:	be 00 00 00 00       	mov    $0x0,%esi
 920:	eb 8d                	jmp    8af <printf+0x2c>
        printint(fd, *ap, 10, 1);
 922:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 925:	8b 17                	mov    (%edi),%edx
 927:	83 ec 0c             	sub    $0xc,%esp
 92a:	6a 01                	push   $0x1
 92c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 931:	8b 45 08             	mov    0x8(%ebp),%eax
 934:	e8 ca fe ff ff       	call   803 <printint>
        ap++;
 939:	83 c7 04             	add    $0x4,%edi
 93c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 93f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 942:	be 00 00 00 00       	mov    $0x0,%esi
 947:	e9 63 ff ff ff       	jmp    8af <printf+0x2c>
        printint(fd, *ap, 16, 0);
 94c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 94f:	8b 17                	mov    (%edi),%edx
 951:	83 ec 0c             	sub    $0xc,%esp
 954:	6a 00                	push   $0x0
 956:	b9 10 00 00 00       	mov    $0x10,%ecx
 95b:	8b 45 08             	mov    0x8(%ebp),%eax
 95e:	e8 a0 fe ff ff       	call   803 <printint>
        ap++;
 963:	83 c7 04             	add    $0x4,%edi
 966:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 969:	83 c4 10             	add    $0x10,%esp
      state = 0;
 96c:	be 00 00 00 00       	mov    $0x0,%esi
 971:	e9 39 ff ff ff       	jmp    8af <printf+0x2c>
        s = (char*)*ap;
 976:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 979:	8b 30                	mov    (%eax),%esi
        ap++;
 97b:	83 c0 04             	add    $0x4,%eax
 97e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 981:	85 f6                	test   %esi,%esi
 983:	75 28                	jne    9ad <printf+0x12a>
          s = "(null)";
 985:	be 57 0c 00 00       	mov    $0xc57,%esi
 98a:	8b 7d 08             	mov    0x8(%ebp),%edi
 98d:	eb 0d                	jmp    99c <printf+0x119>
          putc(fd, *s);
 98f:	0f be d2             	movsbl %dl,%edx
 992:	89 f8                	mov    %edi,%eax
 994:	e8 50 fe ff ff       	call   7e9 <putc>
          s++;
 999:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 99c:	0f b6 16             	movzbl (%esi),%edx
 99f:	84 d2                	test   %dl,%dl
 9a1:	75 ec                	jne    98f <printf+0x10c>
      state = 0;
 9a3:	be 00 00 00 00       	mov    $0x0,%esi
 9a8:	e9 02 ff ff ff       	jmp    8af <printf+0x2c>
 9ad:	8b 7d 08             	mov    0x8(%ebp),%edi
 9b0:	eb ea                	jmp    99c <printf+0x119>
        putc(fd, *ap);
 9b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 9b5:	0f be 17             	movsbl (%edi),%edx
 9b8:	8b 45 08             	mov    0x8(%ebp),%eax
 9bb:	e8 29 fe ff ff       	call   7e9 <putc>
        ap++;
 9c0:	83 c7 04             	add    $0x4,%edi
 9c3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 9c6:	be 00 00 00 00       	mov    $0x0,%esi
 9cb:	e9 df fe ff ff       	jmp    8af <printf+0x2c>
        putc(fd, c);
 9d0:	89 fa                	mov    %edi,%edx
 9d2:	8b 45 08             	mov    0x8(%ebp),%eax
 9d5:	e8 0f fe ff ff       	call   7e9 <putc>
      state = 0;
 9da:	be 00 00 00 00       	mov    $0x0,%esi
 9df:	e9 cb fe ff ff       	jmp    8af <printf+0x2c>
    }
  }
}
 9e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9e7:	5b                   	pop    %ebx
 9e8:	5e                   	pop    %esi
 9e9:	5f                   	pop    %edi
 9ea:	5d                   	pop    %ebp
 9eb:	c3                   	ret    

000009ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ec:	55                   	push   %ebp
 9ed:	89 e5                	mov    %esp,%ebp
 9ef:	57                   	push   %edi
 9f0:	56                   	push   %esi
 9f1:	53                   	push   %ebx
 9f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9f5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f8:	a1 d8 0f 00 00       	mov    0xfd8,%eax
 9fd:	eb 02                	jmp    a01 <free+0x15>
 9ff:	89 d0                	mov    %edx,%eax
 a01:	39 c8                	cmp    %ecx,%eax
 a03:	73 04                	jae    a09 <free+0x1d>
 a05:	39 08                	cmp    %ecx,(%eax)
 a07:	77 12                	ja     a1b <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a09:	8b 10                	mov    (%eax),%edx
 a0b:	39 c2                	cmp    %eax,%edx
 a0d:	77 f0                	ja     9ff <free+0x13>
 a0f:	39 c8                	cmp    %ecx,%eax
 a11:	72 08                	jb     a1b <free+0x2f>
 a13:	39 ca                	cmp    %ecx,%edx
 a15:	77 04                	ja     a1b <free+0x2f>
 a17:	89 d0                	mov    %edx,%eax
 a19:	eb e6                	jmp    a01 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a1b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a1e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a21:	8b 10                	mov    (%eax),%edx
 a23:	39 d7                	cmp    %edx,%edi
 a25:	74 19                	je     a40 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 a27:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 a2a:	8b 50 04             	mov    0x4(%eax),%edx
 a2d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 a30:	39 ce                	cmp    %ecx,%esi
 a32:	74 1b                	je     a4f <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 a34:	89 08                	mov    %ecx,(%eax)
  freep = p;
 a36:	a3 d8 0f 00 00       	mov    %eax,0xfd8
}
 a3b:	5b                   	pop    %ebx
 a3c:	5e                   	pop    %esi
 a3d:	5f                   	pop    %edi
 a3e:	5d                   	pop    %ebp
 a3f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 a40:	03 72 04             	add    0x4(%edx),%esi
 a43:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 a46:	8b 10                	mov    (%eax),%edx
 a48:	8b 12                	mov    (%edx),%edx
 a4a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 a4d:	eb db                	jmp    a2a <free+0x3e>
    p->s.size += bp->s.size;
 a4f:	03 53 fc             	add    -0x4(%ebx),%edx
 a52:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a55:	8b 53 f8             	mov    -0x8(%ebx),%edx
 a58:	89 10                	mov    %edx,(%eax)
 a5a:	eb da                	jmp    a36 <free+0x4a>

00000a5c <morecore>:

static Header*
morecore(uint nu)
{
 a5c:	55                   	push   %ebp
 a5d:	89 e5                	mov    %esp,%ebp
 a5f:	53                   	push   %ebx
 a60:	83 ec 04             	sub    $0x4,%esp
 a63:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 a65:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 a6a:	77 05                	ja     a71 <morecore+0x15>
    nu = 4096;
 a6c:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 a71:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 a78:	83 ec 0c             	sub    $0xc,%esp
 a7b:	50                   	push   %eax
 a7c:	e8 38 fd ff ff       	call   7b9 <sbrk>
  if(p == (char*)-1)
 a81:	83 c4 10             	add    $0x10,%esp
 a84:	83 f8 ff             	cmp    $0xffffffff,%eax
 a87:	74 1c                	je     aa5 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 a89:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a8c:	83 c0 08             	add    $0x8,%eax
 a8f:	83 ec 0c             	sub    $0xc,%esp
 a92:	50                   	push   %eax
 a93:	e8 54 ff ff ff       	call   9ec <free>
  return freep;
 a98:	a1 d8 0f 00 00       	mov    0xfd8,%eax
 a9d:	83 c4 10             	add    $0x10,%esp
}
 aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 aa3:	c9                   	leave  
 aa4:	c3                   	ret    
    return 0;
 aa5:	b8 00 00 00 00       	mov    $0x0,%eax
 aaa:	eb f4                	jmp    aa0 <morecore+0x44>

00000aac <malloc>:

void*
malloc(uint nbytes)
{
 aac:	55                   	push   %ebp
 aad:	89 e5                	mov    %esp,%ebp
 aaf:	53                   	push   %ebx
 ab0:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ab3:	8b 45 08             	mov    0x8(%ebp),%eax
 ab6:	8d 58 07             	lea    0x7(%eax),%ebx
 ab9:	c1 eb 03             	shr    $0x3,%ebx
 abc:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 abf:	8b 0d d8 0f 00 00    	mov    0xfd8,%ecx
 ac5:	85 c9                	test   %ecx,%ecx
 ac7:	74 04                	je     acd <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ac9:	8b 01                	mov    (%ecx),%eax
 acb:	eb 4d                	jmp    b1a <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 acd:	c7 05 d8 0f 00 00 dc 	movl   $0xfdc,0xfd8
 ad4:	0f 00 00 
 ad7:	c7 05 dc 0f 00 00 dc 	movl   $0xfdc,0xfdc
 ade:	0f 00 00 
    base.s.size = 0;
 ae1:	c7 05 e0 0f 00 00 00 	movl   $0x0,0xfe0
 ae8:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 aeb:	b9 dc 0f 00 00       	mov    $0xfdc,%ecx
 af0:	eb d7                	jmp    ac9 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 af2:	39 da                	cmp    %ebx,%edx
 af4:	74 1a                	je     b10 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 af6:	29 da                	sub    %ebx,%edx
 af8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 afb:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 afe:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 b01:	89 0d d8 0f 00 00    	mov    %ecx,0xfd8
      return (void*)(p + 1);
 b07:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b0a:	83 c4 04             	add    $0x4,%esp
 b0d:	5b                   	pop    %ebx
 b0e:	5d                   	pop    %ebp
 b0f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 b10:	8b 10                	mov    (%eax),%edx
 b12:	89 11                	mov    %edx,(%ecx)
 b14:	eb eb                	jmp    b01 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b16:	89 c1                	mov    %eax,%ecx
 b18:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 b1a:	8b 50 04             	mov    0x4(%eax),%edx
 b1d:	39 da                	cmp    %ebx,%edx
 b1f:	73 d1                	jae    af2 <malloc+0x46>
    if(p == freep)
 b21:	39 05 d8 0f 00 00    	cmp    %eax,0xfd8
 b27:	75 ed                	jne    b16 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 b29:	89 d8                	mov    %ebx,%eax
 b2b:	e8 2c ff ff ff       	call   a5c <morecore>
 b30:	85 c0                	test   %eax,%eax
 b32:	75 e2                	jne    b16 <malloc+0x6a>
        return 0;
 b34:	b8 00 00 00 00       	mov    $0x0,%eax
 b39:	eb cf                	jmp    b0a <malloc+0x5e>
