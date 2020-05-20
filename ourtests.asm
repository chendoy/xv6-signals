
_ourtests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    return;

}

int main()
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 0c             	sub    $0xc,%esp
    // printf(0,"--------- SIGPROCMASK TEST ---------\n");
    // sigprocmask_test();
    printf(0,"--------- STOP_CONT_KILL_ABC TEST ---------\n");
      11:	68 f0 1b 00 00       	push   $0x1bf0
      16:	6a 00                	push   $0x0
      18:	e8 e3 12 00 00       	call   1300 <printf>
    cont_stop_kill_abc_test();
      1d:	e8 ee 00 00 00       	call   110 <cont_stop_kill_abc_test>
    // printf(0,"\n");
    // printf(0,"---------  SIGNAL TESTS 3 --------- \n");
    // SignalTests3();
    // printf(0,"\n");

    printf(0,"Done TESTS\n");
      22:	58                   	pop    %eax
      23:	5a                   	pop    %edx
      24:	68 7b 1e 00 00       	push   $0x1e7b
      29:	6a 00                	push   $0x0
      2b:	e8 d0 12 00 00       	call   1300 <printf>
    exit();
      30:	e8 6d 11 00 00       	call   11a2 <exit>
      35:	66 90                	xchg   %ax,%ax
      37:	66 90                	xchg   %ax,%ax
      39:	66 90                	xchg   %ax,%ax
      3b:	66 90                	xchg   %ax,%ax
      3d:	66 90                	xchg   %ax,%ax
      3f:	90                   	nop

00000040 <custom_handler>:
{
      40:	55                   	push   %ebp
      41:	89 e5                	mov    %esp,%ebp
      43:	83 ec 10             	sub    $0x10,%esp
    printf(1, "child: CUSTOM HANDLER WAS FIRED!!\n");
      46:	68 58 16 00 00       	push   $0x1658
      4b:	6a 01                	push   $0x1
      4d:	e8 ae 12 00 00       	call   1300 <printf>
    return;
      52:	83 c4 10             	add    $0x10,%esp
}
      55:	c9                   	leave  
      56:	c3                   	ret    
      57:	89 f6                	mov    %esi,%esi
      59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000060 <user_handler_signal>:
{
      60:	55                   	push   %ebp
      61:	89 e5                	mov    %esp,%ebp
      63:	83 ec 08             	sub    $0x8,%esp
    printf(0,"pid : %d is Using User Handler Signal - %d!!!!WOrks!!!\n", getpid(),signum);
      66:	e8 b7 11 00 00       	call   1222 <getpid>
      6b:	ff 75 08             	pushl  0x8(%ebp)
      6e:	50                   	push   %eax
      6f:	68 7c 16 00 00       	push   $0x167c
      74:	6a 00                	push   $0x0
      76:	e8 85 12 00 00       	call   1300 <printf>
    return;
      7b:	83 c4 10             	add    $0x10,%esp
}
      7e:	c9                   	leave  
      7f:	c3                   	ret    

00000080 <sigprocmask_test>:
{
      80:	55                   	push   %ebp
      81:	89 e5                	mov    %esp,%ebp
      83:	56                   	push   %esi
      84:	53                   	push   %ebx
    for(i = 1; i < ITER_SIGPROCMASK_TEST; i++) {
      85:	bb 01 00 00 00       	mov    $0x1,%ebx
{
      8a:	83 ec 10             	sub    $0x10,%esp
      8d:	8d 76 00             	lea    0x0(%esi),%esi
        omask = sigprocmask(mask);
      90:	83 ec 0c             	sub    $0xc,%esp
      93:	53                   	push   %ebx
      94:	e8 a9 11 00 00       	call   1242 <sigprocmask>
        printf(1, "should be %d = %d\n", i-1 ,omask);
      99:	50                   	push   %eax
      9a:	8d 43 ff             	lea    -0x1(%ebx),%eax
    for(i = 1; i < ITER_SIGPROCMASK_TEST; i++) {
      9d:	83 c3 01             	add    $0x1,%ebx
        printf(1, "should be %d = %d\n", i-1 ,omask);
      a0:	50                   	push   %eax
      a1:	68 20 1c 00 00       	push   $0x1c20
      a6:	6a 01                	push   $0x1
      a8:	e8 53 12 00 00       	call   1300 <printf>
    for(i = 1; i < ITER_SIGPROCMASK_TEST; i++) {
      ad:	83 c4 20             	add    $0x20,%esp
      b0:	83 fb 0a             	cmp    $0xa,%ebx
      b3:	75 db                	jne    90 <sigprocmask_test+0x10>
    sigaction(12, &newact, &oldact);
      b5:	8d 5d f0             	lea    -0x10(%ebp),%ebx
      b8:	8d 75 e8             	lea    -0x18(%ebp),%esi
      bb:	83 ec 04             	sub    $0x4,%esp
    newact.sa_handler = SIG_IGN;
      be:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    newact.sigmask = 12;
      c5:	c7 45 ec 0c 00 00 00 	movl   $0xc,-0x14(%ebp)
    sigaction(12, &newact, &oldact);
      cc:	53                   	push   %ebx
      cd:	56                   	push   %esi
      ce:	6a 0c                	push   $0xc
      d0:	e8 75 11 00 00       	call   124a <sigaction>
    printf(1, "should be 0,0 = %d,%d\n", (uint)oldact.sa_handler, oldact.sigmask);
      d5:	ff 75 f4             	pushl  -0xc(%ebp)
      d8:	ff 75 f0             	pushl  -0x10(%ebp)
      db:	68 33 1c 00 00       	push   $0x1c33
      e0:	6a 01                	push   $0x1
      e2:	e8 19 12 00 00       	call   1300 <printf>
    sigaction(12, &oldact, &newact);
      e7:	83 c4 1c             	add    $0x1c,%esp
      ea:	56                   	push   %esi
      eb:	53                   	push   %ebx
      ec:	6a 0c                	push   $0xc
      ee:	e8 57 11 00 00       	call   124a <sigaction>
    printf(1, "should be 1,12 = %d,%d\n", (uint)newact.sa_handler, newact.sigmask);
      f3:	ff 75 ec             	pushl  -0x14(%ebp)
      f6:	ff 75 e8             	pushl  -0x18(%ebp)
      f9:	68 4a 1c 00 00       	push   $0x1c4a
      fe:	6a 01                	push   $0x1
     100:	e8 fb 11 00 00       	call   1300 <printf>
}
     105:	83 c4 20             	add    $0x20,%esp
     108:	8d 65 f8             	lea    -0x8(%ebp),%esp
     10b:	5b                   	pop    %ebx
     10c:	5e                   	pop    %esi
     10d:	5d                   	pop    %ebp
     10e:	c3                   	ret    
     10f:	90                   	nop

00000110 <cont_stop_kill_abc_test>:
{
     110:	55                   	push   %ebp
     111:	89 e5                	mov    %esp,%ebp
     113:	57                   	push   %edi
     114:	56                   	push   %esi
     115:	53                   	push   %ebx
     116:	83 ec 1c             	sub    $0x1c,%esp
    int sigs[] = {SIGSTOP, SIGCONT};
     119:	c7 45 e0 11 00 00 00 	movl   $0x11,-0x20(%ebp)
     120:	c7 45 e4 13 00 00 00 	movl   $0x13,-0x1c(%ebp)
    if((pid = fork()) == 0) {
     127:	e8 6e 10 00 00       	call   119a <fork>
     12c:	85 c0                	test   %eax,%eax
     12e:	74 70                	je     1a0 <cont_stop_kill_abc_test+0x90>
     130:	89 c6                	mov    %eax,%esi
     132:	bf 11 00 00 00       	mov    $0x11,%edi
        for (int i = 0; i < 20; i++)
     137:	31 db                	xor    %ebx,%ebx
     139:	eb 41                	jmp    17c <cont_stop_kill_abc_test+0x6c>
                printf(2, "\n%d: SENT: CONT\n", i);
     13b:	83 ec 04             	sub    $0x4,%esp
     13e:	53                   	push   %ebx
     13f:	68 96 1c 00 00       	push   $0x1c96
     144:	6a 02                	push   $0x2
     146:	e8 b5 11 00 00       	call   1300 <printf>
     14b:	83 c4 10             	add    $0x10,%esp
            kill(pid, sigs[i%2]);
     14e:	83 ec 08             	sub    $0x8,%esp
        for (int i = 0; i < 20; i++)
     151:	83 c3 01             	add    $0x1,%ebx
            kill(pid, sigs[i%2]);
     154:	57                   	push   %edi
     155:	56                   	push   %esi
     156:	e8 77 10 00 00       	call   11d2 <kill>
            sleep(30);
     15b:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
     162:	e8 cb 10 00 00       	call   1232 <sleep>
        for (int i = 0; i < 20; i++)
     167:	83 c4 10             	add    $0x10,%esp
     16a:	83 fb 14             	cmp    $0x14,%ebx
     16d:	0f 84 d7 02 00 00    	je     44a <cont_stop_kill_abc_test+0x33a>
     173:	89 d8                	mov    %ebx,%eax
     175:	83 e0 01             	and    $0x1,%eax
     178:	8b 7c 85 e0          	mov    -0x20(%ebp,%eax,4),%edi
            if (i % 2)
     17c:	f6 c3 01             	test   $0x1,%bl
     17f:	75 ba                	jne    13b <cont_stop_kill_abc_test+0x2b>
                printf(2, "\n%d: SENT: STOP\n", i);    
     181:	83 ec 04             	sub    $0x4,%esp
     184:	53                   	push   %ebx
     185:	68 a7 1c 00 00       	push   $0x1ca7
     18a:	6a 02                	push   $0x2
     18c:	e8 6f 11 00 00       	call   1300 <printf>
     191:	83 c4 10             	add    $0x10,%esp
     194:	eb b8                	jmp    14e <cont_stop_kill_abc_test+0x3e>
     196:	8d 76 00             	lea    0x0(%esi),%esi
     199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            sleep(5);printf(1, "a");sleep(5);printf(1, "b");sleep(5);printf(1, "c");sleep(5);printf(1, "d");
     1a0:	83 ec 0c             	sub    $0xc,%esp
     1a3:	6a 05                	push   $0x5
     1a5:	e8 88 10 00 00       	call   1232 <sleep>
     1aa:	59                   	pop    %ecx
     1ab:	5b                   	pop    %ebx
     1ac:	68 62 1c 00 00       	push   $0x1c62
     1b1:	6a 01                	push   $0x1
     1b3:	e8 48 11 00 00       	call   1300 <printf>
     1b8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     1bf:	e8 6e 10 00 00       	call   1232 <sleep>
     1c4:	5e                   	pop    %esi
     1c5:	5f                   	pop    %edi
     1c6:	68 64 1c 00 00       	push   $0x1c64
     1cb:	6a 01                	push   $0x1
     1cd:	e8 2e 11 00 00       	call   1300 <printf>
     1d2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     1d9:	e8 54 10 00 00       	call   1232 <sleep>
     1de:	58                   	pop    %eax
     1df:	5a                   	pop    %edx
     1e0:	68 66 1c 00 00       	push   $0x1c66
     1e5:	6a 01                	push   $0x1
     1e7:	e8 14 11 00 00       	call   1300 <printf>
     1ec:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     1f3:	e8 3a 10 00 00       	call   1232 <sleep>
     1f8:	59                   	pop    %ecx
     1f9:	5b                   	pop    %ebx
     1fa:	68 68 1c 00 00       	push   $0x1c68
     1ff:	6a 01                	push   $0x1
     201:	e8 fa 10 00 00       	call   1300 <printf>
            sleep(5);printf(1, "e");sleep(5);printf(1, "f");sleep(5);printf(1, "g");sleep(5);printf(1, "h");
     206:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     20d:	e8 20 10 00 00       	call   1232 <sleep>
     212:	5e                   	pop    %esi
     213:	5f                   	pop    %edi
     214:	68 6a 1c 00 00       	push   $0x1c6a
     219:	6a 01                	push   $0x1
     21b:	e8 e0 10 00 00       	call   1300 <printf>
     220:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     227:	e8 06 10 00 00       	call   1232 <sleep>
     22c:	58                   	pop    %eax
     22d:	5a                   	pop    %edx
     22e:	68 6c 1c 00 00       	push   $0x1c6c
     233:	6a 01                	push   $0x1
     235:	e8 c6 10 00 00       	call   1300 <printf>
     23a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     241:	e8 ec 0f 00 00       	call   1232 <sleep>
     246:	59                   	pop    %ecx
     247:	5b                   	pop    %ebx
     248:	68 6e 1c 00 00       	push   $0x1c6e
     24d:	6a 01                	push   $0x1
     24f:	e8 ac 10 00 00       	call   1300 <printf>
     254:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     25b:	e8 d2 0f 00 00       	call   1232 <sleep>
     260:	5e                   	pop    %esi
     261:	5f                   	pop    %edi
     262:	68 70 1c 00 00       	push   $0x1c70
     267:	6a 01                	push   $0x1
     269:	e8 92 10 00 00       	call   1300 <printf>
            sleep(5);printf(1, "i");sleep(5);printf(1, "j");sleep(5);printf(1, "k");sleep(5);printf(1, "l");
     26e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     275:	e8 b8 0f 00 00       	call   1232 <sleep>
     27a:	58                   	pop    %eax
     27b:	5a                   	pop    %edx
     27c:	68 72 1c 00 00       	push   $0x1c72
     281:	6a 01                	push   $0x1
     283:	e8 78 10 00 00       	call   1300 <printf>
     288:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     28f:	e8 9e 0f 00 00       	call   1232 <sleep>
     294:	59                   	pop    %ecx
     295:	5b                   	pop    %ebx
     296:	68 74 1c 00 00       	push   $0x1c74
     29b:	6a 01                	push   $0x1
     29d:	e8 5e 10 00 00       	call   1300 <printf>
     2a2:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2a9:	e8 84 0f 00 00       	call   1232 <sleep>
     2ae:	5e                   	pop    %esi
     2af:	5f                   	pop    %edi
     2b0:	68 76 1c 00 00       	push   $0x1c76
     2b5:	6a 01                	push   $0x1
     2b7:	e8 44 10 00 00       	call   1300 <printf>
     2bc:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2c3:	e8 6a 0f 00 00       	call   1232 <sleep>
     2c8:	58                   	pop    %eax
     2c9:	5a                   	pop    %edx
     2ca:	68 78 1c 00 00       	push   $0x1c78
     2cf:	6a 01                	push   $0x1
     2d1:	e8 2a 10 00 00       	call   1300 <printf>
            sleep(5);printf(1, "m");sleep(5);printf(1, "n");sleep(5);printf(1, "o");sleep(5);printf(1, "p");
     2d6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2dd:	e8 50 0f 00 00       	call   1232 <sleep>
     2e2:	59                   	pop    %ecx
     2e3:	5b                   	pop    %ebx
     2e4:	68 7a 1c 00 00       	push   $0x1c7a
     2e9:	6a 01                	push   $0x1
     2eb:	e8 10 10 00 00       	call   1300 <printf>
     2f0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2f7:	e8 36 0f 00 00       	call   1232 <sleep>
     2fc:	5e                   	pop    %esi
     2fd:	5f                   	pop    %edi
     2fe:	68 7c 1c 00 00       	push   $0x1c7c
     303:	6a 01                	push   $0x1
     305:	e8 f6 0f 00 00       	call   1300 <printf>
     30a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     311:	e8 1c 0f 00 00       	call   1232 <sleep>
     316:	58                   	pop    %eax
     317:	5a                   	pop    %edx
     318:	68 7e 1c 00 00       	push   $0x1c7e
     31d:	6a 01                	push   $0x1
     31f:	e8 dc 0f 00 00       	call   1300 <printf>
     324:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     32b:	e8 02 0f 00 00       	call   1232 <sleep>
     330:	59                   	pop    %ecx
     331:	5b                   	pop    %ebx
     332:	68 80 1c 00 00       	push   $0x1c80
     337:	6a 01                	push   $0x1
     339:	e8 c2 0f 00 00       	call   1300 <printf>
            sleep(5);printf(1, "q");sleep(5);printf(1, "r");sleep(5);printf(1, "s");sleep(5);printf(1, "t");
     33e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     345:	e8 e8 0e 00 00       	call   1232 <sleep>
     34a:	5e                   	pop    %esi
     34b:	5f                   	pop    %edi
     34c:	68 82 1c 00 00       	push   $0x1c82
     351:	6a 01                	push   $0x1
     353:	e8 a8 0f 00 00       	call   1300 <printf>
     358:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     35f:	e8 ce 0e 00 00       	call   1232 <sleep>
     364:	58                   	pop    %eax
     365:	5a                   	pop    %edx
     366:	68 84 1c 00 00       	push   $0x1c84
     36b:	6a 01                	push   $0x1
     36d:	e8 8e 0f 00 00       	call   1300 <printf>
     372:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     379:	e8 b4 0e 00 00       	call   1232 <sleep>
     37e:	59                   	pop    %ecx
     37f:	5b                   	pop    %ebx
     380:	68 86 1c 00 00       	push   $0x1c86
     385:	6a 01                	push   $0x1
     387:	e8 74 0f 00 00       	call   1300 <printf>
     38c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     393:	e8 9a 0e 00 00       	call   1232 <sleep>
     398:	5e                   	pop    %esi
     399:	5f                   	pop    %edi
     39a:	68 88 1c 00 00       	push   $0x1c88
     39f:	6a 01                	push   $0x1
     3a1:	e8 5a 0f 00 00       	call   1300 <printf>
            sleep(5);printf(1, "u");sleep(5);printf(1, "v");sleep(5);printf(1, "w");sleep(5);printf(1, "x");
     3a6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     3ad:	e8 80 0e 00 00       	call   1232 <sleep>
     3b2:	58                   	pop    %eax
     3b3:	5a                   	pop    %edx
     3b4:	68 8a 1c 00 00       	push   $0x1c8a
     3b9:	6a 01                	push   $0x1
     3bb:	e8 40 0f 00 00       	call   1300 <printf>
     3c0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     3c7:	e8 66 0e 00 00       	call   1232 <sleep>
     3cc:	59                   	pop    %ecx
     3cd:	5b                   	pop    %ebx
     3ce:	68 8c 1c 00 00       	push   $0x1c8c
     3d3:	6a 01                	push   $0x1
     3d5:	e8 26 0f 00 00       	call   1300 <printf>
     3da:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     3e1:	e8 4c 0e 00 00       	call   1232 <sleep>
     3e6:	5e                   	pop    %esi
     3e7:	5f                   	pop    %edi
     3e8:	68 8e 1c 00 00       	push   $0x1c8e
     3ed:	6a 01                	push   $0x1
     3ef:	e8 0c 0f 00 00       	call   1300 <printf>
     3f4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     3fb:	e8 32 0e 00 00       	call   1232 <sleep>
     400:	58                   	pop    %eax
     401:	5a                   	pop    %edx
     402:	68 90 1c 00 00       	push   $0x1c90
     407:	6a 01                	push   $0x1
     409:	e8 f2 0e 00 00       	call   1300 <printf>
            sleep(5);printf(1, "y");sleep(5);printf(1, "z");
     40e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     415:	e8 18 0e 00 00       	call   1232 <sleep>
     41a:	59                   	pop    %ecx
     41b:	5b                   	pop    %ebx
     41c:	68 92 1c 00 00       	push   $0x1c92
     421:	6a 01                	push   $0x1
     423:	e8 d8 0e 00 00       	call   1300 <printf>
     428:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     42f:	e8 fe 0d 00 00       	call   1232 <sleep>
     434:	5e                   	pop    %esi
     435:	5f                   	pop    %edi
     436:	68 94 1c 00 00       	push   $0x1c94
     43b:	6a 01                	push   $0x1
     43d:	e8 be 0e 00 00       	call   1300 <printf>
     442:	83 c4 10             	add    $0x10,%esp
     445:	e9 56 fd ff ff       	jmp    1a0 <cont_stop_kill_abc_test+0x90>
        printf(1, "\nSENT: KILL!\n");
     44a:	83 ec 08             	sub    $0x8,%esp
     44d:	68 b8 1c 00 00       	push   $0x1cb8
     452:	6a 01                	push   $0x1
     454:	e8 a7 0e 00 00       	call   1300 <printf>
        kill(pid, SIGKILL);
     459:	58                   	pop    %eax
     45a:	5a                   	pop    %edx
     45b:	6a 09                	push   $0x9
     45d:	56                   	push   %esi
     45e:	e8 6f 0d 00 00       	call   11d2 <kill>
        wait();
     463:	83 c4 10             	add    $0x10,%esp
}
     466:	8d 65 f4             	lea    -0xc(%ebp),%esp
     469:	5b                   	pop    %ebx
     46a:	5e                   	pop    %esi
     46b:	5f                   	pop    %edi
     46c:	5d                   	pop    %ebp
        wait();
     46d:	e9 38 0d 00 00       	jmp    11aa <wait>
     472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000480 <user_handler_test>:
{
     480:	55                   	push   %ebp
     481:	89 e5                	mov    %esp,%ebp
     483:	53                   	push   %ebx
     484:	83 ec 14             	sub    $0x14,%esp
    act.sa_handler = &custom_handler;
     487:	c7 45 f0 40 00 00 00 	movl   $0x40,-0x10(%ebp)
    act.sigmask = mask;
     48e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if((pid = fork()) == 0) 
     495:	e8 00 0d 00 00       	call   119a <fork>
     49a:	85 c0                	test   %eax,%eax
     49c:	75 3a                	jne    4d8 <user_handler_test+0x58>
        sigaction(SIGTEST, &act, null); // register custom handler
     49e:	8d 45 f0             	lea    -0x10(%ebp),%eax
     4a1:	83 ec 04             	sub    $0x4,%esp
     4a4:	6a 00                	push   $0x0
     4a6:	50                   	push   %eax
     4a7:	6a 14                	push   $0x14
     4a9:	e8 9c 0d 00 00       	call   124a <sigaction>
     4ae:	83 c4 10             	add    $0x10,%esp
     4b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(1, "child: waiting...\n");
     4b8:	83 ec 08             	sub    $0x8,%esp
     4bb:	68 c6 1c 00 00       	push   $0x1cc6
     4c0:	6a 01                	push   $0x1
     4c2:	e8 39 0e 00 00       	call   1300 <printf>
            sleep(30);
     4c7:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
     4ce:	e8 5f 0d 00 00       	call   1232 <sleep>
     4d3:	83 c4 10             	add    $0x10,%esp
     4d6:	eb e0                	jmp    4b8 <user_handler_test+0x38>
        sleep(300); // let child print some lines
     4d8:	83 ec 0c             	sub    $0xc,%esp
     4db:	89 c3                	mov    %eax,%ebx
     4dd:	68 2c 01 00 00       	push   $0x12c
     4e2:	e8 4b 0d 00 00       	call   1232 <sleep>
        printf(1, "parent: kill(child, SIGTEST)\n");
     4e7:	58                   	pop    %eax
     4e8:	5a                   	pop    %edx
     4e9:	68 d9 1c 00 00       	push   $0x1cd9
     4ee:	6a 01                	push   $0x1
     4f0:	e8 0b 0e 00 00       	call   1300 <printf>
        sleep(5);
     4f5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     4fc:	e8 31 0d 00 00       	call   1232 <sleep>
        kill(pid, SIGTEST);
     501:	59                   	pop    %ecx
     502:	58                   	pop    %eax
     503:	6a 14                	push   $0x14
     505:	53                   	push   %ebx
     506:	e8 c7 0c 00 00       	call   11d2 <kill>
        sleep(50);
     50b:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     512:	e8 1b 0d 00 00       	call   1232 <sleep>
        printf(1, "parent: kill(child, SIGKILL)\n");
     517:	58                   	pop    %eax
     518:	5a                   	pop    %edx
     519:	68 f7 1c 00 00       	push   $0x1cf7
     51e:	6a 01                	push   $0x1
     520:	e8 db 0d 00 00       	call   1300 <printf>
        kill(pid, SIGKILL);
     525:	59                   	pop    %ecx
     526:	58                   	pop    %eax
     527:	6a 09                	push   $0x9
     529:	53                   	push   %ebx
     52a:	e8 a3 0c 00 00       	call   11d2 <kill>
        wait();
     52f:	e8 76 0c 00 00       	call   11aa <wait>
        return;
     534:	83 c4 10             	add    $0x10,%esp
}
     537:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     53a:	c9                   	leave  
     53b:	c3                   	ret    
     53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000540 <simple_sigaction_test>:
{
     540:	55                   	push   %ebp
     541:	89 e5                	mov    %esp,%ebp
     543:	57                   	push   %edi
     544:	56                   	push   %esi
     545:	53                   	push   %ebx
     546:	83 ec 18             	sub    $0x18,%esp
    printf(0,"mask: %d\n",sigprocmask(0));
     549:	6a 00                	push   $0x0
     54b:	e8 f2 0c 00 00       	call   1242 <sigprocmask>
     550:	83 c4 0c             	add    $0xc,%esp
     553:	50                   	push   %eax
     554:	68 15 1d 00 00       	push   $0x1d15
     559:	6a 00                	push   $0x0
     55b:	e8 a0 0d 00 00       	call   1300 <printf>
    printf(0,"mask: %d\n",sigprocmask(100));
     560:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     567:	e8 d6 0c 00 00       	call   1242 <sigprocmask>
     56c:	83 c4 0c             	add    $0xc,%esp
     56f:	50                   	push   %eax
     570:	68 15 1d 00 00       	push   $0x1d15
     575:	6a 00                	push   $0x0
     577:	e8 84 0d 00 00       	call   1300 <printf>
    printf(0,"mask: %d\n",sigprocmask(0));
     57c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     583:	e8 ba 0c 00 00       	call   1242 <sigprocmask>
     588:	83 c4 0c             	add    $0xc,%esp
     58b:	50                   	push   %eax
     58c:	68 15 1d 00 00       	push   $0x1d15
     591:	6a 00                	push   $0x0
     593:	e8 68 0d 00 00       	call   1300 <printf>
    printf(0,"Start SigactionTetss\n");
     598:	58                   	pop    %eax
     599:	5a                   	pop    %edx
     59a:	68 1f 1d 00 00       	push   $0x1d1f
     59f:	6a 00                	push   $0x0
     5a1:	e8 5a 0d 00 00       	call   1300 <printf>
    struct sigaction *FIrstSigAct = malloc(sizeof(struct sigaction));
     5a6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     5ad:	e8 ae 0f 00 00       	call   1560 <malloc>
    FIrstSigAct->sa_handler = (void (*)())14;
     5b2:	c7 00 0e 00 00 00    	movl   $0xe,(%eax)
    FIrstSigAct->sigmask=7;
     5b8:	c7 40 04 07 00 00 00 	movl   $0x7,0x4(%eax)
    struct sigaction *FIrstSigAct = malloc(sizeof(struct sigaction));
     5bf:	89 c6                	mov    %eax,%esi
    printf(0,"Create SigAction1 with handler(int 14) and mask (int 7)\n");
     5c1:	59                   	pop    %ecx
     5c2:	5b                   	pop    %ebx
     5c3:	68 b4 16 00 00       	push   $0x16b4
     5c8:	6a 00                	push   $0x0
     5ca:	e8 31 0d 00 00       	call   1300 <printf>
    struct sigaction *SecondSigAct = malloc(sizeof(struct sigaction));
     5cf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     5d6:	e8 85 0f 00 00       	call   1560 <malloc>
    SecondSigAct->sa_handler = (void (*)())22;
     5db:	c7 00 16 00 00 00    	movl   $0x16,(%eax)
    SecondSigAct->sigmask=8;
     5e1:	c7 40 04 08 00 00 00 	movl   $0x8,0x4(%eax)
    struct sigaction *SecondSigAct = malloc(sizeof(struct sigaction));
     5e8:	89 c7                	mov    %eax,%edi
    printf(0,"Create SigAction2 with handler(int 22) and mask (int 8)\n");
     5ea:	58                   	pop    %eax
     5eb:	5a                   	pop    %edx
     5ec:	68 f0 16 00 00       	push   $0x16f0
     5f1:	6a 00                	push   $0x0
     5f3:	e8 08 0d 00 00       	call   1300 <printf>
    printf(0,"Check SigAct1 handler number: %d\n",FIrstSigAct->sa_handler);
     5f8:	83 c4 0c             	add    $0xc,%esp
     5fb:	ff 36                	pushl  (%esi)
     5fd:	68 2c 17 00 00       	push   $0x172c
     602:	6a 00                	push   $0x0
     604:	e8 f7 0c 00 00       	call   1300 <printf>
    printf(0,"Performing First sigaction assign to signum 4 SigAction1\n");
     609:	59                   	pop    %ecx
     60a:	5b                   	pop    %ebx
     60b:	68 50 17 00 00       	push   $0x1750
     610:	6a 00                	push   $0x0
     612:	e8 e9 0c 00 00       	call   1300 <printf>
    sigaction(4,FIrstSigAct,null);
     617:	83 c4 0c             	add    $0xc,%esp
     61a:	6a 00                	push   $0x0
     61c:	56                   	push   %esi
     61d:	6a 04                	push   $0x4
     61f:	e8 26 0c 00 00       	call   124a <sigaction>
    struct sigaction *ThirdSigAct = malloc(sizeof(struct sigaction));
     624:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     62b:	e8 30 0f 00 00       	call   1560 <malloc>
     630:	89 c3                	mov    %eax,%ebx
    printf(0,"Creating SigAction3 to hold the old action hander\n");
     632:	58                   	pop    %eax
     633:	5a                   	pop    %edx
     634:	68 8c 17 00 00       	push   $0x178c
     639:	6a 00                	push   $0x0
     63b:	e8 c0 0c 00 00       	call   1300 <printf>
    sigaction(4, SecondSigAct, ThirdSigAct);
     640:	83 c4 0c             	add    $0xc,%esp
     643:	53                   	push   %ebx
     644:	57                   	push   %edi
     645:	6a 04                	push   $0x4
     647:	e8 fe 0b 00 00       	call   124a <sigaction>
    printf(0,"Changed signum 4 to hold SigAction2 and Sigaction 3 will hold SigAction1\n");
     64c:	59                   	pop    %ecx
     64d:	58                   	pop    %eax
     64e:	68 c0 17 00 00       	push   $0x17c0
     653:	6a 00                	push   $0x0
     655:	e8 a6 0c 00 00       	call   1300 <printf>
    printf(0,"SigAction3 handler should be 14: %d\n",ThirdSigAct->sa_handler);
     65a:	83 c4 0c             	add    $0xc,%esp
     65d:	ff 33                	pushl  (%ebx)
     65f:	68 0c 18 00 00       	push   $0x180c
     664:	6a 00                	push   $0x0
     666:	e8 95 0c 00 00       	call   1300 <printf>
    printf(0,"SigAction3 mask should be 7: %d\n",ThirdSigAct->sigmask);
     66b:	83 c4 0c             	add    $0xc,%esp
     66e:	ff 73 04             	pushl  0x4(%ebx)
     671:	68 34 18 00 00       	push   $0x1834
     676:	6a 00                	push   $0x0
     678:	e8 83 0c 00 00       	call   1300 <printf>
    sigaction(4,SecondSigAct,null);
     67d:	83 c4 0c             	add    $0xc,%esp
     680:	6a 00                	push   $0x0
     682:	57                   	push   %edi
     683:	6a 04                	push   $0x4
     685:	e8 c0 0b 00 00       	call   124a <sigaction>
    printf(0,"SigAction3 handler should be 14: %d\n",ThirdSigAct->sa_handler);
     68a:	83 c4 0c             	add    $0xc,%esp
     68d:	ff 33                	pushl  (%ebx)
     68f:	68 0c 18 00 00       	push   $0x180c
     694:	6a 00                	push   $0x0
     696:	e8 65 0c 00 00       	call   1300 <printf>
    printf(0,"SigAction3 mask should be 7: %d\n",ThirdSigAct->sigmask);
     69b:	83 c4 0c             	add    $0xc,%esp
     69e:	ff 73 04             	pushl  0x4(%ebx)
     6a1:	68 34 18 00 00       	push   $0x1834
     6a6:	6a 00                	push   $0x0
     6a8:	e8 53 0c 00 00       	call   1300 <printf>
    struct sigaction *ForthSigAct = malloc(sizeof(struct sigaction));
     6ad:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     6b4:	e8 a7 0e 00 00       	call   1560 <malloc>
     6b9:	89 c7                	mov    %eax,%edi
    ForthSigAct->sa_handler = (void (*)())28;
     6bb:	c7 00 1c 00 00 00    	movl   $0x1c,(%eax)
    ForthSigAct->sigmask=4;
     6c1:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
    printf(0,"Create SigAction4 with handler(int 28) and mask (int 4)\n");
     6c8:	58                   	pop    %eax
     6c9:	5a                   	pop    %edx
     6ca:	68 58 18 00 00       	push   $0x1858
     6cf:	6a 00                	push   $0x0
     6d1:	e8 2a 0c 00 00       	call   1300 <printf>
    sigaction(4, ForthSigAct, null);
     6d6:	83 c4 0c             	add    $0xc,%esp
     6d9:	6a 00                	push   $0x0
     6db:	57                   	push   %edi
     6dc:	6a 04                	push   $0x4
     6de:	e8 67 0b 00 00       	call   124a <sigaction>
    printf(0,"Changed signum 4 to hold SigAction4 and do not save old\n");
     6e3:	59                   	pop    %ecx
     6e4:	58                   	pop    %eax
     6e5:	68 94 18 00 00       	push   $0x1894
     6ea:	6a 00                	push   $0x0
     6ec:	e8 0f 0c 00 00       	call   1300 <printf>
    sigaction(4, ForthSigAct, FIrstSigAct);
     6f1:	83 c4 0c             	add    $0xc,%esp
     6f4:	56                   	push   %esi
     6f5:	57                   	push   %edi
     6f6:	6a 04                	push   $0x4
     6f8:	e8 4d 0b 00 00       	call   124a <sigaction>
    printf(0,"Changed signum 4 to hold SigAction4 and FirstSigact will hold the old (sig4)\n");
     6fd:	58                   	pop    %eax
     6fe:	5a                   	pop    %edx
     6ff:	68 d0 18 00 00       	push   $0x18d0
     704:	6a 00                	push   $0x0
     706:	e8 f5 0b 00 00       	call   1300 <printf>
    printf(0,"SigAction1 handler should be 28: %d\n",FIrstSigAct->sa_handler);
     70b:	83 c4 0c             	add    $0xc,%esp
     70e:	ff 36                	pushl  (%esi)
     710:	68 20 19 00 00       	push   $0x1920
     715:	6a 00                	push   $0x0
     717:	e8 e4 0b 00 00       	call   1300 <printf>
    printf(0,"SigAction1 mask should be 4: %d\n",FIrstSigAct->sigmask);
     71c:	83 c4 0c             	add    $0xc,%esp
     71f:	ff 76 04             	pushl  0x4(%esi)
     722:	68 48 19 00 00       	push   $0x1948
     727:	6a 00                	push   $0x0
     729:	e8 d2 0b 00 00       	call   1300 <printf>
    printf(0,"Error Tests - Will check things that should not changed are working\n");
     72e:	59                   	pop    %ecx
     72f:	5e                   	pop    %esi
     730:	68 6c 19 00 00       	push   $0x196c
     735:	6a 00                	push   $0x0
     737:	e8 c4 0b 00 00       	call   1300 <printf>
    printf(0,"Try to Change signum kill\n");
     73c:	58                   	pop    %eax
     73d:	5a                   	pop    %edx
     73e:	68 35 1d 00 00       	push   $0x1d35
     743:	6a 00                	push   $0x0
     745:	e8 b6 0b 00 00       	call   1300 <printf>
    sigaction(SIGKILL, ForthSigAct, ThirdSigAct);
     74a:	83 c4 0c             	add    $0xc,%esp
     74d:	53                   	push   %ebx
     74e:	57                   	push   %edi
     74f:	6a 09                	push   $0x9
     751:	e8 f4 0a 00 00       	call   124a <sigaction>
    printf(0,"Try to Change signum 43 (do not exist\n");
     756:	59                   	pop    %ecx
     757:	5e                   	pop    %esi
     758:	68 b4 19 00 00       	push   $0x19b4
     75d:	6a 00                	push   $0x0
     75f:	e8 9c 0b 00 00       	call   1300 <printf>
    sigaction(43, ForthSigAct, ThirdSigAct);
     764:	83 c4 0c             	add    $0xc,%esp
     767:	53                   	push   %ebx
     768:	57                   	push   %edi
     769:	6a 2b                	push   $0x2b
     76b:	e8 da 0a 00 00       	call   124a <sigaction>
    printf(0,"SigAction3 handler should be 14: %d\n",ThirdSigAct->sa_handler);
     770:	83 c4 0c             	add    $0xc,%esp
     773:	ff 33                	pushl  (%ebx)
     775:	68 0c 18 00 00       	push   $0x180c
     77a:	6a 00                	push   $0x0
     77c:	e8 7f 0b 00 00       	call   1300 <printf>
    printf(0,"SigAction3 mask should be 7: %d\n",ThirdSigAct->sigmask);
     781:	83 c4 0c             	add    $0xc,%esp
     784:	ff 73 04             	pushl  0x4(%ebx)
     787:	68 34 18 00 00       	push   $0x1834
     78c:	6a 00                	push   $0x0
     78e:	e8 6d 0b 00 00       	call   1300 <printf>
    printf(0,"Finished\n");
     793:	5f                   	pop    %edi
     794:	58                   	pop    %eax
     795:	68 50 1d 00 00       	push   $0x1d50
     79a:	6a 00                	push   $0x0
     79c:	e8 5f 0b 00 00       	call   1300 <printf>
    return;
     7a1:	83 c4 10             	add    $0x10,%esp
}
     7a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7a7:	5b                   	pop    %ebx
     7a8:	5e                   	pop    %esi
     7a9:	5f                   	pop    %edi
     7aa:	5d                   	pop    %ebp
     7ab:	c3                   	ret    
     7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007b0 <kill_self_test>:
{
     7b0:	55                   	push   %ebp
     7b1:	89 e5                	mov    %esp,%ebp
     7b3:	83 ec 08             	sub    $0x8,%esp
    kill(getpid(),SIGKILL);
     7b6:	e8 67 0a 00 00       	call   1222 <getpid>
     7bb:	83 ec 08             	sub    $0x8,%esp
     7be:	6a 09                	push   $0x9
     7c0:	50                   	push   %eax
     7c1:	e8 0c 0a 00 00       	call   11d2 <kill>
}
     7c6:	31 c0                	xor    %eax,%eax
     7c8:	c9                   	leave  
     7c9:	c3                   	ret    
     7ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000007d0 <kill_other>:
{
     7d0:	55                   	push   %ebp
     7d1:	89 e5                	mov    %esp,%ebp
     7d3:	83 ec 10             	sub    $0x10,%esp
    kill(child_kill,signum);
     7d6:	ff 75 0c             	pushl  0xc(%ebp)
     7d9:	ff 75 08             	pushl  0x8(%ebp)
     7dc:	e8 f1 09 00 00       	call   11d2 <kill>
}
     7e1:	31 c0                	xor    %eax,%eax
     7e3:	c9                   	leave  
     7e4:	c3                   	ret    
     7e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     7e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007f0 <SignalTests1>:
{
     7f0:	55                   	push   %ebp
     7f1:	89 e5                	mov    %esp,%ebp
     7f3:	53                   	push   %ebx
     7f4:	83 ec 04             	sub    $0x4,%esp
    if((child_pid[0]=fork()) == 0)
     7f7:	e8 9e 09 00 00       	call   119a <fork>
     7fc:	85 c0                	test   %eax,%eax
     7fe:	0f 84 cb 00 00 00    	je     8cf <SignalTests1+0xdf>
        if((child_pid[1]=fork()) == 0)
     804:	e8 91 09 00 00       	call   119a <fork>
     809:	85 c0                	test   %eax,%eax
     80b:	89 c3                	mov    %eax,%ebx
     80d:	75 7f                	jne    88e <SignalTests1+0x9e>
            struct sigaction *UserHandlerSignal = malloc(sizeof(struct sigaction));
     80f:	83 ec 0c             	sub    $0xc,%esp
     812:	6a 08                	push   $0x8
     814:	e8 47 0d 00 00       	call   1560 <malloc>
            UserHandlerSignal->sa_handler = user_handler_signal;
     819:	c7 00 60 00 00 00    	movl   $0x60,(%eax)
            UserHandlerSignal->sigmask=0;
     81f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            struct sigaction *UserHandlerSignal = malloc(sizeof(struct sigaction));
     826:	89 c3                	mov    %eax,%ebx
            printf(0,"Created User Handler Signal with mask that is 0\n");
     828:	58                   	pop    %eax
     829:	5a                   	pop    %edx
     82a:	68 2c 1a 00 00       	push   $0x1a2c
     82f:	6a 00                	push   $0x0
     831:	e8 ca 0a 00 00       	call   1300 <printf>
            sigaction(22,UserHandlerSignal,null);
     836:	83 c4 0c             	add    $0xc,%esp
     839:	6a 00                	push   $0x0
     83b:	53                   	push   %ebx
     83c:	6a 16                	push   $0x16
     83e:	e8 07 0a 00 00       	call   124a <sigaction>
            printf(0,"Assigned User Handler Signal to signum 22\n");
     843:	59                   	pop    %ecx
     844:	5b                   	pop    %ebx
     845:	68 60 1a 00 00       	push   $0x1a60
     84a:	6a 00                	push   $0x0
     84c:	e8 af 0a 00 00       	call   1300 <printf>
            printf(0,"Starting Loop\n");
     851:	58                   	pop    %eax
     852:	5a                   	pop    %edx
     853:	68 5a 1d 00 00       	push   $0x1d5a
     858:	6a 00                	push   $0x0
     85a:	e8 a1 0a 00 00       	call   1300 <printf>
     85f:	83 c4 10             	add    $0x10,%esp
     862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                printf(0,"pid - %d child two\n",getpid());
     868:	e8 b5 09 00 00       	call   1222 <getpid>
     86d:	83 ec 04             	sub    $0x4,%esp
     870:	50                   	push   %eax
     871:	68 69 1d 00 00       	push   $0x1d69
     876:	6a 00                	push   $0x0
     878:	e8 83 0a 00 00       	call   1300 <printf>
                sleep(50);
     87d:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     884:	e8 a9 09 00 00       	call   1232 <sleep>
     889:	83 c4 10             	add    $0x10,%esp
     88c:	eb da                	jmp    868 <SignalTests1+0x78>
            if((child_pid[2]=fork()) == 0)
     88e:	e8 07 09 00 00       	call   119a <fork>
     893:	85 c0                	test   %eax,%eax
     895:	0f 84 a6 00 00 00    	je     941 <SignalTests1+0x151>
                if((child_pid[3]=fork()) == 0)
     89b:	e8 fa 08 00 00       	call   119a <fork>
     8a0:	85 c0                	test   %eax,%eax
     8a2:	74 67                	je     90b <SignalTests1+0x11b>
    wait();
     8a4:	e8 01 09 00 00       	call   11aa <wait>
    wait();
     8a9:	e8 fc 08 00 00       	call   11aa <wait>
    wait();
     8ae:	e8 f7 08 00 00       	call   11aa <wait>
    wait();
     8b3:	e8 f2 08 00 00       	call   11aa <wait>
    printf(0,"parent\n");
     8b8:	83 ec 08             	sub    $0x8,%esp
     8bb:	68 9a 1d 00 00       	push   $0x1d9a
     8c0:	6a 00                	push   $0x0
     8c2:	e8 39 0a 00 00       	call   1300 <printf>
    return;
     8c7:	83 c4 10             	add    $0x10,%esp
}
     8ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8cd:	c9                   	leave  
     8ce:	c3                   	ret    
        printf(0,"Trying to self kill the process\n");
     8cf:	51                   	push   %ecx
     8d0:	51                   	push   %ecx
     8d1:	68 dc 19 00 00       	push   $0x19dc
     8d6:	6a 00                	push   $0x0
     8d8:	e8 23 0a 00 00       	call   1300 <printf>
    kill(getpid(),SIGKILL);
     8dd:	e8 40 09 00 00       	call   1222 <getpid>
     8e2:	5b                   	pop    %ebx
     8e3:	5a                   	pop    %edx
     8e4:	6a 09                	push   $0x9
     8e6:	50                   	push   %eax
     8e7:	e8 e6 08 00 00       	call   11d2 <kill>
        sleep(50);
     8ec:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     8f3:	e8 3a 09 00 00       	call   1232 <sleep>
        printf(0,"Process 1 Should have benn Killed Already!\n");
     8f8:	59                   	pop    %ecx
     8f9:	5b                   	pop    %ebx
     8fa:	68 00 1a 00 00       	push   $0x1a00
     8ff:	6a 00                	push   $0x0
     901:	e8 fa 09 00 00       	call   1300 <printf>
        exit();
     906:	e8 97 08 00 00       	call   11a2 <exit>
                    sleep(250);
     90b:	83 ec 0c             	sub    $0xc,%esp
     90e:	68 fa 00 00 00       	push   $0xfa
     913:	e8 1a 09 00 00       	call   1232 <sleep>
                    printf(0,"signal kill to second child\n");
     918:	58                   	pop    %eax
     919:	5a                   	pop    %edx
     91a:	68 7d 1d 00 00       	push   $0x1d7d
     91f:	6a 00                	push   $0x0
     921:	e8 da 09 00 00       	call   1300 <printf>
                    kill(child_pid[1],SIGKILL);
     926:	59                   	pop    %ecx
     927:	58                   	pop    %eax
     928:	6a 09                	push   $0x9
     92a:	53                   	push   %ebx
     92b:	e8 a2 08 00 00       	call   11d2 <kill>
                    sleep(100);
     930:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     937:	e8 f6 08 00 00       	call   1232 <sleep>
                    exit();
     93c:	e8 61 08 00 00       	call   11a2 <exit>
                sleep(150);
     941:	83 ec 0c             	sub    $0xc,%esp
     944:	68 96 00 00 00       	push   $0x96
     949:	e8 e4 08 00 00       	call   1232 <sleep>
                printf(0,"Run User Handler Signal Second Child\n");
     94e:	58                   	pop    %eax
     94f:	5a                   	pop    %edx
     950:	68 8c 1a 00 00       	push   $0x1a8c
     955:	6a 00                	push   $0x0
     957:	e8 a4 09 00 00       	call   1300 <printf>
    kill(child_kill,signum);
     95c:	59                   	pop    %ecx
     95d:	58                   	pop    %eax
     95e:	6a 16                	push   $0x16
     960:	53                   	push   %ebx
     961:	e8 6c 08 00 00       	call   11d2 <kill>
                sleep(450);
     966:	c7 04 24 c2 01 00 00 	movl   $0x1c2,(%esp)
     96d:	e8 c0 08 00 00       	call   1232 <sleep>
                exit();
     972:	e8 2b 08 00 00       	call   11a2 <exit>
     977:	89 f6                	mov    %esi,%esi
     979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000980 <SignalTests2>:
{
     980:	55                   	push   %ebp
     981:	89 e5                	mov    %esp,%ebp
     983:	53                   	push   %ebx
     984:	83 ec 04             	sub    $0x4,%esp
    if((child_pid[0]=fork()) == 0)
     987:	e8 0e 08 00 00       	call   119a <fork>
     98c:	85 c0                	test   %eax,%eax
     98e:	75 54                	jne    9e4 <SignalTests2+0x64>
        printf(0,"Trying to self kill the process even while Mask is Blocking\n");
     990:	83 ec 08             	sub    $0x8,%esp
     993:	68 b4 1a 00 00       	push   $0x1ab4
     998:	6a 00                	push   $0x0
     99a:	e8 61 09 00 00       	call   1300 <printf>
        sigprocmask(896);
     99f:	c7 04 24 80 03 00 00 	movl   $0x380,(%esp)
     9a6:	e8 97 08 00 00       	call   1242 <sigprocmask>
    kill(getpid(),SIGKILL);
     9ab:	e8 72 08 00 00       	call   1222 <getpid>
     9b0:	59                   	pop    %ecx
     9b1:	5b                   	pop    %ebx
     9b2:	6a 09                	push   $0x9
     9b4:	50                   	push   %eax
     9b5:	e8 18 08 00 00       	call   11d2 <kill>
        sleep(250);
     9ba:	c7 04 24 fa 00 00 00 	movl   $0xfa,(%esp)
     9c1:	e8 6c 08 00 00       	call   1232 <sleep>
     9c6:	83 c4 10             	add    $0x10,%esp
     9c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(0,"Process 1 Should have benn Killed Alreadyyyyy!\n");
     9d0:	83 ec 08             	sub    $0x8,%esp
     9d3:	68 f4 1a 00 00       	push   $0x1af4
     9d8:	6a 00                	push   $0x0
     9da:	e8 21 09 00 00       	call   1300 <printf>
     9df:	83 c4 10             	add    $0x10,%esp
     9e2:	eb ec                	jmp    9d0 <SignalTests2+0x50>
        if((child_pid[1]=fork()) == 0)
     9e4:	e8 b1 07 00 00       	call   119a <fork>
     9e9:	85 c0                	test   %eax,%eax
     9eb:	89 c3                	mov    %eax,%ebx
     9ed:	75 7f                	jne    a6e <SignalTests2+0xee>
            printf(0,"Trying to Ignore All\n");
     9ef:	51                   	push   %ecx
     9f0:	51                   	push   %ecx
     9f1:	68 a2 1d 00 00       	push   $0x1da2
     9f6:	6a 00                	push   $0x0
     9f8:	e8 03 09 00 00       	call   1300 <printf>
            sigprocmask(4294967295);
     9fd:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
     a04:	e8 39 08 00 00       	call   1242 <sigprocmask>
            struct sigaction *SigAction1 = malloc(sizeof(struct sigaction));
     a09:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     a10:	e8 4b 0b 00 00       	call   1560 <malloc>
            SigAction1->sa_handler = (void (*)())SIGKILL;
     a15:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
            SigAction1->sigmask=4294967295;
     a1b:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
            struct sigaction *SigAction1 = malloc(sizeof(struct sigaction));
     a22:	89 c3                	mov    %eax,%ebx
            printf(0,"Creating sinum 4 handler is SIGKILL and mask is Ignore ALl\n");
     a24:	58                   	pop    %eax
     a25:	5a                   	pop    %edx
     a26:	68 24 1b 00 00       	push   $0x1b24
     a2b:	6a 00                	push   $0x0
     a2d:	e8 ce 08 00 00       	call   1300 <printf>
            sigaction(4,SigAction1,null);
     a32:	83 c4 0c             	add    $0xc,%esp
     a35:	6a 00                	push   $0x0
     a37:	53                   	push   %ebx
     a38:	6a 04                	push   $0x4
     a3a:	e8 0b 08 00 00       	call   124a <sigaction>
     a3f:	83 c4 10             	add    $0x10,%esp
     a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                printf(0,"pid - %d child two\n",getpid());
     a48:	e8 d5 07 00 00       	call   1222 <getpid>
     a4d:	83 ec 04             	sub    $0x4,%esp
     a50:	50                   	push   %eax
     a51:	68 69 1d 00 00       	push   $0x1d69
     a56:	6a 00                	push   $0x0
     a58:	e8 a3 08 00 00       	call   1300 <printf>
                sleep(50);
     a5d:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     a64:	e8 c9 07 00 00       	call   1232 <sleep>
     a69:	83 c4 10             	add    $0x10,%esp
     a6c:	eb da                	jmp    a48 <SignalTests2+0xc8>
            if((child_pid[2]=fork()) == 0)
     a6e:	e8 27 07 00 00       	call   119a <fork>
     a73:	85 c0                	test   %eax,%eax
     a75:	74 33                	je     aaa <SignalTests2+0x12a>
                if((child_pid[3]=fork()) == 0)
     a77:	e8 1e 07 00 00       	call   119a <fork>
     a7c:	85 c0                	test   %eax,%eax
     a7e:	74 60                	je     ae0 <SignalTests2+0x160>
    wait();
     a80:	e8 25 07 00 00       	call   11aa <wait>
    wait();
     a85:	e8 20 07 00 00       	call   11aa <wait>
    wait();
     a8a:	e8 1b 07 00 00       	call   11aa <wait>
    wait();
     a8f:	e8 16 07 00 00       	call   11aa <wait>
    printf(0,"parent\n");
     a94:	50                   	push   %eax
     a95:	50                   	push   %eax
     a96:	68 9a 1d 00 00       	push   $0x1d9a
     a9b:	6a 00                	push   $0x0
     a9d:	e8 5e 08 00 00       	call   1300 <printf>
    return;
     aa2:	83 c4 10             	add    $0x10,%esp
}
     aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     aa8:	c9                   	leave  
     aa9:	c3                   	ret    
                sleep(250);
     aaa:	83 ec 0c             	sub    $0xc,%esp
     aad:	68 fa 00 00 00       	push   $0xfa
     ab2:	e8 7b 07 00 00       	call   1232 <sleep>
    kill(child_kill,signum);
     ab7:	59                   	pop    %ecx
     ab8:	58                   	pop    %eax
     ab9:	6a 04                	push   $0x4
     abb:	53                   	push   %ebx
     abc:	e8 11 07 00 00       	call   11d2 <kill>
                printf(0,"Should Ignore Signla 4\n");
     ac1:	58                   	pop    %eax
     ac2:	5a                   	pop    %edx
     ac3:	68 b8 1d 00 00       	push   $0x1db8
     ac8:	6a 00                	push   $0x0
     aca:	e8 31 08 00 00       	call   1300 <printf>
                sleep(550);
     acf:	c7 04 24 26 02 00 00 	movl   $0x226,(%esp)
     ad6:	e8 57 07 00 00       	call   1232 <sleep>
                exit();
     adb:	e8 c2 06 00 00       	call   11a2 <exit>
                    sleep(480);
     ae0:	83 ec 0c             	sub    $0xc,%esp
     ae3:	68 e0 01 00 00       	push   $0x1e0
     ae8:	e8 45 07 00 00       	call   1232 <sleep>
                    printf(0,"signal kill\n");
     aed:	5a                   	pop    %edx
     aee:	59                   	pop    %ecx
     aef:	68 d0 1d 00 00       	push   $0x1dd0
     af4:	6a 00                	push   $0x0
     af6:	e8 05 08 00 00       	call   1300 <printf>
                    kill(child_pid[1],SIGKILL);
     afb:	58                   	pop    %eax
     afc:	5a                   	pop    %edx
     afd:	6a 09                	push   $0x9
     aff:	53                   	push   %ebx
     b00:	e8 cd 06 00 00       	call   11d2 <kill>
                    sleep(100);
     b05:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     b0c:	e8 21 07 00 00       	call   1232 <sleep>
                    exit();
     b11:	e8 8c 06 00 00       	call   11a2 <exit>
     b16:	8d 76 00             	lea    0x0(%esi),%esi
     b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b20 <SignalTests3>:
{
     b20:	55                   	push   %ebp
     b21:	89 e5                	mov    %esp,%ebp
     b23:	53                   	push   %ebx
     b24:	83 ec 04             	sub    $0x4,%esp
    if((child_pid[0]=fork()) == 0)
     b27:	e8 6e 06 00 00       	call   119a <fork>
     b2c:	85 c0                	test   %eax,%eax
     b2e:	0f 85 84 00 00 00    	jne    bb8 <SignalTests3+0x98>
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
     b34:	83 ec 0c             	sub    $0xc,%esp
     b37:	6a 08                	push   $0x8
     b39:	e8 22 0a 00 00       	call   1560 <malloc>
        KillHAndlerSignal->sa_handler = (void (*)())SIGKILL;
     b3e:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
        KillHAndlerSignal->sigmask = 0;
     b44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
     b4b:	89 c3                	mov    %eax,%ebx
        printf(0,"Created KillHAndlerSignal (KILL) with mask that is 0\n");
     b4d:	58                   	pop    %eax
     b4e:	5a                   	pop    %edx
     b4f:	68 60 1b 00 00       	push   $0x1b60
     b54:	6a 00                	push   $0x0
     b56:	e8 a5 07 00 00       	call   1300 <printf>
        sigaction(4,KillHAndlerSignal,null);
     b5b:	83 c4 0c             	add    $0xc,%esp
     b5e:	6a 00                	push   $0x0
     b60:	53                   	push   %ebx
     b61:	6a 04                	push   $0x4
     b63:	e8 e2 06 00 00       	call   124a <sigaction>
        printf(0,"Sending KillHAndlerSignal (22)to process\n");
     b68:	59                   	pop    %ecx
     b69:	5b                   	pop    %ebx
     b6a:	68 98 1b 00 00       	push   $0x1b98
     b6f:	6a 00                	push   $0x0
     b71:	e8 8a 07 00 00       	call   1300 <printf>
        kill_self_test(4);
     b76:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     b7d:	e8 2e fc ff ff       	call   7b0 <kill_self_test>
        sleep(1250);
     b82:	c7 04 24 e2 04 00 00 	movl   $0x4e2,(%esp)
     b89:	e8 a4 06 00 00       	call   1232 <sleep>
     b8e:	83 c4 10             	add    $0x10,%esp
     b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(0,"Process 1 should have been killed already!\n");
     b98:	83 ec 08             	sub    $0x8,%esp
     b9b:	68 c4 1b 00 00       	push   $0x1bc4
     ba0:	6a 00                	push   $0x0
     ba2:	e8 59 07 00 00       	call   1300 <printf>
            sleep(100);
     ba7:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     bae:	e8 7f 06 00 00       	call   1232 <sleep>
     bb3:	83 c4 10             	add    $0x10,%esp
     bb6:	eb e0                	jmp    b98 <SignalTests3+0x78>
        if((child_pid[1]=fork()) == 0)
     bb8:	e8 dd 05 00 00       	call   119a <fork>
     bbd:	85 c0                	test   %eax,%eax
     bbf:	89 c3                	mov    %eax,%ebx
     bc1:	75 3b                	jne    bfe <SignalTests3+0xde>
            printf(0,"Starting Loop\n");
     bc3:	51                   	push   %ecx
     bc4:	51                   	push   %ecx
     bc5:	68 5a 1d 00 00       	push   $0x1d5a
     bca:	6a 00                	push   $0x0
     bcc:	e8 2f 07 00 00       	call   1300 <printf>
     bd1:	83 c4 10             	add    $0x10,%esp
     bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                printf(0,"pid - %d child two\n",getpid());
     bd8:	e8 45 06 00 00       	call   1222 <getpid>
     bdd:	83 ec 04             	sub    $0x4,%esp
     be0:	50                   	push   %eax
     be1:	68 69 1d 00 00       	push   $0x1d69
     be6:	6a 00                	push   $0x0
     be8:	e8 13 07 00 00       	call   1300 <printf>
                sleep(50);
     bed:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     bf4:	e8 39 06 00 00       	call   1232 <sleep>
     bf9:	83 c4 10             	add    $0x10,%esp
     bfc:	eb da                	jmp    bd8 <SignalTests3+0xb8>
            if((child_pid[2]=fork()) == 0)
     bfe:	e8 97 05 00 00       	call   119a <fork>
     c03:	85 c0                	test   %eax,%eax
     c05:	74 37                	je     c3e <SignalTests3+0x11e>
                if((child_pid[3]=fork()) == 0)
     c07:	e8 8e 05 00 00       	call   119a <fork>
     c0c:	85 c0                	test   %eax,%eax
     c0e:	0f 84 3a 01 00 00    	je     d4e <SignalTests3+0x22e>
    wait();
     c14:	e8 91 05 00 00       	call   11aa <wait>
    wait();
     c19:	e8 8c 05 00 00       	call   11aa <wait>
    wait();
     c1e:	e8 87 05 00 00       	call   11aa <wait>
    wait();
     c23:	e8 82 05 00 00       	call   11aa <wait>
    printf(0,"parent\n");
     c28:	50                   	push   %eax
     c29:	50                   	push   %eax
     c2a:	68 9a 1d 00 00       	push   $0x1d9a
     c2f:	6a 00                	push   $0x0
     c31:	e8 ca 06 00 00       	call   1300 <printf>
    return;
     c36:	83 c4 10             	add    $0x10,%esp
}
     c39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     c3c:	c9                   	leave  
     c3d:	c3                   	ret    
                printf(0, "child 3 pid: %d\n", getpid());
     c3e:	e8 df 05 00 00       	call   1222 <getpid>
     c43:	52                   	push   %edx
     c44:	50                   	push   %eax
     c45:	68 dd 1d 00 00       	push   $0x1ddd
     c4a:	6a 00                	push   $0x0
     c4c:	e8 af 06 00 00       	call   1300 <printf>
                sleep(30);
     c51:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
     c58:	e8 d5 05 00 00       	call   1232 <sleep>
                printf(0,"Run SigSTOP Second Child\n");
     c5d:	59                   	pop    %ecx
     c5e:	58                   	pop    %eax
     c5f:	68 ee 1d 00 00       	push   $0x1dee
     c64:	6a 00                	push   $0x0
     c66:	e8 95 06 00 00       	call   1300 <printf>
    kill(child_kill,signum);
     c6b:	58                   	pop    %eax
     c6c:	5a                   	pop    %edx
     c6d:	6a 11                	push   $0x11
     c6f:	53                   	push   %ebx
     c70:	e8 5d 05 00 00       	call   11d2 <kill>
                printf(0, "@@@@@1\n");
     c75:	59                   	pop    %ecx
     c76:	58                   	pop    %eax
     c77:	68 08 1e 00 00       	push   $0x1e08
     c7c:	6a 00                	push   $0x0
     c7e:	e8 7d 06 00 00       	call   1300 <printf>
                sleep(20);
     c83:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     c8a:	e8 a3 05 00 00       	call   1232 <sleep>
                printf(0, "@@@@@2\n");
     c8f:	58                   	pop    %eax
     c90:	5a                   	pop    %edx
     c91:	68 10 1e 00 00       	push   $0x1e10
     c96:	6a 00                	push   $0x0
     c98:	e8 63 06 00 00       	call   1300 <printf>
                printf(0,"Send SIGCONT child two\n");
     c9d:	59                   	pop    %ecx
     c9e:	58                   	pop    %eax
     c9f:	68 18 1e 00 00       	push   $0x1e18
     ca4:	6a 00                	push   $0x0
     ca6:	e8 55 06 00 00       	call   1300 <printf>
    kill(child_kill,signum);
     cab:	58                   	pop    %eax
     cac:	5a                   	pop    %edx
     cad:	6a 13                	push   $0x13
     caf:	53                   	push   %ebx
     cb0:	e8 1d 05 00 00       	call   11d2 <kill>
                sleep(20);
     cb5:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     cbc:	e8 71 05 00 00       	call   1232 <sleep>
                printf(0,"Send SIGSTOP child2 AGAIN\n");
     cc1:	59                   	pop    %ecx
     cc2:	58                   	pop    %eax
     cc3:	68 30 1e 00 00       	push   $0x1e30
     cc8:	6a 00                	push   $0x0
     cca:	e8 31 06 00 00       	call   1300 <printf>
    kill(child_kill,signum);
     ccf:	58                   	pop    %eax
     cd0:	5a                   	pop    %edx
     cd1:	6a 11                	push   $0x11
     cd3:	53                   	push   %ebx
     cd4:	e8 f9 04 00 00       	call   11d2 <kill>
                printf(0, "@@@@@1\n");
     cd9:	59                   	pop    %ecx
     cda:	58                   	pop    %eax
     cdb:	68 08 1e 00 00       	push   $0x1e08
     ce0:	6a 00                	push   $0x0
     ce2:	e8 19 06 00 00       	call   1300 <printf>
                sleep(20);
     ce7:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     cee:	e8 3f 05 00 00       	call   1232 <sleep>
                printf(0, "@@@@@2\n");
     cf3:	58                   	pop    %eax
     cf4:	5a                   	pop    %edx
     cf5:	68 10 1e 00 00       	push   $0x1e10
     cfa:	6a 00                	push   $0x0
     cfc:	e8 ff 05 00 00       	call   1300 <printf>
                printf(0,"Send SIGKILL to child2\n");
     d01:	59                   	pop    %ecx
     d02:	58                   	pop    %eax
     d03:	68 4b 1e 00 00       	push   $0x1e4b
     d08:	6a 00                	push   $0x0
     d0a:	e8 f1 05 00 00       	call   1300 <printf>
    kill(child_kill,signum);
     d0f:	58                   	pop    %eax
     d10:	5a                   	pop    %edx
     d11:	6a 09                	push   $0x9
     d13:	53                   	push   %ebx
     d14:	e8 b9 04 00 00       	call   11d2 <kill>
                sleep(30);
     d19:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
     d20:	e8 0d 05 00 00       	call   1232 <sleep>
                printf(0,"Send SIGCONT to child2\n");
     d25:	59                   	pop    %ecx
     d26:	58                   	pop    %eax
     d27:	68 63 1e 00 00       	push   $0x1e63
     d2c:	6a 00                	push   $0x0
     d2e:	e8 cd 05 00 00       	call   1300 <printf>
    kill(child_kill,signum);
     d33:	58                   	pop    %eax
     d34:	5a                   	pop    %edx
     d35:	6a 13                	push   $0x13
     d37:	53                   	push   %ebx
     d38:	e8 95 04 00 00       	call   11d2 <kill>
                sleep(30);
     d3d:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
     d44:	e8 e9 04 00 00       	call   1232 <sleep>
                exit();
     d49:	e8 54 04 00 00       	call   11a2 <exit>
                    exit();
     d4e:	e8 4f 04 00 00       	call   11a2 <exit>
     d53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d60 <sleepTest>:
void sleepTest() {
     d60:	55                   	push   %ebp
     d61:	89 e5                	mov    %esp,%ebp
     d63:	53                   	push   %ebx
     d64:	83 ec 04             	sub    $0x4,%esp
    if((child_pid[0]=fork()) == 0)
     d67:	e8 2e 04 00 00       	call   119a <fork>
     d6c:	85 c0                	test   %eax,%eax
     d6e:	0f 85 84 00 00 00    	jne    df8 <sleepTest+0x98>
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
     d74:	83 ec 0c             	sub    $0xc,%esp
     d77:	6a 08                	push   $0x8
     d79:	e8 e2 07 00 00       	call   1560 <malloc>
        KillHAndlerSignal->sa_handler = (void (*)())SIGKILL;
     d7e:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
        KillHAndlerSignal->sigmask = 0;
     d84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
     d8b:	89 c3                	mov    %eax,%ebx
        printf(0,"Created KillHAndlerSignal (KILL) with mask that is 0\n");
     d8d:	58                   	pop    %eax
     d8e:	5a                   	pop    %edx
     d8f:	68 60 1b 00 00       	push   $0x1b60
     d94:	6a 00                	push   $0x0
     d96:	e8 65 05 00 00       	call   1300 <printf>
        sigaction(4,KillHAndlerSignal,null);
     d9b:	83 c4 0c             	add    $0xc,%esp
     d9e:	6a 00                	push   $0x0
     da0:	53                   	push   %ebx
     da1:	6a 04                	push   $0x4
     da3:	e8 a2 04 00 00       	call   124a <sigaction>
        printf(0,"Sending KillHAndlerSignal (22)to process\n");
     da8:	59                   	pop    %ecx
     da9:	5b                   	pop    %ebx
     daa:	68 98 1b 00 00       	push   $0x1b98
     daf:	6a 00                	push   $0x0
     db1:	e8 4a 05 00 00       	call   1300 <printf>
        kill_self_test(4);
     db6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     dbd:	e8 ee f9 ff ff       	call   7b0 <kill_self_test>
        sleep(1250);
     dc2:	c7 04 24 e2 04 00 00 	movl   $0x4e2,(%esp)
     dc9:	e8 64 04 00 00       	call   1232 <sleep>
     dce:	83 c4 10             	add    $0x10,%esp
     dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(0,"Process 1 should have been killed already!\n");
     dd8:	83 ec 08             	sub    $0x8,%esp
     ddb:	68 c4 1b 00 00       	push   $0x1bc4
     de0:	6a 00                	push   $0x0
     de2:	e8 19 05 00 00       	call   1300 <printf>
            sleep(100);
     de7:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     dee:	e8 3f 04 00 00       	call   1232 <sleep>
     df3:	83 c4 10             	add    $0x10,%esp
     df6:	eb e0                	jmp    dd8 <sleepTest+0x78>
        if((child_pid[1]=fork()) == 0)
     df8:	e8 9d 03 00 00       	call   119a <fork>
     dfd:	85 c0                	test   %eax,%eax
     dff:	75 3d                	jne    e3e <sleepTest+0xde>
            printf(0,"Starting Loop\n");
     e01:	51                   	push   %ecx
     e02:	51                   	push   %ecx
     e03:	68 5a 1d 00 00       	push   $0x1d5a
     e08:	6a 00                	push   $0x0
     e0a:	e8 f1 04 00 00       	call   1300 <printf>
     e0f:	83 c4 10             	add    $0x10,%esp
     e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                printf(0,"pid - %d child two\n",getpid());
     e18:	e8 05 04 00 00       	call   1222 <getpid>
     e1d:	83 ec 04             	sub    $0x4,%esp
     e20:	50                   	push   %eax
     e21:	68 69 1d 00 00       	push   $0x1d69
     e26:	6a 00                	push   $0x0
     e28:	e8 d3 04 00 00       	call   1300 <printf>
                sleep(50);
     e2d:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     e34:	e8 f9 03 00 00       	call   1232 <sleep>
     e39:	83 c4 10             	add    $0x10,%esp
     e3c:	eb da                	jmp    e18 <sleepTest+0xb8>
            if((child_pid[2]=fork()) == 0)
     e3e:	e8 57 03 00 00       	call   119a <fork>
     e43:	85 c0                	test   %eax,%eax
     e45:	74 37                	je     e7e <sleepTest+0x11e>
                if((child_pid[3]=fork()) == 0)
     e47:	e8 4e 03 00 00       	call   119a <fork>
     e4c:	85 c0                	test   %eax,%eax
     e4e:	0f 84 f3 00 00 00    	je     f47 <sleepTest+0x1e7>
    wait();
     e54:	e8 51 03 00 00       	call   11aa <wait>
    wait();
     e59:	e8 4c 03 00 00       	call   11aa <wait>
    wait();
     e5e:	e8 47 03 00 00       	call   11aa <wait>
    wait();
     e63:	e8 42 03 00 00       	call   11aa <wait>
    printf(0,"parent\n");
     e68:	50                   	push   %eax
     e69:	50                   	push   %eax
     e6a:	68 9a 1d 00 00       	push   $0x1d9a
     e6f:	6a 00                	push   $0x0
     e71:	e8 8a 04 00 00       	call   1300 <printf>
    return;
     e76:	83 c4 10             	add    $0x10,%esp
}
     e79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e7c:	c9                   	leave  
     e7d:	c3                   	ret    
                sleep(25);
     e7e:	83 ec 0c             	sub    $0xc,%esp
     e81:	6a 19                	push   $0x19
     e83:	e8 aa 03 00 00       	call   1232 <sleep>
                printf(0,"Run SigSTOP Second Child\n");
     e88:	5a                   	pop    %edx
     e89:	59                   	pop    %ecx
     e8a:	68 ee 1d 00 00       	push   $0x1dee
     e8f:	6a 00                	push   $0x0
     e91:	e8 6a 04 00 00       	call   1300 <printf>
                printf(0, "@@@@@1\n");
     e96:	5b                   	pop    %ebx
     e97:	58                   	pop    %eax
     e98:	68 08 1e 00 00       	push   $0x1e08
     e9d:	6a 00                	push   $0x0
     e9f:	e8 5c 04 00 00       	call   1300 <printf>
                sleep(20);
     ea4:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     eab:	e8 82 03 00 00       	call   1232 <sleep>
                printf(0, "@@@@@2\n");
     eb0:	58                   	pop    %eax
     eb1:	5a                   	pop    %edx
     eb2:	68 10 1e 00 00       	push   $0x1e10
     eb7:	6a 00                	push   $0x0
     eb9:	e8 42 04 00 00       	call   1300 <printf>
                printf(0,"Send SIGCONT child two\n");
     ebe:	59                   	pop    %ecx
     ebf:	5b                   	pop    %ebx
     ec0:	68 18 1e 00 00       	push   $0x1e18
     ec5:	6a 00                	push   $0x0
     ec7:	e8 34 04 00 00       	call   1300 <printf>
                sleep(20);
     ecc:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     ed3:	e8 5a 03 00 00       	call   1232 <sleep>
                printf(0,"Send SIGSTOP child2 AGAIN\n");
     ed8:	58                   	pop    %eax
     ed9:	5a                   	pop    %edx
     eda:	68 30 1e 00 00       	push   $0x1e30
     edf:	6a 00                	push   $0x0
     ee1:	e8 1a 04 00 00       	call   1300 <printf>
                printf(0, "@@@@@1\n");
     ee6:	59                   	pop    %ecx
     ee7:	5b                   	pop    %ebx
     ee8:	68 08 1e 00 00       	push   $0x1e08
     eed:	6a 00                	push   $0x0
     eef:	e8 0c 04 00 00       	call   1300 <printf>
                sleep(20);
     ef4:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     efb:	e8 32 03 00 00       	call   1232 <sleep>
                printf(0, "@@@@@2\n");
     f00:	58                   	pop    %eax
     f01:	5a                   	pop    %edx
     f02:	68 10 1e 00 00       	push   $0x1e10
     f07:	6a 00                	push   $0x0
     f09:	e8 f2 03 00 00       	call   1300 <printf>
                printf(0,"Send SIGKILL to child2\n");
     f0e:	59                   	pop    %ecx
     f0f:	5b                   	pop    %ebx
     f10:	68 4b 1e 00 00       	push   $0x1e4b
     f15:	6a 00                	push   $0x0
     f17:	e8 e4 03 00 00       	call   1300 <printf>
                sleep(40);
     f1c:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
     f23:	e8 0a 03 00 00       	call   1232 <sleep>
                printf(0,"Send SIGCONT to child2\n");
     f28:	58                   	pop    %eax
     f29:	5a                   	pop    %edx
     f2a:	68 63 1e 00 00       	push   $0x1e63
     f2f:	6a 00                	push   $0x0
     f31:	e8 ca 03 00 00       	call   1300 <printf>
                sleep(45);
     f36:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
     f3d:	e8 f0 02 00 00       	call   1232 <sleep>
                exit();
     f42:	e8 5b 02 00 00       	call   11a2 <exit>
                    exit();
     f47:	e8 56 02 00 00       	call   11a2 <exit>
     f4c:	66 90                	xchg   %ax,%ax
     f4e:	66 90                	xchg   %ax,%ax

00000f50 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     f50:	55                   	push   %ebp
     f51:	89 e5                	mov    %esp,%ebp
     f53:	53                   	push   %ebx
     f54:	8b 45 08             	mov    0x8(%ebp),%eax
     f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     f5a:	89 c2                	mov    %eax,%edx
     f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f60:	83 c1 01             	add    $0x1,%ecx
     f63:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     f67:	83 c2 01             	add    $0x1,%edx
     f6a:	84 db                	test   %bl,%bl
     f6c:	88 5a ff             	mov    %bl,-0x1(%edx)
     f6f:	75 ef                	jne    f60 <strcpy+0x10>
    ;
  return os;
}
     f71:	5b                   	pop    %ebx
     f72:	5d                   	pop    %ebp
     f73:	c3                   	ret    
     f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000f80 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     f80:	55                   	push   %ebp
     f81:	89 e5                	mov    %esp,%ebp
     f83:	53                   	push   %ebx
     f84:	8b 55 08             	mov    0x8(%ebp),%edx
     f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     f8a:	0f b6 02             	movzbl (%edx),%eax
     f8d:	0f b6 19             	movzbl (%ecx),%ebx
     f90:	84 c0                	test   %al,%al
     f92:	75 1c                	jne    fb0 <strcmp+0x30>
     f94:	eb 2a                	jmp    fc0 <strcmp+0x40>
     f96:	8d 76 00             	lea    0x0(%esi),%esi
     f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
     fa0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     fa3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
     fa6:	83 c1 01             	add    $0x1,%ecx
     fa9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
     fac:	84 c0                	test   %al,%al
     fae:	74 10                	je     fc0 <strcmp+0x40>
     fb0:	38 d8                	cmp    %bl,%al
     fb2:	74 ec                	je     fa0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     fb4:	29 d8                	sub    %ebx,%eax
}
     fb6:	5b                   	pop    %ebx
     fb7:	5d                   	pop    %ebp
     fb8:	c3                   	ret    
     fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     fc0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     fc2:	29 d8                	sub    %ebx,%eax
}
     fc4:	5b                   	pop    %ebx
     fc5:	5d                   	pop    %ebp
     fc6:	c3                   	ret    
     fc7:	89 f6                	mov    %esi,%esi
     fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000fd0 <strlen>:

uint
strlen(const char *s)
{
     fd0:	55                   	push   %ebp
     fd1:	89 e5                	mov    %esp,%ebp
     fd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     fd6:	80 39 00             	cmpb   $0x0,(%ecx)
     fd9:	74 15                	je     ff0 <strlen+0x20>
     fdb:	31 d2                	xor    %edx,%edx
     fdd:	8d 76 00             	lea    0x0(%esi),%esi
     fe0:	83 c2 01             	add    $0x1,%edx
     fe3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     fe7:	89 d0                	mov    %edx,%eax
     fe9:	75 f5                	jne    fe0 <strlen+0x10>
    ;
  return n;
}
     feb:	5d                   	pop    %ebp
     fec:	c3                   	ret    
     fed:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
     ff0:	31 c0                	xor    %eax,%eax
}
     ff2:	5d                   	pop    %ebp
     ff3:	c3                   	ret    
     ff4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     ffa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001000 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
    1004:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1007:	8b 4d 10             	mov    0x10(%ebp),%ecx
    100a:	8b 45 0c             	mov    0xc(%ebp),%eax
    100d:	89 d7                	mov    %edx,%edi
    100f:	fc                   	cld    
    1010:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1012:	89 d0                	mov    %edx,%eax
    1014:	5f                   	pop    %edi
    1015:	5d                   	pop    %ebp
    1016:	c3                   	ret    
    1017:	89 f6                	mov    %esi,%esi
    1019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001020 <strchr>:

char*
strchr(const char *s, char c)
{
    1020:	55                   	push   %ebp
    1021:	89 e5                	mov    %esp,%ebp
    1023:	53                   	push   %ebx
    1024:	8b 45 08             	mov    0x8(%ebp),%eax
    1027:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    102a:	0f b6 10             	movzbl (%eax),%edx
    102d:	84 d2                	test   %dl,%dl
    102f:	74 1d                	je     104e <strchr+0x2e>
    if(*s == c)
    1031:	38 d3                	cmp    %dl,%bl
    1033:	89 d9                	mov    %ebx,%ecx
    1035:	75 0d                	jne    1044 <strchr+0x24>
    1037:	eb 17                	jmp    1050 <strchr+0x30>
    1039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1040:	38 ca                	cmp    %cl,%dl
    1042:	74 0c                	je     1050 <strchr+0x30>
  for(; *s; s++)
    1044:	83 c0 01             	add    $0x1,%eax
    1047:	0f b6 10             	movzbl (%eax),%edx
    104a:	84 d2                	test   %dl,%dl
    104c:	75 f2                	jne    1040 <strchr+0x20>
      return (char*)s;
  return 0;
    104e:	31 c0                	xor    %eax,%eax
}
    1050:	5b                   	pop    %ebx
    1051:	5d                   	pop    %ebp
    1052:	c3                   	ret    
    1053:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001060 <gets>:

char*
gets(char *buf, int max)
{
    1060:	55                   	push   %ebp
    1061:	89 e5                	mov    %esp,%ebp
    1063:	57                   	push   %edi
    1064:	56                   	push   %esi
    1065:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1066:	31 f6                	xor    %esi,%esi
    1068:	89 f3                	mov    %esi,%ebx
{
    106a:	83 ec 1c             	sub    $0x1c,%esp
    106d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1070:	eb 2f                	jmp    10a1 <gets+0x41>
    1072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1078:	8d 45 e7             	lea    -0x19(%ebp),%eax
    107b:	83 ec 04             	sub    $0x4,%esp
    107e:	6a 01                	push   $0x1
    1080:	50                   	push   %eax
    1081:	6a 00                	push   $0x0
    1083:	e8 32 01 00 00       	call   11ba <read>
    if(cc < 1)
    1088:	83 c4 10             	add    $0x10,%esp
    108b:	85 c0                	test   %eax,%eax
    108d:	7e 1c                	jle    10ab <gets+0x4b>
      break;
    buf[i++] = c;
    108f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1093:	83 c7 01             	add    $0x1,%edi
    1096:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    1099:	3c 0a                	cmp    $0xa,%al
    109b:	74 23                	je     10c0 <gets+0x60>
    109d:	3c 0d                	cmp    $0xd,%al
    109f:	74 1f                	je     10c0 <gets+0x60>
  for(i=0; i+1 < max; ){
    10a1:	83 c3 01             	add    $0x1,%ebx
    10a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    10a7:	89 fe                	mov    %edi,%esi
    10a9:	7c cd                	jl     1078 <gets+0x18>
    10ab:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    10ad:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    10b0:	c6 03 00             	movb   $0x0,(%ebx)
}
    10b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10b6:	5b                   	pop    %ebx
    10b7:	5e                   	pop    %esi
    10b8:	5f                   	pop    %edi
    10b9:	5d                   	pop    %ebp
    10ba:	c3                   	ret    
    10bb:	90                   	nop
    10bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10c0:	8b 75 08             	mov    0x8(%ebp),%esi
    10c3:	8b 45 08             	mov    0x8(%ebp),%eax
    10c6:	01 de                	add    %ebx,%esi
    10c8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    10ca:	c6 03 00             	movb   $0x0,(%ebx)
}
    10cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10d0:	5b                   	pop    %ebx
    10d1:	5e                   	pop    %esi
    10d2:	5f                   	pop    %edi
    10d3:	5d                   	pop    %ebp
    10d4:	c3                   	ret    
    10d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000010e0 <stat>:

int
stat(const char *n, struct stat *st)
{
    10e0:	55                   	push   %ebp
    10e1:	89 e5                	mov    %esp,%ebp
    10e3:	56                   	push   %esi
    10e4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    10e5:	83 ec 08             	sub    $0x8,%esp
    10e8:	6a 00                	push   $0x0
    10ea:	ff 75 08             	pushl  0x8(%ebp)
    10ed:	e8 f0 00 00 00       	call   11e2 <open>
  if(fd < 0)
    10f2:	83 c4 10             	add    $0x10,%esp
    10f5:	85 c0                	test   %eax,%eax
    10f7:	78 27                	js     1120 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    10f9:	83 ec 08             	sub    $0x8,%esp
    10fc:	ff 75 0c             	pushl  0xc(%ebp)
    10ff:	89 c3                	mov    %eax,%ebx
    1101:	50                   	push   %eax
    1102:	e8 f3 00 00 00       	call   11fa <fstat>
  close(fd);
    1107:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    110a:	89 c6                	mov    %eax,%esi
  close(fd);
    110c:	e8 b9 00 00 00       	call   11ca <close>
  return r;
    1111:	83 c4 10             	add    $0x10,%esp
}
    1114:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1117:	89 f0                	mov    %esi,%eax
    1119:	5b                   	pop    %ebx
    111a:	5e                   	pop    %esi
    111b:	5d                   	pop    %ebp
    111c:	c3                   	ret    
    111d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    1120:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1125:	eb ed                	jmp    1114 <stat+0x34>
    1127:	89 f6                	mov    %esi,%esi
    1129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001130 <atoi>:

int
atoi(const char *s)
{
    1130:	55                   	push   %ebp
    1131:	89 e5                	mov    %esp,%ebp
    1133:	53                   	push   %ebx
    1134:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1137:	0f be 11             	movsbl (%ecx),%edx
    113a:	8d 42 d0             	lea    -0x30(%edx),%eax
    113d:	3c 09                	cmp    $0x9,%al
  n = 0;
    113f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1144:	77 1f                	ja     1165 <atoi+0x35>
    1146:	8d 76 00             	lea    0x0(%esi),%esi
    1149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    1150:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1153:	83 c1 01             	add    $0x1,%ecx
    1156:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    115a:	0f be 11             	movsbl (%ecx),%edx
    115d:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1160:	80 fb 09             	cmp    $0x9,%bl
    1163:	76 eb                	jbe    1150 <atoi+0x20>
  return n;
}
    1165:	5b                   	pop    %ebx
    1166:	5d                   	pop    %ebp
    1167:	c3                   	ret    
    1168:	90                   	nop
    1169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001170 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1170:	55                   	push   %ebp
    1171:	89 e5                	mov    %esp,%ebp
    1173:	56                   	push   %esi
    1174:	53                   	push   %ebx
    1175:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1178:	8b 45 08             	mov    0x8(%ebp),%eax
    117b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    117e:	85 db                	test   %ebx,%ebx
    1180:	7e 14                	jle    1196 <memmove+0x26>
    1182:	31 d2                	xor    %edx,%edx
    1184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1188:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    118c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    118f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1192:	39 d3                	cmp    %edx,%ebx
    1194:	75 f2                	jne    1188 <memmove+0x18>
  return vdst;
}
    1196:	5b                   	pop    %ebx
    1197:	5e                   	pop    %esi
    1198:	5d                   	pop    %ebp
    1199:	c3                   	ret    

0000119a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    119a:	b8 01 00 00 00       	mov    $0x1,%eax
    119f:	cd 40                	int    $0x40
    11a1:	c3                   	ret    

000011a2 <exit>:
SYSCALL(exit)
    11a2:	b8 02 00 00 00       	mov    $0x2,%eax
    11a7:	cd 40                	int    $0x40
    11a9:	c3                   	ret    

000011aa <wait>:
SYSCALL(wait)
    11aa:	b8 03 00 00 00       	mov    $0x3,%eax
    11af:	cd 40                	int    $0x40
    11b1:	c3                   	ret    

000011b2 <pipe>:
SYSCALL(pipe)
    11b2:	b8 04 00 00 00       	mov    $0x4,%eax
    11b7:	cd 40                	int    $0x40
    11b9:	c3                   	ret    

000011ba <read>:
SYSCALL(read)
    11ba:	b8 05 00 00 00       	mov    $0x5,%eax
    11bf:	cd 40                	int    $0x40
    11c1:	c3                   	ret    

000011c2 <write>:
SYSCALL(write)
    11c2:	b8 10 00 00 00       	mov    $0x10,%eax
    11c7:	cd 40                	int    $0x40
    11c9:	c3                   	ret    

000011ca <close>:
SYSCALL(close)
    11ca:	b8 15 00 00 00       	mov    $0x15,%eax
    11cf:	cd 40                	int    $0x40
    11d1:	c3                   	ret    

000011d2 <kill>:
SYSCALL(kill)
    11d2:	b8 06 00 00 00       	mov    $0x6,%eax
    11d7:	cd 40                	int    $0x40
    11d9:	c3                   	ret    

000011da <exec>:
SYSCALL(exec)
    11da:	b8 07 00 00 00       	mov    $0x7,%eax
    11df:	cd 40                	int    $0x40
    11e1:	c3                   	ret    

000011e2 <open>:
SYSCALL(open)
    11e2:	b8 0f 00 00 00       	mov    $0xf,%eax
    11e7:	cd 40                	int    $0x40
    11e9:	c3                   	ret    

000011ea <mknod>:
SYSCALL(mknod)
    11ea:	b8 11 00 00 00       	mov    $0x11,%eax
    11ef:	cd 40                	int    $0x40
    11f1:	c3                   	ret    

000011f2 <unlink>:
SYSCALL(unlink)
    11f2:	b8 12 00 00 00       	mov    $0x12,%eax
    11f7:	cd 40                	int    $0x40
    11f9:	c3                   	ret    

000011fa <fstat>:
SYSCALL(fstat)
    11fa:	b8 08 00 00 00       	mov    $0x8,%eax
    11ff:	cd 40                	int    $0x40
    1201:	c3                   	ret    

00001202 <link>:
SYSCALL(link)
    1202:	b8 13 00 00 00       	mov    $0x13,%eax
    1207:	cd 40                	int    $0x40
    1209:	c3                   	ret    

0000120a <mkdir>:
SYSCALL(mkdir)
    120a:	b8 14 00 00 00       	mov    $0x14,%eax
    120f:	cd 40                	int    $0x40
    1211:	c3                   	ret    

00001212 <chdir>:
SYSCALL(chdir)
    1212:	b8 09 00 00 00       	mov    $0x9,%eax
    1217:	cd 40                	int    $0x40
    1219:	c3                   	ret    

0000121a <dup>:
SYSCALL(dup)
    121a:	b8 0a 00 00 00       	mov    $0xa,%eax
    121f:	cd 40                	int    $0x40
    1221:	c3                   	ret    

00001222 <getpid>:
SYSCALL(getpid)
    1222:	b8 0b 00 00 00       	mov    $0xb,%eax
    1227:	cd 40                	int    $0x40
    1229:	c3                   	ret    

0000122a <sbrk>:
SYSCALL(sbrk)
    122a:	b8 0c 00 00 00       	mov    $0xc,%eax
    122f:	cd 40                	int    $0x40
    1231:	c3                   	ret    

00001232 <sleep>:
SYSCALL(sleep)
    1232:	b8 0d 00 00 00       	mov    $0xd,%eax
    1237:	cd 40                	int    $0x40
    1239:	c3                   	ret    

0000123a <uptime>:
SYSCALL(uptime)
    123a:	b8 0e 00 00 00       	mov    $0xe,%eax
    123f:	cd 40                	int    $0x40
    1241:	c3                   	ret    

00001242 <sigprocmask>:
SYSCALL(sigprocmask)
    1242:	b8 16 00 00 00       	mov    $0x16,%eax
    1247:	cd 40                	int    $0x40
    1249:	c3                   	ret    

0000124a <sigaction>:
SYSCALL(sigaction)
    124a:	b8 17 00 00 00       	mov    $0x17,%eax
    124f:	cd 40                	int    $0x40
    1251:	c3                   	ret    

00001252 <sigret>:
SYSCALL(sigret)
    1252:	b8 18 00 00 00       	mov    $0x18,%eax
    1257:	cd 40                	int    $0x40
    1259:	c3                   	ret    
    125a:	66 90                	xchg   %ax,%ax
    125c:	66 90                	xchg   %ax,%ax
    125e:	66 90                	xchg   %ax,%ax

00001260 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1260:	55                   	push   %ebp
    1261:	89 e5                	mov    %esp,%ebp
    1263:	57                   	push   %edi
    1264:	56                   	push   %esi
    1265:	53                   	push   %ebx
    1266:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1269:	85 d2                	test   %edx,%edx
{
    126b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
    126e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    1270:	79 76                	jns    12e8 <printint+0x88>
    1272:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    1276:	74 70                	je     12e8 <printint+0x88>
    x = -xx;
    1278:	f7 d8                	neg    %eax
    neg = 1;
    127a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1281:	31 f6                	xor    %esi,%esi
    1283:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    1286:	eb 0a                	jmp    1292 <printint+0x32>
    1288:	90                   	nop
    1289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
    1290:	89 fe                	mov    %edi,%esi
    1292:	31 d2                	xor    %edx,%edx
    1294:	8d 7e 01             	lea    0x1(%esi),%edi
    1297:	f7 f1                	div    %ecx
    1299:	0f b6 92 90 1e 00 00 	movzbl 0x1e90(%edx),%edx
  }while((x /= base) != 0);
    12a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    12a2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
    12a5:	75 e9                	jne    1290 <printint+0x30>
  if(neg)
    12a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    12aa:	85 c0                	test   %eax,%eax
    12ac:	74 08                	je     12b6 <printint+0x56>
    buf[i++] = '-';
    12ae:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    12b3:	8d 7e 02             	lea    0x2(%esi),%edi
    12b6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
    12ba:	8b 7d c0             	mov    -0x40(%ebp),%edi
    12bd:	8d 76 00             	lea    0x0(%esi),%esi
    12c0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
    12c3:	83 ec 04             	sub    $0x4,%esp
    12c6:	83 ee 01             	sub    $0x1,%esi
    12c9:	6a 01                	push   $0x1
    12cb:	53                   	push   %ebx
    12cc:	57                   	push   %edi
    12cd:	88 45 d7             	mov    %al,-0x29(%ebp)
    12d0:	e8 ed fe ff ff       	call   11c2 <write>

  while(--i >= 0)
    12d5:	83 c4 10             	add    $0x10,%esp
    12d8:	39 de                	cmp    %ebx,%esi
    12da:	75 e4                	jne    12c0 <printint+0x60>
    putc(fd, buf[i]);
}
    12dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    12df:	5b                   	pop    %ebx
    12e0:	5e                   	pop    %esi
    12e1:	5f                   	pop    %edi
    12e2:	5d                   	pop    %ebp
    12e3:	c3                   	ret    
    12e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    12e8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    12ef:	eb 90                	jmp    1281 <printint+0x21>
    12f1:	eb 0d                	jmp    1300 <printf>
    12f3:	90                   	nop
    12f4:	90                   	nop
    12f5:	90                   	nop
    12f6:	90                   	nop
    12f7:	90                   	nop
    12f8:	90                   	nop
    12f9:	90                   	nop
    12fa:	90                   	nop
    12fb:	90                   	nop
    12fc:	90                   	nop
    12fd:	90                   	nop
    12fe:	90                   	nop
    12ff:	90                   	nop

00001300 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1300:	55                   	push   %ebp
    1301:	89 e5                	mov    %esp,%ebp
    1303:	57                   	push   %edi
    1304:	56                   	push   %esi
    1305:	53                   	push   %ebx
    1306:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1309:	8b 75 0c             	mov    0xc(%ebp),%esi
    130c:	0f b6 1e             	movzbl (%esi),%ebx
    130f:	84 db                	test   %bl,%bl
    1311:	0f 84 b3 00 00 00    	je     13ca <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
    1317:	8d 45 10             	lea    0x10(%ebp),%eax
    131a:	83 c6 01             	add    $0x1,%esi
  state = 0;
    131d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
    131f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1322:	eb 2f                	jmp    1353 <printf+0x53>
    1324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1328:	83 f8 25             	cmp    $0x25,%eax
    132b:	0f 84 a7 00 00 00    	je     13d8 <printf+0xd8>
  write(fd, &c, 1);
    1331:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1334:	83 ec 04             	sub    $0x4,%esp
    1337:	88 5d e2             	mov    %bl,-0x1e(%ebp)
    133a:	6a 01                	push   $0x1
    133c:	50                   	push   %eax
    133d:	ff 75 08             	pushl  0x8(%ebp)
    1340:	e8 7d fe ff ff       	call   11c2 <write>
    1345:	83 c4 10             	add    $0x10,%esp
    1348:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    134b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    134f:	84 db                	test   %bl,%bl
    1351:	74 77                	je     13ca <printf+0xca>
    if(state == 0){
    1353:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    1355:	0f be cb             	movsbl %bl,%ecx
    1358:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    135b:	74 cb                	je     1328 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    135d:	83 ff 25             	cmp    $0x25,%edi
    1360:	75 e6                	jne    1348 <printf+0x48>
      if(c == 'd'){
    1362:	83 f8 64             	cmp    $0x64,%eax
    1365:	0f 84 05 01 00 00    	je     1470 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    136b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    1371:	83 f9 70             	cmp    $0x70,%ecx
    1374:	74 72                	je     13e8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1376:	83 f8 73             	cmp    $0x73,%eax
    1379:	0f 84 99 00 00 00    	je     1418 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    137f:	83 f8 63             	cmp    $0x63,%eax
    1382:	0f 84 08 01 00 00    	je     1490 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1388:	83 f8 25             	cmp    $0x25,%eax
    138b:	0f 84 ef 00 00 00    	je     1480 <printf+0x180>
  write(fd, &c, 1);
    1391:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1394:	83 ec 04             	sub    $0x4,%esp
    1397:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    139b:	6a 01                	push   $0x1
    139d:	50                   	push   %eax
    139e:	ff 75 08             	pushl  0x8(%ebp)
    13a1:	e8 1c fe ff ff       	call   11c2 <write>
    13a6:	83 c4 0c             	add    $0xc,%esp
    13a9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    13ac:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    13af:	6a 01                	push   $0x1
    13b1:	50                   	push   %eax
    13b2:	ff 75 08             	pushl  0x8(%ebp)
    13b5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    13b8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    13ba:	e8 03 fe ff ff       	call   11c2 <write>
  for(i = 0; fmt[i]; i++){
    13bf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
    13c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    13c6:	84 db                	test   %bl,%bl
    13c8:	75 89                	jne    1353 <printf+0x53>
    }
  }
}
    13ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
    13cd:	5b                   	pop    %ebx
    13ce:	5e                   	pop    %esi
    13cf:	5f                   	pop    %edi
    13d0:	5d                   	pop    %ebp
    13d1:	c3                   	ret    
    13d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    13d8:	bf 25 00 00 00       	mov    $0x25,%edi
    13dd:	e9 66 ff ff ff       	jmp    1348 <printf+0x48>
    13e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    13e8:	83 ec 0c             	sub    $0xc,%esp
    13eb:	b9 10 00 00 00       	mov    $0x10,%ecx
    13f0:	6a 00                	push   $0x0
    13f2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    13f5:	8b 45 08             	mov    0x8(%ebp),%eax
    13f8:	8b 17                	mov    (%edi),%edx
    13fa:	e8 61 fe ff ff       	call   1260 <printint>
        ap++;
    13ff:	89 f8                	mov    %edi,%eax
    1401:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1404:	31 ff                	xor    %edi,%edi
        ap++;
    1406:	83 c0 04             	add    $0x4,%eax
    1409:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    140c:	e9 37 ff ff ff       	jmp    1348 <printf+0x48>
    1411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1418:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    141b:	8b 08                	mov    (%eax),%ecx
        ap++;
    141d:	83 c0 04             	add    $0x4,%eax
    1420:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    1423:	85 c9                	test   %ecx,%ecx
    1425:	0f 84 8e 00 00 00    	je     14b9 <printf+0x1b9>
        while(*s != 0){
    142b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    142e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    1430:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    1432:	84 c0                	test   %al,%al
    1434:	0f 84 0e ff ff ff    	je     1348 <printf+0x48>
    143a:	89 75 d0             	mov    %esi,-0x30(%ebp)
    143d:	89 de                	mov    %ebx,%esi
    143f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1442:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    1445:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    1448:	83 ec 04             	sub    $0x4,%esp
          s++;
    144b:	83 c6 01             	add    $0x1,%esi
    144e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    1451:	6a 01                	push   $0x1
    1453:	57                   	push   %edi
    1454:	53                   	push   %ebx
    1455:	e8 68 fd ff ff       	call   11c2 <write>
        while(*s != 0){
    145a:	0f b6 06             	movzbl (%esi),%eax
    145d:	83 c4 10             	add    $0x10,%esp
    1460:	84 c0                	test   %al,%al
    1462:	75 e4                	jne    1448 <printf+0x148>
    1464:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1467:	31 ff                	xor    %edi,%edi
    1469:	e9 da fe ff ff       	jmp    1348 <printf+0x48>
    146e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    1470:	83 ec 0c             	sub    $0xc,%esp
    1473:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1478:	6a 01                	push   $0x1
    147a:	e9 73 ff ff ff       	jmp    13f2 <printf+0xf2>
    147f:	90                   	nop
  write(fd, &c, 1);
    1480:	83 ec 04             	sub    $0x4,%esp
    1483:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    1486:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1489:	6a 01                	push   $0x1
    148b:	e9 21 ff ff ff       	jmp    13b1 <printf+0xb1>
        putc(fd, *ap);
    1490:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    1493:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1496:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    1498:	6a 01                	push   $0x1
        ap++;
    149a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    149d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    14a0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    14a3:	50                   	push   %eax
    14a4:	ff 75 08             	pushl  0x8(%ebp)
    14a7:	e8 16 fd ff ff       	call   11c2 <write>
        ap++;
    14ac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    14af:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14b2:	31 ff                	xor    %edi,%edi
    14b4:	e9 8f fe ff ff       	jmp    1348 <printf+0x48>
          s = "(null)";
    14b9:	bb 87 1e 00 00       	mov    $0x1e87,%ebx
        while(*s != 0){
    14be:	b8 28 00 00 00       	mov    $0x28,%eax
    14c3:	e9 72 ff ff ff       	jmp    143a <printf+0x13a>
    14c8:	66 90                	xchg   %ax,%ax
    14ca:	66 90                	xchg   %ax,%ax
    14cc:	66 90                	xchg   %ax,%ax
    14ce:	66 90                	xchg   %ax,%ax

000014d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    14d0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    14d1:	a1 00 23 00 00       	mov    0x2300,%eax
{
    14d6:	89 e5                	mov    %esp,%ebp
    14d8:	57                   	push   %edi
    14d9:	56                   	push   %esi
    14da:	53                   	push   %ebx
    14db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    14de:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    14e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    14e8:	39 c8                	cmp    %ecx,%eax
    14ea:	8b 10                	mov    (%eax),%edx
    14ec:	73 32                	jae    1520 <free+0x50>
    14ee:	39 d1                	cmp    %edx,%ecx
    14f0:	72 04                	jb     14f6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    14f2:	39 d0                	cmp    %edx,%eax
    14f4:	72 32                	jb     1528 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    14f6:	8b 73 fc             	mov    -0x4(%ebx),%esi
    14f9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    14fc:	39 fa                	cmp    %edi,%edx
    14fe:	74 30                	je     1530 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1500:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1503:	8b 50 04             	mov    0x4(%eax),%edx
    1506:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1509:	39 f1                	cmp    %esi,%ecx
    150b:	74 3a                	je     1547 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    150d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    150f:	a3 00 23 00 00       	mov    %eax,0x2300
}
    1514:	5b                   	pop    %ebx
    1515:	5e                   	pop    %esi
    1516:	5f                   	pop    %edi
    1517:	5d                   	pop    %ebp
    1518:	c3                   	ret    
    1519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1520:	39 d0                	cmp    %edx,%eax
    1522:	72 04                	jb     1528 <free+0x58>
    1524:	39 d1                	cmp    %edx,%ecx
    1526:	72 ce                	jb     14f6 <free+0x26>
{
    1528:	89 d0                	mov    %edx,%eax
    152a:	eb bc                	jmp    14e8 <free+0x18>
    152c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1530:	03 72 04             	add    0x4(%edx),%esi
    1533:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1536:	8b 10                	mov    (%eax),%edx
    1538:	8b 12                	mov    (%edx),%edx
    153a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    153d:	8b 50 04             	mov    0x4(%eax),%edx
    1540:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1543:	39 f1                	cmp    %esi,%ecx
    1545:	75 c6                	jne    150d <free+0x3d>
    p->s.size += bp->s.size;
    1547:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    154a:	a3 00 23 00 00       	mov    %eax,0x2300
    p->s.size += bp->s.size;
    154f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1552:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1555:	89 10                	mov    %edx,(%eax)
}
    1557:	5b                   	pop    %ebx
    1558:	5e                   	pop    %esi
    1559:	5f                   	pop    %edi
    155a:	5d                   	pop    %ebp
    155b:	c3                   	ret    
    155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001560 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1560:	55                   	push   %ebp
    1561:	89 e5                	mov    %esp,%ebp
    1563:	57                   	push   %edi
    1564:	56                   	push   %esi
    1565:	53                   	push   %ebx
    1566:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1569:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    156c:	8b 15 00 23 00 00    	mov    0x2300,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1572:	8d 78 07             	lea    0x7(%eax),%edi
    1575:	c1 ef 03             	shr    $0x3,%edi
    1578:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    157b:	85 d2                	test   %edx,%edx
    157d:	0f 84 9d 00 00 00    	je     1620 <malloc+0xc0>
    1583:	8b 02                	mov    (%edx),%eax
    1585:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1588:	39 cf                	cmp    %ecx,%edi
    158a:	76 6c                	jbe    15f8 <malloc+0x98>
    158c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    1592:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1597:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    159a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    15a1:	eb 0e                	jmp    15b1 <malloc+0x51>
    15a3:	90                   	nop
    15a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    15a8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    15aa:	8b 48 04             	mov    0x4(%eax),%ecx
    15ad:	39 f9                	cmp    %edi,%ecx
    15af:	73 47                	jae    15f8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    15b1:	39 05 00 23 00 00    	cmp    %eax,0x2300
    15b7:	89 c2                	mov    %eax,%edx
    15b9:	75 ed                	jne    15a8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    15bb:	83 ec 0c             	sub    $0xc,%esp
    15be:	56                   	push   %esi
    15bf:	e8 66 fc ff ff       	call   122a <sbrk>
  if(p == (char*)-1)
    15c4:	83 c4 10             	add    $0x10,%esp
    15c7:	83 f8 ff             	cmp    $0xffffffff,%eax
    15ca:	74 1c                	je     15e8 <malloc+0x88>
  hp->s.size = nu;
    15cc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    15cf:	83 ec 0c             	sub    $0xc,%esp
    15d2:	83 c0 08             	add    $0x8,%eax
    15d5:	50                   	push   %eax
    15d6:	e8 f5 fe ff ff       	call   14d0 <free>
  return freep;
    15db:	8b 15 00 23 00 00    	mov    0x2300,%edx
      if((p = morecore(nunits)) == 0)
    15e1:	83 c4 10             	add    $0x10,%esp
    15e4:	85 d2                	test   %edx,%edx
    15e6:	75 c0                	jne    15a8 <malloc+0x48>
        return 0;
  }
}
    15e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    15eb:	31 c0                	xor    %eax,%eax
}
    15ed:	5b                   	pop    %ebx
    15ee:	5e                   	pop    %esi
    15ef:	5f                   	pop    %edi
    15f0:	5d                   	pop    %ebp
    15f1:	c3                   	ret    
    15f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    15f8:	39 cf                	cmp    %ecx,%edi
    15fa:	74 54                	je     1650 <malloc+0xf0>
        p->s.size -= nunits;
    15fc:	29 f9                	sub    %edi,%ecx
    15fe:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1601:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1604:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    1607:	89 15 00 23 00 00    	mov    %edx,0x2300
}
    160d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1610:	83 c0 08             	add    $0x8,%eax
}
    1613:	5b                   	pop    %ebx
    1614:	5e                   	pop    %esi
    1615:	5f                   	pop    %edi
    1616:	5d                   	pop    %ebp
    1617:	c3                   	ret    
    1618:	90                   	nop
    1619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    1620:	c7 05 00 23 00 00 04 	movl   $0x2304,0x2300
    1627:	23 00 00 
    162a:	c7 05 04 23 00 00 04 	movl   $0x2304,0x2304
    1631:	23 00 00 
    base.s.size = 0;
    1634:	b8 04 23 00 00       	mov    $0x2304,%eax
    1639:	c7 05 08 23 00 00 00 	movl   $0x0,0x2308
    1640:	00 00 00 
    1643:	e9 44 ff ff ff       	jmp    158c <malloc+0x2c>
    1648:	90                   	nop
    1649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    1650:	8b 08                	mov    (%eax),%ecx
    1652:	89 0a                	mov    %ecx,(%edx)
    1654:	eb b1                	jmp    1607 <malloc+0xa7>
