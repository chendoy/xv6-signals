
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
    printf(0,"--------- SIGPROCMASK TEST ---------\n");
      11:	68 a0 1c 00 00       	push   $0x1ca0
      16:	6a 00                	push   $0x0
      18:	e8 93 13 00 00       	call   13b0 <printf>
    sigprocmask_test();
      1d:	e8 0e 01 00 00       	call   130 <sigprocmask_test>
    printf(0,"--------- STOP_CONT_KILL_ABC TEST ---------\n");
      22:	58                   	pop    %eax
      23:	5a                   	pop    %edx
      24:	68 c8 1c 00 00       	push   $0x1cc8
      29:	6a 00                	push   $0x0
      2b:	e8 80 13 00 00       	call   13b0 <printf>
    cont_stop_kill_abc_test();
      30:	e8 8b 01 00 00       	call   1c0 <cont_stop_kill_abc_test>
    printf(0,"--------- CUSTOM USER HANDLER TEST ---------\n");
      35:	59                   	pop    %ecx
      36:	58                   	pop    %eax
      37:	68 f8 1c 00 00       	push   $0x1cf8
      3c:	6a 00                	push   $0x0
      3e:	e8 6d 13 00 00       	call   13b0 <printf>
    user_handler_test();
      43:	e8 e8 04 00 00       	call   530 <user_handler_test>
    printf(0,"\n");
      48:	58                   	pop    %eax
      49:	5a                   	pop    %edx
      4a:	68 6c 1e 00 00       	push   $0x1e6c
      4f:	6a 00                	push   $0x0
      51:	e8 5a 13 00 00       	call   13b0 <printf>
    printf(0,"--------- SIGACTION TESTS ---------\n");
      56:	59                   	pop    %ecx
      57:	58                   	pop    %eax
      58:	68 28 1d 00 00       	push   $0x1d28
      5d:	6a 00                	push   $0x0
      5f:	e8 4c 13 00 00       	call   13b0 <printf>
    simple_sigaction_test();
      64:	e8 87 05 00 00       	call   5f0 <simple_sigaction_test>
    printf(0,"\n");
      69:	58                   	pop    %eax
      6a:	5a                   	pop    %edx
      6b:	68 6c 1e 00 00       	push   $0x1e6c
      70:	6a 00                	push   $0x0
      72:	e8 39 13 00 00       	call   13b0 <printf>
    printf(0,"--------- SIGNAL TESTS 1 --------- \n");
      77:	59                   	pop    %ecx
      78:	58                   	pop    %eax
      79:	68 50 1d 00 00       	push   $0x1d50
      7e:	6a 00                	push   $0x0
      80:	e8 2b 13 00 00       	call   13b0 <printf>
    SignalTests1();
      85:	e8 16 08 00 00       	call   8a0 <SignalTests1>
    printf(0,"\n");
      8a:	58                   	pop    %eax
      8b:	5a                   	pop    %edx
      8c:	68 6c 1e 00 00       	push   $0x1e6c
      91:	6a 00                	push   $0x0
      93:	e8 18 13 00 00       	call   13b0 <printf>
    printf(0,"---------  SIGNAL TESTS 2 --------- \n");
      98:	59                   	pop    %ecx
      99:	58                   	pop    %eax
      9a:	68 78 1d 00 00       	push   $0x1d78
      9f:	6a 00                	push   $0x0
      a1:	e8 0a 13 00 00       	call   13b0 <printf>
    SignalTests2();
      a6:	e8 85 09 00 00       	call   a30 <SignalTests2>
    printf(0,"\n");
      ab:	58                   	pop    %eax
      ac:	5a                   	pop    %edx
      ad:	68 6c 1e 00 00       	push   $0x1e6c
      b2:	6a 00                	push   $0x0
      b4:	e8 f7 12 00 00       	call   13b0 <printf>
    printf(0,"---------  SIGNAL TESTS 3 --------- \n");
      b9:	59                   	pop    %ecx
      ba:	58                   	pop    %eax
      bb:	68 a0 1d 00 00       	push   $0x1da0
      c0:	6a 00                	push   $0x0
      c2:	e8 e9 12 00 00       	call   13b0 <printf>
    SignalTests3();
      c7:	e8 04 0b 00 00       	call   bd0 <SignalTests3>
    printf(0,"\n");
      cc:	58                   	pop    %eax
      cd:	5a                   	pop    %edx
      ce:	68 6c 1e 00 00       	push   $0x1e6c
      d3:	6a 00                	push   $0x0
      d5:	e8 d6 12 00 00       	call   13b0 <printf>
    printf(0,"Done TESTS\n");
      da:	59                   	pop    %ecx
      db:	58                   	pop    %eax
      dc:	68 23 20 00 00       	push   $0x2023
      e1:	6a 00                	push   $0x0
      e3:	e8 c8 12 00 00       	call   13b0 <printf>
    exit();
      e8:	e8 65 11 00 00       	call   1252 <exit>
      ed:	66 90                	xchg   %ax,%ax
      ef:	90                   	nop

000000f0 <custom_handler>:
{
      f0:	55                   	push   %ebp
      f1:	89 e5                	mov    %esp,%ebp
      f3:	83 ec 10             	sub    $0x10,%esp
    printf(1, "child: CUSTOM HANDLER WAS FIRED!!\n");
      f6:	68 08 17 00 00       	push   $0x1708
      fb:	6a 01                	push   $0x1
      fd:	e8 ae 12 00 00       	call   13b0 <printf>
    return;
     102:	83 c4 10             	add    $0x10,%esp
}
     105:	c9                   	leave  
     106:	c3                   	ret    
     107:	89 f6                	mov    %esi,%esi
     109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <user_handler_signal>:
{
     110:	55                   	push   %ebp
     111:	89 e5                	mov    %esp,%ebp
     113:	83 ec 08             	sub    $0x8,%esp
    printf(0,"pid : %d is Using User Handler Signal - %d!!!!WOrks!!!\n", getpid(),signum);
     116:	e8 b7 11 00 00       	call   12d2 <getpid>
     11b:	ff 75 08             	pushl  0x8(%ebp)
     11e:	50                   	push   %eax
     11f:	68 2c 17 00 00       	push   $0x172c
     124:	6a 00                	push   $0x0
     126:	e8 85 12 00 00       	call   13b0 <printf>
    return;
     12b:	83 c4 10             	add    $0x10,%esp
}
     12e:	c9                   	leave  
     12f:	c3                   	ret    

00000130 <sigprocmask_test>:
{
     130:	55                   	push   %ebp
     131:	89 e5                	mov    %esp,%ebp
     133:	56                   	push   %esi
     134:	53                   	push   %ebx
    for(i = 1; i < ITER_SIGPROCMASK_TEST; i++) {
     135:	bb 01 00 00 00       	mov    $0x1,%ebx
{
     13a:	83 ec 10             	sub    $0x10,%esp
     13d:	8d 76 00             	lea    0x0(%esi),%esi
        omask = sigprocmask(mask);
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	53                   	push   %ebx
     144:	e8 a9 11 00 00       	call   12f2 <sigprocmask>
        printf(1, "should be %d = %d\n", i-1 ,omask);
     149:	50                   	push   %eax
     14a:	8d 43 ff             	lea    -0x1(%ebx),%eax
    for(i = 1; i < ITER_SIGPROCMASK_TEST; i++) {
     14d:	83 c3 01             	add    $0x1,%ebx
        printf(1, "should be %d = %d\n", i-1 ,omask);
     150:	50                   	push   %eax
     151:	68 c8 1d 00 00       	push   $0x1dc8
     156:	6a 01                	push   $0x1
     158:	e8 53 12 00 00       	call   13b0 <printf>
    for(i = 1; i < ITER_SIGPROCMASK_TEST; i++) {
     15d:	83 c4 20             	add    $0x20,%esp
     160:	83 fb 0a             	cmp    $0xa,%ebx
     163:	75 db                	jne    140 <sigprocmask_test+0x10>
    sigaction(12, &newact, &oldact);
     165:	8d 5d f0             	lea    -0x10(%ebp),%ebx
     168:	8d 75 e8             	lea    -0x18(%ebp),%esi
     16b:	83 ec 04             	sub    $0x4,%esp
    newact.sa_handler = SIG_IGN;
     16e:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    newact.sigmask = 12;
     175:	c7 45 ec 0c 00 00 00 	movl   $0xc,-0x14(%ebp)
    sigaction(12, &newact, &oldact);
     17c:	53                   	push   %ebx
     17d:	56                   	push   %esi
     17e:	6a 0c                	push   $0xc
     180:	e8 75 11 00 00       	call   12fa <sigaction>
    printf(1, "should be 0,0 = %d,%d\n", (uint)oldact.sa_handler, oldact.sigmask);
     185:	ff 75 f4             	pushl  -0xc(%ebp)
     188:	ff 75 f0             	pushl  -0x10(%ebp)
     18b:	68 db 1d 00 00       	push   $0x1ddb
     190:	6a 01                	push   $0x1
     192:	e8 19 12 00 00       	call   13b0 <printf>
    sigaction(12, &oldact, &newact);
     197:	83 c4 1c             	add    $0x1c,%esp
     19a:	56                   	push   %esi
     19b:	53                   	push   %ebx
     19c:	6a 0c                	push   $0xc
     19e:	e8 57 11 00 00       	call   12fa <sigaction>
    printf(1, "should be 1,12 = %d,%d\n", (uint)newact.sa_handler, newact.sigmask);
     1a3:	ff 75 ec             	pushl  -0x14(%ebp)
     1a6:	ff 75 e8             	pushl  -0x18(%ebp)
     1a9:	68 f2 1d 00 00       	push   $0x1df2
     1ae:	6a 01                	push   $0x1
     1b0:	e8 fb 11 00 00       	call   13b0 <printf>
}
     1b5:	83 c4 20             	add    $0x20,%esp
     1b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
     1bb:	5b                   	pop    %ebx
     1bc:	5e                   	pop    %esi
     1bd:	5d                   	pop    %ebp
     1be:	c3                   	ret    
     1bf:	90                   	nop

000001c0 <cont_stop_kill_abc_test>:
{
     1c0:	55                   	push   %ebp
     1c1:	89 e5                	mov    %esp,%ebp
     1c3:	57                   	push   %edi
     1c4:	56                   	push   %esi
     1c5:	53                   	push   %ebx
     1c6:	83 ec 1c             	sub    $0x1c,%esp
    int sigs[] = {SIGSTOP, SIGCONT};
     1c9:	c7 45 e0 11 00 00 00 	movl   $0x11,-0x20(%ebp)
     1d0:	c7 45 e4 13 00 00 00 	movl   $0x13,-0x1c(%ebp)
    if((pid = fork()) == 0) {
     1d7:	e8 6e 10 00 00       	call   124a <fork>
     1dc:	85 c0                	test   %eax,%eax
     1de:	74 70                	je     250 <cont_stop_kill_abc_test+0x90>
     1e0:	89 c6                	mov    %eax,%esi
     1e2:	bf 11 00 00 00       	mov    $0x11,%edi
        for (int i = 0; i < 20; i++)
     1e7:	31 db                	xor    %ebx,%ebx
     1e9:	eb 41                	jmp    22c <cont_stop_kill_abc_test+0x6c>
                printf(2, "\n%d: SENT: CONT\n", i);
     1eb:	83 ec 04             	sub    $0x4,%esp
     1ee:	53                   	push   %ebx
     1ef:	68 3e 1e 00 00       	push   $0x1e3e
     1f4:	6a 02                	push   $0x2
     1f6:	e8 b5 11 00 00       	call   13b0 <printf>
     1fb:	83 c4 10             	add    $0x10,%esp
            kill(pid, sigs[i%2]);
     1fe:	83 ec 08             	sub    $0x8,%esp
        for (int i = 0; i < 20; i++)
     201:	83 c3 01             	add    $0x1,%ebx
            kill(pid, sigs[i%2]);
     204:	57                   	push   %edi
     205:	56                   	push   %esi
     206:	e8 77 10 00 00       	call   1282 <kill>
            sleep(50);
     20b:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     212:	e8 cb 10 00 00       	call   12e2 <sleep>
        for (int i = 0; i < 20; i++)
     217:	83 c4 10             	add    $0x10,%esp
     21a:	83 fb 14             	cmp    $0x14,%ebx
     21d:	0f 84 d7 02 00 00    	je     4fa <cont_stop_kill_abc_test+0x33a>
     223:	89 d8                	mov    %ebx,%eax
     225:	83 e0 01             	and    $0x1,%eax
     228:	8b 7c 85 e0          	mov    -0x20(%ebp,%eax,4),%edi
            if (i % 2)
     22c:	f6 c3 01             	test   $0x1,%bl
     22f:	75 ba                	jne    1eb <cont_stop_kill_abc_test+0x2b>
                printf(2, "\n%d: SENT: STOP\n", i);    
     231:	83 ec 04             	sub    $0x4,%esp
     234:	53                   	push   %ebx
     235:	68 4f 1e 00 00       	push   $0x1e4f
     23a:	6a 02                	push   $0x2
     23c:	e8 6f 11 00 00       	call   13b0 <printf>
     241:	83 c4 10             	add    $0x10,%esp
     244:	eb b8                	jmp    1fe <cont_stop_kill_abc_test+0x3e>
     246:	8d 76 00             	lea    0x0(%esi),%esi
     249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            sleep(5);printf(1, "a");sleep(5);printf(1, "b");sleep(5);printf(1, "c");sleep(5);printf(1, "d");
     250:	83 ec 0c             	sub    $0xc,%esp
     253:	6a 05                	push   $0x5
     255:	e8 88 10 00 00       	call   12e2 <sleep>
     25a:	59                   	pop    %ecx
     25b:	5b                   	pop    %ebx
     25c:	68 0a 1e 00 00       	push   $0x1e0a
     261:	6a 01                	push   $0x1
     263:	e8 48 11 00 00       	call   13b0 <printf>
     268:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     26f:	e8 6e 10 00 00       	call   12e2 <sleep>
     274:	5e                   	pop    %esi
     275:	5f                   	pop    %edi
     276:	68 0c 1e 00 00       	push   $0x1e0c
     27b:	6a 01                	push   $0x1
     27d:	e8 2e 11 00 00       	call   13b0 <printf>
     282:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     289:	e8 54 10 00 00       	call   12e2 <sleep>
     28e:	58                   	pop    %eax
     28f:	5a                   	pop    %edx
     290:	68 0e 1e 00 00       	push   $0x1e0e
     295:	6a 01                	push   $0x1
     297:	e8 14 11 00 00       	call   13b0 <printf>
     29c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2a3:	e8 3a 10 00 00       	call   12e2 <sleep>
     2a8:	59                   	pop    %ecx
     2a9:	5b                   	pop    %ebx
     2aa:	68 10 1e 00 00       	push   $0x1e10
     2af:	6a 01                	push   $0x1
     2b1:	e8 fa 10 00 00       	call   13b0 <printf>
            sleep(5);printf(1, "e");sleep(5);printf(1, "f");sleep(5);printf(1, "g");sleep(5);printf(1, "h");
     2b6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2bd:	e8 20 10 00 00       	call   12e2 <sleep>
     2c2:	5e                   	pop    %esi
     2c3:	5f                   	pop    %edi
     2c4:	68 12 1e 00 00       	push   $0x1e12
     2c9:	6a 01                	push   $0x1
     2cb:	e8 e0 10 00 00       	call   13b0 <printf>
     2d0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2d7:	e8 06 10 00 00       	call   12e2 <sleep>
     2dc:	58                   	pop    %eax
     2dd:	5a                   	pop    %edx
     2de:	68 14 1e 00 00       	push   $0x1e14
     2e3:	6a 01                	push   $0x1
     2e5:	e8 c6 10 00 00       	call   13b0 <printf>
     2ea:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     2f1:	e8 ec 0f 00 00       	call   12e2 <sleep>
     2f6:	59                   	pop    %ecx
     2f7:	5b                   	pop    %ebx
     2f8:	68 16 1e 00 00       	push   $0x1e16
     2fd:	6a 01                	push   $0x1
     2ff:	e8 ac 10 00 00       	call   13b0 <printf>
     304:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     30b:	e8 d2 0f 00 00       	call   12e2 <sleep>
     310:	5e                   	pop    %esi
     311:	5f                   	pop    %edi
     312:	68 18 1e 00 00       	push   $0x1e18
     317:	6a 01                	push   $0x1
     319:	e8 92 10 00 00       	call   13b0 <printf>
            sleep(5);printf(1, "i");sleep(5);printf(1, "j");sleep(5);printf(1, "k");sleep(5);printf(1, "l");
     31e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     325:	e8 b8 0f 00 00       	call   12e2 <sleep>
     32a:	58                   	pop    %eax
     32b:	5a                   	pop    %edx
     32c:	68 1a 1e 00 00       	push   $0x1e1a
     331:	6a 01                	push   $0x1
     333:	e8 78 10 00 00       	call   13b0 <printf>
     338:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     33f:	e8 9e 0f 00 00       	call   12e2 <sleep>
     344:	59                   	pop    %ecx
     345:	5b                   	pop    %ebx
     346:	68 1c 1e 00 00       	push   $0x1e1c
     34b:	6a 01                	push   $0x1
     34d:	e8 5e 10 00 00       	call   13b0 <printf>
     352:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     359:	e8 84 0f 00 00       	call   12e2 <sleep>
     35e:	5e                   	pop    %esi
     35f:	5f                   	pop    %edi
     360:	68 1e 1e 00 00       	push   $0x1e1e
     365:	6a 01                	push   $0x1
     367:	e8 44 10 00 00       	call   13b0 <printf>
     36c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     373:	e8 6a 0f 00 00       	call   12e2 <sleep>
     378:	58                   	pop    %eax
     379:	5a                   	pop    %edx
     37a:	68 20 1e 00 00       	push   $0x1e20
     37f:	6a 01                	push   $0x1
     381:	e8 2a 10 00 00       	call   13b0 <printf>
            sleep(5);printf(1, "m");sleep(5);printf(1, "n");sleep(5);printf(1, "o");sleep(5);printf(1, "p");
     386:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     38d:	e8 50 0f 00 00       	call   12e2 <sleep>
     392:	59                   	pop    %ecx
     393:	5b                   	pop    %ebx
     394:	68 22 1e 00 00       	push   $0x1e22
     399:	6a 01                	push   $0x1
     39b:	e8 10 10 00 00       	call   13b0 <printf>
     3a0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     3a7:	e8 36 0f 00 00       	call   12e2 <sleep>
     3ac:	5e                   	pop    %esi
     3ad:	5f                   	pop    %edi
     3ae:	68 24 1e 00 00       	push   $0x1e24
     3b3:	6a 01                	push   $0x1
     3b5:	e8 f6 0f 00 00       	call   13b0 <printf>
     3ba:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     3c1:	e8 1c 0f 00 00       	call   12e2 <sleep>
     3c6:	58                   	pop    %eax
     3c7:	5a                   	pop    %edx
     3c8:	68 26 1e 00 00       	push   $0x1e26
     3cd:	6a 01                	push   $0x1
     3cf:	e8 dc 0f 00 00       	call   13b0 <printf>
     3d4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     3db:	e8 02 0f 00 00       	call   12e2 <sleep>
     3e0:	59                   	pop    %ecx
     3e1:	5b                   	pop    %ebx
     3e2:	68 28 1e 00 00       	push   $0x1e28
     3e7:	6a 01                	push   $0x1
     3e9:	e8 c2 0f 00 00       	call   13b0 <printf>
            sleep(5);printf(1, "q");sleep(5);printf(1, "r");sleep(5);printf(1, "s");sleep(5);printf(1, "t");
     3ee:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     3f5:	e8 e8 0e 00 00       	call   12e2 <sleep>
     3fa:	5e                   	pop    %esi
     3fb:	5f                   	pop    %edi
     3fc:	68 2a 1e 00 00       	push   $0x1e2a
     401:	6a 01                	push   $0x1
     403:	e8 a8 0f 00 00       	call   13b0 <printf>
     408:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     40f:	e8 ce 0e 00 00       	call   12e2 <sleep>
     414:	58                   	pop    %eax
     415:	5a                   	pop    %edx
     416:	68 2c 1e 00 00       	push   $0x1e2c
     41b:	6a 01                	push   $0x1
     41d:	e8 8e 0f 00 00       	call   13b0 <printf>
     422:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     429:	e8 b4 0e 00 00       	call   12e2 <sleep>
     42e:	59                   	pop    %ecx
     42f:	5b                   	pop    %ebx
     430:	68 2e 1e 00 00       	push   $0x1e2e
     435:	6a 01                	push   $0x1
     437:	e8 74 0f 00 00       	call   13b0 <printf>
     43c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     443:	e8 9a 0e 00 00       	call   12e2 <sleep>
     448:	5e                   	pop    %esi
     449:	5f                   	pop    %edi
     44a:	68 30 1e 00 00       	push   $0x1e30
     44f:	6a 01                	push   $0x1
     451:	e8 5a 0f 00 00       	call   13b0 <printf>
            sleep(5);printf(1, "u");sleep(5);printf(1, "v");sleep(5);printf(1, "w");sleep(5);printf(1, "x");
     456:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     45d:	e8 80 0e 00 00       	call   12e2 <sleep>
     462:	58                   	pop    %eax
     463:	5a                   	pop    %edx
     464:	68 32 1e 00 00       	push   $0x1e32
     469:	6a 01                	push   $0x1
     46b:	e8 40 0f 00 00       	call   13b0 <printf>
     470:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     477:	e8 66 0e 00 00       	call   12e2 <sleep>
     47c:	59                   	pop    %ecx
     47d:	5b                   	pop    %ebx
     47e:	68 34 1e 00 00       	push   $0x1e34
     483:	6a 01                	push   $0x1
     485:	e8 26 0f 00 00       	call   13b0 <printf>
     48a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     491:	e8 4c 0e 00 00       	call   12e2 <sleep>
     496:	5e                   	pop    %esi
     497:	5f                   	pop    %edi
     498:	68 36 1e 00 00       	push   $0x1e36
     49d:	6a 01                	push   $0x1
     49f:	e8 0c 0f 00 00       	call   13b0 <printf>
     4a4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     4ab:	e8 32 0e 00 00       	call   12e2 <sleep>
     4b0:	58                   	pop    %eax
     4b1:	5a                   	pop    %edx
     4b2:	68 38 1e 00 00       	push   $0x1e38
     4b7:	6a 01                	push   $0x1
     4b9:	e8 f2 0e 00 00       	call   13b0 <printf>
            sleep(5);printf(1, "y");sleep(5);printf(1, "z");
     4be:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     4c5:	e8 18 0e 00 00       	call   12e2 <sleep>
     4ca:	59                   	pop    %ecx
     4cb:	5b                   	pop    %ebx
     4cc:	68 3a 1e 00 00       	push   $0x1e3a
     4d1:	6a 01                	push   $0x1
     4d3:	e8 d8 0e 00 00       	call   13b0 <printf>
     4d8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     4df:	e8 fe 0d 00 00       	call   12e2 <sleep>
     4e4:	5e                   	pop    %esi
     4e5:	5f                   	pop    %edi
     4e6:	68 3c 1e 00 00       	push   $0x1e3c
     4eb:	6a 01                	push   $0x1
     4ed:	e8 be 0e 00 00       	call   13b0 <printf>
     4f2:	83 c4 10             	add    $0x10,%esp
     4f5:	e9 56 fd ff ff       	jmp    250 <cont_stop_kill_abc_test+0x90>
        printf(1, "\nSENT: KILL!\n");
     4fa:	83 ec 08             	sub    $0x8,%esp
     4fd:	68 60 1e 00 00       	push   $0x1e60
     502:	6a 01                	push   $0x1
     504:	e8 a7 0e 00 00       	call   13b0 <printf>
        kill(pid, SIGKILL);
     509:	58                   	pop    %eax
     50a:	5a                   	pop    %edx
     50b:	6a 09                	push   $0x9
     50d:	56                   	push   %esi
     50e:	e8 6f 0d 00 00       	call   1282 <kill>
        wait();
     513:	83 c4 10             	add    $0x10,%esp
}
     516:	8d 65 f4             	lea    -0xc(%ebp),%esp
     519:	5b                   	pop    %ebx
     51a:	5e                   	pop    %esi
     51b:	5f                   	pop    %edi
     51c:	5d                   	pop    %ebp
        wait();
     51d:	e9 38 0d 00 00       	jmp    125a <wait>
     522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000530 <user_handler_test>:
{
     530:	55                   	push   %ebp
     531:	89 e5                	mov    %esp,%ebp
     533:	53                   	push   %ebx
     534:	83 ec 14             	sub    $0x14,%esp
    act.sa_handler = &custom_handler;
     537:	c7 45 f0 f0 00 00 00 	movl   $0xf0,-0x10(%ebp)
    act.sigmask = mask;
     53e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if((pid = fork()) == 0) 
     545:	e8 00 0d 00 00       	call   124a <fork>
     54a:	85 c0                	test   %eax,%eax
     54c:	75 3a                	jne    588 <user_handler_test+0x58>
        sigaction(SIGTEST, &act, null); // register custom handler
     54e:	8d 45 f0             	lea    -0x10(%ebp),%eax
     551:	83 ec 04             	sub    $0x4,%esp
     554:	6a 00                	push   $0x0
     556:	50                   	push   %eax
     557:	6a 14                	push   $0x14
     559:	e8 9c 0d 00 00       	call   12fa <sigaction>
     55e:	83 c4 10             	add    $0x10,%esp
     561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(1, "child: waiting...\n");
     568:	83 ec 08             	sub    $0x8,%esp
     56b:	68 6e 1e 00 00       	push   $0x1e6e
     570:	6a 01                	push   $0x1
     572:	e8 39 0e 00 00       	call   13b0 <printf>
            sleep(30);
     577:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
     57e:	e8 5f 0d 00 00       	call   12e2 <sleep>
     583:	83 c4 10             	add    $0x10,%esp
     586:	eb e0                	jmp    568 <user_handler_test+0x38>
        sleep(300); // let child print some lines
     588:	83 ec 0c             	sub    $0xc,%esp
     58b:	89 c3                	mov    %eax,%ebx
     58d:	68 2c 01 00 00       	push   $0x12c
     592:	e8 4b 0d 00 00       	call   12e2 <sleep>
        printf(1, "parent: kill(child, SIGTEST)\n");
     597:	58                   	pop    %eax
     598:	5a                   	pop    %edx
     599:	68 81 1e 00 00       	push   $0x1e81
     59e:	6a 01                	push   $0x1
     5a0:	e8 0b 0e 00 00       	call   13b0 <printf>
        sleep(5);
     5a5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
     5ac:	e8 31 0d 00 00       	call   12e2 <sleep>
        kill(pid, SIGTEST);
     5b1:	59                   	pop    %ecx
     5b2:	58                   	pop    %eax
     5b3:	6a 14                	push   $0x14
     5b5:	53                   	push   %ebx
     5b6:	e8 c7 0c 00 00       	call   1282 <kill>
        sleep(50);
     5bb:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     5c2:	e8 1b 0d 00 00       	call   12e2 <sleep>
        printf(1, "parent: kill(child, SIGKILL)\n");
     5c7:	58                   	pop    %eax
     5c8:	5a                   	pop    %edx
     5c9:	68 9f 1e 00 00       	push   $0x1e9f
     5ce:	6a 01                	push   $0x1
     5d0:	e8 db 0d 00 00       	call   13b0 <printf>
        kill(pid, SIGKILL);
     5d5:	59                   	pop    %ecx
     5d6:	58                   	pop    %eax
     5d7:	6a 09                	push   $0x9
     5d9:	53                   	push   %ebx
     5da:	e8 a3 0c 00 00       	call   1282 <kill>
        wait();
     5df:	e8 76 0c 00 00       	call   125a <wait>
        return;
     5e4:	83 c4 10             	add    $0x10,%esp
}
     5e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     5ea:	c9                   	leave  
     5eb:	c3                   	ret    
     5ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000005f0 <simple_sigaction_test>:
{
     5f0:	55                   	push   %ebp
     5f1:	89 e5                	mov    %esp,%ebp
     5f3:	57                   	push   %edi
     5f4:	56                   	push   %esi
     5f5:	53                   	push   %ebx
     5f6:	83 ec 18             	sub    $0x18,%esp
    printf(0,"mask: %d\n",sigprocmask(0));
     5f9:	6a 00                	push   $0x0
     5fb:	e8 f2 0c 00 00       	call   12f2 <sigprocmask>
     600:	83 c4 0c             	add    $0xc,%esp
     603:	50                   	push   %eax
     604:	68 bd 1e 00 00       	push   $0x1ebd
     609:	6a 00                	push   $0x0
     60b:	e8 a0 0d 00 00       	call   13b0 <printf>
    printf(0,"mask: %d\n",sigprocmask(100));
     610:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     617:	e8 d6 0c 00 00       	call   12f2 <sigprocmask>
     61c:	83 c4 0c             	add    $0xc,%esp
     61f:	50                   	push   %eax
     620:	68 bd 1e 00 00       	push   $0x1ebd
     625:	6a 00                	push   $0x0
     627:	e8 84 0d 00 00       	call   13b0 <printf>
    printf(0,"mask: %d\n",sigprocmask(0));
     62c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     633:	e8 ba 0c 00 00       	call   12f2 <sigprocmask>
     638:	83 c4 0c             	add    $0xc,%esp
     63b:	50                   	push   %eax
     63c:	68 bd 1e 00 00       	push   $0x1ebd
     641:	6a 00                	push   $0x0
     643:	e8 68 0d 00 00       	call   13b0 <printf>
    printf(0,"Start SigactionTetss\n");
     648:	58                   	pop    %eax
     649:	5a                   	pop    %edx
     64a:	68 c7 1e 00 00       	push   $0x1ec7
     64f:	6a 00                	push   $0x0
     651:	e8 5a 0d 00 00       	call   13b0 <printf>
    struct sigaction *FIrstSigAct = malloc(sizeof(struct sigaction));
     656:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     65d:	e8 ae 0f 00 00       	call   1610 <malloc>
    FIrstSigAct->sa_handler = (void (*)())14;
     662:	c7 00 0e 00 00 00    	movl   $0xe,(%eax)
    FIrstSigAct->sigmask=7;
     668:	c7 40 04 07 00 00 00 	movl   $0x7,0x4(%eax)
    struct sigaction *FIrstSigAct = malloc(sizeof(struct sigaction));
     66f:	89 c6                	mov    %eax,%esi
    printf(0,"Create SigAction1 with handler(int 14) and mask (int 7)\n");
     671:	59                   	pop    %ecx
     672:	5b                   	pop    %ebx
     673:	68 64 17 00 00       	push   $0x1764
     678:	6a 00                	push   $0x0
     67a:	e8 31 0d 00 00       	call   13b0 <printf>
    struct sigaction *SecondSigAct = malloc(sizeof(struct sigaction));
     67f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     686:	e8 85 0f 00 00       	call   1610 <malloc>
    SecondSigAct->sa_handler = (void (*)())22;
     68b:	c7 00 16 00 00 00    	movl   $0x16,(%eax)
    SecondSigAct->sigmask=8;
     691:	c7 40 04 08 00 00 00 	movl   $0x8,0x4(%eax)
    struct sigaction *SecondSigAct = malloc(sizeof(struct sigaction));
     698:	89 c7                	mov    %eax,%edi
    printf(0,"Create SigAction2 with handler(int 22) and mask (int 8)\n");
     69a:	58                   	pop    %eax
     69b:	5a                   	pop    %edx
     69c:	68 a0 17 00 00       	push   $0x17a0
     6a1:	6a 00                	push   $0x0
     6a3:	e8 08 0d 00 00       	call   13b0 <printf>
    printf(0,"Check SigAct1 handler number: %d\n",FIrstSigAct->sa_handler);
     6a8:	83 c4 0c             	add    $0xc,%esp
     6ab:	ff 36                	pushl  (%esi)
     6ad:	68 dc 17 00 00       	push   $0x17dc
     6b2:	6a 00                	push   $0x0
     6b4:	e8 f7 0c 00 00       	call   13b0 <printf>
    printf(0,"Performing First sigaction assign to signum 4 SigAction1\n");
     6b9:	59                   	pop    %ecx
     6ba:	5b                   	pop    %ebx
     6bb:	68 00 18 00 00       	push   $0x1800
     6c0:	6a 00                	push   $0x0
     6c2:	e8 e9 0c 00 00       	call   13b0 <printf>
    sigaction(4,FIrstSigAct,null);
     6c7:	83 c4 0c             	add    $0xc,%esp
     6ca:	6a 00                	push   $0x0
     6cc:	56                   	push   %esi
     6cd:	6a 04                	push   $0x4
     6cf:	e8 26 0c 00 00       	call   12fa <sigaction>
    struct sigaction *ThirdSigAct = malloc(sizeof(struct sigaction));
     6d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     6db:	e8 30 0f 00 00       	call   1610 <malloc>
     6e0:	89 c3                	mov    %eax,%ebx
    printf(0,"Creating SigAction3 to hold the old action hander\n");
     6e2:	58                   	pop    %eax
     6e3:	5a                   	pop    %edx
     6e4:	68 3c 18 00 00       	push   $0x183c
     6e9:	6a 00                	push   $0x0
     6eb:	e8 c0 0c 00 00       	call   13b0 <printf>
    sigaction(4, SecondSigAct, ThirdSigAct);
     6f0:	83 c4 0c             	add    $0xc,%esp
     6f3:	53                   	push   %ebx
     6f4:	57                   	push   %edi
     6f5:	6a 04                	push   $0x4
     6f7:	e8 fe 0b 00 00       	call   12fa <sigaction>
    printf(0,"Changed signum 4 to hold SigAction2 and Sigaction 3 will hold SigAction1\n");
     6fc:	59                   	pop    %ecx
     6fd:	58                   	pop    %eax
     6fe:	68 70 18 00 00       	push   $0x1870
     703:	6a 00                	push   $0x0
     705:	e8 a6 0c 00 00       	call   13b0 <printf>
    printf(0,"SigAction3 handler should be 14: %d\n",ThirdSigAct->sa_handler);
     70a:	83 c4 0c             	add    $0xc,%esp
     70d:	ff 33                	pushl  (%ebx)
     70f:	68 bc 18 00 00       	push   $0x18bc
     714:	6a 00                	push   $0x0
     716:	e8 95 0c 00 00       	call   13b0 <printf>
    printf(0,"SigAction3 mask should be 7: %d\n",ThirdSigAct->sigmask);
     71b:	83 c4 0c             	add    $0xc,%esp
     71e:	ff 73 04             	pushl  0x4(%ebx)
     721:	68 e4 18 00 00       	push   $0x18e4
     726:	6a 00                	push   $0x0
     728:	e8 83 0c 00 00       	call   13b0 <printf>
    sigaction(4,SecondSigAct,null);
     72d:	83 c4 0c             	add    $0xc,%esp
     730:	6a 00                	push   $0x0
     732:	57                   	push   %edi
     733:	6a 04                	push   $0x4
     735:	e8 c0 0b 00 00       	call   12fa <sigaction>
    printf(0,"SigAction3 handler should be 14: %d\n",ThirdSigAct->sa_handler);
     73a:	83 c4 0c             	add    $0xc,%esp
     73d:	ff 33                	pushl  (%ebx)
     73f:	68 bc 18 00 00       	push   $0x18bc
     744:	6a 00                	push   $0x0
     746:	e8 65 0c 00 00       	call   13b0 <printf>
    printf(0,"SigAction3 mask should be 7: %d\n",ThirdSigAct->sigmask);
     74b:	83 c4 0c             	add    $0xc,%esp
     74e:	ff 73 04             	pushl  0x4(%ebx)
     751:	68 e4 18 00 00       	push   $0x18e4
     756:	6a 00                	push   $0x0
     758:	e8 53 0c 00 00       	call   13b0 <printf>
    struct sigaction *ForthSigAct = malloc(sizeof(struct sigaction));
     75d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     764:	e8 a7 0e 00 00       	call   1610 <malloc>
     769:	89 c7                	mov    %eax,%edi
    ForthSigAct->sa_handler = (void (*)())28;
     76b:	c7 00 1c 00 00 00    	movl   $0x1c,(%eax)
    ForthSigAct->sigmask=4;
     771:	c7 40 04 04 00 00 00 	movl   $0x4,0x4(%eax)
    printf(0,"Create SigAction4 with handler(int 28) and mask (int 4)\n");
     778:	58                   	pop    %eax
     779:	5a                   	pop    %edx
     77a:	68 08 19 00 00       	push   $0x1908
     77f:	6a 00                	push   $0x0
     781:	e8 2a 0c 00 00       	call   13b0 <printf>
    sigaction(4, ForthSigAct, null);
     786:	83 c4 0c             	add    $0xc,%esp
     789:	6a 00                	push   $0x0
     78b:	57                   	push   %edi
     78c:	6a 04                	push   $0x4
     78e:	e8 67 0b 00 00       	call   12fa <sigaction>
    printf(0,"Changed signum 4 to hold SigAction4 and do not save old\n");
     793:	59                   	pop    %ecx
     794:	58                   	pop    %eax
     795:	68 44 19 00 00       	push   $0x1944
     79a:	6a 00                	push   $0x0
     79c:	e8 0f 0c 00 00       	call   13b0 <printf>
    sigaction(4, ForthSigAct, FIrstSigAct);
     7a1:	83 c4 0c             	add    $0xc,%esp
     7a4:	56                   	push   %esi
     7a5:	57                   	push   %edi
     7a6:	6a 04                	push   $0x4
     7a8:	e8 4d 0b 00 00       	call   12fa <sigaction>
    printf(0,"Changed signum 4 to hold SigAction4 and FirstSigact will hold the old (sig4)\n");
     7ad:	58                   	pop    %eax
     7ae:	5a                   	pop    %edx
     7af:	68 80 19 00 00       	push   $0x1980
     7b4:	6a 00                	push   $0x0
     7b6:	e8 f5 0b 00 00       	call   13b0 <printf>
    printf(0,"SigAction1 handler should be 28: %d\n",FIrstSigAct->sa_handler);
     7bb:	83 c4 0c             	add    $0xc,%esp
     7be:	ff 36                	pushl  (%esi)
     7c0:	68 d0 19 00 00       	push   $0x19d0
     7c5:	6a 00                	push   $0x0
     7c7:	e8 e4 0b 00 00       	call   13b0 <printf>
    printf(0,"SigAction1 mask should be 4: %d\n",FIrstSigAct->sigmask);
     7cc:	83 c4 0c             	add    $0xc,%esp
     7cf:	ff 76 04             	pushl  0x4(%esi)
     7d2:	68 f8 19 00 00       	push   $0x19f8
     7d7:	6a 00                	push   $0x0
     7d9:	e8 d2 0b 00 00       	call   13b0 <printf>
    printf(0,"Error Tests - Will check things that should not changed are working\n");
     7de:	59                   	pop    %ecx
     7df:	5e                   	pop    %esi
     7e0:	68 1c 1a 00 00       	push   $0x1a1c
     7e5:	6a 00                	push   $0x0
     7e7:	e8 c4 0b 00 00       	call   13b0 <printf>
    printf(0,"Try to Change signum kill\n");
     7ec:	58                   	pop    %eax
     7ed:	5a                   	pop    %edx
     7ee:	68 dd 1e 00 00       	push   $0x1edd
     7f3:	6a 00                	push   $0x0
     7f5:	e8 b6 0b 00 00       	call   13b0 <printf>
    sigaction(SIGKILL, ForthSigAct, ThirdSigAct);
     7fa:	83 c4 0c             	add    $0xc,%esp
     7fd:	53                   	push   %ebx
     7fe:	57                   	push   %edi
     7ff:	6a 09                	push   $0x9
     801:	e8 f4 0a 00 00       	call   12fa <sigaction>
    printf(0,"Try to Change signum 43 (do not exist\n");
     806:	59                   	pop    %ecx
     807:	5e                   	pop    %esi
     808:	68 64 1a 00 00       	push   $0x1a64
     80d:	6a 00                	push   $0x0
     80f:	e8 9c 0b 00 00       	call   13b0 <printf>
    sigaction(43, ForthSigAct, ThirdSigAct);
     814:	83 c4 0c             	add    $0xc,%esp
     817:	53                   	push   %ebx
     818:	57                   	push   %edi
     819:	6a 2b                	push   $0x2b
     81b:	e8 da 0a 00 00       	call   12fa <sigaction>
    printf(0,"SigAction3 handler should be 14: %d\n",ThirdSigAct->sa_handler);
     820:	83 c4 0c             	add    $0xc,%esp
     823:	ff 33                	pushl  (%ebx)
     825:	68 bc 18 00 00       	push   $0x18bc
     82a:	6a 00                	push   $0x0
     82c:	e8 7f 0b 00 00       	call   13b0 <printf>
    printf(0,"SigAction3 mask should be 7: %d\n",ThirdSigAct->sigmask);
     831:	83 c4 0c             	add    $0xc,%esp
     834:	ff 73 04             	pushl  0x4(%ebx)
     837:	68 e4 18 00 00       	push   $0x18e4
     83c:	6a 00                	push   $0x0
     83e:	e8 6d 0b 00 00       	call   13b0 <printf>
    printf(0,"Finished\n");
     843:	5f                   	pop    %edi
     844:	58                   	pop    %eax
     845:	68 f8 1e 00 00       	push   $0x1ef8
     84a:	6a 00                	push   $0x0
     84c:	e8 5f 0b 00 00       	call   13b0 <printf>
    return;
     851:	83 c4 10             	add    $0x10,%esp
}
     854:	8d 65 f4             	lea    -0xc(%ebp),%esp
     857:	5b                   	pop    %ebx
     858:	5e                   	pop    %esi
     859:	5f                   	pop    %edi
     85a:	5d                   	pop    %ebp
     85b:	c3                   	ret    
     85c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000860 <kill_self_test>:
{
     860:	55                   	push   %ebp
     861:	89 e5                	mov    %esp,%ebp
     863:	83 ec 08             	sub    $0x8,%esp
    kill(getpid(),SIGKILL);
     866:	e8 67 0a 00 00       	call   12d2 <getpid>
     86b:	83 ec 08             	sub    $0x8,%esp
     86e:	6a 09                	push   $0x9
     870:	50                   	push   %eax
     871:	e8 0c 0a 00 00       	call   1282 <kill>
}
     876:	31 c0                	xor    %eax,%eax
     878:	c9                   	leave  
     879:	c3                   	ret    
     87a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000880 <kill_other>:
{
     880:	55                   	push   %ebp
     881:	89 e5                	mov    %esp,%ebp
     883:	83 ec 10             	sub    $0x10,%esp
    kill(child_kill,signum);
     886:	ff 75 0c             	pushl  0xc(%ebp)
     889:	ff 75 08             	pushl  0x8(%ebp)
     88c:	e8 f1 09 00 00       	call   1282 <kill>
}
     891:	31 c0                	xor    %eax,%eax
     893:	c9                   	leave  
     894:	c3                   	ret    
     895:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008a0 <SignalTests1>:
{
     8a0:	55                   	push   %ebp
     8a1:	89 e5                	mov    %esp,%ebp
     8a3:	53                   	push   %ebx
     8a4:	83 ec 04             	sub    $0x4,%esp
    if((child_pid[0]=fork()) == 0)
     8a7:	e8 9e 09 00 00       	call   124a <fork>
     8ac:	85 c0                	test   %eax,%eax
     8ae:	0f 84 cb 00 00 00    	je     97f <SignalTests1+0xdf>
        if((child_pid[1]=fork()) == 0)
     8b4:	e8 91 09 00 00       	call   124a <fork>
     8b9:	85 c0                	test   %eax,%eax
     8bb:	89 c3                	mov    %eax,%ebx
     8bd:	75 7f                	jne    93e <SignalTests1+0x9e>
            struct sigaction *UserHandlerSignal = malloc(sizeof(struct sigaction));
     8bf:	83 ec 0c             	sub    $0xc,%esp
     8c2:	6a 08                	push   $0x8
     8c4:	e8 47 0d 00 00       	call   1610 <malloc>
            UserHandlerSignal->sa_handler = user_handler_signal;
     8c9:	c7 00 10 01 00 00    	movl   $0x110,(%eax)
            UserHandlerSignal->sigmask=0;
     8cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            struct sigaction *UserHandlerSignal = malloc(sizeof(struct sigaction));
     8d6:	89 c3                	mov    %eax,%ebx
            printf(0,"Created User Handler Signal with mask that is 0\n");
     8d8:	58                   	pop    %eax
     8d9:	5a                   	pop    %edx
     8da:	68 dc 1a 00 00       	push   $0x1adc
     8df:	6a 00                	push   $0x0
     8e1:	e8 ca 0a 00 00       	call   13b0 <printf>
            sigaction(22,UserHandlerSignal,null);
     8e6:	83 c4 0c             	add    $0xc,%esp
     8e9:	6a 00                	push   $0x0
     8eb:	53                   	push   %ebx
     8ec:	6a 16                	push   $0x16
     8ee:	e8 07 0a 00 00       	call   12fa <sigaction>
            printf(0,"Assigned User Handler Signal to signum 22\n");
     8f3:	59                   	pop    %ecx
     8f4:	5b                   	pop    %ebx
     8f5:	68 10 1b 00 00       	push   $0x1b10
     8fa:	6a 00                	push   $0x0
     8fc:	e8 af 0a 00 00       	call   13b0 <printf>
            printf(0,"Starting Loop\n");
     901:	58                   	pop    %eax
     902:	5a                   	pop    %edx
     903:	68 02 1f 00 00       	push   $0x1f02
     908:	6a 00                	push   $0x0
     90a:	e8 a1 0a 00 00       	call   13b0 <printf>
     90f:	83 c4 10             	add    $0x10,%esp
     912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                printf(0,"pid - %d child two\n",getpid());
     918:	e8 b5 09 00 00       	call   12d2 <getpid>
     91d:	83 ec 04             	sub    $0x4,%esp
     920:	50                   	push   %eax
     921:	68 11 1f 00 00       	push   $0x1f11
     926:	6a 00                	push   $0x0
     928:	e8 83 0a 00 00       	call   13b0 <printf>
                sleep(50);
     92d:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     934:	e8 a9 09 00 00       	call   12e2 <sleep>
     939:	83 c4 10             	add    $0x10,%esp
     93c:	eb da                	jmp    918 <SignalTests1+0x78>
            if((child_pid[2]=fork()) == 0)
     93e:	e8 07 09 00 00       	call   124a <fork>
     943:	85 c0                	test   %eax,%eax
     945:	0f 84 a6 00 00 00    	je     9f1 <SignalTests1+0x151>
                if((child_pid[3]=fork()) == 0)
     94b:	e8 fa 08 00 00       	call   124a <fork>
     950:	85 c0                	test   %eax,%eax
     952:	74 67                	je     9bb <SignalTests1+0x11b>
    wait();
     954:	e8 01 09 00 00       	call   125a <wait>
    wait();
     959:	e8 fc 08 00 00       	call   125a <wait>
    wait();
     95e:	e8 f7 08 00 00       	call   125a <wait>
    wait();
     963:	e8 f2 08 00 00       	call   125a <wait>
    printf(0,"parent\n");
     968:	83 ec 08             	sub    $0x8,%esp
     96b:	68 42 1f 00 00       	push   $0x1f42
     970:	6a 00                	push   $0x0
     972:	e8 39 0a 00 00       	call   13b0 <printf>
    return;
     977:	83 c4 10             	add    $0x10,%esp
}
     97a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     97d:	c9                   	leave  
     97e:	c3                   	ret    
        printf(0,"Trying to self kill the process\n");
     97f:	51                   	push   %ecx
     980:	51                   	push   %ecx
     981:	68 8c 1a 00 00       	push   $0x1a8c
     986:	6a 00                	push   $0x0
     988:	e8 23 0a 00 00       	call   13b0 <printf>
    kill(getpid(),SIGKILL);
     98d:	e8 40 09 00 00       	call   12d2 <getpid>
     992:	5b                   	pop    %ebx
     993:	5a                   	pop    %edx
     994:	6a 09                	push   $0x9
     996:	50                   	push   %eax
     997:	e8 e6 08 00 00       	call   1282 <kill>
        sleep(50);
     99c:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     9a3:	e8 3a 09 00 00       	call   12e2 <sleep>
        printf(0,"Process 1 Should have benn Killed Already!\n");
     9a8:	59                   	pop    %ecx
     9a9:	5b                   	pop    %ebx
     9aa:	68 b0 1a 00 00       	push   $0x1ab0
     9af:	6a 00                	push   $0x0
     9b1:	e8 fa 09 00 00       	call   13b0 <printf>
        exit();
     9b6:	e8 97 08 00 00       	call   1252 <exit>
                    sleep(250);
     9bb:	83 ec 0c             	sub    $0xc,%esp
     9be:	68 fa 00 00 00       	push   $0xfa
     9c3:	e8 1a 09 00 00       	call   12e2 <sleep>
                    printf(0,"signal kill to second child\n");
     9c8:	58                   	pop    %eax
     9c9:	5a                   	pop    %edx
     9ca:	68 25 1f 00 00       	push   $0x1f25
     9cf:	6a 00                	push   $0x0
     9d1:	e8 da 09 00 00       	call   13b0 <printf>
                    kill(child_pid[1],SIGKILL);
     9d6:	59                   	pop    %ecx
     9d7:	58                   	pop    %eax
     9d8:	6a 09                	push   $0x9
     9da:	53                   	push   %ebx
     9db:	e8 a2 08 00 00       	call   1282 <kill>
                    sleep(100);
     9e0:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     9e7:	e8 f6 08 00 00       	call   12e2 <sleep>
                    exit();
     9ec:	e8 61 08 00 00       	call   1252 <exit>
                sleep(150);
     9f1:	83 ec 0c             	sub    $0xc,%esp
     9f4:	68 96 00 00 00       	push   $0x96
     9f9:	e8 e4 08 00 00       	call   12e2 <sleep>
                printf(0,"Run User Handler Signal Second Child\n");
     9fe:	58                   	pop    %eax
     9ff:	5a                   	pop    %edx
     a00:	68 3c 1b 00 00       	push   $0x1b3c
     a05:	6a 00                	push   $0x0
     a07:	e8 a4 09 00 00       	call   13b0 <printf>
    kill(child_kill,signum);
     a0c:	59                   	pop    %ecx
     a0d:	58                   	pop    %eax
     a0e:	6a 16                	push   $0x16
     a10:	53                   	push   %ebx
     a11:	e8 6c 08 00 00       	call   1282 <kill>
                sleep(450);
     a16:	c7 04 24 c2 01 00 00 	movl   $0x1c2,(%esp)
     a1d:	e8 c0 08 00 00       	call   12e2 <sleep>
                exit();
     a22:	e8 2b 08 00 00       	call   1252 <exit>
     a27:	89 f6                	mov    %esi,%esi
     a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a30 <SignalTests2>:
{
     a30:	55                   	push   %ebp
     a31:	89 e5                	mov    %esp,%ebp
     a33:	53                   	push   %ebx
     a34:	83 ec 04             	sub    $0x4,%esp
    if((child_pid[0]=fork()) == 0)
     a37:	e8 0e 08 00 00       	call   124a <fork>
     a3c:	85 c0                	test   %eax,%eax
     a3e:	75 54                	jne    a94 <SignalTests2+0x64>
        printf(0,"Trying to self kill the process even while Mask is Blocking\n");
     a40:	83 ec 08             	sub    $0x8,%esp
     a43:	68 64 1b 00 00       	push   $0x1b64
     a48:	6a 00                	push   $0x0
     a4a:	e8 61 09 00 00       	call   13b0 <printf>
        sigprocmask(896);
     a4f:	c7 04 24 80 03 00 00 	movl   $0x380,(%esp)
     a56:	e8 97 08 00 00       	call   12f2 <sigprocmask>
    kill(getpid(),SIGKILL);
     a5b:	e8 72 08 00 00       	call   12d2 <getpid>
     a60:	59                   	pop    %ecx
     a61:	5b                   	pop    %ebx
     a62:	6a 09                	push   $0x9
     a64:	50                   	push   %eax
     a65:	e8 18 08 00 00       	call   1282 <kill>
        sleep(250);
     a6a:	c7 04 24 fa 00 00 00 	movl   $0xfa,(%esp)
     a71:	e8 6c 08 00 00       	call   12e2 <sleep>
     a76:	83 c4 10             	add    $0x10,%esp
     a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(0,"Process 1 Should have benn Killed Alreadyyyyy!\n");
     a80:	83 ec 08             	sub    $0x8,%esp
     a83:	68 a4 1b 00 00       	push   $0x1ba4
     a88:	6a 00                	push   $0x0
     a8a:	e8 21 09 00 00       	call   13b0 <printf>
     a8f:	83 c4 10             	add    $0x10,%esp
     a92:	eb ec                	jmp    a80 <SignalTests2+0x50>
        if((child_pid[1]=fork()) == 0)
     a94:	e8 b1 07 00 00       	call   124a <fork>
     a99:	85 c0                	test   %eax,%eax
     a9b:	89 c3                	mov    %eax,%ebx
     a9d:	75 7f                	jne    b1e <SignalTests2+0xee>
            printf(0,"Trying to Ignore All\n");
     a9f:	51                   	push   %ecx
     aa0:	51                   	push   %ecx
     aa1:	68 4a 1f 00 00       	push   $0x1f4a
     aa6:	6a 00                	push   $0x0
     aa8:	e8 03 09 00 00       	call   13b0 <printf>
            sigprocmask(4294967295);
     aad:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
     ab4:	e8 39 08 00 00       	call   12f2 <sigprocmask>
            struct sigaction *SigAction1 = malloc(sizeof(struct sigaction));
     ab9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     ac0:	e8 4b 0b 00 00       	call   1610 <malloc>
            SigAction1->sa_handler = (void (*)())SIGKILL;
     ac5:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
            SigAction1->sigmask=4294967295;
     acb:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
            struct sigaction *SigAction1 = malloc(sizeof(struct sigaction));
     ad2:	89 c3                	mov    %eax,%ebx
            printf(0,"Creating sinum 4 handler is SIGKILL and mask is Ignore ALl\n");
     ad4:	58                   	pop    %eax
     ad5:	5a                   	pop    %edx
     ad6:	68 d4 1b 00 00       	push   $0x1bd4
     adb:	6a 00                	push   $0x0
     add:	e8 ce 08 00 00       	call   13b0 <printf>
            sigaction(4,SigAction1,null);
     ae2:	83 c4 0c             	add    $0xc,%esp
     ae5:	6a 00                	push   $0x0
     ae7:	53                   	push   %ebx
     ae8:	6a 04                	push   $0x4
     aea:	e8 0b 08 00 00       	call   12fa <sigaction>
     aef:	83 c4 10             	add    $0x10,%esp
     af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                printf(0,"pid - %d child two\n",getpid());
     af8:	e8 d5 07 00 00       	call   12d2 <getpid>
     afd:	83 ec 04             	sub    $0x4,%esp
     b00:	50                   	push   %eax
     b01:	68 11 1f 00 00       	push   $0x1f11
     b06:	6a 00                	push   $0x0
     b08:	e8 a3 08 00 00       	call   13b0 <printf>
                sleep(50);
     b0d:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     b14:	e8 c9 07 00 00       	call   12e2 <sleep>
     b19:	83 c4 10             	add    $0x10,%esp
     b1c:	eb da                	jmp    af8 <SignalTests2+0xc8>
            if((child_pid[2]=fork()) == 0)
     b1e:	e8 27 07 00 00       	call   124a <fork>
     b23:	85 c0                	test   %eax,%eax
     b25:	74 33                	je     b5a <SignalTests2+0x12a>
                if((child_pid[3]=fork()) == 0)
     b27:	e8 1e 07 00 00       	call   124a <fork>
     b2c:	85 c0                	test   %eax,%eax
     b2e:	74 60                	je     b90 <SignalTests2+0x160>
    wait();
     b30:	e8 25 07 00 00       	call   125a <wait>
    wait();
     b35:	e8 20 07 00 00       	call   125a <wait>
    wait();
     b3a:	e8 1b 07 00 00       	call   125a <wait>
    wait();
     b3f:	e8 16 07 00 00       	call   125a <wait>
    printf(0,"parent\n");
     b44:	50                   	push   %eax
     b45:	50                   	push   %eax
     b46:	68 42 1f 00 00       	push   $0x1f42
     b4b:	6a 00                	push   $0x0
     b4d:	e8 5e 08 00 00       	call   13b0 <printf>
    return;
     b52:	83 c4 10             	add    $0x10,%esp
}
     b55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b58:	c9                   	leave  
     b59:	c3                   	ret    
                sleep(250);
     b5a:	83 ec 0c             	sub    $0xc,%esp
     b5d:	68 fa 00 00 00       	push   $0xfa
     b62:	e8 7b 07 00 00       	call   12e2 <sleep>
    kill(child_kill,signum);
     b67:	59                   	pop    %ecx
     b68:	58                   	pop    %eax
     b69:	6a 04                	push   $0x4
     b6b:	53                   	push   %ebx
     b6c:	e8 11 07 00 00       	call   1282 <kill>
                printf(0,"Should Ignore Signla 4\n");
     b71:	58                   	pop    %eax
     b72:	5a                   	pop    %edx
     b73:	68 60 1f 00 00       	push   $0x1f60
     b78:	6a 00                	push   $0x0
     b7a:	e8 31 08 00 00       	call   13b0 <printf>
                sleep(550);
     b7f:	c7 04 24 26 02 00 00 	movl   $0x226,(%esp)
     b86:	e8 57 07 00 00       	call   12e2 <sleep>
                exit();
     b8b:	e8 c2 06 00 00       	call   1252 <exit>
                    sleep(480);
     b90:	83 ec 0c             	sub    $0xc,%esp
     b93:	68 e0 01 00 00       	push   $0x1e0
     b98:	e8 45 07 00 00       	call   12e2 <sleep>
                    printf(0,"signal kill\n");
     b9d:	5a                   	pop    %edx
     b9e:	59                   	pop    %ecx
     b9f:	68 78 1f 00 00       	push   $0x1f78
     ba4:	6a 00                	push   $0x0
     ba6:	e8 05 08 00 00       	call   13b0 <printf>
                    kill(child_pid[1],SIGKILL);
     bab:	58                   	pop    %eax
     bac:	5a                   	pop    %edx
     bad:	6a 09                	push   $0x9
     baf:	53                   	push   %ebx
     bb0:	e8 cd 06 00 00       	call   1282 <kill>
                    sleep(100);
     bb5:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     bbc:	e8 21 07 00 00       	call   12e2 <sleep>
                    exit();
     bc1:	e8 8c 06 00 00       	call   1252 <exit>
     bc6:	8d 76 00             	lea    0x0(%esi),%esi
     bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000bd0 <SignalTests3>:
{
     bd0:	55                   	push   %ebp
     bd1:	89 e5                	mov    %esp,%ebp
     bd3:	53                   	push   %ebx
     bd4:	83 ec 04             	sub    $0x4,%esp
    if((child_pid[0]=fork()) == 0)
     bd7:	e8 6e 06 00 00       	call   124a <fork>
     bdc:	85 c0                	test   %eax,%eax
     bde:	0f 85 84 00 00 00    	jne    c68 <SignalTests3+0x98>
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
     be4:	83 ec 0c             	sub    $0xc,%esp
     be7:	6a 08                	push   $0x8
     be9:	e8 22 0a 00 00       	call   1610 <malloc>
        KillHAndlerSignal->sa_handler = (void (*)())SIGKILL;
     bee:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
        KillHAndlerSignal->sigmask = 0;
     bf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
     bfb:	89 c3                	mov    %eax,%ebx
        printf(0,"Created KillHAndlerSignal (KILL) with mask that is 0\n");
     bfd:	58                   	pop    %eax
     bfe:	5a                   	pop    %edx
     bff:	68 10 1c 00 00       	push   $0x1c10
     c04:	6a 00                	push   $0x0
     c06:	e8 a5 07 00 00       	call   13b0 <printf>
        sigaction(4,KillHAndlerSignal,null);
     c0b:	83 c4 0c             	add    $0xc,%esp
     c0e:	6a 00                	push   $0x0
     c10:	53                   	push   %ebx
     c11:	6a 04                	push   $0x4
     c13:	e8 e2 06 00 00       	call   12fa <sigaction>
        printf(0,"Sending KillHAndlerSignal (22)to process\n");
     c18:	59                   	pop    %ecx
     c19:	5b                   	pop    %ebx
     c1a:	68 48 1c 00 00       	push   $0x1c48
     c1f:	6a 00                	push   $0x0
     c21:	e8 8a 07 00 00       	call   13b0 <printf>
        kill_self_test(4);
     c26:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     c2d:	e8 2e fc ff ff       	call   860 <kill_self_test>
        sleep(1250);
     c32:	c7 04 24 e2 04 00 00 	movl   $0x4e2,(%esp)
     c39:	e8 a4 06 00 00       	call   12e2 <sleep>
     c3e:	83 c4 10             	add    $0x10,%esp
     c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(0,"Process 1 should have been killed already!\n");
     c48:	83 ec 08             	sub    $0x8,%esp
     c4b:	68 74 1c 00 00       	push   $0x1c74
     c50:	6a 00                	push   $0x0
     c52:	e8 59 07 00 00       	call   13b0 <printf>
            sleep(100);
     c57:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     c5e:	e8 7f 06 00 00       	call   12e2 <sleep>
     c63:	83 c4 10             	add    $0x10,%esp
     c66:	eb e0                	jmp    c48 <SignalTests3+0x78>
        if((child_pid[1]=fork()) == 0)
     c68:	e8 dd 05 00 00       	call   124a <fork>
     c6d:	85 c0                	test   %eax,%eax
     c6f:	89 c3                	mov    %eax,%ebx
     c71:	75 3b                	jne    cae <SignalTests3+0xde>
            printf(0,"Starting Loop\n");
     c73:	51                   	push   %ecx
     c74:	51                   	push   %ecx
     c75:	68 02 1f 00 00       	push   $0x1f02
     c7a:	6a 00                	push   $0x0
     c7c:	e8 2f 07 00 00       	call   13b0 <printf>
     c81:	83 c4 10             	add    $0x10,%esp
     c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                printf(0,"pid - %d child two\n",getpid());
     c88:	e8 45 06 00 00       	call   12d2 <getpid>
     c8d:	83 ec 04             	sub    $0x4,%esp
     c90:	50                   	push   %eax
     c91:	68 11 1f 00 00       	push   $0x1f11
     c96:	6a 00                	push   $0x0
     c98:	e8 13 07 00 00       	call   13b0 <printf>
                sleep(50);
     c9d:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     ca4:	e8 39 06 00 00       	call   12e2 <sleep>
     ca9:	83 c4 10             	add    $0x10,%esp
     cac:	eb da                	jmp    c88 <SignalTests3+0xb8>
            if((child_pid[2]=fork()) == 0)
     cae:	e8 97 05 00 00       	call   124a <fork>
     cb3:	85 c0                	test   %eax,%eax
     cb5:	74 37                	je     cee <SignalTests3+0x11e>
                if((child_pid[3]=fork()) == 0)
     cb7:	e8 8e 05 00 00       	call   124a <fork>
     cbc:	85 c0                	test   %eax,%eax
     cbe:	0f 84 3a 01 00 00    	je     dfe <SignalTests3+0x22e>
    wait();
     cc4:	e8 91 05 00 00       	call   125a <wait>
    wait();
     cc9:	e8 8c 05 00 00       	call   125a <wait>
    wait();
     cce:	e8 87 05 00 00       	call   125a <wait>
    wait();
     cd3:	e8 82 05 00 00       	call   125a <wait>
    printf(0,"parent\n");
     cd8:	50                   	push   %eax
     cd9:	50                   	push   %eax
     cda:	68 42 1f 00 00       	push   $0x1f42
     cdf:	6a 00                	push   $0x0
     ce1:	e8 ca 06 00 00       	call   13b0 <printf>
    return;
     ce6:	83 c4 10             	add    $0x10,%esp
}
     ce9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     cec:	c9                   	leave  
     ced:	c3                   	ret    
                printf(0, "child 3 pid: %d\n", getpid());
     cee:	e8 df 05 00 00       	call   12d2 <getpid>
     cf3:	52                   	push   %edx
     cf4:	50                   	push   %eax
     cf5:	68 85 1f 00 00       	push   $0x1f85
     cfa:	6a 00                	push   $0x0
     cfc:	e8 af 06 00 00       	call   13b0 <printf>
                sleep(30);
     d01:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
     d08:	e8 d5 05 00 00       	call   12e2 <sleep>
                printf(0,"Run SigSTOP Second Child\n");
     d0d:	59                   	pop    %ecx
     d0e:	58                   	pop    %eax
     d0f:	68 96 1f 00 00       	push   $0x1f96
     d14:	6a 00                	push   $0x0
     d16:	e8 95 06 00 00       	call   13b0 <printf>
    kill(child_kill,signum);
     d1b:	58                   	pop    %eax
     d1c:	5a                   	pop    %edx
     d1d:	6a 11                	push   $0x11
     d1f:	53                   	push   %ebx
     d20:	e8 5d 05 00 00       	call   1282 <kill>
                printf(0, "@@@@@1\n");
     d25:	59                   	pop    %ecx
     d26:	58                   	pop    %eax
     d27:	68 b0 1f 00 00       	push   $0x1fb0
     d2c:	6a 00                	push   $0x0
     d2e:	e8 7d 06 00 00       	call   13b0 <printf>
                sleep(20);
     d33:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     d3a:	e8 a3 05 00 00       	call   12e2 <sleep>
                printf(0, "@@@@@2\n");
     d3f:	58                   	pop    %eax
     d40:	5a                   	pop    %edx
     d41:	68 b8 1f 00 00       	push   $0x1fb8
     d46:	6a 00                	push   $0x0
     d48:	e8 63 06 00 00       	call   13b0 <printf>
                printf(0,"Send SIGCONT child two\n");
     d4d:	59                   	pop    %ecx
     d4e:	58                   	pop    %eax
     d4f:	68 c0 1f 00 00       	push   $0x1fc0
     d54:	6a 00                	push   $0x0
     d56:	e8 55 06 00 00       	call   13b0 <printf>
    kill(child_kill,signum);
     d5b:	58                   	pop    %eax
     d5c:	5a                   	pop    %edx
     d5d:	6a 13                	push   $0x13
     d5f:	53                   	push   %ebx
     d60:	e8 1d 05 00 00       	call   1282 <kill>
                sleep(20);
     d65:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     d6c:	e8 71 05 00 00       	call   12e2 <sleep>
                printf(0,"Send SIGSTOP child2 AGAIN\n");
     d71:	59                   	pop    %ecx
     d72:	58                   	pop    %eax
     d73:	68 d8 1f 00 00       	push   $0x1fd8
     d78:	6a 00                	push   $0x0
     d7a:	e8 31 06 00 00       	call   13b0 <printf>
    kill(child_kill,signum);
     d7f:	58                   	pop    %eax
     d80:	5a                   	pop    %edx
     d81:	6a 11                	push   $0x11
     d83:	53                   	push   %ebx
     d84:	e8 f9 04 00 00       	call   1282 <kill>
                printf(0, "@@@@@1\n");
     d89:	59                   	pop    %ecx
     d8a:	58                   	pop    %eax
     d8b:	68 b0 1f 00 00       	push   $0x1fb0
     d90:	6a 00                	push   $0x0
     d92:	e8 19 06 00 00       	call   13b0 <printf>
                sleep(20);
     d97:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
     d9e:	e8 3f 05 00 00       	call   12e2 <sleep>
                printf(0, "@@@@@2\n");
     da3:	58                   	pop    %eax
     da4:	5a                   	pop    %edx
     da5:	68 b8 1f 00 00       	push   $0x1fb8
     daa:	6a 00                	push   $0x0
     dac:	e8 ff 05 00 00       	call   13b0 <printf>
                printf(0,"Send SIGKILL to child2\n");
     db1:	59                   	pop    %ecx
     db2:	58                   	pop    %eax
     db3:	68 f3 1f 00 00       	push   $0x1ff3
     db8:	6a 00                	push   $0x0
     dba:	e8 f1 05 00 00       	call   13b0 <printf>
    kill(child_kill,signum);
     dbf:	58                   	pop    %eax
     dc0:	5a                   	pop    %edx
     dc1:	6a 09                	push   $0x9
     dc3:	53                   	push   %ebx
     dc4:	e8 b9 04 00 00       	call   1282 <kill>
                sleep(30);
     dc9:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
     dd0:	e8 0d 05 00 00       	call   12e2 <sleep>
                printf(0,"Send SIGCONT to child2\n");
     dd5:	59                   	pop    %ecx
     dd6:	58                   	pop    %eax
     dd7:	68 0b 20 00 00       	push   $0x200b
     ddc:	6a 00                	push   $0x0
     dde:	e8 cd 05 00 00       	call   13b0 <printf>
    kill(child_kill,signum);
     de3:	58                   	pop    %eax
     de4:	5a                   	pop    %edx
     de5:	6a 13                	push   $0x13
     de7:	53                   	push   %ebx
     de8:	e8 95 04 00 00       	call   1282 <kill>
                sleep(30);
     ded:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
     df4:	e8 e9 04 00 00       	call   12e2 <sleep>
                exit();
     df9:	e8 54 04 00 00       	call   1252 <exit>
                    exit();
     dfe:	e8 4f 04 00 00       	call   1252 <exit>
     e03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000e10 <sleepTest>:
void sleepTest() {
     e10:	55                   	push   %ebp
     e11:	89 e5                	mov    %esp,%ebp
     e13:	53                   	push   %ebx
     e14:	83 ec 04             	sub    $0x4,%esp
    if((child_pid[0]=fork()) == 0)
     e17:	e8 2e 04 00 00       	call   124a <fork>
     e1c:	85 c0                	test   %eax,%eax
     e1e:	0f 85 84 00 00 00    	jne    ea8 <sleepTest+0x98>
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
     e24:	83 ec 0c             	sub    $0xc,%esp
     e27:	6a 08                	push   $0x8
     e29:	e8 e2 07 00 00       	call   1610 <malloc>
        KillHAndlerSignal->sa_handler = (void (*)())SIGKILL;
     e2e:	c7 00 09 00 00 00    	movl   $0x9,(%eax)
        KillHAndlerSignal->sigmask = 0;
     e34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        struct sigaction *KillHAndlerSignal = malloc(sizeof(struct sigaction));
     e3b:	89 c3                	mov    %eax,%ebx
        printf(0,"Created KillHAndlerSignal (KILL) with mask that is 0\n");
     e3d:	58                   	pop    %eax
     e3e:	5a                   	pop    %edx
     e3f:	68 10 1c 00 00       	push   $0x1c10
     e44:	6a 00                	push   $0x0
     e46:	e8 65 05 00 00       	call   13b0 <printf>
        sigaction(4,KillHAndlerSignal,null);
     e4b:	83 c4 0c             	add    $0xc,%esp
     e4e:	6a 00                	push   $0x0
     e50:	53                   	push   %ebx
     e51:	6a 04                	push   $0x4
     e53:	e8 a2 04 00 00       	call   12fa <sigaction>
        printf(0,"Sending KillHAndlerSignal (22)to process\n");
     e58:	59                   	pop    %ecx
     e59:	5b                   	pop    %ebx
     e5a:	68 48 1c 00 00       	push   $0x1c48
     e5f:	6a 00                	push   $0x0
     e61:	e8 4a 05 00 00       	call   13b0 <printf>
        kill_self_test(4);
     e66:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     e6d:	e8 ee f9 ff ff       	call   860 <kill_self_test>
        sleep(1250);
     e72:	c7 04 24 e2 04 00 00 	movl   $0x4e2,(%esp)
     e79:	e8 64 04 00 00       	call   12e2 <sleep>
     e7e:	83 c4 10             	add    $0x10,%esp
     e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            printf(0,"Process 1 should have been killed already!\n");
     e88:	83 ec 08             	sub    $0x8,%esp
     e8b:	68 74 1c 00 00       	push   $0x1c74
     e90:	6a 00                	push   $0x0
     e92:	e8 19 05 00 00       	call   13b0 <printf>
            sleep(100);
     e97:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
     e9e:	e8 3f 04 00 00       	call   12e2 <sleep>
     ea3:	83 c4 10             	add    $0x10,%esp
     ea6:	eb e0                	jmp    e88 <sleepTest+0x78>
        if((child_pid[1]=fork()) == 0)
     ea8:	e8 9d 03 00 00       	call   124a <fork>
     ead:	85 c0                	test   %eax,%eax
     eaf:	75 3d                	jne    eee <sleepTest+0xde>
            printf(0,"Starting Loop\n");
     eb1:	51                   	push   %ecx
     eb2:	51                   	push   %ecx
     eb3:	68 02 1f 00 00       	push   $0x1f02
     eb8:	6a 00                	push   $0x0
     eba:	e8 f1 04 00 00       	call   13b0 <printf>
     ebf:	83 c4 10             	add    $0x10,%esp
     ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                printf(0,"pid - %d child two\n",getpid());
     ec8:	e8 05 04 00 00       	call   12d2 <getpid>
     ecd:	83 ec 04             	sub    $0x4,%esp
     ed0:	50                   	push   %eax
     ed1:	68 11 1f 00 00       	push   $0x1f11
     ed6:	6a 00                	push   $0x0
     ed8:	e8 d3 04 00 00       	call   13b0 <printf>
                sleep(50);
     edd:	c7 04 24 32 00 00 00 	movl   $0x32,(%esp)
     ee4:	e8 f9 03 00 00       	call   12e2 <sleep>
     ee9:	83 c4 10             	add    $0x10,%esp
     eec:	eb da                	jmp    ec8 <sleepTest+0xb8>
            if((child_pid[2]=fork()) == 0)
     eee:	e8 57 03 00 00       	call   124a <fork>
     ef3:	85 c0                	test   %eax,%eax
     ef5:	74 37                	je     f2e <sleepTest+0x11e>
                if((child_pid[3]=fork()) == 0)
     ef7:	e8 4e 03 00 00       	call   124a <fork>
     efc:	85 c0                	test   %eax,%eax
     efe:	0f 84 f6 00 00 00    	je     ffa <sleepTest+0x1ea>
    wait();
     f04:	e8 51 03 00 00       	call   125a <wait>
    wait();
     f09:	e8 4c 03 00 00       	call   125a <wait>
    wait();
     f0e:	e8 47 03 00 00       	call   125a <wait>
    wait();
     f13:	e8 42 03 00 00       	call   125a <wait>
    printf(0,"parent\n");
     f18:	50                   	push   %eax
     f19:	50                   	push   %eax
     f1a:	68 42 1f 00 00       	push   $0x1f42
     f1f:	6a 00                	push   $0x0
     f21:	e8 8a 04 00 00       	call   13b0 <printf>
    return;
     f26:	83 c4 10             	add    $0x10,%esp
}
     f29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     f2c:	c9                   	leave  
     f2d:	c3                   	ret    
                sleep(250);
     f2e:	83 ec 0c             	sub    $0xc,%esp
     f31:	68 fa 00 00 00       	push   $0xfa
     f36:	e8 a7 03 00 00       	call   12e2 <sleep>
                printf(0,"Run SigSTOP Second Child\n");
     f3b:	5a                   	pop    %edx
     f3c:	59                   	pop    %ecx
     f3d:	68 96 1f 00 00       	push   $0x1f96
     f42:	6a 00                	push   $0x0
     f44:	e8 67 04 00 00       	call   13b0 <printf>
                printf(0, "@@@@@1\n");
     f49:	5b                   	pop    %ebx
     f4a:	58                   	pop    %eax
     f4b:	68 b0 1f 00 00       	push   $0x1fb0
     f50:	6a 00                	push   $0x0
     f52:	e8 59 04 00 00       	call   13b0 <printf>
                sleep(200);
     f57:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
     f5e:	e8 7f 03 00 00       	call   12e2 <sleep>
                printf(0, "@@@@@2\n");
     f63:	58                   	pop    %eax
     f64:	5a                   	pop    %edx
     f65:	68 b8 1f 00 00       	push   $0x1fb8
     f6a:	6a 00                	push   $0x0
     f6c:	e8 3f 04 00 00       	call   13b0 <printf>
                printf(0,"Send SIGCONT child two\n");
     f71:	59                   	pop    %ecx
     f72:	5b                   	pop    %ebx
     f73:	68 c0 1f 00 00       	push   $0x1fc0
     f78:	6a 00                	push   $0x0
     f7a:	e8 31 04 00 00       	call   13b0 <printf>
                sleep(200);
     f7f:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
     f86:	e8 57 03 00 00       	call   12e2 <sleep>
                printf(0,"Send SIGSTOP child2 AGAIN\n");
     f8b:	58                   	pop    %eax
     f8c:	5a                   	pop    %edx
     f8d:	68 d8 1f 00 00       	push   $0x1fd8
     f92:	6a 00                	push   $0x0
     f94:	e8 17 04 00 00       	call   13b0 <printf>
                printf(0, "@@@@@1\n");
     f99:	59                   	pop    %ecx
     f9a:	5b                   	pop    %ebx
     f9b:	68 b0 1f 00 00       	push   $0x1fb0
     fa0:	6a 00                	push   $0x0
     fa2:	e8 09 04 00 00       	call   13b0 <printf>
                sleep(200);
     fa7:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
     fae:	e8 2f 03 00 00       	call   12e2 <sleep>
                printf(0, "@@@@@2\n");
     fb3:	58                   	pop    %eax
     fb4:	5a                   	pop    %edx
     fb5:	68 b8 1f 00 00       	push   $0x1fb8
     fba:	6a 00                	push   $0x0
     fbc:	e8 ef 03 00 00       	call   13b0 <printf>
                printf(0,"Send SIGKILL to child2\n");
     fc1:	59                   	pop    %ecx
     fc2:	5b                   	pop    %ebx
     fc3:	68 f3 1f 00 00       	push   $0x1ff3
     fc8:	6a 00                	push   $0x0
     fca:	e8 e1 03 00 00       	call   13b0 <printf>
                sleep(400);
     fcf:	c7 04 24 90 01 00 00 	movl   $0x190,(%esp)
     fd6:	e8 07 03 00 00       	call   12e2 <sleep>
                printf(0,"Send SIGCONT to child2\n");
     fdb:	58                   	pop    %eax
     fdc:	5a                   	pop    %edx
     fdd:	68 0b 20 00 00       	push   $0x200b
     fe2:	6a 00                	push   $0x0
     fe4:	e8 c7 03 00 00       	call   13b0 <printf>
                sleep(450);
     fe9:	c7 04 24 c2 01 00 00 	movl   $0x1c2,(%esp)
     ff0:	e8 ed 02 00 00       	call   12e2 <sleep>
                exit();
     ff5:	e8 58 02 00 00       	call   1252 <exit>
                    exit();
     ffa:	e8 53 02 00 00       	call   1252 <exit>
     fff:	90                   	nop

00001000 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	53                   	push   %ebx
    1004:	8b 45 08             	mov    0x8(%ebp),%eax
    1007:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    100a:	89 c2                	mov    %eax,%edx
    100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1010:	83 c1 01             	add    $0x1,%ecx
    1013:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    1017:	83 c2 01             	add    $0x1,%edx
    101a:	84 db                	test   %bl,%bl
    101c:	88 5a ff             	mov    %bl,-0x1(%edx)
    101f:	75 ef                	jne    1010 <strcpy+0x10>
    ;
  return os;
}
    1021:	5b                   	pop    %ebx
    1022:	5d                   	pop    %ebp
    1023:	c3                   	ret    
    1024:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    102a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001030 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1030:	55                   	push   %ebp
    1031:	89 e5                	mov    %esp,%ebp
    1033:	53                   	push   %ebx
    1034:	8b 55 08             	mov    0x8(%ebp),%edx
    1037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    103a:	0f b6 02             	movzbl (%edx),%eax
    103d:	0f b6 19             	movzbl (%ecx),%ebx
    1040:	84 c0                	test   %al,%al
    1042:	75 1c                	jne    1060 <strcmp+0x30>
    1044:	eb 2a                	jmp    1070 <strcmp+0x40>
    1046:	8d 76 00             	lea    0x0(%esi),%esi
    1049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
    1050:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    1053:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    1056:	83 c1 01             	add    $0x1,%ecx
    1059:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
    105c:	84 c0                	test   %al,%al
    105e:	74 10                	je     1070 <strcmp+0x40>
    1060:	38 d8                	cmp    %bl,%al
    1062:	74 ec                	je     1050 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    1064:	29 d8                	sub    %ebx,%eax
}
    1066:	5b                   	pop    %ebx
    1067:	5d                   	pop    %ebp
    1068:	c3                   	ret    
    1069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1070:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    1072:	29 d8                	sub    %ebx,%eax
}
    1074:	5b                   	pop    %ebx
    1075:	5d                   	pop    %ebp
    1076:	c3                   	ret    
    1077:	89 f6                	mov    %esi,%esi
    1079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001080 <strlen>:

uint
strlen(const char *s)
{
    1080:	55                   	push   %ebp
    1081:	89 e5                	mov    %esp,%ebp
    1083:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1086:	80 39 00             	cmpb   $0x0,(%ecx)
    1089:	74 15                	je     10a0 <strlen+0x20>
    108b:	31 d2                	xor    %edx,%edx
    108d:	8d 76 00             	lea    0x0(%esi),%esi
    1090:	83 c2 01             	add    $0x1,%edx
    1093:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1097:	89 d0                	mov    %edx,%eax
    1099:	75 f5                	jne    1090 <strlen+0x10>
    ;
  return n;
}
    109b:	5d                   	pop    %ebp
    109c:	c3                   	ret    
    109d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    10a0:	31 c0                	xor    %eax,%eax
}
    10a2:	5d                   	pop    %ebp
    10a3:	c3                   	ret    
    10a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    10aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000010b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10b0:	55                   	push   %ebp
    10b1:	89 e5                	mov    %esp,%ebp
    10b3:	57                   	push   %edi
    10b4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    10b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10ba:	8b 45 0c             	mov    0xc(%ebp),%eax
    10bd:	89 d7                	mov    %edx,%edi
    10bf:	fc                   	cld    
    10c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    10c2:	89 d0                	mov    %edx,%eax
    10c4:	5f                   	pop    %edi
    10c5:	5d                   	pop    %ebp
    10c6:	c3                   	ret    
    10c7:	89 f6                	mov    %esi,%esi
    10c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000010d0 <strchr>:

char*
strchr(const char *s, char c)
{
    10d0:	55                   	push   %ebp
    10d1:	89 e5                	mov    %esp,%ebp
    10d3:	53                   	push   %ebx
    10d4:	8b 45 08             	mov    0x8(%ebp),%eax
    10d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    10da:	0f b6 10             	movzbl (%eax),%edx
    10dd:	84 d2                	test   %dl,%dl
    10df:	74 1d                	je     10fe <strchr+0x2e>
    if(*s == c)
    10e1:	38 d3                	cmp    %dl,%bl
    10e3:	89 d9                	mov    %ebx,%ecx
    10e5:	75 0d                	jne    10f4 <strchr+0x24>
    10e7:	eb 17                	jmp    1100 <strchr+0x30>
    10e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10f0:	38 ca                	cmp    %cl,%dl
    10f2:	74 0c                	je     1100 <strchr+0x30>
  for(; *s; s++)
    10f4:	83 c0 01             	add    $0x1,%eax
    10f7:	0f b6 10             	movzbl (%eax),%edx
    10fa:	84 d2                	test   %dl,%dl
    10fc:	75 f2                	jne    10f0 <strchr+0x20>
      return (char*)s;
  return 0;
    10fe:	31 c0                	xor    %eax,%eax
}
    1100:	5b                   	pop    %ebx
    1101:	5d                   	pop    %ebp
    1102:	c3                   	ret    
    1103:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001110 <gets>:

char*
gets(char *buf, int max)
{
    1110:	55                   	push   %ebp
    1111:	89 e5                	mov    %esp,%ebp
    1113:	57                   	push   %edi
    1114:	56                   	push   %esi
    1115:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1116:	31 f6                	xor    %esi,%esi
    1118:	89 f3                	mov    %esi,%ebx
{
    111a:	83 ec 1c             	sub    $0x1c,%esp
    111d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    1120:	eb 2f                	jmp    1151 <gets+0x41>
    1122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    1128:	8d 45 e7             	lea    -0x19(%ebp),%eax
    112b:	83 ec 04             	sub    $0x4,%esp
    112e:	6a 01                	push   $0x1
    1130:	50                   	push   %eax
    1131:	6a 00                	push   $0x0
    1133:	e8 32 01 00 00       	call   126a <read>
    if(cc < 1)
    1138:	83 c4 10             	add    $0x10,%esp
    113b:	85 c0                	test   %eax,%eax
    113d:	7e 1c                	jle    115b <gets+0x4b>
      break;
    buf[i++] = c;
    113f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    1143:	83 c7 01             	add    $0x1,%edi
    1146:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    1149:	3c 0a                	cmp    $0xa,%al
    114b:	74 23                	je     1170 <gets+0x60>
    114d:	3c 0d                	cmp    $0xd,%al
    114f:	74 1f                	je     1170 <gets+0x60>
  for(i=0; i+1 < max; ){
    1151:	83 c3 01             	add    $0x1,%ebx
    1154:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1157:	89 fe                	mov    %edi,%esi
    1159:	7c cd                	jl     1128 <gets+0x18>
    115b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    115d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    1160:	c6 03 00             	movb   $0x0,(%ebx)
}
    1163:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1166:	5b                   	pop    %ebx
    1167:	5e                   	pop    %esi
    1168:	5f                   	pop    %edi
    1169:	5d                   	pop    %ebp
    116a:	c3                   	ret    
    116b:	90                   	nop
    116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1170:	8b 75 08             	mov    0x8(%ebp),%esi
    1173:	8b 45 08             	mov    0x8(%ebp),%eax
    1176:	01 de                	add    %ebx,%esi
    1178:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    117a:	c6 03 00             	movb   $0x0,(%ebx)
}
    117d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1180:	5b                   	pop    %ebx
    1181:	5e                   	pop    %esi
    1182:	5f                   	pop    %edi
    1183:	5d                   	pop    %ebp
    1184:	c3                   	ret    
    1185:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001190 <stat>:

int
stat(const char *n, struct stat *st)
{
    1190:	55                   	push   %ebp
    1191:	89 e5                	mov    %esp,%ebp
    1193:	56                   	push   %esi
    1194:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1195:	83 ec 08             	sub    $0x8,%esp
    1198:	6a 00                	push   $0x0
    119a:	ff 75 08             	pushl  0x8(%ebp)
    119d:	e8 f0 00 00 00       	call   1292 <open>
  if(fd < 0)
    11a2:	83 c4 10             	add    $0x10,%esp
    11a5:	85 c0                	test   %eax,%eax
    11a7:	78 27                	js     11d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    11a9:	83 ec 08             	sub    $0x8,%esp
    11ac:	ff 75 0c             	pushl  0xc(%ebp)
    11af:	89 c3                	mov    %eax,%ebx
    11b1:	50                   	push   %eax
    11b2:	e8 f3 00 00 00       	call   12aa <fstat>
  close(fd);
    11b7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    11ba:	89 c6                	mov    %eax,%esi
  close(fd);
    11bc:	e8 b9 00 00 00       	call   127a <close>
  return r;
    11c1:	83 c4 10             	add    $0x10,%esp
}
    11c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11c7:	89 f0                	mov    %esi,%eax
    11c9:	5b                   	pop    %ebx
    11ca:	5e                   	pop    %esi
    11cb:	5d                   	pop    %ebp
    11cc:	c3                   	ret    
    11cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    11d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
    11d5:	eb ed                	jmp    11c4 <stat+0x34>
    11d7:	89 f6                	mov    %esi,%esi
    11d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000011e0 <atoi>:

int
atoi(const char *s)
{
    11e0:	55                   	push   %ebp
    11e1:	89 e5                	mov    %esp,%ebp
    11e3:	53                   	push   %ebx
    11e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11e7:	0f be 11             	movsbl (%ecx),%edx
    11ea:	8d 42 d0             	lea    -0x30(%edx),%eax
    11ed:	3c 09                	cmp    $0x9,%al
  n = 0;
    11ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    11f4:	77 1f                	ja     1215 <atoi+0x35>
    11f6:	8d 76 00             	lea    0x0(%esi),%esi
    11f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    1200:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1203:	83 c1 01             	add    $0x1,%ecx
    1206:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    120a:	0f be 11             	movsbl (%ecx),%edx
    120d:	8d 5a d0             	lea    -0x30(%edx),%ebx
    1210:	80 fb 09             	cmp    $0x9,%bl
    1213:	76 eb                	jbe    1200 <atoi+0x20>
  return n;
}
    1215:	5b                   	pop    %ebx
    1216:	5d                   	pop    %ebp
    1217:	c3                   	ret    
    1218:	90                   	nop
    1219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001220 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	56                   	push   %esi
    1224:	53                   	push   %ebx
    1225:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1228:	8b 45 08             	mov    0x8(%ebp),%eax
    122b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    122e:	85 db                	test   %ebx,%ebx
    1230:	7e 14                	jle    1246 <memmove+0x26>
    1232:	31 d2                	xor    %edx,%edx
    1234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    1238:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    123c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    123f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    1242:	39 d3                	cmp    %edx,%ebx
    1244:	75 f2                	jne    1238 <memmove+0x18>
  return vdst;
}
    1246:	5b                   	pop    %ebx
    1247:	5e                   	pop    %esi
    1248:	5d                   	pop    %ebp
    1249:	c3                   	ret    

0000124a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    124a:	b8 01 00 00 00       	mov    $0x1,%eax
    124f:	cd 40                	int    $0x40
    1251:	c3                   	ret    

00001252 <exit>:
SYSCALL(exit)
    1252:	b8 02 00 00 00       	mov    $0x2,%eax
    1257:	cd 40                	int    $0x40
    1259:	c3                   	ret    

0000125a <wait>:
SYSCALL(wait)
    125a:	b8 03 00 00 00       	mov    $0x3,%eax
    125f:	cd 40                	int    $0x40
    1261:	c3                   	ret    

00001262 <pipe>:
SYSCALL(pipe)
    1262:	b8 04 00 00 00       	mov    $0x4,%eax
    1267:	cd 40                	int    $0x40
    1269:	c3                   	ret    

0000126a <read>:
SYSCALL(read)
    126a:	b8 05 00 00 00       	mov    $0x5,%eax
    126f:	cd 40                	int    $0x40
    1271:	c3                   	ret    

00001272 <write>:
SYSCALL(write)
    1272:	b8 10 00 00 00       	mov    $0x10,%eax
    1277:	cd 40                	int    $0x40
    1279:	c3                   	ret    

0000127a <close>:
SYSCALL(close)
    127a:	b8 15 00 00 00       	mov    $0x15,%eax
    127f:	cd 40                	int    $0x40
    1281:	c3                   	ret    

00001282 <kill>:
SYSCALL(kill)
    1282:	b8 06 00 00 00       	mov    $0x6,%eax
    1287:	cd 40                	int    $0x40
    1289:	c3                   	ret    

0000128a <exec>:
SYSCALL(exec)
    128a:	b8 07 00 00 00       	mov    $0x7,%eax
    128f:	cd 40                	int    $0x40
    1291:	c3                   	ret    

00001292 <open>:
SYSCALL(open)
    1292:	b8 0f 00 00 00       	mov    $0xf,%eax
    1297:	cd 40                	int    $0x40
    1299:	c3                   	ret    

0000129a <mknod>:
SYSCALL(mknod)
    129a:	b8 11 00 00 00       	mov    $0x11,%eax
    129f:	cd 40                	int    $0x40
    12a1:	c3                   	ret    

000012a2 <unlink>:
SYSCALL(unlink)
    12a2:	b8 12 00 00 00       	mov    $0x12,%eax
    12a7:	cd 40                	int    $0x40
    12a9:	c3                   	ret    

000012aa <fstat>:
SYSCALL(fstat)
    12aa:	b8 08 00 00 00       	mov    $0x8,%eax
    12af:	cd 40                	int    $0x40
    12b1:	c3                   	ret    

000012b2 <link>:
SYSCALL(link)
    12b2:	b8 13 00 00 00       	mov    $0x13,%eax
    12b7:	cd 40                	int    $0x40
    12b9:	c3                   	ret    

000012ba <mkdir>:
SYSCALL(mkdir)
    12ba:	b8 14 00 00 00       	mov    $0x14,%eax
    12bf:	cd 40                	int    $0x40
    12c1:	c3                   	ret    

000012c2 <chdir>:
SYSCALL(chdir)
    12c2:	b8 09 00 00 00       	mov    $0x9,%eax
    12c7:	cd 40                	int    $0x40
    12c9:	c3                   	ret    

000012ca <dup>:
SYSCALL(dup)
    12ca:	b8 0a 00 00 00       	mov    $0xa,%eax
    12cf:	cd 40                	int    $0x40
    12d1:	c3                   	ret    

000012d2 <getpid>:
SYSCALL(getpid)
    12d2:	b8 0b 00 00 00       	mov    $0xb,%eax
    12d7:	cd 40                	int    $0x40
    12d9:	c3                   	ret    

000012da <sbrk>:
SYSCALL(sbrk)
    12da:	b8 0c 00 00 00       	mov    $0xc,%eax
    12df:	cd 40                	int    $0x40
    12e1:	c3                   	ret    

000012e2 <sleep>:
SYSCALL(sleep)
    12e2:	b8 0d 00 00 00       	mov    $0xd,%eax
    12e7:	cd 40                	int    $0x40
    12e9:	c3                   	ret    

000012ea <uptime>:
SYSCALL(uptime)
    12ea:	b8 0e 00 00 00       	mov    $0xe,%eax
    12ef:	cd 40                	int    $0x40
    12f1:	c3                   	ret    

000012f2 <sigprocmask>:
SYSCALL(sigprocmask)
    12f2:	b8 16 00 00 00       	mov    $0x16,%eax
    12f7:	cd 40                	int    $0x40
    12f9:	c3                   	ret    

000012fa <sigaction>:
SYSCALL(sigaction)
    12fa:	b8 17 00 00 00       	mov    $0x17,%eax
    12ff:	cd 40                	int    $0x40
    1301:	c3                   	ret    

00001302 <sigret>:
SYSCALL(sigret)
    1302:	b8 18 00 00 00       	mov    $0x18,%eax
    1307:	cd 40                	int    $0x40
    1309:	c3                   	ret    
    130a:	66 90                	xchg   %ax,%ax
    130c:	66 90                	xchg   %ax,%ax
    130e:	66 90                	xchg   %ax,%ax

00001310 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1310:	55                   	push   %ebp
    1311:	89 e5                	mov    %esp,%ebp
    1313:	57                   	push   %edi
    1314:	56                   	push   %esi
    1315:	53                   	push   %ebx
    1316:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1319:	85 d2                	test   %edx,%edx
{
    131b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
    131e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    1320:	79 76                	jns    1398 <printint+0x88>
    1322:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    1326:	74 70                	je     1398 <printint+0x88>
    x = -xx;
    1328:	f7 d8                	neg    %eax
    neg = 1;
    132a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    1331:	31 f6                	xor    %esi,%esi
    1333:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    1336:	eb 0a                	jmp    1342 <printint+0x32>
    1338:	90                   	nop
    1339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
    1340:	89 fe                	mov    %edi,%esi
    1342:	31 d2                	xor    %edx,%edx
    1344:	8d 7e 01             	lea    0x1(%esi),%edi
    1347:	f7 f1                	div    %ecx
    1349:	0f b6 92 38 20 00 00 	movzbl 0x2038(%edx),%edx
  }while((x /= base) != 0);
    1350:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    1352:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
    1355:	75 e9                	jne    1340 <printint+0x30>
  if(neg)
    1357:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    135a:	85 c0                	test   %eax,%eax
    135c:	74 08                	je     1366 <printint+0x56>
    buf[i++] = '-';
    135e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    1363:	8d 7e 02             	lea    0x2(%esi),%edi
    1366:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
    136a:	8b 7d c0             	mov    -0x40(%ebp),%edi
    136d:	8d 76 00             	lea    0x0(%esi),%esi
    1370:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
    1373:	83 ec 04             	sub    $0x4,%esp
    1376:	83 ee 01             	sub    $0x1,%esi
    1379:	6a 01                	push   $0x1
    137b:	53                   	push   %ebx
    137c:	57                   	push   %edi
    137d:	88 45 d7             	mov    %al,-0x29(%ebp)
    1380:	e8 ed fe ff ff       	call   1272 <write>

  while(--i >= 0)
    1385:	83 c4 10             	add    $0x10,%esp
    1388:	39 de                	cmp    %ebx,%esi
    138a:	75 e4                	jne    1370 <printint+0x60>
    putc(fd, buf[i]);
}
    138c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    138f:	5b                   	pop    %ebx
    1390:	5e                   	pop    %esi
    1391:	5f                   	pop    %edi
    1392:	5d                   	pop    %ebp
    1393:	c3                   	ret    
    1394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1398:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    139f:	eb 90                	jmp    1331 <printint+0x21>
    13a1:	eb 0d                	jmp    13b0 <printf>
    13a3:	90                   	nop
    13a4:	90                   	nop
    13a5:	90                   	nop
    13a6:	90                   	nop
    13a7:	90                   	nop
    13a8:	90                   	nop
    13a9:	90                   	nop
    13aa:	90                   	nop
    13ab:	90                   	nop
    13ac:	90                   	nop
    13ad:	90                   	nop
    13ae:	90                   	nop
    13af:	90                   	nop

000013b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    13b0:	55                   	push   %ebp
    13b1:	89 e5                	mov    %esp,%ebp
    13b3:	57                   	push   %edi
    13b4:	56                   	push   %esi
    13b5:	53                   	push   %ebx
    13b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    13b9:	8b 75 0c             	mov    0xc(%ebp),%esi
    13bc:	0f b6 1e             	movzbl (%esi),%ebx
    13bf:	84 db                	test   %bl,%bl
    13c1:	0f 84 b3 00 00 00    	je     147a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
    13c7:	8d 45 10             	lea    0x10(%ebp),%eax
    13ca:	83 c6 01             	add    $0x1,%esi
  state = 0;
    13cd:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
    13cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    13d2:	eb 2f                	jmp    1403 <printf+0x53>
    13d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    13d8:	83 f8 25             	cmp    $0x25,%eax
    13db:	0f 84 a7 00 00 00    	je     1488 <printf+0xd8>
  write(fd, &c, 1);
    13e1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    13e4:	83 ec 04             	sub    $0x4,%esp
    13e7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
    13ea:	6a 01                	push   $0x1
    13ec:	50                   	push   %eax
    13ed:	ff 75 08             	pushl  0x8(%ebp)
    13f0:	e8 7d fe ff ff       	call   1272 <write>
    13f5:	83 c4 10             	add    $0x10,%esp
    13f8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    13fb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    13ff:	84 db                	test   %bl,%bl
    1401:	74 77                	je     147a <printf+0xca>
    if(state == 0){
    1403:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    1405:	0f be cb             	movsbl %bl,%ecx
    1408:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    140b:	74 cb                	je     13d8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    140d:	83 ff 25             	cmp    $0x25,%edi
    1410:	75 e6                	jne    13f8 <printf+0x48>
      if(c == 'd'){
    1412:	83 f8 64             	cmp    $0x64,%eax
    1415:	0f 84 05 01 00 00    	je     1520 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    141b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    1421:	83 f9 70             	cmp    $0x70,%ecx
    1424:	74 72                	je     1498 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1426:	83 f8 73             	cmp    $0x73,%eax
    1429:	0f 84 99 00 00 00    	je     14c8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    142f:	83 f8 63             	cmp    $0x63,%eax
    1432:	0f 84 08 01 00 00    	je     1540 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1438:	83 f8 25             	cmp    $0x25,%eax
    143b:	0f 84 ef 00 00 00    	je     1530 <printf+0x180>
  write(fd, &c, 1);
    1441:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1444:	83 ec 04             	sub    $0x4,%esp
    1447:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    144b:	6a 01                	push   $0x1
    144d:	50                   	push   %eax
    144e:	ff 75 08             	pushl  0x8(%ebp)
    1451:	e8 1c fe ff ff       	call   1272 <write>
    1456:	83 c4 0c             	add    $0xc,%esp
    1459:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    145c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    145f:	6a 01                	push   $0x1
    1461:	50                   	push   %eax
    1462:	ff 75 08             	pushl  0x8(%ebp)
    1465:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1468:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    146a:	e8 03 fe ff ff       	call   1272 <write>
  for(i = 0; fmt[i]; i++){
    146f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
    1473:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1476:	84 db                	test   %bl,%bl
    1478:	75 89                	jne    1403 <printf+0x53>
    }
  }
}
    147a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    147d:	5b                   	pop    %ebx
    147e:	5e                   	pop    %esi
    147f:	5f                   	pop    %edi
    1480:	5d                   	pop    %ebp
    1481:	c3                   	ret    
    1482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    1488:	bf 25 00 00 00       	mov    $0x25,%edi
    148d:	e9 66 ff ff ff       	jmp    13f8 <printf+0x48>
    1492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1498:	83 ec 0c             	sub    $0xc,%esp
    149b:	b9 10 00 00 00       	mov    $0x10,%ecx
    14a0:	6a 00                	push   $0x0
    14a2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    14a5:	8b 45 08             	mov    0x8(%ebp),%eax
    14a8:	8b 17                	mov    (%edi),%edx
    14aa:	e8 61 fe ff ff       	call   1310 <printint>
        ap++;
    14af:	89 f8                	mov    %edi,%eax
    14b1:	83 c4 10             	add    $0x10,%esp
      state = 0;
    14b4:	31 ff                	xor    %edi,%edi
        ap++;
    14b6:	83 c0 04             	add    $0x4,%eax
    14b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    14bc:	e9 37 ff ff ff       	jmp    13f8 <printf+0x48>
    14c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    14c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    14cb:	8b 08                	mov    (%eax),%ecx
        ap++;
    14cd:	83 c0 04             	add    $0x4,%eax
    14d0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    14d3:	85 c9                	test   %ecx,%ecx
    14d5:	0f 84 8e 00 00 00    	je     1569 <printf+0x1b9>
        while(*s != 0){
    14db:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    14de:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    14e0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    14e2:	84 c0                	test   %al,%al
    14e4:	0f 84 0e ff ff ff    	je     13f8 <printf+0x48>
    14ea:	89 75 d0             	mov    %esi,-0x30(%ebp)
    14ed:	89 de                	mov    %ebx,%esi
    14ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
    14f2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    14f5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    14f8:	83 ec 04             	sub    $0x4,%esp
          s++;
    14fb:	83 c6 01             	add    $0x1,%esi
    14fe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    1501:	6a 01                	push   $0x1
    1503:	57                   	push   %edi
    1504:	53                   	push   %ebx
    1505:	e8 68 fd ff ff       	call   1272 <write>
        while(*s != 0){
    150a:	0f b6 06             	movzbl (%esi),%eax
    150d:	83 c4 10             	add    $0x10,%esp
    1510:	84 c0                	test   %al,%al
    1512:	75 e4                	jne    14f8 <printf+0x148>
    1514:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    1517:	31 ff                	xor    %edi,%edi
    1519:	e9 da fe ff ff       	jmp    13f8 <printf+0x48>
    151e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    1520:	83 ec 0c             	sub    $0xc,%esp
    1523:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1528:	6a 01                	push   $0x1
    152a:	e9 73 ff ff ff       	jmp    14a2 <printf+0xf2>
    152f:	90                   	nop
  write(fd, &c, 1);
    1530:	83 ec 04             	sub    $0x4,%esp
    1533:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    1536:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1539:	6a 01                	push   $0x1
    153b:	e9 21 ff ff ff       	jmp    1461 <printf+0xb1>
        putc(fd, *ap);
    1540:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    1543:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1546:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    1548:	6a 01                	push   $0x1
        ap++;
    154a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    154d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    1550:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    1553:	50                   	push   %eax
    1554:	ff 75 08             	pushl  0x8(%ebp)
    1557:	e8 16 fd ff ff       	call   1272 <write>
        ap++;
    155c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    155f:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1562:	31 ff                	xor    %edi,%edi
    1564:	e9 8f fe ff ff       	jmp    13f8 <printf+0x48>
          s = "(null)";
    1569:	bb 2f 20 00 00       	mov    $0x202f,%ebx
        while(*s != 0){
    156e:	b8 28 00 00 00       	mov    $0x28,%eax
    1573:	e9 72 ff ff ff       	jmp    14ea <printf+0x13a>
    1578:	66 90                	xchg   %ax,%ax
    157a:	66 90                	xchg   %ax,%ax
    157c:	66 90                	xchg   %ax,%ax
    157e:	66 90                	xchg   %ax,%ax

00001580 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1580:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1581:	a1 a8 24 00 00       	mov    0x24a8,%eax
{
    1586:	89 e5                	mov    %esp,%ebp
    1588:	57                   	push   %edi
    1589:	56                   	push   %esi
    158a:	53                   	push   %ebx
    158b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    158e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    1591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1598:	39 c8                	cmp    %ecx,%eax
    159a:	8b 10                	mov    (%eax),%edx
    159c:	73 32                	jae    15d0 <free+0x50>
    159e:	39 d1                	cmp    %edx,%ecx
    15a0:	72 04                	jb     15a6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15a2:	39 d0                	cmp    %edx,%eax
    15a4:	72 32                	jb     15d8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    15a6:	8b 73 fc             	mov    -0x4(%ebx),%esi
    15a9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    15ac:	39 fa                	cmp    %edi,%edx
    15ae:	74 30                	je     15e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    15b0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    15b3:	8b 50 04             	mov    0x4(%eax),%edx
    15b6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    15b9:	39 f1                	cmp    %esi,%ecx
    15bb:	74 3a                	je     15f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    15bd:	89 08                	mov    %ecx,(%eax)
  freep = p;
    15bf:	a3 a8 24 00 00       	mov    %eax,0x24a8
}
    15c4:	5b                   	pop    %ebx
    15c5:	5e                   	pop    %esi
    15c6:	5f                   	pop    %edi
    15c7:	5d                   	pop    %ebp
    15c8:	c3                   	ret    
    15c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    15d0:	39 d0                	cmp    %edx,%eax
    15d2:	72 04                	jb     15d8 <free+0x58>
    15d4:	39 d1                	cmp    %edx,%ecx
    15d6:	72 ce                	jb     15a6 <free+0x26>
{
    15d8:	89 d0                	mov    %edx,%eax
    15da:	eb bc                	jmp    1598 <free+0x18>
    15dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    15e0:	03 72 04             	add    0x4(%edx),%esi
    15e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    15e6:	8b 10                	mov    (%eax),%edx
    15e8:	8b 12                	mov    (%edx),%edx
    15ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    15ed:	8b 50 04             	mov    0x4(%eax),%edx
    15f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    15f3:	39 f1                	cmp    %esi,%ecx
    15f5:	75 c6                	jne    15bd <free+0x3d>
    p->s.size += bp->s.size;
    15f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    15fa:	a3 a8 24 00 00       	mov    %eax,0x24a8
    p->s.size += bp->s.size;
    15ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1602:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1605:	89 10                	mov    %edx,(%eax)
}
    1607:	5b                   	pop    %ebx
    1608:	5e                   	pop    %esi
    1609:	5f                   	pop    %edi
    160a:	5d                   	pop    %ebp
    160b:	c3                   	ret    
    160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001610 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1610:	55                   	push   %ebp
    1611:	89 e5                	mov    %esp,%ebp
    1613:	57                   	push   %edi
    1614:	56                   	push   %esi
    1615:	53                   	push   %ebx
    1616:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1619:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    161c:	8b 15 a8 24 00 00    	mov    0x24a8,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1622:	8d 78 07             	lea    0x7(%eax),%edi
    1625:	c1 ef 03             	shr    $0x3,%edi
    1628:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    162b:	85 d2                	test   %edx,%edx
    162d:	0f 84 9d 00 00 00    	je     16d0 <malloc+0xc0>
    1633:	8b 02                	mov    (%edx),%eax
    1635:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    1638:	39 cf                	cmp    %ecx,%edi
    163a:	76 6c                	jbe    16a8 <malloc+0x98>
    163c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    1642:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1647:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    164a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    1651:	eb 0e                	jmp    1661 <malloc+0x51>
    1653:	90                   	nop
    1654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1658:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    165a:	8b 48 04             	mov    0x4(%eax),%ecx
    165d:	39 f9                	cmp    %edi,%ecx
    165f:	73 47                	jae    16a8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1661:	39 05 a8 24 00 00    	cmp    %eax,0x24a8
    1667:	89 c2                	mov    %eax,%edx
    1669:	75 ed                	jne    1658 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    166b:	83 ec 0c             	sub    $0xc,%esp
    166e:	56                   	push   %esi
    166f:	e8 66 fc ff ff       	call   12da <sbrk>
  if(p == (char*)-1)
    1674:	83 c4 10             	add    $0x10,%esp
    1677:	83 f8 ff             	cmp    $0xffffffff,%eax
    167a:	74 1c                	je     1698 <malloc+0x88>
  hp->s.size = nu;
    167c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    167f:	83 ec 0c             	sub    $0xc,%esp
    1682:	83 c0 08             	add    $0x8,%eax
    1685:	50                   	push   %eax
    1686:	e8 f5 fe ff ff       	call   1580 <free>
  return freep;
    168b:	8b 15 a8 24 00 00    	mov    0x24a8,%edx
      if((p = morecore(nunits)) == 0)
    1691:	83 c4 10             	add    $0x10,%esp
    1694:	85 d2                	test   %edx,%edx
    1696:	75 c0                	jne    1658 <malloc+0x48>
        return 0;
  }
}
    1698:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    169b:	31 c0                	xor    %eax,%eax
}
    169d:	5b                   	pop    %ebx
    169e:	5e                   	pop    %esi
    169f:	5f                   	pop    %edi
    16a0:	5d                   	pop    %ebp
    16a1:	c3                   	ret    
    16a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    16a8:	39 cf                	cmp    %ecx,%edi
    16aa:	74 54                	je     1700 <malloc+0xf0>
        p->s.size -= nunits;
    16ac:	29 f9                	sub    %edi,%ecx
    16ae:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    16b1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    16b4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    16b7:	89 15 a8 24 00 00    	mov    %edx,0x24a8
}
    16bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    16c0:	83 c0 08             	add    $0x8,%eax
}
    16c3:	5b                   	pop    %ebx
    16c4:	5e                   	pop    %esi
    16c5:	5f                   	pop    %edi
    16c6:	5d                   	pop    %ebp
    16c7:	c3                   	ret    
    16c8:	90                   	nop
    16c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    16d0:	c7 05 a8 24 00 00 ac 	movl   $0x24ac,0x24a8
    16d7:	24 00 00 
    16da:	c7 05 ac 24 00 00 ac 	movl   $0x24ac,0x24ac
    16e1:	24 00 00 
    base.s.size = 0;
    16e4:	b8 ac 24 00 00       	mov    $0x24ac,%eax
    16e9:	c7 05 b0 24 00 00 00 	movl   $0x0,0x24b0
    16f0:	00 00 00 
    16f3:	e9 44 ff ff ff       	jmp    163c <malloc+0x2c>
    16f8:	90                   	nop
    16f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    1700:	8b 08                	mov    (%eax),%ecx
    1702:	89 0a                	mov    %ecx,(%edx)
    1704:	eb b1                	jmp    16b7 <malloc+0xa7>
