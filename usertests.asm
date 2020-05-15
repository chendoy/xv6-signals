
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
       6:	68 d4 3b 00 00       	push   $0x3bd4
       b:	ff 35 80 5b 00 00    	pushl  0x5b80
      11:	e8 70 38 00 00       	call   3886 <printf>

  if(mkdir("iputdir") < 0){
      16:	c7 04 24 67 3b 00 00 	movl   $0x3b67,(%esp)
      1d:	e8 7a 37 00 00       	call   379c <mkdir>
      22:	83 c4 10             	add    $0x10,%esp
      25:	85 c0                	test   %eax,%eax
      27:	78 54                	js     7d <iputtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
      29:	83 ec 0c             	sub    $0xc,%esp
      2c:	68 67 3b 00 00       	push   $0x3b67
      31:	e8 6e 37 00 00       	call   37a4 <chdir>
      36:	83 c4 10             	add    $0x10,%esp
      39:	85 c0                	test   %eax,%eax
      3b:	78 58                	js     95 <iputtest+0x95>
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
      3d:	83 ec 0c             	sub    $0xc,%esp
      40:	68 64 3b 00 00       	push   $0x3b64
      45:	e8 3a 37 00 00       	call   3784 <unlink>
      4a:	83 c4 10             	add    $0x10,%esp
      4d:	85 c0                	test   %eax,%eax
      4f:	78 5c                	js     ad <iputtest+0xad>
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
      51:	83 ec 0c             	sub    $0xc,%esp
      54:	68 89 3b 00 00       	push   $0x3b89
      59:	e8 46 37 00 00       	call   37a4 <chdir>
      5e:	83 c4 10             	add    $0x10,%esp
      61:	85 c0                	test   %eax,%eax
      63:	78 60                	js     c5 <iputtest+0xc5>
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
      65:	83 ec 08             	sub    $0x8,%esp
      68:	68 0c 3c 00 00       	push   $0x3c0c
      6d:	ff 35 80 5b 00 00    	pushl  0x5b80
      73:	e8 0e 38 00 00       	call   3886 <printf>
}
      78:	83 c4 10             	add    $0x10,%esp
      7b:	c9                   	leave  
      7c:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
      7d:	83 ec 08             	sub    $0x8,%esp
      80:	68 40 3b 00 00       	push   $0x3b40
      85:	ff 35 80 5b 00 00    	pushl  0x5b80
      8b:	e8 f6 37 00 00       	call   3886 <printf>
    exit();
      90:	e8 9f 36 00 00       	call   3734 <exit>
    printf(stdout, "chdir iputdir failed\n");
      95:	83 ec 08             	sub    $0x8,%esp
      98:	68 4e 3b 00 00       	push   $0x3b4e
      9d:	ff 35 80 5b 00 00    	pushl  0x5b80
      a3:	e8 de 37 00 00       	call   3886 <printf>
    exit();
      a8:	e8 87 36 00 00       	call   3734 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
      ad:	83 ec 08             	sub    $0x8,%esp
      b0:	68 6f 3b 00 00       	push   $0x3b6f
      b5:	ff 35 80 5b 00 00    	pushl  0x5b80
      bb:	e8 c6 37 00 00       	call   3886 <printf>
    exit();
      c0:	e8 6f 36 00 00       	call   3734 <exit>
    printf(stdout, "chdir / failed\n");
      c5:	83 ec 08             	sub    $0x8,%esp
      c8:	68 8b 3b 00 00       	push   $0x3b8b
      cd:	ff 35 80 5b 00 00    	pushl  0x5b80
      d3:	e8 ae 37 00 00       	call   3886 <printf>
    exit();
      d8:	e8 57 36 00 00       	call   3734 <exit>

000000dd <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      dd:	55                   	push   %ebp
      de:	89 e5                	mov    %esp,%ebp
      e0:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e3:	68 9b 3b 00 00       	push   $0x3b9b
      e8:	ff 35 80 5b 00 00    	pushl  0x5b80
      ee:	e8 93 37 00 00       	call   3886 <printf>

  pid = fork();
      f3:	e8 34 36 00 00       	call   372c <fork>
  if(pid < 0){
      f8:	83 c4 10             	add    $0x10,%esp
      fb:	85 c0                	test   %eax,%eax
      fd:	78 49                	js     148 <exitiputtest+0x6b>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
      ff:	85 c0                	test   %eax,%eax
     101:	0f 85 a1 00 00 00    	jne    1a8 <exitiputtest+0xcb>
    if(mkdir("iputdir") < 0){
     107:	83 ec 0c             	sub    $0xc,%esp
     10a:	68 67 3b 00 00       	push   $0x3b67
     10f:	e8 88 36 00 00       	call   379c <mkdir>
     114:	83 c4 10             	add    $0x10,%esp
     117:	85 c0                	test   %eax,%eax
     119:	78 45                	js     160 <exitiputtest+0x83>
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
     11b:	83 ec 0c             	sub    $0xc,%esp
     11e:	68 67 3b 00 00       	push   $0x3b67
     123:	e8 7c 36 00 00       	call   37a4 <chdir>
     128:	83 c4 10             	add    $0x10,%esp
     12b:	85 c0                	test   %eax,%eax
     12d:	78 49                	js     178 <exitiputtest+0x9b>
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     12f:	83 ec 0c             	sub    $0xc,%esp
     132:	68 64 3b 00 00       	push   $0x3b64
     137:	e8 48 36 00 00       	call   3784 <unlink>
     13c:	83 c4 10             	add    $0x10,%esp
     13f:	85 c0                	test   %eax,%eax
     141:	78 4d                	js     190 <exitiputtest+0xb3>
      printf(stdout, "unlink ../iputdir failed\n");
      exit();
    }
    exit();
     143:	e8 ec 35 00 00       	call   3734 <exit>
    printf(stdout, "fork failed\n");
     148:	83 ec 08             	sub    $0x8,%esp
     14b:	68 81 4a 00 00       	push   $0x4a81
     150:	ff 35 80 5b 00 00    	pushl  0x5b80
     156:	e8 2b 37 00 00       	call   3886 <printf>
    exit();
     15b:	e8 d4 35 00 00       	call   3734 <exit>
      printf(stdout, "mkdir failed\n");
     160:	83 ec 08             	sub    $0x8,%esp
     163:	68 40 3b 00 00       	push   $0x3b40
     168:	ff 35 80 5b 00 00    	pushl  0x5b80
     16e:	e8 13 37 00 00       	call   3886 <printf>
      exit();
     173:	e8 bc 35 00 00       	call   3734 <exit>
      printf(stdout, "child chdir failed\n");
     178:	83 ec 08             	sub    $0x8,%esp
     17b:	68 aa 3b 00 00       	push   $0x3baa
     180:	ff 35 80 5b 00 00    	pushl  0x5b80
     186:	e8 fb 36 00 00       	call   3886 <printf>
      exit();
     18b:	e8 a4 35 00 00       	call   3734 <exit>
      printf(stdout, "unlink ../iputdir failed\n");
     190:	83 ec 08             	sub    $0x8,%esp
     193:	68 6f 3b 00 00       	push   $0x3b6f
     198:	ff 35 80 5b 00 00    	pushl  0x5b80
     19e:	e8 e3 36 00 00       	call   3886 <printf>
      exit();
     1a3:	e8 8c 35 00 00       	call   3734 <exit>
  }
  wait();
     1a8:	e8 8f 35 00 00       	call   373c <wait>
  printf(stdout, "exitiput test ok\n");
     1ad:	83 ec 08             	sub    $0x8,%esp
     1b0:	68 be 3b 00 00       	push   $0x3bbe
     1b5:	ff 35 80 5b 00 00    	pushl  0x5b80
     1bb:	e8 c6 36 00 00       	call   3886 <printf>
}
     1c0:	83 c4 10             	add    $0x10,%esp
     1c3:	c9                   	leave  
     1c4:	c3                   	ret    

000001c5 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c5:	55                   	push   %ebp
     1c6:	89 e5                	mov    %esp,%ebp
     1c8:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cb:	68 d0 3b 00 00       	push   $0x3bd0
     1d0:	ff 35 80 5b 00 00    	pushl  0x5b80
     1d6:	e8 ab 36 00 00       	call   3886 <printf>
  if(mkdir("oidir") < 0){
     1db:	c7 04 24 df 3b 00 00 	movl   $0x3bdf,(%esp)
     1e2:	e8 b5 35 00 00       	call   379c <mkdir>
     1e7:	83 c4 10             	add    $0x10,%esp
     1ea:	85 c0                	test   %eax,%eax
     1ec:	78 3b                	js     229 <openiputtest+0x64>
    printf(stdout, "mkdir oidir failed\n");
    exit();
  }
  pid = fork();
     1ee:	e8 39 35 00 00       	call   372c <fork>
  if(pid < 0){
     1f3:	85 c0                	test   %eax,%eax
     1f5:	78 4a                	js     241 <openiputtest+0x7c>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     1f7:	85 c0                	test   %eax,%eax
     1f9:	75 63                	jne    25e <openiputtest+0x99>
    int fd = open("oidir", O_RDWR);
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	6a 02                	push   $0x2
     200:	68 df 3b 00 00       	push   $0x3bdf
     205:	e8 6a 35 00 00       	call   3774 <open>
    if(fd >= 0){
     20a:	83 c4 10             	add    $0x10,%esp
     20d:	85 c0                	test   %eax,%eax
     20f:	78 48                	js     259 <openiputtest+0x94>
      printf(stdout, "open directory for write succeeded\n");
     211:	83 ec 08             	sub    $0x8,%esp
     214:	68 64 4b 00 00       	push   $0x4b64
     219:	ff 35 80 5b 00 00    	pushl  0x5b80
     21f:	e8 62 36 00 00       	call   3886 <printf>
      exit();
     224:	e8 0b 35 00 00       	call   3734 <exit>
    printf(stdout, "mkdir oidir failed\n");
     229:	83 ec 08             	sub    $0x8,%esp
     22c:	68 e5 3b 00 00       	push   $0x3be5
     231:	ff 35 80 5b 00 00    	pushl  0x5b80
     237:	e8 4a 36 00 00       	call   3886 <printf>
    exit();
     23c:	e8 f3 34 00 00       	call   3734 <exit>
    printf(stdout, "fork failed\n");
     241:	83 ec 08             	sub    $0x8,%esp
     244:	68 81 4a 00 00       	push   $0x4a81
     249:	ff 35 80 5b 00 00    	pushl  0x5b80
     24f:	e8 32 36 00 00       	call   3886 <printf>
    exit();
     254:	e8 db 34 00 00       	call   3734 <exit>
    }
    exit();
     259:	e8 d6 34 00 00       	call   3734 <exit>
  }
  sleep(1);
     25e:	83 ec 0c             	sub    $0xc,%esp
     261:	6a 01                	push   $0x1
     263:	e8 5c 35 00 00       	call   37c4 <sleep>
  if(unlink("oidir") != 0){
     268:	c7 04 24 df 3b 00 00 	movl   $0x3bdf,(%esp)
     26f:	e8 10 35 00 00       	call   3784 <unlink>
     274:	83 c4 10             	add    $0x10,%esp
     277:	85 c0                	test   %eax,%eax
     279:	75 1d                	jne    298 <openiputtest+0xd3>
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
     27b:	e8 bc 34 00 00       	call   373c <wait>
  printf(stdout, "openiput test ok\n");
     280:	83 ec 08             	sub    $0x8,%esp
     283:	68 08 3c 00 00       	push   $0x3c08
     288:	ff 35 80 5b 00 00    	pushl  0x5b80
     28e:	e8 f3 35 00 00       	call   3886 <printf>
}
     293:	83 c4 10             	add    $0x10,%esp
     296:	c9                   	leave  
     297:	c3                   	ret    
    printf(stdout, "unlink failed\n");
     298:	83 ec 08             	sub    $0x8,%esp
     29b:	68 f9 3b 00 00       	push   $0x3bf9
     2a0:	ff 35 80 5b 00 00    	pushl  0x5b80
     2a6:	e8 db 35 00 00       	call   3886 <printf>
    exit();
     2ab:	e8 84 34 00 00       	call   3734 <exit>

000002b0 <opentest>:

// simple file system tests

void
opentest(void)
{
     2b0:	55                   	push   %ebp
     2b1:	89 e5                	mov    %esp,%ebp
     2b3:	83 ec 10             	sub    $0x10,%esp
  int fd;

  printf(stdout, "open test\n");
     2b6:	68 1a 3c 00 00       	push   $0x3c1a
     2bb:	ff 35 80 5b 00 00    	pushl  0x5b80
     2c1:	e8 c0 35 00 00       	call   3886 <printf>
  fd = open("echo", 0);
     2c6:	83 c4 08             	add    $0x8,%esp
     2c9:	6a 00                	push   $0x0
     2cb:	68 25 3c 00 00       	push   $0x3c25
     2d0:	e8 9f 34 00 00       	call   3774 <open>
  if(fd < 0){
     2d5:	83 c4 10             	add    $0x10,%esp
     2d8:	85 c0                	test   %eax,%eax
     2da:	78 37                	js     313 <opentest+0x63>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
     2dc:	83 ec 0c             	sub    $0xc,%esp
     2df:	50                   	push   %eax
     2e0:	e8 77 34 00 00       	call   375c <close>
  fd = open("doesnotexist", 0);
     2e5:	83 c4 08             	add    $0x8,%esp
     2e8:	6a 00                	push   $0x0
     2ea:	68 3d 3c 00 00       	push   $0x3c3d
     2ef:	e8 80 34 00 00       	call   3774 <open>
  if(fd >= 0){
     2f4:	83 c4 10             	add    $0x10,%esp
     2f7:	85 c0                	test   %eax,%eax
     2f9:	79 30                	jns    32b <opentest+0x7b>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
     2fb:	83 ec 08             	sub    $0x8,%esp
     2fe:	68 68 3c 00 00       	push   $0x3c68
     303:	ff 35 80 5b 00 00    	pushl  0x5b80
     309:	e8 78 35 00 00       	call   3886 <printf>
}
     30e:	83 c4 10             	add    $0x10,%esp
     311:	c9                   	leave  
     312:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     313:	83 ec 08             	sub    $0x8,%esp
     316:	68 2a 3c 00 00       	push   $0x3c2a
     31b:	ff 35 80 5b 00 00    	pushl  0x5b80
     321:	e8 60 35 00 00       	call   3886 <printf>
    exit();
     326:	e8 09 34 00 00       	call   3734 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     32b:	83 ec 08             	sub    $0x8,%esp
     32e:	68 4a 3c 00 00       	push   $0x3c4a
     333:	ff 35 80 5b 00 00    	pushl  0x5b80
     339:	e8 48 35 00 00       	call   3886 <printf>
    exit();
     33e:	e8 f1 33 00 00       	call   3734 <exit>

00000343 <writetest>:

void
writetest(void)
{
     343:	55                   	push   %ebp
     344:	89 e5                	mov    %esp,%ebp
     346:	56                   	push   %esi
     347:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     348:	83 ec 08             	sub    $0x8,%esp
     34b:	68 76 3c 00 00       	push   $0x3c76
     350:	ff 35 80 5b 00 00    	pushl  0x5b80
     356:	e8 2b 35 00 00       	call   3886 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     35b:	83 c4 08             	add    $0x8,%esp
     35e:	68 02 02 00 00       	push   $0x202
     363:	68 87 3c 00 00       	push   $0x3c87
     368:	e8 07 34 00 00       	call   3774 <open>
  if(fd >= 0){
     36d:	83 c4 10             	add    $0x10,%esp
     370:	85 c0                	test   %eax,%eax
     372:	78 57                	js     3cb <writetest+0x88>
     374:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
     376:	83 ec 08             	sub    $0x8,%esp
     379:	68 8d 3c 00 00       	push   $0x3c8d
     37e:	ff 35 80 5b 00 00    	pushl  0x5b80
     384:	e8 fd 34 00 00       	call   3886 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     389:	83 c4 10             	add    $0x10,%esp
     38c:	bb 00 00 00 00       	mov    $0x0,%ebx
     391:	83 fb 63             	cmp    $0x63,%ebx
     394:	7f 7f                	jg     415 <writetest+0xd2>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     396:	83 ec 04             	sub    $0x4,%esp
     399:	6a 0a                	push   $0xa
     39b:	68 c4 3c 00 00       	push   $0x3cc4
     3a0:	56                   	push   %esi
     3a1:	e8 ae 33 00 00       	call   3754 <write>
     3a6:	83 c4 10             	add    $0x10,%esp
     3a9:	83 f8 0a             	cmp    $0xa,%eax
     3ac:	75 35                	jne    3e3 <writetest+0xa0>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     3ae:	83 ec 04             	sub    $0x4,%esp
     3b1:	6a 0a                	push   $0xa
     3b3:	68 cf 3c 00 00       	push   $0x3ccf
     3b8:	56                   	push   %esi
     3b9:	e8 96 33 00 00       	call   3754 <write>
     3be:	83 c4 10             	add    $0x10,%esp
     3c1:	83 f8 0a             	cmp    $0xa,%eax
     3c4:	75 36                	jne    3fc <writetest+0xb9>
  for(i = 0; i < 100; i++){
     3c6:	83 c3 01             	add    $0x1,%ebx
     3c9:	eb c6                	jmp    391 <writetest+0x4e>
    printf(stdout, "error: creat small failed!\n");
     3cb:	83 ec 08             	sub    $0x8,%esp
     3ce:	68 a8 3c 00 00       	push   $0x3ca8
     3d3:	ff 35 80 5b 00 00    	pushl  0x5b80
     3d9:	e8 a8 34 00 00       	call   3886 <printf>
    exit();
     3de:	e8 51 33 00 00       	call   3734 <exit>
      printf(stdout, "error: write aa %d new file failed\n", i);
     3e3:	83 ec 04             	sub    $0x4,%esp
     3e6:	53                   	push   %ebx
     3e7:	68 88 4b 00 00       	push   $0x4b88
     3ec:	ff 35 80 5b 00 00    	pushl  0x5b80
     3f2:	e8 8f 34 00 00       	call   3886 <printf>
      exit();
     3f7:	e8 38 33 00 00       	call   3734 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     3fc:	83 ec 04             	sub    $0x4,%esp
     3ff:	53                   	push   %ebx
     400:	68 ac 4b 00 00       	push   $0x4bac
     405:	ff 35 80 5b 00 00    	pushl  0x5b80
     40b:	e8 76 34 00 00       	call   3886 <printf>
      exit();
     410:	e8 1f 33 00 00       	call   3734 <exit>
    }
  }
  printf(stdout, "writes ok\n");
     415:	83 ec 08             	sub    $0x8,%esp
     418:	68 da 3c 00 00       	push   $0x3cda
     41d:	ff 35 80 5b 00 00    	pushl  0x5b80
     423:	e8 5e 34 00 00       	call   3886 <printf>
  close(fd);
     428:	89 34 24             	mov    %esi,(%esp)
     42b:	e8 2c 33 00 00       	call   375c <close>
  fd = open("small", O_RDONLY);
     430:	83 c4 08             	add    $0x8,%esp
     433:	6a 00                	push   $0x0
     435:	68 87 3c 00 00       	push   $0x3c87
     43a:	e8 35 33 00 00       	call   3774 <open>
     43f:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     441:	83 c4 10             	add    $0x10,%esp
     444:	85 c0                	test   %eax,%eax
     446:	78 7b                	js     4c3 <writetest+0x180>
    printf(stdout, "open small succeeded ok\n");
     448:	83 ec 08             	sub    $0x8,%esp
     44b:	68 e5 3c 00 00       	push   $0x3ce5
     450:	ff 35 80 5b 00 00    	pushl  0x5b80
     456:	e8 2b 34 00 00       	call   3886 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     45b:	83 c4 0c             	add    $0xc,%esp
     45e:	68 d0 07 00 00       	push   $0x7d0
     463:	68 60 83 00 00       	push   $0x8360
     468:	53                   	push   %ebx
     469:	e8 de 32 00 00       	call   374c <read>
  if(i == 2000){
     46e:	83 c4 10             	add    $0x10,%esp
     471:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     476:	75 63                	jne    4db <writetest+0x198>
    printf(stdout, "read succeeded ok\n");
     478:	83 ec 08             	sub    $0x8,%esp
     47b:	68 19 3d 00 00       	push   $0x3d19
     480:	ff 35 80 5b 00 00    	pushl  0x5b80
     486:	e8 fb 33 00 00       	call   3886 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     48b:	89 1c 24             	mov    %ebx,(%esp)
     48e:	e8 c9 32 00 00       	call   375c <close>

  if(unlink("small") < 0){
     493:	c7 04 24 87 3c 00 00 	movl   $0x3c87,(%esp)
     49a:	e8 e5 32 00 00       	call   3784 <unlink>
     49f:	83 c4 10             	add    $0x10,%esp
     4a2:	85 c0                	test   %eax,%eax
     4a4:	78 4d                	js     4f3 <writetest+0x1b0>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
     4a6:	83 ec 08             	sub    $0x8,%esp
     4a9:	68 41 3d 00 00       	push   $0x3d41
     4ae:	ff 35 80 5b 00 00    	pushl  0x5b80
     4b4:	e8 cd 33 00 00       	call   3886 <printf>
}
     4b9:	83 c4 10             	add    $0x10,%esp
     4bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
     4bf:	5b                   	pop    %ebx
     4c0:	5e                   	pop    %esi
     4c1:	5d                   	pop    %ebp
     4c2:	c3                   	ret    
    printf(stdout, "error: open small failed!\n");
     4c3:	83 ec 08             	sub    $0x8,%esp
     4c6:	68 fe 3c 00 00       	push   $0x3cfe
     4cb:	ff 35 80 5b 00 00    	pushl  0x5b80
     4d1:	e8 b0 33 00 00       	call   3886 <printf>
    exit();
     4d6:	e8 59 32 00 00       	call   3734 <exit>
    printf(stdout, "read failed\n");
     4db:	83 ec 08             	sub    $0x8,%esp
     4de:	68 45 40 00 00       	push   $0x4045
     4e3:	ff 35 80 5b 00 00    	pushl  0x5b80
     4e9:	e8 98 33 00 00       	call   3886 <printf>
    exit();
     4ee:	e8 41 32 00 00       	call   3734 <exit>
    printf(stdout, "unlink small failed\n");
     4f3:	83 ec 08             	sub    $0x8,%esp
     4f6:	68 2c 3d 00 00       	push   $0x3d2c
     4fb:	ff 35 80 5b 00 00    	pushl  0x5b80
     501:	e8 80 33 00 00       	call   3886 <printf>
    exit();
     506:	e8 29 32 00 00       	call   3734 <exit>

0000050b <writetest1>:

void
writetest1(void)
{
     50b:	55                   	push   %ebp
     50c:	89 e5                	mov    %esp,%ebp
     50e:	56                   	push   %esi
     50f:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
     510:	83 ec 08             	sub    $0x8,%esp
     513:	68 55 3d 00 00       	push   $0x3d55
     518:	ff 35 80 5b 00 00    	pushl  0x5b80
     51e:	e8 63 33 00 00       	call   3886 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     523:	83 c4 08             	add    $0x8,%esp
     526:	68 02 02 00 00       	push   $0x202
     52b:	68 cf 3d 00 00       	push   $0x3dcf
     530:	e8 3f 32 00 00       	call   3774 <open>
  if(fd < 0){
     535:	83 c4 10             	add    $0x10,%esp
     538:	85 c0                	test   %eax,%eax
     53a:	78 37                	js     573 <writetest1+0x68>
     53c:	89 c6                	mov    %eax,%esi
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     53e:	bb 00 00 00 00       	mov    $0x0,%ebx
     543:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     549:	77 59                	ja     5a4 <writetest1+0x99>
    ((int*)buf)[0] = i;
     54b:	89 1d 60 83 00 00    	mov    %ebx,0x8360
    if(write(fd, buf, 512) != 512){
     551:	83 ec 04             	sub    $0x4,%esp
     554:	68 00 02 00 00       	push   $0x200
     559:	68 60 83 00 00       	push   $0x8360
     55e:	56                   	push   %esi
     55f:	e8 f0 31 00 00       	call   3754 <write>
     564:	83 c4 10             	add    $0x10,%esp
     567:	3d 00 02 00 00       	cmp    $0x200,%eax
     56c:	75 1d                	jne    58b <writetest1+0x80>
  for(i = 0; i < MAXFILE; i++){
     56e:	83 c3 01             	add    $0x1,%ebx
     571:	eb d0                	jmp    543 <writetest1+0x38>
    printf(stdout, "error: creat big failed!\n");
     573:	83 ec 08             	sub    $0x8,%esp
     576:	68 65 3d 00 00       	push   $0x3d65
     57b:	ff 35 80 5b 00 00    	pushl  0x5b80
     581:	e8 00 33 00 00       	call   3886 <printf>
    exit();
     586:	e8 a9 31 00 00       	call   3734 <exit>
      printf(stdout, "error: write big file failed\n", i);
     58b:	83 ec 04             	sub    $0x4,%esp
     58e:	53                   	push   %ebx
     58f:	68 7f 3d 00 00       	push   $0x3d7f
     594:	ff 35 80 5b 00 00    	pushl  0x5b80
     59a:	e8 e7 32 00 00       	call   3886 <printf>
      exit();
     59f:	e8 90 31 00 00       	call   3734 <exit>
    }
  }

  close(fd);
     5a4:	83 ec 0c             	sub    $0xc,%esp
     5a7:	56                   	push   %esi
     5a8:	e8 af 31 00 00       	call   375c <close>

  fd = open("big", O_RDONLY);
     5ad:	83 c4 08             	add    $0x8,%esp
     5b0:	6a 00                	push   $0x0
     5b2:	68 cf 3d 00 00       	push   $0x3dcf
     5b7:	e8 b8 31 00 00       	call   3774 <open>
     5bc:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     5be:	83 c4 10             	add    $0x10,%esp
     5c1:	85 c0                	test   %eax,%eax
     5c3:	78 3c                	js     601 <writetest1+0xf6>
    printf(stdout, "error: open big failed!\n");
    exit();
  }

  n = 0;
     5c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(;;){
    i = read(fd, buf, 512);
     5ca:	83 ec 04             	sub    $0x4,%esp
     5cd:	68 00 02 00 00       	push   $0x200
     5d2:	68 60 83 00 00       	push   $0x8360
     5d7:	56                   	push   %esi
     5d8:	e8 6f 31 00 00       	call   374c <read>
    if(i == 0){
     5dd:	83 c4 10             	add    $0x10,%esp
     5e0:	85 c0                	test   %eax,%eax
     5e2:	74 35                	je     619 <writetest1+0x10e>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     5e4:	3d 00 02 00 00       	cmp    $0x200,%eax
     5e9:	0f 85 84 00 00 00    	jne    673 <writetest1+0x168>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
     5ef:	a1 60 83 00 00       	mov    0x8360,%eax
     5f4:	39 d8                	cmp    %ebx,%eax
     5f6:	0f 85 90 00 00 00    	jne    68c <writetest1+0x181>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     5fc:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     5ff:	eb c9                	jmp    5ca <writetest1+0xbf>
    printf(stdout, "error: open big failed!\n");
     601:	83 ec 08             	sub    $0x8,%esp
     604:	68 9d 3d 00 00       	push   $0x3d9d
     609:	ff 35 80 5b 00 00    	pushl  0x5b80
     60f:	e8 72 32 00 00       	call   3886 <printf>
    exit();
     614:	e8 1b 31 00 00       	call   3734 <exit>
      if(n == MAXFILE - 1){
     619:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     61f:	74 39                	je     65a <writetest1+0x14f>
  }
  close(fd);
     621:	83 ec 0c             	sub    $0xc,%esp
     624:	56                   	push   %esi
     625:	e8 32 31 00 00       	call   375c <close>
  if(unlink("big") < 0){
     62a:	c7 04 24 cf 3d 00 00 	movl   $0x3dcf,(%esp)
     631:	e8 4e 31 00 00       	call   3784 <unlink>
     636:	83 c4 10             	add    $0x10,%esp
     639:	85 c0                	test   %eax,%eax
     63b:	78 66                	js     6a3 <writetest1+0x198>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
     63d:	83 ec 08             	sub    $0x8,%esp
     640:	68 f6 3d 00 00       	push   $0x3df6
     645:	ff 35 80 5b 00 00    	pushl  0x5b80
     64b:	e8 36 32 00 00       	call   3886 <printf>
}
     650:	83 c4 10             	add    $0x10,%esp
     653:	8d 65 f8             	lea    -0x8(%ebp),%esp
     656:	5b                   	pop    %ebx
     657:	5e                   	pop    %esi
     658:	5d                   	pop    %ebp
     659:	c3                   	ret    
        printf(stdout, "read only %d blocks from big", n);
     65a:	83 ec 04             	sub    $0x4,%esp
     65d:	53                   	push   %ebx
     65e:	68 b6 3d 00 00       	push   $0x3db6
     663:	ff 35 80 5b 00 00    	pushl  0x5b80
     669:	e8 18 32 00 00       	call   3886 <printf>
        exit();
     66e:	e8 c1 30 00 00       	call   3734 <exit>
      printf(stdout, "read failed %d\n", i);
     673:	83 ec 04             	sub    $0x4,%esp
     676:	50                   	push   %eax
     677:	68 d3 3d 00 00       	push   $0x3dd3
     67c:	ff 35 80 5b 00 00    	pushl  0x5b80
     682:	e8 ff 31 00 00       	call   3886 <printf>
      exit();
     687:	e8 a8 30 00 00       	call   3734 <exit>
      printf(stdout, "read content of block %d is %d\n",
     68c:	50                   	push   %eax
     68d:	53                   	push   %ebx
     68e:	68 d0 4b 00 00       	push   $0x4bd0
     693:	ff 35 80 5b 00 00    	pushl  0x5b80
     699:	e8 e8 31 00 00       	call   3886 <printf>
      exit();
     69e:	e8 91 30 00 00       	call   3734 <exit>
    printf(stdout, "unlink big failed\n");
     6a3:	83 ec 08             	sub    $0x8,%esp
     6a6:	68 e3 3d 00 00       	push   $0x3de3
     6ab:	ff 35 80 5b 00 00    	pushl  0x5b80
     6b1:	e8 d0 31 00 00       	call   3886 <printf>
    exit();
     6b6:	e8 79 30 00 00       	call   3734 <exit>

000006bb <createtest>:

void
createtest(void)
{
     6bb:	55                   	push   %ebp
     6bc:	89 e5                	mov    %esp,%ebp
     6be:	53                   	push   %ebx
     6bf:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     6c2:	68 f0 4b 00 00       	push   $0x4bf0
     6c7:	ff 35 80 5b 00 00    	pushl  0x5b80
     6cd:	e8 b4 31 00 00       	call   3886 <printf>

  name[0] = 'a';
     6d2:	c6 05 60 a3 00 00 61 	movb   $0x61,0xa360
  name[2] = '\0';
     6d9:	c6 05 62 a3 00 00 00 	movb   $0x0,0xa362
  for(i = 0; i < 52; i++){
     6e0:	83 c4 10             	add    $0x10,%esp
     6e3:	bb 00 00 00 00       	mov    $0x0,%ebx
     6e8:	eb 28                	jmp    712 <createtest+0x57>
    name[1] = '0' + i;
     6ea:	8d 43 30             	lea    0x30(%ebx),%eax
     6ed:	a2 61 a3 00 00       	mov    %al,0xa361
    fd = open(name, O_CREATE|O_RDWR);
     6f2:	83 ec 08             	sub    $0x8,%esp
     6f5:	68 02 02 00 00       	push   $0x202
     6fa:	68 60 a3 00 00       	push   $0xa360
     6ff:	e8 70 30 00 00       	call   3774 <open>
    close(fd);
     704:	89 04 24             	mov    %eax,(%esp)
     707:	e8 50 30 00 00       	call   375c <close>
  for(i = 0; i < 52; i++){
     70c:	83 c3 01             	add    $0x1,%ebx
     70f:	83 c4 10             	add    $0x10,%esp
     712:	83 fb 33             	cmp    $0x33,%ebx
     715:	7e d3                	jle    6ea <createtest+0x2f>
  }
  name[0] = 'a';
     717:	c6 05 60 a3 00 00 61 	movb   $0x61,0xa360
  name[2] = '\0';
     71e:	c6 05 62 a3 00 00 00 	movb   $0x0,0xa362
  for(i = 0; i < 52; i++){
     725:	bb 00 00 00 00       	mov    $0x0,%ebx
     72a:	eb 1b                	jmp    747 <createtest+0x8c>
    name[1] = '0' + i;
     72c:	8d 43 30             	lea    0x30(%ebx),%eax
     72f:	a2 61 a3 00 00       	mov    %al,0xa361
    unlink(name);
     734:	83 ec 0c             	sub    $0xc,%esp
     737:	68 60 a3 00 00       	push   $0xa360
     73c:	e8 43 30 00 00       	call   3784 <unlink>
  for(i = 0; i < 52; i++){
     741:	83 c3 01             	add    $0x1,%ebx
     744:	83 c4 10             	add    $0x10,%esp
     747:	83 fb 33             	cmp    $0x33,%ebx
     74a:	7e e0                	jle    72c <createtest+0x71>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     74c:	83 ec 08             	sub    $0x8,%esp
     74f:	68 18 4c 00 00       	push   $0x4c18
     754:	ff 35 80 5b 00 00    	pushl  0x5b80
     75a:	e8 27 31 00 00       	call   3886 <printf>
}
     75f:	83 c4 10             	add    $0x10,%esp
     762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     765:	c9                   	leave  
     766:	c3                   	ret    

00000767 <dirtest>:

void dirtest(void)
{
     767:	55                   	push   %ebp
     768:	89 e5                	mov    %esp,%ebp
     76a:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     76d:	68 04 3e 00 00       	push   $0x3e04
     772:	ff 35 80 5b 00 00    	pushl  0x5b80
     778:	e8 09 31 00 00       	call   3886 <printf>

  if(mkdir("dir0") < 0){
     77d:	c7 04 24 10 3e 00 00 	movl   $0x3e10,(%esp)
     784:	e8 13 30 00 00       	call   379c <mkdir>
     789:	83 c4 10             	add    $0x10,%esp
     78c:	85 c0                	test   %eax,%eax
     78e:	78 54                	js     7e4 <dirtest+0x7d>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
     790:	83 ec 0c             	sub    $0xc,%esp
     793:	68 10 3e 00 00       	push   $0x3e10
     798:	e8 07 30 00 00       	call   37a4 <chdir>
     79d:	83 c4 10             	add    $0x10,%esp
     7a0:	85 c0                	test   %eax,%eax
     7a2:	78 58                	js     7fc <dirtest+0x95>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
     7a4:	83 ec 0c             	sub    $0xc,%esp
     7a7:	68 b5 43 00 00       	push   $0x43b5
     7ac:	e8 f3 2f 00 00       	call   37a4 <chdir>
     7b1:	83 c4 10             	add    $0x10,%esp
     7b4:	85 c0                	test   %eax,%eax
     7b6:	78 5c                	js     814 <dirtest+0xad>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     7b8:	83 ec 0c             	sub    $0xc,%esp
     7bb:	68 10 3e 00 00       	push   $0x3e10
     7c0:	e8 bf 2f 00 00       	call   3784 <unlink>
     7c5:	83 c4 10             	add    $0x10,%esp
     7c8:	85 c0                	test   %eax,%eax
     7ca:	78 60                	js     82c <dirtest+0xc5>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
     7cc:	83 ec 08             	sub    $0x8,%esp
     7cf:	68 4d 3e 00 00       	push   $0x3e4d
     7d4:	ff 35 80 5b 00 00    	pushl  0x5b80
     7da:	e8 a7 30 00 00       	call   3886 <printf>
}
     7df:	83 c4 10             	add    $0x10,%esp
     7e2:	c9                   	leave  
     7e3:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     7e4:	83 ec 08             	sub    $0x8,%esp
     7e7:	68 40 3b 00 00       	push   $0x3b40
     7ec:	ff 35 80 5b 00 00    	pushl  0x5b80
     7f2:	e8 8f 30 00 00       	call   3886 <printf>
    exit();
     7f7:	e8 38 2f 00 00       	call   3734 <exit>
    printf(stdout, "chdir dir0 failed\n");
     7fc:	83 ec 08             	sub    $0x8,%esp
     7ff:	68 15 3e 00 00       	push   $0x3e15
     804:	ff 35 80 5b 00 00    	pushl  0x5b80
     80a:	e8 77 30 00 00       	call   3886 <printf>
    exit();
     80f:	e8 20 2f 00 00       	call   3734 <exit>
    printf(stdout, "chdir .. failed\n");
     814:	83 ec 08             	sub    $0x8,%esp
     817:	68 28 3e 00 00       	push   $0x3e28
     81c:	ff 35 80 5b 00 00    	pushl  0x5b80
     822:	e8 5f 30 00 00       	call   3886 <printf>
    exit();
     827:	e8 08 2f 00 00       	call   3734 <exit>
    printf(stdout, "unlink dir0 failed\n");
     82c:	83 ec 08             	sub    $0x8,%esp
     82f:	68 39 3e 00 00       	push   $0x3e39
     834:	ff 35 80 5b 00 00    	pushl  0x5b80
     83a:	e8 47 30 00 00       	call   3886 <printf>
    exit();
     83f:	e8 f0 2e 00 00       	call   3734 <exit>

00000844 <exectest>:

void
exectest(void)
{
     844:	55                   	push   %ebp
     845:	89 e5                	mov    %esp,%ebp
     847:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     84a:	68 5c 3e 00 00       	push   $0x3e5c
     84f:	ff 35 80 5b 00 00    	pushl  0x5b80
     855:	e8 2c 30 00 00       	call   3886 <printf>
  if(exec("echo", echoargv) < 0){
     85a:	83 c4 08             	add    $0x8,%esp
     85d:	68 84 5b 00 00       	push   $0x5b84
     862:	68 25 3c 00 00       	push   $0x3c25
     867:	e8 00 2f 00 00       	call   376c <exec>
     86c:	83 c4 10             	add    $0x10,%esp
     86f:	85 c0                	test   %eax,%eax
     871:	78 02                	js     875 <exectest+0x31>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
     873:	c9                   	leave  
     874:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     875:	83 ec 08             	sub    $0x8,%esp
     878:	68 67 3e 00 00       	push   $0x3e67
     87d:	ff 35 80 5b 00 00    	pushl  0x5b80
     883:	e8 fe 2f 00 00       	call   3886 <printf>
    exit();
     888:	e8 a7 2e 00 00       	call   3734 <exit>

0000088d <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     88d:	55                   	push   %ebp
     88e:	89 e5                	mov    %esp,%ebp
     890:	57                   	push   %edi
     891:	56                   	push   %esi
     892:	53                   	push   %ebx
     893:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     896:	8d 45 e0             	lea    -0x20(%ebp),%eax
     899:	50                   	push   %eax
     89a:	e8 a5 2e 00 00       	call   3744 <pipe>
     89f:	83 c4 10             	add    $0x10,%esp
     8a2:	85 c0                	test   %eax,%eax
     8a4:	75 74                	jne    91a <pipe1+0x8d>
     8a6:	89 c6                	mov    %eax,%esi
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
     8a8:	e8 7f 2e 00 00       	call   372c <fork>
     8ad:	89 c7                	mov    %eax,%edi
  seq = 0;
  if(pid == 0){
     8af:	85 c0                	test   %eax,%eax
     8b1:	74 7b                	je     92e <pipe1+0xa1>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
     8b3:	85 c0                	test   %eax,%eax
     8b5:	0f 8e 5e 01 00 00    	jle    a19 <pipe1+0x18c>
    close(fds[1]);
     8bb:	83 ec 0c             	sub    $0xc,%esp
     8be:	ff 75 e4             	pushl  -0x1c(%ebp)
     8c1:	e8 96 2e 00 00       	call   375c <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     8c6:	83 c4 10             	add    $0x10,%esp
    total = 0;
     8c9:	89 75 d0             	mov    %esi,-0x30(%ebp)
  seq = 0;
     8cc:	89 f3                	mov    %esi,%ebx
    cc = 1;
     8ce:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     8d5:	83 ec 04             	sub    $0x4,%esp
     8d8:	ff 75 d4             	pushl  -0x2c(%ebp)
     8db:	68 60 83 00 00       	push   $0x8360
     8e0:	ff 75 e0             	pushl  -0x20(%ebp)
     8e3:	e8 64 2e 00 00       	call   374c <read>
     8e8:	83 c4 10             	add    $0x10,%esp
     8eb:	85 c0                	test   %eax,%eax
     8ed:	0f 8e e2 00 00 00    	jle    9d5 <pipe1+0x148>
      for(i = 0; i < n; i++){
     8f3:	89 f2                	mov    %esi,%edx
     8f5:	89 df                	mov    %ebx,%edi
     8f7:	39 c2                	cmp    %eax,%edx
     8f9:	0f 8d b4 00 00 00    	jge    9b3 <pipe1+0x126>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     8ff:	0f be 9a 60 83 00 00 	movsbl 0x8360(%edx),%ebx
     906:	8d 4f 01             	lea    0x1(%edi),%ecx
     909:	31 fb                	xor    %edi,%ebx
     90b:	84 db                	test   %bl,%bl
     90d:	0f 85 86 00 00 00    	jne    999 <pipe1+0x10c>
      for(i = 0; i < n; i++){
     913:	83 c2 01             	add    $0x1,%edx
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     916:	89 cf                	mov    %ecx,%edi
     918:	eb dd                	jmp    8f7 <pipe1+0x6a>
    printf(1, "pipe() failed\n");
     91a:	83 ec 08             	sub    $0x8,%esp
     91d:	68 79 3e 00 00       	push   $0x3e79
     922:	6a 01                	push   $0x1
     924:	e8 5d 2f 00 00       	call   3886 <printf>
    exit();
     929:	e8 06 2e 00 00       	call   3734 <exit>
    close(fds[0]);
     92e:	83 ec 0c             	sub    $0xc,%esp
     931:	ff 75 e0             	pushl  -0x20(%ebp)
     934:	e8 23 2e 00 00       	call   375c <close>
    for(n = 0; n < 5; n++){
     939:	83 c4 10             	add    $0x10,%esp
     93c:	89 fe                	mov    %edi,%esi
  seq = 0;
     93e:	89 fb                	mov    %edi,%ebx
    for(n = 0; n < 5; n++){
     940:	eb 35                	jmp    977 <pipe1+0xea>
        buf[i] = seq++;
     942:	88 98 60 83 00 00    	mov    %bl,0x8360(%eax)
      for(i = 0; i < 1033; i++)
     948:	83 c0 01             	add    $0x1,%eax
        buf[i] = seq++;
     94b:	8d 5b 01             	lea    0x1(%ebx),%ebx
      for(i = 0; i < 1033; i++)
     94e:	3d 08 04 00 00       	cmp    $0x408,%eax
     953:	7e ed                	jle    942 <pipe1+0xb5>
      if(write(fds[1], buf, 1033) != 1033){
     955:	83 ec 04             	sub    $0x4,%esp
     958:	68 09 04 00 00       	push   $0x409
     95d:	68 60 83 00 00       	push   $0x8360
     962:	ff 75 e4             	pushl  -0x1c(%ebp)
     965:	e8 ea 2d 00 00       	call   3754 <write>
     96a:	83 c4 10             	add    $0x10,%esp
     96d:	3d 09 04 00 00       	cmp    $0x409,%eax
     972:	75 0c                	jne    980 <pipe1+0xf3>
    for(n = 0; n < 5; n++){
     974:	83 c6 01             	add    $0x1,%esi
     977:	83 fe 04             	cmp    $0x4,%esi
     97a:	7f 18                	jg     994 <pipe1+0x107>
      for(i = 0; i < 1033; i++)
     97c:	89 f8                	mov    %edi,%eax
     97e:	eb ce                	jmp    94e <pipe1+0xc1>
        printf(1, "pipe1 oops 1\n");
     980:	83 ec 08             	sub    $0x8,%esp
     983:	68 88 3e 00 00       	push   $0x3e88
     988:	6a 01                	push   $0x1
     98a:	e8 f7 2e 00 00       	call   3886 <printf>
        exit();
     98f:	e8 a0 2d 00 00       	call   3734 <exit>
    exit();
     994:	e8 9b 2d 00 00       	call   3734 <exit>
          printf(1, "pipe1 oops 2\n");
     999:	83 ec 08             	sub    $0x8,%esp
     99c:	68 96 3e 00 00       	push   $0x3e96
     9a1:	6a 01                	push   $0x1
     9a3:	e8 de 2e 00 00       	call   3886 <printf>
          return;
     9a8:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
     9ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9ae:	5b                   	pop    %ebx
     9af:	5e                   	pop    %esi
     9b0:	5f                   	pop    %edi
     9b1:	5d                   	pop    %ebp
     9b2:	c3                   	ret    
     9b3:	89 fb                	mov    %edi,%ebx
      total += n;
     9b5:	01 45 d0             	add    %eax,-0x30(%ebp)
      cc = cc * 2;
     9b8:	d1 65 d4             	shll   -0x2c(%ebp)
     9bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      if(cc > sizeof(buf))
     9be:	3d 00 20 00 00       	cmp    $0x2000,%eax
     9c3:	0f 86 0c ff ff ff    	jbe    8d5 <pipe1+0x48>
        cc = sizeof(buf);
     9c9:	c7 45 d4 00 20 00 00 	movl   $0x2000,-0x2c(%ebp)
     9d0:	e9 00 ff ff ff       	jmp    8d5 <pipe1+0x48>
    if(total != 5 * 1033){
     9d5:	81 7d d0 2d 14 00 00 	cmpl   $0x142d,-0x30(%ebp)
     9dc:	75 24                	jne    a02 <pipe1+0x175>
    close(fds[0]);
     9de:	83 ec 0c             	sub    $0xc,%esp
     9e1:	ff 75 e0             	pushl  -0x20(%ebp)
     9e4:	e8 73 2d 00 00       	call   375c <close>
    wait();
     9e9:	e8 4e 2d 00 00       	call   373c <wait>
  printf(1, "pipe1 ok\n");
     9ee:	83 c4 08             	add    $0x8,%esp
     9f1:	68 bb 3e 00 00       	push   $0x3ebb
     9f6:	6a 01                	push   $0x1
     9f8:	e8 89 2e 00 00       	call   3886 <printf>
     9fd:	83 c4 10             	add    $0x10,%esp
     a00:	eb a9                	jmp    9ab <pipe1+0x11e>
      printf(1, "pipe1 oops 3 total %d\n", total);
     a02:	83 ec 04             	sub    $0x4,%esp
     a05:	ff 75 d0             	pushl  -0x30(%ebp)
     a08:	68 a4 3e 00 00       	push   $0x3ea4
     a0d:	6a 01                	push   $0x1
     a0f:	e8 72 2e 00 00       	call   3886 <printf>
      exit();
     a14:	e8 1b 2d 00 00       	call   3734 <exit>
    printf(1, "fork() failed\n");
     a19:	83 ec 08             	sub    $0x8,%esp
     a1c:	68 c5 3e 00 00       	push   $0x3ec5
     a21:	6a 01                	push   $0x1
     a23:	e8 5e 2e 00 00       	call   3886 <printf>
    exit();
     a28:	e8 07 2d 00 00       	call   3734 <exit>

00000a2d <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     a2d:	55                   	push   %ebp
     a2e:	89 e5                	mov    %esp,%ebp
     a30:	57                   	push   %edi
     a31:	56                   	push   %esi
     a32:	53                   	push   %ebx
     a33:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     a36:	68 d4 3e 00 00       	push   $0x3ed4
     a3b:	6a 01                	push   $0x1
     a3d:	e8 44 2e 00 00       	call   3886 <printf>
  pid1 = fork();
     a42:	e8 e5 2c 00 00       	call   372c <fork>
  if(pid1 == 0)
     a47:	83 c4 10             	add    $0x10,%esp
     a4a:	85 c0                	test   %eax,%eax
     a4c:	75 02                	jne    a50 <preempt+0x23>
     a4e:	eb fe                	jmp    a4e <preempt+0x21>
     a50:	89 c7                	mov    %eax,%edi
    for(;;)
      ;

  pid2 = fork();
     a52:	e8 d5 2c 00 00       	call   372c <fork>
     a57:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     a59:	85 c0                	test   %eax,%eax
     a5b:	75 02                	jne    a5f <preempt+0x32>
     a5d:	eb fe                	jmp    a5d <preempt+0x30>
    for(;;)
      ;

  pipe(pfds);
     a5f:	83 ec 0c             	sub    $0xc,%esp
     a62:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a65:	50                   	push   %eax
     a66:	e8 d9 2c 00 00       	call   3744 <pipe>
  pid3 = fork();
     a6b:	e8 bc 2c 00 00       	call   372c <fork>
     a70:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     a72:	83 c4 10             	add    $0x10,%esp
     a75:	85 c0                	test   %eax,%eax
     a77:	75 47                	jne    ac0 <preempt+0x93>
    close(pfds[0]);
     a79:	83 ec 0c             	sub    $0xc,%esp
     a7c:	ff 75 e0             	pushl  -0x20(%ebp)
     a7f:	e8 d8 2c 00 00       	call   375c <close>
    if(write(pfds[1], "x", 1) != 1)
     a84:	83 c4 0c             	add    $0xc,%esp
     a87:	6a 01                	push   $0x1
     a89:	68 99 44 00 00       	push   $0x4499
     a8e:	ff 75 e4             	pushl  -0x1c(%ebp)
     a91:	e8 be 2c 00 00       	call   3754 <write>
     a96:	83 c4 10             	add    $0x10,%esp
     a99:	83 f8 01             	cmp    $0x1,%eax
     a9c:	74 12                	je     ab0 <preempt+0x83>
      printf(1, "preempt write error");
     a9e:	83 ec 08             	sub    $0x8,%esp
     aa1:	68 de 3e 00 00       	push   $0x3ede
     aa6:	6a 01                	push   $0x1
     aa8:	e8 d9 2d 00 00       	call   3886 <printf>
     aad:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     ab0:	83 ec 0c             	sub    $0xc,%esp
     ab3:	ff 75 e4             	pushl  -0x1c(%ebp)
     ab6:	e8 a1 2c 00 00       	call   375c <close>
     abb:	83 c4 10             	add    $0x10,%esp
     abe:	eb fe                	jmp    abe <preempt+0x91>
    for(;;)
      ;
  }

  close(pfds[1]);
     ac0:	83 ec 0c             	sub    $0xc,%esp
     ac3:	ff 75 e4             	pushl  -0x1c(%ebp)
     ac6:	e8 91 2c 00 00       	call   375c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     acb:	83 c4 0c             	add    $0xc,%esp
     ace:	68 00 20 00 00       	push   $0x2000
     ad3:	68 60 83 00 00       	push   $0x8360
     ad8:	ff 75 e0             	pushl  -0x20(%ebp)
     adb:	e8 6c 2c 00 00       	call   374c <read>
     ae0:	83 c4 10             	add    $0x10,%esp
     ae3:	83 f8 01             	cmp    $0x1,%eax
     ae6:	74 1a                	je     b02 <preempt+0xd5>
    printf(1, "preempt read error");
     ae8:	83 ec 08             	sub    $0x8,%esp
     aeb:	68 f2 3e 00 00       	push   $0x3ef2
     af0:	6a 01                	push   $0x1
     af2:	e8 8f 2d 00 00       	call   3886 <printf>
    return;
     af7:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
     afa:	8d 65 f4             	lea    -0xc(%ebp),%esp
     afd:	5b                   	pop    %ebx
     afe:	5e                   	pop    %esi
     aff:	5f                   	pop    %edi
     b00:	5d                   	pop    %ebp
     b01:	c3                   	ret    
  close(pfds[0]);
     b02:	83 ec 0c             	sub    $0xc,%esp
     b05:	ff 75 e0             	pushl  -0x20(%ebp)
     b08:	e8 4f 2c 00 00       	call   375c <close>
  printf(1, "kill... ");
     b0d:	83 c4 08             	add    $0x8,%esp
     b10:	68 05 3f 00 00       	push   $0x3f05
     b15:	6a 01                	push   $0x1
     b17:	e8 6a 2d 00 00       	call   3886 <printf>
  kill(pid1, SIGKILL);
     b1c:	83 c4 08             	add    $0x8,%esp
     b1f:	6a 09                	push   $0x9
     b21:	57                   	push   %edi
     b22:	e8 3d 2c 00 00       	call   3764 <kill>
  kill(pid2, SIGKILL);
     b27:	83 c4 08             	add    $0x8,%esp
     b2a:	6a 09                	push   $0x9
     b2c:	56                   	push   %esi
     b2d:	e8 32 2c 00 00       	call   3764 <kill>
  kill(pid3, SIGKILL);
     b32:	83 c4 08             	add    $0x8,%esp
     b35:	6a 09                	push   $0x9
     b37:	53                   	push   %ebx
     b38:	e8 27 2c 00 00       	call   3764 <kill>
  printf(1, "wait... ");
     b3d:	83 c4 08             	add    $0x8,%esp
     b40:	68 0e 3f 00 00       	push   $0x3f0e
     b45:	6a 01                	push   $0x1
     b47:	e8 3a 2d 00 00       	call   3886 <printf>
  wait();
     b4c:	e8 eb 2b 00 00       	call   373c <wait>
  wait();
     b51:	e8 e6 2b 00 00       	call   373c <wait>
  wait();
     b56:	e8 e1 2b 00 00       	call   373c <wait>
  printf(1, "preempt ok\n");
     b5b:	83 c4 08             	add    $0x8,%esp
     b5e:	68 17 3f 00 00       	push   $0x3f17
     b63:	6a 01                	push   $0x1
     b65:	e8 1c 2d 00 00       	call   3886 <printf>
     b6a:	83 c4 10             	add    $0x10,%esp
     b6d:	eb 8b                	jmp    afa <preempt+0xcd>

00000b6f <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     b6f:	55                   	push   %ebp
     b70:	89 e5                	mov    %esp,%ebp
     b72:	56                   	push   %esi
     b73:	53                   	push   %ebx
  int i, pid;

  for(i = 0; i < 100; i++){
     b74:	be 00 00 00 00       	mov    $0x0,%esi
     b79:	83 fe 63             	cmp    $0x63,%esi
     b7c:	7f 4f                	jg     bcd <exitwait+0x5e>
    pid = fork();
     b7e:	e8 a9 2b 00 00       	call   372c <fork>
     b83:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     b85:	85 c0                	test   %eax,%eax
     b87:	78 12                	js     b9b <exitwait+0x2c>
      printf(1, "fork failed\n");
      return;
    }
    if(pid){
     b89:	85 c0                	test   %eax,%eax
     b8b:	74 3b                	je     bc8 <exitwait+0x59>
      if(wait() != pid){
     b8d:	e8 aa 2b 00 00       	call   373c <wait>
     b92:	39 d8                	cmp    %ebx,%eax
     b94:	75 1e                	jne    bb4 <exitwait+0x45>
  for(i = 0; i < 100; i++){
     b96:	83 c6 01             	add    $0x1,%esi
     b99:	eb de                	jmp    b79 <exitwait+0xa>
      printf(1, "fork failed\n");
     b9b:	83 ec 08             	sub    $0x8,%esp
     b9e:	68 81 4a 00 00       	push   $0x4a81
     ba3:	6a 01                	push   $0x1
     ba5:	e8 dc 2c 00 00       	call   3886 <printf>
      return;
     baa:	83 c4 10             	add    $0x10,%esp
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     bad:	8d 65 f8             	lea    -0x8(%ebp),%esp
     bb0:	5b                   	pop    %ebx
     bb1:	5e                   	pop    %esi
     bb2:	5d                   	pop    %ebp
     bb3:	c3                   	ret    
        printf(1, "wait wrong pid\n");
     bb4:	83 ec 08             	sub    $0x8,%esp
     bb7:	68 23 3f 00 00       	push   $0x3f23
     bbc:	6a 01                	push   $0x1
     bbe:	e8 c3 2c 00 00       	call   3886 <printf>
        return;
     bc3:	83 c4 10             	add    $0x10,%esp
     bc6:	eb e5                	jmp    bad <exitwait+0x3e>
      exit();
     bc8:	e8 67 2b 00 00       	call   3734 <exit>
  printf(1, "exitwait ok\n");
     bcd:	83 ec 08             	sub    $0x8,%esp
     bd0:	68 33 3f 00 00       	push   $0x3f33
     bd5:	6a 01                	push   $0x1
     bd7:	e8 aa 2c 00 00       	call   3886 <printf>
     bdc:	83 c4 10             	add    $0x10,%esp
     bdf:	eb cc                	jmp    bad <exitwait+0x3e>

00000be1 <mem>:

void
mem(void)
{
     be1:	55                   	push   %ebp
     be2:	89 e5                	mov    %esp,%ebp
     be4:	57                   	push   %edi
     be5:	56                   	push   %esi
     be6:	53                   	push   %ebx
     be7:	83 ec 14             	sub    $0x14,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     bea:	68 40 3f 00 00       	push   $0x3f40
     bef:	6a 01                	push   $0x1
     bf1:	e8 90 2c 00 00       	call   3886 <printf>
  ppid = getpid();
     bf6:	e8 b9 2b 00 00       	call   37b4 <getpid>
     bfb:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     bfd:	e8 2a 2b 00 00       	call   372c <fork>
     c02:	83 c4 10             	add    $0x10,%esp
     c05:	85 c0                	test   %eax,%eax
     c07:	0f 85 85 00 00 00    	jne    c92 <mem+0xb1>
    m1 = 0;
     c0d:	bb 00 00 00 00       	mov    $0x0,%ebx
     c12:	eb 04                	jmp    c18 <mem+0x37>
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
     c14:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
     c16:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     c18:	83 ec 0c             	sub    $0xc,%esp
     c1b:	68 11 27 00 00       	push   $0x2711
     c20:	e8 8a 2e 00 00       	call   3aaf <malloc>
     c25:	83 c4 10             	add    $0x10,%esp
     c28:	85 c0                	test   %eax,%eax
     c2a:	75 e8                	jne    c14 <mem+0x33>
     c2c:	eb 10                	jmp    c3e <mem+0x5d>
    }
    while(m1){
      m2 = *(char**)m1;
     c2e:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     c30:	83 ec 0c             	sub    $0xc,%esp
     c33:	53                   	push   %ebx
     c34:	e8 b6 2d 00 00       	call   39ef <free>
      m1 = m2;
     c39:	83 c4 10             	add    $0x10,%esp
     c3c:	89 fb                	mov    %edi,%ebx
    while(m1){
     c3e:	85 db                	test   %ebx,%ebx
     c40:	75 ec                	jne    c2e <mem+0x4d>
    }
    m1 = malloc(1024*20);
     c42:	83 ec 0c             	sub    $0xc,%esp
     c45:	68 00 50 00 00       	push   $0x5000
     c4a:	e8 60 2e 00 00       	call   3aaf <malloc>
    if(m1 == 0){
     c4f:	83 c4 10             	add    $0x10,%esp
     c52:	85 c0                	test   %eax,%eax
     c54:	74 1d                	je     c73 <mem+0x92>
      printf(1, "couldn't allocate mem?!!\n");
      kill(ppid, SIGKILL);
      exit();
    }
    free(m1);
     c56:	83 ec 0c             	sub    $0xc,%esp
     c59:	50                   	push   %eax
     c5a:	e8 90 2d 00 00       	call   39ef <free>
    printf(1, "mem ok\n");
     c5f:	83 c4 08             	add    $0x8,%esp
     c62:	68 64 3f 00 00       	push   $0x3f64
     c67:	6a 01                	push   $0x1
     c69:	e8 18 2c 00 00       	call   3886 <printf>
    exit();
     c6e:	e8 c1 2a 00 00       	call   3734 <exit>
      printf(1, "couldn't allocate mem?!!\n");
     c73:	83 ec 08             	sub    $0x8,%esp
     c76:	68 4a 3f 00 00       	push   $0x3f4a
     c7b:	6a 01                	push   $0x1
     c7d:	e8 04 2c 00 00       	call   3886 <printf>
      kill(ppid, SIGKILL);
     c82:	83 c4 08             	add    $0x8,%esp
     c85:	6a 09                	push   $0x9
     c87:	56                   	push   %esi
     c88:	e8 d7 2a 00 00       	call   3764 <kill>
      exit();
     c8d:	e8 a2 2a 00 00       	call   3734 <exit>
  } else {
    wait();
     c92:	e8 a5 2a 00 00       	call   373c <wait>
  }
}
     c97:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c9a:	5b                   	pop    %ebx
     c9b:	5e                   	pop    %esi
     c9c:	5f                   	pop    %edi
     c9d:	5d                   	pop    %ebp
     c9e:	c3                   	ret    

00000c9f <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     c9f:	55                   	push   %ebp
     ca0:	89 e5                	mov    %esp,%ebp
     ca2:	57                   	push   %edi
     ca3:	56                   	push   %esi
     ca4:	53                   	push   %ebx
     ca5:	83 ec 24             	sub    $0x24,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     ca8:	68 6c 3f 00 00       	push   $0x3f6c
     cad:	6a 01                	push   $0x1
     caf:	e8 d2 2b 00 00       	call   3886 <printf>

  unlink("sharedfd");
     cb4:	c7 04 24 7b 3f 00 00 	movl   $0x3f7b,(%esp)
     cbb:	e8 c4 2a 00 00       	call   3784 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     cc0:	83 c4 08             	add    $0x8,%esp
     cc3:	68 02 02 00 00       	push   $0x202
     cc8:	68 7b 3f 00 00       	push   $0x3f7b
     ccd:	e8 a2 2a 00 00       	call   3774 <open>
  if(fd < 0){
     cd2:	83 c4 10             	add    $0x10,%esp
     cd5:	85 c0                	test   %eax,%eax
     cd7:	78 4d                	js     d26 <sharedfd+0x87>
     cd9:	89 c6                	mov    %eax,%esi
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     cdb:	e8 4c 2a 00 00       	call   372c <fork>
     ce0:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ce2:	85 c0                	test   %eax,%eax
     ce4:	75 57                	jne    d3d <sharedfd+0x9e>
     ce6:	b8 63 00 00 00       	mov    $0x63,%eax
     ceb:	83 ec 04             	sub    $0x4,%esp
     cee:	6a 0a                	push   $0xa
     cf0:	50                   	push   %eax
     cf1:	8d 45 de             	lea    -0x22(%ebp),%eax
     cf4:	50                   	push   %eax
     cf5:	e8 0b 29 00 00       	call   3605 <memset>
  for(i = 0; i < 1000; i++){
     cfa:	83 c4 10             	add    $0x10,%esp
     cfd:	bb 00 00 00 00       	mov    $0x0,%ebx
     d02:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
     d08:	7f 4c                	jg     d56 <sharedfd+0xb7>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     d0a:	83 ec 04             	sub    $0x4,%esp
     d0d:	6a 0a                	push   $0xa
     d0f:	8d 45 de             	lea    -0x22(%ebp),%eax
     d12:	50                   	push   %eax
     d13:	56                   	push   %esi
     d14:	e8 3b 2a 00 00       	call   3754 <write>
     d19:	83 c4 10             	add    $0x10,%esp
     d1c:	83 f8 0a             	cmp    $0xa,%eax
     d1f:	75 23                	jne    d44 <sharedfd+0xa5>
  for(i = 0; i < 1000; i++){
     d21:	83 c3 01             	add    $0x1,%ebx
     d24:	eb dc                	jmp    d02 <sharedfd+0x63>
    printf(1, "fstests: cannot open sharedfd for writing");
     d26:	83 ec 08             	sub    $0x8,%esp
     d29:	68 40 4c 00 00       	push   $0x4c40
     d2e:	6a 01                	push   $0x1
     d30:	e8 51 2b 00 00       	call   3886 <printf>
    return;
     d35:	83 c4 10             	add    $0x10,%esp
     d38:	e9 e4 00 00 00       	jmp    e21 <sharedfd+0x182>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     d3d:	b8 70 00 00 00       	mov    $0x70,%eax
     d42:	eb a7                	jmp    ceb <sharedfd+0x4c>
      printf(1, "fstests: write sharedfd failed\n");
     d44:	83 ec 08             	sub    $0x8,%esp
     d47:	68 6c 4c 00 00       	push   $0x4c6c
     d4c:	6a 01                	push   $0x1
     d4e:	e8 33 2b 00 00       	call   3886 <printf>
      break;
     d53:	83 c4 10             	add    $0x10,%esp
    }
  }
  if(pid == 0)
     d56:	85 ff                	test   %edi,%edi
     d58:	74 4d                	je     da7 <sharedfd+0x108>
    exit();
  else
    wait();
     d5a:	e8 dd 29 00 00       	call   373c <wait>
  close(fd);
     d5f:	83 ec 0c             	sub    $0xc,%esp
     d62:	56                   	push   %esi
     d63:	e8 f4 29 00 00       	call   375c <close>
  fd = open("sharedfd", 0);
     d68:	83 c4 08             	add    $0x8,%esp
     d6b:	6a 00                	push   $0x0
     d6d:	68 7b 3f 00 00       	push   $0x3f7b
     d72:	e8 fd 29 00 00       	call   3774 <open>
     d77:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     d79:	83 c4 10             	add    $0x10,%esp
     d7c:	85 c0                	test   %eax,%eax
     d7e:	78 2c                	js     dac <sharedfd+0x10d>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
     d80:	be 00 00 00 00       	mov    $0x0,%esi
     d85:	bb 00 00 00 00       	mov    $0x0,%ebx
  while((n = read(fd, buf, sizeof(buf))) > 0){
     d8a:	83 ec 04             	sub    $0x4,%esp
     d8d:	6a 0a                	push   $0xa
     d8f:	8d 45 de             	lea    -0x22(%ebp),%eax
     d92:	50                   	push   %eax
     d93:	57                   	push   %edi
     d94:	e8 b3 29 00 00       	call   374c <read>
     d99:	83 c4 10             	add    $0x10,%esp
     d9c:	85 c0                	test   %eax,%eax
     d9e:	7e 41                	jle    de1 <sharedfd+0x142>
    for(i = 0; i < sizeof(buf); i++){
     da0:	b8 00 00 00 00       	mov    $0x0,%eax
     da5:	eb 21                	jmp    dc8 <sharedfd+0x129>
    exit();
     da7:	e8 88 29 00 00       	call   3734 <exit>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     dac:	83 ec 08             	sub    $0x8,%esp
     daf:	68 8c 4c 00 00       	push   $0x4c8c
     db4:	6a 01                	push   $0x1
     db6:	e8 cb 2a 00 00       	call   3886 <printf>
    return;
     dbb:	83 c4 10             	add    $0x10,%esp
     dbe:	eb 61                	jmp    e21 <sharedfd+0x182>
      if(buf[i] == 'c')
        nc++;
     dc0:	83 c3 01             	add    $0x1,%ebx
     dc3:	eb 12                	jmp    dd7 <sharedfd+0x138>
    for(i = 0; i < sizeof(buf); i++){
     dc5:	83 c0 01             	add    $0x1,%eax
     dc8:	83 f8 09             	cmp    $0x9,%eax
     dcb:	77 bd                	ja     d8a <sharedfd+0xeb>
      if(buf[i] == 'c')
     dcd:	0f b6 54 05 de       	movzbl -0x22(%ebp,%eax,1),%edx
     dd2:	80 fa 63             	cmp    $0x63,%dl
     dd5:	74 e9                	je     dc0 <sharedfd+0x121>
      if(buf[i] == 'p')
     dd7:	80 fa 70             	cmp    $0x70,%dl
     dda:	75 e9                	jne    dc5 <sharedfd+0x126>
        np++;
     ddc:	83 c6 01             	add    $0x1,%esi
     ddf:	eb e4                	jmp    dc5 <sharedfd+0x126>
    }
  }
  close(fd);
     de1:	83 ec 0c             	sub    $0xc,%esp
     de4:	57                   	push   %edi
     de5:	e8 72 29 00 00       	call   375c <close>
  unlink("sharedfd");
     dea:	c7 04 24 7b 3f 00 00 	movl   $0x3f7b,(%esp)
     df1:	e8 8e 29 00 00       	call   3784 <unlink>
  if(nc == 10000 && np == 10000){
     df6:	83 c4 10             	add    $0x10,%esp
     df9:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     dff:	0f 94 c2             	sete   %dl
     e02:	81 fe 10 27 00 00    	cmp    $0x2710,%esi
     e08:	0f 94 c0             	sete   %al
     e0b:	84 c2                	test   %al,%dl
     e0d:	74 1a                	je     e29 <sharedfd+0x18a>
    printf(1, "sharedfd ok\n");
     e0f:	83 ec 08             	sub    $0x8,%esp
     e12:	68 84 3f 00 00       	push   $0x3f84
     e17:	6a 01                	push   $0x1
     e19:	e8 68 2a 00 00       	call   3886 <printf>
     e1e:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
     e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e24:	5b                   	pop    %ebx
     e25:	5e                   	pop    %esi
     e26:	5f                   	pop    %edi
     e27:	5d                   	pop    %ebp
     e28:	c3                   	ret    
    printf(1, "sharedfd oops %d %d\n", nc, np);
     e29:	56                   	push   %esi
     e2a:	53                   	push   %ebx
     e2b:	68 91 3f 00 00       	push   $0x3f91
     e30:	6a 01                	push   $0x1
     e32:	e8 4f 2a 00 00       	call   3886 <printf>
    exit();
     e37:	e8 f8 28 00 00       	call   3734 <exit>

00000e3c <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     e3c:	55                   	push   %ebp
     e3d:	89 e5                	mov    %esp,%ebp
     e3f:	57                   	push   %edi
     e40:	56                   	push   %esi
     e41:	53                   	push   %ebx
     e42:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     e45:	c7 45 d8 a6 3f 00 00 	movl   $0x3fa6,-0x28(%ebp)
     e4c:	c7 45 dc ef 40 00 00 	movl   $0x40ef,-0x24(%ebp)
     e53:	c7 45 e0 f3 40 00 00 	movl   $0x40f3,-0x20(%ebp)
     e5a:	c7 45 e4 a9 3f 00 00 	movl   $0x3fa9,-0x1c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
     e61:	68 ac 3f 00 00       	push   $0x3fac
     e66:	6a 01                	push   $0x1
     e68:	e8 19 2a 00 00       	call   3886 <printf>

  for(pi = 0; pi < 4; pi++){
     e6d:	83 c4 10             	add    $0x10,%esp
     e70:	be 00 00 00 00       	mov    $0x0,%esi
     e75:	83 fe 03             	cmp    $0x3,%esi
     e78:	0f 8f bd 00 00 00    	jg     f3b <fourfiles+0xff>
    fname = names[pi];
     e7e:	8b 7c b5 d8          	mov    -0x28(%ebp,%esi,4),%edi
    unlink(fname);
     e82:	83 ec 0c             	sub    $0xc,%esp
     e85:	57                   	push   %edi
     e86:	e8 f9 28 00 00       	call   3784 <unlink>

    pid = fork();
     e8b:	e8 9c 28 00 00       	call   372c <fork>
    if(pid < 0){
     e90:	83 c4 10             	add    $0x10,%esp
     e93:	85 c0                	test   %eax,%eax
     e95:	78 09                	js     ea0 <fourfiles+0x64>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
     e97:	85 c0                	test   %eax,%eax
     e99:	74 19                	je     eb4 <fourfiles+0x78>
  for(pi = 0; pi < 4; pi++){
     e9b:	83 c6 01             	add    $0x1,%esi
     e9e:	eb d5                	jmp    e75 <fourfiles+0x39>
      printf(1, "fork failed\n");
     ea0:	83 ec 08             	sub    $0x8,%esp
     ea3:	68 81 4a 00 00       	push   $0x4a81
     ea8:	6a 01                	push   $0x1
     eaa:	e8 d7 29 00 00       	call   3886 <printf>
      exit();
     eaf:	e8 80 28 00 00       	call   3734 <exit>
     eb4:	89 c3                	mov    %eax,%ebx
      fd = open(fname, O_CREATE | O_RDWR);
     eb6:	83 ec 08             	sub    $0x8,%esp
     eb9:	68 02 02 00 00       	push   $0x202
     ebe:	57                   	push   %edi
     ebf:	e8 b0 28 00 00       	call   3774 <open>
     ec4:	89 c7                	mov    %eax,%edi
      if(fd < 0){
     ec6:	83 c4 10             	add    $0x10,%esp
     ec9:	85 c0                	test   %eax,%eax
     ecb:	78 1b                	js     ee8 <fourfiles+0xac>
        printf(1, "create failed\n");
        exit();
      }

      memset(buf, '0'+pi, 512);
     ecd:	83 ec 04             	sub    $0x4,%esp
     ed0:	68 00 02 00 00       	push   $0x200
     ed5:	83 c6 30             	add    $0x30,%esi
     ed8:	56                   	push   %esi
     ed9:	68 60 83 00 00       	push   $0x8360
     ede:	e8 22 27 00 00       	call   3605 <memset>
      for(i = 0; i < 12; i++){
     ee3:	83 c4 10             	add    $0x10,%esp
     ee6:	eb 34                	jmp    f1c <fourfiles+0xe0>
        printf(1, "create failed\n");
     ee8:	83 ec 08             	sub    $0x8,%esp
     eeb:	68 47 42 00 00       	push   $0x4247
     ef0:	6a 01                	push   $0x1
     ef2:	e8 8f 29 00 00       	call   3886 <printf>
        exit();
     ef7:	e8 38 28 00 00       	call   3734 <exit>
        if((n = write(fd, buf, 500)) != 500){
     efc:	83 ec 04             	sub    $0x4,%esp
     eff:	68 f4 01 00 00       	push   $0x1f4
     f04:	68 60 83 00 00       	push   $0x8360
     f09:	57                   	push   %edi
     f0a:	e8 45 28 00 00       	call   3754 <write>
     f0f:	83 c4 10             	add    $0x10,%esp
     f12:	3d f4 01 00 00       	cmp    $0x1f4,%eax
     f17:	75 0d                	jne    f26 <fourfiles+0xea>
      for(i = 0; i < 12; i++){
     f19:	83 c3 01             	add    $0x1,%ebx
     f1c:	83 fb 0b             	cmp    $0xb,%ebx
     f1f:	7e db                	jle    efc <fourfiles+0xc0>
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
     f21:	e8 0e 28 00 00       	call   3734 <exit>
          printf(1, "write failed %d\n", n);
     f26:	83 ec 04             	sub    $0x4,%esp
     f29:	50                   	push   %eax
     f2a:	68 bc 3f 00 00       	push   $0x3fbc
     f2f:	6a 01                	push   $0x1
     f31:	e8 50 29 00 00       	call   3886 <printf>
          exit();
     f36:	e8 f9 27 00 00       	call   3734 <exit>
    }
  }

  for(pi = 0; pi < 4; pi++){
     f3b:	bb 00 00 00 00       	mov    $0x0,%ebx
     f40:	83 fb 03             	cmp    $0x3,%ebx
     f43:	7f 0a                	jg     f4f <fourfiles+0x113>
    wait();
     f45:	e8 f2 27 00 00       	call   373c <wait>
  for(pi = 0; pi < 4; pi++){
     f4a:	83 c3 01             	add    $0x1,%ebx
     f4d:	eb f1                	jmp    f40 <fourfiles+0x104>
  }

  for(i = 0; i < 2; i++){
     f4f:	bb 00 00 00 00       	mov    $0x0,%ebx
     f54:	eb 75                	jmp    fcb <fourfiles+0x18f>
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
     f56:	83 ec 08             	sub    $0x8,%esp
     f59:	68 cd 3f 00 00       	push   $0x3fcd
     f5e:	6a 01                	push   $0x1
     f60:	e8 21 29 00 00       	call   3886 <printf>
          exit();
     f65:	e8 ca 27 00 00       	call   3734 <exit>
        }
      }
      total += n;
     f6a:	01 c6                	add    %eax,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f6c:	83 ec 04             	sub    $0x4,%esp
     f6f:	68 00 20 00 00       	push   $0x2000
     f74:	68 60 83 00 00       	push   $0x8360
     f79:	ff 75 d4             	pushl  -0x2c(%ebp)
     f7c:	e8 cb 27 00 00       	call   374c <read>
     f81:	83 c4 10             	add    $0x10,%esp
     f84:	85 c0                	test   %eax,%eax
     f86:	7e 1c                	jle    fa4 <fourfiles+0x168>
      for(j = 0; j < n; j++){
     f88:	ba 00 00 00 00       	mov    $0x0,%edx
     f8d:	39 c2                	cmp    %eax,%edx
     f8f:	7d d9                	jge    f6a <fourfiles+0x12e>
        if(buf[j] != '0'+i){
     f91:	0f be ba 60 83 00 00 	movsbl 0x8360(%edx),%edi
     f98:	8d 4b 30             	lea    0x30(%ebx),%ecx
     f9b:	39 cf                	cmp    %ecx,%edi
     f9d:	75 b7                	jne    f56 <fourfiles+0x11a>
      for(j = 0; j < n; j++){
     f9f:	83 c2 01             	add    $0x1,%edx
     fa2:	eb e9                	jmp    f8d <fourfiles+0x151>
    }
    close(fd);
     fa4:	83 ec 0c             	sub    $0xc,%esp
     fa7:	ff 75 d4             	pushl  -0x2c(%ebp)
     faa:	e8 ad 27 00 00       	call   375c <close>
    if(total != 12*500){
     faf:	83 c4 10             	add    $0x10,%esp
     fb2:	81 fe 70 17 00 00    	cmp    $0x1770,%esi
     fb8:	75 38                	jne    ff2 <fourfiles+0x1b6>
      printf(1, "wrong length %d\n", total);
      exit();
    }
    unlink(fname);
     fba:	83 ec 0c             	sub    $0xc,%esp
     fbd:	ff 75 d0             	pushl  -0x30(%ebp)
     fc0:	e8 bf 27 00 00       	call   3784 <unlink>
  for(i = 0; i < 2; i++){
     fc5:	83 c3 01             	add    $0x1,%ebx
     fc8:	83 c4 10             	add    $0x10,%esp
     fcb:	83 fb 01             	cmp    $0x1,%ebx
     fce:	7f 37                	jg     1007 <fourfiles+0x1cb>
    fname = names[i];
     fd0:	8b 44 9d d8          	mov    -0x28(%ebp,%ebx,4),%eax
     fd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
    fd = open(fname, 0);
     fd7:	83 ec 08             	sub    $0x8,%esp
     fda:	6a 00                	push   $0x0
     fdc:	50                   	push   %eax
     fdd:	e8 92 27 00 00       	call   3774 <open>
     fe2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
     fe5:	83 c4 10             	add    $0x10,%esp
    total = 0;
     fe8:	be 00 00 00 00       	mov    $0x0,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
     fed:	e9 7a ff ff ff       	jmp    f6c <fourfiles+0x130>
      printf(1, "wrong length %d\n", total);
     ff2:	83 ec 04             	sub    $0x4,%esp
     ff5:	56                   	push   %esi
     ff6:	68 d9 3f 00 00       	push   $0x3fd9
     ffb:	6a 01                	push   $0x1
     ffd:	e8 84 28 00 00       	call   3886 <printf>
      exit();
    1002:	e8 2d 27 00 00       	call   3734 <exit>
  }

  printf(1, "fourfiles ok\n");
    1007:	83 ec 08             	sub    $0x8,%esp
    100a:	68 ea 3f 00 00       	push   $0x3fea
    100f:	6a 01                	push   $0x1
    1011:	e8 70 28 00 00       	call   3886 <printf>
}
    1016:	83 c4 10             	add    $0x10,%esp
    1019:	8d 65 f4             	lea    -0xc(%ebp),%esp
    101c:	5b                   	pop    %ebx
    101d:	5e                   	pop    %esi
    101e:	5f                   	pop    %edi
    101f:	5d                   	pop    %ebp
    1020:	c3                   	ret    

00001021 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1021:	55                   	push   %ebp
    1022:	89 e5                	mov    %esp,%ebp
    1024:	56                   	push   %esi
    1025:	53                   	push   %ebx
    1026:	83 ec 28             	sub    $0x28,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1029:	68 f8 3f 00 00       	push   $0x3ff8
    102e:	6a 01                	push   $0x1
    1030:	e8 51 28 00 00       	call   3886 <printf>

  for(pi = 0; pi < 4; pi++){
    1035:	83 c4 10             	add    $0x10,%esp
    1038:	be 00 00 00 00       	mov    $0x0,%esi
    103d:	83 fe 03             	cmp    $0x3,%esi
    1040:	0f 8f be 00 00 00    	jg     1104 <createdelete+0xe3>
    pid = fork();
    1046:	e8 e1 26 00 00       	call   372c <fork>
    104b:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    104d:	85 c0                	test   %eax,%eax
    104f:	78 09                	js     105a <createdelete+0x39>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
    1051:	85 c0                	test   %eax,%eax
    1053:	74 19                	je     106e <createdelete+0x4d>
  for(pi = 0; pi < 4; pi++){
    1055:	83 c6 01             	add    $0x1,%esi
    1058:	eb e3                	jmp    103d <createdelete+0x1c>
      printf(1, "fork failed\n");
    105a:	83 ec 08             	sub    $0x8,%esp
    105d:	68 81 4a 00 00       	push   $0x4a81
    1062:	6a 01                	push   $0x1
    1064:	e8 1d 28 00 00       	call   3886 <printf>
      exit();
    1069:	e8 c6 26 00 00       	call   3734 <exit>
      name[0] = 'p' + pi;
    106e:	8d 46 70             	lea    0x70(%esi),%eax
    1071:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[2] = '\0';
    1074:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
      for(i = 0; i < N; i++){
    1078:	eb 17                	jmp    1091 <createdelete+0x70>
        name[1] = '0' + i;
        fd = open(name, O_CREATE | O_RDWR);
        if(fd < 0){
          printf(1, "create failed\n");
    107a:	83 ec 08             	sub    $0x8,%esp
    107d:	68 47 42 00 00       	push   $0x4247
    1082:	6a 01                	push   $0x1
    1084:	e8 fd 27 00 00       	call   3886 <printf>
          exit();
    1089:	e8 a6 26 00 00       	call   3734 <exit>
      for(i = 0; i < N; i++){
    108e:	83 c3 01             	add    $0x1,%ebx
    1091:	83 fb 13             	cmp    $0x13,%ebx
    1094:	7f 69                	jg     10ff <createdelete+0xde>
        name[1] = '0' + i;
    1096:	8d 43 30             	lea    0x30(%ebx),%eax
    1099:	88 45 d9             	mov    %al,-0x27(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    109c:	83 ec 08             	sub    $0x8,%esp
    109f:	68 02 02 00 00       	push   $0x202
    10a4:	8d 45 d8             	lea    -0x28(%ebp),%eax
    10a7:	50                   	push   %eax
    10a8:	e8 c7 26 00 00       	call   3774 <open>
        if(fd < 0){
    10ad:	83 c4 10             	add    $0x10,%esp
    10b0:	85 c0                	test   %eax,%eax
    10b2:	78 c6                	js     107a <createdelete+0x59>
        }
        close(fd);
    10b4:	83 ec 0c             	sub    $0xc,%esp
    10b7:	50                   	push   %eax
    10b8:	e8 9f 26 00 00       	call   375c <close>
        if(i > 0 && (i % 2 ) == 0){
    10bd:	83 c4 10             	add    $0x10,%esp
    10c0:	85 db                	test   %ebx,%ebx
    10c2:	7e ca                	jle    108e <createdelete+0x6d>
    10c4:	f6 c3 01             	test   $0x1,%bl
    10c7:	75 c5                	jne    108e <createdelete+0x6d>
          name[1] = '0' + (i / 2);
    10c9:	89 d8                	mov    %ebx,%eax
    10cb:	c1 e8 1f             	shr    $0x1f,%eax
    10ce:	01 d8                	add    %ebx,%eax
    10d0:	d1 f8                	sar    %eax
    10d2:	83 c0 30             	add    $0x30,%eax
    10d5:	88 45 d9             	mov    %al,-0x27(%ebp)
          if(unlink(name) < 0){
    10d8:	83 ec 0c             	sub    $0xc,%esp
    10db:	8d 45 d8             	lea    -0x28(%ebp),%eax
    10de:	50                   	push   %eax
    10df:	e8 a0 26 00 00       	call   3784 <unlink>
    10e4:	83 c4 10             	add    $0x10,%esp
    10e7:	85 c0                	test   %eax,%eax
    10e9:	79 a3                	jns    108e <createdelete+0x6d>
            printf(1, "unlink failed\n");
    10eb:	83 ec 08             	sub    $0x8,%esp
    10ee:	68 f9 3b 00 00       	push   $0x3bf9
    10f3:	6a 01                	push   $0x1
    10f5:	e8 8c 27 00 00       	call   3886 <printf>
            exit();
    10fa:	e8 35 26 00 00       	call   3734 <exit>
          }
        }
      }
      exit();
    10ff:	e8 30 26 00 00       	call   3734 <exit>
    }
  }

  for(pi = 0; pi < 4; pi++){
    1104:	bb 00 00 00 00       	mov    $0x0,%ebx
    1109:	eb 08                	jmp    1113 <createdelete+0xf2>
    wait();
    110b:	e8 2c 26 00 00       	call   373c <wait>
  for(pi = 0; pi < 4; pi++){
    1110:	83 c3 01             	add    $0x1,%ebx
    1113:	83 fb 03             	cmp    $0x3,%ebx
    1116:	7e f3                	jle    110b <createdelete+0xea>
  }

  name[0] = name[1] = name[2] = 0;
    1118:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
    111c:	c6 45 d9 00          	movb   $0x0,-0x27(%ebp)
    1120:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
  for(i = 0; i < N; i++){
    1124:	bb 00 00 00 00       	mov    $0x0,%ebx
    1129:	e9 89 00 00 00       	jmp    11b7 <createdelete+0x196>
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
    112e:	8d 53 ff             	lea    -0x1(%ebx),%edx
    1131:	83 fa 08             	cmp    $0x8,%edx
    1134:	76 54                	jbe    118a <createdelete+0x169>
        printf(1, "oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
    1136:	85 c0                	test   %eax,%eax
    1138:	79 6c                	jns    11a6 <createdelete+0x185>
    for(pi = 0; pi < 4; pi++){
    113a:	83 c6 01             	add    $0x1,%esi
    113d:	83 fe 03             	cmp    $0x3,%esi
    1140:	7f 72                	jg     11b4 <createdelete+0x193>
      name[0] = 'p' + pi;
    1142:	8d 46 70             	lea    0x70(%esi),%eax
    1145:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[1] = '0' + i;
    1148:	8d 43 30             	lea    0x30(%ebx),%eax
    114b:	88 45 d9             	mov    %al,-0x27(%ebp)
      fd = open(name, 0);
    114e:	83 ec 08             	sub    $0x8,%esp
    1151:	6a 00                	push   $0x0
    1153:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1156:	50                   	push   %eax
    1157:	e8 18 26 00 00       	call   3774 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    115c:	83 c4 10             	add    $0x10,%esp
    115f:	85 db                	test   %ebx,%ebx
    1161:	0f 94 c1             	sete   %cl
    1164:	83 fb 09             	cmp    $0x9,%ebx
    1167:	0f 9f c2             	setg   %dl
    116a:	08 d1                	or     %dl,%cl
    116c:	74 c0                	je     112e <createdelete+0x10d>
    116e:	85 c0                	test   %eax,%eax
    1170:	79 bc                	jns    112e <createdelete+0x10d>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1172:	83 ec 04             	sub    $0x4,%esp
    1175:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1178:	50                   	push   %eax
    1179:	68 b8 4c 00 00       	push   $0x4cb8
    117e:	6a 01                	push   $0x1
    1180:	e8 01 27 00 00       	call   3886 <printf>
        exit();
    1185:	e8 aa 25 00 00       	call   3734 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    118a:	85 c0                	test   %eax,%eax
    118c:	78 a8                	js     1136 <createdelete+0x115>
        printf(1, "oops createdelete %s did exist\n", name);
    118e:	83 ec 04             	sub    $0x4,%esp
    1191:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1194:	50                   	push   %eax
    1195:	68 dc 4c 00 00       	push   $0x4cdc
    119a:	6a 01                	push   $0x1
    119c:	e8 e5 26 00 00       	call   3886 <printf>
        exit();
    11a1:	e8 8e 25 00 00       	call   3734 <exit>
        close(fd);
    11a6:	83 ec 0c             	sub    $0xc,%esp
    11a9:	50                   	push   %eax
    11aa:	e8 ad 25 00 00       	call   375c <close>
    11af:	83 c4 10             	add    $0x10,%esp
    11b2:	eb 86                	jmp    113a <createdelete+0x119>
  for(i = 0; i < N; i++){
    11b4:	83 c3 01             	add    $0x1,%ebx
    11b7:	83 fb 13             	cmp    $0x13,%ebx
    11ba:	7f 0a                	jg     11c6 <createdelete+0x1a5>
    for(pi = 0; pi < 4; pi++){
    11bc:	be 00 00 00 00       	mov    $0x0,%esi
    11c1:	e9 77 ff ff ff       	jmp    113d <createdelete+0x11c>
    }
  }

  for(i = 0; i < N; i++){
    11c6:	be 00 00 00 00       	mov    $0x0,%esi
    11cb:	eb 26                	jmp    11f3 <createdelete+0x1d2>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    11cd:	8d 46 70             	lea    0x70(%esi),%eax
    11d0:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[1] = '0' + i;
    11d3:	8d 46 30             	lea    0x30(%esi),%eax
    11d6:	88 45 d9             	mov    %al,-0x27(%ebp)
      unlink(name);
    11d9:	83 ec 0c             	sub    $0xc,%esp
    11dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
    11df:	50                   	push   %eax
    11e0:	e8 9f 25 00 00       	call   3784 <unlink>
    for(pi = 0; pi < 4; pi++){
    11e5:	83 c3 01             	add    $0x1,%ebx
    11e8:	83 c4 10             	add    $0x10,%esp
    11eb:	83 fb 03             	cmp    $0x3,%ebx
    11ee:	7e dd                	jle    11cd <createdelete+0x1ac>
  for(i = 0; i < N; i++){
    11f0:	83 c6 01             	add    $0x1,%esi
    11f3:	83 fe 13             	cmp    $0x13,%esi
    11f6:	7f 07                	jg     11ff <createdelete+0x1de>
    for(pi = 0; pi < 4; pi++){
    11f8:	bb 00 00 00 00       	mov    $0x0,%ebx
    11fd:	eb ec                	jmp    11eb <createdelete+0x1ca>
    }
  }

  printf(1, "createdelete ok\n");
    11ff:	83 ec 08             	sub    $0x8,%esp
    1202:	68 0b 40 00 00       	push   $0x400b
    1207:	6a 01                	push   $0x1
    1209:	e8 78 26 00 00       	call   3886 <printf>
}
    120e:	83 c4 10             	add    $0x10,%esp
    1211:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1214:	5b                   	pop    %ebx
    1215:	5e                   	pop    %esi
    1216:	5d                   	pop    %ebp
    1217:	c3                   	ret    

00001218 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1218:	55                   	push   %ebp
    1219:	89 e5                	mov    %esp,%ebp
    121b:	56                   	push   %esi
    121c:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    121d:	83 ec 08             	sub    $0x8,%esp
    1220:	68 1c 40 00 00       	push   $0x401c
    1225:	6a 01                	push   $0x1
    1227:	e8 5a 26 00 00       	call   3886 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    122c:	83 c4 08             	add    $0x8,%esp
    122f:	68 02 02 00 00       	push   $0x202
    1234:	68 2d 40 00 00       	push   $0x402d
    1239:	e8 36 25 00 00       	call   3774 <open>
  if(fd < 0){
    123e:	83 c4 10             	add    $0x10,%esp
    1241:	85 c0                	test   %eax,%eax
    1243:	0f 88 f0 00 00 00    	js     1339 <unlinkread+0x121>
    1249:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    124b:	83 ec 04             	sub    $0x4,%esp
    124e:	6a 05                	push   $0x5
    1250:	68 52 40 00 00       	push   $0x4052
    1255:	50                   	push   %eax
    1256:	e8 f9 24 00 00       	call   3754 <write>
  close(fd);
    125b:	89 1c 24             	mov    %ebx,(%esp)
    125e:	e8 f9 24 00 00       	call   375c <close>

  fd = open("unlinkread", O_RDWR);
    1263:	83 c4 08             	add    $0x8,%esp
    1266:	6a 02                	push   $0x2
    1268:	68 2d 40 00 00       	push   $0x402d
    126d:	e8 02 25 00 00       	call   3774 <open>
    1272:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1274:	83 c4 10             	add    $0x10,%esp
    1277:	85 c0                	test   %eax,%eax
    1279:	0f 88 ce 00 00 00    	js     134d <unlinkread+0x135>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    127f:	83 ec 0c             	sub    $0xc,%esp
    1282:	68 2d 40 00 00       	push   $0x402d
    1287:	e8 f8 24 00 00       	call   3784 <unlink>
    128c:	83 c4 10             	add    $0x10,%esp
    128f:	85 c0                	test   %eax,%eax
    1291:	0f 85 ca 00 00 00    	jne    1361 <unlinkread+0x149>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1297:	83 ec 08             	sub    $0x8,%esp
    129a:	68 02 02 00 00       	push   $0x202
    129f:	68 2d 40 00 00       	push   $0x402d
    12a4:	e8 cb 24 00 00       	call   3774 <open>
    12a9:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    12ab:	83 c4 0c             	add    $0xc,%esp
    12ae:	6a 03                	push   $0x3
    12b0:	68 8a 40 00 00       	push   $0x408a
    12b5:	50                   	push   %eax
    12b6:	e8 99 24 00 00       	call   3754 <write>
  close(fd1);
    12bb:	89 34 24             	mov    %esi,(%esp)
    12be:	e8 99 24 00 00       	call   375c <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    12c3:	83 c4 0c             	add    $0xc,%esp
    12c6:	68 00 20 00 00       	push   $0x2000
    12cb:	68 60 83 00 00       	push   $0x8360
    12d0:	53                   	push   %ebx
    12d1:	e8 76 24 00 00       	call   374c <read>
    12d6:	83 c4 10             	add    $0x10,%esp
    12d9:	83 f8 05             	cmp    $0x5,%eax
    12dc:	0f 85 93 00 00 00    	jne    1375 <unlinkread+0x15d>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    12e2:	80 3d 60 83 00 00 68 	cmpb   $0x68,0x8360
    12e9:	0f 85 9a 00 00 00    	jne    1389 <unlinkread+0x171>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    12ef:	83 ec 04             	sub    $0x4,%esp
    12f2:	6a 0a                	push   $0xa
    12f4:	68 60 83 00 00       	push   $0x8360
    12f9:	53                   	push   %ebx
    12fa:	e8 55 24 00 00       	call   3754 <write>
    12ff:	83 c4 10             	add    $0x10,%esp
    1302:	83 f8 0a             	cmp    $0xa,%eax
    1305:	0f 85 92 00 00 00    	jne    139d <unlinkread+0x185>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    130b:	83 ec 0c             	sub    $0xc,%esp
    130e:	53                   	push   %ebx
    130f:	e8 48 24 00 00       	call   375c <close>
  unlink("unlinkread");
    1314:	c7 04 24 2d 40 00 00 	movl   $0x402d,(%esp)
    131b:	e8 64 24 00 00       	call   3784 <unlink>
  printf(1, "unlinkread ok\n");
    1320:	83 c4 08             	add    $0x8,%esp
    1323:	68 d5 40 00 00       	push   $0x40d5
    1328:	6a 01                	push   $0x1
    132a:	e8 57 25 00 00       	call   3886 <printf>
}
    132f:	83 c4 10             	add    $0x10,%esp
    1332:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1335:	5b                   	pop    %ebx
    1336:	5e                   	pop    %esi
    1337:	5d                   	pop    %ebp
    1338:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    1339:	83 ec 08             	sub    $0x8,%esp
    133c:	68 38 40 00 00       	push   $0x4038
    1341:	6a 01                	push   $0x1
    1343:	e8 3e 25 00 00       	call   3886 <printf>
    exit();
    1348:	e8 e7 23 00 00       	call   3734 <exit>
    printf(1, "open unlinkread failed\n");
    134d:	83 ec 08             	sub    $0x8,%esp
    1350:	68 58 40 00 00       	push   $0x4058
    1355:	6a 01                	push   $0x1
    1357:	e8 2a 25 00 00       	call   3886 <printf>
    exit();
    135c:	e8 d3 23 00 00       	call   3734 <exit>
    printf(1, "unlink unlinkread failed\n");
    1361:	83 ec 08             	sub    $0x8,%esp
    1364:	68 70 40 00 00       	push   $0x4070
    1369:	6a 01                	push   $0x1
    136b:	e8 16 25 00 00       	call   3886 <printf>
    exit();
    1370:	e8 bf 23 00 00       	call   3734 <exit>
    printf(1, "unlinkread read failed");
    1375:	83 ec 08             	sub    $0x8,%esp
    1378:	68 8e 40 00 00       	push   $0x408e
    137d:	6a 01                	push   $0x1
    137f:	e8 02 25 00 00       	call   3886 <printf>
    exit();
    1384:	e8 ab 23 00 00       	call   3734 <exit>
    printf(1, "unlinkread wrong data\n");
    1389:	83 ec 08             	sub    $0x8,%esp
    138c:	68 a5 40 00 00       	push   $0x40a5
    1391:	6a 01                	push   $0x1
    1393:	e8 ee 24 00 00       	call   3886 <printf>
    exit();
    1398:	e8 97 23 00 00       	call   3734 <exit>
    printf(1, "unlinkread write failed\n");
    139d:	83 ec 08             	sub    $0x8,%esp
    13a0:	68 bc 40 00 00       	push   $0x40bc
    13a5:	6a 01                	push   $0x1
    13a7:	e8 da 24 00 00       	call   3886 <printf>
    exit();
    13ac:	e8 83 23 00 00       	call   3734 <exit>

000013b1 <linktest>:

void
linktest(void)
{
    13b1:	55                   	push   %ebp
    13b2:	89 e5                	mov    %esp,%ebp
    13b4:	53                   	push   %ebx
    13b5:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    13b8:	68 e4 40 00 00       	push   $0x40e4
    13bd:	6a 01                	push   $0x1
    13bf:	e8 c2 24 00 00       	call   3886 <printf>

  unlink("lf1");
    13c4:	c7 04 24 ee 40 00 00 	movl   $0x40ee,(%esp)
    13cb:	e8 b4 23 00 00       	call   3784 <unlink>
  unlink("lf2");
    13d0:	c7 04 24 f2 40 00 00 	movl   $0x40f2,(%esp)
    13d7:	e8 a8 23 00 00       	call   3784 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    13dc:	83 c4 08             	add    $0x8,%esp
    13df:	68 02 02 00 00       	push   $0x202
    13e4:	68 ee 40 00 00       	push   $0x40ee
    13e9:	e8 86 23 00 00       	call   3774 <open>
  if(fd < 0){
    13ee:	83 c4 10             	add    $0x10,%esp
    13f1:	85 c0                	test   %eax,%eax
    13f3:	0f 88 2a 01 00 00    	js     1523 <linktest+0x172>
    13f9:	89 c3                	mov    %eax,%ebx
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    13fb:	83 ec 04             	sub    $0x4,%esp
    13fe:	6a 05                	push   $0x5
    1400:	68 52 40 00 00       	push   $0x4052
    1405:	50                   	push   %eax
    1406:	e8 49 23 00 00       	call   3754 <write>
    140b:	83 c4 10             	add    $0x10,%esp
    140e:	83 f8 05             	cmp    $0x5,%eax
    1411:	0f 85 20 01 00 00    	jne    1537 <linktest+0x186>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    1417:	83 ec 0c             	sub    $0xc,%esp
    141a:	53                   	push   %ebx
    141b:	e8 3c 23 00 00       	call   375c <close>

  if(link("lf1", "lf2") < 0){
    1420:	83 c4 08             	add    $0x8,%esp
    1423:	68 f2 40 00 00       	push   $0x40f2
    1428:	68 ee 40 00 00       	push   $0x40ee
    142d:	e8 62 23 00 00       	call   3794 <link>
    1432:	83 c4 10             	add    $0x10,%esp
    1435:	85 c0                	test   %eax,%eax
    1437:	0f 88 0e 01 00 00    	js     154b <linktest+0x19a>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    143d:	83 ec 0c             	sub    $0xc,%esp
    1440:	68 ee 40 00 00       	push   $0x40ee
    1445:	e8 3a 23 00 00       	call   3784 <unlink>

  if(open("lf1", 0) >= 0){
    144a:	83 c4 08             	add    $0x8,%esp
    144d:	6a 00                	push   $0x0
    144f:	68 ee 40 00 00       	push   $0x40ee
    1454:	e8 1b 23 00 00       	call   3774 <open>
    1459:	83 c4 10             	add    $0x10,%esp
    145c:	85 c0                	test   %eax,%eax
    145e:	0f 89 fb 00 00 00    	jns    155f <linktest+0x1ae>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1464:	83 ec 08             	sub    $0x8,%esp
    1467:	6a 00                	push   $0x0
    1469:	68 f2 40 00 00       	push   $0x40f2
    146e:	e8 01 23 00 00       	call   3774 <open>
    1473:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1475:	83 c4 10             	add    $0x10,%esp
    1478:	85 c0                	test   %eax,%eax
    147a:	0f 88 f3 00 00 00    	js     1573 <linktest+0x1c2>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    1480:	83 ec 04             	sub    $0x4,%esp
    1483:	68 00 20 00 00       	push   $0x2000
    1488:	68 60 83 00 00       	push   $0x8360
    148d:	50                   	push   %eax
    148e:	e8 b9 22 00 00       	call   374c <read>
    1493:	83 c4 10             	add    $0x10,%esp
    1496:	83 f8 05             	cmp    $0x5,%eax
    1499:	0f 85 e8 00 00 00    	jne    1587 <linktest+0x1d6>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    149f:	83 ec 0c             	sub    $0xc,%esp
    14a2:	53                   	push   %ebx
    14a3:	e8 b4 22 00 00       	call   375c <close>

  if(link("lf2", "lf2") >= 0){
    14a8:	83 c4 08             	add    $0x8,%esp
    14ab:	68 f2 40 00 00       	push   $0x40f2
    14b0:	68 f2 40 00 00       	push   $0x40f2
    14b5:	e8 da 22 00 00       	call   3794 <link>
    14ba:	83 c4 10             	add    $0x10,%esp
    14bd:	85 c0                	test   %eax,%eax
    14bf:	0f 89 d6 00 00 00    	jns    159b <linktest+0x1ea>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    14c5:	83 ec 0c             	sub    $0xc,%esp
    14c8:	68 f2 40 00 00       	push   $0x40f2
    14cd:	e8 b2 22 00 00       	call   3784 <unlink>
  if(link("lf2", "lf1") >= 0){
    14d2:	83 c4 08             	add    $0x8,%esp
    14d5:	68 ee 40 00 00       	push   $0x40ee
    14da:	68 f2 40 00 00       	push   $0x40f2
    14df:	e8 b0 22 00 00       	call   3794 <link>
    14e4:	83 c4 10             	add    $0x10,%esp
    14e7:	85 c0                	test   %eax,%eax
    14e9:	0f 89 c0 00 00 00    	jns    15af <linktest+0x1fe>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    14ef:	83 ec 08             	sub    $0x8,%esp
    14f2:	68 ee 40 00 00       	push   $0x40ee
    14f7:	68 b6 43 00 00       	push   $0x43b6
    14fc:	e8 93 22 00 00       	call   3794 <link>
    1501:	83 c4 10             	add    $0x10,%esp
    1504:	85 c0                	test   %eax,%eax
    1506:	0f 89 b7 00 00 00    	jns    15c3 <linktest+0x212>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    150c:	83 ec 08             	sub    $0x8,%esp
    150f:	68 8c 41 00 00       	push   $0x418c
    1514:	6a 01                	push   $0x1
    1516:	e8 6b 23 00 00       	call   3886 <printf>
}
    151b:	83 c4 10             	add    $0x10,%esp
    151e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1521:	c9                   	leave  
    1522:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1523:	83 ec 08             	sub    $0x8,%esp
    1526:	68 f6 40 00 00       	push   $0x40f6
    152b:	6a 01                	push   $0x1
    152d:	e8 54 23 00 00       	call   3886 <printf>
    exit();
    1532:	e8 fd 21 00 00       	call   3734 <exit>
    printf(1, "write lf1 failed\n");
    1537:	83 ec 08             	sub    $0x8,%esp
    153a:	68 09 41 00 00       	push   $0x4109
    153f:	6a 01                	push   $0x1
    1541:	e8 40 23 00 00       	call   3886 <printf>
    exit();
    1546:	e8 e9 21 00 00       	call   3734 <exit>
    printf(1, "link lf1 lf2 failed\n");
    154b:	83 ec 08             	sub    $0x8,%esp
    154e:	68 1b 41 00 00       	push   $0x411b
    1553:	6a 01                	push   $0x1
    1555:	e8 2c 23 00 00       	call   3886 <printf>
    exit();
    155a:	e8 d5 21 00 00       	call   3734 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    155f:	83 ec 08             	sub    $0x8,%esp
    1562:	68 fc 4c 00 00       	push   $0x4cfc
    1567:	6a 01                	push   $0x1
    1569:	e8 18 23 00 00       	call   3886 <printf>
    exit();
    156e:	e8 c1 21 00 00       	call   3734 <exit>
    printf(1, "open lf2 failed\n");
    1573:	83 ec 08             	sub    $0x8,%esp
    1576:	68 30 41 00 00       	push   $0x4130
    157b:	6a 01                	push   $0x1
    157d:	e8 04 23 00 00       	call   3886 <printf>
    exit();
    1582:	e8 ad 21 00 00       	call   3734 <exit>
    printf(1, "read lf2 failed\n");
    1587:	83 ec 08             	sub    $0x8,%esp
    158a:	68 41 41 00 00       	push   $0x4141
    158f:	6a 01                	push   $0x1
    1591:	e8 f0 22 00 00       	call   3886 <printf>
    exit();
    1596:	e8 99 21 00 00       	call   3734 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    159b:	83 ec 08             	sub    $0x8,%esp
    159e:	68 52 41 00 00       	push   $0x4152
    15a3:	6a 01                	push   $0x1
    15a5:	e8 dc 22 00 00       	call   3886 <printf>
    exit();
    15aa:	e8 85 21 00 00       	call   3734 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    15af:	83 ec 08             	sub    $0x8,%esp
    15b2:	68 24 4d 00 00       	push   $0x4d24
    15b7:	6a 01                	push   $0x1
    15b9:	e8 c8 22 00 00       	call   3886 <printf>
    exit();
    15be:	e8 71 21 00 00       	call   3734 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    15c3:	83 ec 08             	sub    $0x8,%esp
    15c6:	68 70 41 00 00       	push   $0x4170
    15cb:	6a 01                	push   $0x1
    15cd:	e8 b4 22 00 00       	call   3886 <printf>
    exit();
    15d2:	e8 5d 21 00 00       	call   3734 <exit>

000015d7 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    15d7:	55                   	push   %ebp
    15d8:	89 e5                	mov    %esp,%ebp
    15da:	57                   	push   %edi
    15db:	56                   	push   %esi
    15dc:	53                   	push   %ebx
    15dd:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    15e0:	68 99 41 00 00       	push   $0x4199
    15e5:	6a 01                	push   $0x1
    15e7:	e8 9a 22 00 00       	call   3886 <printf>
  file[0] = 'C';
    15ec:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    15f0:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    15f4:	83 c4 10             	add    $0x10,%esp
    15f7:	bb 00 00 00 00       	mov    $0x0,%ebx
    15fc:	eb 5e                	jmp    165c <concreate+0x85>
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    15fe:	85 f6                	test   %esi,%esi
    1600:	75 22                	jne    1624 <concreate+0x4d>
    1602:	ba 67 66 66 66       	mov    $0x66666667,%edx
    1607:	89 d8                	mov    %ebx,%eax
    1609:	f7 ea                	imul   %edx
    160b:	d1 fa                	sar    %edx
    160d:	89 d8                	mov    %ebx,%eax
    160f:	c1 f8 1f             	sar    $0x1f,%eax
    1612:	29 c2                	sub    %eax,%edx
    1614:	8d 04 92             	lea    (%edx,%edx,4),%eax
    1617:	89 da                	mov    %ebx,%edx
    1619:	29 c2                	sub    %eax,%edx
    161b:	83 fa 01             	cmp    $0x1,%edx
    161e:	0f 84 9b 00 00 00    	je     16bf <concreate+0xe8>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    1624:	83 ec 08             	sub    $0x8,%esp
    1627:	68 02 02 00 00       	push   $0x202
    162c:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    162f:	50                   	push   %eax
    1630:	e8 3f 21 00 00       	call   3774 <open>
      if(fd < 0){
    1635:	83 c4 10             	add    $0x10,%esp
    1638:	85 c0                	test   %eax,%eax
    163a:	0f 88 98 00 00 00    	js     16d8 <concreate+0x101>
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    1640:	83 ec 0c             	sub    $0xc,%esp
    1643:	50                   	push   %eax
    1644:	e8 13 21 00 00       	call   375c <close>
    1649:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    164c:	85 f6                	test   %esi,%esi
    164e:	0f 84 9c 00 00 00    	je     16f0 <concreate+0x119>
      exit();
    else
      wait();
    1654:	e8 e3 20 00 00       	call   373c <wait>
  for(i = 0; i < 40; i++){
    1659:	83 c3 01             	add    $0x1,%ebx
    165c:	83 fb 27             	cmp    $0x27,%ebx
    165f:	0f 8f 90 00 00 00    	jg     16f5 <concreate+0x11e>
    file[1] = '0' + i;
    1665:	8d 43 30             	lea    0x30(%ebx),%eax
    1668:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    166b:	83 ec 0c             	sub    $0xc,%esp
    166e:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1671:	50                   	push   %eax
    1672:	e8 0d 21 00 00       	call   3784 <unlink>
    pid = fork();
    1677:	e8 b0 20 00 00       	call   372c <fork>
    167c:	89 c6                	mov    %eax,%esi
    if(pid && (i % 3) == 1){
    167e:	83 c4 10             	add    $0x10,%esp
    1681:	85 c0                	test   %eax,%eax
    1683:	0f 84 75 ff ff ff    	je     15fe <concreate+0x27>
    1689:	ba 56 55 55 55       	mov    $0x55555556,%edx
    168e:	89 d8                	mov    %ebx,%eax
    1690:	f7 ea                	imul   %edx
    1692:	89 d8                	mov    %ebx,%eax
    1694:	c1 f8 1f             	sar    $0x1f,%eax
    1697:	29 c2                	sub    %eax,%edx
    1699:	8d 04 52             	lea    (%edx,%edx,2),%eax
    169c:	89 da                	mov    %ebx,%edx
    169e:	29 c2                	sub    %eax,%edx
    16a0:	83 fa 01             	cmp    $0x1,%edx
    16a3:	0f 85 55 ff ff ff    	jne    15fe <concreate+0x27>
      link("C0", file);
    16a9:	83 ec 08             	sub    $0x8,%esp
    16ac:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16af:	50                   	push   %eax
    16b0:	68 a9 41 00 00       	push   $0x41a9
    16b5:	e8 da 20 00 00       	call   3794 <link>
    16ba:	83 c4 10             	add    $0x10,%esp
    16bd:	eb 8d                	jmp    164c <concreate+0x75>
      link("C0", file);
    16bf:	83 ec 08             	sub    $0x8,%esp
    16c2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16c5:	50                   	push   %eax
    16c6:	68 a9 41 00 00       	push   $0x41a9
    16cb:	e8 c4 20 00 00       	call   3794 <link>
    16d0:	83 c4 10             	add    $0x10,%esp
    16d3:	e9 74 ff ff ff       	jmp    164c <concreate+0x75>
        printf(1, "concreate create %s failed\n", file);
    16d8:	83 ec 04             	sub    $0x4,%esp
    16db:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16de:	50                   	push   %eax
    16df:	68 ac 41 00 00       	push   $0x41ac
    16e4:	6a 01                	push   $0x1
    16e6:	e8 9b 21 00 00       	call   3886 <printf>
        exit();
    16eb:	e8 44 20 00 00       	call   3734 <exit>
      exit();
    16f0:	e8 3f 20 00 00       	call   3734 <exit>
  }

  memset(fa, 0, sizeof(fa));
    16f5:	83 ec 04             	sub    $0x4,%esp
    16f8:	6a 28                	push   $0x28
    16fa:	6a 00                	push   $0x0
    16fc:	8d 45 bd             	lea    -0x43(%ebp),%eax
    16ff:	50                   	push   %eax
    1700:	e8 00 1f 00 00       	call   3605 <memset>
  fd = open(".", 0);
    1705:	83 c4 08             	add    $0x8,%esp
    1708:	6a 00                	push   $0x0
    170a:	68 b6 43 00 00       	push   $0x43b6
    170f:	e8 60 20 00 00       	call   3774 <open>
    1714:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1716:	83 c4 10             	add    $0x10,%esp
  n = 0;
    1719:	be 00 00 00 00       	mov    $0x0,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    171e:	83 ec 04             	sub    $0x4,%esp
    1721:	6a 10                	push   $0x10
    1723:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1726:	50                   	push   %eax
    1727:	53                   	push   %ebx
    1728:	e8 1f 20 00 00       	call   374c <read>
    172d:	83 c4 10             	add    $0x10,%esp
    1730:	85 c0                	test   %eax,%eax
    1732:	7e 60                	jle    1794 <concreate+0x1bd>
    if(de.inum == 0)
    1734:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    1739:	74 e3                	je     171e <concreate+0x147>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    173b:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    173f:	75 dd                	jne    171e <concreate+0x147>
    1741:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    1745:	75 d7                	jne    171e <concreate+0x147>
      i = de.name[1] - '0';
    1747:	0f be 45 af          	movsbl -0x51(%ebp),%eax
    174b:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    174e:	83 f8 27             	cmp    $0x27,%eax
    1751:	77 11                	ja     1764 <concreate+0x18d>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    1753:	80 7c 05 bd 00       	cmpb   $0x0,-0x43(%ebp,%eax,1)
    1758:	75 22                	jne    177c <concreate+0x1a5>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    175a:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    175f:	83 c6 01             	add    $0x1,%esi
    1762:	eb ba                	jmp    171e <concreate+0x147>
        printf(1, "concreate weird file %s\n", de.name);
    1764:	83 ec 04             	sub    $0x4,%esp
    1767:	8d 45 ae             	lea    -0x52(%ebp),%eax
    176a:	50                   	push   %eax
    176b:	68 c8 41 00 00       	push   $0x41c8
    1770:	6a 01                	push   $0x1
    1772:	e8 0f 21 00 00       	call   3886 <printf>
        exit();
    1777:	e8 b8 1f 00 00       	call   3734 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    177c:	83 ec 04             	sub    $0x4,%esp
    177f:	8d 45 ae             	lea    -0x52(%ebp),%eax
    1782:	50                   	push   %eax
    1783:	68 e1 41 00 00       	push   $0x41e1
    1788:	6a 01                	push   $0x1
    178a:	e8 f7 20 00 00       	call   3886 <printf>
        exit();
    178f:	e8 a0 1f 00 00       	call   3734 <exit>
    }
  }
  close(fd);
    1794:	83 ec 0c             	sub    $0xc,%esp
    1797:	53                   	push   %ebx
    1798:	e8 bf 1f 00 00       	call   375c <close>

  if(n != 40){
    179d:	83 c4 10             	add    $0x10,%esp
    17a0:	83 fe 28             	cmp    $0x28,%esi
    17a3:	75 0a                	jne    17af <concreate+0x1d8>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    17a5:	bb 00 00 00 00       	mov    $0x0,%ebx
    17aa:	e9 86 00 00 00       	jmp    1835 <concreate+0x25e>
    printf(1, "concreate not enough files in directory listing\n");
    17af:	83 ec 08             	sub    $0x8,%esp
    17b2:	68 48 4d 00 00       	push   $0x4d48
    17b7:	6a 01                	push   $0x1
    17b9:	e8 c8 20 00 00       	call   3886 <printf>
    exit();
    17be:	e8 71 1f 00 00       	call   3734 <exit>
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    17c3:	83 ec 08             	sub    $0x8,%esp
    17c6:	68 81 4a 00 00       	push   $0x4a81
    17cb:	6a 01                	push   $0x1
    17cd:	e8 b4 20 00 00       	call   3886 <printf>
      exit();
    17d2:	e8 5d 1f 00 00       	call   3734 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    17d7:	83 ec 08             	sub    $0x8,%esp
    17da:	6a 00                	push   $0x0
    17dc:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    17df:	57                   	push   %edi
    17e0:	e8 8f 1f 00 00       	call   3774 <open>
    17e5:	89 04 24             	mov    %eax,(%esp)
    17e8:	e8 6f 1f 00 00       	call   375c <close>
      close(open(file, 0));
    17ed:	83 c4 08             	add    $0x8,%esp
    17f0:	6a 00                	push   $0x0
    17f2:	57                   	push   %edi
    17f3:	e8 7c 1f 00 00       	call   3774 <open>
    17f8:	89 04 24             	mov    %eax,(%esp)
    17fb:	e8 5c 1f 00 00       	call   375c <close>
      close(open(file, 0));
    1800:	83 c4 08             	add    $0x8,%esp
    1803:	6a 00                	push   $0x0
    1805:	57                   	push   %edi
    1806:	e8 69 1f 00 00       	call   3774 <open>
    180b:	89 04 24             	mov    %eax,(%esp)
    180e:	e8 49 1f 00 00       	call   375c <close>
      close(open(file, 0));
    1813:	83 c4 08             	add    $0x8,%esp
    1816:	6a 00                	push   $0x0
    1818:	57                   	push   %edi
    1819:	e8 56 1f 00 00       	call   3774 <open>
    181e:	89 04 24             	mov    %eax,(%esp)
    1821:	e8 36 1f 00 00       	call   375c <close>
    1826:	83 c4 10             	add    $0x10,%esp
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    1829:	85 f6                	test   %esi,%esi
    182b:	74 79                	je     18a6 <concreate+0x2cf>
      exit();
    else
      wait();
    182d:	e8 0a 1f 00 00       	call   373c <wait>
  for(i = 0; i < 40; i++){
    1832:	83 c3 01             	add    $0x1,%ebx
    1835:	83 fb 27             	cmp    $0x27,%ebx
    1838:	7f 71                	jg     18ab <concreate+0x2d4>
    file[1] = '0' + i;
    183a:	8d 43 30             	lea    0x30(%ebx),%eax
    183d:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1840:	e8 e7 1e 00 00       	call   372c <fork>
    1845:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    1847:	85 c0                	test   %eax,%eax
    1849:	0f 88 74 ff ff ff    	js     17c3 <concreate+0x1ec>
    if(((i % 3) == 0 && pid == 0) ||
    184f:	ba 56 55 55 55       	mov    $0x55555556,%edx
    1854:	89 d8                	mov    %ebx,%eax
    1856:	f7 ea                	imul   %edx
    1858:	89 d8                	mov    %ebx,%eax
    185a:	c1 f8 1f             	sar    $0x1f,%eax
    185d:	29 c2                	sub    %eax,%edx
    185f:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1862:	89 da                	mov    %ebx,%edx
    1864:	29 c2                	sub    %eax,%edx
    1866:	89 d0                	mov    %edx,%eax
    1868:	09 f0                	or     %esi,%eax
    186a:	0f 84 67 ff ff ff    	je     17d7 <concreate+0x200>
    1870:	83 fa 01             	cmp    $0x1,%edx
    1873:	75 08                	jne    187d <concreate+0x2a6>
       ((i % 3) == 1 && pid != 0)){
    1875:	85 f6                	test   %esi,%esi
    1877:	0f 85 5a ff ff ff    	jne    17d7 <concreate+0x200>
      unlink(file);
    187d:	83 ec 0c             	sub    $0xc,%esp
    1880:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1883:	57                   	push   %edi
    1884:	e8 fb 1e 00 00       	call   3784 <unlink>
      unlink(file);
    1889:	89 3c 24             	mov    %edi,(%esp)
    188c:	e8 f3 1e 00 00       	call   3784 <unlink>
      unlink(file);
    1891:	89 3c 24             	mov    %edi,(%esp)
    1894:	e8 eb 1e 00 00       	call   3784 <unlink>
      unlink(file);
    1899:	89 3c 24             	mov    %edi,(%esp)
    189c:	e8 e3 1e 00 00       	call   3784 <unlink>
    18a1:	83 c4 10             	add    $0x10,%esp
    18a4:	eb 83                	jmp    1829 <concreate+0x252>
      exit();
    18a6:	e8 89 1e 00 00       	call   3734 <exit>
  }

  printf(1, "concreate ok\n");
    18ab:	83 ec 08             	sub    $0x8,%esp
    18ae:	68 fe 41 00 00       	push   $0x41fe
    18b3:	6a 01                	push   $0x1
    18b5:	e8 cc 1f 00 00       	call   3886 <printf>
}
    18ba:	83 c4 10             	add    $0x10,%esp
    18bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    18c0:	5b                   	pop    %ebx
    18c1:	5e                   	pop    %esi
    18c2:	5f                   	pop    %edi
    18c3:	5d                   	pop    %ebp
    18c4:	c3                   	ret    

000018c5 <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    18c5:	55                   	push   %ebp
    18c6:	89 e5                	mov    %esp,%ebp
    18c8:	57                   	push   %edi
    18c9:	56                   	push   %esi
    18ca:	53                   	push   %ebx
    18cb:	83 ec 14             	sub    $0x14,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    18ce:	68 0c 42 00 00       	push   $0x420c
    18d3:	6a 01                	push   $0x1
    18d5:	e8 ac 1f 00 00       	call   3886 <printf>

  unlink("x");
    18da:	c7 04 24 99 44 00 00 	movl   $0x4499,(%esp)
    18e1:	e8 9e 1e 00 00       	call   3784 <unlink>
  pid = fork();
    18e6:	e8 41 1e 00 00       	call   372c <fork>
  if(pid < 0){
    18eb:	83 c4 10             	add    $0x10,%esp
    18ee:	85 c0                	test   %eax,%eax
    18f0:	78 12                	js     1904 <linkunlink+0x3f>
    18f2:	89 c7                	mov    %eax,%edi
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    18f4:	85 c0                	test   %eax,%eax
    18f6:	74 20                	je     1918 <linkunlink+0x53>
    18f8:	bb 01 00 00 00       	mov    $0x1,%ebx
    18fd:	be 00 00 00 00       	mov    $0x0,%esi
    1902:	eb 3b                	jmp    193f <linkunlink+0x7a>
    printf(1, "fork failed\n");
    1904:	83 ec 08             	sub    $0x8,%esp
    1907:	68 81 4a 00 00       	push   $0x4a81
    190c:	6a 01                	push   $0x1
    190e:	e8 73 1f 00 00       	call   3886 <printf>
    exit();
    1913:	e8 1c 1e 00 00       	call   3734 <exit>
  unsigned int x = (pid ? 1 : 97);
    1918:	bb 61 00 00 00       	mov    $0x61,%ebx
    191d:	eb de                	jmp    18fd <linkunlink+0x38>
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    191f:	83 ec 08             	sub    $0x8,%esp
    1922:	68 02 02 00 00       	push   $0x202
    1927:	68 99 44 00 00       	push   $0x4499
    192c:	e8 43 1e 00 00       	call   3774 <open>
    1931:	89 04 24             	mov    %eax,(%esp)
    1934:	e8 23 1e 00 00       	call   375c <close>
    1939:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    193c:	83 c6 01             	add    $0x1,%esi
    193f:	83 fe 63             	cmp    $0x63,%esi
    1942:	7f 4e                	jg     1992 <linkunlink+0xcd>
    x = x * 1103515245 + 12345;
    1944:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    194a:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    1950:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    1955:	89 d8                	mov    %ebx,%eax
    1957:	f7 e2                	mul    %edx
    1959:	d1 ea                	shr    %edx
    195b:	8d 04 52             	lea    (%edx,%edx,2),%eax
    195e:	89 da                	mov    %ebx,%edx
    1960:	29 c2                	sub    %eax,%edx
    1962:	74 bb                	je     191f <linkunlink+0x5a>
    } else if((x % 3) == 1){
    1964:	83 fa 01             	cmp    $0x1,%edx
    1967:	74 12                	je     197b <linkunlink+0xb6>
      link("cat", "x");
    } else {
      unlink("x");
    1969:	83 ec 0c             	sub    $0xc,%esp
    196c:	68 99 44 00 00       	push   $0x4499
    1971:	e8 0e 1e 00 00       	call   3784 <unlink>
    1976:	83 c4 10             	add    $0x10,%esp
    1979:	eb c1                	jmp    193c <linkunlink+0x77>
      link("cat", "x");
    197b:	83 ec 08             	sub    $0x8,%esp
    197e:	68 99 44 00 00       	push   $0x4499
    1983:	68 1d 42 00 00       	push   $0x421d
    1988:	e8 07 1e 00 00       	call   3794 <link>
    198d:	83 c4 10             	add    $0x10,%esp
    1990:	eb aa                	jmp    193c <linkunlink+0x77>
    }
  }

  if(pid)
    1992:	85 ff                	test   %edi,%edi
    1994:	74 1c                	je     19b2 <linkunlink+0xed>
    wait();
    1996:	e8 a1 1d 00 00       	call   373c <wait>
  else
    exit();

  printf(1, "linkunlink ok\n");
    199b:	83 ec 08             	sub    $0x8,%esp
    199e:	68 21 42 00 00       	push   $0x4221
    19a3:	6a 01                	push   $0x1
    19a5:	e8 dc 1e 00 00       	call   3886 <printf>
}
    19aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
    19ad:	5b                   	pop    %ebx
    19ae:	5e                   	pop    %esi
    19af:	5f                   	pop    %edi
    19b0:	5d                   	pop    %ebp
    19b1:	c3                   	ret    
    exit();
    19b2:	e8 7d 1d 00 00       	call   3734 <exit>

000019b7 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    19b7:	55                   	push   %ebp
    19b8:	89 e5                	mov    %esp,%ebp
    19ba:	53                   	push   %ebx
    19bb:	83 ec 1c             	sub    $0x1c,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    19be:	68 30 42 00 00       	push   $0x4230
    19c3:	6a 01                	push   $0x1
    19c5:	e8 bc 1e 00 00       	call   3886 <printf>
  unlink("bd");
    19ca:	c7 04 24 3d 42 00 00 	movl   $0x423d,(%esp)
    19d1:	e8 ae 1d 00 00       	call   3784 <unlink>

  fd = open("bd", O_CREATE);
    19d6:	83 c4 08             	add    $0x8,%esp
    19d9:	68 00 02 00 00       	push   $0x200
    19de:	68 3d 42 00 00       	push   $0x423d
    19e3:	e8 8c 1d 00 00       	call   3774 <open>
  if(fd < 0){
    19e8:	83 c4 10             	add    $0x10,%esp
    19eb:	85 c0                	test   %eax,%eax
    19ed:	78 65                	js     1a54 <bigdir+0x9d>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
    19ef:	83 ec 0c             	sub    $0xc,%esp
    19f2:	50                   	push   %eax
    19f3:	e8 64 1d 00 00       	call   375c <close>

  for(i = 0; i < 500; i++){
    19f8:	83 c4 10             	add    $0x10,%esp
    19fb:	bb 00 00 00 00       	mov    $0x0,%ebx
    1a00:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1a06:	7f 74                	jg     1a7c <bigdir+0xc5>
    name[0] = 'x';
    1a08:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1a0c:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1a0f:	85 db                	test   %ebx,%ebx
    1a11:	0f 49 c3             	cmovns %ebx,%eax
    1a14:	c1 f8 06             	sar    $0x6,%eax
    1a17:	83 c0 30             	add    $0x30,%eax
    1a1a:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1a1d:	89 da                	mov    %ebx,%edx
    1a1f:	c1 fa 1f             	sar    $0x1f,%edx
    1a22:	c1 ea 1a             	shr    $0x1a,%edx
    1a25:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    1a28:	83 e0 3f             	and    $0x3f,%eax
    1a2b:	29 d0                	sub    %edx,%eax
    1a2d:	83 c0 30             	add    $0x30,%eax
    1a30:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1a33:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
    1a37:	83 ec 08             	sub    $0x8,%esp
    1a3a:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1a3d:	50                   	push   %eax
    1a3e:	68 3d 42 00 00       	push   $0x423d
    1a43:	e8 4c 1d 00 00       	call   3794 <link>
    1a48:	83 c4 10             	add    $0x10,%esp
    1a4b:	85 c0                	test   %eax,%eax
    1a4d:	75 19                	jne    1a68 <bigdir+0xb1>
  for(i = 0; i < 500; i++){
    1a4f:	83 c3 01             	add    $0x1,%ebx
    1a52:	eb ac                	jmp    1a00 <bigdir+0x49>
    printf(1, "bigdir create failed\n");
    1a54:	83 ec 08             	sub    $0x8,%esp
    1a57:	68 40 42 00 00       	push   $0x4240
    1a5c:	6a 01                	push   $0x1
    1a5e:	e8 23 1e 00 00       	call   3886 <printf>
    exit();
    1a63:	e8 cc 1c 00 00       	call   3734 <exit>
      printf(1, "bigdir link failed\n");
    1a68:	83 ec 08             	sub    $0x8,%esp
    1a6b:	68 56 42 00 00       	push   $0x4256
    1a70:	6a 01                	push   $0x1
    1a72:	e8 0f 1e 00 00       	call   3886 <printf>
      exit();
    1a77:	e8 b8 1c 00 00       	call   3734 <exit>
    }
  }

  unlink("bd");
    1a7c:	83 ec 0c             	sub    $0xc,%esp
    1a7f:	68 3d 42 00 00       	push   $0x423d
    1a84:	e8 fb 1c 00 00       	call   3784 <unlink>
  for(i = 0; i < 500; i++){
    1a89:	83 c4 10             	add    $0x10,%esp
    1a8c:	bb 00 00 00 00       	mov    $0x0,%ebx
    1a91:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1a97:	7f 5b                	jg     1af4 <bigdir+0x13d>
    name[0] = 'x';
    1a99:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1a9d:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1aa0:	85 db                	test   %ebx,%ebx
    1aa2:	0f 49 c3             	cmovns %ebx,%eax
    1aa5:	c1 f8 06             	sar    $0x6,%eax
    1aa8:	83 c0 30             	add    $0x30,%eax
    1aab:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1aae:	89 da                	mov    %ebx,%edx
    1ab0:	c1 fa 1f             	sar    $0x1f,%edx
    1ab3:	c1 ea 1a             	shr    $0x1a,%edx
    1ab6:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    1ab9:	83 e0 3f             	and    $0x3f,%eax
    1abc:	29 d0                	sub    %edx,%eax
    1abe:	83 c0 30             	add    $0x30,%eax
    1ac1:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1ac4:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
    1ac8:	83 ec 0c             	sub    $0xc,%esp
    1acb:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1ace:	50                   	push   %eax
    1acf:	e8 b0 1c 00 00       	call   3784 <unlink>
    1ad4:	83 c4 10             	add    $0x10,%esp
    1ad7:	85 c0                	test   %eax,%eax
    1ad9:	75 05                	jne    1ae0 <bigdir+0x129>
  for(i = 0; i < 500; i++){
    1adb:	83 c3 01             	add    $0x1,%ebx
    1ade:	eb b1                	jmp    1a91 <bigdir+0xda>
      printf(1, "bigdir unlink failed");
    1ae0:	83 ec 08             	sub    $0x8,%esp
    1ae3:	68 6a 42 00 00       	push   $0x426a
    1ae8:	6a 01                	push   $0x1
    1aea:	e8 97 1d 00 00       	call   3886 <printf>
      exit();
    1aef:	e8 40 1c 00 00       	call   3734 <exit>
    }
  }

  printf(1, "bigdir ok\n");
    1af4:	83 ec 08             	sub    $0x8,%esp
    1af7:	68 7f 42 00 00       	push   $0x427f
    1afc:	6a 01                	push   $0x1
    1afe:	e8 83 1d 00 00       	call   3886 <printf>
}
    1b03:	83 c4 10             	add    $0x10,%esp
    1b06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1b09:	c9                   	leave  
    1b0a:	c3                   	ret    

00001b0b <subdir>:

void
subdir(void)
{
    1b0b:	55                   	push   %ebp
    1b0c:	89 e5                	mov    %esp,%ebp
    1b0e:	53                   	push   %ebx
    1b0f:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1b12:	68 8a 42 00 00       	push   $0x428a
    1b17:	6a 01                	push   $0x1
    1b19:	e8 68 1d 00 00       	call   3886 <printf>

  unlink("ff");
    1b1e:	c7 04 24 13 43 00 00 	movl   $0x4313,(%esp)
    1b25:	e8 5a 1c 00 00       	call   3784 <unlink>
  if(mkdir("dd") != 0){
    1b2a:	c7 04 24 b0 43 00 00 	movl   $0x43b0,(%esp)
    1b31:	e8 66 1c 00 00       	call   379c <mkdir>
    1b36:	83 c4 10             	add    $0x10,%esp
    1b39:	85 c0                	test   %eax,%eax
    1b3b:	0f 85 14 04 00 00    	jne    1f55 <subdir+0x44a>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1b41:	83 ec 08             	sub    $0x8,%esp
    1b44:	68 02 02 00 00       	push   $0x202
    1b49:	68 e9 42 00 00       	push   $0x42e9
    1b4e:	e8 21 1c 00 00       	call   3774 <open>
    1b53:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1b55:	83 c4 10             	add    $0x10,%esp
    1b58:	85 c0                	test   %eax,%eax
    1b5a:	0f 88 09 04 00 00    	js     1f69 <subdir+0x45e>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    1b60:	83 ec 04             	sub    $0x4,%esp
    1b63:	6a 02                	push   $0x2
    1b65:	68 13 43 00 00       	push   $0x4313
    1b6a:	50                   	push   %eax
    1b6b:	e8 e4 1b 00 00       	call   3754 <write>
  close(fd);
    1b70:	89 1c 24             	mov    %ebx,(%esp)
    1b73:	e8 e4 1b 00 00       	call   375c <close>

  if(unlink("dd") >= 0){
    1b78:	c7 04 24 b0 43 00 00 	movl   $0x43b0,(%esp)
    1b7f:	e8 00 1c 00 00       	call   3784 <unlink>
    1b84:	83 c4 10             	add    $0x10,%esp
    1b87:	85 c0                	test   %eax,%eax
    1b89:	0f 89 ee 03 00 00    	jns    1f7d <subdir+0x472>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    1b8f:	83 ec 0c             	sub    $0xc,%esp
    1b92:	68 c4 42 00 00       	push   $0x42c4
    1b97:	e8 00 1c 00 00       	call   379c <mkdir>
    1b9c:	83 c4 10             	add    $0x10,%esp
    1b9f:	85 c0                	test   %eax,%eax
    1ba1:	0f 85 ea 03 00 00    	jne    1f91 <subdir+0x486>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1ba7:	83 ec 08             	sub    $0x8,%esp
    1baa:	68 02 02 00 00       	push   $0x202
    1baf:	68 e6 42 00 00       	push   $0x42e6
    1bb4:	e8 bb 1b 00 00       	call   3774 <open>
    1bb9:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1bbb:	83 c4 10             	add    $0x10,%esp
    1bbe:	85 c0                	test   %eax,%eax
    1bc0:	0f 88 df 03 00 00    	js     1fa5 <subdir+0x49a>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    1bc6:	83 ec 04             	sub    $0x4,%esp
    1bc9:	6a 02                	push   $0x2
    1bcb:	68 07 43 00 00       	push   $0x4307
    1bd0:	50                   	push   %eax
    1bd1:	e8 7e 1b 00 00       	call   3754 <write>
  close(fd);
    1bd6:	89 1c 24             	mov    %ebx,(%esp)
    1bd9:	e8 7e 1b 00 00       	call   375c <close>

  fd = open("dd/dd/../ff", 0);
    1bde:	83 c4 08             	add    $0x8,%esp
    1be1:	6a 00                	push   $0x0
    1be3:	68 0a 43 00 00       	push   $0x430a
    1be8:	e8 87 1b 00 00       	call   3774 <open>
    1bed:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1bef:	83 c4 10             	add    $0x10,%esp
    1bf2:	85 c0                	test   %eax,%eax
    1bf4:	0f 88 bf 03 00 00    	js     1fb9 <subdir+0x4ae>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    1bfa:	83 ec 04             	sub    $0x4,%esp
    1bfd:	68 00 20 00 00       	push   $0x2000
    1c02:	68 60 83 00 00       	push   $0x8360
    1c07:	50                   	push   %eax
    1c08:	e8 3f 1b 00 00       	call   374c <read>
  if(cc != 2 || buf[0] != 'f'){
    1c0d:	83 c4 10             	add    $0x10,%esp
    1c10:	83 f8 02             	cmp    $0x2,%eax
    1c13:	0f 85 b4 03 00 00    	jne    1fcd <subdir+0x4c2>
    1c19:	80 3d 60 83 00 00 66 	cmpb   $0x66,0x8360
    1c20:	0f 85 a7 03 00 00    	jne    1fcd <subdir+0x4c2>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    1c26:	83 ec 0c             	sub    $0xc,%esp
    1c29:	53                   	push   %ebx
    1c2a:	e8 2d 1b 00 00       	call   375c <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1c2f:	83 c4 08             	add    $0x8,%esp
    1c32:	68 4a 43 00 00       	push   $0x434a
    1c37:	68 e6 42 00 00       	push   $0x42e6
    1c3c:	e8 53 1b 00 00       	call   3794 <link>
    1c41:	83 c4 10             	add    $0x10,%esp
    1c44:	85 c0                	test   %eax,%eax
    1c46:	0f 85 95 03 00 00    	jne    1fe1 <subdir+0x4d6>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    1c4c:	83 ec 0c             	sub    $0xc,%esp
    1c4f:	68 e6 42 00 00       	push   $0x42e6
    1c54:	e8 2b 1b 00 00       	call   3784 <unlink>
    1c59:	83 c4 10             	add    $0x10,%esp
    1c5c:	85 c0                	test   %eax,%eax
    1c5e:	0f 85 91 03 00 00    	jne    1ff5 <subdir+0x4ea>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1c64:	83 ec 08             	sub    $0x8,%esp
    1c67:	6a 00                	push   $0x0
    1c69:	68 e6 42 00 00       	push   $0x42e6
    1c6e:	e8 01 1b 00 00       	call   3774 <open>
    1c73:	83 c4 10             	add    $0x10,%esp
    1c76:	85 c0                	test   %eax,%eax
    1c78:	0f 89 8b 03 00 00    	jns    2009 <subdir+0x4fe>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    1c7e:	83 ec 0c             	sub    $0xc,%esp
    1c81:	68 b0 43 00 00       	push   $0x43b0
    1c86:	e8 19 1b 00 00       	call   37a4 <chdir>
    1c8b:	83 c4 10             	add    $0x10,%esp
    1c8e:	85 c0                	test   %eax,%eax
    1c90:	0f 85 87 03 00 00    	jne    201d <subdir+0x512>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    1c96:	83 ec 0c             	sub    $0xc,%esp
    1c99:	68 7e 43 00 00       	push   $0x437e
    1c9e:	e8 01 1b 00 00       	call   37a4 <chdir>
    1ca3:	83 c4 10             	add    $0x10,%esp
    1ca6:	85 c0                	test   %eax,%eax
    1ca8:	0f 85 83 03 00 00    	jne    2031 <subdir+0x526>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    1cae:	83 ec 0c             	sub    $0xc,%esp
    1cb1:	68 a4 43 00 00       	push   $0x43a4
    1cb6:	e8 e9 1a 00 00       	call   37a4 <chdir>
    1cbb:	83 c4 10             	add    $0x10,%esp
    1cbe:	85 c0                	test   %eax,%eax
    1cc0:	0f 85 7f 03 00 00    	jne    2045 <subdir+0x53a>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    1cc6:	83 ec 0c             	sub    $0xc,%esp
    1cc9:	68 b3 43 00 00       	push   $0x43b3
    1cce:	e8 d1 1a 00 00       	call   37a4 <chdir>
    1cd3:	83 c4 10             	add    $0x10,%esp
    1cd6:	85 c0                	test   %eax,%eax
    1cd8:	0f 85 7b 03 00 00    	jne    2059 <subdir+0x54e>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1cde:	83 ec 08             	sub    $0x8,%esp
    1ce1:	6a 00                	push   $0x0
    1ce3:	68 4a 43 00 00       	push   $0x434a
    1ce8:	e8 87 1a 00 00       	call   3774 <open>
    1ced:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1cef:	83 c4 10             	add    $0x10,%esp
    1cf2:	85 c0                	test   %eax,%eax
    1cf4:	0f 88 73 03 00 00    	js     206d <subdir+0x562>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1cfa:	83 ec 04             	sub    $0x4,%esp
    1cfd:	68 00 20 00 00       	push   $0x2000
    1d02:	68 60 83 00 00       	push   $0x8360
    1d07:	50                   	push   %eax
    1d08:	e8 3f 1a 00 00       	call   374c <read>
    1d0d:	83 c4 10             	add    $0x10,%esp
    1d10:	83 f8 02             	cmp    $0x2,%eax
    1d13:	0f 85 68 03 00 00    	jne    2081 <subdir+0x576>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    1d19:	83 ec 0c             	sub    $0xc,%esp
    1d1c:	53                   	push   %ebx
    1d1d:	e8 3a 1a 00 00       	call   375c <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1d22:	83 c4 08             	add    $0x8,%esp
    1d25:	6a 00                	push   $0x0
    1d27:	68 e6 42 00 00       	push   $0x42e6
    1d2c:	e8 43 1a 00 00       	call   3774 <open>
    1d31:	83 c4 10             	add    $0x10,%esp
    1d34:	85 c0                	test   %eax,%eax
    1d36:	0f 89 59 03 00 00    	jns    2095 <subdir+0x58a>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1d3c:	83 ec 08             	sub    $0x8,%esp
    1d3f:	68 02 02 00 00       	push   $0x202
    1d44:	68 fe 43 00 00       	push   $0x43fe
    1d49:	e8 26 1a 00 00       	call   3774 <open>
    1d4e:	83 c4 10             	add    $0x10,%esp
    1d51:	85 c0                	test   %eax,%eax
    1d53:	0f 89 50 03 00 00    	jns    20a9 <subdir+0x59e>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1d59:	83 ec 08             	sub    $0x8,%esp
    1d5c:	68 02 02 00 00       	push   $0x202
    1d61:	68 23 44 00 00       	push   $0x4423
    1d66:	e8 09 1a 00 00       	call   3774 <open>
    1d6b:	83 c4 10             	add    $0x10,%esp
    1d6e:	85 c0                	test   %eax,%eax
    1d70:	0f 89 47 03 00 00    	jns    20bd <subdir+0x5b2>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    1d76:	83 ec 08             	sub    $0x8,%esp
    1d79:	68 00 02 00 00       	push   $0x200
    1d7e:	68 b0 43 00 00       	push   $0x43b0
    1d83:	e8 ec 19 00 00       	call   3774 <open>
    1d88:	83 c4 10             	add    $0x10,%esp
    1d8b:	85 c0                	test   %eax,%eax
    1d8d:	0f 89 3e 03 00 00    	jns    20d1 <subdir+0x5c6>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    1d93:	83 ec 08             	sub    $0x8,%esp
    1d96:	6a 02                	push   $0x2
    1d98:	68 b0 43 00 00       	push   $0x43b0
    1d9d:	e8 d2 19 00 00       	call   3774 <open>
    1da2:	83 c4 10             	add    $0x10,%esp
    1da5:	85 c0                	test   %eax,%eax
    1da7:	0f 89 38 03 00 00    	jns    20e5 <subdir+0x5da>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    1dad:	83 ec 08             	sub    $0x8,%esp
    1db0:	6a 01                	push   $0x1
    1db2:	68 b0 43 00 00       	push   $0x43b0
    1db7:	e8 b8 19 00 00       	call   3774 <open>
    1dbc:	83 c4 10             	add    $0x10,%esp
    1dbf:	85 c0                	test   %eax,%eax
    1dc1:	0f 89 32 03 00 00    	jns    20f9 <subdir+0x5ee>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1dc7:	83 ec 08             	sub    $0x8,%esp
    1dca:	68 92 44 00 00       	push   $0x4492
    1dcf:	68 fe 43 00 00       	push   $0x43fe
    1dd4:	e8 bb 19 00 00       	call   3794 <link>
    1dd9:	83 c4 10             	add    $0x10,%esp
    1ddc:	85 c0                	test   %eax,%eax
    1dde:	0f 84 29 03 00 00    	je     210d <subdir+0x602>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1de4:	83 ec 08             	sub    $0x8,%esp
    1de7:	68 92 44 00 00       	push   $0x4492
    1dec:	68 23 44 00 00       	push   $0x4423
    1df1:	e8 9e 19 00 00       	call   3794 <link>
    1df6:	83 c4 10             	add    $0x10,%esp
    1df9:	85 c0                	test   %eax,%eax
    1dfb:	0f 84 20 03 00 00    	je     2121 <subdir+0x616>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1e01:	83 ec 08             	sub    $0x8,%esp
    1e04:	68 4a 43 00 00       	push   $0x434a
    1e09:	68 e9 42 00 00       	push   $0x42e9
    1e0e:	e8 81 19 00 00       	call   3794 <link>
    1e13:	83 c4 10             	add    $0x10,%esp
    1e16:	85 c0                	test   %eax,%eax
    1e18:	0f 84 17 03 00 00    	je     2135 <subdir+0x62a>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    1e1e:	83 ec 0c             	sub    $0xc,%esp
    1e21:	68 fe 43 00 00       	push   $0x43fe
    1e26:	e8 71 19 00 00       	call   379c <mkdir>
    1e2b:	83 c4 10             	add    $0x10,%esp
    1e2e:	85 c0                	test   %eax,%eax
    1e30:	0f 84 13 03 00 00    	je     2149 <subdir+0x63e>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    1e36:	83 ec 0c             	sub    $0xc,%esp
    1e39:	68 23 44 00 00       	push   $0x4423
    1e3e:	e8 59 19 00 00       	call   379c <mkdir>
    1e43:	83 c4 10             	add    $0x10,%esp
    1e46:	85 c0                	test   %eax,%eax
    1e48:	0f 84 0f 03 00 00    	je     215d <subdir+0x652>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    1e4e:	83 ec 0c             	sub    $0xc,%esp
    1e51:	68 4a 43 00 00       	push   $0x434a
    1e56:	e8 41 19 00 00       	call   379c <mkdir>
    1e5b:	83 c4 10             	add    $0x10,%esp
    1e5e:	85 c0                	test   %eax,%eax
    1e60:	0f 84 0b 03 00 00    	je     2171 <subdir+0x666>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    1e66:	83 ec 0c             	sub    $0xc,%esp
    1e69:	68 23 44 00 00       	push   $0x4423
    1e6e:	e8 11 19 00 00       	call   3784 <unlink>
    1e73:	83 c4 10             	add    $0x10,%esp
    1e76:	85 c0                	test   %eax,%eax
    1e78:	0f 84 07 03 00 00    	je     2185 <subdir+0x67a>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    1e7e:	83 ec 0c             	sub    $0xc,%esp
    1e81:	68 fe 43 00 00       	push   $0x43fe
    1e86:	e8 f9 18 00 00       	call   3784 <unlink>
    1e8b:	83 c4 10             	add    $0x10,%esp
    1e8e:	85 c0                	test   %eax,%eax
    1e90:	0f 84 03 03 00 00    	je     2199 <subdir+0x68e>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    1e96:	83 ec 0c             	sub    $0xc,%esp
    1e99:	68 e9 42 00 00       	push   $0x42e9
    1e9e:	e8 01 19 00 00       	call   37a4 <chdir>
    1ea3:	83 c4 10             	add    $0x10,%esp
    1ea6:	85 c0                	test   %eax,%eax
    1ea8:	0f 84 ff 02 00 00    	je     21ad <subdir+0x6a2>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    1eae:	83 ec 0c             	sub    $0xc,%esp
    1eb1:	68 95 44 00 00       	push   $0x4495
    1eb6:	e8 e9 18 00 00       	call   37a4 <chdir>
    1ebb:	83 c4 10             	add    $0x10,%esp
    1ebe:	85 c0                	test   %eax,%eax
    1ec0:	0f 84 fb 02 00 00    	je     21c1 <subdir+0x6b6>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    1ec6:	83 ec 0c             	sub    $0xc,%esp
    1ec9:	68 4a 43 00 00       	push   $0x434a
    1ece:	e8 b1 18 00 00       	call   3784 <unlink>
    1ed3:	83 c4 10             	add    $0x10,%esp
    1ed6:	85 c0                	test   %eax,%eax
    1ed8:	0f 85 f7 02 00 00    	jne    21d5 <subdir+0x6ca>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    1ede:	83 ec 0c             	sub    $0xc,%esp
    1ee1:	68 e9 42 00 00       	push   $0x42e9
    1ee6:	e8 99 18 00 00       	call   3784 <unlink>
    1eeb:	83 c4 10             	add    $0x10,%esp
    1eee:	85 c0                	test   %eax,%eax
    1ef0:	0f 85 f3 02 00 00    	jne    21e9 <subdir+0x6de>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    1ef6:	83 ec 0c             	sub    $0xc,%esp
    1ef9:	68 b0 43 00 00       	push   $0x43b0
    1efe:	e8 81 18 00 00       	call   3784 <unlink>
    1f03:	83 c4 10             	add    $0x10,%esp
    1f06:	85 c0                	test   %eax,%eax
    1f08:	0f 84 ef 02 00 00    	je     21fd <subdir+0x6f2>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    1f0e:	83 ec 0c             	sub    $0xc,%esp
    1f11:	68 c5 42 00 00       	push   $0x42c5
    1f16:	e8 69 18 00 00       	call   3784 <unlink>
    1f1b:	83 c4 10             	add    $0x10,%esp
    1f1e:	85 c0                	test   %eax,%eax
    1f20:	0f 88 eb 02 00 00    	js     2211 <subdir+0x706>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    1f26:	83 ec 0c             	sub    $0xc,%esp
    1f29:	68 b0 43 00 00       	push   $0x43b0
    1f2e:	e8 51 18 00 00       	call   3784 <unlink>
    1f33:	83 c4 10             	add    $0x10,%esp
    1f36:	85 c0                	test   %eax,%eax
    1f38:	0f 88 e7 02 00 00    	js     2225 <subdir+0x71a>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    1f3e:	83 ec 08             	sub    $0x8,%esp
    1f41:	68 92 45 00 00       	push   $0x4592
    1f46:	6a 01                	push   $0x1
    1f48:	e8 39 19 00 00       	call   3886 <printf>
}
    1f4d:	83 c4 10             	add    $0x10,%esp
    1f50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1f53:	c9                   	leave  
    1f54:	c3                   	ret    
    printf(1, "subdir mkdir dd failed\n");
    1f55:	83 ec 08             	sub    $0x8,%esp
    1f58:	68 97 42 00 00       	push   $0x4297
    1f5d:	6a 01                	push   $0x1
    1f5f:	e8 22 19 00 00       	call   3886 <printf>
    exit();
    1f64:	e8 cb 17 00 00       	call   3734 <exit>
    printf(1, "create dd/ff failed\n");
    1f69:	83 ec 08             	sub    $0x8,%esp
    1f6c:	68 af 42 00 00       	push   $0x42af
    1f71:	6a 01                	push   $0x1
    1f73:	e8 0e 19 00 00       	call   3886 <printf>
    exit();
    1f78:	e8 b7 17 00 00       	call   3734 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1f7d:	83 ec 08             	sub    $0x8,%esp
    1f80:	68 7c 4d 00 00       	push   $0x4d7c
    1f85:	6a 01                	push   $0x1
    1f87:	e8 fa 18 00 00       	call   3886 <printf>
    exit();
    1f8c:	e8 a3 17 00 00       	call   3734 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    1f91:	83 ec 08             	sub    $0x8,%esp
    1f94:	68 cb 42 00 00       	push   $0x42cb
    1f99:	6a 01                	push   $0x1
    1f9b:	e8 e6 18 00 00       	call   3886 <printf>
    exit();
    1fa0:	e8 8f 17 00 00       	call   3734 <exit>
    printf(1, "create dd/dd/ff failed\n");
    1fa5:	83 ec 08             	sub    $0x8,%esp
    1fa8:	68 ef 42 00 00       	push   $0x42ef
    1fad:	6a 01                	push   $0x1
    1faf:	e8 d2 18 00 00       	call   3886 <printf>
    exit();
    1fb4:	e8 7b 17 00 00       	call   3734 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    1fb9:	83 ec 08             	sub    $0x8,%esp
    1fbc:	68 16 43 00 00       	push   $0x4316
    1fc1:	6a 01                	push   $0x1
    1fc3:	e8 be 18 00 00       	call   3886 <printf>
    exit();
    1fc8:	e8 67 17 00 00       	call   3734 <exit>
    printf(1, "dd/dd/../ff wrong content\n");
    1fcd:	83 ec 08             	sub    $0x8,%esp
    1fd0:	68 2f 43 00 00       	push   $0x432f
    1fd5:	6a 01                	push   $0x1
    1fd7:	e8 aa 18 00 00       	call   3886 <printf>
    exit();
    1fdc:	e8 53 17 00 00       	call   3734 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1fe1:	83 ec 08             	sub    $0x8,%esp
    1fe4:	68 a4 4d 00 00       	push   $0x4da4
    1fe9:	6a 01                	push   $0x1
    1feb:	e8 96 18 00 00       	call   3886 <printf>
    exit();
    1ff0:	e8 3f 17 00 00       	call   3734 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    1ff5:	83 ec 08             	sub    $0x8,%esp
    1ff8:	68 55 43 00 00       	push   $0x4355
    1ffd:	6a 01                	push   $0x1
    1fff:	e8 82 18 00 00       	call   3886 <printf>
    exit();
    2004:	e8 2b 17 00 00       	call   3734 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2009:	83 ec 08             	sub    $0x8,%esp
    200c:	68 c8 4d 00 00       	push   $0x4dc8
    2011:	6a 01                	push   $0x1
    2013:	e8 6e 18 00 00       	call   3886 <printf>
    exit();
    2018:	e8 17 17 00 00       	call   3734 <exit>
    printf(1, "chdir dd failed\n");
    201d:	83 ec 08             	sub    $0x8,%esp
    2020:	68 6d 43 00 00       	push   $0x436d
    2025:	6a 01                	push   $0x1
    2027:	e8 5a 18 00 00       	call   3886 <printf>
    exit();
    202c:	e8 03 17 00 00       	call   3734 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    2031:	83 ec 08             	sub    $0x8,%esp
    2034:	68 8a 43 00 00       	push   $0x438a
    2039:	6a 01                	push   $0x1
    203b:	e8 46 18 00 00       	call   3886 <printf>
    exit();
    2040:	e8 ef 16 00 00       	call   3734 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    2045:	83 ec 08             	sub    $0x8,%esp
    2048:	68 8a 43 00 00       	push   $0x438a
    204d:	6a 01                	push   $0x1
    204f:	e8 32 18 00 00       	call   3886 <printf>
    exit();
    2054:	e8 db 16 00 00       	call   3734 <exit>
    printf(1, "chdir ./.. failed\n");
    2059:	83 ec 08             	sub    $0x8,%esp
    205c:	68 b8 43 00 00       	push   $0x43b8
    2061:	6a 01                	push   $0x1
    2063:	e8 1e 18 00 00       	call   3886 <printf>
    exit();
    2068:	e8 c7 16 00 00       	call   3734 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    206d:	83 ec 08             	sub    $0x8,%esp
    2070:	68 cb 43 00 00       	push   $0x43cb
    2075:	6a 01                	push   $0x1
    2077:	e8 0a 18 00 00       	call   3886 <printf>
    exit();
    207c:	e8 b3 16 00 00       	call   3734 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    2081:	83 ec 08             	sub    $0x8,%esp
    2084:	68 e3 43 00 00       	push   $0x43e3
    2089:	6a 01                	push   $0x1
    208b:	e8 f6 17 00 00       	call   3886 <printf>
    exit();
    2090:	e8 9f 16 00 00       	call   3734 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2095:	83 ec 08             	sub    $0x8,%esp
    2098:	68 ec 4d 00 00       	push   $0x4dec
    209d:	6a 01                	push   $0x1
    209f:	e8 e2 17 00 00       	call   3886 <printf>
    exit();
    20a4:	e8 8b 16 00 00       	call   3734 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    20a9:	83 ec 08             	sub    $0x8,%esp
    20ac:	68 07 44 00 00       	push   $0x4407
    20b1:	6a 01                	push   $0x1
    20b3:	e8 ce 17 00 00       	call   3886 <printf>
    exit();
    20b8:	e8 77 16 00 00       	call   3734 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    20bd:	83 ec 08             	sub    $0x8,%esp
    20c0:	68 2c 44 00 00       	push   $0x442c
    20c5:	6a 01                	push   $0x1
    20c7:	e8 ba 17 00 00       	call   3886 <printf>
    exit();
    20cc:	e8 63 16 00 00       	call   3734 <exit>
    printf(1, "create dd succeeded!\n");
    20d1:	83 ec 08             	sub    $0x8,%esp
    20d4:	68 48 44 00 00       	push   $0x4448
    20d9:	6a 01                	push   $0x1
    20db:	e8 a6 17 00 00       	call   3886 <printf>
    exit();
    20e0:	e8 4f 16 00 00       	call   3734 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    20e5:	83 ec 08             	sub    $0x8,%esp
    20e8:	68 5e 44 00 00       	push   $0x445e
    20ed:	6a 01                	push   $0x1
    20ef:	e8 92 17 00 00       	call   3886 <printf>
    exit();
    20f4:	e8 3b 16 00 00       	call   3734 <exit>
    printf(1, "open dd wronly succeeded!\n");
    20f9:	83 ec 08             	sub    $0x8,%esp
    20fc:	68 77 44 00 00       	push   $0x4477
    2101:	6a 01                	push   $0x1
    2103:	e8 7e 17 00 00       	call   3886 <printf>
    exit();
    2108:	e8 27 16 00 00       	call   3734 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    210d:	83 ec 08             	sub    $0x8,%esp
    2110:	68 14 4e 00 00       	push   $0x4e14
    2115:	6a 01                	push   $0x1
    2117:	e8 6a 17 00 00       	call   3886 <printf>
    exit();
    211c:	e8 13 16 00 00       	call   3734 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2121:	83 ec 08             	sub    $0x8,%esp
    2124:	68 38 4e 00 00       	push   $0x4e38
    2129:	6a 01                	push   $0x1
    212b:	e8 56 17 00 00       	call   3886 <printf>
    exit();
    2130:	e8 ff 15 00 00       	call   3734 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2135:	83 ec 08             	sub    $0x8,%esp
    2138:	68 5c 4e 00 00       	push   $0x4e5c
    213d:	6a 01                	push   $0x1
    213f:	e8 42 17 00 00       	call   3886 <printf>
    exit();
    2144:	e8 eb 15 00 00       	call   3734 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2149:	83 ec 08             	sub    $0x8,%esp
    214c:	68 9b 44 00 00       	push   $0x449b
    2151:	6a 01                	push   $0x1
    2153:	e8 2e 17 00 00       	call   3886 <printf>
    exit();
    2158:	e8 d7 15 00 00       	call   3734 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    215d:	83 ec 08             	sub    $0x8,%esp
    2160:	68 b6 44 00 00       	push   $0x44b6
    2165:	6a 01                	push   $0x1
    2167:	e8 1a 17 00 00       	call   3886 <printf>
    exit();
    216c:	e8 c3 15 00 00       	call   3734 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2171:	83 ec 08             	sub    $0x8,%esp
    2174:	68 d1 44 00 00       	push   $0x44d1
    2179:	6a 01                	push   $0x1
    217b:	e8 06 17 00 00       	call   3886 <printf>
    exit();
    2180:	e8 af 15 00 00       	call   3734 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2185:	83 ec 08             	sub    $0x8,%esp
    2188:	68 ee 44 00 00       	push   $0x44ee
    218d:	6a 01                	push   $0x1
    218f:	e8 f2 16 00 00       	call   3886 <printf>
    exit();
    2194:	e8 9b 15 00 00       	call   3734 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2199:	83 ec 08             	sub    $0x8,%esp
    219c:	68 0a 45 00 00       	push   $0x450a
    21a1:	6a 01                	push   $0x1
    21a3:	e8 de 16 00 00       	call   3886 <printf>
    exit();
    21a8:	e8 87 15 00 00       	call   3734 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    21ad:	83 ec 08             	sub    $0x8,%esp
    21b0:	68 26 45 00 00       	push   $0x4526
    21b5:	6a 01                	push   $0x1
    21b7:	e8 ca 16 00 00       	call   3886 <printf>
    exit();
    21bc:	e8 73 15 00 00       	call   3734 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    21c1:	83 ec 08             	sub    $0x8,%esp
    21c4:	68 3e 45 00 00       	push   $0x453e
    21c9:	6a 01                	push   $0x1
    21cb:	e8 b6 16 00 00       	call   3886 <printf>
    exit();
    21d0:	e8 5f 15 00 00       	call   3734 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    21d5:	83 ec 08             	sub    $0x8,%esp
    21d8:	68 55 43 00 00       	push   $0x4355
    21dd:	6a 01                	push   $0x1
    21df:	e8 a2 16 00 00       	call   3886 <printf>
    exit();
    21e4:	e8 4b 15 00 00       	call   3734 <exit>
    printf(1, "unlink dd/ff failed\n");
    21e9:	83 ec 08             	sub    $0x8,%esp
    21ec:	68 56 45 00 00       	push   $0x4556
    21f1:	6a 01                	push   $0x1
    21f3:	e8 8e 16 00 00       	call   3886 <printf>
    exit();
    21f8:	e8 37 15 00 00       	call   3734 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    21fd:	83 ec 08             	sub    $0x8,%esp
    2200:	68 80 4e 00 00       	push   $0x4e80
    2205:	6a 01                	push   $0x1
    2207:	e8 7a 16 00 00       	call   3886 <printf>
    exit();
    220c:	e8 23 15 00 00       	call   3734 <exit>
    printf(1, "unlink dd/dd failed\n");
    2211:	83 ec 08             	sub    $0x8,%esp
    2214:	68 6b 45 00 00       	push   $0x456b
    2219:	6a 01                	push   $0x1
    221b:	e8 66 16 00 00       	call   3886 <printf>
    exit();
    2220:	e8 0f 15 00 00       	call   3734 <exit>
    printf(1, "unlink dd failed\n");
    2225:	83 ec 08             	sub    $0x8,%esp
    2228:	68 80 45 00 00       	push   $0x4580
    222d:	6a 01                	push   $0x1
    222f:	e8 52 16 00 00       	call   3886 <printf>
    exit();
    2234:	e8 fb 14 00 00       	call   3734 <exit>

00002239 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    2239:	55                   	push   %ebp
    223a:	89 e5                	mov    %esp,%ebp
    223c:	57                   	push   %edi
    223d:	56                   	push   %esi
    223e:	53                   	push   %ebx
    223f:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    2242:	68 9d 45 00 00       	push   $0x459d
    2247:	6a 01                	push   $0x1
    2249:	e8 38 16 00 00       	call   3886 <printf>

  unlink("bigwrite");
    224e:	c7 04 24 ac 45 00 00 	movl   $0x45ac,(%esp)
    2255:	e8 2a 15 00 00       	call   3784 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    225a:	83 c4 10             	add    $0x10,%esp
    225d:	be f3 01 00 00       	mov    $0x1f3,%esi
    2262:	eb 45                	jmp    22a9 <bigwrite+0x70>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
    2264:	83 ec 08             	sub    $0x8,%esp
    2267:	68 b5 45 00 00       	push   $0x45b5
    226c:	6a 01                	push   $0x1
    226e:	e8 13 16 00 00       	call   3886 <printf>
      exit();
    2273:	e8 bc 14 00 00       	call   3734 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
    2278:	50                   	push   %eax
    2279:	56                   	push   %esi
    227a:	68 cd 45 00 00       	push   $0x45cd
    227f:	6a 01                	push   $0x1
    2281:	e8 00 16 00 00       	call   3886 <printf>
        exit();
    2286:	e8 a9 14 00 00       	call   3734 <exit>
      }
    }
    close(fd);
    228b:	83 ec 0c             	sub    $0xc,%esp
    228e:	57                   	push   %edi
    228f:	e8 c8 14 00 00       	call   375c <close>
    unlink("bigwrite");
    2294:	c7 04 24 ac 45 00 00 	movl   $0x45ac,(%esp)
    229b:	e8 e4 14 00 00       	call   3784 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    22a0:	81 c6 d7 01 00 00    	add    $0x1d7,%esi
    22a6:	83 c4 10             	add    $0x10,%esp
    22a9:	81 fe ff 17 00 00    	cmp    $0x17ff,%esi
    22af:	7f 40                	jg     22f1 <bigwrite+0xb8>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    22b1:	83 ec 08             	sub    $0x8,%esp
    22b4:	68 02 02 00 00       	push   $0x202
    22b9:	68 ac 45 00 00       	push   $0x45ac
    22be:	e8 b1 14 00 00       	call   3774 <open>
    22c3:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    22c5:	83 c4 10             	add    $0x10,%esp
    22c8:	85 c0                	test   %eax,%eax
    22ca:	78 98                	js     2264 <bigwrite+0x2b>
    for(i = 0; i < 2; i++){
    22cc:	bb 00 00 00 00       	mov    $0x0,%ebx
    22d1:	83 fb 01             	cmp    $0x1,%ebx
    22d4:	7f b5                	jg     228b <bigwrite+0x52>
      int cc = write(fd, buf, sz);
    22d6:	83 ec 04             	sub    $0x4,%esp
    22d9:	56                   	push   %esi
    22da:	68 60 83 00 00       	push   $0x8360
    22df:	57                   	push   %edi
    22e0:	e8 6f 14 00 00       	call   3754 <write>
      if(cc != sz){
    22e5:	83 c4 10             	add    $0x10,%esp
    22e8:	39 c6                	cmp    %eax,%esi
    22ea:	75 8c                	jne    2278 <bigwrite+0x3f>
    for(i = 0; i < 2; i++){
    22ec:	83 c3 01             	add    $0x1,%ebx
    22ef:	eb e0                	jmp    22d1 <bigwrite+0x98>
  }

  printf(1, "bigwrite ok\n");
    22f1:	83 ec 08             	sub    $0x8,%esp
    22f4:	68 df 45 00 00       	push   $0x45df
    22f9:	6a 01                	push   $0x1
    22fb:	e8 86 15 00 00       	call   3886 <printf>
}
    2300:	83 c4 10             	add    $0x10,%esp
    2303:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2306:	5b                   	pop    %ebx
    2307:	5e                   	pop    %esi
    2308:	5f                   	pop    %edi
    2309:	5d                   	pop    %ebp
    230a:	c3                   	ret    

0000230b <bigfile>:

void
bigfile(void)
{
    230b:	55                   	push   %ebp
    230c:	89 e5                	mov    %esp,%ebp
    230e:	57                   	push   %edi
    230f:	56                   	push   %esi
    2310:	53                   	push   %ebx
    2311:	83 ec 14             	sub    $0x14,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2314:	68 ec 45 00 00       	push   $0x45ec
    2319:	6a 01                	push   $0x1
    231b:	e8 66 15 00 00       	call   3886 <printf>

  unlink("bigfile");
    2320:	c7 04 24 08 46 00 00 	movl   $0x4608,(%esp)
    2327:	e8 58 14 00 00       	call   3784 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    232c:	83 c4 08             	add    $0x8,%esp
    232f:	68 02 02 00 00       	push   $0x202
    2334:	68 08 46 00 00       	push   $0x4608
    2339:	e8 36 14 00 00       	call   3774 <open>
  if(fd < 0){
    233e:	83 c4 10             	add    $0x10,%esp
    2341:	85 c0                	test   %eax,%eax
    2343:	78 09                	js     234e <bigfile+0x43>
    2345:	89 c6                	mov    %eax,%esi
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    2347:	bb 00 00 00 00       	mov    $0x0,%ebx
    234c:	eb 17                	jmp    2365 <bigfile+0x5a>
    printf(1, "cannot create bigfile");
    234e:	83 ec 08             	sub    $0x8,%esp
    2351:	68 fa 45 00 00       	push   $0x45fa
    2356:	6a 01                	push   $0x1
    2358:	e8 29 15 00 00       	call   3886 <printf>
    exit();
    235d:	e8 d2 13 00 00       	call   3734 <exit>
  for(i = 0; i < 20; i++){
    2362:	83 c3 01             	add    $0x1,%ebx
    2365:	83 fb 13             	cmp    $0x13,%ebx
    2368:	7f 44                	jg     23ae <bigfile+0xa3>
    memset(buf, i, 600);
    236a:	83 ec 04             	sub    $0x4,%esp
    236d:	68 58 02 00 00       	push   $0x258
    2372:	53                   	push   %ebx
    2373:	68 60 83 00 00       	push   $0x8360
    2378:	e8 88 12 00 00       	call   3605 <memset>
    if(write(fd, buf, 600) != 600){
    237d:	83 c4 0c             	add    $0xc,%esp
    2380:	68 58 02 00 00       	push   $0x258
    2385:	68 60 83 00 00       	push   $0x8360
    238a:	56                   	push   %esi
    238b:	e8 c4 13 00 00       	call   3754 <write>
    2390:	83 c4 10             	add    $0x10,%esp
    2393:	3d 58 02 00 00       	cmp    $0x258,%eax
    2398:	74 c8                	je     2362 <bigfile+0x57>
      printf(1, "write bigfile failed\n");
    239a:	83 ec 08             	sub    $0x8,%esp
    239d:	68 10 46 00 00       	push   $0x4610
    23a2:	6a 01                	push   $0x1
    23a4:	e8 dd 14 00 00       	call   3886 <printf>
      exit();
    23a9:	e8 86 13 00 00       	call   3734 <exit>
    }
  }
  close(fd);
    23ae:	83 ec 0c             	sub    $0xc,%esp
    23b1:	56                   	push   %esi
    23b2:	e8 a5 13 00 00       	call   375c <close>

  fd = open("bigfile", 0);
    23b7:	83 c4 08             	add    $0x8,%esp
    23ba:	6a 00                	push   $0x0
    23bc:	68 08 46 00 00       	push   $0x4608
    23c1:	e8 ae 13 00 00       	call   3774 <open>
    23c6:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    23c8:	83 c4 10             	add    $0x10,%esp
    23cb:	85 c0                	test   %eax,%eax
    23cd:	78 55                	js     2424 <bigfile+0x119>
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
    23cf:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; ; i++){
    23d4:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(fd, buf, 300);
    23d9:	83 ec 04             	sub    $0x4,%esp
    23dc:	68 2c 01 00 00       	push   $0x12c
    23e1:	68 60 83 00 00       	push   $0x8360
    23e6:	57                   	push   %edi
    23e7:	e8 60 13 00 00       	call   374c <read>
    if(cc < 0){
    23ec:	83 c4 10             	add    $0x10,%esp
    23ef:	85 c0                	test   %eax,%eax
    23f1:	78 45                	js     2438 <bigfile+0x12d>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    23f3:	85 c0                	test   %eax,%eax
    23f5:	74 7d                	je     2474 <bigfile+0x169>
      break;
    if(cc != 300){
    23f7:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    23fc:	75 4e                	jne    244c <bigfile+0x141>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    23fe:	0f be 0d 60 83 00 00 	movsbl 0x8360,%ecx
    2405:	89 da                	mov    %ebx,%edx
    2407:	c1 ea 1f             	shr    $0x1f,%edx
    240a:	01 da                	add    %ebx,%edx
    240c:	d1 fa                	sar    %edx
    240e:	39 d1                	cmp    %edx,%ecx
    2410:	75 4e                	jne    2460 <bigfile+0x155>
    2412:	0f be 0d 8b 84 00 00 	movsbl 0x848b,%ecx
    2419:	39 ca                	cmp    %ecx,%edx
    241b:	75 43                	jne    2460 <bigfile+0x155>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
    241d:	01 c6                	add    %eax,%esi
  for(i = 0; ; i++){
    241f:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
    2422:	eb b5                	jmp    23d9 <bigfile+0xce>
    printf(1, "cannot open bigfile\n");
    2424:	83 ec 08             	sub    $0x8,%esp
    2427:	68 26 46 00 00       	push   $0x4626
    242c:	6a 01                	push   $0x1
    242e:	e8 53 14 00 00       	call   3886 <printf>
    exit();
    2433:	e8 fc 12 00 00       	call   3734 <exit>
      printf(1, "read bigfile failed\n");
    2438:	83 ec 08             	sub    $0x8,%esp
    243b:	68 3b 46 00 00       	push   $0x463b
    2440:	6a 01                	push   $0x1
    2442:	e8 3f 14 00 00       	call   3886 <printf>
      exit();
    2447:	e8 e8 12 00 00       	call   3734 <exit>
      printf(1, "short read bigfile\n");
    244c:	83 ec 08             	sub    $0x8,%esp
    244f:	68 50 46 00 00       	push   $0x4650
    2454:	6a 01                	push   $0x1
    2456:	e8 2b 14 00 00       	call   3886 <printf>
      exit();
    245b:	e8 d4 12 00 00       	call   3734 <exit>
      printf(1, "read bigfile wrong data\n");
    2460:	83 ec 08             	sub    $0x8,%esp
    2463:	68 64 46 00 00       	push   $0x4664
    2468:	6a 01                	push   $0x1
    246a:	e8 17 14 00 00       	call   3886 <printf>
      exit();
    246f:	e8 c0 12 00 00       	call   3734 <exit>
  }
  close(fd);
    2474:	83 ec 0c             	sub    $0xc,%esp
    2477:	57                   	push   %edi
    2478:	e8 df 12 00 00       	call   375c <close>
  if(total != 20*600){
    247d:	83 c4 10             	add    $0x10,%esp
    2480:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    2486:	75 27                	jne    24af <bigfile+0x1a4>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    2488:	83 ec 0c             	sub    $0xc,%esp
    248b:	68 08 46 00 00       	push   $0x4608
    2490:	e8 ef 12 00 00       	call   3784 <unlink>

  printf(1, "bigfile test ok\n");
    2495:	83 c4 08             	add    $0x8,%esp
    2498:	68 97 46 00 00       	push   $0x4697
    249d:	6a 01                	push   $0x1
    249f:	e8 e2 13 00 00       	call   3886 <printf>
}
    24a4:	83 c4 10             	add    $0x10,%esp
    24a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    24aa:	5b                   	pop    %ebx
    24ab:	5e                   	pop    %esi
    24ac:	5f                   	pop    %edi
    24ad:	5d                   	pop    %ebp
    24ae:	c3                   	ret    
    printf(1, "read bigfile wrong total\n");
    24af:	83 ec 08             	sub    $0x8,%esp
    24b2:	68 7d 46 00 00       	push   $0x467d
    24b7:	6a 01                	push   $0x1
    24b9:	e8 c8 13 00 00       	call   3886 <printf>
    exit();
    24be:	e8 71 12 00 00       	call   3734 <exit>

000024c3 <fourteen>:

void
fourteen(void)
{
    24c3:	55                   	push   %ebp
    24c4:	89 e5                	mov    %esp,%ebp
    24c6:	83 ec 10             	sub    $0x10,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    24c9:	68 a8 46 00 00       	push   $0x46a8
    24ce:	6a 01                	push   $0x1
    24d0:	e8 b1 13 00 00       	call   3886 <printf>

  if(mkdir("12345678901234") != 0){
    24d5:	c7 04 24 e3 46 00 00 	movl   $0x46e3,(%esp)
    24dc:	e8 bb 12 00 00       	call   379c <mkdir>
    24e1:	83 c4 10             	add    $0x10,%esp
    24e4:	85 c0                	test   %eax,%eax
    24e6:	0f 85 9c 00 00 00    	jne    2588 <fourteen+0xc5>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    24ec:	83 ec 0c             	sub    $0xc,%esp
    24ef:	68 a0 4e 00 00       	push   $0x4ea0
    24f4:	e8 a3 12 00 00       	call   379c <mkdir>
    24f9:	83 c4 10             	add    $0x10,%esp
    24fc:	85 c0                	test   %eax,%eax
    24fe:	0f 85 98 00 00 00    	jne    259c <fourteen+0xd9>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2504:	83 ec 08             	sub    $0x8,%esp
    2507:	68 00 02 00 00       	push   $0x200
    250c:	68 f0 4e 00 00       	push   $0x4ef0
    2511:	e8 5e 12 00 00       	call   3774 <open>
  if(fd < 0){
    2516:	83 c4 10             	add    $0x10,%esp
    2519:	85 c0                	test   %eax,%eax
    251b:	0f 88 8f 00 00 00    	js     25b0 <fourteen+0xed>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    2521:	83 ec 0c             	sub    $0xc,%esp
    2524:	50                   	push   %eax
    2525:	e8 32 12 00 00       	call   375c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    252a:	83 c4 08             	add    $0x8,%esp
    252d:	6a 00                	push   $0x0
    252f:	68 60 4f 00 00       	push   $0x4f60
    2534:	e8 3b 12 00 00       	call   3774 <open>
  if(fd < 0){
    2539:	83 c4 10             	add    $0x10,%esp
    253c:	85 c0                	test   %eax,%eax
    253e:	0f 88 80 00 00 00    	js     25c4 <fourteen+0x101>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    2544:	83 ec 0c             	sub    $0xc,%esp
    2547:	50                   	push   %eax
    2548:	e8 0f 12 00 00       	call   375c <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    254d:	c7 04 24 d4 46 00 00 	movl   $0x46d4,(%esp)
    2554:	e8 43 12 00 00       	call   379c <mkdir>
    2559:	83 c4 10             	add    $0x10,%esp
    255c:	85 c0                	test   %eax,%eax
    255e:	74 78                	je     25d8 <fourteen+0x115>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2560:	83 ec 0c             	sub    $0xc,%esp
    2563:	68 fc 4f 00 00       	push   $0x4ffc
    2568:	e8 2f 12 00 00       	call   379c <mkdir>
    256d:	83 c4 10             	add    $0x10,%esp
    2570:	85 c0                	test   %eax,%eax
    2572:	74 78                	je     25ec <fourteen+0x129>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
    2574:	83 ec 08             	sub    $0x8,%esp
    2577:	68 f2 46 00 00       	push   $0x46f2
    257c:	6a 01                	push   $0x1
    257e:	e8 03 13 00 00       	call   3886 <printf>
}
    2583:	83 c4 10             	add    $0x10,%esp
    2586:	c9                   	leave  
    2587:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    2588:	83 ec 08             	sub    $0x8,%esp
    258b:	68 b7 46 00 00       	push   $0x46b7
    2590:	6a 01                	push   $0x1
    2592:	e8 ef 12 00 00       	call   3886 <printf>
    exit();
    2597:	e8 98 11 00 00       	call   3734 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    259c:	83 ec 08             	sub    $0x8,%esp
    259f:	68 c0 4e 00 00       	push   $0x4ec0
    25a4:	6a 01                	push   $0x1
    25a6:	e8 db 12 00 00       	call   3886 <printf>
    exit();
    25ab:	e8 84 11 00 00       	call   3734 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    25b0:	83 ec 08             	sub    $0x8,%esp
    25b3:	68 20 4f 00 00       	push   $0x4f20
    25b8:	6a 01                	push   $0x1
    25ba:	e8 c7 12 00 00       	call   3886 <printf>
    exit();
    25bf:	e8 70 11 00 00       	call   3734 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    25c4:	83 ec 08             	sub    $0x8,%esp
    25c7:	68 90 4f 00 00       	push   $0x4f90
    25cc:	6a 01                	push   $0x1
    25ce:	e8 b3 12 00 00       	call   3886 <printf>
    exit();
    25d3:	e8 5c 11 00 00       	call   3734 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    25d8:	83 ec 08             	sub    $0x8,%esp
    25db:	68 cc 4f 00 00       	push   $0x4fcc
    25e0:	6a 01                	push   $0x1
    25e2:	e8 9f 12 00 00       	call   3886 <printf>
    exit();
    25e7:	e8 48 11 00 00       	call   3734 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    25ec:	83 ec 08             	sub    $0x8,%esp
    25ef:	68 1c 50 00 00       	push   $0x501c
    25f4:	6a 01                	push   $0x1
    25f6:	e8 8b 12 00 00       	call   3886 <printf>
    exit();
    25fb:	e8 34 11 00 00       	call   3734 <exit>

00002600 <rmdot>:

void
rmdot(void)
{
    2600:	55                   	push   %ebp
    2601:	89 e5                	mov    %esp,%ebp
    2603:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    2606:	68 ff 46 00 00       	push   $0x46ff
    260b:	6a 01                	push   $0x1
    260d:	e8 74 12 00 00       	call   3886 <printf>
  if(mkdir("dots") != 0){
    2612:	c7 04 24 0b 47 00 00 	movl   $0x470b,(%esp)
    2619:	e8 7e 11 00 00       	call   379c <mkdir>
    261e:	83 c4 10             	add    $0x10,%esp
    2621:	85 c0                	test   %eax,%eax
    2623:	0f 85 bc 00 00 00    	jne    26e5 <rmdot+0xe5>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    2629:	83 ec 0c             	sub    $0xc,%esp
    262c:	68 0b 47 00 00       	push   $0x470b
    2631:	e8 6e 11 00 00       	call   37a4 <chdir>
    2636:	83 c4 10             	add    $0x10,%esp
    2639:	85 c0                	test   %eax,%eax
    263b:	0f 85 b8 00 00 00    	jne    26f9 <rmdot+0xf9>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    2641:	83 ec 0c             	sub    $0xc,%esp
    2644:	68 b6 43 00 00       	push   $0x43b6
    2649:	e8 36 11 00 00       	call   3784 <unlink>
    264e:	83 c4 10             	add    $0x10,%esp
    2651:	85 c0                	test   %eax,%eax
    2653:	0f 84 b4 00 00 00    	je     270d <rmdot+0x10d>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    2659:	83 ec 0c             	sub    $0xc,%esp
    265c:	68 b5 43 00 00       	push   $0x43b5
    2661:	e8 1e 11 00 00       	call   3784 <unlink>
    2666:	83 c4 10             	add    $0x10,%esp
    2669:	85 c0                	test   %eax,%eax
    266b:	0f 84 b0 00 00 00    	je     2721 <rmdot+0x121>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    2671:	83 ec 0c             	sub    $0xc,%esp
    2674:	68 89 3b 00 00       	push   $0x3b89
    2679:	e8 26 11 00 00       	call   37a4 <chdir>
    267e:	83 c4 10             	add    $0x10,%esp
    2681:	85 c0                	test   %eax,%eax
    2683:	0f 85 ac 00 00 00    	jne    2735 <rmdot+0x135>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    2689:	83 ec 0c             	sub    $0xc,%esp
    268c:	68 53 47 00 00       	push   $0x4753
    2691:	e8 ee 10 00 00       	call   3784 <unlink>
    2696:	83 c4 10             	add    $0x10,%esp
    2699:	85 c0                	test   %eax,%eax
    269b:	0f 84 a8 00 00 00    	je     2749 <rmdot+0x149>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    26a1:	83 ec 0c             	sub    $0xc,%esp
    26a4:	68 71 47 00 00       	push   $0x4771
    26a9:	e8 d6 10 00 00       	call   3784 <unlink>
    26ae:	83 c4 10             	add    $0x10,%esp
    26b1:	85 c0                	test   %eax,%eax
    26b3:	0f 84 a4 00 00 00    	je     275d <rmdot+0x15d>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    26b9:	83 ec 0c             	sub    $0xc,%esp
    26bc:	68 0b 47 00 00       	push   $0x470b
    26c1:	e8 be 10 00 00       	call   3784 <unlink>
    26c6:	83 c4 10             	add    $0x10,%esp
    26c9:	85 c0                	test   %eax,%eax
    26cb:	0f 85 a0 00 00 00    	jne    2771 <rmdot+0x171>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
    26d1:	83 ec 08             	sub    $0x8,%esp
    26d4:	68 a6 47 00 00       	push   $0x47a6
    26d9:	6a 01                	push   $0x1
    26db:	e8 a6 11 00 00       	call   3886 <printf>
}
    26e0:	83 c4 10             	add    $0x10,%esp
    26e3:	c9                   	leave  
    26e4:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    26e5:	83 ec 08             	sub    $0x8,%esp
    26e8:	68 10 47 00 00       	push   $0x4710
    26ed:	6a 01                	push   $0x1
    26ef:	e8 92 11 00 00       	call   3886 <printf>
    exit();
    26f4:	e8 3b 10 00 00       	call   3734 <exit>
    printf(1, "chdir dots failed\n");
    26f9:	83 ec 08             	sub    $0x8,%esp
    26fc:	68 23 47 00 00       	push   $0x4723
    2701:	6a 01                	push   $0x1
    2703:	e8 7e 11 00 00       	call   3886 <printf>
    exit();
    2708:	e8 27 10 00 00       	call   3734 <exit>
    printf(1, "rm . worked!\n");
    270d:	83 ec 08             	sub    $0x8,%esp
    2710:	68 36 47 00 00       	push   $0x4736
    2715:	6a 01                	push   $0x1
    2717:	e8 6a 11 00 00       	call   3886 <printf>
    exit();
    271c:	e8 13 10 00 00       	call   3734 <exit>
    printf(1, "rm .. worked!\n");
    2721:	83 ec 08             	sub    $0x8,%esp
    2724:	68 44 47 00 00       	push   $0x4744
    2729:	6a 01                	push   $0x1
    272b:	e8 56 11 00 00       	call   3886 <printf>
    exit();
    2730:	e8 ff 0f 00 00       	call   3734 <exit>
    printf(1, "chdir / failed\n");
    2735:	83 ec 08             	sub    $0x8,%esp
    2738:	68 8b 3b 00 00       	push   $0x3b8b
    273d:	6a 01                	push   $0x1
    273f:	e8 42 11 00 00       	call   3886 <printf>
    exit();
    2744:	e8 eb 0f 00 00       	call   3734 <exit>
    printf(1, "unlink dots/. worked!\n");
    2749:	83 ec 08             	sub    $0x8,%esp
    274c:	68 5a 47 00 00       	push   $0x475a
    2751:	6a 01                	push   $0x1
    2753:	e8 2e 11 00 00       	call   3886 <printf>
    exit();
    2758:	e8 d7 0f 00 00       	call   3734 <exit>
    printf(1, "unlink dots/.. worked!\n");
    275d:	83 ec 08             	sub    $0x8,%esp
    2760:	68 79 47 00 00       	push   $0x4779
    2765:	6a 01                	push   $0x1
    2767:	e8 1a 11 00 00       	call   3886 <printf>
    exit();
    276c:	e8 c3 0f 00 00       	call   3734 <exit>
    printf(1, "unlink dots failed!\n");
    2771:	83 ec 08             	sub    $0x8,%esp
    2774:	68 91 47 00 00       	push   $0x4791
    2779:	6a 01                	push   $0x1
    277b:	e8 06 11 00 00       	call   3886 <printf>
    exit();
    2780:	e8 af 0f 00 00       	call   3734 <exit>

00002785 <dirfile>:

void
dirfile(void)
{
    2785:	55                   	push   %ebp
    2786:	89 e5                	mov    %esp,%ebp
    2788:	53                   	push   %ebx
    2789:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    278c:	68 b0 47 00 00       	push   $0x47b0
    2791:	6a 01                	push   $0x1
    2793:	e8 ee 10 00 00       	call   3886 <printf>

  fd = open("dirfile", O_CREATE);
    2798:	83 c4 08             	add    $0x8,%esp
    279b:	68 00 02 00 00       	push   $0x200
    27a0:	68 bd 47 00 00       	push   $0x47bd
    27a5:	e8 ca 0f 00 00       	call   3774 <open>
  if(fd < 0){
    27aa:	83 c4 10             	add    $0x10,%esp
    27ad:	85 c0                	test   %eax,%eax
    27af:	0f 88 22 01 00 00    	js     28d7 <dirfile+0x152>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    27b5:	83 ec 0c             	sub    $0xc,%esp
    27b8:	50                   	push   %eax
    27b9:	e8 9e 0f 00 00       	call   375c <close>
  if(chdir("dirfile") == 0){
    27be:	c7 04 24 bd 47 00 00 	movl   $0x47bd,(%esp)
    27c5:	e8 da 0f 00 00       	call   37a4 <chdir>
    27ca:	83 c4 10             	add    $0x10,%esp
    27cd:	85 c0                	test   %eax,%eax
    27cf:	0f 84 16 01 00 00    	je     28eb <dirfile+0x166>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    27d5:	83 ec 08             	sub    $0x8,%esp
    27d8:	6a 00                	push   $0x0
    27da:	68 f6 47 00 00       	push   $0x47f6
    27df:	e8 90 0f 00 00       	call   3774 <open>
  if(fd >= 0){
    27e4:	83 c4 10             	add    $0x10,%esp
    27e7:	85 c0                	test   %eax,%eax
    27e9:	0f 89 10 01 00 00    	jns    28ff <dirfile+0x17a>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    27ef:	83 ec 08             	sub    $0x8,%esp
    27f2:	68 00 02 00 00       	push   $0x200
    27f7:	68 f6 47 00 00       	push   $0x47f6
    27fc:	e8 73 0f 00 00       	call   3774 <open>
  if(fd >= 0){
    2801:	83 c4 10             	add    $0x10,%esp
    2804:	85 c0                	test   %eax,%eax
    2806:	0f 89 07 01 00 00    	jns    2913 <dirfile+0x18e>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    280c:	83 ec 0c             	sub    $0xc,%esp
    280f:	68 f6 47 00 00       	push   $0x47f6
    2814:	e8 83 0f 00 00       	call   379c <mkdir>
    2819:	83 c4 10             	add    $0x10,%esp
    281c:	85 c0                	test   %eax,%eax
    281e:	0f 84 03 01 00 00    	je     2927 <dirfile+0x1a2>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    2824:	83 ec 0c             	sub    $0xc,%esp
    2827:	68 f6 47 00 00       	push   $0x47f6
    282c:	e8 53 0f 00 00       	call   3784 <unlink>
    2831:	83 c4 10             	add    $0x10,%esp
    2834:	85 c0                	test   %eax,%eax
    2836:	0f 84 ff 00 00 00    	je     293b <dirfile+0x1b6>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    283c:	83 ec 08             	sub    $0x8,%esp
    283f:	68 f6 47 00 00       	push   $0x47f6
    2844:	68 5a 48 00 00       	push   $0x485a
    2849:	e8 46 0f 00 00       	call   3794 <link>
    284e:	83 c4 10             	add    $0x10,%esp
    2851:	85 c0                	test   %eax,%eax
    2853:	0f 84 f6 00 00 00    	je     294f <dirfile+0x1ca>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    2859:	83 ec 0c             	sub    $0xc,%esp
    285c:	68 bd 47 00 00       	push   $0x47bd
    2861:	e8 1e 0f 00 00       	call   3784 <unlink>
    2866:	83 c4 10             	add    $0x10,%esp
    2869:	85 c0                	test   %eax,%eax
    286b:	0f 85 f2 00 00 00    	jne    2963 <dirfile+0x1de>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    2871:	83 ec 08             	sub    $0x8,%esp
    2874:	6a 02                	push   $0x2
    2876:	68 b6 43 00 00       	push   $0x43b6
    287b:	e8 f4 0e 00 00       	call   3774 <open>
  if(fd >= 0){
    2880:	83 c4 10             	add    $0x10,%esp
    2883:	85 c0                	test   %eax,%eax
    2885:	0f 89 ec 00 00 00    	jns    2977 <dirfile+0x1f2>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    288b:	83 ec 08             	sub    $0x8,%esp
    288e:	6a 00                	push   $0x0
    2890:	68 b6 43 00 00       	push   $0x43b6
    2895:	e8 da 0e 00 00       	call   3774 <open>
    289a:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    289c:	83 c4 0c             	add    $0xc,%esp
    289f:	6a 01                	push   $0x1
    28a1:	68 99 44 00 00       	push   $0x4499
    28a6:	50                   	push   %eax
    28a7:	e8 a8 0e 00 00       	call   3754 <write>
    28ac:	83 c4 10             	add    $0x10,%esp
    28af:	85 c0                	test   %eax,%eax
    28b1:	0f 8f d4 00 00 00    	jg     298b <dirfile+0x206>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
    28b7:	83 ec 0c             	sub    $0xc,%esp
    28ba:	53                   	push   %ebx
    28bb:	e8 9c 0e 00 00       	call   375c <close>

  printf(1, "dir vs file OK\n");
    28c0:	83 c4 08             	add    $0x8,%esp
    28c3:	68 8d 48 00 00       	push   $0x488d
    28c8:	6a 01                	push   $0x1
    28ca:	e8 b7 0f 00 00       	call   3886 <printf>
}
    28cf:	83 c4 10             	add    $0x10,%esp
    28d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    28d5:	c9                   	leave  
    28d6:	c3                   	ret    
    printf(1, "create dirfile failed\n");
    28d7:	83 ec 08             	sub    $0x8,%esp
    28da:	68 c5 47 00 00       	push   $0x47c5
    28df:	6a 01                	push   $0x1
    28e1:	e8 a0 0f 00 00       	call   3886 <printf>
    exit();
    28e6:	e8 49 0e 00 00       	call   3734 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    28eb:	83 ec 08             	sub    $0x8,%esp
    28ee:	68 dc 47 00 00       	push   $0x47dc
    28f3:	6a 01                	push   $0x1
    28f5:	e8 8c 0f 00 00       	call   3886 <printf>
    exit();
    28fa:	e8 35 0e 00 00       	call   3734 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    28ff:	83 ec 08             	sub    $0x8,%esp
    2902:	68 01 48 00 00       	push   $0x4801
    2907:	6a 01                	push   $0x1
    2909:	e8 78 0f 00 00       	call   3886 <printf>
    exit();
    290e:	e8 21 0e 00 00       	call   3734 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2913:	83 ec 08             	sub    $0x8,%esp
    2916:	68 01 48 00 00       	push   $0x4801
    291b:	6a 01                	push   $0x1
    291d:	e8 64 0f 00 00       	call   3886 <printf>
    exit();
    2922:	e8 0d 0e 00 00       	call   3734 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2927:	83 ec 08             	sub    $0x8,%esp
    292a:	68 1f 48 00 00       	push   $0x481f
    292f:	6a 01                	push   $0x1
    2931:	e8 50 0f 00 00       	call   3886 <printf>
    exit();
    2936:	e8 f9 0d 00 00       	call   3734 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    293b:	83 ec 08             	sub    $0x8,%esp
    293e:	68 3c 48 00 00       	push   $0x483c
    2943:	6a 01                	push   $0x1
    2945:	e8 3c 0f 00 00       	call   3886 <printf>
    exit();
    294a:	e8 e5 0d 00 00       	call   3734 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    294f:	83 ec 08             	sub    $0x8,%esp
    2952:	68 50 50 00 00       	push   $0x5050
    2957:	6a 01                	push   $0x1
    2959:	e8 28 0f 00 00       	call   3886 <printf>
    exit();
    295e:	e8 d1 0d 00 00       	call   3734 <exit>
    printf(1, "unlink dirfile failed!\n");
    2963:	83 ec 08             	sub    $0x8,%esp
    2966:	68 61 48 00 00       	push   $0x4861
    296b:	6a 01                	push   $0x1
    296d:	e8 14 0f 00 00       	call   3886 <printf>
    exit();
    2972:	e8 bd 0d 00 00       	call   3734 <exit>
    printf(1, "open . for writing succeeded!\n");
    2977:	83 ec 08             	sub    $0x8,%esp
    297a:	68 70 50 00 00       	push   $0x5070
    297f:	6a 01                	push   $0x1
    2981:	e8 00 0f 00 00       	call   3886 <printf>
    exit();
    2986:	e8 a9 0d 00 00       	call   3734 <exit>
    printf(1, "write . succeeded!\n");
    298b:	83 ec 08             	sub    $0x8,%esp
    298e:	68 79 48 00 00       	push   $0x4879
    2993:	6a 01                	push   $0x1
    2995:	e8 ec 0e 00 00       	call   3886 <printf>
    exit();
    299a:	e8 95 0d 00 00       	call   3734 <exit>

0000299f <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    299f:	55                   	push   %ebp
    29a0:	89 e5                	mov    %esp,%ebp
    29a2:	53                   	push   %ebx
    29a3:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    29a6:	68 9d 48 00 00       	push   $0x489d
    29ab:	6a 01                	push   $0x1
    29ad:	e8 d4 0e 00 00       	call   3886 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    29b2:	83 c4 10             	add    $0x10,%esp
    29b5:	bb 00 00 00 00       	mov    $0x0,%ebx
    29ba:	eb 4c                	jmp    2a08 <iref+0x69>
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    29bc:	83 ec 08             	sub    $0x8,%esp
    29bf:	68 b4 48 00 00       	push   $0x48b4
    29c4:	6a 01                	push   $0x1
    29c6:	e8 bb 0e 00 00       	call   3886 <printf>
      exit();
    29cb:	e8 64 0d 00 00       	call   3734 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    29d0:	83 ec 08             	sub    $0x8,%esp
    29d3:	68 c8 48 00 00       	push   $0x48c8
    29d8:	6a 01                	push   $0x1
    29da:	e8 a7 0e 00 00       	call   3886 <printf>
      exit();
    29df:	e8 50 0d 00 00       	call   3734 <exit>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    29e4:	83 ec 0c             	sub    $0xc,%esp
    29e7:	50                   	push   %eax
    29e8:	e8 6f 0d 00 00       	call   375c <close>
    29ed:	83 c4 10             	add    $0x10,%esp
    29f0:	e9 80 00 00 00       	jmp    2a75 <iref+0xd6>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    29f5:	83 ec 0c             	sub    $0xc,%esp
    29f8:	68 98 44 00 00       	push   $0x4498
    29fd:	e8 82 0d 00 00       	call   3784 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2a02:	83 c3 01             	add    $0x1,%ebx
    2a05:	83 c4 10             	add    $0x10,%esp
    2a08:	83 fb 32             	cmp    $0x32,%ebx
    2a0b:	0f 8f 92 00 00 00    	jg     2aa3 <iref+0x104>
    if(mkdir("irefd") != 0){
    2a11:	83 ec 0c             	sub    $0xc,%esp
    2a14:	68 ae 48 00 00       	push   $0x48ae
    2a19:	e8 7e 0d 00 00       	call   379c <mkdir>
    2a1e:	83 c4 10             	add    $0x10,%esp
    2a21:	85 c0                	test   %eax,%eax
    2a23:	75 97                	jne    29bc <iref+0x1d>
    if(chdir("irefd") != 0){
    2a25:	83 ec 0c             	sub    $0xc,%esp
    2a28:	68 ae 48 00 00       	push   $0x48ae
    2a2d:	e8 72 0d 00 00       	call   37a4 <chdir>
    2a32:	83 c4 10             	add    $0x10,%esp
    2a35:	85 c0                	test   %eax,%eax
    2a37:	75 97                	jne    29d0 <iref+0x31>
    mkdir("");
    2a39:	83 ec 0c             	sub    $0xc,%esp
    2a3c:	68 63 3f 00 00       	push   $0x3f63
    2a41:	e8 56 0d 00 00       	call   379c <mkdir>
    link("README", "");
    2a46:	83 c4 08             	add    $0x8,%esp
    2a49:	68 63 3f 00 00       	push   $0x3f63
    2a4e:	68 5a 48 00 00       	push   $0x485a
    2a53:	e8 3c 0d 00 00       	call   3794 <link>
    fd = open("", O_CREATE);
    2a58:	83 c4 08             	add    $0x8,%esp
    2a5b:	68 00 02 00 00       	push   $0x200
    2a60:	68 63 3f 00 00       	push   $0x3f63
    2a65:	e8 0a 0d 00 00       	call   3774 <open>
    if(fd >= 0)
    2a6a:	83 c4 10             	add    $0x10,%esp
    2a6d:	85 c0                	test   %eax,%eax
    2a6f:	0f 89 6f ff ff ff    	jns    29e4 <iref+0x45>
    fd = open("xx", O_CREATE);
    2a75:	83 ec 08             	sub    $0x8,%esp
    2a78:	68 00 02 00 00       	push   $0x200
    2a7d:	68 98 44 00 00       	push   $0x4498
    2a82:	e8 ed 0c 00 00       	call   3774 <open>
    if(fd >= 0)
    2a87:	83 c4 10             	add    $0x10,%esp
    2a8a:	85 c0                	test   %eax,%eax
    2a8c:	0f 88 63 ff ff ff    	js     29f5 <iref+0x56>
      close(fd);
    2a92:	83 ec 0c             	sub    $0xc,%esp
    2a95:	50                   	push   %eax
    2a96:	e8 c1 0c 00 00       	call   375c <close>
    2a9b:	83 c4 10             	add    $0x10,%esp
    2a9e:	e9 52 ff ff ff       	jmp    29f5 <iref+0x56>
  }

  chdir("/");
    2aa3:	83 ec 0c             	sub    $0xc,%esp
    2aa6:	68 89 3b 00 00       	push   $0x3b89
    2aab:	e8 f4 0c 00 00       	call   37a4 <chdir>
  printf(1, "empty file name OK\n");
    2ab0:	83 c4 08             	add    $0x8,%esp
    2ab3:	68 dc 48 00 00       	push   $0x48dc
    2ab8:	6a 01                	push   $0x1
    2aba:	e8 c7 0d 00 00       	call   3886 <printf>
}
    2abf:	83 c4 10             	add    $0x10,%esp
    2ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2ac5:	c9                   	leave  
    2ac6:	c3                   	ret    

00002ac7 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2ac7:	55                   	push   %ebp
    2ac8:	89 e5                	mov    %esp,%ebp
    2aca:	53                   	push   %ebx
    2acb:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    2ace:	68 f0 48 00 00       	push   $0x48f0
    2ad3:	6a 01                	push   $0x1
    2ad5:	e8 ac 0d 00 00       	call   3886 <printf>

  for(n=0; n<1000; n++){
    2ada:	83 c4 10             	add    $0x10,%esp
    2add:	bb 00 00 00 00       	mov    $0x0,%ebx
    2ae2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
    2ae8:	7f 17                	jg     2b01 <forktest+0x3a>
    pid = fork();
    2aea:	e8 3d 0c 00 00       	call   372c <fork>
    if(pid < 0)
    2aef:	85 c0                	test   %eax,%eax
    2af1:	78 0e                	js     2b01 <forktest+0x3a>
      break;
    if(pid == 0)
    2af3:	85 c0                	test   %eax,%eax
    2af5:	74 05                	je     2afc <forktest+0x35>
  for(n=0; n<1000; n++){
    2af7:	83 c3 01             	add    $0x1,%ebx
    2afa:	eb e6                	jmp    2ae2 <forktest+0x1b>
      exit();
    2afc:	e8 33 0c 00 00       	call   3734 <exit>
  }

  if(n == 1000){
    2b01:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2b07:	74 12                	je     2b1b <forktest+0x54>
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }

  for(; n > 0; n--){
    2b09:	85 db                	test   %ebx,%ebx
    2b0b:	7e 36                	jle    2b43 <forktest+0x7c>
    if(wait() < 0){
    2b0d:	e8 2a 0c 00 00       	call   373c <wait>
    2b12:	85 c0                	test   %eax,%eax
    2b14:	78 19                	js     2b2f <forktest+0x68>
  for(; n > 0; n--){
    2b16:	83 eb 01             	sub    $0x1,%ebx
    2b19:	eb ee                	jmp    2b09 <forktest+0x42>
    printf(1, "fork claimed to work 1000 times!\n");
    2b1b:	83 ec 08             	sub    $0x8,%esp
    2b1e:	68 90 50 00 00       	push   $0x5090
    2b23:	6a 01                	push   $0x1
    2b25:	e8 5c 0d 00 00       	call   3886 <printf>
    exit();
    2b2a:	e8 05 0c 00 00       	call   3734 <exit>
      printf(1, "wait stopped early\n");
    2b2f:	83 ec 08             	sub    $0x8,%esp
    2b32:	68 fb 48 00 00       	push   $0x48fb
    2b37:	6a 01                	push   $0x1
    2b39:	e8 48 0d 00 00       	call   3886 <printf>
      exit();
    2b3e:	e8 f1 0b 00 00       	call   3734 <exit>
    }
  }

  if(wait() != -1){
    2b43:	e8 f4 0b 00 00       	call   373c <wait>
    2b48:	83 f8 ff             	cmp    $0xffffffff,%eax
    2b4b:	75 17                	jne    2b64 <forktest+0x9d>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
    2b4d:	83 ec 08             	sub    $0x8,%esp
    2b50:	68 22 49 00 00       	push   $0x4922
    2b55:	6a 01                	push   $0x1
    2b57:	e8 2a 0d 00 00       	call   3886 <printf>
}
    2b5c:	83 c4 10             	add    $0x10,%esp
    2b5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2b62:	c9                   	leave  
    2b63:	c3                   	ret    
    printf(1, "wait got too many\n");
    2b64:	83 ec 08             	sub    $0x8,%esp
    2b67:	68 0f 49 00 00       	push   $0x490f
    2b6c:	6a 01                	push   $0x1
    2b6e:	e8 13 0d 00 00       	call   3886 <printf>
    exit();
    2b73:	e8 bc 0b 00 00       	call   3734 <exit>

00002b78 <sbrktest>:

void
sbrktest(void)
{
    2b78:	55                   	push   %ebp
    2b79:	89 e5                	mov    %esp,%ebp
    2b7b:	57                   	push   %edi
    2b7c:	56                   	push   %esi
    2b7d:	53                   	push   %ebx
    2b7e:	83 ec 54             	sub    $0x54,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2b81:	68 30 49 00 00       	push   $0x4930
    2b86:	ff 35 80 5b 00 00    	pushl  0x5b80
    2b8c:	e8 f5 0c 00 00       	call   3886 <printf>
  oldbrk = sbrk(0);
    2b91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2b98:	e8 1f 0c 00 00       	call   37bc <sbrk>
    2b9d:	89 c7                	mov    %eax,%edi

  // can one sbrk() less than a page?
  a = sbrk(0);
    2b9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ba6:	e8 11 0c 00 00       	call   37bc <sbrk>
    2bab:	89 c6                	mov    %eax,%esi
  int i;
  for(i = 0; i < 5000; i++){
    2bad:	83 c4 10             	add    $0x10,%esp
    2bb0:	bb 00 00 00 00       	mov    $0x0,%ebx
    2bb5:	81 fb 87 13 00 00    	cmp    $0x1387,%ebx
    2bbb:	7f 3a                	jg     2bf7 <sbrktest+0x7f>
    b = sbrk(1);
    2bbd:	83 ec 0c             	sub    $0xc,%esp
    2bc0:	6a 01                	push   $0x1
    2bc2:	e8 f5 0b 00 00       	call   37bc <sbrk>
    if(b != a){
    2bc7:	83 c4 10             	add    $0x10,%esp
    2bca:	39 c6                	cmp    %eax,%esi
    2bcc:	75 0b                	jne    2bd9 <sbrktest+0x61>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    2bce:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    2bd1:	8d 70 01             	lea    0x1(%eax),%esi
  for(i = 0; i < 5000; i++){
    2bd4:	83 c3 01             	add    $0x1,%ebx
    2bd7:	eb dc                	jmp    2bb5 <sbrktest+0x3d>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2bd9:	83 ec 0c             	sub    $0xc,%esp
    2bdc:	50                   	push   %eax
    2bdd:	56                   	push   %esi
    2bde:	53                   	push   %ebx
    2bdf:	68 3b 49 00 00       	push   $0x493b
    2be4:	ff 35 80 5b 00 00    	pushl  0x5b80
    2bea:	e8 97 0c 00 00       	call   3886 <printf>
      exit();
    2bef:	83 c4 20             	add    $0x20,%esp
    2bf2:	e8 3d 0b 00 00       	call   3734 <exit>
  }
  pid = fork();
    2bf7:	e8 30 0b 00 00       	call   372c <fork>
    2bfc:	89 c3                	mov    %eax,%ebx
  if(pid < 0){
    2bfe:	85 c0                	test   %eax,%eax
    2c00:	0f 88 53 01 00 00    	js     2d59 <sbrktest+0x1e1>
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    2c06:	83 ec 0c             	sub    $0xc,%esp
    2c09:	6a 01                	push   $0x1
    2c0b:	e8 ac 0b 00 00       	call   37bc <sbrk>
  c = sbrk(1);
    2c10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c17:	e8 a0 0b 00 00       	call   37bc <sbrk>
  if(c != a + 1){
    2c1c:	83 c6 01             	add    $0x1,%esi
    2c1f:	83 c4 10             	add    $0x10,%esp
    2c22:	39 c6                	cmp    %eax,%esi
    2c24:	0f 85 47 01 00 00    	jne    2d71 <sbrktest+0x1f9>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    2c2a:	85 db                	test   %ebx,%ebx
    2c2c:	0f 84 57 01 00 00    	je     2d89 <sbrktest+0x211>
    exit();
  wait();
    2c32:	e8 05 0b 00 00       	call   373c <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2c37:	83 ec 0c             	sub    $0xc,%esp
    2c3a:	6a 00                	push   $0x0
    2c3c:	e8 7b 0b 00 00       	call   37bc <sbrk>
    2c41:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
    2c43:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2c48:	29 d8                	sub    %ebx,%eax
  p = sbrk(amt);
    2c4a:	89 04 24             	mov    %eax,(%esp)
    2c4d:	e8 6a 0b 00 00       	call   37bc <sbrk>
  if (p != a) {
    2c52:	83 c4 10             	add    $0x10,%esp
    2c55:	39 c3                	cmp    %eax,%ebx
    2c57:	0f 85 31 01 00 00    	jne    2d8e <sbrktest+0x216>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    2c5d:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    2c64:	83 ec 0c             	sub    $0xc,%esp
    2c67:	6a 00                	push   $0x0
    2c69:	e8 4e 0b 00 00       	call   37bc <sbrk>
    2c6e:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    2c70:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2c77:	e8 40 0b 00 00       	call   37bc <sbrk>
  if(c == (char*)0xffffffff){
    2c7c:	83 c4 10             	add    $0x10,%esp
    2c7f:	83 f8 ff             	cmp    $0xffffffff,%eax
    2c82:	0f 84 1e 01 00 00    	je     2da6 <sbrktest+0x22e>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    2c88:	83 ec 0c             	sub    $0xc,%esp
    2c8b:	6a 00                	push   $0x0
    2c8d:	e8 2a 0b 00 00       	call   37bc <sbrk>
  if(c != a - 4096){
    2c92:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    2c98:	83 c4 10             	add    $0x10,%esp
    2c9b:	39 c2                	cmp    %eax,%edx
    2c9d:	0f 85 1b 01 00 00    	jne    2dbe <sbrktest+0x246>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    2ca3:	83 ec 0c             	sub    $0xc,%esp
    2ca6:	6a 00                	push   $0x0
    2ca8:	e8 0f 0b 00 00       	call   37bc <sbrk>
    2cad:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    2caf:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2cb6:	e8 01 0b 00 00       	call   37bc <sbrk>
    2cbb:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    2cbd:	83 c4 10             	add    $0x10,%esp
    2cc0:	39 c3                	cmp    %eax,%ebx
    2cc2:	0f 85 0d 01 00 00    	jne    2dd5 <sbrktest+0x25d>
    2cc8:	83 ec 0c             	sub    $0xc,%esp
    2ccb:	6a 00                	push   $0x0
    2ccd:	e8 ea 0a 00 00       	call   37bc <sbrk>
    2cd2:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    2cd8:	83 c4 10             	add    $0x10,%esp
    2cdb:	39 d0                	cmp    %edx,%eax
    2cdd:	0f 85 f2 00 00 00    	jne    2dd5 <sbrktest+0x25d>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    2ce3:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2cea:	0f 84 fc 00 00 00    	je     2dec <sbrktest+0x274>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    2cf0:	83 ec 0c             	sub    $0xc,%esp
    2cf3:	6a 00                	push   $0x0
    2cf5:	e8 c2 0a 00 00       	call   37bc <sbrk>
    2cfa:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    2cfc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d03:	e8 b4 0a 00 00       	call   37bc <sbrk>
    2d08:	89 f9                	mov    %edi,%ecx
    2d0a:	29 c1                	sub    %eax,%ecx
    2d0c:	89 0c 24             	mov    %ecx,(%esp)
    2d0f:	e8 a8 0a 00 00       	call   37bc <sbrk>
  if(c != a){
    2d14:	83 c4 10             	add    $0x10,%esp
    2d17:	39 c3                	cmp    %eax,%ebx
    2d19:	0f 85 e5 00 00 00    	jne    2e04 <sbrktest+0x28c>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2d1f:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    2d24:	81 fb 7f 84 1e 80    	cmp    $0x801e847f,%ebx
    2d2a:	0f 87 28 01 00 00    	ja     2e58 <sbrktest+0x2e0>
    ppid = getpid();
    2d30:	e8 7f 0a 00 00       	call   37b4 <getpid>
    2d35:	89 c6                	mov    %eax,%esi
    pid = fork();
    2d37:	e8 f0 09 00 00       	call   372c <fork>
    if(pid < 0){
    2d3c:	85 c0                	test   %eax,%eax
    2d3e:	0f 88 d7 00 00 00    	js     2e1b <sbrktest+0x2a3>
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
    2d44:	85 c0                	test   %eax,%eax
    2d46:	0f 84 e7 00 00 00    	je     2e33 <sbrktest+0x2bb>
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid, SIGKILL);
      exit();
    }
    wait();
    2d4c:	e8 eb 09 00 00       	call   373c <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2d51:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    2d57:	eb cb                	jmp    2d24 <sbrktest+0x1ac>
    printf(stdout, "sbrk test fork failed\n");
    2d59:	83 ec 08             	sub    $0x8,%esp
    2d5c:	68 56 49 00 00       	push   $0x4956
    2d61:	ff 35 80 5b 00 00    	pushl  0x5b80
    2d67:	e8 1a 0b 00 00       	call   3886 <printf>
    exit();
    2d6c:	e8 c3 09 00 00       	call   3734 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    2d71:	83 ec 08             	sub    $0x8,%esp
    2d74:	68 6d 49 00 00       	push   $0x496d
    2d79:	ff 35 80 5b 00 00    	pushl  0x5b80
    2d7f:	e8 02 0b 00 00       	call   3886 <printf>
    exit();
    2d84:	e8 ab 09 00 00       	call   3734 <exit>
    exit();
    2d89:	e8 a6 09 00 00       	call   3734 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2d8e:	83 ec 08             	sub    $0x8,%esp
    2d91:	68 b4 50 00 00       	push   $0x50b4
    2d96:	ff 35 80 5b 00 00    	pushl  0x5b80
    2d9c:	e8 e5 0a 00 00       	call   3886 <printf>
    exit();
    2da1:	e8 8e 09 00 00       	call   3734 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    2da6:	83 ec 08             	sub    $0x8,%esp
    2da9:	68 89 49 00 00       	push   $0x4989
    2dae:	ff 35 80 5b 00 00    	pushl  0x5b80
    2db4:	e8 cd 0a 00 00       	call   3886 <printf>
    exit();
    2db9:	e8 76 09 00 00       	call   3734 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2dbe:	50                   	push   %eax
    2dbf:	53                   	push   %ebx
    2dc0:	68 f4 50 00 00       	push   $0x50f4
    2dc5:	ff 35 80 5b 00 00    	pushl  0x5b80
    2dcb:	e8 b6 0a 00 00       	call   3886 <printf>
    exit();
    2dd0:	e8 5f 09 00 00       	call   3734 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    2dd5:	56                   	push   %esi
    2dd6:	53                   	push   %ebx
    2dd7:	68 2c 51 00 00       	push   $0x512c
    2ddc:	ff 35 80 5b 00 00    	pushl  0x5b80
    2de2:	e8 9f 0a 00 00       	call   3886 <printf>
    exit();
    2de7:	e8 48 09 00 00       	call   3734 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    2dec:	83 ec 08             	sub    $0x8,%esp
    2def:	68 54 51 00 00       	push   $0x5154
    2df4:	ff 35 80 5b 00 00    	pushl  0x5b80
    2dfa:	e8 87 0a 00 00       	call   3886 <printf>
    exit();
    2dff:	e8 30 09 00 00       	call   3734 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    2e04:	50                   	push   %eax
    2e05:	53                   	push   %ebx
    2e06:	68 84 51 00 00       	push   $0x5184
    2e0b:	ff 35 80 5b 00 00    	pushl  0x5b80
    2e11:	e8 70 0a 00 00       	call   3886 <printf>
    exit();
    2e16:	e8 19 09 00 00       	call   3734 <exit>
      printf(stdout, "fork failed\n");
    2e1b:	83 ec 08             	sub    $0x8,%esp
    2e1e:	68 81 4a 00 00       	push   $0x4a81
    2e23:	ff 35 80 5b 00 00    	pushl  0x5b80
    2e29:	e8 58 0a 00 00       	call   3886 <printf>
      exit();
    2e2e:	e8 01 09 00 00       	call   3734 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    2e33:	0f be 03             	movsbl (%ebx),%eax
    2e36:	50                   	push   %eax
    2e37:	53                   	push   %ebx
    2e38:	68 a4 49 00 00       	push   $0x49a4
    2e3d:	ff 35 80 5b 00 00    	pushl  0x5b80
    2e43:	e8 3e 0a 00 00       	call   3886 <printf>
      kill(ppid, SIGKILL);
    2e48:	83 c4 08             	add    $0x8,%esp
    2e4b:	6a 09                	push   $0x9
    2e4d:	56                   	push   %esi
    2e4e:	e8 11 09 00 00       	call   3764 <kill>
      exit();
    2e53:	e8 dc 08 00 00       	call   3734 <exit>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    2e58:	83 ec 0c             	sub    $0xc,%esp
    2e5b:	8d 45 e0             	lea    -0x20(%ebp),%eax
    2e5e:	50                   	push   %eax
    2e5f:	e8 e0 08 00 00       	call   3744 <pipe>
    2e64:	89 c3                	mov    %eax,%ebx
    2e66:	83 c4 10             	add    $0x10,%esp
    2e69:	85 c0                	test   %eax,%eax
    2e6b:	75 04                	jne    2e71 <sbrktest+0x2f9>
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2e6d:	89 c6                	mov    %eax,%esi
    2e6f:	eb 57                	jmp    2ec8 <sbrktest+0x350>
    printf(1, "pipe() failed\n");
    2e71:	83 ec 08             	sub    $0x8,%esp
    2e74:	68 79 3e 00 00       	push   $0x3e79
    2e79:	6a 01                	push   $0x1
    2e7b:	e8 06 0a 00 00       	call   3886 <printf>
    exit();
    2e80:	e8 af 08 00 00       	call   3734 <exit>
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    2e85:	83 ec 0c             	sub    $0xc,%esp
    2e88:	6a 00                	push   $0x0
    2e8a:	e8 2d 09 00 00       	call   37bc <sbrk>
    2e8f:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2e94:	29 c2                	sub    %eax,%edx
    2e96:	89 14 24             	mov    %edx,(%esp)
    2e99:	e8 1e 09 00 00       	call   37bc <sbrk>
      write(fds[1], "x", 1);
    2e9e:	83 c4 0c             	add    $0xc,%esp
    2ea1:	6a 01                	push   $0x1
    2ea3:	68 99 44 00 00       	push   $0x4499
    2ea8:	ff 75 e4             	pushl  -0x1c(%ebp)
    2eab:	e8 a4 08 00 00       	call   3754 <write>
    2eb0:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    2eb3:	83 ec 0c             	sub    $0xc,%esp
    2eb6:	68 e8 03 00 00       	push   $0x3e8
    2ebb:	e8 04 09 00 00       	call   37c4 <sleep>
    2ec0:	83 c4 10             	add    $0x10,%esp
    2ec3:	eb ee                	jmp    2eb3 <sbrktest+0x33b>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2ec5:	83 c6 01             	add    $0x1,%esi
    2ec8:	83 fe 09             	cmp    $0x9,%esi
    2ecb:	77 28                	ja     2ef5 <sbrktest+0x37d>
    if((pids[i] = fork()) == 0){
    2ecd:	e8 5a 08 00 00       	call   372c <fork>
    2ed2:	89 44 b5 b8          	mov    %eax,-0x48(%ebp,%esi,4)
    2ed6:	85 c0                	test   %eax,%eax
    2ed8:	74 ab                	je     2e85 <sbrktest+0x30d>
    }
    if(pids[i] != -1)
    2eda:	83 f8 ff             	cmp    $0xffffffff,%eax
    2edd:	74 e6                	je     2ec5 <sbrktest+0x34d>
      read(fds[0], &scratch, 1);
    2edf:	83 ec 04             	sub    $0x4,%esp
    2ee2:	6a 01                	push   $0x1
    2ee4:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2ee7:	50                   	push   %eax
    2ee8:	ff 75 e0             	pushl  -0x20(%ebp)
    2eeb:	e8 5c 08 00 00       	call   374c <read>
    2ef0:	83 c4 10             	add    $0x10,%esp
    2ef3:	eb d0                	jmp    2ec5 <sbrktest+0x34d>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    2ef5:	83 ec 0c             	sub    $0xc,%esp
    2ef8:	68 00 10 00 00       	push   $0x1000
    2efd:	e8 ba 08 00 00       	call   37bc <sbrk>
    2f02:	89 c6                	mov    %eax,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f04:	83 c4 10             	add    $0x10,%esp
    2f07:	eb 03                	jmp    2f0c <sbrktest+0x394>
    2f09:	83 c3 01             	add    $0x1,%ebx
    2f0c:	83 fb 09             	cmp    $0x9,%ebx
    2f0f:	77 1e                	ja     2f2f <sbrktest+0x3b7>
    if(pids[i] == -1)
    2f11:	8b 44 9d b8          	mov    -0x48(%ebp,%ebx,4),%eax
    2f15:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f18:	74 ef                	je     2f09 <sbrktest+0x391>
      continue;
    kill(pids[i], SIGKILL);
    2f1a:	83 ec 08             	sub    $0x8,%esp
    2f1d:	6a 09                	push   $0x9
    2f1f:	50                   	push   %eax
    2f20:	e8 3f 08 00 00       	call   3764 <kill>
    wait();
    2f25:	e8 12 08 00 00       	call   373c <wait>
    2f2a:	83 c4 10             	add    $0x10,%esp
    2f2d:	eb da                	jmp    2f09 <sbrktest+0x391>
  }
  if(c == (char*)0xffffffff){
    2f2f:	83 fe ff             	cmp    $0xffffffff,%esi
    2f32:	74 2f                	je     2f63 <sbrktest+0x3eb>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    2f34:	83 ec 0c             	sub    $0xc,%esp
    2f37:	6a 00                	push   $0x0
    2f39:	e8 7e 08 00 00       	call   37bc <sbrk>
    2f3e:	83 c4 10             	add    $0x10,%esp
    2f41:	39 f8                	cmp    %edi,%eax
    2f43:	77 36                	ja     2f7b <sbrktest+0x403>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    2f45:	83 ec 08             	sub    $0x8,%esp
    2f48:	68 d8 49 00 00       	push   $0x49d8
    2f4d:	ff 35 80 5b 00 00    	pushl  0x5b80
    2f53:	e8 2e 09 00 00       	call   3886 <printf>
}
    2f58:	83 c4 10             	add    $0x10,%esp
    2f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2f5e:	5b                   	pop    %ebx
    2f5f:	5e                   	pop    %esi
    2f60:	5f                   	pop    %edi
    2f61:	5d                   	pop    %ebp
    2f62:	c3                   	ret    
    printf(stdout, "failed sbrk leaked memory\n");
    2f63:	83 ec 08             	sub    $0x8,%esp
    2f66:	68 bd 49 00 00       	push   $0x49bd
    2f6b:	ff 35 80 5b 00 00    	pushl  0x5b80
    2f71:	e8 10 09 00 00       	call   3886 <printf>
    exit();
    2f76:	e8 b9 07 00 00       	call   3734 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    2f7b:	83 ec 0c             	sub    $0xc,%esp
    2f7e:	6a 00                	push   $0x0
    2f80:	e8 37 08 00 00       	call   37bc <sbrk>
    2f85:	29 c7                	sub    %eax,%edi
    2f87:	89 3c 24             	mov    %edi,(%esp)
    2f8a:	e8 2d 08 00 00       	call   37bc <sbrk>
    2f8f:	83 c4 10             	add    $0x10,%esp
    2f92:	eb b1                	jmp    2f45 <sbrktest+0x3cd>

00002f94 <validateint>:

void
validateint(int *p)
{
    2f94:	55                   	push   %ebp
    2f95:	89 e5                	mov    %esp,%ebp
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    2f97:	5d                   	pop    %ebp
    2f98:	c3                   	ret    

00002f99 <validatetest>:

void
validatetest(void)
{
    2f99:	55                   	push   %ebp
    2f9a:	89 e5                	mov    %esp,%ebp
    2f9c:	56                   	push   %esi
    2f9d:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    2f9e:	83 ec 08             	sub    $0x8,%esp
    2fa1:	68 e6 49 00 00       	push   $0x49e6
    2fa6:	ff 35 80 5b 00 00    	pushl  0x5b80
    2fac:	e8 d5 08 00 00       	call   3886 <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    2fb1:	83 c4 10             	add    $0x10,%esp
    2fb4:	bb 00 00 00 00       	mov    $0x0,%ebx
    2fb9:	81 fb 00 30 11 00    	cmp    $0x113000,%ebx
    2fbf:	77 6c                	ja     302d <validatetest+0x94>
    if((pid = fork()) == 0){
    2fc1:	e8 66 07 00 00       	call   372c <fork>
    2fc6:	89 c6                	mov    %eax,%esi
    2fc8:	85 c0                	test   %eax,%eax
    2fca:	74 44                	je     3010 <validatetest+0x77>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit();
    }
    sleep(0);
    2fcc:	83 ec 0c             	sub    $0xc,%esp
    2fcf:	6a 00                	push   $0x0
    2fd1:	e8 ee 07 00 00       	call   37c4 <sleep>
    sleep(0);
    2fd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fdd:	e8 e2 07 00 00       	call   37c4 <sleep>
    kill(pid, SIGKILL);
    2fe2:	83 c4 08             	add    $0x8,%esp
    2fe5:	6a 09                	push   $0x9
    2fe7:	56                   	push   %esi
    2fe8:	e8 77 07 00 00       	call   3764 <kill>
    wait();
    2fed:	e8 4a 07 00 00       	call   373c <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    2ff2:	83 c4 08             	add    $0x8,%esp
    2ff5:	53                   	push   %ebx
    2ff6:	68 f5 49 00 00       	push   $0x49f5
    2ffb:	e8 94 07 00 00       	call   3794 <link>
    3000:	83 c4 10             	add    $0x10,%esp
    3003:	83 f8 ff             	cmp    $0xffffffff,%eax
    3006:	75 0d                	jne    3015 <validatetest+0x7c>
  for(p = 0; p <= (uint)hi; p += 4096){
    3008:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    300e:	eb a9                	jmp    2fb9 <validatetest+0x20>
      exit();
    3010:	e8 1f 07 00 00       	call   3734 <exit>
      printf(stdout, "link should not succeed\n");
    3015:	83 ec 08             	sub    $0x8,%esp
    3018:	68 00 4a 00 00       	push   $0x4a00
    301d:	ff 35 80 5b 00 00    	pushl  0x5b80
    3023:	e8 5e 08 00 00       	call   3886 <printf>
      exit();
    3028:	e8 07 07 00 00       	call   3734 <exit>
    }
  }

  printf(stdout, "validate ok\n");
    302d:	83 ec 08             	sub    $0x8,%esp
    3030:	68 19 4a 00 00       	push   $0x4a19
    3035:	ff 35 80 5b 00 00    	pushl  0x5b80
    303b:	e8 46 08 00 00       	call   3886 <printf>
}
    3040:	83 c4 10             	add    $0x10,%esp
    3043:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3046:	5b                   	pop    %ebx
    3047:	5e                   	pop    %esi
    3048:	5d                   	pop    %ebp
    3049:	c3                   	ret    

0000304a <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    304a:	55                   	push   %ebp
    304b:	89 e5                	mov    %esp,%ebp
    304d:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(stdout, "bss test\n");
    3050:	68 26 4a 00 00       	push   $0x4a26
    3055:	ff 35 80 5b 00 00    	pushl  0x5b80
    305b:	e8 26 08 00 00       	call   3886 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    3060:	83 c4 10             	add    $0x10,%esp
    3063:	b8 00 00 00 00       	mov    $0x0,%eax
    3068:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    306d:	77 26                	ja     3095 <bsstest+0x4b>
    if(uninit[i] != '\0'){
    306f:	80 b8 40 5c 00 00 00 	cmpb   $0x0,0x5c40(%eax)
    3076:	75 05                	jne    307d <bsstest+0x33>
  for(i = 0; i < sizeof(uninit); i++){
    3078:	83 c0 01             	add    $0x1,%eax
    307b:	eb eb                	jmp    3068 <bsstest+0x1e>
      printf(stdout, "bss test failed\n");
    307d:	83 ec 08             	sub    $0x8,%esp
    3080:	68 30 4a 00 00       	push   $0x4a30
    3085:	ff 35 80 5b 00 00    	pushl  0x5b80
    308b:	e8 f6 07 00 00       	call   3886 <printf>
      exit();
    3090:	e8 9f 06 00 00       	call   3734 <exit>
    }
  }
  printf(stdout, "bss test ok\n");
    3095:	83 ec 08             	sub    $0x8,%esp
    3098:	68 41 4a 00 00       	push   $0x4a41
    309d:	ff 35 80 5b 00 00    	pushl  0x5b80
    30a3:	e8 de 07 00 00       	call   3886 <printf>
}
    30a8:	83 c4 10             	add    $0x10,%esp
    30ab:	c9                   	leave  
    30ac:	c3                   	ret    

000030ad <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    30ad:	55                   	push   %ebp
    30ae:	89 e5                	mov    %esp,%ebp
    30b0:	83 ec 14             	sub    $0x14,%esp
  int pid, fd;

  unlink("bigarg-ok");
    30b3:	68 4e 4a 00 00       	push   $0x4a4e
    30b8:	e8 c7 06 00 00       	call   3784 <unlink>
  pid = fork();
    30bd:	e8 6a 06 00 00       	call   372c <fork>
  if(pid == 0){
    30c2:	83 c4 10             	add    $0x10,%esp
    30c5:	85 c0                	test   %eax,%eax
    30c7:	74 4f                	je     3118 <bigargtest+0x6b>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    30c9:	85 c0                	test   %eax,%eax
    30cb:	0f 88 ad 00 00 00    	js     317e <bigargtest+0xd1>
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
    30d1:	e8 66 06 00 00       	call   373c <wait>
  fd = open("bigarg-ok", 0);
    30d6:	83 ec 08             	sub    $0x8,%esp
    30d9:	6a 00                	push   $0x0
    30db:	68 4e 4a 00 00       	push   $0x4a4e
    30e0:	e8 8f 06 00 00       	call   3774 <open>
  if(fd < 0){
    30e5:	83 c4 10             	add    $0x10,%esp
    30e8:	85 c0                	test   %eax,%eax
    30ea:	0f 88 a6 00 00 00    	js     3196 <bigargtest+0xe9>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
    30f0:	83 ec 0c             	sub    $0xc,%esp
    30f3:	50                   	push   %eax
    30f4:	e8 63 06 00 00       	call   375c <close>
  unlink("bigarg-ok");
    30f9:	c7 04 24 4e 4a 00 00 	movl   $0x4a4e,(%esp)
    3100:	e8 7f 06 00 00       	call   3784 <unlink>
}
    3105:	83 c4 10             	add    $0x10,%esp
    3108:	c9                   	leave  
    3109:	c3                   	ret    
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    310a:	c7 04 85 a0 5b 00 00 	movl   $0x51a8,0x5ba0(,%eax,4)
    3111:	a8 51 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3115:	83 c0 01             	add    $0x1,%eax
    3118:	83 f8 1e             	cmp    $0x1e,%eax
    311b:	7e ed                	jle    310a <bigargtest+0x5d>
    args[MAXARG-1] = 0;
    311d:	c7 05 1c 5c 00 00 00 	movl   $0x0,0x5c1c
    3124:	00 00 00 
    printf(stdout, "bigarg test\n");
    3127:	83 ec 08             	sub    $0x8,%esp
    312a:	68 58 4a 00 00       	push   $0x4a58
    312f:	ff 35 80 5b 00 00    	pushl  0x5b80
    3135:	e8 4c 07 00 00       	call   3886 <printf>
    exec("echo", args);
    313a:	83 c4 08             	add    $0x8,%esp
    313d:	68 a0 5b 00 00       	push   $0x5ba0
    3142:	68 25 3c 00 00       	push   $0x3c25
    3147:	e8 20 06 00 00       	call   376c <exec>
    printf(stdout, "bigarg test ok\n");
    314c:	83 c4 08             	add    $0x8,%esp
    314f:	68 65 4a 00 00       	push   $0x4a65
    3154:	ff 35 80 5b 00 00    	pushl  0x5b80
    315a:	e8 27 07 00 00       	call   3886 <printf>
    fd = open("bigarg-ok", O_CREATE);
    315f:	83 c4 08             	add    $0x8,%esp
    3162:	68 00 02 00 00       	push   $0x200
    3167:	68 4e 4a 00 00       	push   $0x4a4e
    316c:	e8 03 06 00 00       	call   3774 <open>
    close(fd);
    3171:	89 04 24             	mov    %eax,(%esp)
    3174:	e8 e3 05 00 00       	call   375c <close>
    exit();
    3179:	e8 b6 05 00 00       	call   3734 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    317e:	83 ec 08             	sub    $0x8,%esp
    3181:	68 75 4a 00 00       	push   $0x4a75
    3186:	ff 35 80 5b 00 00    	pushl  0x5b80
    318c:	e8 f5 06 00 00       	call   3886 <printf>
    exit();
    3191:	e8 9e 05 00 00       	call   3734 <exit>
    printf(stdout, "bigarg test failed!\n");
    3196:	83 ec 08             	sub    $0x8,%esp
    3199:	68 8e 4a 00 00       	push   $0x4a8e
    319e:	ff 35 80 5b 00 00    	pushl  0x5b80
    31a4:	e8 dd 06 00 00       	call   3886 <printf>
    exit();
    31a9:	e8 86 05 00 00       	call   3734 <exit>

000031ae <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    31ae:	55                   	push   %ebp
    31af:	89 e5                	mov    %esp,%ebp
    31b1:	57                   	push   %edi
    31b2:	56                   	push   %esi
    31b3:	53                   	push   %ebx
    31b4:	83 ec 54             	sub    $0x54,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    31b7:	68 a3 4a 00 00       	push   $0x4aa3
    31bc:	6a 01                	push   $0x1
    31be:	e8 c3 06 00 00       	call   3886 <printf>
    31c3:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    31c6:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    31cb:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    31cf:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    31d4:	89 d8                	mov    %ebx,%eax
    31d6:	f7 ea                	imul   %edx
    31d8:	c1 fa 06             	sar    $0x6,%edx
    31db:	89 df                	mov    %ebx,%edi
    31dd:	c1 ff 1f             	sar    $0x1f,%edi
    31e0:	29 fa                	sub    %edi,%edx
    31e2:	8d 42 30             	lea    0x30(%edx),%eax
    31e5:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    31e8:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    31ee:	89 de                	mov    %ebx,%esi
    31f0:	29 d6                	sub    %edx,%esi
    31f2:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    31f7:	89 f0                	mov    %esi,%eax
    31f9:	f7 e9                	imul   %ecx
    31fb:	c1 fa 05             	sar    $0x5,%edx
    31fe:	c1 fe 1f             	sar    $0x1f,%esi
    3201:	29 f2                	sub    %esi,%edx
    3203:	83 c2 30             	add    $0x30,%edx
    3206:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3209:	89 d8                	mov    %ebx,%eax
    320b:	f7 e9                	imul   %ecx
    320d:	89 d1                	mov    %edx,%ecx
    320f:	c1 f9 05             	sar    $0x5,%ecx
    3212:	29 f9                	sub    %edi,%ecx
    3214:	6b c9 64             	imul   $0x64,%ecx,%ecx
    3217:	89 d8                	mov    %ebx,%eax
    3219:	29 c8                	sub    %ecx,%eax
    321b:	89 c1                	mov    %eax,%ecx
    321d:	be 67 66 66 66       	mov    $0x66666667,%esi
    3222:	f7 ee                	imul   %esi
    3224:	c1 fa 02             	sar    $0x2,%edx
    3227:	c1 f9 1f             	sar    $0x1f,%ecx
    322a:	29 ca                	sub    %ecx,%edx
    322c:	83 c2 30             	add    $0x30,%edx
    322f:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3232:	89 d8                	mov    %ebx,%eax
    3234:	f7 ee                	imul   %esi
    3236:	c1 fa 02             	sar    $0x2,%edx
    3239:	29 fa                	sub    %edi,%edx
    323b:	8d 14 92             	lea    (%edx,%edx,4),%edx
    323e:	8d 04 12             	lea    (%edx,%edx,1),%eax
    3241:	89 da                	mov    %ebx,%edx
    3243:	29 c2                	sub    %eax,%edx
    3245:	83 c2 30             	add    $0x30,%edx
    3248:	88 55 ac             	mov    %dl,-0x54(%ebp)
    name[5] = '\0';
    324b:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    324f:	83 ec 04             	sub    $0x4,%esp
    3252:	8d 75 a8             	lea    -0x58(%ebp),%esi
    3255:	56                   	push   %esi
    3256:	68 b0 4a 00 00       	push   $0x4ab0
    325b:	6a 01                	push   $0x1
    325d:	e8 24 06 00 00       	call   3886 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3262:	83 c4 08             	add    $0x8,%esp
    3265:	68 02 02 00 00       	push   $0x202
    326a:	56                   	push   %esi
    326b:	e8 04 05 00 00       	call   3774 <open>
    3270:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    3272:	83 c4 10             	add    $0x10,%esp
    3275:	85 c0                	test   %eax,%eax
    3277:	79 1b                	jns    3294 <fsfull+0xe6>
      printf(1, "open %s failed\n", name);
    3279:	83 ec 04             	sub    $0x4,%esp
    327c:	8d 45 a8             	lea    -0x58(%ebp),%eax
    327f:	50                   	push   %eax
    3280:	68 bc 4a 00 00       	push   $0x4abc
    3285:	6a 01                	push   $0x1
    3287:	e8 fa 05 00 00       	call   3886 <printf>
      break;
    328c:	83 c4 10             	add    $0x10,%esp
    328f:	e9 e7 00 00 00       	jmp    337b <fsfull+0x1cd>
    }
    int total = 0;
    3294:	bf 00 00 00 00       	mov    $0x0,%edi
    3299:	eb 02                	jmp    329d <fsfull+0xef>
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
      total += cc;
    329b:	01 c7                	add    %eax,%edi
      int cc = write(fd, buf, 512);
    329d:	83 ec 04             	sub    $0x4,%esp
    32a0:	68 00 02 00 00       	push   $0x200
    32a5:	68 60 83 00 00       	push   $0x8360
    32aa:	56                   	push   %esi
    32ab:	e8 a4 04 00 00       	call   3754 <write>
      if(cc < 512)
    32b0:	83 c4 10             	add    $0x10,%esp
    32b3:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    32b8:	7f e1                	jg     329b <fsfull+0xed>
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    32ba:	83 ec 04             	sub    $0x4,%esp
    32bd:	57                   	push   %edi
    32be:	68 cc 4a 00 00       	push   $0x4acc
    32c3:	6a 01                	push   $0x1
    32c5:	e8 bc 05 00 00       	call   3886 <printf>
    close(fd);
    32ca:	89 34 24             	mov    %esi,(%esp)
    32cd:	e8 8a 04 00 00       	call   375c <close>
    if(total == 0)
    32d2:	83 c4 10             	add    $0x10,%esp
    32d5:	85 ff                	test   %edi,%edi
    32d7:	0f 84 9e 00 00 00    	je     337b <fsfull+0x1cd>
  for(nfiles = 0; ; nfiles++){
    32dd:	83 c3 01             	add    $0x1,%ebx
    32e0:	e9 e6 fe ff ff       	jmp    31cb <fsfull+0x1d>
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    32e5:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    32e9:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    32ee:	89 d8                	mov    %ebx,%eax
    32f0:	f7 ea                	imul   %edx
    32f2:	c1 fa 06             	sar    $0x6,%edx
    32f5:	89 df                	mov    %ebx,%edi
    32f7:	c1 ff 1f             	sar    $0x1f,%edi
    32fa:	29 fa                	sub    %edi,%edx
    32fc:	8d 42 30             	lea    0x30(%edx),%eax
    32ff:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3302:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    3308:	89 de                	mov    %ebx,%esi
    330a:	29 d6                	sub    %edx,%esi
    330c:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    3311:	89 f0                	mov    %esi,%eax
    3313:	f7 e9                	imul   %ecx
    3315:	c1 fa 05             	sar    $0x5,%edx
    3318:	c1 fe 1f             	sar    $0x1f,%esi
    331b:	29 f2                	sub    %esi,%edx
    331d:	83 c2 30             	add    $0x30,%edx
    3320:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3323:	89 d8                	mov    %ebx,%eax
    3325:	f7 e9                	imul   %ecx
    3327:	89 d1                	mov    %edx,%ecx
    3329:	c1 f9 05             	sar    $0x5,%ecx
    332c:	29 f9                	sub    %edi,%ecx
    332e:	6b c9 64             	imul   $0x64,%ecx,%ecx
    3331:	89 d8                	mov    %ebx,%eax
    3333:	29 c8                	sub    %ecx,%eax
    3335:	89 c1                	mov    %eax,%ecx
    3337:	be 67 66 66 66       	mov    $0x66666667,%esi
    333c:	f7 ee                	imul   %esi
    333e:	c1 fa 02             	sar    $0x2,%edx
    3341:	c1 f9 1f             	sar    $0x1f,%ecx
    3344:	29 ca                	sub    %ecx,%edx
    3346:	83 c2 30             	add    $0x30,%edx
    3349:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    334c:	89 d8                	mov    %ebx,%eax
    334e:	f7 ee                	imul   %esi
    3350:	c1 fa 02             	sar    $0x2,%edx
    3353:	29 fa                	sub    %edi,%edx
    3355:	8d 14 92             	lea    (%edx,%edx,4),%edx
    3358:	8d 04 12             	lea    (%edx,%edx,1),%eax
    335b:	89 da                	mov    %ebx,%edx
    335d:	29 c2                	sub    %eax,%edx
    335f:	83 c2 30             	add    $0x30,%edx
    3362:	88 55 ac             	mov    %dl,-0x54(%ebp)
    name[5] = '\0';
    3365:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    3369:	83 ec 0c             	sub    $0xc,%esp
    336c:	8d 45 a8             	lea    -0x58(%ebp),%eax
    336f:	50                   	push   %eax
    3370:	e8 0f 04 00 00       	call   3784 <unlink>
    nfiles--;
    3375:	83 eb 01             	sub    $0x1,%ebx
    3378:	83 c4 10             	add    $0x10,%esp
  while(nfiles >= 0){
    337b:	85 db                	test   %ebx,%ebx
    337d:	0f 89 62 ff ff ff    	jns    32e5 <fsfull+0x137>
  }

  printf(1, "fsfull test finished\n");
    3383:	83 ec 08             	sub    $0x8,%esp
    3386:	68 dc 4a 00 00       	push   $0x4adc
    338b:	6a 01                	push   $0x1
    338d:	e8 f4 04 00 00       	call   3886 <printf>
}
    3392:	83 c4 10             	add    $0x10,%esp
    3395:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3398:	5b                   	pop    %ebx
    3399:	5e                   	pop    %esi
    339a:	5f                   	pop    %edi
    339b:	5d                   	pop    %ebp
    339c:	c3                   	ret    

0000339d <uio>:

void
uio()
{
    339d:	55                   	push   %ebp
    339e:	89 e5                	mov    %esp,%ebp
    33a0:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    33a3:	68 f2 4a 00 00       	push   $0x4af2
    33a8:	6a 01                	push   $0x1
    33aa:	e8 d7 04 00 00       	call   3886 <printf>
  pid = fork();
    33af:	e8 78 03 00 00       	call   372c <fork>
  if(pid == 0){
    33b4:	83 c4 10             	add    $0x10,%esp
    33b7:	85 c0                	test   %eax,%eax
    33b9:	74 1d                	je     33d8 <uio+0x3b>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit();
  } else if(pid < 0){
    33bb:	85 c0                	test   %eax,%eax
    33bd:	78 3e                	js     33fd <uio+0x60>
    printf (1, "fork failed\n");
    exit();
  }
  wait();
    33bf:	e8 78 03 00 00       	call   373c <wait>
  printf(1, "uio test done\n");
    33c4:	83 ec 08             	sub    $0x8,%esp
    33c7:	68 fc 4a 00 00       	push   $0x4afc
    33cc:	6a 01                	push   $0x1
    33ce:	e8 b3 04 00 00       	call   3886 <printf>
}
    33d3:	83 c4 10             	add    $0x10,%esp
    33d6:	c9                   	leave  
    33d7:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    33d8:	b8 09 00 00 00       	mov    $0x9,%eax
    33dd:	ba 70 00 00 00       	mov    $0x70,%edx
    33e2:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    33e3:	ba 71 00 00 00       	mov    $0x71,%edx
    33e8:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    33e9:	83 ec 08             	sub    $0x8,%esp
    33ec:	68 88 52 00 00       	push   $0x5288
    33f1:	6a 01                	push   $0x1
    33f3:	e8 8e 04 00 00       	call   3886 <printf>
    exit();
    33f8:	e8 37 03 00 00       	call   3734 <exit>
    printf (1, "fork failed\n");
    33fd:	83 ec 08             	sub    $0x8,%esp
    3400:	68 81 4a 00 00       	push   $0x4a81
    3405:	6a 01                	push   $0x1
    3407:	e8 7a 04 00 00       	call   3886 <printf>
    exit();
    340c:	e8 23 03 00 00       	call   3734 <exit>

00003411 <argptest>:

void argptest()
{
    3411:	55                   	push   %ebp
    3412:	89 e5                	mov    %esp,%ebp
    3414:	53                   	push   %ebx
    3415:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3418:	6a 00                	push   $0x0
    341a:	68 0b 4b 00 00       	push   $0x4b0b
    341f:	e8 50 03 00 00       	call   3774 <open>
  if (fd < 0) {
    3424:	83 c4 10             	add    $0x10,%esp
    3427:	85 c0                	test   %eax,%eax
    3429:	78 3a                	js     3465 <argptest+0x54>
    342b:	89 c3                	mov    %eax,%ebx
    printf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
    342d:	83 ec 0c             	sub    $0xc,%esp
    3430:	6a 00                	push   $0x0
    3432:	e8 85 03 00 00       	call   37bc <sbrk>
    3437:	83 e8 01             	sub    $0x1,%eax
    343a:	83 c4 0c             	add    $0xc,%esp
    343d:	6a ff                	push   $0xffffffff
    343f:	50                   	push   %eax
    3440:	53                   	push   %ebx
    3441:	e8 06 03 00 00       	call   374c <read>
  close(fd);
    3446:	89 1c 24             	mov    %ebx,(%esp)
    3449:	e8 0e 03 00 00       	call   375c <close>
  printf(1, "arg test passed\n");
    344e:	83 c4 08             	add    $0x8,%esp
    3451:	68 1d 4b 00 00       	push   $0x4b1d
    3456:	6a 01                	push   $0x1
    3458:	e8 29 04 00 00       	call   3886 <printf>
}
    345d:	83 c4 10             	add    $0x10,%esp
    3460:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3463:	c9                   	leave  
    3464:	c3                   	ret    
    printf(2, "open failed\n");
    3465:	83 ec 08             	sub    $0x8,%esp
    3468:	68 10 4b 00 00       	push   $0x4b10
    346d:	6a 02                	push   $0x2
    346f:	e8 12 04 00 00       	call   3886 <printf>
    exit();
    3474:	e8 bb 02 00 00       	call   3734 <exit>

00003479 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3479:	55                   	push   %ebp
    347a:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    347c:	69 05 7c 5b 00 00 0d 	imul   $0x19660d,0x5b7c,%eax
    3483:	66 19 00 
    3486:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    348b:	a3 7c 5b 00 00       	mov    %eax,0x5b7c
  return randstate;
}
    3490:	5d                   	pop    %ebp
    3491:	c3                   	ret    

00003492 <main>:

int
main(int argc, char *argv[])
{
    3492:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3496:	83 e4 f0             	and    $0xfffffff0,%esp
    3499:	ff 71 fc             	pushl  -0x4(%ecx)
    349c:	55                   	push   %ebp
    349d:	89 e5                	mov    %esp,%ebp
    349f:	51                   	push   %ecx
    34a0:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    34a3:	68 2e 4b 00 00       	push   $0x4b2e
    34a8:	6a 01                	push   $0x1
    34aa:	e8 d7 03 00 00       	call   3886 <printf>

  if(open("usertests.ran", 0) >= 0){
    34af:	83 c4 08             	add    $0x8,%esp
    34b2:	6a 00                	push   $0x0
    34b4:	68 42 4b 00 00       	push   $0x4b42
    34b9:	e8 b6 02 00 00       	call   3774 <open>
    34be:	83 c4 10             	add    $0x10,%esp
    34c1:	85 c0                	test   %eax,%eax
    34c3:	78 14                	js     34d9 <main+0x47>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    34c5:	83 ec 08             	sub    $0x8,%esp
    34c8:	68 ac 52 00 00       	push   $0x52ac
    34cd:	6a 01                	push   $0x1
    34cf:	e8 b2 03 00 00       	call   3886 <printf>
    exit();
    34d4:	e8 5b 02 00 00       	call   3734 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    34d9:	83 ec 08             	sub    $0x8,%esp
    34dc:	68 00 02 00 00       	push   $0x200
    34e1:	68 42 4b 00 00       	push   $0x4b42
    34e6:	e8 89 02 00 00       	call   3774 <open>
    34eb:	89 04 24             	mov    %eax,(%esp)
    34ee:	e8 69 02 00 00       	call   375c <close>

  argptest();
    34f3:	e8 19 ff ff ff       	call   3411 <argptest>
  createdelete();
    34f8:	e8 24 db ff ff       	call   1021 <createdelete>
  linkunlink();
    34fd:	e8 c3 e3 ff ff       	call   18c5 <linkunlink>
  concreate();
    3502:	e8 d0 e0 ff ff       	call   15d7 <concreate>
  fourfiles();
    3507:	e8 30 d9 ff ff       	call   e3c <fourfiles>
  sharedfd();
    350c:	e8 8e d7 ff ff       	call   c9f <sharedfd>

  bigargtest();
    3511:	e8 97 fb ff ff       	call   30ad <bigargtest>
  bigwrite();
    3516:	e8 1e ed ff ff       	call   2239 <bigwrite>
  bigargtest();
    351b:	e8 8d fb ff ff       	call   30ad <bigargtest>
  bsstest();
    3520:	e8 25 fb ff ff       	call   304a <bsstest>
  sbrktest();
    3525:	e8 4e f6 ff ff       	call   2b78 <sbrktest>
  validatetest();
    352a:	e8 6a fa ff ff       	call   2f99 <validatetest>

  opentest();
    352f:	e8 7c cd ff ff       	call   2b0 <opentest>
  writetest();
    3534:	e8 0a ce ff ff       	call   343 <writetest>
  writetest1();
    3539:	e8 cd cf ff ff       	call   50b <writetest1>
  createtest();
    353e:	e8 78 d1 ff ff       	call   6bb <createtest>

  openiputtest();
    3543:	e8 7d cc ff ff       	call   1c5 <openiputtest>
  exitiputtest();
    3548:	e8 90 cb ff ff       	call   dd <exitiputtest>
  iputtest();
    354d:	e8 ae ca ff ff       	call   0 <iputtest>

  mem();
    3552:	e8 8a d6 ff ff       	call   be1 <mem>
  pipe1();
    3557:	e8 31 d3 ff ff       	call   88d <pipe1>
  preempt();
    355c:	e8 cc d4 ff ff       	call   a2d <preempt>
  exitwait();
    3561:	e8 09 d6 ff ff       	call   b6f <exitwait>

  rmdot();
    3566:	e8 95 f0 ff ff       	call   2600 <rmdot>
  fourteen();
    356b:	e8 53 ef ff ff       	call   24c3 <fourteen>
  bigfile();
    3570:	e8 96 ed ff ff       	call   230b <bigfile>
  subdir();
    3575:	e8 91 e5 ff ff       	call   1b0b <subdir>
  linktest();
    357a:	e8 32 de ff ff       	call   13b1 <linktest>
  unlinkread();
    357f:	e8 94 dc ff ff       	call   1218 <unlinkread>
  dirfile();
    3584:	e8 fc f1 ff ff       	call   2785 <dirfile>
  iref();
    3589:	e8 11 f4 ff ff       	call   299f <iref>
  forktest();
    358e:	e8 34 f5 ff ff       	call   2ac7 <forktest>
  bigdir(); // slow
    3593:	e8 1f e4 ff ff       	call   19b7 <bigdir>

  uio();
    3598:	e8 00 fe ff ff       	call   339d <uio>

  exectest();
    359d:	e8 a2 d2 ff ff       	call   844 <exectest>

  exit();
    35a2:	e8 8d 01 00 00       	call   3734 <exit>

000035a7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    35a7:	55                   	push   %ebp
    35a8:	89 e5                	mov    %esp,%ebp
    35aa:	53                   	push   %ebx
    35ab:	8b 45 08             	mov    0x8(%ebp),%eax
    35ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    35b1:	89 c2                	mov    %eax,%edx
    35b3:	0f b6 19             	movzbl (%ecx),%ebx
    35b6:	88 1a                	mov    %bl,(%edx)
    35b8:	8d 52 01             	lea    0x1(%edx),%edx
    35bb:	8d 49 01             	lea    0x1(%ecx),%ecx
    35be:	84 db                	test   %bl,%bl
    35c0:	75 f1                	jne    35b3 <strcpy+0xc>
    ;
  return os;
}
    35c2:	5b                   	pop    %ebx
    35c3:	5d                   	pop    %ebp
    35c4:	c3                   	ret    

000035c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    35c5:	55                   	push   %ebp
    35c6:	89 e5                	mov    %esp,%ebp
    35c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    35cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    35ce:	eb 06                	jmp    35d6 <strcmp+0x11>
    p++, q++;
    35d0:	83 c1 01             	add    $0x1,%ecx
    35d3:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    35d6:	0f b6 01             	movzbl (%ecx),%eax
    35d9:	84 c0                	test   %al,%al
    35db:	74 04                	je     35e1 <strcmp+0x1c>
    35dd:	3a 02                	cmp    (%edx),%al
    35df:	74 ef                	je     35d0 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
    35e1:	0f b6 c0             	movzbl %al,%eax
    35e4:	0f b6 12             	movzbl (%edx),%edx
    35e7:	29 d0                	sub    %edx,%eax
}
    35e9:	5d                   	pop    %ebp
    35ea:	c3                   	ret    

000035eb <strlen>:

uint
strlen(const char *s)
{
    35eb:	55                   	push   %ebp
    35ec:	89 e5                	mov    %esp,%ebp
    35ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    35f1:	ba 00 00 00 00       	mov    $0x0,%edx
    35f6:	eb 03                	jmp    35fb <strlen+0x10>
    35f8:	83 c2 01             	add    $0x1,%edx
    35fb:	89 d0                	mov    %edx,%eax
    35fd:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    3601:	75 f5                	jne    35f8 <strlen+0xd>
    ;
  return n;
}
    3603:	5d                   	pop    %ebp
    3604:	c3                   	ret    

00003605 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3605:	55                   	push   %ebp
    3606:	89 e5                	mov    %esp,%ebp
    3608:	57                   	push   %edi
    3609:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    360c:	89 d7                	mov    %edx,%edi
    360e:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3611:	8b 45 0c             	mov    0xc(%ebp),%eax
    3614:	fc                   	cld    
    3615:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3617:	89 d0                	mov    %edx,%eax
    3619:	5f                   	pop    %edi
    361a:	5d                   	pop    %ebp
    361b:	c3                   	ret    

0000361c <strchr>:

char*
strchr(const char *s, char c)
{
    361c:	55                   	push   %ebp
    361d:	89 e5                	mov    %esp,%ebp
    361f:	8b 45 08             	mov    0x8(%ebp),%eax
    3622:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    3626:	0f b6 10             	movzbl (%eax),%edx
    3629:	84 d2                	test   %dl,%dl
    362b:	74 09                	je     3636 <strchr+0x1a>
    if(*s == c)
    362d:	38 ca                	cmp    %cl,%dl
    362f:	74 0a                	je     363b <strchr+0x1f>
  for(; *s; s++)
    3631:	83 c0 01             	add    $0x1,%eax
    3634:	eb f0                	jmp    3626 <strchr+0xa>
      return (char*)s;
  return 0;
    3636:	b8 00 00 00 00       	mov    $0x0,%eax
}
    363b:	5d                   	pop    %ebp
    363c:	c3                   	ret    

0000363d <gets>:

char*
gets(char *buf, int max)
{
    363d:	55                   	push   %ebp
    363e:	89 e5                	mov    %esp,%ebp
    3640:	57                   	push   %edi
    3641:	56                   	push   %esi
    3642:	53                   	push   %ebx
    3643:	83 ec 1c             	sub    $0x1c,%esp
    3646:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3649:	bb 00 00 00 00       	mov    $0x0,%ebx
    364e:	8d 73 01             	lea    0x1(%ebx),%esi
    3651:	3b 75 0c             	cmp    0xc(%ebp),%esi
    3654:	7d 2e                	jge    3684 <gets+0x47>
    cc = read(0, &c, 1);
    3656:	83 ec 04             	sub    $0x4,%esp
    3659:	6a 01                	push   $0x1
    365b:	8d 45 e7             	lea    -0x19(%ebp),%eax
    365e:	50                   	push   %eax
    365f:	6a 00                	push   $0x0
    3661:	e8 e6 00 00 00       	call   374c <read>
    if(cc < 1)
    3666:	83 c4 10             	add    $0x10,%esp
    3669:	85 c0                	test   %eax,%eax
    366b:	7e 17                	jle    3684 <gets+0x47>
      break;
    buf[i++] = c;
    366d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    3671:	88 04 1f             	mov    %al,(%edi,%ebx,1)
    if(c == '\n' || c == '\r')
    3674:	3c 0a                	cmp    $0xa,%al
    3676:	0f 94 c2             	sete   %dl
    3679:	3c 0d                	cmp    $0xd,%al
    367b:	0f 94 c0             	sete   %al
    buf[i++] = c;
    367e:	89 f3                	mov    %esi,%ebx
    if(c == '\n' || c == '\r')
    3680:	08 c2                	or     %al,%dl
    3682:	74 ca                	je     364e <gets+0x11>
      break;
  }
  buf[i] = '\0';
    3684:	c6 04 1f 00          	movb   $0x0,(%edi,%ebx,1)
  return buf;
}
    3688:	89 f8                	mov    %edi,%eax
    368a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    368d:	5b                   	pop    %ebx
    368e:	5e                   	pop    %esi
    368f:	5f                   	pop    %edi
    3690:	5d                   	pop    %ebp
    3691:	c3                   	ret    

00003692 <stat>:

int
stat(const char *n, struct stat *st)
{
    3692:	55                   	push   %ebp
    3693:	89 e5                	mov    %esp,%ebp
    3695:	56                   	push   %esi
    3696:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3697:	83 ec 08             	sub    $0x8,%esp
    369a:	6a 00                	push   $0x0
    369c:	ff 75 08             	pushl  0x8(%ebp)
    369f:	e8 d0 00 00 00       	call   3774 <open>
  if(fd < 0)
    36a4:	83 c4 10             	add    $0x10,%esp
    36a7:	85 c0                	test   %eax,%eax
    36a9:	78 24                	js     36cf <stat+0x3d>
    36ab:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    36ad:	83 ec 08             	sub    $0x8,%esp
    36b0:	ff 75 0c             	pushl  0xc(%ebp)
    36b3:	50                   	push   %eax
    36b4:	e8 d3 00 00 00       	call   378c <fstat>
    36b9:	89 c6                	mov    %eax,%esi
  close(fd);
    36bb:	89 1c 24             	mov    %ebx,(%esp)
    36be:	e8 99 00 00 00       	call   375c <close>
  return r;
    36c3:	83 c4 10             	add    $0x10,%esp
}
    36c6:	89 f0                	mov    %esi,%eax
    36c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    36cb:	5b                   	pop    %ebx
    36cc:	5e                   	pop    %esi
    36cd:	5d                   	pop    %ebp
    36ce:	c3                   	ret    
    return -1;
    36cf:	be ff ff ff ff       	mov    $0xffffffff,%esi
    36d4:	eb f0                	jmp    36c6 <stat+0x34>

000036d6 <atoi>:

int
atoi(const char *s)
{
    36d6:	55                   	push   %ebp
    36d7:	89 e5                	mov    %esp,%ebp
    36d9:	53                   	push   %ebx
    36da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
    36dd:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    36e2:	eb 10                	jmp    36f4 <atoi+0x1e>
    n = n*10 + *s++ - '0';
    36e4:	8d 1c 80             	lea    (%eax,%eax,4),%ebx
    36e7:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
    36ea:	83 c1 01             	add    $0x1,%ecx
    36ed:	0f be d2             	movsbl %dl,%edx
    36f0:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  while('0' <= *s && *s <= '9')
    36f4:	0f b6 11             	movzbl (%ecx),%edx
    36f7:	8d 5a d0             	lea    -0x30(%edx),%ebx
    36fa:	80 fb 09             	cmp    $0x9,%bl
    36fd:	76 e5                	jbe    36e4 <atoi+0xe>
  return n;
}
    36ff:	5b                   	pop    %ebx
    3700:	5d                   	pop    %ebp
    3701:	c3                   	ret    

00003702 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3702:	55                   	push   %ebp
    3703:	89 e5                	mov    %esp,%ebp
    3705:	56                   	push   %esi
    3706:	53                   	push   %ebx
    3707:	8b 45 08             	mov    0x8(%ebp),%eax
    370a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    370d:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
    3710:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
    3712:	eb 0d                	jmp    3721 <memmove+0x1f>
    *dst++ = *src++;
    3714:	0f b6 13             	movzbl (%ebx),%edx
    3717:	88 11                	mov    %dl,(%ecx)
    3719:	8d 5b 01             	lea    0x1(%ebx),%ebx
    371c:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
    371f:	89 f2                	mov    %esi,%edx
    3721:	8d 72 ff             	lea    -0x1(%edx),%esi
    3724:	85 d2                	test   %edx,%edx
    3726:	7f ec                	jg     3714 <memmove+0x12>
  return vdst;
}
    3728:	5b                   	pop    %ebx
    3729:	5e                   	pop    %esi
    372a:	5d                   	pop    %ebp
    372b:	c3                   	ret    

0000372c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    372c:	b8 01 00 00 00       	mov    $0x1,%eax
    3731:	cd 40                	int    $0x40
    3733:	c3                   	ret    

00003734 <exit>:
SYSCALL(exit)
    3734:	b8 02 00 00 00       	mov    $0x2,%eax
    3739:	cd 40                	int    $0x40
    373b:	c3                   	ret    

0000373c <wait>:
SYSCALL(wait)
    373c:	b8 03 00 00 00       	mov    $0x3,%eax
    3741:	cd 40                	int    $0x40
    3743:	c3                   	ret    

00003744 <pipe>:
SYSCALL(pipe)
    3744:	b8 04 00 00 00       	mov    $0x4,%eax
    3749:	cd 40                	int    $0x40
    374b:	c3                   	ret    

0000374c <read>:
SYSCALL(read)
    374c:	b8 05 00 00 00       	mov    $0x5,%eax
    3751:	cd 40                	int    $0x40
    3753:	c3                   	ret    

00003754 <write>:
SYSCALL(write)
    3754:	b8 10 00 00 00       	mov    $0x10,%eax
    3759:	cd 40                	int    $0x40
    375b:	c3                   	ret    

0000375c <close>:
SYSCALL(close)
    375c:	b8 15 00 00 00       	mov    $0x15,%eax
    3761:	cd 40                	int    $0x40
    3763:	c3                   	ret    

00003764 <kill>:
SYSCALL(kill)
    3764:	b8 06 00 00 00       	mov    $0x6,%eax
    3769:	cd 40                	int    $0x40
    376b:	c3                   	ret    

0000376c <exec>:
SYSCALL(exec)
    376c:	b8 07 00 00 00       	mov    $0x7,%eax
    3771:	cd 40                	int    $0x40
    3773:	c3                   	ret    

00003774 <open>:
SYSCALL(open)
    3774:	b8 0f 00 00 00       	mov    $0xf,%eax
    3779:	cd 40                	int    $0x40
    377b:	c3                   	ret    

0000377c <mknod>:
SYSCALL(mknod)
    377c:	b8 11 00 00 00       	mov    $0x11,%eax
    3781:	cd 40                	int    $0x40
    3783:	c3                   	ret    

00003784 <unlink>:
SYSCALL(unlink)
    3784:	b8 12 00 00 00       	mov    $0x12,%eax
    3789:	cd 40                	int    $0x40
    378b:	c3                   	ret    

0000378c <fstat>:
SYSCALL(fstat)
    378c:	b8 08 00 00 00       	mov    $0x8,%eax
    3791:	cd 40                	int    $0x40
    3793:	c3                   	ret    

00003794 <link>:
SYSCALL(link)
    3794:	b8 13 00 00 00       	mov    $0x13,%eax
    3799:	cd 40                	int    $0x40
    379b:	c3                   	ret    

0000379c <mkdir>:
SYSCALL(mkdir)
    379c:	b8 14 00 00 00       	mov    $0x14,%eax
    37a1:	cd 40                	int    $0x40
    37a3:	c3                   	ret    

000037a4 <chdir>:
SYSCALL(chdir)
    37a4:	b8 09 00 00 00       	mov    $0x9,%eax
    37a9:	cd 40                	int    $0x40
    37ab:	c3                   	ret    

000037ac <dup>:
SYSCALL(dup)
    37ac:	b8 0a 00 00 00       	mov    $0xa,%eax
    37b1:	cd 40                	int    $0x40
    37b3:	c3                   	ret    

000037b4 <getpid>:
SYSCALL(getpid)
    37b4:	b8 0b 00 00 00       	mov    $0xb,%eax
    37b9:	cd 40                	int    $0x40
    37bb:	c3                   	ret    

000037bc <sbrk>:
SYSCALL(sbrk)
    37bc:	b8 0c 00 00 00       	mov    $0xc,%eax
    37c1:	cd 40                	int    $0x40
    37c3:	c3                   	ret    

000037c4 <sleep>:
SYSCALL(sleep)
    37c4:	b8 0d 00 00 00       	mov    $0xd,%eax
    37c9:	cd 40                	int    $0x40
    37cb:	c3                   	ret    

000037cc <uptime>:
SYSCALL(uptime)
    37cc:	b8 0e 00 00 00       	mov    $0xe,%eax
    37d1:	cd 40                	int    $0x40
    37d3:	c3                   	ret    

000037d4 <sigprocmask>:
SYSCALL(sigprocmask)
    37d4:	b8 16 00 00 00       	mov    $0x16,%eax
    37d9:	cd 40                	int    $0x40
    37db:	c3                   	ret    

000037dc <sigaction>:
SYSCALL(sigaction)
    37dc:	b8 17 00 00 00       	mov    $0x17,%eax
    37e1:	cd 40                	int    $0x40
    37e3:	c3                   	ret    

000037e4 <sigret>:
SYSCALL(sigret)
    37e4:	b8 18 00 00 00       	mov    $0x18,%eax
    37e9:	cd 40                	int    $0x40
    37eb:	c3                   	ret    

000037ec <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    37ec:	55                   	push   %ebp
    37ed:	89 e5                	mov    %esp,%ebp
    37ef:	83 ec 1c             	sub    $0x1c,%esp
    37f2:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
    37f5:	6a 01                	push   $0x1
    37f7:	8d 55 f4             	lea    -0xc(%ebp),%edx
    37fa:	52                   	push   %edx
    37fb:	50                   	push   %eax
    37fc:	e8 53 ff ff ff       	call   3754 <write>
}
    3801:	83 c4 10             	add    $0x10,%esp
    3804:	c9                   	leave  
    3805:	c3                   	ret    

00003806 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3806:	55                   	push   %ebp
    3807:	89 e5                	mov    %esp,%ebp
    3809:	57                   	push   %edi
    380a:	56                   	push   %esi
    380b:	53                   	push   %ebx
    380c:	83 ec 2c             	sub    $0x2c,%esp
    380f:	89 c7                	mov    %eax,%edi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    3811:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    3815:	0f 95 c3             	setne  %bl
    3818:	89 d0                	mov    %edx,%eax
    381a:	c1 e8 1f             	shr    $0x1f,%eax
    381d:	84 c3                	test   %al,%bl
    381f:	74 10                	je     3831 <printint+0x2b>
    neg = 1;
    x = -xx;
    3821:	f7 da                	neg    %edx
    neg = 1;
    3823:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    382a:	be 00 00 00 00       	mov    $0x0,%esi
    382f:	eb 0b                	jmp    383c <printint+0x36>
  neg = 0;
    3831:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    3838:	eb f0                	jmp    382a <printint+0x24>
  do{
    buf[i++] = digits[x % base];
    383a:	89 c6                	mov    %eax,%esi
    383c:	89 d0                	mov    %edx,%eax
    383e:	ba 00 00 00 00       	mov    $0x0,%edx
    3843:	f7 f1                	div    %ecx
    3845:	89 c3                	mov    %eax,%ebx
    3847:	8d 46 01             	lea    0x1(%esi),%eax
    384a:	0f b6 92 e0 52 00 00 	movzbl 0x52e0(%edx),%edx
    3851:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
    3855:	89 da                	mov    %ebx,%edx
    3857:	85 db                	test   %ebx,%ebx
    3859:	75 df                	jne    383a <printint+0x34>
    385b:	89 c3                	mov    %eax,%ebx
  if(neg)
    385d:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
    3861:	74 16                	je     3879 <printint+0x73>
    buf[i++] = '-';
    3863:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
    3868:	8d 5e 02             	lea    0x2(%esi),%ebx
    386b:	eb 0c                	jmp    3879 <printint+0x73>

  while(--i >= 0)
    putc(fd, buf[i]);
    386d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
    3872:	89 f8                	mov    %edi,%eax
    3874:	e8 73 ff ff ff       	call   37ec <putc>
  while(--i >= 0)
    3879:	83 eb 01             	sub    $0x1,%ebx
    387c:	79 ef                	jns    386d <printint+0x67>
}
    387e:	83 c4 2c             	add    $0x2c,%esp
    3881:	5b                   	pop    %ebx
    3882:	5e                   	pop    %esi
    3883:	5f                   	pop    %edi
    3884:	5d                   	pop    %ebp
    3885:	c3                   	ret    

00003886 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3886:	55                   	push   %ebp
    3887:	89 e5                	mov    %esp,%ebp
    3889:	57                   	push   %edi
    388a:	56                   	push   %esi
    388b:	53                   	push   %ebx
    388c:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    388f:	8d 45 10             	lea    0x10(%ebp),%eax
    3892:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
    3895:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
    389a:	bb 00 00 00 00       	mov    $0x0,%ebx
    389f:	eb 14                	jmp    38b5 <printf+0x2f>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    38a1:	89 fa                	mov    %edi,%edx
    38a3:	8b 45 08             	mov    0x8(%ebp),%eax
    38a6:	e8 41 ff ff ff       	call   37ec <putc>
    38ab:	eb 05                	jmp    38b2 <printf+0x2c>
      }
    } else if(state == '%'){
    38ad:	83 fe 25             	cmp    $0x25,%esi
    38b0:	74 25                	je     38d7 <printf+0x51>
  for(i = 0; fmt[i]; i++){
    38b2:	83 c3 01             	add    $0x1,%ebx
    38b5:	8b 45 0c             	mov    0xc(%ebp),%eax
    38b8:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
    38bc:	84 c0                	test   %al,%al
    38be:	0f 84 23 01 00 00    	je     39e7 <printf+0x161>
    c = fmt[i] & 0xff;
    38c4:	0f be f8             	movsbl %al,%edi
    38c7:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    38ca:	85 f6                	test   %esi,%esi
    38cc:	75 df                	jne    38ad <printf+0x27>
      if(c == '%'){
    38ce:	83 f8 25             	cmp    $0x25,%eax
    38d1:	75 ce                	jne    38a1 <printf+0x1b>
        state = '%';
    38d3:	89 c6                	mov    %eax,%esi
    38d5:	eb db                	jmp    38b2 <printf+0x2c>
      if(c == 'd'){
    38d7:	83 f8 64             	cmp    $0x64,%eax
    38da:	74 49                	je     3925 <printf+0x9f>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    38dc:	83 f8 78             	cmp    $0x78,%eax
    38df:	0f 94 c1             	sete   %cl
    38e2:	83 f8 70             	cmp    $0x70,%eax
    38e5:	0f 94 c2             	sete   %dl
    38e8:	08 d1                	or     %dl,%cl
    38ea:	75 63                	jne    394f <printf+0xc9>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    38ec:	83 f8 73             	cmp    $0x73,%eax
    38ef:	0f 84 84 00 00 00    	je     3979 <printf+0xf3>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    38f5:	83 f8 63             	cmp    $0x63,%eax
    38f8:	0f 84 b7 00 00 00    	je     39b5 <printf+0x12f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    38fe:	83 f8 25             	cmp    $0x25,%eax
    3901:	0f 84 cc 00 00 00    	je     39d3 <printf+0x14d>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    3907:	ba 25 00 00 00       	mov    $0x25,%edx
    390c:	8b 45 08             	mov    0x8(%ebp),%eax
    390f:	e8 d8 fe ff ff       	call   37ec <putc>
        putc(fd, c);
    3914:	89 fa                	mov    %edi,%edx
    3916:	8b 45 08             	mov    0x8(%ebp),%eax
    3919:	e8 ce fe ff ff       	call   37ec <putc>
      }
      state = 0;
    391e:	be 00 00 00 00       	mov    $0x0,%esi
    3923:	eb 8d                	jmp    38b2 <printf+0x2c>
        printint(fd, *ap, 10, 1);
    3925:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    3928:	8b 17                	mov    (%edi),%edx
    392a:	83 ec 0c             	sub    $0xc,%esp
    392d:	6a 01                	push   $0x1
    392f:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3934:	8b 45 08             	mov    0x8(%ebp),%eax
    3937:	e8 ca fe ff ff       	call   3806 <printint>
        ap++;
    393c:	83 c7 04             	add    $0x4,%edi
    393f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    3942:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3945:	be 00 00 00 00       	mov    $0x0,%esi
    394a:	e9 63 ff ff ff       	jmp    38b2 <printf+0x2c>
        printint(fd, *ap, 16, 0);
    394f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    3952:	8b 17                	mov    (%edi),%edx
    3954:	83 ec 0c             	sub    $0xc,%esp
    3957:	6a 00                	push   $0x0
    3959:	b9 10 00 00 00       	mov    $0x10,%ecx
    395e:	8b 45 08             	mov    0x8(%ebp),%eax
    3961:	e8 a0 fe ff ff       	call   3806 <printint>
        ap++;
    3966:	83 c7 04             	add    $0x4,%edi
    3969:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    396c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    396f:	be 00 00 00 00       	mov    $0x0,%esi
    3974:	e9 39 ff ff ff       	jmp    38b2 <printf+0x2c>
        s = (char*)*ap;
    3979:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    397c:	8b 30                	mov    (%eax),%esi
        ap++;
    397e:	83 c0 04             	add    $0x4,%eax
    3981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
    3984:	85 f6                	test   %esi,%esi
    3986:	75 28                	jne    39b0 <printf+0x12a>
          s = "(null)";
    3988:	be d8 52 00 00       	mov    $0x52d8,%esi
    398d:	8b 7d 08             	mov    0x8(%ebp),%edi
    3990:	eb 0d                	jmp    399f <printf+0x119>
          putc(fd, *s);
    3992:	0f be d2             	movsbl %dl,%edx
    3995:	89 f8                	mov    %edi,%eax
    3997:	e8 50 fe ff ff       	call   37ec <putc>
          s++;
    399c:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
    399f:	0f b6 16             	movzbl (%esi),%edx
    39a2:	84 d2                	test   %dl,%dl
    39a4:	75 ec                	jne    3992 <printf+0x10c>
      state = 0;
    39a6:	be 00 00 00 00       	mov    $0x0,%esi
    39ab:	e9 02 ff ff ff       	jmp    38b2 <printf+0x2c>
    39b0:	8b 7d 08             	mov    0x8(%ebp),%edi
    39b3:	eb ea                	jmp    399f <printf+0x119>
        putc(fd, *ap);
    39b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    39b8:	0f be 17             	movsbl (%edi),%edx
    39bb:	8b 45 08             	mov    0x8(%ebp),%eax
    39be:	e8 29 fe ff ff       	call   37ec <putc>
        ap++;
    39c3:	83 c7 04             	add    $0x4,%edi
    39c6:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
    39c9:	be 00 00 00 00       	mov    $0x0,%esi
    39ce:	e9 df fe ff ff       	jmp    38b2 <printf+0x2c>
        putc(fd, c);
    39d3:	89 fa                	mov    %edi,%edx
    39d5:	8b 45 08             	mov    0x8(%ebp),%eax
    39d8:	e8 0f fe ff ff       	call   37ec <putc>
      state = 0;
    39dd:	be 00 00 00 00       	mov    $0x0,%esi
    39e2:	e9 cb fe ff ff       	jmp    38b2 <printf+0x2c>
    }
  }
}
    39e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    39ea:	5b                   	pop    %ebx
    39eb:	5e                   	pop    %esi
    39ec:	5f                   	pop    %edi
    39ed:	5d                   	pop    %ebp
    39ee:	c3                   	ret    

000039ef <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    39ef:	55                   	push   %ebp
    39f0:	89 e5                	mov    %esp,%ebp
    39f2:	57                   	push   %edi
    39f3:	56                   	push   %esi
    39f4:	53                   	push   %ebx
    39f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    39f8:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    39fb:	a1 20 5c 00 00       	mov    0x5c20,%eax
    3a00:	eb 02                	jmp    3a04 <free+0x15>
    3a02:	89 d0                	mov    %edx,%eax
    3a04:	39 c8                	cmp    %ecx,%eax
    3a06:	73 04                	jae    3a0c <free+0x1d>
    3a08:	39 08                	cmp    %ecx,(%eax)
    3a0a:	77 12                	ja     3a1e <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3a0c:	8b 10                	mov    (%eax),%edx
    3a0e:	39 c2                	cmp    %eax,%edx
    3a10:	77 f0                	ja     3a02 <free+0x13>
    3a12:	39 c8                	cmp    %ecx,%eax
    3a14:	72 08                	jb     3a1e <free+0x2f>
    3a16:	39 ca                	cmp    %ecx,%edx
    3a18:	77 04                	ja     3a1e <free+0x2f>
    3a1a:	89 d0                	mov    %edx,%eax
    3a1c:	eb e6                	jmp    3a04 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3a1e:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3a21:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3a24:	8b 10                	mov    (%eax),%edx
    3a26:	39 d7                	cmp    %edx,%edi
    3a28:	74 19                	je     3a43 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3a2a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3a2d:	8b 50 04             	mov    0x4(%eax),%edx
    3a30:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3a33:	39 ce                	cmp    %ecx,%esi
    3a35:	74 1b                	je     3a52 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3a37:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3a39:	a3 20 5c 00 00       	mov    %eax,0x5c20
}
    3a3e:	5b                   	pop    %ebx
    3a3f:	5e                   	pop    %esi
    3a40:	5f                   	pop    %edi
    3a41:	5d                   	pop    %ebp
    3a42:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    3a43:	03 72 04             	add    0x4(%edx),%esi
    3a46:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3a49:	8b 10                	mov    (%eax),%edx
    3a4b:	8b 12                	mov    (%edx),%edx
    3a4d:	89 53 f8             	mov    %edx,-0x8(%ebx)
    3a50:	eb db                	jmp    3a2d <free+0x3e>
    p->s.size += bp->s.size;
    3a52:	03 53 fc             	add    -0x4(%ebx),%edx
    3a55:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3a58:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3a5b:	89 10                	mov    %edx,(%eax)
    3a5d:	eb da                	jmp    3a39 <free+0x4a>

00003a5f <morecore>:

static Header*
morecore(uint nu)
{
    3a5f:	55                   	push   %ebp
    3a60:	89 e5                	mov    %esp,%ebp
    3a62:	53                   	push   %ebx
    3a63:	83 ec 04             	sub    $0x4,%esp
    3a66:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    3a68:	3d ff 0f 00 00       	cmp    $0xfff,%eax
    3a6d:	77 05                	ja     3a74 <morecore+0x15>
    nu = 4096;
    3a6f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    3a74:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    3a7b:	83 ec 0c             	sub    $0xc,%esp
    3a7e:	50                   	push   %eax
    3a7f:	e8 38 fd ff ff       	call   37bc <sbrk>
  if(p == (char*)-1)
    3a84:	83 c4 10             	add    $0x10,%esp
    3a87:	83 f8 ff             	cmp    $0xffffffff,%eax
    3a8a:	74 1c                	je     3aa8 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    3a8c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3a8f:	83 c0 08             	add    $0x8,%eax
    3a92:	83 ec 0c             	sub    $0xc,%esp
    3a95:	50                   	push   %eax
    3a96:	e8 54 ff ff ff       	call   39ef <free>
  return freep;
    3a9b:	a1 20 5c 00 00       	mov    0x5c20,%eax
    3aa0:	83 c4 10             	add    $0x10,%esp
}
    3aa3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3aa6:	c9                   	leave  
    3aa7:	c3                   	ret    
    return 0;
    3aa8:	b8 00 00 00 00       	mov    $0x0,%eax
    3aad:	eb f4                	jmp    3aa3 <morecore+0x44>

00003aaf <malloc>:

void*
malloc(uint nbytes)
{
    3aaf:	55                   	push   %ebp
    3ab0:	89 e5                	mov    %esp,%ebp
    3ab2:	53                   	push   %ebx
    3ab3:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3ab6:	8b 45 08             	mov    0x8(%ebp),%eax
    3ab9:	8d 58 07             	lea    0x7(%eax),%ebx
    3abc:	c1 eb 03             	shr    $0x3,%ebx
    3abf:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    3ac2:	8b 0d 20 5c 00 00    	mov    0x5c20,%ecx
    3ac8:	85 c9                	test   %ecx,%ecx
    3aca:	74 04                	je     3ad0 <malloc+0x21>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3acc:	8b 01                	mov    (%ecx),%eax
    3ace:	eb 4d                	jmp    3b1d <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
    3ad0:	c7 05 20 5c 00 00 24 	movl   $0x5c24,0x5c20
    3ad7:	5c 00 00 
    3ada:	c7 05 24 5c 00 00 24 	movl   $0x5c24,0x5c24
    3ae1:	5c 00 00 
    base.s.size = 0;
    3ae4:	c7 05 28 5c 00 00 00 	movl   $0x0,0x5c28
    3aeb:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    3aee:	b9 24 5c 00 00       	mov    $0x5c24,%ecx
    3af3:	eb d7                	jmp    3acc <malloc+0x1d>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    3af5:	39 da                	cmp    %ebx,%edx
    3af7:	74 1a                	je     3b13 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    3af9:	29 da                	sub    %ebx,%edx
    3afb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    3afe:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    3b01:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    3b04:	89 0d 20 5c 00 00    	mov    %ecx,0x5c20
      return (void*)(p + 1);
    3b0a:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    3b0d:	83 c4 04             	add    $0x4,%esp
    3b10:	5b                   	pop    %ebx
    3b11:	5d                   	pop    %ebp
    3b12:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    3b13:	8b 10                	mov    (%eax),%edx
    3b15:	89 11                	mov    %edx,(%ecx)
    3b17:	eb eb                	jmp    3b04 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3b19:	89 c1                	mov    %eax,%ecx
    3b1b:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    3b1d:	8b 50 04             	mov    0x4(%eax),%edx
    3b20:	39 da                	cmp    %ebx,%edx
    3b22:	73 d1                	jae    3af5 <malloc+0x46>
    if(p == freep)
    3b24:	39 05 20 5c 00 00    	cmp    %eax,0x5c20
    3b2a:	75 ed                	jne    3b19 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
    3b2c:	89 d8                	mov    %ebx,%eax
    3b2e:	e8 2c ff ff ff       	call   3a5f <morecore>
    3b33:	85 c0                	test   %eax,%eax
    3b35:	75 e2                	jne    3b19 <malloc+0x6a>
        return 0;
    3b37:	b8 00 00 00 00       	mov    $0x0,%eax
    3b3c:	eb cf                	jmp    3b0d <malloc+0x5e>
