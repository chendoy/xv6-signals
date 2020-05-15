
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
   6:	68 7c 0a 00 00       	push   $0xa7c
   b:	6a 01                	push   $0x1
   d:	e8 b1 07 00 00       	call   7c3 <printf>
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
  2a:	e8 e2 06 00 00       	call   711 <sigprocmask>
        printf(1, "need to be %d = %d\n", i-1 ,omask);
  2f:	50                   	push   %eax
  30:	8d 43 ff             	lea    -0x1(%ebx),%eax
  33:	50                   	push   %eax
  34:	68 a0 0a 00 00       	push   $0xaa0
  39:	6a 01                	push   $0x1
  3b:	e8 83 07 00 00       	call   7c3 <printf>
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
  66:	e8 ae 06 00 00       	call   719 <sigaction>
    printf(1, "Need to be 0,0 = %d,%d\n", (uint)oldact.sa_handler, oldact.sigmask);
  6b:	ff 75 f4             	pushl  -0xc(%ebp)
  6e:	ff 75 f0             	pushl  -0x10(%ebp)
  71:	68 b4 0a 00 00       	push   $0xab4
  76:	6a 01                	push   $0x1
  78:	e8 46 07 00 00       	call   7c3 <printf>
    sigaction(12, &oldact, &newact);
  7d:	83 c4 1c             	add    $0x1c,%esp
  80:	56                   	push   %esi
  81:	53                   	push   %ebx
  82:	6a 0c                	push   $0xc
  84:	e8 90 06 00 00       	call   719 <sigaction>
    printf(1, "Need to be 1,12 = %d,%d\n", (uint)newact.sa_handler, newact.sigmask);
  89:	ff 75 ec             	pushl  -0x14(%ebp)
  8c:	ff 75 e8             	pushl  -0x18(%ebp)
  8f:	68 cc 0a 00 00       	push   $0xacc
  94:	6a 01                	push   $0x1
  96:	e8 28 07 00 00       	call   7c3 <printf>
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
  bb:	e8 a9 05 00 00       	call   669 <fork>
  c0:	85 c0                	test   %eax,%eax
  c2:	0f 85 22 03 00 00    	jne    3ea <test_2+0x345>
            sleep(5);printf(1, "a");sleep(5);printf(1, "b");sleep(5);printf(1, "c");sleep(5);printf(1, "d");
  c8:	83 ec 0c             	sub    $0xc,%esp
  cb:	6a 05                	push   $0x5
  cd:	e8 2f 06 00 00       	call   701 <sleep>
  d2:	83 c4 08             	add    $0x8,%esp
  d5:	68 e5 0a 00 00       	push   $0xae5
  da:	6a 01                	push   $0x1
  dc:	e8 e2 06 00 00       	call   7c3 <printf>
  e1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  e8:	e8 14 06 00 00       	call   701 <sleep>
  ed:	83 c4 08             	add    $0x8,%esp
  f0:	68 e7 0a 00 00       	push   $0xae7
  f5:	6a 01                	push   $0x1
  f7:	e8 c7 06 00 00       	call   7c3 <printf>
  fc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 103:	e8 f9 05 00 00       	call   701 <sleep>
 108:	83 c4 08             	add    $0x8,%esp
 10b:	68 e9 0a 00 00       	push   $0xae9
 110:	6a 01                	push   $0x1
 112:	e8 ac 06 00 00       	call   7c3 <printf>
 117:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 11e:	e8 de 05 00 00       	call   701 <sleep>
 123:	83 c4 08             	add    $0x8,%esp
 126:	68 eb 0a 00 00       	push   $0xaeb
 12b:	6a 01                	push   $0x1
 12d:	e8 91 06 00 00       	call   7c3 <printf>
            sleep(5);printf(1, "e");sleep(5);printf(1, "f");sleep(5);printf(1, "g");sleep(5);printf(1, "h");
 132:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 139:	e8 c3 05 00 00       	call   701 <sleep>
 13e:	83 c4 08             	add    $0x8,%esp
 141:	68 ed 0a 00 00       	push   $0xaed
 146:	6a 01                	push   $0x1
 148:	e8 76 06 00 00       	call   7c3 <printf>
 14d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 154:	e8 a8 05 00 00       	call   701 <sleep>
 159:	83 c4 08             	add    $0x8,%esp
 15c:	68 ef 0a 00 00       	push   $0xaef
 161:	6a 01                	push   $0x1
 163:	e8 5b 06 00 00       	call   7c3 <printf>
 168:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 16f:	e8 8d 05 00 00       	call   701 <sleep>
 174:	83 c4 08             	add    $0x8,%esp
 177:	68 f1 0a 00 00       	push   $0xaf1
 17c:	6a 01                	push   $0x1
 17e:	e8 40 06 00 00       	call   7c3 <printf>
 183:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 18a:	e8 72 05 00 00       	call   701 <sleep>
 18f:	83 c4 08             	add    $0x8,%esp
 192:	68 f3 0a 00 00       	push   $0xaf3
 197:	6a 01                	push   $0x1
 199:	e8 25 06 00 00       	call   7c3 <printf>
            sleep(5);printf(1, "i");sleep(5);printf(1, "j");sleep(5);printf(1, "k");sleep(5);printf(1, "l");
 19e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1a5:	e8 57 05 00 00       	call   701 <sleep>
 1aa:	83 c4 08             	add    $0x8,%esp
 1ad:	68 f5 0a 00 00       	push   $0xaf5
 1b2:	6a 01                	push   $0x1
 1b4:	e8 0a 06 00 00       	call   7c3 <printf>
 1b9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1c0:	e8 3c 05 00 00       	call   701 <sleep>
 1c5:	83 c4 08             	add    $0x8,%esp
 1c8:	68 f7 0a 00 00       	push   $0xaf7
 1cd:	6a 01                	push   $0x1
 1cf:	e8 ef 05 00 00       	call   7c3 <printf>
 1d4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1db:	e8 21 05 00 00       	call   701 <sleep>
 1e0:	83 c4 08             	add    $0x8,%esp
 1e3:	68 f9 0a 00 00       	push   $0xaf9
 1e8:	6a 01                	push   $0x1
 1ea:	e8 d4 05 00 00       	call   7c3 <printf>
 1ef:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1f6:	e8 06 05 00 00       	call   701 <sleep>
 1fb:	83 c4 08             	add    $0x8,%esp
 1fe:	68 fb 0a 00 00       	push   $0xafb
 203:	6a 01                	push   $0x1
 205:	e8 b9 05 00 00       	call   7c3 <printf>
            sleep(5);printf(1, "m");sleep(5);printf(1, "n");sleep(5);printf(1, "o");sleep(5);printf(1, "p");
 20a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 211:	e8 eb 04 00 00       	call   701 <sleep>
 216:	83 c4 08             	add    $0x8,%esp
 219:	68 fd 0a 00 00       	push   $0xafd
 21e:	6a 01                	push   $0x1
 220:	e8 9e 05 00 00       	call   7c3 <printf>
 225:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 22c:	e8 d0 04 00 00       	call   701 <sleep>
 231:	83 c4 08             	add    $0x8,%esp
 234:	68 ff 0a 00 00       	push   $0xaff
 239:	6a 01                	push   $0x1
 23b:	e8 83 05 00 00       	call   7c3 <printf>
 240:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 247:	e8 b5 04 00 00       	call   701 <sleep>
 24c:	83 c4 08             	add    $0x8,%esp
 24f:	68 01 0b 00 00       	push   $0xb01
 254:	6a 01                	push   $0x1
 256:	e8 68 05 00 00       	call   7c3 <printf>
 25b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 262:	e8 9a 04 00 00       	call   701 <sleep>
 267:	83 c4 08             	add    $0x8,%esp
 26a:	68 03 0b 00 00       	push   $0xb03
 26f:	6a 01                	push   $0x1
 271:	e8 4d 05 00 00       	call   7c3 <printf>
            sleep(5);printf(1, "q");sleep(5);printf(1, "r");sleep(5);printf(1, "s");sleep(5);printf(1, "t");
 276:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 27d:	e8 7f 04 00 00       	call   701 <sleep>
 282:	83 c4 08             	add    $0x8,%esp
 285:	68 05 0b 00 00       	push   $0xb05
 28a:	6a 01                	push   $0x1
 28c:	e8 32 05 00 00       	call   7c3 <printf>
 291:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 298:	e8 64 04 00 00       	call   701 <sleep>
 29d:	83 c4 08             	add    $0x8,%esp
 2a0:	68 07 0b 00 00       	push   $0xb07
 2a5:	6a 01                	push   $0x1
 2a7:	e8 17 05 00 00       	call   7c3 <printf>
 2ac:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2b3:	e8 49 04 00 00       	call   701 <sleep>
 2b8:	83 c4 08             	add    $0x8,%esp
 2bb:	68 09 0b 00 00       	push   $0xb09
 2c0:	6a 01                	push   $0x1
 2c2:	e8 fc 04 00 00       	call   7c3 <printf>
 2c7:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2ce:	e8 2e 04 00 00       	call   701 <sleep>
 2d3:	83 c4 08             	add    $0x8,%esp
 2d6:	68 0b 0b 00 00       	push   $0xb0b
 2db:	6a 01                	push   $0x1
 2dd:	e8 e1 04 00 00       	call   7c3 <printf>
            sleep(5);printf(1, "u");sleep(5);printf(1, "v");sleep(5);printf(1, "w");sleep(5);printf(1, "x");
 2e2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 2e9:	e8 13 04 00 00       	call   701 <sleep>
 2ee:	83 c4 08             	add    $0x8,%esp
 2f1:	68 0d 0b 00 00       	push   $0xb0d
 2f6:	6a 01                	push   $0x1
 2f8:	e8 c6 04 00 00       	call   7c3 <printf>
 2fd:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 304:	e8 f8 03 00 00       	call   701 <sleep>
 309:	83 c4 08             	add    $0x8,%esp
 30c:	68 0f 0b 00 00       	push   $0xb0f
 311:	6a 01                	push   $0x1
 313:	e8 ab 04 00 00       	call   7c3 <printf>
 318:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 31f:	e8 dd 03 00 00       	call   701 <sleep>
 324:	83 c4 08             	add    $0x8,%esp
 327:	68 11 0b 00 00       	push   $0xb11
 32c:	6a 01                	push   $0x1
 32e:	e8 90 04 00 00       	call   7c3 <printf>
 333:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 33a:	e8 c2 03 00 00       	call   701 <sleep>
 33f:	83 c4 08             	add    $0x8,%esp
 342:	68 13 0b 00 00       	push   $0xb13
 347:	6a 01                	push   $0x1
 349:	e8 75 04 00 00       	call   7c3 <printf>
            sleep(5);printf(1, "y");sleep(5);printf(1, "z");
 34e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 355:	e8 a7 03 00 00       	call   701 <sleep>
 35a:	83 c4 08             	add    $0x8,%esp
 35d:	68 15 0b 00 00       	push   $0xb15
 362:	6a 01                	push   $0x1
 364:	e8 5a 04 00 00       	call   7c3 <printf>
 369:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 370:	e8 8c 03 00 00       	call   701 <sleep>
 375:	83 c4 08             	add    $0x8,%esp
 378:	68 17 0b 00 00       	push   $0xb17
 37d:	6a 01                	push   $0x1
 37f:	e8 3f 04 00 00       	call   7c3 <printf>
 384:	83 c4 10             	add    $0x10,%esp
 387:	e9 3c fd ff ff       	jmp    c8 <test_2+0x23>
                printf(2, "\n%d: STOP!!!\n", i);    
 38c:	83 ec 04             	sub    $0x4,%esp
 38f:	53                   	push   %ebx
 390:	68 27 0b 00 00       	push   $0xb27
 395:	6a 02                	push   $0x2
 397:	e8 27 04 00 00       	call   7c3 <printf>
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
 3b4:	e8 e8 02 00 00       	call   6a1 <kill>
            sleep(30);
 3b9:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
 3c0:	e8 3c 03 00 00       	call   701 <sleep>
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
 3d9:	68 19 0b 00 00       	push   $0xb19
 3de:	6a 02                	push   $0x2
 3e0:	e8 de 03 00 00       	call   7c3 <printf>
 3e5:	83 c4 10             	add    $0x10,%esp
 3e8:	eb b5                	jmp    39f <test_2+0x2fa>
 3ea:	89 c6                	mov    %eax,%esi
        for (int i = 0; i < 20; i++)
 3ec:	bb 00 00 00 00       	mov    $0x0,%ebx
 3f1:	eb d8                	jmp    3cb <test_2+0x326>
        printf(1, "\nKILL pid : %d!!!\n", pid);
 3f3:	83 ec 04             	sub    $0x4,%esp
 3f6:	56                   	push   %esi
 3f7:	68 35 0b 00 00       	push   $0xb35
 3fc:	6a 01                	push   $0x1
 3fe:	e8 c0 03 00 00       	call   7c3 <printf>
        kill(pid, SIGKILL);
 403:	83 c4 08             	add    $0x8,%esp
 406:	6a 09                	push   $0x9
 408:	56                   	push   %esi
 409:	e8 93 02 00 00       	call   6a1 <kill>
        wait();
 40e:	e8 66 02 00 00       	call   679 <wait>
        exit();
 413:	e8 59 02 00 00       	call   671 <exit>

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
 42d:	e8 37 02 00 00       	call   669 <fork>
 432:	85 c0                	test   %eax,%eax
 434:	75 33                	jne    469 <test_3+0x51>
    {
        sigaction(SIGTEST, &act, null); // register custom handler
 436:	83 ec 04             	sub    $0x4,%esp
 439:	6a 00                	push   $0x0
 43b:	8d 45 f0             	lea    -0x10(%ebp),%eax
 43e:	50                   	push   %eax
 43f:	6a 14                	push   $0x14
 441:	e8 d3 02 00 00       	call   719 <sigaction>
 446:	83 c4 10             	add    $0x10,%esp

        while(1)
        {
            printf(1, "child: waiting...\n");
 449:	83 ec 08             	sub    $0x8,%esp
 44c:	68 48 0b 00 00       	push   $0xb48
 451:	6a 01                	push   $0x1
 453:	e8 6b 03 00 00       	call   7c3 <printf>
            sleep(30);
 458:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
 45f:	e8 9d 02 00 00       	call   701 <sleep>
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
 473:	e8 89 02 00 00       	call   701 <sleep>
        printf(1, "parent: kill(child, SIGTEST)\n");
 478:	83 c4 08             	add    $0x8,%esp
 47b:	68 5b 0b 00 00       	push   $0xb5b
 480:	6a 01                	push   $0x1
 482:	e8 3c 03 00 00       	call   7c3 <printf>
        sleep(5);
 487:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 48e:	e8 6e 02 00 00       	call   701 <sleep>
        kill(pid, SIGTEST);
 493:	83 c4 08             	add    $0x8,%esp
 496:	6a 14                	push   $0x14
 498:	53                   	push   %ebx
 499:	e8 03 02 00 00       	call   6a1 <kill>
        sleep(50);
 49e:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
 4a5:	e8 57 02 00 00       	call   701 <sleep>
        printf(1, "parent: kill(child, SIGKILL)\n");
 4aa:	83 c4 08             	add    $0x8,%esp
 4ad:	68 79 0b 00 00       	push   $0xb79
 4b2:	6a 01                	push   $0x1
 4b4:	e8 0a 03 00 00       	call   7c3 <printf>
        kill(pid, SIGKILL);
 4b9:	83 c4 08             	add    $0x8,%esp
 4bc:	6a 09                	push   $0x9
 4be:	53                   	push   %ebx
 4bf:	e8 dd 01 00 00       	call   6a1 <kill>
        wait();
 4c4:	e8 b0 01 00 00       	call   679 <wait>
        exit();
 4c9:	e8 a3 01 00 00       	call   671 <exit>

000004ce <main>:
    }
}

int main()
{
 4ce:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 4d2:	83 e4 f0             	and    $0xfffffff0,%esp
 4d5:	ff 71 fc             	pushl  -0x4(%ecx)
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	51                   	push   %ecx
 4dc:	83 ec 04             	sub    $0x4,%esp
        // test_1();
        test_2(); 
 4df:	e8 c1 fb ff ff       	call   a5 <test_2>

000004e4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	53                   	push   %ebx
 4e8:	8b 45 08             	mov    0x8(%ebp),%eax
 4eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4ee:	89 c2                	mov    %eax,%edx
 4f0:	0f b6 19             	movzbl (%ecx),%ebx
 4f3:	88 1a                	mov    %bl,(%edx)
 4f5:	8d 52 01             	lea    0x1(%edx),%edx
 4f8:	8d 49 01             	lea    0x1(%ecx),%ecx
 4fb:	84 db                	test   %bl,%bl
 4fd:	75 f1                	jne    4f0 <strcpy+0xc>
    ;
  return os;
}
 4ff:	5b                   	pop    %ebx
 500:	5d                   	pop    %ebp
 501:	c3                   	ret    

00000502 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 502:	55                   	push   %ebp
 503:	89 e5                	mov    %esp,%ebp
 505:	8b 4d 08             	mov    0x8(%ebp),%ecx
 508:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 50b:	eb 06                	jmp    513 <strcmp+0x11>
    p++, q++;
 50d:	83 c1 01             	add    $0x1,%ecx
 510:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 513:	0f b6 01             	movzbl (%ecx),%eax
 516:	84 c0                	test   %al,%al
 518:	74 04                	je     51e <strcmp+0x1c>
 51a:	3a 02                	cmp    (%edx),%al
 51c:	74 ef                	je     50d <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 51e:	0f b6 c0             	movzbl %al,%eax
 521:	0f b6 12             	movzbl (%edx),%edx
 524:	29 d0                	sub    %edx,%eax
}
 526:	5d                   	pop    %ebp
 527:	c3                   	ret    

00000528 <strlen>:

uint
strlen(const char *s)
{
 528:	55                   	push   %ebp
 529:	89 e5                	mov    %esp,%ebp
 52b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 52e:	ba 00 00 00 00       	mov    $0x0,%edx
 533:	eb 03                	jmp    538 <strlen+0x10>
 535:	83 c2 01             	add    $0x1,%edx
 538:	89 d0                	mov    %edx,%eax
 53a:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 53e:	75 f5                	jne    535 <strlen+0xd>
    ;
  return n;
}
 540:	5d                   	pop    %ebp
 541:	c3                   	ret    

00000542 <memset>:

void*
memset(void *dst, int c, uint n)
{
 542:	55                   	push   %ebp
 543:	89 e5                	mov    %esp,%ebp
 545:	57                   	push   %edi
 546:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 549:	89 d7                	mov    %edx,%edi
 54b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 54e:	8b 45 0c             	mov    0xc(%ebp),%eax
 551:	fc                   	cld    
 552:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 554:	89 d0                	mov    %edx,%eax
 556:	5f                   	pop    %edi
 557:	5d                   	pop    %ebp
 558:	c3                   	ret    

00000559 <strchr>:

char*
strchr(const char *s, char c)
{
 559:	55                   	push   %ebp
 55a:	89 e5                	mov    %esp,%ebp
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 563:	0f b6 10             	movzbl (%eax),%edx
 566:	84 d2                	test   %dl,%dl
 568:	74 09                	je     573 <strchr+0x1a>
    if(*s == c)
 56a:	38 ca                	cmp    %cl,%dl
 56c:	74 0a                	je     578 <strchr+0x1f>
  for(; *s; s++)
 56e:	83 c0 01             	add    $0x1,%eax
 571:	eb f0                	jmp    563 <strchr+0xa>
      return (char*)s;
  return 0;
 573:	b8 00 00 00 00       	mov    $0x0,%eax
}
 578:	5d                   	pop    %ebp
 579:	c3                   	ret    

0000057a <gets>:

char*
gets(char *buf, int max)
{
 57a:	55                   	push   %ebp
 57b:	89 e5                	mov    %esp,%ebp
 57d:	57                   	push   %edi
 57e:	56                   	push   %esi
 57f:	53                   	push   %ebx
 580:	83 ec 1c             	sub    $0x1c,%esp
 583:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 586:	bb 00 00 00 00       	mov    $0x0,%ebx
 58b:	8d 73 01             	lea    0x1(%ebx),%esi
 58e:	3b 75 0c             	cmp    0xc(%ebp),%esi
 591:	7d 2e                	jge    5c1 <gets+0x47>
    cc = read(0, &c, 1);
 593:	83 ec 04             	sub    $0x4,%esp
 596:	6a 01                	push   $0x1
 598:	8d 45 e7             	lea    -0x19(%ebp),%eax
 59b:	50                   	push   %eax
 59c:	6a 00                	push   $0x0
 59e:	e8 e6 00 00 00       	call   689 <read>
    if(cc < 1)
 5a3:	83 c4 10             	add    $0x10,%esp
 5a6:	85 c0                	test   %eax,%eax
 5a8:	7e 17                	jle    5c1 <gets+0x47>
      break;
    buf[i++] = c;
 5aa:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 5ae:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
 5b1:	3c 0a                	cmp    $0xa,%al
 5b3:	0f 94 c2             	sete   %dl
 5b6:	3c 0d                	cmp    $0xd,%al
 5b8:	0f 94 c0             	sete   %al
    buf[i++] = c;
 5bb:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
 5bd:	08 c2                	or     %al,%dl
 5bf:	74 ca                	je     58b <gets+0x11>
      break;
  }
  buf[i] = '\0';
 5c1:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
 5c5:	89 f8                	mov    %edi,%eax
 5c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ca:	5b                   	pop    %ebx
 5cb:	5e                   	pop    %esi
 5cc:	5f                   	pop    %edi
 5cd:	5d                   	pop    %ebp
 5ce:	c3                   	ret    

000005cf <stat>:

int
stat(const char *n, struct stat *st)
{
 5cf:	55                   	push   %ebp
 5d0:	89 e5                	mov    %esp,%ebp
 5d2:	56                   	push   %esi
 5d3:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5d4:	83 ec 08             	sub    $0x8,%esp
 5d7:	6a 00                	push   $0x0
 5d9:	ff 75 08             	pushl  0x8(%ebp)
 5dc:	e8 d0 00 00 00       	call   6b1 <open>
  if(fd < 0)
 5e1:	83 c4 10             	add    $0x10,%esp
 5e4:	85 c0                	test   %eax,%eax
 5e6:	78 24                	js     60c <stat+0x3d>
 5e8:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 5ea:	83 ec 08             	sub    $0x8,%esp
 5ed:	ff 75 0c             	pushl  0xc(%ebp)
 5f0:	50                   	push   %eax
 5f1:	e8 d3 00 00 00       	call   6c9 <fstat>
 5f6:	89 c6                	mov    %eax,%esi
  close(fd);
 5f8:	89 1c 24             	mov    %ebx,(%esp)
 5fb:	e8 99 00 00 00       	call   699 <close>
  return r;
 600:	83 c4 10             	add    $0x10,%esp
}
 603:	89 f0                	mov    %esi,%eax
 605:	8d 65 f8             	lea    -0x8(%ebp),%esp
 608:	5b                   	pop    %ebx
 609:	5e                   	pop    %esi
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret    
    return -1;
 60c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 611:	eb f0                	jmp    603 <stat+0x34>

00000613 <atoi>:

int
atoi(const char *s)
{
 613:	55                   	push   %ebp
 614:	89 e5                	mov    %esp,%ebp
 616:	53                   	push   %ebx
 617:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 61a:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 61f:	eb 10                	jmp    631 <atoi+0x1e>
    n = n*10 + *s++ - '0';
 621:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
 624:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
 627:	83 c1 01             	add    $0x1,%ecx
 62a:	0f be d2             	movsbl %dl,%edx
 62d:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  while('0' <= *s && *s <= '9')
 631:	0f b6 11             	movzbl (%ecx),%edx
 634:	8d 5a d0             	lea    -0x30(%edx),%ebx
 637:	80 fb 09             	cmp    $0x9,%bl
 63a:	76 e5                	jbe    621 <atoi+0xe>
  return n;
}
 63c:	5b                   	pop    %ebx
 63d:	5d                   	pop    %ebp
 63e:	c3                   	ret    

0000063f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 63f:	55                   	push   %ebp
 640:	89 e5                	mov    %esp,%ebp
 642:	56                   	push   %esi
 643:	53                   	push   %ebx
 644:	8b 45 08             	mov    0x8(%ebp),%eax
 647:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 64a:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 64d:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 64f:	eb 0d                	jmp    65e <memmove+0x1f>
    *dst++ = *src++;
 651:	0f b6 13             	movzbl (%ebx),%edx
 654:	88 11                	mov    %dl,(%ecx)
 656:	8d 5b 01             	lea    0x1(%ebx),%ebx
 659:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 65c:	89 f2                	mov    %esi,%edx
 65e:	8d 72 ff             	lea    -0x1(%edx),%esi
 661:	85 d2                	test   %edx,%edx
 663:	7f ec                	jg     651 <memmove+0x12>
  return vdst;
}
 665:	5b                   	pop    %ebx
 666:	5e                   	pop    %esi
 667:	5d                   	pop    %ebp
 668:	c3                   	ret    

00000669 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 669:	b8 01 00 00 00       	mov    $0x1,%eax
 66e:	cd 40                	int    $0x40
 670:	c3                   	ret    

00000671 <exit>:
SYSCALL(exit)
 671:	b8 02 00 00 00       	mov    $0x2,%eax
 676:	cd 40                	int    $0x40
 678:	c3                   	ret    

00000679 <wait>:
SYSCALL(wait)
 679:	b8 03 00 00 00       	mov    $0x3,%eax
 67e:	cd 40                	int    $0x40
 680:	c3                   	ret    

00000681 <pipe>:
SYSCALL(pipe)
 681:	b8 04 00 00 00       	mov    $0x4,%eax
 686:	cd 40                	int    $0x40
 688:	c3                   	ret    

00000689 <read>:
SYSCALL(read)
 689:	b8 05 00 00 00       	mov    $0x5,%eax
 68e:	cd 40                	int    $0x40
 690:	c3                   	ret    

00000691 <write>:
SYSCALL(write)
 691:	b8 10 00 00 00       	mov    $0x10,%eax
 696:	cd 40                	int    $0x40
 698:	c3                   	ret    

00000699 <close>:
SYSCALL(close)
 699:	b8 15 00 00 00       	mov    $0x15,%eax
 69e:	cd 40                	int    $0x40
 6a0:	c3                   	ret    

000006a1 <kill>:
SYSCALL(kill)
 6a1:	b8 06 00 00 00       	mov    $0x6,%eax
 6a6:	cd 40                	int    $0x40
 6a8:	c3                   	ret    

000006a9 <exec>:
SYSCALL(exec)
 6a9:	b8 07 00 00 00       	mov    $0x7,%eax
 6ae:	cd 40                	int    $0x40
 6b0:	c3                   	ret    

000006b1 <open>:
SYSCALL(open)
 6b1:	b8 0f 00 00 00       	mov    $0xf,%eax
 6b6:	cd 40                	int    $0x40
 6b8:	c3                   	ret    

000006b9 <mknod>:
SYSCALL(mknod)
 6b9:	b8 11 00 00 00       	mov    $0x11,%eax
 6be:	cd 40                	int    $0x40
 6c0:	c3                   	ret    

000006c1 <unlink>:
SYSCALL(unlink)
 6c1:	b8 12 00 00 00       	mov    $0x12,%eax
 6c6:	cd 40                	int    $0x40
 6c8:	c3                   	ret    

000006c9 <fstat>:
SYSCALL(fstat)
 6c9:	b8 08 00 00 00       	mov    $0x8,%eax
 6ce:	cd 40                	int    $0x40
 6d0:	c3                   	ret    

000006d1 <link>:
SYSCALL(link)
 6d1:	b8 13 00 00 00       	mov    $0x13,%eax
 6d6:	cd 40                	int    $0x40
 6d8:	c3                   	ret    

000006d9 <mkdir>:
SYSCALL(mkdir)
 6d9:	b8 14 00 00 00       	mov    $0x14,%eax
 6de:	cd 40                	int    $0x40
 6e0:	c3                   	ret    

000006e1 <chdir>:
SYSCALL(chdir)
 6e1:	b8 09 00 00 00       	mov    $0x9,%eax
 6e6:	cd 40                	int    $0x40
 6e8:	c3                   	ret    

000006e9 <dup>:
SYSCALL(dup)
 6e9:	b8 0a 00 00 00       	mov    $0xa,%eax
 6ee:	cd 40                	int    $0x40
 6f0:	c3                   	ret    

000006f1 <getpid>:
SYSCALL(getpid)
 6f1:	b8 0b 00 00 00       	mov    $0xb,%eax
 6f6:	cd 40                	int    $0x40
 6f8:	c3                   	ret    

000006f9 <sbrk>:
SYSCALL(sbrk)
 6f9:	b8 0c 00 00 00       	mov    $0xc,%eax
 6fe:	cd 40                	int    $0x40
 700:	c3                   	ret    

00000701 <sleep>:
SYSCALL(sleep)
 701:	b8 0d 00 00 00       	mov    $0xd,%eax
 706:	cd 40                	int    $0x40
 708:	c3                   	ret    

00000709 <uptime>:
SYSCALL(uptime)
 709:	b8 0e 00 00 00       	mov    $0xe,%eax
 70e:	cd 40                	int    $0x40
 710:	c3                   	ret    

00000711 <sigprocmask>:
SYSCALL(sigprocmask)
 711:	b8 16 00 00 00       	mov    $0x16,%eax
 716:	cd 40                	int    $0x40
 718:	c3                   	ret    

00000719 <sigaction>:
SYSCALL(sigaction)
 719:	b8 17 00 00 00       	mov    $0x17,%eax
 71e:	cd 40                	int    $0x40
 720:	c3                   	ret    

00000721 <sigret>:
SYSCALL(sigret)
 721:	b8 18 00 00 00       	mov    $0x18,%eax
 726:	cd 40                	int    $0x40
 728:	c3                   	ret    

00000729 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 729:	55                   	push   %ebp
 72a:	89 e5                	mov    %esp,%ebp
 72c:	83 ec 1c             	sub    $0x1c,%esp
 72f:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 732:	6a 01                	push   $0x1
 734:	8d 55 f4             	lea    -0xc(%ebp),%edx
 737:	52                   	push   %edx
 738:	50                   	push   %eax
 739:	e8 53 ff ff ff       	call   691 <write>
}
 73e:	83 c4 10             	add    $0x10,%esp
 741:	c9                   	leave  
 742:	c3                   	ret    

00000743 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 743:	55                   	push   %ebp
 744:	89 e5                	mov    %esp,%ebp
 746:	57                   	push   %edi
 747:	56                   	push   %esi
 748:	53                   	push   %ebx
 749:	83 ec 2c             	sub    $0x2c,%esp
 74c:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 74e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 752:	0f 95 c3             	setne  %bl
 755:	89 d0                	mov    %edx,%eax
 757:	c1 e8 1f             	shr    $0x1f,%eax
 75a:	84 c3                	test   %al,%bl
 75c:	74 10                	je     76e <printint+0x2b>
    neg = 1;
    x = -xx;
 75e:	f7 da                	neg    %edx
    neg = 1;
 760:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 767:	be 00 00 00 00       	mov    $0x0,%esi
 76c:	eb 0b                	jmp    779 <printint+0x36>
  neg = 0;
 76e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 775:	eb f0                	jmp    767 <printint+0x24>
  do{
    buf[i++] = digits[x % base];
 777:	89 c6                	mov    %eax,%esi
 779:	89 d0                	mov    %edx,%eax
 77b:	ba 00 00 00 00       	mov    $0x0,%edx
 780:	f7 f1                	div    %ecx
 782:	89 c3                	mov    %eax,%ebx
 784:	8d 46 01             	lea    0x1(%esi),%eax
 787:	0f b6 92 a0 0b 00 00 	movzbl 0xba0(%edx),%edx
 78e:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
 792:	89 da                	mov    %ebx,%edx
 794:	85 db                	test   %ebx,%ebx
 796:	75 df                	jne    777 <printint+0x34>
 798:	89 c3                	mov    %eax,%ebx
  if(neg)
 79a:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 79e:	74 16                	je     7b6 <printint+0x73>
    buf[i++] = '-';
 7a0:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
 7a5:	8d 5e 02             	lea    0x2(%esi),%ebx
 7a8:	eb 0c                	jmp    7b6 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
 7aa:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 7af:	89 f8                	mov    %edi,%eax
 7b1:	e8 73 ff ff ff       	call   729 <putc>
  while(--i >= 0)
 7b6:	83 eb 01             	sub    $0x1,%ebx
 7b9:	79 ef                	jns    7aa <printint+0x67>
}
 7bb:	83 c4 2c             	add    $0x2c,%esp
 7be:	5b                   	pop    %ebx
 7bf:	5e                   	pop    %esi
 7c0:	5f                   	pop    %edi
 7c1:	5d                   	pop    %ebp
 7c2:	c3                   	ret    

000007c3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 7c3:	55                   	push   %ebp
 7c4:	89 e5                	mov    %esp,%ebp
 7c6:	57                   	push   %edi
 7c7:	56                   	push   %esi
 7c8:	53                   	push   %ebx
 7c9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 7cc:	8d 45 10             	lea    0x10(%ebp),%eax
 7cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 7d2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 7d7:	bb 00 00 00 00       	mov    $0x0,%ebx
 7dc:	eb 14                	jmp    7f2 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 7de:	89 fa                	mov    %edi,%edx
 7e0:	8b 45 08             	mov    0x8(%ebp),%eax
 7e3:	e8 41 ff ff ff       	call   729 <putc>
 7e8:	eb 05                	jmp    7ef <printf+0x2c>
      }
    } else if(state == '%'){
 7ea:	83 fe 25             	cmp    $0x25,%esi
 7ed:	74 25                	je     814 <printf+0x51>
  for(i = 0; fmt[i]; i++){
 7ef:	83 c3 01             	add    $0x1,%ebx
 7f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 7f5:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 7f9:	84 c0                	test   %al,%al
 7fb:	0f 84 23 01 00 00    	je     924 <printf+0x161>
    c = fmt[i] & 0xff;
 801:	0f be f8             	movsbl %al,%edi
 804:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 807:	85 f6                	test   %esi,%esi
 809:	75 df                	jne    7ea <printf+0x27>
      if(c == '%'){
 80b:	83 f8 25             	cmp    $0x25,%eax
 80e:	75 ce                	jne    7de <printf+0x1b>
        state = '%';
 810:	89 c6                	mov    %eax,%esi
 812:	eb db                	jmp    7ef <printf+0x2c>
      if(c == 'd'){
 814:	83 f8 64             	cmp    $0x64,%eax
 817:	74 49                	je     862 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 819:	83 f8 78             	cmp    $0x78,%eax
 81c:	0f 94 c1             	sete   %cl
 81f:	83 f8 70             	cmp    $0x70,%eax
 822:	0f 94 c2             	sete   %dl
 825:	08 d1                	or     %dl,%cl
 827:	75 63                	jne    88c <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 829:	83 f8 73             	cmp    $0x73,%eax
 82c:	0f 84 84 00 00 00    	je     8b6 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 832:	83 f8 63             	cmp    $0x63,%eax
 835:	0f 84 b7 00 00 00    	je     8f2 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 83b:	83 f8 25             	cmp    $0x25,%eax
 83e:	0f 84 cc 00 00 00    	je     910 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 844:	ba 25 00 00 00       	mov    $0x25,%edx
 849:	8b 45 08             	mov    0x8(%ebp),%eax
 84c:	e8 d8 fe ff ff       	call   729 <putc>
        putc(fd, c);
 851:	89 fa                	mov    %edi,%edx
 853:	8b 45 08             	mov    0x8(%ebp),%eax
 856:	e8 ce fe ff ff       	call   729 <putc>
      }
      state = 0;
 85b:	be 00 00 00 00       	mov    $0x0,%esi
 860:	eb 8d                	jmp    7ef <printf+0x2c>
        printint(fd, *ap, 10, 1);
 862:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 865:	8b 17                	mov    (%edi),%edx
 867:	83 ec 0c             	sub    $0xc,%esp
 86a:	6a 01                	push   $0x1
 86c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 871:	8b 45 08             	mov    0x8(%ebp),%eax
 874:	e8 ca fe ff ff       	call   743 <printint>
        ap++;
 879:	83 c7 04             	add    $0x4,%edi
 87c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 87f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 882:	be 00 00 00 00       	mov    $0x0,%esi
 887:	e9 63 ff ff ff       	jmp    7ef <printf+0x2c>
        printint(fd, *ap, 16, 0);
 88c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 88f:	8b 17                	mov    (%edi),%edx
 891:	83 ec 0c             	sub    $0xc,%esp
 894:	6a 00                	push   $0x0
 896:	b9 10 00 00 00       	mov    $0x10,%ecx
 89b:	8b 45 08             	mov    0x8(%ebp),%eax
 89e:	e8 a0 fe ff ff       	call   743 <printint>
        ap++;
 8a3:	83 c7 04             	add    $0x4,%edi
 8a6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 8a9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8ac:	be 00 00 00 00       	mov    $0x0,%esi
 8b1:	e9 39 ff ff ff       	jmp    7ef <printf+0x2c>
        s = (char*)*ap;
 8b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b9:	8b 30                	mov    (%eax),%esi
        ap++;
 8bb:	83 c0 04             	add    $0x4,%eax
 8be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 8c1:	85 f6                	test   %esi,%esi
 8c3:	75 28                	jne    8ed <printf+0x12a>
          s = "(null)";
 8c5:	be 97 0b 00 00       	mov    $0xb97,%esi
 8ca:	8b 7d 08             	mov    0x8(%ebp),%edi
 8cd:	eb 0d                	jmp    8dc <printf+0x119>
          putc(fd, *s);
 8cf:	0f be d2             	movsbl %dl,%edx
 8d2:	89 f8                	mov    %edi,%eax
 8d4:	e8 50 fe ff ff       	call   729 <putc>
          s++;
 8d9:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 8dc:	0f b6 16             	movzbl (%esi),%edx
 8df:	84 d2                	test   %dl,%dl
 8e1:	75 ec                	jne    8cf <printf+0x10c>
      state = 0;
 8e3:	be 00 00 00 00       	mov    $0x0,%esi
 8e8:	e9 02 ff ff ff       	jmp    7ef <printf+0x2c>
 8ed:	8b 7d 08             	mov    0x8(%ebp),%edi
 8f0:	eb ea                	jmp    8dc <printf+0x119>
        putc(fd, *ap);
 8f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 8f5:	0f be 17             	movsbl (%edi),%edx
 8f8:	8b 45 08             	mov    0x8(%ebp),%eax
 8fb:	e8 29 fe ff ff       	call   729 <putc>
        ap++;
 900:	83 c7 04             	add    $0x4,%edi
 903:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 906:	be 00 00 00 00       	mov    $0x0,%esi
 90b:	e9 df fe ff ff       	jmp    7ef <printf+0x2c>
        putc(fd, c);
 910:	89 fa                	mov    %edi,%edx
 912:	8b 45 08             	mov    0x8(%ebp),%eax
 915:	e8 0f fe ff ff       	call   729 <putc>
      state = 0;
 91a:	be 00 00 00 00       	mov    $0x0,%esi
 91f:	e9 cb fe ff ff       	jmp    7ef <printf+0x2c>
    }
  }
}
 924:	8d 65 f4             	lea    -0xc(%ebp),%esp
 927:	5b                   	pop    %ebx
 928:	5e                   	pop    %esi
 929:	5f                   	pop    %edi
 92a:	5d                   	pop    %ebp
 92b:	c3                   	ret    

0000092c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 92c:	55                   	push   %ebp
 92d:	89 e5                	mov    %esp,%ebp
 92f:	57                   	push   %edi
 930:	56                   	push   %esi
 931:	53                   	push   %ebx
 932:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 935:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 938:	a1 bc 0e 00 00       	mov    0xebc,%eax
 93d:	eb 02                	jmp    941 <free+0x15>
 93f:	89 d0                	mov    %edx,%eax
 941:	39 c8                	cmp    %ecx,%eax
 943:	73 04                	jae    949 <free+0x1d>
 945:	39 08                	cmp    %ecx,(%eax)
 947:	77 12                	ja     95b <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 949:	8b 10                	mov    (%eax),%edx
 94b:	39 c2                	cmp    %eax,%edx
 94d:	77 f0                	ja     93f <free+0x13>
 94f:	39 c8                	cmp    %ecx,%eax
 951:	72 08                	jb     95b <free+0x2f>
 953:	39 ca                	cmp    %ecx,%edx
 955:	77 04                	ja     95b <free+0x2f>
 957:	89 d0                	mov    %edx,%eax
 959:	eb e6                	jmp    941 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 95b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 95e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 961:	8b 10                	mov    (%eax),%edx
 963:	39 d7                	cmp    %edx,%edi
 965:	74 19                	je     980 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 967:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 96a:	8b 50 04             	mov    0x4(%eax),%edx
 96d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 970:	39 ce                	cmp    %ecx,%esi
 972:	74 1b                	je     98f <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 974:	89 08                	mov    %ecx,(%eax)
  freep = p;
 976:	a3 bc 0e 00 00       	mov    %eax,0xebc
}
 97b:	5b                   	pop    %ebx
 97c:	5e                   	pop    %esi
 97d:	5f                   	pop    %edi
 97e:	5d                   	pop    %ebp
 97f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 980:	03 72 04             	add    0x4(%edx),%esi
 983:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	8b 10                	mov    (%eax),%edx
 988:	8b 12                	mov    (%edx),%edx
 98a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 98d:	eb db                	jmp    96a <free+0x3e>
    p->s.size += bp->s.size;
 98f:	03 53 fc             	add    -0x4(%ebx),%edx
 992:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 995:	8b 53 f8             	mov    -0x8(%ebx),%edx
 998:	89 10                	mov    %edx,(%eax)
 99a:	eb da                	jmp    976 <free+0x4a>

0000099c <morecore>:

static Header*
morecore(uint nu)
{
 99c:	55                   	push   %ebp
 99d:	89 e5                	mov    %esp,%ebp
 99f:	53                   	push   %ebx
 9a0:	83 ec 04             	sub    $0x4,%esp
 9a3:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 9a5:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 9aa:	77 05                	ja     9b1 <morecore+0x15>
    nu = 4096;
 9ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 9b1:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 9b8:	83 ec 0c             	sub    $0xc,%esp
 9bb:	50                   	push   %eax
 9bc:	e8 38 fd ff ff       	call   6f9 <sbrk>
  if(p == (char*)-1)
 9c1:	83 c4 10             	add    $0x10,%esp
 9c4:	83 f8 ff             	cmp    $0xffffffff,%eax
 9c7:	74 1c                	je     9e5 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 9c9:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 9cc:	83 c0 08             	add    $0x8,%eax
 9cf:	83 ec 0c             	sub    $0xc,%esp
 9d2:	50                   	push   %eax
 9d3:	e8 54 ff ff ff       	call   92c <free>
  return freep;
 9d8:	a1 bc 0e 00 00       	mov    0xebc,%eax
 9dd:	83 c4 10             	add    $0x10,%esp
}
 9e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 9e3:	c9                   	leave  
 9e4:	c3                   	ret    
    return 0;
 9e5:	b8 00 00 00 00       	mov    $0x0,%eax
 9ea:	eb f4                	jmp    9e0 <morecore+0x44>

000009ec <malloc>:

void*
malloc(uint nbytes)
{
 9ec:	55                   	push   %ebp
 9ed:	89 e5                	mov    %esp,%ebp
 9ef:	53                   	push   %ebx
 9f0:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9f3:	8b 45 08             	mov    0x8(%ebp),%eax
 9f6:	8d 58 07             	lea    0x7(%eax),%ebx
 9f9:	c1 eb 03             	shr    $0x3,%ebx
 9fc:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 9ff:	8b 0d bc 0e 00 00    	mov    0xebc,%ecx
 a05:	85 c9                	test   %ecx,%ecx
 a07:	74 04                	je     a0d <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a09:	8b 01                	mov    (%ecx),%eax
 a0b:	eb 4d                	jmp    a5a <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 a0d:	c7 05 bc 0e 00 00 c0 	movl   $0xec0,0xebc
 a14:	0e 00 00 
 a17:	c7 05 c0 0e 00 00 c0 	movl   $0xec0,0xec0
 a1e:	0e 00 00 
    base.s.size = 0;
 a21:	c7 05 c4 0e 00 00 00 	movl   $0x0,0xec4
 a28:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 a2b:	b9 c0 0e 00 00       	mov    $0xec0,%ecx
 a30:	eb d7                	jmp    a09 <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 a32:	39 da                	cmp    %ebx,%edx
 a34:	74 1a                	je     a50 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 a36:	29 da                	sub    %ebx,%edx
 a38:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a3b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 a3e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 a41:	89 0d bc 0e 00 00    	mov    %ecx,0xebc
      return (void*)(p + 1);
 a47:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a4a:	83 c4 04             	add    $0x4,%esp
 a4d:	5b                   	pop    %ebx
 a4e:	5d                   	pop    %ebp
 a4f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 a50:	8b 10                	mov    (%eax),%edx
 a52:	89 11                	mov    %edx,(%ecx)
 a54:	eb eb                	jmp    a41 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a56:	89 c1                	mov    %eax,%ecx
 a58:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 a5a:	8b 50 04             	mov    0x4(%eax),%edx
 a5d:	39 da                	cmp    %ebx,%edx
 a5f:	73 d1                	jae    a32 <malloc+0x46>
    if(p == freep)
 a61:	39 05 bc 0e 00 00    	cmp    %eax,0xebc
 a67:	75 ed                	jne    a56 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 a69:	89 d8                	mov    %ebx,%eax
 a6b:	e8 2c ff ff ff       	call   99c <morecore>
 a70:	85 c0                	test   %eax,%eax
 a72:	75 e2                	jne    a56 <malloc+0x6a>
        return 0;
 a74:	b8 00 00 00 00       	mov    $0x0,%eax
 a79:	eb cf                	jmp    a4a <malloc+0x5e>
