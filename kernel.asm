
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 87 2a 10 80       	mov    $0x80102a87,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 c0 b5 10 80       	push   $0x8010b5c0
80100046:	e8 f9 40 00 00       	call   80104144 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010005f:	74 30                	je     80100091 <bget+0x5d>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	83 c0 01             	add    $0x1,%eax
80100071:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100074:	83 ec 0c             	sub    $0xc,%esp
80100077:	68 c0 b5 10 80       	push   $0x8010b5c0
8010007c:	e8 28 41 00 00       	call   801041a9 <release>
      acquiresleep(&b->lock);
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	89 04 24             	mov    %eax,(%esp)
80100087:	e8 a4 3e 00 00       	call   80103f30 <acquiresleep>
      return b;
8010008c:	83 c4 10             	add    $0x10,%esp
8010008f:	eb 4c                	jmp    801000dd <bget+0xa9>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100091:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100097:	eb 03                	jmp    8010009c <bget+0x68>
80100099:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009c:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000a2:	74 43                	je     801000e7 <bget+0xb3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a8:	75 ef                	jne    80100099 <bget+0x65>
801000aa:	f6 03 04             	testb  $0x4,(%ebx)
801000ad:	75 ea                	jne    80100099 <bget+0x65>
      b->dev = dev;
801000af:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b2:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 c0 b5 10 80       	push   $0x8010b5c0
801000ca:	e8 da 40 00 00       	call   801041a9 <release>
      acquiresleep(&b->lock);
801000cf:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d2:	89 04 24             	mov    %eax,(%esp)
801000d5:	e8 56 3e 00 00       	call   80103f30 <acquiresleep>
      return b;
801000da:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dd:	89 d8                	mov    %ebx,%eax
801000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e2:	5b                   	pop    %ebx
801000e3:	5e                   	pop    %esi
801000e4:	5f                   	pop    %edi
801000e5:	5d                   	pop    %ebp
801000e6:	c3                   	ret    
  panic("bget: no buffers");
801000e7:	83 ec 0c             	sub    $0xc,%esp
801000ea:	68 a0 6a 10 80       	push   $0x80106aa0
801000ef:	e8 54 02 00 00       	call   80100348 <panic>

801000f4 <binit>:
{
801000f4:	55                   	push   %ebp
801000f5:	89 e5                	mov    %esp,%ebp
801000f7:	53                   	push   %ebx
801000f8:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000fb:	68 b1 6a 10 80       	push   $0x80106ab1
80100100:	68 c0 b5 10 80       	push   $0x8010b5c0
80100105:	e8 fe 3e 00 00       	call   80104008 <initlock>
  bcache.head.prev = &bcache.head;
8010010a:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100111:	fc 10 80 
  bcache.head.next = &bcache.head;
80100114:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010011b:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010011e:	83 c4 10             	add    $0x10,%esp
80100121:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
80100126:	eb 37                	jmp    8010015f <binit+0x6b>
    b->next = bcache.head.next;
80100128:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010012d:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100130:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100137:	83 ec 08             	sub    $0x8,%esp
8010013a:	68 b8 6a 10 80       	push   $0x80106ab8
8010013f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100142:	50                   	push   %eax
80100143:	e8 b5 3d 00 00       	call   80103efd <initsleeplock>
    bcache.head.next->prev = b;
80100148:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010014d:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100150:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100156:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015c:	83 c4 10             	add    $0x10,%esp
8010015f:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100165:	72 c1                	jb     80100128 <binit+0x34>
}
80100167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016a:	c9                   	leave  
8010016b:	c3                   	ret    

8010016c <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016c:	55                   	push   %ebp
8010016d:	89 e5                	mov    %esp,%ebp
8010016f:	53                   	push   %ebx
80100170:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100173:	8b 55 0c             	mov    0xc(%ebp),%edx
80100176:	8b 45 08             	mov    0x8(%ebp),%eax
80100179:	e8 b6 fe ff ff       	call   80100034 <bget>
8010017e:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100180:	f6 00 02             	testb  $0x2,(%eax)
80100183:	74 07                	je     8010018c <bread+0x20>
    iderw(b);
  }
  return b;
}
80100185:	89 d8                	mov    %ebx,%eax
80100187:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010018a:	c9                   	leave  
8010018b:	c3                   	ret    
    iderw(b);
8010018c:	83 ec 0c             	sub    $0xc,%esp
8010018f:	50                   	push   %eax
80100190:	e8 9a 1c 00 00       	call   80101e2f <iderw>
80100195:	83 c4 10             	add    $0x10,%esp
  return b;
80100198:	eb eb                	jmp    80100185 <bread+0x19>

8010019a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
8010019a:	55                   	push   %ebp
8010019b:	89 e5                	mov    %esp,%ebp
8010019d:	53                   	push   %ebx
8010019e:	83 ec 10             	sub    $0x10,%esp
801001a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001a4:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a7:	50                   	push   %eax
801001a8:	e8 0d 3e 00 00       	call   80103fba <holdingsleep>
801001ad:	83 c4 10             	add    $0x10,%esp
801001b0:	85 c0                	test   %eax,%eax
801001b2:	74 14                	je     801001c8 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b4:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001b7:	83 ec 0c             	sub    $0xc,%esp
801001ba:	53                   	push   %ebx
801001bb:	e8 6f 1c 00 00       	call   80101e2f <iderw>
}
801001c0:	83 c4 10             	add    $0x10,%esp
801001c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c6:	c9                   	leave  
801001c7:	c3                   	ret    
    panic("bwrite");
801001c8:	83 ec 0c             	sub    $0xc,%esp
801001cb:	68 bf 6a 10 80       	push   $0x80106abf
801001d0:	e8 73 01 00 00       	call   80100348 <panic>

801001d5 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d5:	55                   	push   %ebp
801001d6:	89 e5                	mov    %esp,%ebp
801001d8:	56                   	push   %esi
801001d9:	53                   	push   %ebx
801001da:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001dd:	8d 73 0c             	lea    0xc(%ebx),%esi
801001e0:	83 ec 0c             	sub    $0xc,%esp
801001e3:	56                   	push   %esi
801001e4:	e8 d1 3d 00 00       	call   80103fba <holdingsleep>
801001e9:	83 c4 10             	add    $0x10,%esp
801001ec:	85 c0                	test   %eax,%eax
801001ee:	74 6b                	je     8010025b <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001f0:	83 ec 0c             	sub    $0xc,%esp
801001f3:	56                   	push   %esi
801001f4:	e8 86 3d 00 00       	call   80103f7f <releasesleep>

  acquire(&bcache.lock);
801001f9:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100200:	e8 3f 3f 00 00       	call   80104144 <acquire>
  b->refcnt--;
80100205:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100208:	83 e8 01             	sub    $0x1,%eax
8010020b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010020e:	83 c4 10             	add    $0x10,%esp
80100211:	85 c0                	test   %eax,%eax
80100213:	75 2f                	jne    80100244 <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100215:	8b 43 54             	mov    0x54(%ebx),%eax
80100218:	8b 53 50             	mov    0x50(%ebx),%edx
8010021b:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021e:	8b 43 50             	mov    0x50(%ebx),%eax
80100221:	8b 53 54             	mov    0x54(%ebx),%edx
80100224:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100227:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010022c:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010022f:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
80100236:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023e:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100244:	83 ec 0c             	sub    $0xc,%esp
80100247:	68 c0 b5 10 80       	push   $0x8010b5c0
8010024c:	e8 58 3f 00 00       	call   801041a9 <release>
}
80100251:	83 c4 10             	add    $0x10,%esp
80100254:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100257:	5b                   	pop    %ebx
80100258:	5e                   	pop    %esi
80100259:	5d                   	pop    %ebp
8010025a:	c3                   	ret    
    panic("brelse");
8010025b:	83 ec 0c             	sub    $0xc,%esp
8010025e:	68 c6 6a 10 80       	push   $0x80106ac6
80100263:	e8 e0 00 00 00       	call   80100348 <panic>

80100268 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100268:	55                   	push   %ebp
80100269:	89 e5                	mov    %esp,%ebp
8010026b:	57                   	push   %edi
8010026c:	56                   	push   %esi
8010026d:	53                   	push   %ebx
8010026e:	83 ec 28             	sub    $0x28,%esp
80100271:	8b 7d 08             	mov    0x8(%ebp),%edi
80100274:	8b 75 0c             	mov    0xc(%ebp),%esi
80100277:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010027a:	57                   	push   %edi
8010027b:	e8 e6 13 00 00       	call   80101666 <iunlock>
  target = n;
80100280:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100283:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028a:	e8 b5 3e 00 00       	call   80104144 <acquire>
  while(n > 0){
8010028f:	83 c4 10             	add    $0x10,%esp
80100292:	85 db                	test   %ebx,%ebx
80100294:	0f 8e 8f 00 00 00    	jle    80100329 <consoleread+0xc1>
    while(input.r == input.w){
8010029a:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010029f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002a5:	75 47                	jne    801002ee <consoleread+0x86>
      if(myproc()->killed){
801002a7:	e8 13 2f 00 00       	call   801031bf <myproc>
801002ac:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002b0:	75 17                	jne    801002c9 <consoleread+0x61>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b2:	83 ec 08             	sub    $0x8,%esp
801002b5:	68 20 a5 10 80       	push   $0x8010a520
801002ba:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bf:	e8 78 36 00 00       	call   8010393c <sleep>
801002c4:	83 c4 10             	add    $0x10,%esp
801002c7:	eb d1                	jmp    8010029a <consoleread+0x32>
        release(&cons.lock);
801002c9:	83 ec 0c             	sub    $0xc,%esp
801002cc:	68 20 a5 10 80       	push   $0x8010a520
801002d1:	e8 d3 3e 00 00       	call   801041a9 <release>
        ilock(ip);
801002d6:	89 3c 24             	mov    %edi,(%esp)
801002d9:	e8 c6 12 00 00       	call   801015a4 <ilock>
        return -1;
801002de:	83 c4 10             	add    $0x10,%esp
801002e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002e9:	5b                   	pop    %ebx
801002ea:	5e                   	pop    %esi
801002eb:	5f                   	pop    %edi
801002ec:	5d                   	pop    %ebp
801002ed:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002ee:	8d 50 01             	lea    0x1(%eax),%edx
801002f1:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002f7:	89 c2                	mov    %eax,%edx
801002f9:	83 e2 7f             	and    $0x7f,%edx
801002fc:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
80100303:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
80100306:	83 fa 04             	cmp    $0x4,%edx
80100309:	74 14                	je     8010031f <consoleread+0xb7>
    *dst++ = c;
8010030b:	8d 46 01             	lea    0x1(%esi),%eax
8010030e:	88 0e                	mov    %cl,(%esi)
    --n;
80100310:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100313:	83 fa 0a             	cmp    $0xa,%edx
80100316:	74 11                	je     80100329 <consoleread+0xc1>
    *dst++ = c;
80100318:	89 c6                	mov    %eax,%esi
8010031a:	e9 73 ff ff ff       	jmp    80100292 <consoleread+0x2a>
      if(n < target){
8010031f:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100322:	73 05                	jae    80100329 <consoleread+0xc1>
        input.r--;
80100324:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
  release(&cons.lock);
80100329:	83 ec 0c             	sub    $0xc,%esp
8010032c:	68 20 a5 10 80       	push   $0x8010a520
80100331:	e8 73 3e 00 00       	call   801041a9 <release>
  ilock(ip);
80100336:	89 3c 24             	mov    %edi,(%esp)
80100339:	e8 66 12 00 00       	call   801015a4 <ilock>
  return target - n;
8010033e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100341:	29 d8                	sub    %ebx,%eax
80100343:	83 c4 10             	add    $0x10,%esp
80100346:	eb 9e                	jmp    801002e6 <consoleread+0x7e>

80100348 <panic>:
{
80100348:	55                   	push   %ebp
80100349:	89 e5                	mov    %esp,%ebp
8010034b:	53                   	push   %ebx
8010034c:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034f:	fa                   	cli    
  cons.locking = 0;
80100350:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100357:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010035a:	e8 42 20 00 00       	call   801023a1 <lapicid>
8010035f:	83 ec 08             	sub    $0x8,%esp
80100362:	50                   	push   %eax
80100363:	68 cd 6a 10 80       	push   $0x80106acd
80100368:	e8 9e 02 00 00       	call   8010060b <cprintf>
  cprintf(s);
8010036d:	83 c4 04             	add    $0x4,%esp
80100370:	ff 75 08             	pushl  0x8(%ebp)
80100373:	e8 93 02 00 00       	call   8010060b <cprintf>
  cprintf("\n");
80100378:	c7 04 24 43 75 10 80 	movl   $0x80107543,(%esp)
8010037f:	e8 87 02 00 00       	call   8010060b <cprintf>
  getcallerpcs(&s, pcs);
80100384:	83 c4 08             	add    $0x8,%esp
80100387:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010038a:	50                   	push   %eax
8010038b:	8d 45 08             	lea    0x8(%ebp),%eax
8010038e:	50                   	push   %eax
8010038f:	e8 8f 3c 00 00       	call   80104023 <getcallerpcs>
  for(i=0; i<10; i++)
80100394:	83 c4 10             	add    $0x10,%esp
80100397:	bb 00 00 00 00       	mov    $0x0,%ebx
8010039c:	eb 17                	jmp    801003b5 <panic+0x6d>
    cprintf(" %p", pcs[i]);
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003a5:	68 e1 6a 10 80       	push   $0x80106ae1
801003aa:	e8 5c 02 00 00       	call   8010060b <cprintf>
  for(i=0; i<10; i++)
801003af:	83 c3 01             	add    $0x1,%ebx
801003b2:	83 c4 10             	add    $0x10,%esp
801003b5:	83 fb 09             	cmp    $0x9,%ebx
801003b8:	7e e4                	jle    8010039e <panic+0x56>
  panicked = 1; // freeze other CPU
801003ba:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003c1:	00 00 00 
801003c4:	eb fe                	jmp    801003c4 <panic+0x7c>

801003c6 <cgaputc>:
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	57                   	push   %edi
801003ca:	56                   	push   %esi
801003cb:	53                   	push   %ebx
801003cc:	83 ec 0c             	sub    $0xc,%esp
801003cf:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003d1:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801003d6:	b8 0e 00 00 00       	mov    $0xe,%eax
801003db:	89 ca                	mov    %ecx,%edx
801003dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003de:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003e3:	89 da                	mov    %ebx,%edx
801003e5:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003e6:	0f b6 f8             	movzbl %al,%edi
801003e9:	c1 e7 08             	shl    $0x8,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003ec:	b8 0f 00 00 00       	mov    $0xf,%eax
801003f1:	89 ca                	mov    %ecx,%edx
801003f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f4:	89 da                	mov    %ebx,%edx
801003f6:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003f7:	0f b6 c8             	movzbl %al,%ecx
801003fa:	09 f9                	or     %edi,%ecx
  if(c == '\n')
801003fc:	83 fe 0a             	cmp    $0xa,%esi
801003ff:	74 6a                	je     8010046b <cgaputc+0xa5>
  else if(c == BACKSPACE){
80100401:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100407:	0f 84 81 00 00 00    	je     8010048e <cgaputc+0xc8>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010040d:	89 f0                	mov    %esi,%eax
8010040f:	0f b6 f0             	movzbl %al,%esi
80100412:	8d 59 01             	lea    0x1(%ecx),%ebx
80100415:	66 81 ce 00 07       	or     $0x700,%si
8010041a:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100421:	80 
  if(pos < 0 || pos > 25*80)
80100422:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100428:	77 71                	ja     8010049b <cgaputc+0xd5>
  if((pos/80) >= 24){  // Scroll up.
8010042a:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100430:	7f 76                	jg     801004a8 <cgaputc+0xe2>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	be d4 03 00 00       	mov    $0x3d4,%esi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 f2                	mov    %esi,%edx
8010043e:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010043f:	89 d8                	mov    %ebx,%eax
80100441:	c1 f8 08             	sar    $0x8,%eax
80100444:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100449:	89 ca                	mov    %ecx,%edx
8010044b:	ee                   	out    %al,(%dx)
8010044c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100451:	89 f2                	mov    %esi,%edx
80100453:	ee                   	out    %al,(%dx)
80100454:	89 d8                	mov    %ebx,%eax
80100456:	89 ca                	mov    %ecx,%edx
80100458:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100459:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100460:	80 20 07 
}
80100463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100466:	5b                   	pop    %ebx
80100467:	5e                   	pop    %esi
80100468:	5f                   	pop    %edi
80100469:	5d                   	pop    %ebp
8010046a:	c3                   	ret    
    pos += 80 - pos%80;
8010046b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100470:	89 c8                	mov    %ecx,%eax
80100472:	f7 ea                	imul   %edx
80100474:	c1 fa 05             	sar    $0x5,%edx
80100477:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010047a:	89 d0                	mov    %edx,%eax
8010047c:	c1 e0 04             	shl    $0x4,%eax
8010047f:	89 ca                	mov    %ecx,%edx
80100481:	29 c2                	sub    %eax,%edx
80100483:	bb 50 00 00 00       	mov    $0x50,%ebx
80100488:	29 d3                	sub    %edx,%ebx
8010048a:	01 cb                	add    %ecx,%ebx
8010048c:	eb 94                	jmp    80100422 <cgaputc+0x5c>
    if(pos > 0) --pos;
8010048e:	85 c9                	test   %ecx,%ecx
80100490:	7e 05                	jle    80100497 <cgaputc+0xd1>
80100492:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100495:	eb 8b                	jmp    80100422 <cgaputc+0x5c>
  pos |= inb(CRTPORT+1);
80100497:	89 cb                	mov    %ecx,%ebx
80100499:	eb 87                	jmp    80100422 <cgaputc+0x5c>
    panic("pos under/overflow");
8010049b:	83 ec 0c             	sub    $0xc,%esp
8010049e:	68 e5 6a 10 80       	push   $0x80106ae5
801004a3:	e8 a0 fe ff ff       	call   80100348 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004a8:	83 ec 04             	sub    $0x4,%esp
801004ab:	68 60 0e 00 00       	push   $0xe60
801004b0:	68 a0 80 0b 80       	push   $0x800b80a0
801004b5:	68 00 80 0b 80       	push   $0x800b8000
801004ba:	e8 ac 3d 00 00       	call   8010426b <memmove>
    pos -= 80;
801004bf:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004c2:	b8 80 07 00 00       	mov    $0x780,%eax
801004c7:	29 d8                	sub    %ebx,%eax
801004c9:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004d0:	83 c4 0c             	add    $0xc,%esp
801004d3:	01 c0                	add    %eax,%eax
801004d5:	50                   	push   %eax
801004d6:	6a 00                	push   $0x0
801004d8:	52                   	push   %edx
801004d9:	e8 12 3d 00 00       	call   801041f0 <memset>
801004de:	83 c4 10             	add    $0x10,%esp
801004e1:	e9 4c ff ff ff       	jmp    80100432 <cgaputc+0x6c>

801004e6 <consputc>:
  if(panicked){
801004e6:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801004ed:	74 03                	je     801004f2 <consputc+0xc>
  asm volatile("cli");
801004ef:	fa                   	cli    
801004f0:	eb fe                	jmp    801004f0 <consputc+0xa>
{
801004f2:	55                   	push   %ebp
801004f3:	89 e5                	mov    %esp,%ebp
801004f5:	53                   	push   %ebx
801004f6:	83 ec 04             	sub    $0x4,%esp
801004f9:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100500:	74 18                	je     8010051a <consputc+0x34>
    uartputc(c);
80100502:	83 ec 0c             	sub    $0xc,%esp
80100505:	50                   	push   %eax
80100506:	e8 84 51 00 00       	call   8010568f <uartputc>
8010050b:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010050e:	89 d8                	mov    %ebx,%eax
80100510:	e8 b1 fe ff ff       	call   801003c6 <cgaputc>
}
80100515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100518:	c9                   	leave  
80100519:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010051a:	83 ec 0c             	sub    $0xc,%esp
8010051d:	6a 08                	push   $0x8
8010051f:	e8 6b 51 00 00       	call   8010568f <uartputc>
80100524:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010052b:	e8 5f 51 00 00       	call   8010568f <uartputc>
80100530:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100537:	e8 53 51 00 00       	call   8010568f <uartputc>
8010053c:	83 c4 10             	add    $0x10,%esp
8010053f:	eb cd                	jmp    8010050e <consputc+0x28>

80100541 <printint>:
{
80100541:	55                   	push   %ebp
80100542:	89 e5                	mov    %esp,%ebp
80100544:	57                   	push   %edi
80100545:	56                   	push   %esi
80100546:	53                   	push   %ebx
80100547:	83 ec 1c             	sub    $0x1c,%esp
8010054a:	89 d7                	mov    %edx,%edi
  if(sign && (sign = xx < 0))
8010054c:	85 c9                	test   %ecx,%ecx
8010054e:	74 09                	je     80100559 <printint+0x18>
80100550:	89 c1                	mov    %eax,%ecx
80100552:	c1 e9 1f             	shr    $0x1f,%ecx
80100555:	85 c0                	test   %eax,%eax
80100557:	78 09                	js     80100562 <printint+0x21>
    x = xx;
80100559:	89 c2                	mov    %eax,%edx
  i = 0;
8010055b:	be 00 00 00 00       	mov    $0x0,%esi
80100560:	eb 08                	jmp    8010056a <printint+0x29>
    x = -xx;
80100562:	f7 d8                	neg    %eax
80100564:	89 c2                	mov    %eax,%edx
80100566:	eb f3                	jmp    8010055b <printint+0x1a>
    buf[i++] = digits[x % base];
80100568:	89 de                	mov    %ebx,%esi
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	ba 00 00 00 00       	mov    $0x0,%edx
80100571:	f7 f7                	div    %edi
80100573:	8d 5e 01             	lea    0x1(%esi),%ebx
80100576:	0f b6 92 10 6b 10 80 	movzbl -0x7fef94f0(%edx),%edx
8010057d:	88 54 35 d8          	mov    %dl,-0x28(%ebp,%esi,1)
  }while((x /= base) != 0);
80100581:	89 c2                	mov    %eax,%edx
80100583:	85 c0                	test   %eax,%eax
80100585:	75 e1                	jne    80100568 <printint+0x27>
  if(sign)
80100587:	85 c9                	test   %ecx,%ecx
80100589:	74 14                	je     8010059f <printint+0x5e>
    buf[i++] = '-';
8010058b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100590:	8d 5e 02             	lea    0x2(%esi),%ebx
80100593:	eb 0a                	jmp    8010059f <printint+0x5e>
    consputc(buf[i]);
80100595:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
8010059a:	e8 47 ff ff ff       	call   801004e6 <consputc>
  while(--i >= 0)
8010059f:	83 eb 01             	sub    $0x1,%ebx
801005a2:	79 f1                	jns    80100595 <printint+0x54>
}
801005a4:	83 c4 1c             	add    $0x1c,%esp
801005a7:	5b                   	pop    %ebx
801005a8:	5e                   	pop    %esi
801005a9:	5f                   	pop    %edi
801005aa:	5d                   	pop    %ebp
801005ab:	c3                   	ret    

801005ac <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005ac:	55                   	push   %ebp
801005ad:	89 e5                	mov    %esp,%ebp
801005af:	57                   	push   %edi
801005b0:	56                   	push   %esi
801005b1:	53                   	push   %ebx
801005b2:	83 ec 18             	sub    $0x18,%esp
801005b5:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005b8:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bb:	ff 75 08             	pushl  0x8(%ebp)
801005be:	e8 a3 10 00 00       	call   80101666 <iunlock>
  acquire(&cons.lock);
801005c3:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005ca:	e8 75 3b 00 00       	call   80104144 <acquire>
  for(i = 0; i < n; i++)
801005cf:	83 c4 10             	add    $0x10,%esp
801005d2:	bb 00 00 00 00       	mov    $0x0,%ebx
801005d7:	eb 0c                	jmp    801005e5 <consolewrite+0x39>
    consputc(buf[i] & 0xff);
801005d9:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005dd:	e8 04 ff ff ff       	call   801004e6 <consputc>
  for(i = 0; i < n; i++)
801005e2:	83 c3 01             	add    $0x1,%ebx
801005e5:	39 f3                	cmp    %esi,%ebx
801005e7:	7c f0                	jl     801005d9 <consolewrite+0x2d>
  release(&cons.lock);
801005e9:	83 ec 0c             	sub    $0xc,%esp
801005ec:	68 20 a5 10 80       	push   $0x8010a520
801005f1:	e8 b3 3b 00 00       	call   801041a9 <release>
  ilock(ip);
801005f6:	83 c4 04             	add    $0x4,%esp
801005f9:	ff 75 08             	pushl  0x8(%ebp)
801005fc:	e8 a3 0f 00 00       	call   801015a4 <ilock>

  return n;
}
80100601:	89 f0                	mov    %esi,%eax
80100603:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100606:	5b                   	pop    %ebx
80100607:	5e                   	pop    %esi
80100608:	5f                   	pop    %edi
80100609:	5d                   	pop    %ebp
8010060a:	c3                   	ret    

8010060b <cprintf>:
{
8010060b:	55                   	push   %ebp
8010060c:	89 e5                	mov    %esp,%ebp
8010060e:	57                   	push   %edi
8010060f:	56                   	push   %esi
80100610:	53                   	push   %ebx
80100611:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100614:	a1 54 a5 10 80       	mov    0x8010a554,%eax
80100619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
8010061c:	85 c0                	test   %eax,%eax
8010061e:	75 10                	jne    80100630 <cprintf+0x25>
  if (fmt == 0)
80100620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100624:	74 1c                	je     80100642 <cprintf+0x37>
  argp = (uint*)(void*)(&fmt + 1);
80100626:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100629:	bb 00 00 00 00       	mov    $0x0,%ebx
8010062e:	eb 27                	jmp    80100657 <cprintf+0x4c>
    acquire(&cons.lock);
80100630:	83 ec 0c             	sub    $0xc,%esp
80100633:	68 20 a5 10 80       	push   $0x8010a520
80100638:	e8 07 3b 00 00       	call   80104144 <acquire>
8010063d:	83 c4 10             	add    $0x10,%esp
80100640:	eb de                	jmp    80100620 <cprintf+0x15>
    panic("null fmt");
80100642:	83 ec 0c             	sub    $0xc,%esp
80100645:	68 ff 6a 10 80       	push   $0x80106aff
8010064a:	e8 f9 fc ff ff       	call   80100348 <panic>
      consputc(c);
8010064f:	e8 92 fe ff ff       	call   801004e6 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100654:	83 c3 01             	add    $0x1,%ebx
80100657:	8b 55 08             	mov    0x8(%ebp),%edx
8010065a:	0f b6 04 1a          	movzbl (%edx,%ebx,1),%eax
8010065e:	85 c0                	test   %eax,%eax
80100660:	0f 84 b8 00 00 00    	je     8010071e <cprintf+0x113>
    if(c != '%'){
80100666:	83 f8 25             	cmp    $0x25,%eax
80100669:	75 e4                	jne    8010064f <cprintf+0x44>
    c = fmt[++i] & 0xff;
8010066b:	83 c3 01             	add    $0x1,%ebx
8010066e:	0f b6 34 1a          	movzbl (%edx,%ebx,1),%esi
    if(c == 0)
80100672:	85 f6                	test   %esi,%esi
80100674:	0f 84 a4 00 00 00    	je     8010071e <cprintf+0x113>
    switch(c){
8010067a:	83 fe 70             	cmp    $0x70,%esi
8010067d:	74 48                	je     801006c7 <cprintf+0xbc>
8010067f:	83 fe 70             	cmp    $0x70,%esi
80100682:	7f 26                	jg     801006aa <cprintf+0x9f>
80100684:	83 fe 25             	cmp    $0x25,%esi
80100687:	0f 84 82 00 00 00    	je     8010070f <cprintf+0x104>
8010068d:	83 fe 64             	cmp    $0x64,%esi
80100690:	75 22                	jne    801006b4 <cprintf+0xa9>
      printint(*argp++, 10, 1);
80100692:	8d 77 04             	lea    0x4(%edi),%esi
80100695:	8b 07                	mov    (%edi),%eax
80100697:	b9 01 00 00 00       	mov    $0x1,%ecx
8010069c:	ba 0a 00 00 00       	mov    $0xa,%edx
801006a1:	e8 9b fe ff ff       	call   80100541 <printint>
801006a6:	89 f7                	mov    %esi,%edi
      break;
801006a8:	eb aa                	jmp    80100654 <cprintf+0x49>
    switch(c){
801006aa:	83 fe 73             	cmp    $0x73,%esi
801006ad:	74 33                	je     801006e2 <cprintf+0xd7>
801006af:	83 fe 78             	cmp    $0x78,%esi
801006b2:	74 13                	je     801006c7 <cprintf+0xbc>
      consputc('%');
801006b4:	b8 25 00 00 00       	mov    $0x25,%eax
801006b9:	e8 28 fe ff ff       	call   801004e6 <consputc>
      consputc(c);
801006be:	89 f0                	mov    %esi,%eax
801006c0:	e8 21 fe ff ff       	call   801004e6 <consputc>
      break;
801006c5:	eb 8d                	jmp    80100654 <cprintf+0x49>
      printint(*argp++, 16, 0);
801006c7:	8d 77 04             	lea    0x4(%edi),%esi
801006ca:	8b 07                	mov    (%edi),%eax
801006cc:	b9 00 00 00 00       	mov    $0x0,%ecx
801006d1:	ba 10 00 00 00       	mov    $0x10,%edx
801006d6:	e8 66 fe ff ff       	call   80100541 <printint>
801006db:	89 f7                	mov    %esi,%edi
      break;
801006dd:	e9 72 ff ff ff       	jmp    80100654 <cprintf+0x49>
      if((s = (char*)*argp++) == 0)
801006e2:	8d 47 04             	lea    0x4(%edi),%eax
801006e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006e8:	8b 37                	mov    (%edi),%esi
801006ea:	85 f6                	test   %esi,%esi
801006ec:	75 12                	jne    80100700 <cprintf+0xf5>
        s = "(null)";
801006ee:	be f8 6a 10 80       	mov    $0x80106af8,%esi
801006f3:	eb 0b                	jmp    80100700 <cprintf+0xf5>
        consputc(*s);
801006f5:	0f be c0             	movsbl %al,%eax
801006f8:	e8 e9 fd ff ff       	call   801004e6 <consputc>
      for(; *s; s++)
801006fd:	83 c6 01             	add    $0x1,%esi
80100700:	0f b6 06             	movzbl (%esi),%eax
80100703:	84 c0                	test   %al,%al
80100705:	75 ee                	jne    801006f5 <cprintf+0xea>
      if((s = (char*)*argp++) == 0)
80100707:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010070a:	e9 45 ff ff ff       	jmp    80100654 <cprintf+0x49>
      consputc('%');
8010070f:	b8 25 00 00 00       	mov    $0x25,%eax
80100714:	e8 cd fd ff ff       	call   801004e6 <consputc>
      break;
80100719:	e9 36 ff ff ff       	jmp    80100654 <cprintf+0x49>
  if(locking)
8010071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100722:	75 08                	jne    8010072c <cprintf+0x121>
}
80100724:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100727:	5b                   	pop    %ebx
80100728:	5e                   	pop    %esi
80100729:	5f                   	pop    %edi
8010072a:	5d                   	pop    %ebp
8010072b:	c3                   	ret    
    release(&cons.lock);
8010072c:	83 ec 0c             	sub    $0xc,%esp
8010072f:	68 20 a5 10 80       	push   $0x8010a520
80100734:	e8 70 3a 00 00       	call   801041a9 <release>
80100739:	83 c4 10             	add    $0x10,%esp
}
8010073c:	eb e6                	jmp    80100724 <cprintf+0x119>

8010073e <consoleintr>:
{
8010073e:	55                   	push   %ebp
8010073f:	89 e5                	mov    %esp,%ebp
80100741:	57                   	push   %edi
80100742:	56                   	push   %esi
80100743:	53                   	push   %ebx
80100744:	83 ec 18             	sub    $0x18,%esp
80100747:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010074a:	68 20 a5 10 80       	push   $0x8010a520
8010074f:	e8 f0 39 00 00       	call   80104144 <acquire>
  while((c = getc()) >= 0){
80100754:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100757:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
8010075c:	e9 c5 00 00 00       	jmp    80100826 <consoleintr+0xe8>
    switch(c){
80100761:	83 ff 08             	cmp    $0x8,%edi
80100764:	0f 84 e0 00 00 00    	je     8010084a <consoleintr+0x10c>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010076a:	85 ff                	test   %edi,%edi
8010076c:	0f 84 b4 00 00 00    	je     80100826 <consoleintr+0xe8>
80100772:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100777:	89 c2                	mov    %eax,%edx
80100779:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
8010077f:	83 fa 7f             	cmp    $0x7f,%edx
80100782:	0f 87 9e 00 00 00    	ja     80100826 <consoleintr+0xe8>
        c = (c == '\r') ? '\n' : c;
80100788:	83 ff 0d             	cmp    $0xd,%edi
8010078b:	0f 84 86 00 00 00    	je     80100817 <consoleintr+0xd9>
        input.buf[input.e++ % INPUT_BUF] = c;
80100791:	8d 50 01             	lea    0x1(%eax),%edx
80100794:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
8010079a:	83 e0 7f             	and    $0x7f,%eax
8010079d:	89 f9                	mov    %edi,%ecx
8010079f:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801007a5:	89 f8                	mov    %edi,%eax
801007a7:	e8 3a fd ff ff       	call   801004e6 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007ac:	83 ff 0a             	cmp    $0xa,%edi
801007af:	0f 94 c2             	sete   %dl
801007b2:	83 ff 04             	cmp    $0x4,%edi
801007b5:	0f 94 c0             	sete   %al
801007b8:	08 c2                	or     %al,%dl
801007ba:	75 10                	jne    801007cc <consoleintr+0x8e>
801007bc:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801007c1:	83 e8 80             	sub    $0xffffff80,%eax
801007c4:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801007ca:	75 5a                	jne    80100826 <consoleintr+0xe8>
          input.w = input.e;
801007cc:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007d1:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801007d6:	83 ec 0c             	sub    $0xc,%esp
801007d9:	68 a0 ff 10 80       	push   $0x8010ffa0
801007de:	e8 05 32 00 00       	call   801039e8 <wakeup>
801007e3:	83 c4 10             	add    $0x10,%esp
801007e6:	eb 3e                	jmp    80100826 <consoleintr+0xe8>
        input.e--;
801007e8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801007ed:	b8 00 01 00 00       	mov    $0x100,%eax
801007f2:	e8 ef fc ff ff       	call   801004e6 <consputc>
      while(input.e != input.w &&
801007f7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007fc:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100802:	74 22                	je     80100826 <consoleintr+0xe8>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100804:	83 e8 01             	sub    $0x1,%eax
80100807:	89 c2                	mov    %eax,%edx
80100809:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010080c:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100813:	75 d3                	jne    801007e8 <consoleintr+0xaa>
80100815:	eb 0f                	jmp    80100826 <consoleintr+0xe8>
        c = (c == '\r') ? '\n' : c;
80100817:	bf 0a 00 00 00       	mov    $0xa,%edi
8010081c:	e9 70 ff ff ff       	jmp    80100791 <consoleintr+0x53>
      doprocdump = 1;
80100821:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100826:	ff d3                	call   *%ebx
80100828:	89 c7                	mov    %eax,%edi
8010082a:	85 c0                	test   %eax,%eax
8010082c:	78 3d                	js     8010086b <consoleintr+0x12d>
    switch(c){
8010082e:	83 ff 10             	cmp    $0x10,%edi
80100831:	74 ee                	je     80100821 <consoleintr+0xe3>
80100833:	83 ff 10             	cmp    $0x10,%edi
80100836:	0f 8e 25 ff ff ff    	jle    80100761 <consoleintr+0x23>
8010083c:	83 ff 15             	cmp    $0x15,%edi
8010083f:	74 b6                	je     801007f7 <consoleintr+0xb9>
80100841:	83 ff 7f             	cmp    $0x7f,%edi
80100844:	0f 85 20 ff ff ff    	jne    8010076a <consoleintr+0x2c>
      if(input.e != input.w){
8010084a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100855:	74 cf                	je     80100826 <consoleintr+0xe8>
        input.e--;
80100857:	83 e8 01             	sub    $0x1,%eax
8010085a:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
8010085f:	b8 00 01 00 00       	mov    $0x100,%eax
80100864:	e8 7d fc ff ff       	call   801004e6 <consputc>
80100869:	eb bb                	jmp    80100826 <consoleintr+0xe8>
  release(&cons.lock);
8010086b:	83 ec 0c             	sub    $0xc,%esp
8010086e:	68 20 a5 10 80       	push   $0x8010a520
80100873:	e8 31 39 00 00       	call   801041a9 <release>
  if(doprocdump) {
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	85 f6                	test   %esi,%esi
8010087d:	75 08                	jne    80100887 <consoleintr+0x149>
}
8010087f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100882:	5b                   	pop    %ebx
80100883:	5e                   	pop    %esi
80100884:	5f                   	pop    %edi
80100885:	5d                   	pop    %ebp
80100886:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100887:	e8 1d 32 00 00       	call   80103aa9 <procdump>
}
8010088c:	eb f1                	jmp    8010087f <consoleintr+0x141>

8010088e <consoleinit>:

void
consoleinit(void)
{
8010088e:	55                   	push   %ebp
8010088f:	89 e5                	mov    %esp,%ebp
80100891:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100894:	68 08 6b 10 80       	push   $0x80106b08
80100899:	68 20 a5 10 80       	push   $0x8010a520
8010089e:	e8 65 37 00 00       	call   80104008 <initlock>

  devsw[CONSOLE].write = consolewrite;
801008a3:	c7 05 6c 09 11 80 ac 	movl   $0x801005ac,0x8011096c
801008aa:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008ad:	c7 05 68 09 11 80 68 	movl   $0x80100268,0x80110968
801008b4:	02 10 80 
  cons.locking = 1;
801008b7:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801008be:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008c1:	83 c4 08             	add    $0x8,%esp
801008c4:	6a 00                	push   $0x0
801008c6:	6a 01                	push   $0x1
801008c8:	e8 d4 16 00 00       	call   80101fa1 <ioapicenable>
}
801008cd:	83 c4 10             	add    $0x10,%esp
801008d0:	c9                   	leave  
801008d1:	c3                   	ret    

801008d2 <default_sighandlers>:
  return -1;
}


void
default_sighandlers (struct proc* currproc) {
801008d2:	55                   	push   %ebp
801008d3:	89 e5                	mov    %esp,%ebp
  int i;
  void** sig_handlers = (void**) &currproc->sig_handlers;
801008d5:	8b 45 08             	mov    0x8(%ebp),%eax
801008d8:	8d 88 84 00 00 00    	lea    0x84(%eax),%ecx
  for (i = 0; i < SIG_HANDLERS_NUM; i++)
801008de:	b8 00 00 00 00       	mov    $0x0,%eax
801008e3:	eb 03                	jmp    801008e8 <default_sighandlers+0x16>
801008e5:	83 c0 01             	add    $0x1,%eax
801008e8:	83 f8 1f             	cmp    $0x1f,%eax
801008eb:	7f 10                	jg     801008fd <default_sighandlers+0x2b>
  {
    if(sig_handlers[i] != SIG_DFL && sig_handlers[i] != SIG_IGN)
801008ed:	8d 14 81             	lea    (%ecx,%eax,4),%edx
801008f0:	83 3a 01             	cmpl   $0x1,(%edx)
801008f3:	76 f0                	jbe    801008e5 <default_sighandlers+0x13>
      sig_handlers[i] = SIG_DFL;
801008f5:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
801008fb:	eb e8                	jmp    801008e5 <default_sighandlers+0x13>
  }
801008fd:	5d                   	pop    %ebp
801008fe:	c3                   	ret    

801008ff <exec>:
{
801008ff:	55                   	push   %ebp
80100900:	89 e5                	mov    %esp,%ebp
80100902:	57                   	push   %edi
80100903:	56                   	push   %esi
80100904:	53                   	push   %ebx
80100905:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct proc *curproc = myproc();
8010090b:	e8 af 28 00 00       	call   801031bf <myproc>
80100910:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  begin_op();
80100916:	e8 b6 1e 00 00       	call   801027d1 <begin_op>
  if((ip = namei(path)) == 0){
8010091b:	83 ec 0c             	sub    $0xc,%esp
8010091e:	ff 75 08             	pushl  0x8(%ebp)
80100921:	e8 de 12 00 00       	call   80101c04 <namei>
80100926:	83 c4 10             	add    $0x10,%esp
80100929:	85 c0                	test   %eax,%eax
8010092b:	74 4a                	je     80100977 <exec+0x78>
8010092d:	89 c3                	mov    %eax,%ebx
  ilock(ip);
8010092f:	83 ec 0c             	sub    $0xc,%esp
80100932:	50                   	push   %eax
80100933:	e8 6c 0c 00 00       	call   801015a4 <ilock>
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100938:	6a 34                	push   $0x34
8010093a:	6a 00                	push   $0x0
8010093c:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100942:	50                   	push   %eax
80100943:	53                   	push   %ebx
80100944:	e8 4d 0e 00 00       	call   80101796 <readi>
80100949:	83 c4 20             	add    $0x20,%esp
8010094c:	83 f8 34             	cmp    $0x34,%eax
8010094f:	74 42                	je     80100993 <exec+0x94>
  if(ip){
80100951:	85 db                	test   %ebx,%ebx
80100953:	0f 84 e5 02 00 00    	je     80100c3e <exec+0x33f>
    iunlockput(ip);
80100959:	83 ec 0c             	sub    $0xc,%esp
8010095c:	53                   	push   %ebx
8010095d:	e8 e9 0d 00 00       	call   8010174b <iunlockput>
    end_op();
80100962:	e8 e4 1e 00 00       	call   8010284b <end_op>
80100967:	83 c4 10             	add    $0x10,%esp
  return -1;
8010096a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010096f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100972:	5b                   	pop    %ebx
80100973:	5e                   	pop    %esi
80100974:	5f                   	pop    %edi
80100975:	5d                   	pop    %ebp
80100976:	c3                   	ret    
    end_op();
80100977:	e8 cf 1e 00 00       	call   8010284b <end_op>
    cprintf("exec: fail\n");
8010097c:	83 ec 0c             	sub    $0xc,%esp
8010097f:	68 21 6b 10 80       	push   $0x80106b21
80100984:	e8 82 fc ff ff       	call   8010060b <cprintf>
    return -1;
80100989:	83 c4 10             	add    $0x10,%esp
8010098c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100991:	eb dc                	jmp    8010096f <exec+0x70>
  if(elf.magic != ELF_MAGIC)
80100993:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010099a:	45 4c 46 
8010099d:	75 b2                	jne    80100951 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
8010099f:	e8 ab 5e 00 00       	call   8010684f <setupkvm>
801009a4:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
801009aa:	85 c0                	test   %eax,%eax
801009ac:	0f 84 06 01 00 00    	je     80100ab8 <exec+0x1b9>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009b2:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
801009b8:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009bd:	be 00 00 00 00       	mov    $0x0,%esi
801009c2:	eb 0c                	jmp    801009d0 <exec+0xd1>
801009c4:	83 c6 01             	add    $0x1,%esi
801009c7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801009cd:	83 c0 20             	add    $0x20,%eax
801009d0:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
801009d7:	39 f2                	cmp    %esi,%edx
801009d9:	0f 8e 98 00 00 00    	jle    80100a77 <exec+0x178>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009df:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009e5:	6a 20                	push   $0x20
801009e7:	50                   	push   %eax
801009e8:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009ee:	50                   	push   %eax
801009ef:	53                   	push   %ebx
801009f0:	e8 a1 0d 00 00       	call   80101796 <readi>
801009f5:	83 c4 10             	add    $0x10,%esp
801009f8:	83 f8 20             	cmp    $0x20,%eax
801009fb:	0f 85 b7 00 00 00    	jne    80100ab8 <exec+0x1b9>
    if(ph.type != ELF_PROG_LOAD)
80100a01:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a08:	75 ba                	jne    801009c4 <exec+0xc5>
    if(ph.memsz < ph.filesz)
80100a0a:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a10:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a16:	0f 82 9c 00 00 00    	jb     80100ab8 <exec+0x1b9>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a1c:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a22:	0f 82 90 00 00 00    	jb     80100ab8 <exec+0x1b9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a28:	83 ec 04             	sub    $0x4,%esp
80100a2b:	50                   	push   %eax
80100a2c:	57                   	push   %edi
80100a2d:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100a33:	e8 bd 5c 00 00       	call   801066f5 <allocuvm>
80100a38:	89 c7                	mov    %eax,%edi
80100a3a:	83 c4 10             	add    $0x10,%esp
80100a3d:	85 c0                	test   %eax,%eax
80100a3f:	74 77                	je     80100ab8 <exec+0x1b9>
    if(ph.vaddr % PGSIZE != 0)
80100a41:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a47:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a4c:	75 6a                	jne    80100ab8 <exec+0x1b9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a4e:	83 ec 0c             	sub    $0xc,%esp
80100a51:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a57:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a5d:	53                   	push   %ebx
80100a5e:	50                   	push   %eax
80100a5f:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100a65:	e8 59 5b 00 00       	call   801065c3 <loaduvm>
80100a6a:	83 c4 20             	add    $0x20,%esp
80100a6d:	85 c0                	test   %eax,%eax
80100a6f:	0f 89 4f ff ff ff    	jns    801009c4 <exec+0xc5>
 bad:
80100a75:	eb 41                	jmp    80100ab8 <exec+0x1b9>
  iunlockput(ip);
80100a77:	83 ec 0c             	sub    $0xc,%esp
80100a7a:	53                   	push   %ebx
80100a7b:	e8 cb 0c 00 00       	call   8010174b <iunlockput>
  end_op();
80100a80:	e8 c6 1d 00 00       	call   8010284b <end_op>
  sz = PGROUNDUP(sz);
80100a85:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100a8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a90:	83 c4 0c             	add    $0xc,%esp
80100a93:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a99:	52                   	push   %edx
80100a9a:	50                   	push   %eax
80100a9b:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100aa1:	e8 4f 5c 00 00       	call   801066f5 <allocuvm>
80100aa6:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aac:	83 c4 10             	add    $0x10,%esp
80100aaf:	85 c0                	test   %eax,%eax
80100ab1:	75 24                	jne    80100ad7 <exec+0x1d8>
  ip = 0;
80100ab3:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100ab8:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100abe:	85 c0                	test   %eax,%eax
80100ac0:	0f 84 8b fe ff ff    	je     80100951 <exec+0x52>
    freevm(pgdir);
80100ac6:	83 ec 0c             	sub    $0xc,%esp
80100ac9:	50                   	push   %eax
80100aca:	e8 10 5d 00 00       	call   801067df <freevm>
80100acf:	83 c4 10             	add    $0x10,%esp
80100ad2:	e9 7a fe ff ff       	jmp    80100951 <exec+0x52>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ad7:	89 c7                	mov    %eax,%edi
80100ad9:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100adf:	83 ec 08             	sub    $0x8,%esp
80100ae2:	50                   	push   %eax
80100ae3:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100ae9:	e8 e6 5d 00 00       	call   801068d4 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100aee:	83 c4 10             	add    $0x10,%esp
80100af1:	bb 00 00 00 00       	mov    $0x0,%ebx
80100af6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100af9:	8d 34 98             	lea    (%eax,%ebx,4),%esi
80100afc:	8b 06                	mov    (%esi),%eax
80100afe:	85 c0                	test   %eax,%eax
80100b00:	74 4d                	je     80100b4f <exec+0x250>
    if(argc >= MAXARG)
80100b02:	83 fb 1f             	cmp    $0x1f,%ebx
80100b05:	0f 87 15 01 00 00    	ja     80100c20 <exec+0x321>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b0b:	83 ec 0c             	sub    $0xc,%esp
80100b0e:	50                   	push   %eax
80100b0f:	e8 7e 38 00 00       	call   80104392 <strlen>
80100b14:	29 c7                	sub    %eax,%edi
80100b16:	83 ef 01             	sub    $0x1,%edi
80100b19:	83 e7 fc             	and    $0xfffffffc,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b1c:	83 c4 04             	add    $0x4,%esp
80100b1f:	ff 36                	pushl  (%esi)
80100b21:	e8 6c 38 00 00       	call   80104392 <strlen>
80100b26:	83 c0 01             	add    $0x1,%eax
80100b29:	50                   	push   %eax
80100b2a:	ff 36                	pushl  (%esi)
80100b2c:	57                   	push   %edi
80100b2d:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b33:	e8 ea 5e 00 00       	call   80106a22 <copyout>
80100b38:	83 c4 20             	add    $0x20,%esp
80100b3b:	85 c0                	test   %eax,%eax
80100b3d:	0f 88 e7 00 00 00    	js     80100c2a <exec+0x32b>
    ustack[3+argc] = sp;
80100b43:	89 bc 9d 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%ebx,4)
  for(argc = 0; argv[argc]; argc++) {
80100b4a:	83 c3 01             	add    $0x1,%ebx
80100b4d:	eb a7                	jmp    80100af6 <exec+0x1f7>
  ustack[3+argc] = 0;
80100b4f:	c7 84 9d 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%ebx,4)
80100b56:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b5a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b61:	ff ff ff 
  ustack[1] = argc;
80100b64:	89 9d 5c ff ff ff    	mov    %ebx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b6a:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
80100b71:	89 f9                	mov    %edi,%ecx
80100b73:	29 c1                	sub    %eax,%ecx
80100b75:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b7b:	8d 04 9d 10 00 00 00 	lea    0x10(,%ebx,4),%eax
80100b82:	29 c7                	sub    %eax,%edi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b84:	50                   	push   %eax
80100b85:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b8b:	50                   	push   %eax
80100b8c:	57                   	push   %edi
80100b8d:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b93:	e8 8a 5e 00 00       	call   80106a22 <copyout>
80100b98:	83 c4 10             	add    $0x10,%esp
80100b9b:	85 c0                	test   %eax,%eax
80100b9d:	0f 88 91 00 00 00    	js     80100c34 <exec+0x335>
  for(last=s=path; *s; s++)
80100ba3:	8b 55 08             	mov    0x8(%ebp),%edx
80100ba6:	89 d0                	mov    %edx,%eax
80100ba8:	eb 03                	jmp    80100bad <exec+0x2ae>
80100baa:	83 c0 01             	add    $0x1,%eax
80100bad:	0f b6 08             	movzbl (%eax),%ecx
80100bb0:	84 c9                	test   %cl,%cl
80100bb2:	74 0a                	je     80100bbe <exec+0x2bf>
    if(*s == '/')
80100bb4:	80 f9 2f             	cmp    $0x2f,%cl
80100bb7:	75 f1                	jne    80100baa <exec+0x2ab>
      last = s+1;
80100bb9:	8d 50 01             	lea    0x1(%eax),%edx
80100bbc:	eb ec                	jmp    80100baa <exec+0x2ab>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100bbe:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100bc4:	89 f0                	mov    %esi,%eax
80100bc6:	83 c0 6c             	add    $0x6c,%eax
80100bc9:	83 ec 04             	sub    $0x4,%esp
80100bcc:	6a 10                	push   $0x10
80100bce:	52                   	push   %edx
80100bcf:	50                   	push   %eax
80100bd0:	e8 82 37 00 00       	call   80104357 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100bd5:	8b 5e 04             	mov    0x4(%esi),%ebx
  curproc->pgdir = pgdir;
80100bd8:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100bde:	89 4e 04             	mov    %ecx,0x4(%esi)
  curproc->sz = sz;
80100be1:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100be7:	89 0e                	mov    %ecx,(%esi)
  curproc->tf->eip = elf.entry;  // main
80100be9:	8b 46 18             	mov    0x18(%esi),%eax
80100bec:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bf2:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bf5:	8b 46 18             	mov    0x18(%esi),%eax
80100bf8:	89 78 44             	mov    %edi,0x44(%eax)
  default_sighandlers(curproc);
80100bfb:	89 34 24             	mov    %esi,(%esp)
80100bfe:	e8 cf fc ff ff       	call   801008d2 <default_sighandlers>
  switchuvm(curproc);
80100c03:	89 34 24             	mov    %esi,(%esp)
80100c06:	e8 37 58 00 00       	call   80106442 <switchuvm>
  freevm(oldpgdir);
80100c0b:	89 1c 24             	mov    %ebx,(%esp)
80100c0e:	e8 cc 5b 00 00       	call   801067df <freevm>
  return 0;
80100c13:	83 c4 10             	add    $0x10,%esp
80100c16:	b8 00 00 00 00       	mov    $0x0,%eax
80100c1b:	e9 4f fd ff ff       	jmp    8010096f <exec+0x70>
  ip = 0;
80100c20:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c25:	e9 8e fe ff ff       	jmp    80100ab8 <exec+0x1b9>
80100c2a:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c2f:	e9 84 fe ff ff       	jmp    80100ab8 <exec+0x1b9>
80100c34:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c39:	e9 7a fe ff ff       	jmp    80100ab8 <exec+0x1b9>
  return -1;
80100c3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c43:	e9 27 fd ff ff       	jmp    8010096f <exec+0x70>

80100c48 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c48:	55                   	push   %ebp
80100c49:	89 e5                	mov    %esp,%ebp
80100c4b:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c4e:	68 2d 6b 10 80       	push   $0x80106b2d
80100c53:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c58:	e8 ab 33 00 00       	call   80104008 <initlock>
}
80100c5d:	83 c4 10             	add    $0x10,%esp
80100c60:	c9                   	leave  
80100c61:	c3                   	ret    

80100c62 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c62:	55                   	push   %ebp
80100c63:	89 e5                	mov    %esp,%ebp
80100c65:	53                   	push   %ebx
80100c66:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c69:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c6e:	e8 d1 34 00 00       	call   80104144 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c73:	83 c4 10             	add    $0x10,%esp
80100c76:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100c7b:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100c81:	73 29                	jae    80100cac <filealloc+0x4a>
    if(f->ref == 0){
80100c83:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c87:	74 05                	je     80100c8e <filealloc+0x2c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c89:	83 c3 18             	add    $0x18,%ebx
80100c8c:	eb ed                	jmp    80100c7b <filealloc+0x19>
      f->ref = 1;
80100c8e:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c95:	83 ec 0c             	sub    $0xc,%esp
80100c98:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c9d:	e8 07 35 00 00       	call   801041a9 <release>
      return f;
80100ca2:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ca5:	89 d8                	mov    %ebx,%eax
80100ca7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100caa:	c9                   	leave  
80100cab:	c3                   	ret    
  release(&ftable.lock);
80100cac:	83 ec 0c             	sub    $0xc,%esp
80100caf:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cb4:	e8 f0 34 00 00       	call   801041a9 <release>
  return 0;
80100cb9:	83 c4 10             	add    $0x10,%esp
80100cbc:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cc1:	eb e2                	jmp    80100ca5 <filealloc+0x43>

80100cc3 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100cc3:	55                   	push   %ebp
80100cc4:	89 e5                	mov    %esp,%ebp
80100cc6:	53                   	push   %ebx
80100cc7:	83 ec 10             	sub    $0x10,%esp
80100cca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ccd:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cd2:	e8 6d 34 00 00       	call   80104144 <acquire>
  if(f->ref < 1)
80100cd7:	8b 43 04             	mov    0x4(%ebx),%eax
80100cda:	83 c4 10             	add    $0x10,%esp
80100cdd:	85 c0                	test   %eax,%eax
80100cdf:	7e 1a                	jle    80100cfb <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ce1:	83 c0 01             	add    $0x1,%eax
80100ce4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ce7:	83 ec 0c             	sub    $0xc,%esp
80100cea:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cef:	e8 b5 34 00 00       	call   801041a9 <release>
  return f;
}
80100cf4:	89 d8                	mov    %ebx,%eax
80100cf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf9:	c9                   	leave  
80100cfa:	c3                   	ret    
    panic("filedup");
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	68 34 6b 10 80       	push   $0x80106b34
80100d03:	e8 40 f6 ff ff       	call   80100348 <panic>

80100d08 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d08:	55                   	push   %ebp
80100d09:	89 e5                	mov    %esp,%ebp
80100d0b:	53                   	push   %ebx
80100d0c:	83 ec 30             	sub    $0x30,%esp
80100d0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d12:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d17:	e8 28 34 00 00       	call   80104144 <acquire>
  if(f->ref < 1)
80100d1c:	8b 43 04             	mov    0x4(%ebx),%eax
80100d1f:	83 c4 10             	add    $0x10,%esp
80100d22:	85 c0                	test   %eax,%eax
80100d24:	7e 1f                	jle    80100d45 <fileclose+0x3d>
    panic("fileclose");
  if(--f->ref > 0){
80100d26:	83 e8 01             	sub    $0x1,%eax
80100d29:	89 43 04             	mov    %eax,0x4(%ebx)
80100d2c:	85 c0                	test   %eax,%eax
80100d2e:	7e 22                	jle    80100d52 <fileclose+0x4a>
    release(&ftable.lock);
80100d30:	83 ec 0c             	sub    $0xc,%esp
80100d33:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d38:	e8 6c 34 00 00       	call   801041a9 <release>
    return;
80100d3d:	83 c4 10             	add    $0x10,%esp
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100d40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d43:	c9                   	leave  
80100d44:	c3                   	ret    
    panic("fileclose");
80100d45:	83 ec 0c             	sub    $0xc,%esp
80100d48:	68 3c 6b 10 80       	push   $0x80106b3c
80100d4d:	e8 f6 f5 ff ff       	call   80100348 <panic>
  ff = *f;
80100d52:	8b 03                	mov    (%ebx),%eax
80100d54:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d57:	8b 43 08             	mov    0x8(%ebx),%eax
80100d5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d5d:	8b 43 0c             	mov    0xc(%ebx),%eax
80100d60:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d63:	8b 43 10             	mov    0x10(%ebx),%eax
80100d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  f->ref = 0;
80100d69:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d70:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d76:	83 ec 0c             	sub    $0xc,%esp
80100d79:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d7e:	e8 26 34 00 00       	call   801041a9 <release>
  if(ff.type == FD_PIPE)
80100d83:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	83 f8 01             	cmp    $0x1,%eax
80100d8c:	74 1f                	je     80100dad <fileclose+0xa5>
  else if(ff.type == FD_INODE){
80100d8e:	83 f8 02             	cmp    $0x2,%eax
80100d91:	75 ad                	jne    80100d40 <fileclose+0x38>
    begin_op();
80100d93:	e8 39 1a 00 00       	call   801027d1 <begin_op>
    iput(ff.ip);
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	ff 75 f0             	pushl  -0x10(%ebp)
80100d9e:	e8 08 09 00 00       	call   801016ab <iput>
    end_op();
80100da3:	e8 a3 1a 00 00       	call   8010284b <end_op>
80100da8:	83 c4 10             	add    $0x10,%esp
80100dab:	eb 93                	jmp    80100d40 <fileclose+0x38>
    pipeclose(ff.pipe, ff.writable);
80100dad:	83 ec 08             	sub    $0x8,%esp
80100db0:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100db4:	50                   	push   %eax
80100db5:	ff 75 ec             	pushl  -0x14(%ebp)
80100db8:	e8 88 20 00 00       	call   80102e45 <pipeclose>
80100dbd:	83 c4 10             	add    $0x10,%esp
80100dc0:	e9 7b ff ff ff       	jmp    80100d40 <fileclose+0x38>

80100dc5 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100dc5:	55                   	push   %ebp
80100dc6:	89 e5                	mov    %esp,%ebp
80100dc8:	53                   	push   %ebx
80100dc9:	83 ec 04             	sub    $0x4,%esp
80100dcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100dcf:	83 3b 02             	cmpl   $0x2,(%ebx)
80100dd2:	75 31                	jne    80100e05 <filestat+0x40>
    ilock(f->ip);
80100dd4:	83 ec 0c             	sub    $0xc,%esp
80100dd7:	ff 73 10             	pushl  0x10(%ebx)
80100dda:	e8 c5 07 00 00       	call   801015a4 <ilock>
    stati(f->ip, st);
80100ddf:	83 c4 08             	add    $0x8,%esp
80100de2:	ff 75 0c             	pushl  0xc(%ebp)
80100de5:	ff 73 10             	pushl  0x10(%ebx)
80100de8:	e8 7e 09 00 00       	call   8010176b <stati>
    iunlock(f->ip);
80100ded:	83 c4 04             	add    $0x4,%esp
80100df0:	ff 73 10             	pushl  0x10(%ebx)
80100df3:	e8 6e 08 00 00       	call   80101666 <iunlock>
    return 0;
80100df8:	83 c4 10             	add    $0x10,%esp
80100dfb:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e00:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e03:	c9                   	leave  
80100e04:	c3                   	ret    
  return -1;
80100e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0a:	eb f4                	jmp    80100e00 <filestat+0x3b>

80100e0c <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e0c:	55                   	push   %ebp
80100e0d:	89 e5                	mov    %esp,%ebp
80100e0f:	56                   	push   %esi
80100e10:	53                   	push   %ebx
80100e11:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e14:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e18:	74 70                	je     80100e8a <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100e1a:	8b 03                	mov    (%ebx),%eax
80100e1c:	83 f8 01             	cmp    $0x1,%eax
80100e1f:	74 44                	je     80100e65 <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e21:	83 f8 02             	cmp    $0x2,%eax
80100e24:	75 57                	jne    80100e7d <fileread+0x71>
    ilock(f->ip);
80100e26:	83 ec 0c             	sub    $0xc,%esp
80100e29:	ff 73 10             	pushl  0x10(%ebx)
80100e2c:	e8 73 07 00 00       	call   801015a4 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e31:	ff 75 10             	pushl  0x10(%ebp)
80100e34:	ff 73 14             	pushl  0x14(%ebx)
80100e37:	ff 75 0c             	pushl  0xc(%ebp)
80100e3a:	ff 73 10             	pushl  0x10(%ebx)
80100e3d:	e8 54 09 00 00       	call   80101796 <readi>
80100e42:	89 c6                	mov    %eax,%esi
80100e44:	83 c4 20             	add    $0x20,%esp
80100e47:	85 c0                	test   %eax,%eax
80100e49:	7e 03                	jle    80100e4e <fileread+0x42>
      f->off += r;
80100e4b:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e4e:	83 ec 0c             	sub    $0xc,%esp
80100e51:	ff 73 10             	pushl  0x10(%ebx)
80100e54:	e8 0d 08 00 00       	call   80101666 <iunlock>
    return r;
80100e59:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e5c:	89 f0                	mov    %esi,%eax
80100e5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e61:	5b                   	pop    %ebx
80100e62:	5e                   	pop    %esi
80100e63:	5d                   	pop    %ebp
80100e64:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e65:	83 ec 04             	sub    $0x4,%esp
80100e68:	ff 75 10             	pushl  0x10(%ebp)
80100e6b:	ff 75 0c             	pushl  0xc(%ebp)
80100e6e:	ff 73 0c             	pushl  0xc(%ebx)
80100e71:	e8 27 21 00 00       	call   80102f9d <piperead>
80100e76:	89 c6                	mov    %eax,%esi
80100e78:	83 c4 10             	add    $0x10,%esp
80100e7b:	eb df                	jmp    80100e5c <fileread+0x50>
  panic("fileread");
80100e7d:	83 ec 0c             	sub    $0xc,%esp
80100e80:	68 46 6b 10 80       	push   $0x80106b46
80100e85:	e8 be f4 ff ff       	call   80100348 <panic>
    return -1;
80100e8a:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e8f:	eb cb                	jmp    80100e5c <fileread+0x50>

80100e91 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e91:	55                   	push   %ebp
80100e92:	89 e5                	mov    %esp,%ebp
80100e94:	57                   	push   %edi
80100e95:	56                   	push   %esi
80100e96:	53                   	push   %ebx
80100e97:	83 ec 1c             	sub    $0x1c,%esp
80100e9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->writable == 0)
80100e9d:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
80100ea1:	0f 84 c5 00 00 00    	je     80100f6c <filewrite+0xdb>
    return -1;
  if(f->type == FD_PIPE)
80100ea7:	8b 03                	mov    (%ebx),%eax
80100ea9:	83 f8 01             	cmp    $0x1,%eax
80100eac:	74 10                	je     80100ebe <filewrite+0x2d>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eae:	83 f8 02             	cmp    $0x2,%eax
80100eb1:	0f 85 a8 00 00 00    	jne    80100f5f <filewrite+0xce>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100eb7:	bf 00 00 00 00       	mov    $0x0,%edi
80100ebc:	eb 67                	jmp    80100f25 <filewrite+0x94>
    return pipewrite(f->pipe, addr, n);
80100ebe:	83 ec 04             	sub    $0x4,%esp
80100ec1:	ff 75 10             	pushl  0x10(%ebp)
80100ec4:	ff 75 0c             	pushl  0xc(%ebp)
80100ec7:	ff 73 0c             	pushl  0xc(%ebx)
80100eca:	e8 02 20 00 00       	call   80102ed1 <pipewrite>
80100ecf:	83 c4 10             	add    $0x10,%esp
80100ed2:	e9 80 00 00 00       	jmp    80100f57 <filewrite+0xc6>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100ed7:	e8 f5 18 00 00       	call   801027d1 <begin_op>
      ilock(f->ip);
80100edc:	83 ec 0c             	sub    $0xc,%esp
80100edf:	ff 73 10             	pushl  0x10(%ebx)
80100ee2:	e8 bd 06 00 00       	call   801015a4 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100ee7:	89 f8                	mov    %edi,%eax
80100ee9:	03 45 0c             	add    0xc(%ebp),%eax
80100eec:	ff 75 e4             	pushl  -0x1c(%ebp)
80100eef:	ff 73 14             	pushl  0x14(%ebx)
80100ef2:	50                   	push   %eax
80100ef3:	ff 73 10             	pushl  0x10(%ebx)
80100ef6:	e8 98 09 00 00       	call   80101893 <writei>
80100efb:	89 c6                	mov    %eax,%esi
80100efd:	83 c4 20             	add    $0x20,%esp
80100f00:	85 c0                	test   %eax,%eax
80100f02:	7e 03                	jle    80100f07 <filewrite+0x76>
        f->off += r;
80100f04:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
80100f07:	83 ec 0c             	sub    $0xc,%esp
80100f0a:	ff 73 10             	pushl  0x10(%ebx)
80100f0d:	e8 54 07 00 00       	call   80101666 <iunlock>
      end_op();
80100f12:	e8 34 19 00 00       	call   8010284b <end_op>

      if(r < 0)
80100f17:	83 c4 10             	add    $0x10,%esp
80100f1a:	85 f6                	test   %esi,%esi
80100f1c:	78 31                	js     80100f4f <filewrite+0xbe>
        break;
      if(r != n1)
80100f1e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
80100f21:	75 1f                	jne    80100f42 <filewrite+0xb1>
        panic("short filewrite");
      i += r;
80100f23:	01 f7                	add    %esi,%edi
    while(i < n){
80100f25:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f28:	7d 25                	jge    80100f4f <filewrite+0xbe>
      int n1 = n - i;
80100f2a:	8b 45 10             	mov    0x10(%ebp),%eax
80100f2d:	29 f8                	sub    %edi,%eax
80100f2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100f32:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f37:	7e 9e                	jle    80100ed7 <filewrite+0x46>
        n1 = max;
80100f39:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f40:	eb 95                	jmp    80100ed7 <filewrite+0x46>
        panic("short filewrite");
80100f42:	83 ec 0c             	sub    $0xc,%esp
80100f45:	68 4f 6b 10 80       	push   $0x80106b4f
80100f4a:	e8 f9 f3 ff ff       	call   80100348 <panic>
    }
    return i == n ? n : -1;
80100f4f:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f52:	75 1f                	jne    80100f73 <filewrite+0xe2>
80100f54:	8b 45 10             	mov    0x10(%ebp),%eax
  }
  panic("filewrite");
}
80100f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5a:	5b                   	pop    %ebx
80100f5b:	5e                   	pop    %esi
80100f5c:	5f                   	pop    %edi
80100f5d:	5d                   	pop    %ebp
80100f5e:	c3                   	ret    
  panic("filewrite");
80100f5f:	83 ec 0c             	sub    $0xc,%esp
80100f62:	68 55 6b 10 80       	push   $0x80106b55
80100f67:	e8 dc f3 ff ff       	call   80100348 <panic>
    return -1;
80100f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f71:	eb e4                	jmp    80100f57 <filewrite+0xc6>
    return i == n ? n : -1;
80100f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f78:	eb dd                	jmp    80100f57 <filewrite+0xc6>

80100f7a <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f7a:	55                   	push   %ebp
80100f7b:	89 e5                	mov    %esp,%ebp
80100f7d:	57                   	push   %edi
80100f7e:	56                   	push   %esi
80100f7f:	53                   	push   %ebx
80100f80:	83 ec 0c             	sub    $0xc,%esp
80100f83:	89 d7                	mov    %edx,%edi
  char *s;
  int len;

  while(*path == '/')
80100f85:	eb 03                	jmp    80100f8a <skipelem+0x10>
    path++;
80100f87:	83 c0 01             	add    $0x1,%eax
  while(*path == '/')
80100f8a:	0f b6 10             	movzbl (%eax),%edx
80100f8d:	80 fa 2f             	cmp    $0x2f,%dl
80100f90:	74 f5                	je     80100f87 <skipelem+0xd>
  if(*path == 0)
80100f92:	84 d2                	test   %dl,%dl
80100f94:	74 59                	je     80100fef <skipelem+0x75>
80100f96:	89 c3                	mov    %eax,%ebx
80100f98:	eb 03                	jmp    80100f9d <skipelem+0x23>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f9a:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80100f9d:	0f b6 13             	movzbl (%ebx),%edx
80100fa0:	80 fa 2f             	cmp    $0x2f,%dl
80100fa3:	0f 95 c1             	setne  %cl
80100fa6:	84 d2                	test   %dl,%dl
80100fa8:	0f 95 c2             	setne  %dl
80100fab:	84 d1                	test   %dl,%cl
80100fad:	75 eb                	jne    80100f9a <skipelem+0x20>
  len = path - s;
80100faf:	89 de                	mov    %ebx,%esi
80100fb1:	29 c6                	sub    %eax,%esi
  if(len >= DIRSIZ)
80100fb3:	83 fe 0d             	cmp    $0xd,%esi
80100fb6:	7e 11                	jle    80100fc9 <skipelem+0x4f>
    memmove(name, s, DIRSIZ);
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	6a 0e                	push   $0xe
80100fbd:	50                   	push   %eax
80100fbe:	57                   	push   %edi
80100fbf:	e8 a7 32 00 00       	call   8010426b <memmove>
80100fc4:	83 c4 10             	add    $0x10,%esp
80100fc7:	eb 17                	jmp    80100fe0 <skipelem+0x66>
  else {
    memmove(name, s, len);
80100fc9:	83 ec 04             	sub    $0x4,%esp
80100fcc:	56                   	push   %esi
80100fcd:	50                   	push   %eax
80100fce:	57                   	push   %edi
80100fcf:	e8 97 32 00 00       	call   8010426b <memmove>
    name[len] = 0;
80100fd4:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
80100fd8:	83 c4 10             	add    $0x10,%esp
80100fdb:	eb 03                	jmp    80100fe0 <skipelem+0x66>
  }
  while(*path == '/')
    path++;
80100fdd:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80100fe0:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100fe3:	74 f8                	je     80100fdd <skipelem+0x63>
  return path;
}
80100fe5:	89 d8                	mov    %ebx,%eax
80100fe7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fea:	5b                   	pop    %ebx
80100feb:	5e                   	pop    %esi
80100fec:	5f                   	pop    %edi
80100fed:	5d                   	pop    %ebp
80100fee:	c3                   	ret    
    return 0;
80100fef:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ff4:	eb ef                	jmp    80100fe5 <skipelem+0x6b>

80100ff6 <bzero>:
{
80100ff6:	55                   	push   %ebp
80100ff7:	89 e5                	mov    %esp,%ebp
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100ffd:	52                   	push   %edx
80100ffe:	50                   	push   %eax
80100fff:	e8 68 f1 ff ff       	call   8010016c <bread>
80101004:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101006:	8d 40 5c             	lea    0x5c(%eax),%eax
80101009:	83 c4 0c             	add    $0xc,%esp
8010100c:	68 00 02 00 00       	push   $0x200
80101011:	6a 00                	push   $0x0
80101013:	50                   	push   %eax
80101014:	e8 d7 31 00 00       	call   801041f0 <memset>
  log_write(bp);
80101019:	89 1c 24             	mov    %ebx,(%esp)
8010101c:	e8 d9 18 00 00       	call   801028fa <log_write>
  brelse(bp);
80101021:	89 1c 24             	mov    %ebx,(%esp)
80101024:	e8 ac f1 ff ff       	call   801001d5 <brelse>
}
80101029:	83 c4 10             	add    $0x10,%esp
8010102c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010102f:	c9                   	leave  
80101030:	c3                   	ret    

80101031 <bfree>:
{
80101031:	55                   	push   %ebp
80101032:	89 e5                	mov    %esp,%ebp
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101038:	c1 ea 0c             	shr    $0xc,%edx
8010103b:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101041:	83 ec 08             	sub    $0x8,%esp
80101044:	52                   	push   %edx
80101045:	50                   	push   %eax
80101046:	e8 21 f1 ff ff       	call   8010016c <bread>
8010104b:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
8010104d:	89 d9                	mov    %ebx,%ecx
8010104f:	83 e1 07             	and    $0x7,%ecx
80101052:	b8 01 00 00 00       	mov    $0x1,%eax
80101057:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101059:	83 c4 10             	add    $0x10,%esp
8010105c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80101062:	c1 fb 03             	sar    $0x3,%ebx
80101065:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
8010106a:	0f b6 ca             	movzbl %dl,%ecx
8010106d:	85 c1                	test   %eax,%ecx
8010106f:	74 23                	je     80101094 <bfree+0x63>
  bp->data[bi/8] &= ~m;
80101071:	f7 d0                	not    %eax
80101073:	21 d0                	and    %edx,%eax
80101075:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
80101079:	83 ec 0c             	sub    $0xc,%esp
8010107c:	56                   	push   %esi
8010107d:	e8 78 18 00 00       	call   801028fa <log_write>
  brelse(bp);
80101082:	89 34 24             	mov    %esi,(%esp)
80101085:	e8 4b f1 ff ff       	call   801001d5 <brelse>
}
8010108a:	83 c4 10             	add    $0x10,%esp
8010108d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101090:	5b                   	pop    %ebx
80101091:	5e                   	pop    %esi
80101092:	5d                   	pop    %ebp
80101093:	c3                   	ret    
    panic("freeing free block");
80101094:	83 ec 0c             	sub    $0xc,%esp
80101097:	68 5f 6b 10 80       	push   $0x80106b5f
8010109c:	e8 a7 f2 ff ff       	call   80100348 <panic>

801010a1 <balloc>:
{
801010a1:	55                   	push   %ebp
801010a2:	89 e5                	mov    %esp,%ebp
801010a4:	57                   	push   %edi
801010a5:	56                   	push   %esi
801010a6:	53                   	push   %ebx
801010a7:	83 ec 1c             	sub    $0x1c,%esp
801010aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010ad:	be 00 00 00 00       	mov    $0x0,%esi
801010b2:	eb 14                	jmp    801010c8 <balloc+0x27>
    brelse(bp);
801010b4:	83 ec 0c             	sub    $0xc,%esp
801010b7:	ff 75 e4             	pushl  -0x1c(%ebp)
801010ba:	e8 16 f1 ff ff       	call   801001d5 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010bf:	81 c6 00 10 00 00    	add    $0x1000,%esi
801010c5:	83 c4 10             	add    $0x10,%esp
801010c8:	39 35 c0 09 11 80    	cmp    %esi,0x801109c0
801010ce:	76 75                	jbe    80101145 <balloc+0xa4>
    bp = bread(dev, BBLOCK(b, sb));
801010d0:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
801010d6:	85 f6                	test   %esi,%esi
801010d8:	0f 49 c6             	cmovns %esi,%eax
801010db:	c1 f8 0c             	sar    $0xc,%eax
801010de:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801010e4:	83 ec 08             	sub    $0x8,%esp
801010e7:	50                   	push   %eax
801010e8:	ff 75 d8             	pushl  -0x28(%ebp)
801010eb:	e8 7c f0 ff ff       	call   8010016c <bread>
801010f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010f3:	83 c4 10             	add    $0x10,%esp
801010f6:	b8 00 00 00 00       	mov    $0x0,%eax
801010fb:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80101100:	7f b2                	jg     801010b4 <balloc+0x13>
80101102:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80101105:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80101108:	3b 1d c0 09 11 80    	cmp    0x801109c0,%ebx
8010110e:	73 a4                	jae    801010b4 <balloc+0x13>
      m = 1 << (bi % 8);
80101110:	99                   	cltd   
80101111:	c1 ea 1d             	shr    $0x1d,%edx
80101114:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80101117:	83 e1 07             	and    $0x7,%ecx
8010111a:	29 d1                	sub    %edx,%ecx
8010111c:	ba 01 00 00 00       	mov    $0x1,%edx
80101121:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101123:	8d 48 07             	lea    0x7(%eax),%ecx
80101126:	85 c0                	test   %eax,%eax
80101128:	0f 49 c8             	cmovns %eax,%ecx
8010112b:	c1 f9 03             	sar    $0x3,%ecx
8010112e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101131:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101134:	0f b6 4c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%ecx
80101139:	0f b6 f9             	movzbl %cl,%edi
8010113c:	85 d7                	test   %edx,%edi
8010113e:	74 12                	je     80101152 <balloc+0xb1>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101140:	83 c0 01             	add    $0x1,%eax
80101143:	eb b6                	jmp    801010fb <balloc+0x5a>
  panic("balloc: out of blocks");
80101145:	83 ec 0c             	sub    $0xc,%esp
80101148:	68 72 6b 10 80       	push   $0x80106b72
8010114d:	e8 f6 f1 ff ff       	call   80100348 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
80101152:	09 ca                	or     %ecx,%edx
80101154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101157:	8b 75 dc             	mov    -0x24(%ebp),%esi
8010115a:	88 54 30 5c          	mov    %dl,0x5c(%eax,%esi,1)
        log_write(bp);
8010115e:	83 ec 0c             	sub    $0xc,%esp
80101161:	89 c6                	mov    %eax,%esi
80101163:	50                   	push   %eax
80101164:	e8 91 17 00 00       	call   801028fa <log_write>
        brelse(bp);
80101169:	89 34 24             	mov    %esi,(%esp)
8010116c:	e8 64 f0 ff ff       	call   801001d5 <brelse>
        bzero(dev, b + bi);
80101171:	89 da                	mov    %ebx,%edx
80101173:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101176:	e8 7b fe ff ff       	call   80100ff6 <bzero>
}
8010117b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010117e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101181:	5b                   	pop    %ebx
80101182:	5e                   	pop    %esi
80101183:	5f                   	pop    %edi
80101184:	5d                   	pop    %ebp
80101185:	c3                   	ret    

80101186 <bmap>:
{
80101186:	55                   	push   %ebp
80101187:	89 e5                	mov    %esp,%ebp
80101189:	57                   	push   %edi
8010118a:	56                   	push   %esi
8010118b:	53                   	push   %ebx
8010118c:	83 ec 1c             	sub    $0x1c,%esp
8010118f:	89 c6                	mov    %eax,%esi
80101191:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
80101193:	83 fa 0b             	cmp    $0xb,%edx
80101196:	77 17                	ja     801011af <bmap+0x29>
    if((addr = ip->addrs[bn]) == 0)
80101198:	8b 5c 90 5c          	mov    0x5c(%eax,%edx,4),%ebx
8010119c:	85 db                	test   %ebx,%ebx
8010119e:	75 4a                	jne    801011ea <bmap+0x64>
      ip->addrs[bn] = addr = balloc(ip->dev);
801011a0:	8b 00                	mov    (%eax),%eax
801011a2:	e8 fa fe ff ff       	call   801010a1 <balloc>
801011a7:	89 c3                	mov    %eax,%ebx
801011a9:	89 44 be 5c          	mov    %eax,0x5c(%esi,%edi,4)
801011ad:	eb 3b                	jmp    801011ea <bmap+0x64>
  bn -= NDIRECT;
801011af:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801011b2:	83 fb 7f             	cmp    $0x7f,%ebx
801011b5:	77 68                	ja     8010121f <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
801011b7:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801011bd:	85 c0                	test   %eax,%eax
801011bf:	74 33                	je     801011f4 <bmap+0x6e>
    bp = bread(ip->dev, addr);
801011c1:	83 ec 08             	sub    $0x8,%esp
801011c4:	50                   	push   %eax
801011c5:	ff 36                	pushl  (%esi)
801011c7:	e8 a0 ef ff ff       	call   8010016c <bread>
801011cc:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801011ce:	8d 44 98 5c          	lea    0x5c(%eax,%ebx,4),%eax
801011d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011d5:	8b 18                	mov    (%eax),%ebx
801011d7:	83 c4 10             	add    $0x10,%esp
801011da:	85 db                	test   %ebx,%ebx
801011dc:	74 25                	je     80101203 <bmap+0x7d>
    brelse(bp);
801011de:	83 ec 0c             	sub    $0xc,%esp
801011e1:	57                   	push   %edi
801011e2:	e8 ee ef ff ff       	call   801001d5 <brelse>
    return addr;
801011e7:	83 c4 10             	add    $0x10,%esp
}
801011ea:	89 d8                	mov    %ebx,%eax
801011ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ef:	5b                   	pop    %ebx
801011f0:	5e                   	pop    %esi
801011f1:	5f                   	pop    %edi
801011f2:	5d                   	pop    %ebp
801011f3:	c3                   	ret    
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801011f4:	8b 06                	mov    (%esi),%eax
801011f6:	e8 a6 fe ff ff       	call   801010a1 <balloc>
801011fb:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101201:	eb be                	jmp    801011c1 <bmap+0x3b>
      a[bn] = addr = balloc(ip->dev);
80101203:	8b 06                	mov    (%esi),%eax
80101205:	e8 97 fe ff ff       	call   801010a1 <balloc>
8010120a:	89 c3                	mov    %eax,%ebx
8010120c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010120f:	89 18                	mov    %ebx,(%eax)
      log_write(bp);
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	57                   	push   %edi
80101215:	e8 e0 16 00 00       	call   801028fa <log_write>
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	eb bf                	jmp    801011de <bmap+0x58>
  panic("bmap: out of range");
8010121f:	83 ec 0c             	sub    $0xc,%esp
80101222:	68 88 6b 10 80       	push   $0x80106b88
80101227:	e8 1c f1 ff ff       	call   80100348 <panic>

8010122c <iget>:
{
8010122c:	55                   	push   %ebp
8010122d:	89 e5                	mov    %esp,%ebp
8010122f:	57                   	push   %edi
80101230:	56                   	push   %esi
80101231:	53                   	push   %ebx
80101232:	83 ec 28             	sub    $0x28,%esp
80101235:	89 c7                	mov    %eax,%edi
80101237:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010123a:	68 e0 09 11 80       	push   $0x801109e0
8010123f:	e8 00 2f 00 00       	call   80104144 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101247:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124c:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
80101251:	eb 0a                	jmp    8010125d <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101253:	85 f6                	test   %esi,%esi
80101255:	74 3b                	je     80101292 <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101257:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010125d:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101263:	73 35                	jae    8010129a <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101265:	8b 43 08             	mov    0x8(%ebx),%eax
80101268:	85 c0                	test   %eax,%eax
8010126a:	7e e7                	jle    80101253 <iget+0x27>
8010126c:	39 3b                	cmp    %edi,(%ebx)
8010126e:	75 e3                	jne    80101253 <iget+0x27>
80101270:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101273:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101276:	75 db                	jne    80101253 <iget+0x27>
      ip->ref++;
80101278:	83 c0 01             	add    $0x1,%eax
8010127b:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
8010127e:	83 ec 0c             	sub    $0xc,%esp
80101281:	68 e0 09 11 80       	push   $0x801109e0
80101286:	e8 1e 2f 00 00       	call   801041a9 <release>
      return ip;
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 de                	mov    %ebx,%esi
80101290:	eb 32                	jmp    801012c4 <iget+0x98>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101292:	85 c0                	test   %eax,%eax
80101294:	75 c1                	jne    80101257 <iget+0x2b>
      empty = ip;
80101296:	89 de                	mov    %ebx,%esi
80101298:	eb bd                	jmp    80101257 <iget+0x2b>
  if(empty == 0)
8010129a:	85 f6                	test   %esi,%esi
8010129c:	74 30                	je     801012ce <iget+0xa2>
  ip->dev = dev;
8010129e:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012a3:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801012a6:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012ad:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012b4:	83 ec 0c             	sub    $0xc,%esp
801012b7:	68 e0 09 11 80       	push   $0x801109e0
801012bc:	e8 e8 2e 00 00       	call   801041a9 <release>
  return ip;
801012c1:	83 c4 10             	add    $0x10,%esp
}
801012c4:	89 f0                	mov    %esi,%eax
801012c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c9:	5b                   	pop    %ebx
801012ca:	5e                   	pop    %esi
801012cb:	5f                   	pop    %edi
801012cc:	5d                   	pop    %ebp
801012cd:	c3                   	ret    
    panic("iget: no inodes");
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	68 9b 6b 10 80       	push   $0x80106b9b
801012d6:	e8 6d f0 ff ff       	call   80100348 <panic>

801012db <readsb>:
{
801012db:	55                   	push   %ebp
801012dc:	89 e5                	mov    %esp,%ebp
801012de:	53                   	push   %ebx
801012df:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012e2:	6a 01                	push   $0x1
801012e4:	ff 75 08             	pushl  0x8(%ebp)
801012e7:	e8 80 ee ff ff       	call   8010016c <bread>
801012ec:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801012ee:	8d 40 5c             	lea    0x5c(%eax),%eax
801012f1:	83 c4 0c             	add    $0xc,%esp
801012f4:	6a 1c                	push   $0x1c
801012f6:	50                   	push   %eax
801012f7:	ff 75 0c             	pushl  0xc(%ebp)
801012fa:	e8 6c 2f 00 00       	call   8010426b <memmove>
  brelse(bp);
801012ff:	89 1c 24             	mov    %ebx,(%esp)
80101302:	e8 ce ee ff ff       	call   801001d5 <brelse>
}
80101307:	83 c4 10             	add    $0x10,%esp
8010130a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010130d:	c9                   	leave  
8010130e:	c3                   	ret    

8010130f <iinit>:
{
8010130f:	55                   	push   %ebp
80101310:	89 e5                	mov    %esp,%ebp
80101312:	53                   	push   %ebx
80101313:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101316:	68 ab 6b 10 80       	push   $0x80106bab
8010131b:	68 e0 09 11 80       	push   $0x801109e0
80101320:	e8 e3 2c 00 00       	call   80104008 <initlock>
  for(i = 0; i < NINODE; i++) {
80101325:	83 c4 10             	add    $0x10,%esp
80101328:	bb 00 00 00 00       	mov    $0x0,%ebx
8010132d:	eb 21                	jmp    80101350 <iinit+0x41>
    initsleeplock(&icache.inode[i].lock, "inode");
8010132f:	83 ec 08             	sub    $0x8,%esp
80101332:	68 b2 6b 10 80       	push   $0x80106bb2
80101337:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
8010133a:	89 d0                	mov    %edx,%eax
8010133c:	c1 e0 04             	shl    $0x4,%eax
8010133f:	05 20 0a 11 80       	add    $0x80110a20,%eax
80101344:	50                   	push   %eax
80101345:	e8 b3 2b 00 00       	call   80103efd <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010134a:	83 c3 01             	add    $0x1,%ebx
8010134d:	83 c4 10             	add    $0x10,%esp
80101350:	83 fb 31             	cmp    $0x31,%ebx
80101353:	7e da                	jle    8010132f <iinit+0x20>
  readsb(dev, &sb);
80101355:	83 ec 08             	sub    $0x8,%esp
80101358:	68 c0 09 11 80       	push   $0x801109c0
8010135d:	ff 75 08             	pushl  0x8(%ebp)
80101360:	e8 76 ff ff ff       	call   801012db <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101365:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010136b:	ff 35 d4 09 11 80    	pushl  0x801109d4
80101371:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101377:	ff 35 cc 09 11 80    	pushl  0x801109cc
8010137d:	ff 35 c8 09 11 80    	pushl  0x801109c8
80101383:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101389:	ff 35 c0 09 11 80    	pushl  0x801109c0
8010138f:	68 18 6c 10 80       	push   $0x80106c18
80101394:	e8 72 f2 ff ff       	call   8010060b <cprintf>
}
80101399:	83 c4 30             	add    $0x30,%esp
8010139c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010139f:	c9                   	leave  
801013a0:	c3                   	ret    

801013a1 <ialloc>:
{
801013a1:	55                   	push   %ebp
801013a2:	89 e5                	mov    %esp,%ebp
801013a4:	57                   	push   %edi
801013a5:	56                   	push   %esi
801013a6:	53                   	push   %ebx
801013a7:	83 ec 1c             	sub    $0x1c,%esp
801013aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801013ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013b0:	bb 01 00 00 00       	mov    $0x1,%ebx
801013b5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801013b8:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801013be:	76 3f                	jbe    801013ff <ialloc+0x5e>
    bp = bread(dev, IBLOCK(inum, sb));
801013c0:	89 d8                	mov    %ebx,%eax
801013c2:	c1 e8 03             	shr    $0x3,%eax
801013c5:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801013cb:	83 ec 08             	sub    $0x8,%esp
801013ce:	50                   	push   %eax
801013cf:	ff 75 08             	pushl  0x8(%ebp)
801013d2:	e8 95 ed ff ff       	call   8010016c <bread>
801013d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013d9:	89 d8                	mov    %ebx,%eax
801013db:	83 e0 07             	and    $0x7,%eax
801013de:	c1 e0 06             	shl    $0x6,%eax
801013e1:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013e5:	83 c4 10             	add    $0x10,%esp
801013e8:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013ec:	74 1e                	je     8010140c <ialloc+0x6b>
    brelse(bp);
801013ee:	83 ec 0c             	sub    $0xc,%esp
801013f1:	56                   	push   %esi
801013f2:	e8 de ed ff ff       	call   801001d5 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013f7:	83 c3 01             	add    $0x1,%ebx
801013fa:	83 c4 10             	add    $0x10,%esp
801013fd:	eb b6                	jmp    801013b5 <ialloc+0x14>
  panic("ialloc: no inodes");
801013ff:	83 ec 0c             	sub    $0xc,%esp
80101402:	68 b8 6b 10 80       	push   $0x80106bb8
80101407:	e8 3c ef ff ff       	call   80100348 <panic>
      memset(dip, 0, sizeof(*dip));
8010140c:	83 ec 04             	sub    $0x4,%esp
8010140f:	6a 40                	push   $0x40
80101411:	6a 00                	push   $0x0
80101413:	57                   	push   %edi
80101414:	e8 d7 2d 00 00       	call   801041f0 <memset>
      dip->type = type;
80101419:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010141d:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101420:	89 34 24             	mov    %esi,(%esp)
80101423:	e8 d2 14 00 00       	call   801028fa <log_write>
      brelse(bp);
80101428:	89 34 24             	mov    %esi,(%esp)
8010142b:	e8 a5 ed ff ff       	call   801001d5 <brelse>
      return iget(dev, inum);
80101430:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101433:	8b 45 08             	mov    0x8(%ebp),%eax
80101436:	e8 f1 fd ff ff       	call   8010122c <iget>
}
8010143b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010143e:	5b                   	pop    %ebx
8010143f:	5e                   	pop    %esi
80101440:	5f                   	pop    %edi
80101441:	5d                   	pop    %ebp
80101442:	c3                   	ret    

80101443 <iupdate>:
{
80101443:	55                   	push   %ebp
80101444:	89 e5                	mov    %esp,%ebp
80101446:	56                   	push   %esi
80101447:	53                   	push   %ebx
80101448:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010144b:	8b 43 04             	mov    0x4(%ebx),%eax
8010144e:	c1 e8 03             	shr    $0x3,%eax
80101451:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101457:	83 ec 08             	sub    $0x8,%esp
8010145a:	50                   	push   %eax
8010145b:	ff 33                	pushl  (%ebx)
8010145d:	e8 0a ed ff ff       	call   8010016c <bread>
80101462:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101464:	8b 43 04             	mov    0x4(%ebx),%eax
80101467:	83 e0 07             	and    $0x7,%eax
8010146a:	c1 e0 06             	shl    $0x6,%eax
8010146d:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101471:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101475:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101478:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
8010147c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101480:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
80101484:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101488:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
8010148c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101490:	8b 53 58             	mov    0x58(%ebx),%edx
80101493:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101496:	83 c3 5c             	add    $0x5c,%ebx
80101499:	83 c0 0c             	add    $0xc,%eax
8010149c:	83 c4 0c             	add    $0xc,%esp
8010149f:	6a 34                	push   $0x34
801014a1:	53                   	push   %ebx
801014a2:	50                   	push   %eax
801014a3:	e8 c3 2d 00 00       	call   8010426b <memmove>
  log_write(bp);
801014a8:	89 34 24             	mov    %esi,(%esp)
801014ab:	e8 4a 14 00 00       	call   801028fa <log_write>
  brelse(bp);
801014b0:	89 34 24             	mov    %esi,(%esp)
801014b3:	e8 1d ed ff ff       	call   801001d5 <brelse>
}
801014b8:	83 c4 10             	add    $0x10,%esp
801014bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014be:	5b                   	pop    %ebx
801014bf:	5e                   	pop    %esi
801014c0:	5d                   	pop    %ebp
801014c1:	c3                   	ret    

801014c2 <itrunc>:
{
801014c2:	55                   	push   %ebp
801014c3:	89 e5                	mov    %esp,%ebp
801014c5:	57                   	push   %edi
801014c6:	56                   	push   %esi
801014c7:	53                   	push   %ebx
801014c8:	83 ec 1c             	sub    $0x1c,%esp
801014cb:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014cd:	bb 00 00 00 00       	mov    $0x0,%ebx
801014d2:	eb 03                	jmp    801014d7 <itrunc+0x15>
801014d4:	83 c3 01             	add    $0x1,%ebx
801014d7:	83 fb 0b             	cmp    $0xb,%ebx
801014da:	7f 19                	jg     801014f5 <itrunc+0x33>
    if(ip->addrs[i]){
801014dc:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801014e0:	85 d2                	test   %edx,%edx
801014e2:	74 f0                	je     801014d4 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801014e4:	8b 06                	mov    (%esi),%eax
801014e6:	e8 46 fb ff ff       	call   80101031 <bfree>
      ip->addrs[i] = 0;
801014eb:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
801014f2:	00 
801014f3:	eb df                	jmp    801014d4 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
801014f5:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801014fb:	85 c0                	test   %eax,%eax
801014fd:	75 1b                	jne    8010151a <itrunc+0x58>
  ip->size = 0;
801014ff:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101506:	83 ec 0c             	sub    $0xc,%esp
80101509:	56                   	push   %esi
8010150a:	e8 34 ff ff ff       	call   80101443 <iupdate>
}
8010150f:	83 c4 10             	add    $0x10,%esp
80101512:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101515:	5b                   	pop    %ebx
80101516:	5e                   	pop    %esi
80101517:	5f                   	pop    %edi
80101518:	5d                   	pop    %ebp
80101519:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010151a:	83 ec 08             	sub    $0x8,%esp
8010151d:	50                   	push   %eax
8010151e:	ff 36                	pushl  (%esi)
80101520:	e8 47 ec ff ff       	call   8010016c <bread>
80101525:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101528:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010152b:	83 c4 10             	add    $0x10,%esp
8010152e:	bb 00 00 00 00       	mov    $0x0,%ebx
80101533:	eb 03                	jmp    80101538 <itrunc+0x76>
80101535:	83 c3 01             	add    $0x1,%ebx
80101538:	83 fb 7f             	cmp    $0x7f,%ebx
8010153b:	77 10                	ja     8010154d <itrunc+0x8b>
      if(a[j])
8010153d:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101540:	85 d2                	test   %edx,%edx
80101542:	74 f1                	je     80101535 <itrunc+0x73>
        bfree(ip->dev, a[j]);
80101544:	8b 06                	mov    (%esi),%eax
80101546:	e8 e6 fa ff ff       	call   80101031 <bfree>
8010154b:	eb e8                	jmp    80101535 <itrunc+0x73>
    brelse(bp);
8010154d:	83 ec 0c             	sub    $0xc,%esp
80101550:	ff 75 e4             	pushl  -0x1c(%ebp)
80101553:	e8 7d ec ff ff       	call   801001d5 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101558:	8b 06                	mov    (%esi),%eax
8010155a:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101560:	e8 cc fa ff ff       	call   80101031 <bfree>
    ip->addrs[NDIRECT] = 0;
80101565:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010156c:	00 00 00 
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	eb 8b                	jmp    801014ff <itrunc+0x3d>

80101574 <idup>:
{
80101574:	55                   	push   %ebp
80101575:	89 e5                	mov    %esp,%ebp
80101577:	53                   	push   %ebx
80101578:	83 ec 10             	sub    $0x10,%esp
8010157b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010157e:	68 e0 09 11 80       	push   $0x801109e0
80101583:	e8 bc 2b 00 00       	call   80104144 <acquire>
  ip->ref++;
80101588:	8b 43 08             	mov    0x8(%ebx),%eax
8010158b:	83 c0 01             	add    $0x1,%eax
8010158e:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101591:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101598:	e8 0c 2c 00 00       	call   801041a9 <release>
}
8010159d:	89 d8                	mov    %ebx,%eax
8010159f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015a2:	c9                   	leave  
801015a3:	c3                   	ret    

801015a4 <ilock>:
{
801015a4:	55                   	push   %ebp
801015a5:	89 e5                	mov    %esp,%ebp
801015a7:	56                   	push   %esi
801015a8:	53                   	push   %ebx
801015a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801015ac:	85 db                	test   %ebx,%ebx
801015ae:	74 22                	je     801015d2 <ilock+0x2e>
801015b0:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015b4:	7e 1c                	jle    801015d2 <ilock+0x2e>
  acquiresleep(&ip->lock);
801015b6:	83 ec 0c             	sub    $0xc,%esp
801015b9:	8d 43 0c             	lea    0xc(%ebx),%eax
801015bc:	50                   	push   %eax
801015bd:	e8 6e 29 00 00       	call   80103f30 <acquiresleep>
  if(ip->valid == 0){
801015c2:	83 c4 10             	add    $0x10,%esp
801015c5:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015c9:	74 14                	je     801015df <ilock+0x3b>
}
801015cb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ce:	5b                   	pop    %ebx
801015cf:	5e                   	pop    %esi
801015d0:	5d                   	pop    %ebp
801015d1:	c3                   	ret    
    panic("ilock");
801015d2:	83 ec 0c             	sub    $0xc,%esp
801015d5:	68 ca 6b 10 80       	push   $0x80106bca
801015da:	e8 69 ed ff ff       	call   80100348 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015df:	8b 43 04             	mov    0x4(%ebx),%eax
801015e2:	c1 e8 03             	shr    $0x3,%eax
801015e5:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015eb:	83 ec 08             	sub    $0x8,%esp
801015ee:	50                   	push   %eax
801015ef:	ff 33                	pushl  (%ebx)
801015f1:	e8 76 eb ff ff       	call   8010016c <bread>
801015f6:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015f8:	8b 43 04             	mov    0x4(%ebx),%eax
801015fb:	83 e0 07             	and    $0x7,%eax
801015fe:	c1 e0 06             	shl    $0x6,%eax
80101601:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101605:	0f b7 10             	movzwl (%eax),%edx
80101608:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010160c:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101610:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101614:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101618:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
8010161c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101620:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101624:	8b 50 08             	mov    0x8(%eax),%edx
80101627:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010162a:	83 c0 0c             	add    $0xc,%eax
8010162d:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101630:	83 c4 0c             	add    $0xc,%esp
80101633:	6a 34                	push   $0x34
80101635:	50                   	push   %eax
80101636:	52                   	push   %edx
80101637:	e8 2f 2c 00 00       	call   8010426b <memmove>
    brelse(bp);
8010163c:	89 34 24             	mov    %esi,(%esp)
8010163f:	e8 91 eb ff ff       	call   801001d5 <brelse>
    ip->valid = 1;
80101644:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010164b:	83 c4 10             	add    $0x10,%esp
8010164e:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101653:	0f 85 72 ff ff ff    	jne    801015cb <ilock+0x27>
      panic("ilock: no type");
80101659:	83 ec 0c             	sub    $0xc,%esp
8010165c:	68 d0 6b 10 80       	push   $0x80106bd0
80101661:	e8 e2 ec ff ff       	call   80100348 <panic>

80101666 <iunlock>:
{
80101666:	55                   	push   %ebp
80101667:	89 e5                	mov    %esp,%ebp
80101669:	56                   	push   %esi
8010166a:	53                   	push   %ebx
8010166b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010166e:	85 db                	test   %ebx,%ebx
80101670:	74 2c                	je     8010169e <iunlock+0x38>
80101672:	8d 73 0c             	lea    0xc(%ebx),%esi
80101675:	83 ec 0c             	sub    $0xc,%esp
80101678:	56                   	push   %esi
80101679:	e8 3c 29 00 00       	call   80103fba <holdingsleep>
8010167e:	83 c4 10             	add    $0x10,%esp
80101681:	85 c0                	test   %eax,%eax
80101683:	74 19                	je     8010169e <iunlock+0x38>
80101685:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101689:	7e 13                	jle    8010169e <iunlock+0x38>
  releasesleep(&ip->lock);
8010168b:	83 ec 0c             	sub    $0xc,%esp
8010168e:	56                   	push   %esi
8010168f:	e8 eb 28 00 00       	call   80103f7f <releasesleep>
}
80101694:	83 c4 10             	add    $0x10,%esp
80101697:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010169a:	5b                   	pop    %ebx
8010169b:	5e                   	pop    %esi
8010169c:	5d                   	pop    %ebp
8010169d:	c3                   	ret    
    panic("iunlock");
8010169e:	83 ec 0c             	sub    $0xc,%esp
801016a1:	68 df 6b 10 80       	push   $0x80106bdf
801016a6:	e8 9d ec ff ff       	call   80100348 <panic>

801016ab <iput>:
{
801016ab:	55                   	push   %ebp
801016ac:	89 e5                	mov    %esp,%ebp
801016ae:	57                   	push   %edi
801016af:	56                   	push   %esi
801016b0:	53                   	push   %ebx
801016b1:	83 ec 18             	sub    $0x18,%esp
801016b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016b7:	8d 73 0c             	lea    0xc(%ebx),%esi
801016ba:	56                   	push   %esi
801016bb:	e8 70 28 00 00       	call   80103f30 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016c0:	83 c4 10             	add    $0x10,%esp
801016c3:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016c7:	74 07                	je     801016d0 <iput+0x25>
801016c9:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801016ce:	74 35                	je     80101705 <iput+0x5a>
  releasesleep(&ip->lock);
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	56                   	push   %esi
801016d4:	e8 a6 28 00 00       	call   80103f7f <releasesleep>
  acquire(&icache.lock);
801016d9:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016e0:	e8 5f 2a 00 00       	call   80104144 <acquire>
  ip->ref--;
801016e5:	8b 43 08             	mov    0x8(%ebx),%eax
801016e8:	83 e8 01             	sub    $0x1,%eax
801016eb:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801016ee:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016f5:	e8 af 2a 00 00       	call   801041a9 <release>
}
801016fa:	83 c4 10             	add    $0x10,%esp
801016fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101700:	5b                   	pop    %ebx
80101701:	5e                   	pop    %esi
80101702:	5f                   	pop    %edi
80101703:	5d                   	pop    %ebp
80101704:	c3                   	ret    
    acquire(&icache.lock);
80101705:	83 ec 0c             	sub    $0xc,%esp
80101708:	68 e0 09 11 80       	push   $0x801109e0
8010170d:	e8 32 2a 00 00       	call   80104144 <acquire>
    int r = ip->ref;
80101712:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101715:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010171c:	e8 88 2a 00 00       	call   801041a9 <release>
    if(r == 1){
80101721:	83 c4 10             	add    $0x10,%esp
80101724:	83 ff 01             	cmp    $0x1,%edi
80101727:	75 a7                	jne    801016d0 <iput+0x25>
      itrunc(ip);
80101729:	89 d8                	mov    %ebx,%eax
8010172b:	e8 92 fd ff ff       	call   801014c2 <itrunc>
      ip->type = 0;
80101730:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101736:	83 ec 0c             	sub    $0xc,%esp
80101739:	53                   	push   %ebx
8010173a:	e8 04 fd ff ff       	call   80101443 <iupdate>
      ip->valid = 0;
8010173f:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101746:	83 c4 10             	add    $0x10,%esp
80101749:	eb 85                	jmp    801016d0 <iput+0x25>

8010174b <iunlockput>:
{
8010174b:	55                   	push   %ebp
8010174c:	89 e5                	mov    %esp,%ebp
8010174e:	53                   	push   %ebx
8010174f:	83 ec 10             	sub    $0x10,%esp
80101752:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101755:	53                   	push   %ebx
80101756:	e8 0b ff ff ff       	call   80101666 <iunlock>
  iput(ip);
8010175b:	89 1c 24             	mov    %ebx,(%esp)
8010175e:	e8 48 ff ff ff       	call   801016ab <iput>
}
80101763:	83 c4 10             	add    $0x10,%esp
80101766:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101769:	c9                   	leave  
8010176a:	c3                   	ret    

8010176b <stati>:
{
8010176b:	55                   	push   %ebp
8010176c:	89 e5                	mov    %esp,%ebp
8010176e:	8b 55 08             	mov    0x8(%ebp),%edx
80101771:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101774:	8b 0a                	mov    (%edx),%ecx
80101776:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101779:	8b 4a 04             	mov    0x4(%edx),%ecx
8010177c:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
8010177f:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101783:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101786:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010178a:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
8010178e:	8b 52 58             	mov    0x58(%edx),%edx
80101791:	89 50 10             	mov    %edx,0x10(%eax)
}
80101794:	5d                   	pop    %ebp
80101795:	c3                   	ret    

80101796 <readi>:
{
80101796:	55                   	push   %ebp
80101797:	89 e5                	mov    %esp,%ebp
80101799:	57                   	push   %edi
8010179a:	56                   	push   %esi
8010179b:	53                   	push   %ebx
8010179c:	83 ec 1c             	sub    $0x1c,%esp
8010179f:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
801017a2:	8b 45 08             	mov    0x8(%ebp),%eax
801017a5:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801017aa:	74 2c                	je     801017d8 <readi+0x42>
  if(off > ip->size || off + n < off)
801017ac:	8b 45 08             	mov    0x8(%ebp),%eax
801017af:	8b 40 58             	mov    0x58(%eax),%eax
801017b2:	39 f8                	cmp    %edi,%eax
801017b4:	0f 82 cb 00 00 00    	jb     80101885 <readi+0xef>
801017ba:	89 fa                	mov    %edi,%edx
801017bc:	03 55 14             	add    0x14(%ebp),%edx
801017bf:	0f 82 c7 00 00 00    	jb     8010188c <readi+0xf6>
  if(off + n > ip->size)
801017c5:	39 d0                	cmp    %edx,%eax
801017c7:	73 05                	jae    801017ce <readi+0x38>
    n = ip->size - off;
801017c9:	29 f8                	sub    %edi,%eax
801017cb:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017ce:	be 00 00 00 00       	mov    $0x0,%esi
801017d3:	e9 8f 00 00 00       	jmp    80101867 <readi+0xd1>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017d8:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801017dc:	66 83 f8 09          	cmp    $0x9,%ax
801017e0:	0f 87 91 00 00 00    	ja     80101877 <readi+0xe1>
801017e6:	98                   	cwtl   
801017e7:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
801017ee:	85 c0                	test   %eax,%eax
801017f0:	0f 84 88 00 00 00    	je     8010187e <readi+0xe8>
    return devsw[ip->major].read(ip, dst, n);
801017f6:	83 ec 04             	sub    $0x4,%esp
801017f9:	ff 75 14             	pushl  0x14(%ebp)
801017fc:	ff 75 0c             	pushl  0xc(%ebp)
801017ff:	ff 75 08             	pushl  0x8(%ebp)
80101802:	ff d0                	call   *%eax
80101804:	83 c4 10             	add    $0x10,%esp
80101807:	eb 66                	jmp    8010186f <readi+0xd9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101809:	89 fa                	mov    %edi,%edx
8010180b:	c1 ea 09             	shr    $0x9,%edx
8010180e:	8b 45 08             	mov    0x8(%ebp),%eax
80101811:	e8 70 f9 ff ff       	call   80101186 <bmap>
80101816:	83 ec 08             	sub    $0x8,%esp
80101819:	50                   	push   %eax
8010181a:	8b 45 08             	mov    0x8(%ebp),%eax
8010181d:	ff 30                	pushl  (%eax)
8010181f:	e8 48 e9 ff ff       	call   8010016c <bread>
80101824:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
80101826:	89 f8                	mov    %edi,%eax
80101828:	25 ff 01 00 00       	and    $0x1ff,%eax
8010182d:	bb 00 02 00 00       	mov    $0x200,%ebx
80101832:	29 c3                	sub    %eax,%ebx
80101834:	8b 55 14             	mov    0x14(%ebp),%edx
80101837:	29 f2                	sub    %esi,%edx
80101839:	83 c4 0c             	add    $0xc,%esp
8010183c:	39 d3                	cmp    %edx,%ebx
8010183e:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101841:	53                   	push   %ebx
80101842:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101845:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101849:	50                   	push   %eax
8010184a:	ff 75 0c             	pushl  0xc(%ebp)
8010184d:	e8 19 2a 00 00       	call   8010426b <memmove>
    brelse(bp);
80101852:	83 c4 04             	add    $0x4,%esp
80101855:	ff 75 e4             	pushl  -0x1c(%ebp)
80101858:	e8 78 e9 ff ff       	call   801001d5 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010185d:	01 de                	add    %ebx,%esi
8010185f:	01 df                	add    %ebx,%edi
80101861:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101864:	83 c4 10             	add    $0x10,%esp
80101867:	39 75 14             	cmp    %esi,0x14(%ebp)
8010186a:	77 9d                	ja     80101809 <readi+0x73>
  return n;
8010186c:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010186f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101872:	5b                   	pop    %ebx
80101873:	5e                   	pop    %esi
80101874:	5f                   	pop    %edi
80101875:	5d                   	pop    %ebp
80101876:	c3                   	ret    
      return -1;
80101877:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010187c:	eb f1                	jmp    8010186f <readi+0xd9>
8010187e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101883:	eb ea                	jmp    8010186f <readi+0xd9>
    return -1;
80101885:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010188a:	eb e3                	jmp    8010186f <readi+0xd9>
8010188c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101891:	eb dc                	jmp    8010186f <readi+0xd9>

80101893 <writei>:
{
80101893:	55                   	push   %ebp
80101894:	89 e5                	mov    %esp,%ebp
80101896:	57                   	push   %edi
80101897:	56                   	push   %esi
80101898:	53                   	push   %ebx
80101899:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
8010189c:	8b 45 08             	mov    0x8(%ebp),%eax
8010189f:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018a4:	74 2f                	je     801018d5 <writei+0x42>
  if(off > ip->size || off + n < off)
801018a6:	8b 45 08             	mov    0x8(%ebp),%eax
801018a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
801018ac:	39 48 58             	cmp    %ecx,0x58(%eax)
801018af:	0f 82 f4 00 00 00    	jb     801019a9 <writei+0x116>
801018b5:	89 c8                	mov    %ecx,%eax
801018b7:	03 45 14             	add    0x14(%ebp),%eax
801018ba:	0f 82 f0 00 00 00    	jb     801019b0 <writei+0x11d>
  if(off + n > MAXFILE*BSIZE)
801018c0:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018c5:	0f 87 ec 00 00 00    	ja     801019b7 <writei+0x124>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018cb:	be 00 00 00 00       	mov    $0x0,%esi
801018d0:	e9 94 00 00 00       	jmp    80101969 <writei+0xd6>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018d5:	0f b7 40 52          	movzwl 0x52(%eax),%eax
801018d9:	66 83 f8 09          	cmp    $0x9,%ax
801018dd:	0f 87 b8 00 00 00    	ja     8010199b <writei+0x108>
801018e3:	98                   	cwtl   
801018e4:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
801018eb:	85 c0                	test   %eax,%eax
801018ed:	0f 84 af 00 00 00    	je     801019a2 <writei+0x10f>
    return devsw[ip->major].write(ip, src, n);
801018f3:	83 ec 04             	sub    $0x4,%esp
801018f6:	ff 75 14             	pushl  0x14(%ebp)
801018f9:	ff 75 0c             	pushl  0xc(%ebp)
801018fc:	ff 75 08             	pushl  0x8(%ebp)
801018ff:	ff d0                	call   *%eax
80101901:	83 c4 10             	add    $0x10,%esp
80101904:	eb 7c                	jmp    80101982 <writei+0xef>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101906:	8b 55 10             	mov    0x10(%ebp),%edx
80101909:	c1 ea 09             	shr    $0x9,%edx
8010190c:	8b 45 08             	mov    0x8(%ebp),%eax
8010190f:	e8 72 f8 ff ff       	call   80101186 <bmap>
80101914:	83 ec 08             	sub    $0x8,%esp
80101917:	50                   	push   %eax
80101918:	8b 45 08             	mov    0x8(%ebp),%eax
8010191b:	ff 30                	pushl  (%eax)
8010191d:	e8 4a e8 ff ff       	call   8010016c <bread>
80101922:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101924:	8b 45 10             	mov    0x10(%ebp),%eax
80101927:	25 ff 01 00 00       	and    $0x1ff,%eax
8010192c:	bb 00 02 00 00       	mov    $0x200,%ebx
80101931:	29 c3                	sub    %eax,%ebx
80101933:	8b 55 14             	mov    0x14(%ebp),%edx
80101936:	29 f2                	sub    %esi,%edx
80101938:	83 c4 0c             	add    $0xc,%esp
8010193b:	39 d3                	cmp    %edx,%ebx
8010193d:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101940:	53                   	push   %ebx
80101941:	ff 75 0c             	pushl  0xc(%ebp)
80101944:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101948:	50                   	push   %eax
80101949:	e8 1d 29 00 00       	call   8010426b <memmove>
    log_write(bp);
8010194e:	89 3c 24             	mov    %edi,(%esp)
80101951:	e8 a4 0f 00 00       	call   801028fa <log_write>
    brelse(bp);
80101956:	89 3c 24             	mov    %edi,(%esp)
80101959:	e8 77 e8 ff ff       	call   801001d5 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010195e:	01 de                	add    %ebx,%esi
80101960:	01 5d 10             	add    %ebx,0x10(%ebp)
80101963:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101966:	83 c4 10             	add    $0x10,%esp
80101969:	3b 75 14             	cmp    0x14(%ebp),%esi
8010196c:	72 98                	jb     80101906 <writei+0x73>
  if(n > 0 && off > ip->size){
8010196e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101972:	74 0b                	je     8010197f <writei+0xec>
80101974:	8b 45 08             	mov    0x8(%ebp),%eax
80101977:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010197a:	39 48 58             	cmp    %ecx,0x58(%eax)
8010197d:	72 0b                	jb     8010198a <writei+0xf7>
  return n;
8010197f:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101982:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101985:	5b                   	pop    %ebx
80101986:	5e                   	pop    %esi
80101987:	5f                   	pop    %edi
80101988:	5d                   	pop    %ebp
80101989:	c3                   	ret    
    ip->size = off;
8010198a:	89 48 58             	mov    %ecx,0x58(%eax)
    iupdate(ip);
8010198d:	83 ec 0c             	sub    $0xc,%esp
80101990:	50                   	push   %eax
80101991:	e8 ad fa ff ff       	call   80101443 <iupdate>
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	eb e4                	jmp    8010197f <writei+0xec>
      return -1;
8010199b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019a0:	eb e0                	jmp    80101982 <writei+0xef>
801019a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019a7:	eb d9                	jmp    80101982 <writei+0xef>
    return -1;
801019a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019ae:	eb d2                	jmp    80101982 <writei+0xef>
801019b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019b5:	eb cb                	jmp    80101982 <writei+0xef>
    return -1;
801019b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019bc:	eb c4                	jmp    80101982 <writei+0xef>

801019be <namecmp>:
{
801019be:	55                   	push   %ebp
801019bf:	89 e5                	mov    %esp,%ebp
801019c1:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801019c4:	6a 0e                	push   $0xe
801019c6:	ff 75 0c             	pushl  0xc(%ebp)
801019c9:	ff 75 08             	pushl  0x8(%ebp)
801019cc:	e8 01 29 00 00       	call   801042d2 <strncmp>
}
801019d1:	c9                   	leave  
801019d2:	c3                   	ret    

801019d3 <dirlookup>:
{
801019d3:	55                   	push   %ebp
801019d4:	89 e5                	mov    %esp,%ebp
801019d6:	57                   	push   %edi
801019d7:	56                   	push   %esi
801019d8:	53                   	push   %ebx
801019d9:	83 ec 1c             	sub    $0x1c,%esp
801019dc:	8b 75 08             	mov    0x8(%ebp),%esi
801019df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
801019e2:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019e7:	75 07                	jne    801019f0 <dirlookup+0x1d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019e9:	bb 00 00 00 00       	mov    $0x0,%ebx
801019ee:	eb 1d                	jmp    80101a0d <dirlookup+0x3a>
    panic("dirlookup not DIR");
801019f0:	83 ec 0c             	sub    $0xc,%esp
801019f3:	68 e7 6b 10 80       	push   $0x80106be7
801019f8:	e8 4b e9 ff ff       	call   80100348 <panic>
      panic("dirlookup read");
801019fd:	83 ec 0c             	sub    $0xc,%esp
80101a00:	68 f9 6b 10 80       	push   $0x80106bf9
80101a05:	e8 3e e9 ff ff       	call   80100348 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a0a:	83 c3 10             	add    $0x10,%ebx
80101a0d:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a10:	76 48                	jbe    80101a5a <dirlookup+0x87>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a12:	6a 10                	push   $0x10
80101a14:	53                   	push   %ebx
80101a15:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a18:	50                   	push   %eax
80101a19:	56                   	push   %esi
80101a1a:	e8 77 fd ff ff       	call   80101796 <readi>
80101a1f:	83 c4 10             	add    $0x10,%esp
80101a22:	83 f8 10             	cmp    $0x10,%eax
80101a25:	75 d6                	jne    801019fd <dirlookup+0x2a>
    if(de.inum == 0)
80101a27:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a2c:	74 dc                	je     80101a0a <dirlookup+0x37>
    if(namecmp(name, de.name) == 0){
80101a2e:	83 ec 08             	sub    $0x8,%esp
80101a31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a34:	50                   	push   %eax
80101a35:	57                   	push   %edi
80101a36:	e8 83 ff ff ff       	call   801019be <namecmp>
80101a3b:	83 c4 10             	add    $0x10,%esp
80101a3e:	85 c0                	test   %eax,%eax
80101a40:	75 c8                	jne    80101a0a <dirlookup+0x37>
      if(poff)
80101a42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a46:	74 05                	je     80101a4d <dirlookup+0x7a>
        *poff = off;
80101a48:	8b 45 10             	mov    0x10(%ebp),%eax
80101a4b:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a4d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a51:	8b 06                	mov    (%esi),%eax
80101a53:	e8 d4 f7 ff ff       	call   8010122c <iget>
80101a58:	eb 05                	jmp    80101a5f <dirlookup+0x8c>
  return 0;
80101a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a62:	5b                   	pop    %ebx
80101a63:	5e                   	pop    %esi
80101a64:	5f                   	pop    %edi
80101a65:	5d                   	pop    %ebp
80101a66:	c3                   	ret    

80101a67 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a67:	55                   	push   %ebp
80101a68:	89 e5                	mov    %esp,%ebp
80101a6a:	57                   	push   %edi
80101a6b:	56                   	push   %esi
80101a6c:	53                   	push   %ebx
80101a6d:	83 ec 1c             	sub    $0x1c,%esp
80101a70:	89 c6                	mov    %eax,%esi
80101a72:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a75:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a78:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a7b:	74 17                	je     80101a94 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a7d:	e8 3d 17 00 00       	call   801031bf <myproc>
80101a82:	83 ec 0c             	sub    $0xc,%esp
80101a85:	ff 70 68             	pushl  0x68(%eax)
80101a88:	e8 e7 fa ff ff       	call   80101574 <idup>
80101a8d:	89 c3                	mov    %eax,%ebx
80101a8f:	83 c4 10             	add    $0x10,%esp
80101a92:	eb 53                	jmp    80101ae7 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101a94:	ba 01 00 00 00       	mov    $0x1,%edx
80101a99:	b8 01 00 00 00       	mov    $0x1,%eax
80101a9e:	e8 89 f7 ff ff       	call   8010122c <iget>
80101aa3:	89 c3                	mov    %eax,%ebx
80101aa5:	eb 40                	jmp    80101ae7 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101aa7:	83 ec 0c             	sub    $0xc,%esp
80101aaa:	53                   	push   %ebx
80101aab:	e8 9b fc ff ff       	call   8010174b <iunlockput>
      return 0;
80101ab0:	83 c4 10             	add    $0x10,%esp
80101ab3:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ab8:	89 d8                	mov    %ebx,%eax
80101aba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101abd:	5b                   	pop    %ebx
80101abe:	5e                   	pop    %esi
80101abf:	5f                   	pop    %edi
80101ac0:	5d                   	pop    %ebp
80101ac1:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101ac2:	83 ec 04             	sub    $0x4,%esp
80101ac5:	6a 00                	push   $0x0
80101ac7:	ff 75 e4             	pushl  -0x1c(%ebp)
80101aca:	53                   	push   %ebx
80101acb:	e8 03 ff ff ff       	call   801019d3 <dirlookup>
80101ad0:	89 c7                	mov    %eax,%edi
80101ad2:	83 c4 10             	add    $0x10,%esp
80101ad5:	85 c0                	test   %eax,%eax
80101ad7:	74 4a                	je     80101b23 <namex+0xbc>
    iunlockput(ip);
80101ad9:	83 ec 0c             	sub    $0xc,%esp
80101adc:	53                   	push   %ebx
80101add:	e8 69 fc ff ff       	call   8010174b <iunlockput>
    ip = next;
80101ae2:	83 c4 10             	add    $0x10,%esp
80101ae5:	89 fb                	mov    %edi,%ebx
  while((path = skipelem(path, name)) != 0){
80101ae7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101aea:	89 f0                	mov    %esi,%eax
80101aec:	e8 89 f4 ff ff       	call   80100f7a <skipelem>
80101af1:	89 c6                	mov    %eax,%esi
80101af3:	85 c0                	test   %eax,%eax
80101af5:	74 3c                	je     80101b33 <namex+0xcc>
    ilock(ip);
80101af7:	83 ec 0c             	sub    $0xc,%esp
80101afa:	53                   	push   %ebx
80101afb:	e8 a4 fa ff ff       	call   801015a4 <ilock>
    if(ip->type != T_DIR){
80101b00:	83 c4 10             	add    $0x10,%esp
80101b03:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b08:	75 9d                	jne    80101aa7 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b0a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b0e:	74 b2                	je     80101ac2 <namex+0x5b>
80101b10:	80 3e 00             	cmpb   $0x0,(%esi)
80101b13:	75 ad                	jne    80101ac2 <namex+0x5b>
      iunlock(ip);
80101b15:	83 ec 0c             	sub    $0xc,%esp
80101b18:	53                   	push   %ebx
80101b19:	e8 48 fb ff ff       	call   80101666 <iunlock>
      return ip;
80101b1e:	83 c4 10             	add    $0x10,%esp
80101b21:	eb 95                	jmp    80101ab8 <namex+0x51>
      iunlockput(ip);
80101b23:	83 ec 0c             	sub    $0xc,%esp
80101b26:	53                   	push   %ebx
80101b27:	e8 1f fc ff ff       	call   8010174b <iunlockput>
      return 0;
80101b2c:	83 c4 10             	add    $0x10,%esp
80101b2f:	89 fb                	mov    %edi,%ebx
80101b31:	eb 85                	jmp    80101ab8 <namex+0x51>
  if(nameiparent){
80101b33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b37:	0f 84 7b ff ff ff    	je     80101ab8 <namex+0x51>
    iput(ip);
80101b3d:	83 ec 0c             	sub    $0xc,%esp
80101b40:	53                   	push   %ebx
80101b41:	e8 65 fb ff ff       	call   801016ab <iput>
    return 0;
80101b46:	83 c4 10             	add    $0x10,%esp
80101b49:	bb 00 00 00 00       	mov    $0x0,%ebx
80101b4e:	e9 65 ff ff ff       	jmp    80101ab8 <namex+0x51>

80101b53 <dirlink>:
{
80101b53:	55                   	push   %ebp
80101b54:	89 e5                	mov    %esp,%ebp
80101b56:	57                   	push   %edi
80101b57:	56                   	push   %esi
80101b58:	53                   	push   %ebx
80101b59:	83 ec 20             	sub    $0x20,%esp
80101b5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b5f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b62:	6a 00                	push   $0x0
80101b64:	57                   	push   %edi
80101b65:	53                   	push   %ebx
80101b66:	e8 68 fe ff ff       	call   801019d3 <dirlookup>
80101b6b:	83 c4 10             	add    $0x10,%esp
80101b6e:	85 c0                	test   %eax,%eax
80101b70:	75 2d                	jne    80101b9f <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b72:	b8 00 00 00 00       	mov    $0x0,%eax
80101b77:	89 c6                	mov    %eax,%esi
80101b79:	39 43 58             	cmp    %eax,0x58(%ebx)
80101b7c:	76 41                	jbe    80101bbf <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b7e:	6a 10                	push   $0x10
80101b80:	50                   	push   %eax
80101b81:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101b84:	50                   	push   %eax
80101b85:	53                   	push   %ebx
80101b86:	e8 0b fc ff ff       	call   80101796 <readi>
80101b8b:	83 c4 10             	add    $0x10,%esp
80101b8e:	83 f8 10             	cmp    $0x10,%eax
80101b91:	75 1f                	jne    80101bb2 <dirlink+0x5f>
    if(de.inum == 0)
80101b93:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b98:	74 25                	je     80101bbf <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b9a:	8d 46 10             	lea    0x10(%esi),%eax
80101b9d:	eb d8                	jmp    80101b77 <dirlink+0x24>
    iput(ip);
80101b9f:	83 ec 0c             	sub    $0xc,%esp
80101ba2:	50                   	push   %eax
80101ba3:	e8 03 fb ff ff       	call   801016ab <iput>
    return -1;
80101ba8:	83 c4 10             	add    $0x10,%esp
80101bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bb0:	eb 3d                	jmp    80101bef <dirlink+0x9c>
      panic("dirlink read");
80101bb2:	83 ec 0c             	sub    $0xc,%esp
80101bb5:	68 08 6c 10 80       	push   $0x80106c08
80101bba:	e8 89 e7 ff ff       	call   80100348 <panic>
  strncpy(de.name, name, DIRSIZ);
80101bbf:	83 ec 04             	sub    $0x4,%esp
80101bc2:	6a 0e                	push   $0xe
80101bc4:	57                   	push   %edi
80101bc5:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101bc8:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bcb:	50                   	push   %eax
80101bcc:	e8 3e 27 00 00       	call   8010430f <strncpy>
  de.inum = inum;
80101bd1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bd4:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd8:	6a 10                	push   $0x10
80101bda:	56                   	push   %esi
80101bdb:	57                   	push   %edi
80101bdc:	53                   	push   %ebx
80101bdd:	e8 b1 fc ff ff       	call   80101893 <writei>
80101be2:	83 c4 20             	add    $0x20,%esp
80101be5:	83 f8 10             	cmp    $0x10,%eax
80101be8:	75 0d                	jne    80101bf7 <dirlink+0xa4>
  return 0;
80101bea:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf2:	5b                   	pop    %ebx
80101bf3:	5e                   	pop    %esi
80101bf4:	5f                   	pop    %edi
80101bf5:	5d                   	pop    %ebp
80101bf6:	c3                   	ret    
    panic("dirlink");
80101bf7:	83 ec 0c             	sub    $0xc,%esp
80101bfa:	68 3c 73 10 80       	push   $0x8010733c
80101bff:	e8 44 e7 ff ff       	call   80100348 <panic>

80101c04 <namei>:

struct inode*
namei(char *path)
{
80101c04:	55                   	push   %ebp
80101c05:	89 e5                	mov    %esp,%ebp
80101c07:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c0a:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c0d:	ba 00 00 00 00       	mov    $0x0,%edx
80101c12:	8b 45 08             	mov    0x8(%ebp),%eax
80101c15:	e8 4d fe ff ff       	call   80101a67 <namex>
}
80101c1a:	c9                   	leave  
80101c1b:	c3                   	ret    

80101c1c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c1c:	55                   	push   %ebp
80101c1d:	89 e5                	mov    %esp,%ebp
80101c1f:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c25:	ba 01 00 00 00       	mov    $0x1,%edx
80101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2d:	e8 35 fe ff ff       	call   80101a67 <namex>
}
80101c32:	c9                   	leave  
80101c33:	c3                   	ret    

80101c34 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c34:	55                   	push   %ebp
80101c35:	89 e5                	mov    %esp,%ebp
80101c37:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c39:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c3e:	ec                   	in     (%dx),%al
80101c3f:	89 c2                	mov    %eax,%edx
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c41:	83 e0 c0             	and    $0xffffffc0,%eax
80101c44:	3c 40                	cmp    $0x40,%al
80101c46:	75 f1                	jne    80101c39 <idewait+0x5>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c48:	85 c9                	test   %ecx,%ecx
80101c4a:	74 0c                	je     80101c58 <idewait+0x24>
80101c4c:	f6 c2 21             	test   $0x21,%dl
80101c4f:	75 0e                	jne    80101c5f <idewait+0x2b>
    return -1;
  return 0;
80101c51:	b8 00 00 00 00       	mov    $0x0,%eax
80101c56:	eb 05                	jmp    80101c5d <idewait+0x29>
80101c58:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c5d:	5d                   	pop    %ebp
80101c5e:	c3                   	ret    
    return -1;
80101c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c64:	eb f7                	jmp    80101c5d <idewait+0x29>

80101c66 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c66:	55                   	push   %ebp
80101c67:	89 e5                	mov    %esp,%ebp
80101c69:	56                   	push   %esi
80101c6a:	53                   	push   %ebx
  if(b == 0)
80101c6b:	85 c0                	test   %eax,%eax
80101c6d:	74 7d                	je     80101cec <idestart+0x86>
80101c6f:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c71:	8b 58 08             	mov    0x8(%eax),%ebx
80101c74:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101c7a:	77 7d                	ja     80101cf9 <idestart+0x93>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101c7c:	b8 00 00 00 00       	mov    $0x0,%eax
80101c81:	e8 ae ff ff ff       	call   80101c34 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c86:	b8 00 00 00 00       	mov    $0x0,%eax
80101c8b:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101c90:	ee                   	out    %al,(%dx)
80101c91:	b8 01 00 00 00       	mov    $0x1,%eax
80101c96:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101c9b:	ee                   	out    %al,(%dx)
80101c9c:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101ca1:	89 d8                	mov    %ebx,%eax
80101ca3:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101ca4:	89 d8                	mov    %ebx,%eax
80101ca6:	c1 f8 08             	sar    $0x8,%eax
80101ca9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101cae:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101caf:	89 d8                	mov    %ebx,%eax
80101cb1:	c1 f8 10             	sar    $0x10,%eax
80101cb4:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101cb9:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101cba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101cbe:	c1 e0 04             	shl    $0x4,%eax
80101cc1:	83 e0 10             	and    $0x10,%eax
80101cc4:	c1 fb 18             	sar    $0x18,%ebx
80101cc7:	83 e3 0f             	and    $0xf,%ebx
80101cca:	09 d8                	or     %ebx,%eax
80101ccc:	83 c8 e0             	or     $0xffffffe0,%eax
80101ccf:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101cd4:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101cd5:	f6 06 04             	testb  $0x4,(%esi)
80101cd8:	75 2c                	jne    80101d06 <idestart+0xa0>
80101cda:	b8 20 00 00 00       	mov    $0x20,%eax
80101cdf:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ce4:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101ce5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ce8:	5b                   	pop    %ebx
80101ce9:	5e                   	pop    %esi
80101cea:	5d                   	pop    %ebp
80101ceb:	c3                   	ret    
    panic("idestart");
80101cec:	83 ec 0c             	sub    $0xc,%esp
80101cef:	68 6b 6c 10 80       	push   $0x80106c6b
80101cf4:	e8 4f e6 ff ff       	call   80100348 <panic>
    panic("incorrect blockno");
80101cf9:	83 ec 0c             	sub    $0xc,%esp
80101cfc:	68 74 6c 10 80       	push   $0x80106c74
80101d01:	e8 42 e6 ff ff       	call   80100348 <panic>
80101d06:	b8 30 00 00 00       	mov    $0x30,%eax
80101d0b:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d10:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101d11:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d14:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d19:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d1e:	fc                   	cld    
80101d1f:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101d21:	eb c2                	jmp    80101ce5 <idestart+0x7f>

80101d23 <ideinit>:
{
80101d23:	55                   	push   %ebp
80101d24:	89 e5                	mov    %esp,%ebp
80101d26:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d29:	68 86 6c 10 80       	push   $0x80106c86
80101d2e:	68 80 a5 10 80       	push   $0x8010a580
80101d33:	e8 d0 22 00 00       	call   80104008 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d38:	83 c4 08             	add    $0x8,%esp
80101d3b:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101d40:	83 e8 01             	sub    $0x1,%eax
80101d43:	50                   	push   %eax
80101d44:	6a 0e                	push   $0xe
80101d46:	e8 56 02 00 00       	call   80101fa1 <ioapicenable>
  idewait(0);
80101d4b:	b8 00 00 00 00       	mov    $0x0,%eax
80101d50:	e8 df fe ff ff       	call   80101c34 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d55:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101d5a:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d5f:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101d60:	83 c4 10             	add    $0x10,%esp
80101d63:	b9 00 00 00 00       	mov    $0x0,%ecx
80101d68:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d6e:	7f 19                	jg     80101d89 <ideinit+0x66>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d70:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d75:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d76:	84 c0                	test   %al,%al
80101d78:	75 05                	jne    80101d7f <ideinit+0x5c>
  for(i=0; i<1000; i++){
80101d7a:	83 c1 01             	add    $0x1,%ecx
80101d7d:	eb e9                	jmp    80101d68 <ideinit+0x45>
      havedisk1 = 1;
80101d7f:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101d86:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d89:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101d8e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d93:	ee                   	out    %al,(%dx)
}
80101d94:	c9                   	leave  
80101d95:	c3                   	ret    

80101d96 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101d96:	55                   	push   %ebp
80101d97:	89 e5                	mov    %esp,%ebp
80101d99:	57                   	push   %edi
80101d9a:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101d9b:	83 ec 0c             	sub    $0xc,%esp
80101d9e:	68 80 a5 10 80       	push   $0x8010a580
80101da3:	e8 9c 23 00 00       	call   80104144 <acquire>

  if((b = idequeue) == 0){
80101da8:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101dae:	83 c4 10             	add    $0x10,%esp
80101db1:	85 db                	test   %ebx,%ebx
80101db3:	74 48                	je     80101dfd <ideintr+0x67>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101db5:	8b 43 58             	mov    0x58(%ebx),%eax
80101db8:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101dbd:	f6 03 04             	testb  $0x4,(%ebx)
80101dc0:	74 4d                	je     80101e0f <ideintr+0x79>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101dc2:	8b 03                	mov    (%ebx),%eax
80101dc4:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101dc7:	83 e0 fb             	and    $0xfffffffb,%eax
80101dca:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101dcc:	83 ec 0c             	sub    $0xc,%esp
80101dcf:	53                   	push   %ebx
80101dd0:	e8 13 1c 00 00       	call   801039e8 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101dd5:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101dda:	83 c4 10             	add    $0x10,%esp
80101ddd:	85 c0                	test   %eax,%eax
80101ddf:	74 05                	je     80101de6 <ideintr+0x50>
    idestart(idequeue);
80101de1:	e8 80 fe ff ff       	call   80101c66 <idestart>

  release(&idelock);
80101de6:	83 ec 0c             	sub    $0xc,%esp
80101de9:	68 80 a5 10 80       	push   $0x8010a580
80101dee:	e8 b6 23 00 00       	call   801041a9 <release>
80101df3:	83 c4 10             	add    $0x10,%esp
}
80101df6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101df9:	5b                   	pop    %ebx
80101dfa:	5f                   	pop    %edi
80101dfb:	5d                   	pop    %ebp
80101dfc:	c3                   	ret    
    release(&idelock);
80101dfd:	83 ec 0c             	sub    $0xc,%esp
80101e00:	68 80 a5 10 80       	push   $0x8010a580
80101e05:	e8 9f 23 00 00       	call   801041a9 <release>
    return;
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	eb e7                	jmp    80101df6 <ideintr+0x60>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e0f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e14:	e8 1b fe ff ff       	call   80101c34 <idewait>
80101e19:	85 c0                	test   %eax,%eax
80101e1b:	78 a5                	js     80101dc2 <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101e1d:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e20:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e25:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e2a:	fc                   	cld    
80101e2b:	f3 6d                	rep insl (%dx),%es:(%edi)
80101e2d:	eb 93                	jmp    80101dc2 <ideintr+0x2c>

80101e2f <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e2f:	55                   	push   %ebp
80101e30:	89 e5                	mov    %esp,%ebp
80101e32:	53                   	push   %ebx
80101e33:	83 ec 10             	sub    $0x10,%esp
80101e36:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e39:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e3c:	50                   	push   %eax
80101e3d:	e8 78 21 00 00       	call   80103fba <holdingsleep>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	85 c0                	test   %eax,%eax
80101e47:	74 37                	je     80101e80 <iderw+0x51>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e49:	8b 03                	mov    (%ebx),%eax
80101e4b:	83 e0 06             	and    $0x6,%eax
80101e4e:	83 f8 02             	cmp    $0x2,%eax
80101e51:	74 3a                	je     80101e8d <iderw+0x5e>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e53:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e57:	74 09                	je     80101e62 <iderw+0x33>
80101e59:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101e60:	74 38                	je     80101e9a <iderw+0x6b>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e62:	83 ec 0c             	sub    $0xc,%esp
80101e65:	68 80 a5 10 80       	push   $0x8010a580
80101e6a:	e8 d5 22 00 00       	call   80104144 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e6f:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e76:	83 c4 10             	add    $0x10,%esp
80101e79:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101e7e:	eb 2a                	jmp    80101eaa <iderw+0x7b>
    panic("iderw: buf not locked");
80101e80:	83 ec 0c             	sub    $0xc,%esp
80101e83:	68 8a 6c 10 80       	push   $0x80106c8a
80101e88:	e8 bb e4 ff ff       	call   80100348 <panic>
    panic("iderw: nothing to do");
80101e8d:	83 ec 0c             	sub    $0xc,%esp
80101e90:	68 a0 6c 10 80       	push   $0x80106ca0
80101e95:	e8 ae e4 ff ff       	call   80100348 <panic>
    panic("iderw: ide disk 1 not present");
80101e9a:	83 ec 0c             	sub    $0xc,%esp
80101e9d:	68 b5 6c 10 80       	push   $0x80106cb5
80101ea2:	e8 a1 e4 ff ff       	call   80100348 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101ea7:	8d 50 58             	lea    0x58(%eax),%edx
80101eaa:	8b 02                	mov    (%edx),%eax
80101eac:	85 c0                	test   %eax,%eax
80101eae:	75 f7                	jne    80101ea7 <iderw+0x78>
    ;
  *pp = b;
80101eb0:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101eb2:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101eb8:	75 1a                	jne    80101ed4 <iderw+0xa5>
    idestart(b);
80101eba:	89 d8                	mov    %ebx,%eax
80101ebc:	e8 a5 fd ff ff       	call   80101c66 <idestart>
80101ec1:	eb 11                	jmp    80101ed4 <iderw+0xa5>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101ec3:	83 ec 08             	sub    $0x8,%esp
80101ec6:	68 80 a5 10 80       	push   $0x8010a580
80101ecb:	53                   	push   %ebx
80101ecc:	e8 6b 1a 00 00       	call   8010393c <sleep>
80101ed1:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101ed4:	8b 03                	mov    (%ebx),%eax
80101ed6:	83 e0 06             	and    $0x6,%eax
80101ed9:	83 f8 02             	cmp    $0x2,%eax
80101edc:	75 e5                	jne    80101ec3 <iderw+0x94>
  }


  release(&idelock);
80101ede:	83 ec 0c             	sub    $0xc,%esp
80101ee1:	68 80 a5 10 80       	push   $0x8010a580
80101ee6:	e8 be 22 00 00       	call   801041a9 <release>
}
80101eeb:	83 c4 10             	add    $0x10,%esp
80101eee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ef1:	c9                   	leave  
80101ef2:	c3                   	ret    

80101ef3 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80101ef3:	55                   	push   %ebp
80101ef4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80101ef6:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80101efc:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101efe:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f03:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    

80101f08 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80101f08:	55                   	push   %ebp
80101f09:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80101f0b:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f11:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f13:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f18:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f1b:	5d                   	pop    %ebp
80101f1c:	c3                   	ret    

80101f1d <ioapicinit>:

void
ioapicinit(void)
{
80101f1d:	55                   	push   %ebp
80101f1e:	89 e5                	mov    %esp,%ebp
80101f20:	57                   	push   %edi
80101f21:	56                   	push   %esi
80101f22:	53                   	push   %ebx
80101f23:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f26:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101f2d:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f30:	b8 01 00 00 00       	mov    $0x1,%eax
80101f35:	e8 b9 ff ff ff       	call   80101ef3 <ioapicread>
80101f3a:	c1 e8 10             	shr    $0x10,%eax
80101f3d:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f40:	b8 00 00 00 00       	mov    $0x0,%eax
80101f45:	e8 a9 ff ff ff       	call   80101ef3 <ioapicread>
80101f4a:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f4d:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80101f54:	39 c2                	cmp    %eax,%edx
80101f56:	75 07                	jne    80101f5f <ioapicinit+0x42>
{
80101f58:	bb 00 00 00 00       	mov    $0x0,%ebx
80101f5d:	eb 36                	jmp    80101f95 <ioapicinit+0x78>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101f5f:	83 ec 0c             	sub    $0xc,%esp
80101f62:	68 d4 6c 10 80       	push   $0x80106cd4
80101f67:	e8 9f e6 ff ff       	call   8010060b <cprintf>
80101f6c:	83 c4 10             	add    $0x10,%esp
80101f6f:	eb e7                	jmp    80101f58 <ioapicinit+0x3b>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f71:	8d 53 20             	lea    0x20(%ebx),%edx
80101f74:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101f7a:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101f7e:	89 f0                	mov    %esi,%eax
80101f80:	e8 83 ff ff ff       	call   80101f08 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f85:	8d 46 01             	lea    0x1(%esi),%eax
80101f88:	ba 00 00 00 00       	mov    $0x0,%edx
80101f8d:	e8 76 ff ff ff       	call   80101f08 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101f92:	83 c3 01             	add    $0x1,%ebx
80101f95:	39 fb                	cmp    %edi,%ebx
80101f97:	7e d8                	jle    80101f71 <ioapicinit+0x54>
  }
}
80101f99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f9c:	5b                   	pop    %ebx
80101f9d:	5e                   	pop    %esi
80101f9e:	5f                   	pop    %edi
80101f9f:	5d                   	pop    %ebp
80101fa0:	c3                   	ret    

80101fa1 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101fa1:	55                   	push   %ebp
80101fa2:	89 e5                	mov    %esp,%ebp
80101fa4:	53                   	push   %ebx
80101fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101fa8:	8d 50 20             	lea    0x20(%eax),%edx
80101fab:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101faf:	89 d8                	mov    %ebx,%eax
80101fb1:	e8 52 ff ff ff       	call   80101f08 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101fb6:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fb9:	c1 e2 18             	shl    $0x18,%edx
80101fbc:	8d 43 01             	lea    0x1(%ebx),%eax
80101fbf:	e8 44 ff ff ff       	call   80101f08 <ioapicwrite>
}
80101fc4:	5b                   	pop    %ebx
80101fc5:	5d                   	pop    %ebp
80101fc6:	c3                   	ret    

80101fc7 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101fc7:	55                   	push   %ebp
80101fc8:	89 e5                	mov    %esp,%ebp
80101fca:	53                   	push   %ebx
80101fcb:	83 ec 04             	sub    $0x4,%esp
80101fce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101fd1:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101fd7:	75 4c                	jne    80102025 <kfree+0x5e>
80101fd9:	81 fb a8 79 11 80    	cmp    $0x801179a8,%ebx
80101fdf:	72 44                	jb     80102025 <kfree+0x5e>
80101fe1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101fe7:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101fec:	77 37                	ja     80102025 <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80101fee:	83 ec 04             	sub    $0x4,%esp
80101ff1:	68 00 10 00 00       	push   $0x1000
80101ff6:	6a 01                	push   $0x1
80101ff8:	53                   	push   %ebx
80101ff9:	e8 f2 21 00 00       	call   801041f0 <memset>

  if(kmem.use_lock)
80101ffe:	83 c4 10             	add    $0x10,%esp
80102001:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102008:	75 28                	jne    80102032 <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010200a:	a1 78 26 11 80       	mov    0x80112678,%eax
8010200f:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102011:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102017:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010201e:	75 24                	jne    80102044 <kfree+0x7d>
    release(&kmem.lock);
}
80102020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102023:	c9                   	leave  
80102024:	c3                   	ret    
    panic("kfree");
80102025:	83 ec 0c             	sub    $0xc,%esp
80102028:	68 06 6d 10 80       	push   $0x80106d06
8010202d:	e8 16 e3 ff ff       	call   80100348 <panic>
    acquire(&kmem.lock);
80102032:	83 ec 0c             	sub    $0xc,%esp
80102035:	68 40 26 11 80       	push   $0x80112640
8010203a:	e8 05 21 00 00       	call   80104144 <acquire>
8010203f:	83 c4 10             	add    $0x10,%esp
80102042:	eb c6                	jmp    8010200a <kfree+0x43>
    release(&kmem.lock);
80102044:	83 ec 0c             	sub    $0xc,%esp
80102047:	68 40 26 11 80       	push   $0x80112640
8010204c:	e8 58 21 00 00       	call   801041a9 <release>
80102051:	83 c4 10             	add    $0x10,%esp
}
80102054:	eb ca                	jmp    80102020 <kfree+0x59>

80102056 <freerange>:
{
80102056:	55                   	push   %ebp
80102057:	89 e5                	mov    %esp,%ebp
80102059:	56                   	push   %esi
8010205a:	53                   	push   %ebx
8010205b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010205e:	8b 45 08             	mov    0x8(%ebp),%eax
80102061:	05 ff 0f 00 00       	add    $0xfff,%eax
80102066:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010206b:	eb 0e                	jmp    8010207b <freerange+0x25>
    kfree(p);
8010206d:	83 ec 0c             	sub    $0xc,%esp
80102070:	50                   	push   %eax
80102071:	e8 51 ff ff ff       	call   80101fc7 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102076:	83 c4 10             	add    $0x10,%esp
80102079:	89 f0                	mov    %esi,%eax
8010207b:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102081:	39 de                	cmp    %ebx,%esi
80102083:	76 e8                	jbe    8010206d <freerange+0x17>
}
80102085:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102088:	5b                   	pop    %ebx
80102089:	5e                   	pop    %esi
8010208a:	5d                   	pop    %ebp
8010208b:	c3                   	ret    

8010208c <kinit1>:
{
8010208c:	55                   	push   %ebp
8010208d:	89 e5                	mov    %esp,%ebp
8010208f:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102092:	68 0c 6d 10 80       	push   $0x80106d0c
80102097:	68 40 26 11 80       	push   $0x80112640
8010209c:	e8 67 1f 00 00       	call   80104008 <initlock>
  kmem.use_lock = 0;
801020a1:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801020a8:	00 00 00 
  freerange(vstart, vend);
801020ab:	83 c4 08             	add    $0x8,%esp
801020ae:	ff 75 0c             	pushl  0xc(%ebp)
801020b1:	ff 75 08             	pushl  0x8(%ebp)
801020b4:	e8 9d ff ff ff       	call   80102056 <freerange>
}
801020b9:	83 c4 10             	add    $0x10,%esp
801020bc:	c9                   	leave  
801020bd:	c3                   	ret    

801020be <kinit2>:
{
801020be:	55                   	push   %ebp
801020bf:	89 e5                	mov    %esp,%ebp
801020c1:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
801020c4:	ff 75 0c             	pushl  0xc(%ebp)
801020c7:	ff 75 08             	pushl  0x8(%ebp)
801020ca:	e8 87 ff ff ff       	call   80102056 <freerange>
  kmem.use_lock = 1;
801020cf:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801020d6:	00 00 00 
}
801020d9:	83 c4 10             	add    $0x10,%esp
801020dc:	c9                   	leave  
801020dd:	c3                   	ret    

801020de <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801020de:	55                   	push   %ebp
801020df:	89 e5                	mov    %esp,%ebp
801020e1:	53                   	push   %ebx
801020e2:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801020e5:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
801020ec:	75 21                	jne    8010210f <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
801020ee:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801020f4:	85 db                	test   %ebx,%ebx
801020f6:	74 07                	je     801020ff <kalloc+0x21>
    kmem.freelist = r->next;
801020f8:	8b 03                	mov    (%ebx),%eax
801020fa:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
801020ff:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102106:	75 19                	jne    80102121 <kalloc+0x43>
    release(&kmem.lock);
  return (char*)r;
}
80102108:	89 d8                	mov    %ebx,%eax
8010210a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010210d:	c9                   	leave  
8010210e:	c3                   	ret    
    acquire(&kmem.lock);
8010210f:	83 ec 0c             	sub    $0xc,%esp
80102112:	68 40 26 11 80       	push   $0x80112640
80102117:	e8 28 20 00 00       	call   80104144 <acquire>
8010211c:	83 c4 10             	add    $0x10,%esp
8010211f:	eb cd                	jmp    801020ee <kalloc+0x10>
    release(&kmem.lock);
80102121:	83 ec 0c             	sub    $0xc,%esp
80102124:	68 40 26 11 80       	push   $0x80112640
80102129:	e8 7b 20 00 00       	call   801041a9 <release>
8010212e:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102131:	eb d5                	jmp    80102108 <kalloc+0x2a>

80102133 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102133:	55                   	push   %ebp
80102134:	89 e5                	mov    %esp,%ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102136:	ba 64 00 00 00       	mov    $0x64,%edx
8010213b:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010213c:	a8 01                	test   $0x1,%al
8010213e:	0f 84 b5 00 00 00    	je     801021f9 <kbdgetc+0xc6>
80102144:	ba 60 00 00 00       	mov    $0x60,%edx
80102149:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010214a:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010214d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102153:	74 5c                	je     801021b1 <kbdgetc+0x7e>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102155:	84 c0                	test   %al,%al
80102157:	78 66                	js     801021bf <kbdgetc+0x8c>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102159:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010215f:	f6 c1 40             	test   $0x40,%cl
80102162:	74 0f                	je     80102173 <kbdgetc+0x40>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102164:	83 c8 80             	or     $0xffffff80,%eax
80102167:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
8010216a:	83 e1 bf             	and    $0xffffffbf,%ecx
8010216d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
80102173:	0f b6 8a 40 6e 10 80 	movzbl -0x7fef91c0(%edx),%ecx
8010217a:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
80102180:	0f b6 82 40 6d 10 80 	movzbl -0x7fef92c0(%edx),%eax
80102187:	31 c1                	xor    %eax,%ecx
80102189:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010218f:	89 c8                	mov    %ecx,%eax
80102191:	83 e0 03             	and    $0x3,%eax
80102194:	8b 04 85 20 6d 10 80 	mov    -0x7fef92e0(,%eax,4),%eax
8010219b:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010219f:	f6 c1 08             	test   $0x8,%cl
801021a2:	74 19                	je     801021bd <kbdgetc+0x8a>
    if('a' <= c && c <= 'z')
801021a4:	8d 50 9f             	lea    -0x61(%eax),%edx
801021a7:	83 fa 19             	cmp    $0x19,%edx
801021aa:	77 40                	ja     801021ec <kbdgetc+0xb9>
      c += 'A' - 'a';
801021ac:	83 e8 20             	sub    $0x20,%eax
801021af:	eb 0c                	jmp    801021bd <kbdgetc+0x8a>
    shift |= E0ESC;
801021b1:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801021b8:	b8 00 00 00 00       	mov    $0x0,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801021bd:	5d                   	pop    %ebp
801021be:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801021bf:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
801021c5:	f6 c1 40             	test   $0x40,%cl
801021c8:	75 05                	jne    801021cf <kbdgetc+0x9c>
801021ca:	89 c2                	mov    %eax,%edx
801021cc:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801021cf:	0f b6 82 40 6e 10 80 	movzbl -0x7fef91c0(%edx),%eax
801021d6:	83 c8 40             	or     $0x40,%eax
801021d9:	0f b6 c0             	movzbl %al,%eax
801021dc:	f7 d0                	not    %eax
801021de:	21 c8                	and    %ecx,%eax
801021e0:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
801021e5:	b8 00 00 00 00       	mov    $0x0,%eax
801021ea:	eb d1                	jmp    801021bd <kbdgetc+0x8a>
    else if('A' <= c && c <= 'Z')
801021ec:	8d 50 bf             	lea    -0x41(%eax),%edx
801021ef:	83 fa 19             	cmp    $0x19,%edx
801021f2:	77 c9                	ja     801021bd <kbdgetc+0x8a>
      c += 'a' - 'A';
801021f4:	83 c0 20             	add    $0x20,%eax
  return c;
801021f7:	eb c4                	jmp    801021bd <kbdgetc+0x8a>
    return -1;
801021f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021fe:	eb bd                	jmp    801021bd <kbdgetc+0x8a>

80102200 <kbdintr>:

void
kbdintr(void)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102206:	68 33 21 10 80       	push   $0x80102133
8010220b:	e8 2e e5 ff ff       	call   8010073e <consoleintr>
}
80102210:	83 c4 10             	add    $0x10,%esp
80102213:	c9                   	leave  
80102214:	c3                   	ret    

80102215 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102215:	55                   	push   %ebp
80102216:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102218:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
8010221e:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102221:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102223:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102228:	8b 40 20             	mov    0x20(%eax),%eax
}
8010222b:	5d                   	pop    %ebp
8010222c:	c3                   	ret    

8010222d <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
8010222d:	55                   	push   %ebp
8010222e:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102230:	ba 70 00 00 00       	mov    $0x70,%edx
80102235:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102236:	ba 71 00 00 00       	mov    $0x71,%edx
8010223b:	ec                   	in     (%dx),%al
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
8010223c:	0f b6 c0             	movzbl %al,%eax
}
8010223f:	5d                   	pop    %ebp
80102240:	c3                   	ret    

80102241 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
80102241:	55                   	push   %ebp
80102242:	89 e5                	mov    %esp,%ebp
80102244:	53                   	push   %ebx
80102245:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
80102247:	b8 00 00 00 00       	mov    $0x0,%eax
8010224c:	e8 dc ff ff ff       	call   8010222d <cmos_read>
80102251:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
80102253:	b8 02 00 00 00       	mov    $0x2,%eax
80102258:	e8 d0 ff ff ff       	call   8010222d <cmos_read>
8010225d:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
80102260:	b8 04 00 00 00       	mov    $0x4,%eax
80102265:	e8 c3 ff ff ff       	call   8010222d <cmos_read>
8010226a:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
8010226d:	b8 07 00 00 00       	mov    $0x7,%eax
80102272:	e8 b6 ff ff ff       	call   8010222d <cmos_read>
80102277:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
8010227a:	b8 08 00 00 00       	mov    $0x8,%eax
8010227f:	e8 a9 ff ff ff       	call   8010222d <cmos_read>
80102284:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
80102287:	b8 09 00 00 00       	mov    $0x9,%eax
8010228c:	e8 9c ff ff ff       	call   8010222d <cmos_read>
80102291:	89 43 14             	mov    %eax,0x14(%ebx)
}
80102294:	5b                   	pop    %ebx
80102295:	5d                   	pop    %ebp
80102296:	c3                   	ret    

80102297 <lapicinit>:
  if(!lapic)
80102297:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
8010229e:	0f 84 fb 00 00 00    	je     8010239f <lapicinit+0x108>
{
801022a4:	55                   	push   %ebp
801022a5:	89 e5                	mov    %esp,%ebp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801022a7:	ba 3f 01 00 00       	mov    $0x13f,%edx
801022ac:	b8 3c 00 00 00       	mov    $0x3c,%eax
801022b1:	e8 5f ff ff ff       	call   80102215 <lapicw>
  lapicw(TDCR, X1);
801022b6:	ba 0b 00 00 00       	mov    $0xb,%edx
801022bb:	b8 f8 00 00 00       	mov    $0xf8,%eax
801022c0:	e8 50 ff ff ff       	call   80102215 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801022c5:	ba 20 00 02 00       	mov    $0x20020,%edx
801022ca:	b8 c8 00 00 00       	mov    $0xc8,%eax
801022cf:	e8 41 ff ff ff       	call   80102215 <lapicw>
  lapicw(TICR, 10000000);
801022d4:	ba 80 96 98 00       	mov    $0x989680,%edx
801022d9:	b8 e0 00 00 00       	mov    $0xe0,%eax
801022de:	e8 32 ff ff ff       	call   80102215 <lapicw>
  lapicw(LINT0, MASKED);
801022e3:	ba 00 00 01 00       	mov    $0x10000,%edx
801022e8:	b8 d4 00 00 00       	mov    $0xd4,%eax
801022ed:	e8 23 ff ff ff       	call   80102215 <lapicw>
  lapicw(LINT1, MASKED);
801022f2:	ba 00 00 01 00       	mov    $0x10000,%edx
801022f7:	b8 d8 00 00 00       	mov    $0xd8,%eax
801022fc:	e8 14 ff ff ff       	call   80102215 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102301:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102306:	8b 40 30             	mov    0x30(%eax),%eax
80102309:	c1 e8 10             	shr    $0x10,%eax
8010230c:	3c 03                	cmp    $0x3,%al
8010230e:	77 7b                	ja     8010238b <lapicinit+0xf4>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102310:	ba 33 00 00 00       	mov    $0x33,%edx
80102315:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010231a:	e8 f6 fe ff ff       	call   80102215 <lapicw>
  lapicw(ESR, 0);
8010231f:	ba 00 00 00 00       	mov    $0x0,%edx
80102324:	b8 a0 00 00 00       	mov    $0xa0,%eax
80102329:	e8 e7 fe ff ff       	call   80102215 <lapicw>
  lapicw(ESR, 0);
8010232e:	ba 00 00 00 00       	mov    $0x0,%edx
80102333:	b8 a0 00 00 00       	mov    $0xa0,%eax
80102338:	e8 d8 fe ff ff       	call   80102215 <lapicw>
  lapicw(EOI, 0);
8010233d:	ba 00 00 00 00       	mov    $0x0,%edx
80102342:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102347:	e8 c9 fe ff ff       	call   80102215 <lapicw>
  lapicw(ICRHI, 0);
8010234c:	ba 00 00 00 00       	mov    $0x0,%edx
80102351:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102356:	e8 ba fe ff ff       	call   80102215 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010235b:	ba 00 85 08 00       	mov    $0x88500,%edx
80102360:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102365:	e8 ab fe ff ff       	call   80102215 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010236a:	a1 7c 26 11 80       	mov    0x8011267c,%eax
8010236f:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
80102375:	f6 c4 10             	test   $0x10,%ah
80102378:	75 f0                	jne    8010236a <lapicinit+0xd3>
  lapicw(TPR, 0);
8010237a:	ba 00 00 00 00       	mov    $0x0,%edx
8010237f:	b8 20 00 00 00       	mov    $0x20,%eax
80102384:	e8 8c fe ff ff       	call   80102215 <lapicw>
}
80102389:	5d                   	pop    %ebp
8010238a:	c3                   	ret    
    lapicw(PCINT, MASKED);
8010238b:	ba 00 00 01 00       	mov    $0x10000,%edx
80102390:	b8 d0 00 00 00       	mov    $0xd0,%eax
80102395:	e8 7b fe ff ff       	call   80102215 <lapicw>
8010239a:	e9 71 ff ff ff       	jmp    80102310 <lapicinit+0x79>
8010239f:	f3 c3                	repz ret 

801023a1 <lapicid>:
{
801023a1:	55                   	push   %ebp
801023a2:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801023a4:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023a9:	85 c0                	test   %eax,%eax
801023ab:	74 08                	je     801023b5 <lapicid+0x14>
  return lapic[ID] >> 24;
801023ad:	8b 40 20             	mov    0x20(%eax),%eax
801023b0:	c1 e8 18             	shr    $0x18,%eax
}
801023b3:	5d                   	pop    %ebp
801023b4:	c3                   	ret    
    return 0;
801023b5:	b8 00 00 00 00       	mov    $0x0,%eax
801023ba:	eb f7                	jmp    801023b3 <lapicid+0x12>

801023bc <lapiceoi>:
  if(lapic)
801023bc:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
801023c3:	74 14                	je     801023d9 <lapiceoi+0x1d>
{
801023c5:	55                   	push   %ebp
801023c6:	89 e5                	mov    %esp,%ebp
    lapicw(EOI, 0);
801023c8:	ba 00 00 00 00       	mov    $0x0,%edx
801023cd:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023d2:	e8 3e fe ff ff       	call   80102215 <lapicw>
}
801023d7:	5d                   	pop    %ebp
801023d8:	c3                   	ret    
801023d9:	f3 c3                	repz ret 

801023db <microdelay>:
{
801023db:	55                   	push   %ebp
801023dc:	89 e5                	mov    %esp,%ebp
}
801023de:	5d                   	pop    %ebp
801023df:	c3                   	ret    

801023e0 <lapicstartap>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	57                   	push   %edi
801023e4:	56                   	push   %esi
801023e5:	53                   	push   %ebx
801023e6:	8b 75 08             	mov    0x8(%ebp),%esi
801023e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023ec:	b8 0f 00 00 00       	mov    $0xf,%eax
801023f1:	ba 70 00 00 00       	mov    $0x70,%edx
801023f6:	ee                   	out    %al,(%dx)
801023f7:	b8 0a 00 00 00       	mov    $0xa,%eax
801023fc:	ba 71 00 00 00       	mov    $0x71,%edx
80102401:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102402:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102409:	00 00 
  wrv[1] = addr >> 4;
8010240b:	89 f8                	mov    %edi,%eax
8010240d:	c1 e8 04             	shr    $0x4,%eax
80102410:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
80102416:	c1 e6 18             	shl    $0x18,%esi
80102419:	89 f2                	mov    %esi,%edx
8010241b:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102420:	e8 f0 fd ff ff       	call   80102215 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102425:	ba 00 c5 00 00       	mov    $0xc500,%edx
8010242a:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010242f:	e8 e1 fd ff ff       	call   80102215 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
80102434:	ba 00 85 00 00       	mov    $0x8500,%edx
80102439:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010243e:	e8 d2 fd ff ff       	call   80102215 <lapicw>
  for(i = 0; i < 2; i++){
80102443:	bb 00 00 00 00       	mov    $0x0,%ebx
80102448:	eb 21                	jmp    8010246b <lapicstartap+0x8b>
    lapicw(ICRHI, apicid<<24);
8010244a:	89 f2                	mov    %esi,%edx
8010244c:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102451:	e8 bf fd ff ff       	call   80102215 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102456:	89 fa                	mov    %edi,%edx
80102458:	c1 ea 0c             	shr    $0xc,%edx
8010245b:	80 ce 06             	or     $0x6,%dh
8010245e:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102463:	e8 ad fd ff ff       	call   80102215 <lapicw>
  for(i = 0; i < 2; i++){
80102468:	83 c3 01             	add    $0x1,%ebx
8010246b:	83 fb 01             	cmp    $0x1,%ebx
8010246e:	7e da                	jle    8010244a <lapicstartap+0x6a>
}
80102470:	5b                   	pop    %ebx
80102471:	5e                   	pop    %esi
80102472:	5f                   	pop    %edi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    

80102475 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102475:	55                   	push   %ebp
80102476:	89 e5                	mov    %esp,%ebp
80102478:	57                   	push   %edi
80102479:	56                   	push   %esi
8010247a:	53                   	push   %ebx
8010247b:	83 ec 3c             	sub    $0x3c,%esp
8010247e:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80102481:	b8 0b 00 00 00       	mov    $0xb,%eax
80102486:	e8 a2 fd ff ff       	call   8010222d <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
8010248b:	83 e0 04             	and    $0x4,%eax
8010248e:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102490:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102493:	e8 a9 fd ff ff       	call   80102241 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102498:	b8 0a 00 00 00       	mov    $0xa,%eax
8010249d:	e8 8b fd ff ff       	call   8010222d <cmos_read>
801024a2:	a8 80                	test   $0x80,%al
801024a4:	75 ea                	jne    80102490 <cmostime+0x1b>
        continue;
    fill_rtcdate(&t2);
801024a6:	8d 5d b8             	lea    -0x48(%ebp),%ebx
801024a9:	89 d8                	mov    %ebx,%eax
801024ab:	e8 91 fd ff ff       	call   80102241 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801024b0:	83 ec 04             	sub    $0x4,%esp
801024b3:	6a 18                	push   $0x18
801024b5:	53                   	push   %ebx
801024b6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024b9:	50                   	push   %eax
801024ba:	e8 77 1d 00 00       	call   80104236 <memcmp>
801024bf:	83 c4 10             	add    $0x10,%esp
801024c2:	85 c0                	test   %eax,%eax
801024c4:	75 ca                	jne    80102490 <cmostime+0x1b>
      break;
  }

  // convert
  if(bcd) {
801024c6:	85 ff                	test   %edi,%edi
801024c8:	0f 85 84 00 00 00    	jne    80102552 <cmostime+0xdd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801024ce:	8b 55 d0             	mov    -0x30(%ebp),%edx
801024d1:	89 d0                	mov    %edx,%eax
801024d3:	c1 e8 04             	shr    $0x4,%eax
801024d6:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801024d9:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
801024dc:	83 e2 0f             	and    $0xf,%edx
801024df:	01 d0                	add    %edx,%eax
801024e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
801024e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801024e7:	89 d0                	mov    %edx,%eax
801024e9:	c1 e8 04             	shr    $0x4,%eax
801024ec:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801024ef:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
801024f2:	83 e2 0f             	and    $0xf,%edx
801024f5:	01 d0                	add    %edx,%eax
801024f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801024fa:	8b 55 d8             	mov    -0x28(%ebp),%edx
801024fd:	89 d0                	mov    %edx,%eax
801024ff:	c1 e8 04             	shr    $0x4,%eax
80102502:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102505:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
80102508:	83 e2 0f             	and    $0xf,%edx
8010250b:	01 d0                	add    %edx,%eax
8010250d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102510:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102513:	89 d0                	mov    %edx,%eax
80102515:	c1 e8 04             	shr    $0x4,%eax
80102518:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010251b:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
8010251e:	83 e2 0f             	and    $0xf,%edx
80102521:	01 d0                	add    %edx,%eax
80102523:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
80102526:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102529:	89 d0                	mov    %edx,%eax
8010252b:	c1 e8 04             	shr    $0x4,%eax
8010252e:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102531:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
80102534:	83 e2 0f             	and    $0xf,%edx
80102537:	01 d0                	add    %edx,%eax
80102539:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010253c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010253f:	89 d0                	mov    %edx,%eax
80102541:	c1 e8 04             	shr    $0x4,%eax
80102544:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102547:	8d 04 09             	lea    (%ecx,%ecx,1),%eax
8010254a:	83 e2 0f             	and    $0xf,%edx
8010254d:	01 d0                	add    %edx,%eax
8010254f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102552:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102555:	89 06                	mov    %eax,(%esi)
80102557:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010255a:	89 46 04             	mov    %eax,0x4(%esi)
8010255d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102560:	89 46 08             	mov    %eax,0x8(%esi)
80102563:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102566:	89 46 0c             	mov    %eax,0xc(%esi)
80102569:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010256c:	89 46 10             	mov    %eax,0x10(%esi)
8010256f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102572:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102575:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010257c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010257f:	5b                   	pop    %ebx
80102580:	5e                   	pop    %esi
80102581:	5f                   	pop    %edi
80102582:	5d                   	pop    %ebp
80102583:	c3                   	ret    

80102584 <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80102584:	55                   	push   %ebp
80102585:	89 e5                	mov    %esp,%ebp
80102587:	53                   	push   %ebx
80102588:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010258b:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102591:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102597:	e8 d0 db ff ff       	call   8010016c <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
8010259c:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010259f:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
801025a5:	83 c4 10             	add    $0x10,%esp
801025a8:	ba 00 00 00 00       	mov    $0x0,%edx
801025ad:	eb 0e                	jmp    801025bd <read_head+0x39>
    log.lh.block[i] = lh->block[i];
801025af:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801025b3:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801025ba:	83 c2 01             	add    $0x1,%edx
801025bd:	39 d3                	cmp    %edx,%ebx
801025bf:	7f ee                	jg     801025af <read_head+0x2b>
  }
  brelse(buf);
801025c1:	83 ec 0c             	sub    $0xc,%esp
801025c4:	50                   	push   %eax
801025c5:	e8 0b dc ff ff       	call   801001d5 <brelse>
}
801025ca:	83 c4 10             	add    $0x10,%esp
801025cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025d0:	c9                   	leave  
801025d1:	c3                   	ret    

801025d2 <install_trans>:
{
801025d2:	55                   	push   %ebp
801025d3:	89 e5                	mov    %esp,%ebp
801025d5:	57                   	push   %edi
801025d6:	56                   	push   %esi
801025d7:	53                   	push   %ebx
801025d8:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801025db:	bb 00 00 00 00       	mov    $0x0,%ebx
801025e0:	eb 66                	jmp    80102648 <install_trans+0x76>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801025e2:	89 d8                	mov    %ebx,%eax
801025e4:	03 05 b4 26 11 80    	add    0x801126b4,%eax
801025ea:	83 c0 01             	add    $0x1,%eax
801025ed:	83 ec 08             	sub    $0x8,%esp
801025f0:	50                   	push   %eax
801025f1:	ff 35 c4 26 11 80    	pushl  0x801126c4
801025f7:	e8 70 db ff ff       	call   8010016c <bread>
801025fc:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801025fe:	83 c4 08             	add    $0x8,%esp
80102601:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102608:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010260e:	e8 59 db ff ff       	call   8010016c <bread>
80102613:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102615:	8d 57 5c             	lea    0x5c(%edi),%edx
80102618:	8d 40 5c             	lea    0x5c(%eax),%eax
8010261b:	83 c4 0c             	add    $0xc,%esp
8010261e:	68 00 02 00 00       	push   $0x200
80102623:	52                   	push   %edx
80102624:	50                   	push   %eax
80102625:	e8 41 1c 00 00       	call   8010426b <memmove>
    bwrite(dbuf);  // write dst to disk
8010262a:	89 34 24             	mov    %esi,(%esp)
8010262d:	e8 68 db ff ff       	call   8010019a <bwrite>
    brelse(lbuf);
80102632:	89 3c 24             	mov    %edi,(%esp)
80102635:	e8 9b db ff ff       	call   801001d5 <brelse>
    brelse(dbuf);
8010263a:	89 34 24             	mov    %esi,(%esp)
8010263d:	e8 93 db ff ff       	call   801001d5 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102642:	83 c3 01             	add    $0x1,%ebx
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
8010264e:	7f 92                	jg     801025e2 <install_trans+0x10>
}
80102650:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102653:	5b                   	pop    %ebx
80102654:	5e                   	pop    %esi
80102655:	5f                   	pop    %edi
80102656:	5d                   	pop    %ebp
80102657:	c3                   	ret    

80102658 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	53                   	push   %ebx
8010265c:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
8010265f:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102665:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010266b:	e8 fc da ff ff       	call   8010016c <bread>
80102670:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102672:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102678:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010267b:	83 c4 10             	add    $0x10,%esp
8010267e:	b8 00 00 00 00       	mov    $0x0,%eax
80102683:	eb 0e                	jmp    80102693 <write_head+0x3b>
    hb->block[i] = log.lh.block[i];
80102685:	8b 14 85 cc 26 11 80 	mov    -0x7feed934(,%eax,4),%edx
8010268c:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102690:	83 c0 01             	add    $0x1,%eax
80102693:	39 c1                	cmp    %eax,%ecx
80102695:	7f ee                	jg     80102685 <write_head+0x2d>
  }
  bwrite(buf);
80102697:	83 ec 0c             	sub    $0xc,%esp
8010269a:	53                   	push   %ebx
8010269b:	e8 fa da ff ff       	call   8010019a <bwrite>
  brelse(buf);
801026a0:	89 1c 24             	mov    %ebx,(%esp)
801026a3:	e8 2d db ff ff       	call   801001d5 <brelse>
}
801026a8:	83 c4 10             	add    $0x10,%esp
801026ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026ae:	c9                   	leave  
801026af:	c3                   	ret    

801026b0 <recover_from_log>:

static void
recover_from_log(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	83 ec 08             	sub    $0x8,%esp
  read_head();
801026b6:	e8 c9 fe ff ff       	call   80102584 <read_head>
  install_trans(); // if committed, copy from log to disk
801026bb:	e8 12 ff ff ff       	call   801025d2 <install_trans>
  log.lh.n = 0;
801026c0:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801026c7:	00 00 00 
  write_head(); // clear the log
801026ca:	e8 89 ff ff ff       	call   80102658 <write_head>
}
801026cf:	c9                   	leave  
801026d0:	c3                   	ret    

801026d1 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801026d1:	55                   	push   %ebp
801026d2:	89 e5                	mov    %esp,%ebp
801026d4:	57                   	push   %edi
801026d5:	56                   	push   %esi
801026d6:	53                   	push   %ebx
801026d7:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026da:	bb 00 00 00 00       	mov    $0x0,%ebx
801026df:	eb 66                	jmp    80102747 <write_log+0x76>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801026e1:	89 d8                	mov    %ebx,%eax
801026e3:	03 05 b4 26 11 80    	add    0x801126b4,%eax
801026e9:	83 c0 01             	add    $0x1,%eax
801026ec:	83 ec 08             	sub    $0x8,%esp
801026ef:	50                   	push   %eax
801026f0:	ff 35 c4 26 11 80    	pushl  0x801126c4
801026f6:	e8 71 da ff ff       	call   8010016c <bread>
801026fb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801026fd:	83 c4 08             	add    $0x8,%esp
80102700:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102707:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010270d:	e8 5a da ff ff       	call   8010016c <bread>
80102712:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102714:	8d 50 5c             	lea    0x5c(%eax),%edx
80102717:	8d 46 5c             	lea    0x5c(%esi),%eax
8010271a:	83 c4 0c             	add    $0xc,%esp
8010271d:	68 00 02 00 00       	push   $0x200
80102722:	52                   	push   %edx
80102723:	50                   	push   %eax
80102724:	e8 42 1b 00 00       	call   8010426b <memmove>
    bwrite(to);  // write the log
80102729:	89 34 24             	mov    %esi,(%esp)
8010272c:	e8 69 da ff ff       	call   8010019a <bwrite>
    brelse(from);
80102731:	89 3c 24             	mov    %edi,(%esp)
80102734:	e8 9c da ff ff       	call   801001d5 <brelse>
    brelse(to);
80102739:	89 34 24             	mov    %esi,(%esp)
8010273c:	e8 94 da ff ff       	call   801001d5 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102741:	83 c3 01             	add    $0x1,%ebx
80102744:	83 c4 10             	add    $0x10,%esp
80102747:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
8010274d:	7f 92                	jg     801026e1 <write_log+0x10>
  }
}
8010274f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102752:	5b                   	pop    %ebx
80102753:	5e                   	pop    %esi
80102754:	5f                   	pop    %edi
80102755:	5d                   	pop    %ebp
80102756:	c3                   	ret    

80102757 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102757:	83 3d c8 26 11 80 00 	cmpl   $0x0,0x801126c8
8010275e:	7e 26                	jle    80102786 <commit+0x2f>
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102766:	e8 66 ff ff ff       	call   801026d1 <write_log>
    write_head();    // Write header to disk -- the real commit
8010276b:	e8 e8 fe ff ff       	call   80102658 <write_head>
    install_trans(); // Now install writes to home locations
80102770:	e8 5d fe ff ff       	call   801025d2 <install_trans>
    log.lh.n = 0;
80102775:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010277c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010277f:	e8 d4 fe ff ff       	call   80102658 <write_head>
  }
}
80102784:	c9                   	leave  
80102785:	c3                   	ret    
80102786:	f3 c3                	repz ret 

80102788 <initlog>:
{
80102788:	55                   	push   %ebp
80102789:	89 e5                	mov    %esp,%ebp
8010278b:	53                   	push   %ebx
8010278c:	83 ec 2c             	sub    $0x2c,%esp
8010278f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102792:	68 40 6f 10 80       	push   $0x80106f40
80102797:	68 80 26 11 80       	push   $0x80112680
8010279c:	e8 67 18 00 00       	call   80104008 <initlock>
  readsb(dev, &sb);
801027a1:	83 c4 08             	add    $0x8,%esp
801027a4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801027a7:	50                   	push   %eax
801027a8:	53                   	push   %ebx
801027a9:	e8 2d eb ff ff       	call   801012db <readsb>
  log.start = sb.logstart;
801027ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027b1:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
801027b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801027b9:	a3 b8 26 11 80       	mov    %eax,0x801126b8
  log.dev = dev;
801027be:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  recover_from_log();
801027c4:	e8 e7 fe ff ff       	call   801026b0 <recover_from_log>
}
801027c9:	83 c4 10             	add    $0x10,%esp
801027cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027cf:	c9                   	leave  
801027d0:	c3                   	ret    

801027d1 <begin_op>:
{
801027d1:	55                   	push   %ebp
801027d2:	89 e5                	mov    %esp,%ebp
801027d4:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801027d7:	68 80 26 11 80       	push   $0x80112680
801027dc:	e8 63 19 00 00       	call   80104144 <acquire>
801027e1:	83 c4 10             	add    $0x10,%esp
801027e4:	eb 15                	jmp    801027fb <begin_op+0x2a>
      sleep(&log, &log.lock);
801027e6:	83 ec 08             	sub    $0x8,%esp
801027e9:	68 80 26 11 80       	push   $0x80112680
801027ee:	68 80 26 11 80       	push   $0x80112680
801027f3:	e8 44 11 00 00       	call   8010393c <sleep>
801027f8:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801027fb:	83 3d c0 26 11 80 00 	cmpl   $0x0,0x801126c0
80102802:	75 e2                	jne    801027e6 <begin_op+0x15>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102804:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102809:	83 c0 01             	add    $0x1,%eax
8010280c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010280f:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
80102812:	03 15 c8 26 11 80    	add    0x801126c8,%edx
80102818:	83 fa 1e             	cmp    $0x1e,%edx
8010281b:	7e 17                	jle    80102834 <begin_op+0x63>
      sleep(&log, &log.lock);
8010281d:	83 ec 08             	sub    $0x8,%esp
80102820:	68 80 26 11 80       	push   $0x80112680
80102825:	68 80 26 11 80       	push   $0x80112680
8010282a:	e8 0d 11 00 00       	call   8010393c <sleep>
8010282f:	83 c4 10             	add    $0x10,%esp
80102832:	eb c7                	jmp    801027fb <begin_op+0x2a>
      log.outstanding += 1;
80102834:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102839:	83 ec 0c             	sub    $0xc,%esp
8010283c:	68 80 26 11 80       	push   $0x80112680
80102841:	e8 63 19 00 00       	call   801041a9 <release>
}
80102846:	83 c4 10             	add    $0x10,%esp
80102849:	c9                   	leave  
8010284a:	c3                   	ret    

8010284b <end_op>:
{
8010284b:	55                   	push   %ebp
8010284c:	89 e5                	mov    %esp,%ebp
8010284e:	53                   	push   %ebx
8010284f:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
80102852:	68 80 26 11 80       	push   $0x80112680
80102857:	e8 e8 18 00 00       	call   80104144 <acquire>
  log.outstanding -= 1;
8010285c:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102861:	83 e8 01             	sub    $0x1,%eax
80102864:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102869:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
8010286f:	83 c4 10             	add    $0x10,%esp
80102872:	85 db                	test   %ebx,%ebx
80102874:	75 2c                	jne    801028a2 <end_op+0x57>
  if(log.outstanding == 0){
80102876:	85 c0                	test   %eax,%eax
80102878:	75 35                	jne    801028af <end_op+0x64>
    log.committing = 1;
8010287a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102881:	00 00 00 
    do_commit = 1;
80102884:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102889:	83 ec 0c             	sub    $0xc,%esp
8010288c:	68 80 26 11 80       	push   $0x80112680
80102891:	e8 13 19 00 00       	call   801041a9 <release>
  if(do_commit){
80102896:	83 c4 10             	add    $0x10,%esp
80102899:	85 db                	test   %ebx,%ebx
8010289b:	75 24                	jne    801028c1 <end_op+0x76>
}
8010289d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028a0:	c9                   	leave  
801028a1:	c3                   	ret    
    panic("log.committing");
801028a2:	83 ec 0c             	sub    $0xc,%esp
801028a5:	68 44 6f 10 80       	push   $0x80106f44
801028aa:	e8 99 da ff ff       	call   80100348 <panic>
    wakeup(&log);
801028af:	83 ec 0c             	sub    $0xc,%esp
801028b2:	68 80 26 11 80       	push   $0x80112680
801028b7:	e8 2c 11 00 00       	call   801039e8 <wakeup>
801028bc:	83 c4 10             	add    $0x10,%esp
801028bf:	eb c8                	jmp    80102889 <end_op+0x3e>
    commit();
801028c1:	e8 91 fe ff ff       	call   80102757 <commit>
    acquire(&log.lock);
801028c6:	83 ec 0c             	sub    $0xc,%esp
801028c9:	68 80 26 11 80       	push   $0x80112680
801028ce:	e8 71 18 00 00       	call   80104144 <acquire>
    log.committing = 0;
801028d3:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801028da:	00 00 00 
    wakeup(&log);
801028dd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028e4:	e8 ff 10 00 00       	call   801039e8 <wakeup>
    release(&log.lock);
801028e9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028f0:	e8 b4 18 00 00       	call   801041a9 <release>
801028f5:	83 c4 10             	add    $0x10,%esp
}
801028f8:	eb a3                	jmp    8010289d <end_op+0x52>

801028fa <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801028fa:	55                   	push   %ebp
801028fb:	89 e5                	mov    %esp,%ebp
801028fd:	53                   	push   %ebx
801028fe:	83 ec 04             	sub    $0x4,%esp
80102901:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102904:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
8010290a:	83 fa 1d             	cmp    $0x1d,%edx
8010290d:	7f 45                	jg     80102954 <log_write+0x5a>
8010290f:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102914:	83 e8 01             	sub    $0x1,%eax
80102917:	39 c2                	cmp    %eax,%edx
80102919:	7d 39                	jge    80102954 <log_write+0x5a>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010291b:	83 3d bc 26 11 80 00 	cmpl   $0x0,0x801126bc
80102922:	7e 3d                	jle    80102961 <log_write+0x67>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102924:	83 ec 0c             	sub    $0xc,%esp
80102927:	68 80 26 11 80       	push   $0x80112680
8010292c:	e8 13 18 00 00       	call   80104144 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102931:	83 c4 10             	add    $0x10,%esp
80102934:	b8 00 00 00 00       	mov    $0x0,%eax
80102939:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
8010293f:	39 c2                	cmp    %eax,%edx
80102941:	7e 2b                	jle    8010296e <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102943:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102946:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
8010294d:	74 1f                	je     8010296e <log_write+0x74>
  for (i = 0; i < log.lh.n; i++) {
8010294f:	83 c0 01             	add    $0x1,%eax
80102952:	eb e5                	jmp    80102939 <log_write+0x3f>
    panic("too big a transaction");
80102954:	83 ec 0c             	sub    $0xc,%esp
80102957:	68 53 6f 10 80       	push   $0x80106f53
8010295c:	e8 e7 d9 ff ff       	call   80100348 <panic>
    panic("log_write outside of trans");
80102961:	83 ec 0c             	sub    $0xc,%esp
80102964:	68 69 6f 10 80       	push   $0x80106f69
80102969:	e8 da d9 ff ff       	call   80100348 <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
8010296e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102971:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102978:	39 c2                	cmp    %eax,%edx
8010297a:	74 18                	je     80102994 <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010297c:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
8010297f:	83 ec 0c             	sub    $0xc,%esp
80102982:	68 80 26 11 80       	push   $0x80112680
80102987:	e8 1d 18 00 00       	call   801041a9 <release>
}
8010298c:	83 c4 10             	add    $0x10,%esp
8010298f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102992:	c9                   	leave  
80102993:	c3                   	ret    
    log.lh.n++;
80102994:	83 c2 01             	add    $0x1,%edx
80102997:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
8010299d:	eb dd                	jmp    8010297c <log_write+0x82>

8010299f <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010299f:	55                   	push   %ebp
801029a0:	89 e5                	mov    %esp,%ebp
801029a2:	53                   	push   %ebx
801029a3:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801029a6:	68 8a 00 00 00       	push   $0x8a
801029ab:	68 8c a4 10 80       	push   $0x8010a48c
801029b0:	68 00 70 00 80       	push   $0x80007000
801029b5:	e8 b1 18 00 00       	call   8010426b <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801029ba:	83 c4 10             	add    $0x10,%esp
801029bd:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801029c2:	eb 06                	jmp    801029ca <startothers+0x2b>
801029c4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801029ca:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801029d1:	00 00 00 
801029d4:	05 80 27 11 80       	add    $0x80112780,%eax
801029d9:	39 d8                	cmp    %ebx,%eax
801029db:	76 4c                	jbe    80102a29 <startothers+0x8a>
    if(c == mycpu())  // We've started already.
801029dd:	e8 66 07 00 00       	call   80103148 <mycpu>
801029e2:	39 d8                	cmp    %ebx,%eax
801029e4:	74 de                	je     801029c4 <startothers+0x25>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801029e6:	e8 f3 f6 ff ff       	call   801020de <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801029eb:	05 00 10 00 00       	add    $0x1000,%eax
801029f0:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
801029f5:	c7 05 f8 6f 00 80 6d 	movl   $0x80102a6d,0x80006ff8
801029fc:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801029ff:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102a06:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102a09:	83 ec 08             	sub    $0x8,%esp
80102a0c:	68 00 70 00 00       	push   $0x7000
80102a11:	0f b6 03             	movzbl (%ebx),%eax
80102a14:	50                   	push   %eax
80102a15:	e8 c6 f9 ff ff       	call   801023e0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102a1a:	83 c4 10             	add    $0x10,%esp
80102a1d:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102a23:	85 c0                	test   %eax,%eax
80102a25:	74 f6                	je     80102a1d <startothers+0x7e>
80102a27:	eb 9b                	jmp    801029c4 <startothers+0x25>
      ;
  }
}
80102a29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a2c:	c9                   	leave  
80102a2d:	c3                   	ret    

80102a2e <mpmain>:
{
80102a2e:	55                   	push   %ebp
80102a2f:	89 e5                	mov    %esp,%ebp
80102a31:	53                   	push   %ebx
80102a32:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a35:	e8 6a 07 00 00       	call   801031a4 <cpuid>
80102a3a:	89 c3                	mov    %eax,%ebx
80102a3c:	e8 63 07 00 00       	call   801031a4 <cpuid>
80102a41:	83 ec 04             	sub    $0x4,%esp
80102a44:	53                   	push   %ebx
80102a45:	50                   	push   %eax
80102a46:	68 84 6f 10 80       	push   $0x80106f84
80102a4b:	e8 bb db ff ff       	call   8010060b <cprintf>
  idtinit();       // load idt register
80102a50:	e8 d2 29 00 00       	call   80105427 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a55:	e8 ee 06 00 00       	call   80103148 <mycpu>
80102a5a:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a5c:	b8 01 00 00 00       	mov    $0x1,%eax
80102a61:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a68:	e8 61 0a 00 00       	call   801034ce <scheduler>

80102a6d <mpenter>:
{
80102a6d:	55                   	push   %ebp
80102a6e:	89 e5                	mov    %esp,%ebp
80102a70:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a73:	e8 b8 39 00 00       	call   80106430 <switchkvm>
  seginit();
80102a78:	e8 67 38 00 00       	call   801062e4 <seginit>
  lapicinit();
80102a7d:	e8 15 f8 ff ff       	call   80102297 <lapicinit>
  mpmain();
80102a82:	e8 a7 ff ff ff       	call   80102a2e <mpmain>

80102a87 <main>:
{
80102a87:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102a8b:	83 e4 f0             	and    $0xfffffff0,%esp
80102a8e:	ff 71 fc             	pushl  -0x4(%ecx)
80102a91:	55                   	push   %ebp
80102a92:	89 e5                	mov    %esp,%ebp
80102a94:	51                   	push   %ecx
80102a95:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102a98:	68 00 00 40 80       	push   $0x80400000
80102a9d:	68 a8 79 11 80       	push   $0x801179a8
80102aa2:	e8 e5 f5 ff ff       	call   8010208c <kinit1>
  kvmalloc();      // kernel page table
80102aa7:	e8 11 3e 00 00       	call   801068bd <kvmalloc>
  mpinit();        // detect other processors
80102aac:	e8 c9 01 00 00       	call   80102c7a <mpinit>
  lapicinit();     // interrupt controller
80102ab1:	e8 e1 f7 ff ff       	call   80102297 <lapicinit>
  seginit();       // segment descriptors
80102ab6:	e8 29 38 00 00       	call   801062e4 <seginit>
  picinit();       // disable pic
80102abb:	e8 82 02 00 00       	call   80102d42 <picinit>
  ioapicinit();    // another interrupt controller
80102ac0:	e8 58 f4 ff ff       	call   80101f1d <ioapicinit>
  consoleinit();   // console hardware
80102ac5:	e8 c4 dd ff ff       	call   8010088e <consoleinit>
  uartinit();      // serial port
80102aca:	e8 06 2c 00 00       	call   801056d5 <uartinit>
  pinit();         // process table
80102acf:	e8 5a 06 00 00       	call   8010312e <pinit>
  tvinit();        // trap vectors
80102ad4:	e8 9d 28 00 00       	call   80105376 <tvinit>
  binit();         // buffer cache
80102ad9:	e8 16 d6 ff ff       	call   801000f4 <binit>
  fileinit();      // file table
80102ade:	e8 65 e1 ff ff       	call   80100c48 <fileinit>
  ideinit();       // disk 
80102ae3:	e8 3b f2 ff ff       	call   80101d23 <ideinit>
  startothers();   // start other processors
80102ae8:	e8 b2 fe ff ff       	call   8010299f <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102aed:	83 c4 08             	add    $0x8,%esp
80102af0:	68 00 00 00 8e       	push   $0x8e000000
80102af5:	68 00 00 40 80       	push   $0x80400000
80102afa:	e8 bf f5 ff ff       	call   801020be <kinit2>
  userinit();      // first user process
80102aff:	e8 19 08 00 00       	call   8010331d <userinit>
  mpmain();        // finish this processor's setup
80102b04:	e8 25 ff ff ff       	call   80102a2e <mpmain>

80102b09 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102b09:	55                   	push   %ebp
80102b0a:	89 e5                	mov    %esp,%ebp
80102b0c:	56                   	push   %esi
80102b0d:	53                   	push   %ebx
  int i, sum;

  sum = 0;
80102b0e:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(i=0; i<len; i++)
80102b13:	b9 00 00 00 00       	mov    $0x0,%ecx
80102b18:	eb 09                	jmp    80102b23 <sum+0x1a>
    sum += addr[i];
80102b1a:	0f b6 34 08          	movzbl (%eax,%ecx,1),%esi
80102b1e:	01 f3                	add    %esi,%ebx
  for(i=0; i<len; i++)
80102b20:	83 c1 01             	add    $0x1,%ecx
80102b23:	39 d1                	cmp    %edx,%ecx
80102b25:	7c f3                	jl     80102b1a <sum+0x11>
  return sum;
}
80102b27:	89 d8                	mov    %ebx,%eax
80102b29:	5b                   	pop    %ebx
80102b2a:	5e                   	pop    %esi
80102b2b:	5d                   	pop    %ebp
80102b2c:	c3                   	ret    

80102b2d <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102b2d:	55                   	push   %ebp
80102b2e:	89 e5                	mov    %esp,%ebp
80102b30:	56                   	push   %esi
80102b31:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102b32:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102b38:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102b3a:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102b3c:	eb 03                	jmp    80102b41 <mpsearch1+0x14>
80102b3e:	83 c3 10             	add    $0x10,%ebx
80102b41:	39 f3                	cmp    %esi,%ebx
80102b43:	73 29                	jae    80102b6e <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b45:	83 ec 04             	sub    $0x4,%esp
80102b48:	6a 04                	push   $0x4
80102b4a:	68 98 6f 10 80       	push   $0x80106f98
80102b4f:	53                   	push   %ebx
80102b50:	e8 e1 16 00 00       	call   80104236 <memcmp>
80102b55:	83 c4 10             	add    $0x10,%esp
80102b58:	85 c0                	test   %eax,%eax
80102b5a:	75 e2                	jne    80102b3e <mpsearch1+0x11>
80102b5c:	ba 10 00 00 00       	mov    $0x10,%edx
80102b61:	89 d8                	mov    %ebx,%eax
80102b63:	e8 a1 ff ff ff       	call   80102b09 <sum>
80102b68:	84 c0                	test   %al,%al
80102b6a:	75 d2                	jne    80102b3e <mpsearch1+0x11>
80102b6c:	eb 05                	jmp    80102b73 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102b6e:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102b73:	89 d8                	mov    %ebx,%eax
80102b75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b78:	5b                   	pop    %ebx
80102b79:	5e                   	pop    %esi
80102b7a:	5d                   	pop    %ebp
80102b7b:	c3                   	ret    

80102b7c <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102b7c:	55                   	push   %ebp
80102b7d:	89 e5                	mov    %esp,%ebp
80102b7f:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102b82:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102b89:	c1 e0 08             	shl    $0x8,%eax
80102b8c:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102b93:	09 d0                	or     %edx,%eax
80102b95:	c1 e0 04             	shl    $0x4,%eax
80102b98:	85 c0                	test   %eax,%eax
80102b9a:	74 1f                	je     80102bbb <mpsearch+0x3f>
    if((mp = mpsearch1(p, 1024)))
80102b9c:	ba 00 04 00 00       	mov    $0x400,%edx
80102ba1:	e8 87 ff ff ff       	call   80102b2d <mpsearch1>
80102ba6:	85 c0                	test   %eax,%eax
80102ba8:	75 0f                	jne    80102bb9 <mpsearch+0x3d>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102baa:	ba 00 00 01 00       	mov    $0x10000,%edx
80102baf:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102bb4:	e8 74 ff ff ff       	call   80102b2d <mpsearch1>
}
80102bb9:	c9                   	leave  
80102bba:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102bbb:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102bc2:	c1 e0 08             	shl    $0x8,%eax
80102bc5:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102bcc:	09 d0                	or     %edx,%eax
80102bce:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102bd1:	2d 00 04 00 00       	sub    $0x400,%eax
80102bd6:	ba 00 04 00 00       	mov    $0x400,%edx
80102bdb:	e8 4d ff ff ff       	call   80102b2d <mpsearch1>
80102be0:	85 c0                	test   %eax,%eax
80102be2:	75 d5                	jne    80102bb9 <mpsearch+0x3d>
80102be4:	eb c4                	jmp    80102baa <mpsearch+0x2e>

80102be6 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102be6:	55                   	push   %ebp
80102be7:	89 e5                	mov    %esp,%ebp
80102be9:	57                   	push   %edi
80102bea:	56                   	push   %esi
80102beb:	53                   	push   %ebx
80102bec:	83 ec 1c             	sub    $0x1c,%esp
80102bef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102bf2:	e8 85 ff ff ff       	call   80102b7c <mpsearch>
80102bf7:	85 c0                	test   %eax,%eax
80102bf9:	74 5c                	je     80102c57 <mpconfig+0x71>
80102bfb:	89 c7                	mov    %eax,%edi
80102bfd:	8b 58 04             	mov    0x4(%eax),%ebx
80102c00:	85 db                	test   %ebx,%ebx
80102c02:	74 5a                	je     80102c5e <mpconfig+0x78>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c04:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c0a:	83 ec 04             	sub    $0x4,%esp
80102c0d:	6a 04                	push   $0x4
80102c0f:	68 9d 6f 10 80       	push   $0x80106f9d
80102c14:	56                   	push   %esi
80102c15:	e8 1c 16 00 00       	call   80104236 <memcmp>
80102c1a:	83 c4 10             	add    $0x10,%esp
80102c1d:	85 c0                	test   %eax,%eax
80102c1f:	75 44                	jne    80102c65 <mpconfig+0x7f>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102c21:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80102c28:	3c 01                	cmp    $0x1,%al
80102c2a:	0f 95 c2             	setne  %dl
80102c2d:	3c 04                	cmp    $0x4,%al
80102c2f:	0f 95 c0             	setne  %al
80102c32:	84 c2                	test   %al,%dl
80102c34:	75 36                	jne    80102c6c <mpconfig+0x86>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102c36:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80102c3d:	89 f0                	mov    %esi,%eax
80102c3f:	e8 c5 fe ff ff       	call   80102b09 <sum>
80102c44:	84 c0                	test   %al,%al
80102c46:	75 2b                	jne    80102c73 <mpconfig+0x8d>
    return 0;
  *pmp = mp;
80102c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c4b:	89 38                	mov    %edi,(%eax)
  return conf;
}
80102c4d:	89 f0                	mov    %esi,%eax
80102c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c52:	5b                   	pop    %ebx
80102c53:	5e                   	pop    %esi
80102c54:	5f                   	pop    %edi
80102c55:	5d                   	pop    %ebp
80102c56:	c3                   	ret    
    return 0;
80102c57:	be 00 00 00 00       	mov    $0x0,%esi
80102c5c:	eb ef                	jmp    80102c4d <mpconfig+0x67>
80102c5e:	be 00 00 00 00       	mov    $0x0,%esi
80102c63:	eb e8                	jmp    80102c4d <mpconfig+0x67>
    return 0;
80102c65:	be 00 00 00 00       	mov    $0x0,%esi
80102c6a:	eb e1                	jmp    80102c4d <mpconfig+0x67>
    return 0;
80102c6c:	be 00 00 00 00       	mov    $0x0,%esi
80102c71:	eb da                	jmp    80102c4d <mpconfig+0x67>
    return 0;
80102c73:	be 00 00 00 00       	mov    $0x0,%esi
80102c78:	eb d3                	jmp    80102c4d <mpconfig+0x67>

80102c7a <mpinit>:

void
mpinit(void)
{
80102c7a:	55                   	push   %ebp
80102c7b:	89 e5                	mov    %esp,%ebp
80102c7d:	57                   	push   %edi
80102c7e:	56                   	push   %esi
80102c7f:	53                   	push   %ebx
80102c80:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c83:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102c86:	e8 5b ff ff ff       	call   80102be6 <mpconfig>
80102c8b:	85 c0                	test   %eax,%eax
80102c8d:	74 19                	je     80102ca8 <mpinit+0x2e>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102c8f:	8b 50 24             	mov    0x24(%eax),%edx
80102c92:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c98:	8d 50 2c             	lea    0x2c(%eax),%edx
80102c9b:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102c9f:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102ca1:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ca6:	eb 34                	jmp    80102cdc <mpinit+0x62>
    panic("Expect to run on an SMP");
80102ca8:	83 ec 0c             	sub    $0xc,%esp
80102cab:	68 a2 6f 10 80       	push   $0x80106fa2
80102cb0:	e8 93 d6 ff ff       	call   80100348 <panic>
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80102cb5:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80102cbb:	83 fe 07             	cmp    $0x7,%esi
80102cbe:	7f 19                	jg     80102cd9 <mpinit+0x5f>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102cc0:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102cc4:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102cca:	88 87 80 27 11 80    	mov    %al,-0x7feed880(%edi)
        ncpu++;
80102cd0:	83 c6 01             	add    $0x1,%esi
80102cd3:	89 35 00 2d 11 80    	mov    %esi,0x80112d00
      }
      p += sizeof(struct mpproc);
80102cd9:	83 c2 14             	add    $0x14,%edx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cdc:	39 ca                	cmp    %ecx,%edx
80102cde:	73 2b                	jae    80102d0b <mpinit+0x91>
    switch(*p){
80102ce0:	0f b6 02             	movzbl (%edx),%eax
80102ce3:	3c 04                	cmp    $0x4,%al
80102ce5:	77 1d                	ja     80102d04 <mpinit+0x8a>
80102ce7:	0f b6 c0             	movzbl %al,%eax
80102cea:	ff 24 85 dc 6f 10 80 	jmp    *-0x7fef9024(,%eax,4)
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80102cf1:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102cf5:	a2 60 27 11 80       	mov    %al,0x80112760
      p += sizeof(struct mpioapic);
80102cfa:	83 c2 08             	add    $0x8,%edx
      continue;
80102cfd:	eb dd                	jmp    80102cdc <mpinit+0x62>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102cff:	83 c2 08             	add    $0x8,%edx
      continue;
80102d02:	eb d8                	jmp    80102cdc <mpinit+0x62>
    default:
      ismp = 0;
80102d04:	bb 00 00 00 00       	mov    $0x0,%ebx
80102d09:	eb d1                	jmp    80102cdc <mpinit+0x62>
      break;
    }
  }
  if(!ismp)
80102d0b:	85 db                	test   %ebx,%ebx
80102d0d:	74 26                	je     80102d35 <mpinit+0xbb>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d12:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d16:	74 15                	je     80102d2d <mpinit+0xb3>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d18:	b8 70 00 00 00       	mov    $0x70,%eax
80102d1d:	ba 22 00 00 00       	mov    $0x22,%edx
80102d22:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d23:	ba 23 00 00 00       	mov    $0x23,%edx
80102d28:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102d29:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d2c:	ee                   	out    %al,(%dx)
  }
}
80102d2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d30:	5b                   	pop    %ebx
80102d31:	5e                   	pop    %esi
80102d32:	5f                   	pop    %edi
80102d33:	5d                   	pop    %ebp
80102d34:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102d35:	83 ec 0c             	sub    $0xc,%esp
80102d38:	68 bc 6f 10 80       	push   $0x80106fbc
80102d3d:	e8 06 d6 ff ff       	call   80100348 <panic>

80102d42 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102d42:	55                   	push   %ebp
80102d43:	89 e5                	mov    %esp,%ebp
80102d45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d4a:	ba 21 00 00 00       	mov    $0x21,%edx
80102d4f:	ee                   	out    %al,(%dx)
80102d50:	ba a1 00 00 00       	mov    $0xa1,%edx
80102d55:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102d56:	5d                   	pop    %ebp
80102d57:	c3                   	ret    

80102d58 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102d58:	55                   	push   %ebp
80102d59:	89 e5                	mov    %esp,%ebp
80102d5b:	57                   	push   %edi
80102d5c:	56                   	push   %esi
80102d5d:	53                   	push   %ebx
80102d5e:	83 ec 0c             	sub    $0xc,%esp
80102d61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d64:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102d67:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d6d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102d73:	e8 ea de ff ff       	call   80100c62 <filealloc>
80102d78:	89 03                	mov    %eax,(%ebx)
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	74 16                	je     80102d94 <pipealloc+0x3c>
80102d7e:	e8 df de ff ff       	call   80100c62 <filealloc>
80102d83:	89 06                	mov    %eax,(%esi)
80102d85:	85 c0                	test   %eax,%eax
80102d87:	74 0b                	je     80102d94 <pipealloc+0x3c>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102d89:	e8 50 f3 ff ff       	call   801020de <kalloc>
80102d8e:	89 c7                	mov    %eax,%edi
80102d90:	85 c0                	test   %eax,%eax
80102d92:	75 35                	jne    80102dc9 <pipealloc+0x71>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102d94:	8b 03                	mov    (%ebx),%eax
80102d96:	85 c0                	test   %eax,%eax
80102d98:	74 0c                	je     80102da6 <pipealloc+0x4e>
    fileclose(*f0);
80102d9a:	83 ec 0c             	sub    $0xc,%esp
80102d9d:	50                   	push   %eax
80102d9e:	e8 65 df ff ff       	call   80100d08 <fileclose>
80102da3:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102da6:	8b 06                	mov    (%esi),%eax
80102da8:	85 c0                	test   %eax,%eax
80102daa:	0f 84 8b 00 00 00    	je     80102e3b <pipealloc+0xe3>
    fileclose(*f1);
80102db0:	83 ec 0c             	sub    $0xc,%esp
80102db3:	50                   	push   %eax
80102db4:	e8 4f df ff ff       	call   80100d08 <fileclose>
80102db9:	83 c4 10             	add    $0x10,%esp
  return -1;
80102dbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dc4:	5b                   	pop    %ebx
80102dc5:	5e                   	pop    %esi
80102dc6:	5f                   	pop    %edi
80102dc7:	5d                   	pop    %ebp
80102dc8:	c3                   	ret    
  p->readopen = 1;
80102dc9:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102dd0:	00 00 00 
  p->writeopen = 1;
80102dd3:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102dda:	00 00 00 
  p->nwrite = 0;
80102ddd:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102de4:	00 00 00 
  p->nread = 0;
80102de7:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102dee:	00 00 00 
  initlock(&p->lock, "pipe");
80102df1:	83 ec 08             	sub    $0x8,%esp
80102df4:	68 f0 6f 10 80       	push   $0x80106ff0
80102df9:	50                   	push   %eax
80102dfa:	e8 09 12 00 00       	call   80104008 <initlock>
  (*f0)->type = FD_PIPE;
80102dff:	8b 03                	mov    (%ebx),%eax
80102e01:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102e07:	8b 03                	mov    (%ebx),%eax
80102e09:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102e0d:	8b 03                	mov    (%ebx),%eax
80102e0f:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e13:	8b 03                	mov    (%ebx),%eax
80102e15:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e18:	8b 06                	mov    (%esi),%eax
80102e1a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e20:	8b 06                	mov    (%esi),%eax
80102e22:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e26:	8b 06                	mov    (%esi),%eax
80102e28:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e2c:	8b 06                	mov    (%esi),%eax
80102e2e:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e31:	83 c4 10             	add    $0x10,%esp
80102e34:	b8 00 00 00 00       	mov    $0x0,%eax
80102e39:	eb 86                	jmp    80102dc1 <pipealloc+0x69>
  return -1;
80102e3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e40:	e9 7c ff ff ff       	jmp    80102dc1 <pipealloc+0x69>

80102e45 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102e45:	55                   	push   %ebp
80102e46:	89 e5                	mov    %esp,%ebp
80102e48:	53                   	push   %ebx
80102e49:	83 ec 10             	sub    $0x10,%esp
80102e4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102e4f:	53                   	push   %ebx
80102e50:	e8 ef 12 00 00       	call   80104144 <acquire>
  if(writable){
80102e55:	83 c4 10             	add    $0x10,%esp
80102e58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102e5c:	74 3f                	je     80102e9d <pipeclose+0x58>
    p->writeopen = 0;
80102e5e:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e65:	00 00 00 
    wakeup(&p->nread);
80102e68:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e6e:	83 ec 0c             	sub    $0xc,%esp
80102e71:	50                   	push   %eax
80102e72:	e8 71 0b 00 00       	call   801039e8 <wakeup>
80102e77:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102e7a:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e81:	75 09                	jne    80102e8c <pipeclose+0x47>
80102e83:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102e8a:	74 2f                	je     80102ebb <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102e8c:	83 ec 0c             	sub    $0xc,%esp
80102e8f:	53                   	push   %ebx
80102e90:	e8 14 13 00 00       	call   801041a9 <release>
80102e95:	83 c4 10             	add    $0x10,%esp
}
80102e98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e9b:	c9                   	leave  
80102e9c:	c3                   	ret    
    p->readopen = 0;
80102e9d:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102ea4:	00 00 00 
    wakeup(&p->nwrite);
80102ea7:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102ead:	83 ec 0c             	sub    $0xc,%esp
80102eb0:	50                   	push   %eax
80102eb1:	e8 32 0b 00 00       	call   801039e8 <wakeup>
80102eb6:	83 c4 10             	add    $0x10,%esp
80102eb9:	eb bf                	jmp    80102e7a <pipeclose+0x35>
    release(&p->lock);
80102ebb:	83 ec 0c             	sub    $0xc,%esp
80102ebe:	53                   	push   %ebx
80102ebf:	e8 e5 12 00 00       	call   801041a9 <release>
    kfree((char*)p);
80102ec4:	89 1c 24             	mov    %ebx,(%esp)
80102ec7:	e8 fb f0 ff ff       	call   80101fc7 <kfree>
80102ecc:	83 c4 10             	add    $0x10,%esp
80102ecf:	eb c7                	jmp    80102e98 <pipeclose+0x53>

80102ed1 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102ed1:	55                   	push   %ebp
80102ed2:	89 e5                	mov    %esp,%ebp
80102ed4:	57                   	push   %edi
80102ed5:	56                   	push   %esi
80102ed6:	53                   	push   %ebx
80102ed7:	83 ec 18             	sub    $0x18,%esp
80102eda:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102edd:	89 de                	mov    %ebx,%esi
80102edf:	53                   	push   %ebx
80102ee0:	e8 5f 12 00 00       	call   80104144 <acquire>
  for(i = 0; i < n; i++){
80102ee5:	83 c4 10             	add    $0x10,%esp
80102ee8:	bf 00 00 00 00       	mov    $0x0,%edi
80102eed:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102ef0:	0f 8d 88 00 00 00    	jge    80102f7e <pipewrite+0xad>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102ef6:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102efc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f02:	05 00 02 00 00       	add    $0x200,%eax
80102f07:	39 c2                	cmp    %eax,%edx
80102f09:	75 51                	jne    80102f5c <pipewrite+0x8b>
      if(p->readopen == 0 || myproc()->killed){
80102f0b:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f12:	74 2f                	je     80102f43 <pipewrite+0x72>
80102f14:	e8 a6 02 00 00       	call   801031bf <myproc>
80102f19:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f1d:	75 24                	jne    80102f43 <pipewrite+0x72>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80102f1f:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f25:	83 ec 0c             	sub    $0xc,%esp
80102f28:	50                   	push   %eax
80102f29:	e8 ba 0a 00 00       	call   801039e8 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f2e:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f34:	83 c4 08             	add    $0x8,%esp
80102f37:	56                   	push   %esi
80102f38:	50                   	push   %eax
80102f39:	e8 fe 09 00 00       	call   8010393c <sleep>
80102f3e:	83 c4 10             	add    $0x10,%esp
80102f41:	eb b3                	jmp    80102ef6 <pipewrite+0x25>
        release(&p->lock);
80102f43:	83 ec 0c             	sub    $0xc,%esp
80102f46:	53                   	push   %ebx
80102f47:	e8 5d 12 00 00       	call   801041a9 <release>
        return -1;
80102f4c:	83 c4 10             	add    $0x10,%esp
80102f4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80102f54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f57:	5b                   	pop    %ebx
80102f58:	5e                   	pop    %esi
80102f59:	5f                   	pop    %edi
80102f5a:	5d                   	pop    %ebp
80102f5b:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102f5c:	8d 42 01             	lea    0x1(%edx),%eax
80102f5f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102f65:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f6e:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
80102f72:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102f76:	83 c7 01             	add    $0x1,%edi
80102f79:	e9 6f ff ff ff       	jmp    80102eed <pipewrite+0x1c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102f7e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f84:	83 ec 0c             	sub    $0xc,%esp
80102f87:	50                   	push   %eax
80102f88:	e8 5b 0a 00 00       	call   801039e8 <wakeup>
  release(&p->lock);
80102f8d:	89 1c 24             	mov    %ebx,(%esp)
80102f90:	e8 14 12 00 00       	call   801041a9 <release>
  return n;
80102f95:	83 c4 10             	add    $0x10,%esp
80102f98:	8b 45 10             	mov    0x10(%ebp),%eax
80102f9b:	eb b7                	jmp    80102f54 <pipewrite+0x83>

80102f9d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102f9d:	55                   	push   %ebp
80102f9e:	89 e5                	mov    %esp,%ebp
80102fa0:	57                   	push   %edi
80102fa1:	56                   	push   %esi
80102fa2:	53                   	push   %ebx
80102fa3:	83 ec 18             	sub    $0x18,%esp
80102fa6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fa9:	89 df                	mov    %ebx,%edi
80102fab:	53                   	push   %ebx
80102fac:	e8 93 11 00 00       	call   80104144 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fb1:	83 c4 10             	add    $0x10,%esp
80102fb4:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102fba:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102fc0:	75 3d                	jne    80102fff <piperead+0x62>
80102fc2:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102fc8:	85 f6                	test   %esi,%esi
80102fca:	74 38                	je     80103004 <piperead+0x67>
    if(myproc()->killed){
80102fcc:	e8 ee 01 00 00       	call   801031bf <myproc>
80102fd1:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102fd5:	75 15                	jne    80102fec <piperead+0x4f>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102fd7:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fdd:	83 ec 08             	sub    $0x8,%esp
80102fe0:	57                   	push   %edi
80102fe1:	50                   	push   %eax
80102fe2:	e8 55 09 00 00       	call   8010393c <sleep>
80102fe7:	83 c4 10             	add    $0x10,%esp
80102fea:	eb c8                	jmp    80102fb4 <piperead+0x17>
      release(&p->lock);
80102fec:	83 ec 0c             	sub    $0xc,%esp
80102fef:	53                   	push   %ebx
80102ff0:	e8 b4 11 00 00       	call   801041a9 <release>
      return -1;
80102ff5:	83 c4 10             	add    $0x10,%esp
80102ff8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102ffd:	eb 50                	jmp    8010304f <piperead+0xb2>
80102fff:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103004:	3b 75 10             	cmp    0x10(%ebp),%esi
80103007:	7d 2c                	jge    80103035 <piperead+0x98>
    if(p->nread == p->nwrite)
80103009:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010300f:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103015:	74 1e                	je     80103035 <piperead+0x98>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103017:	8d 50 01             	lea    0x1(%eax),%edx
8010301a:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80103020:	25 ff 01 00 00       	and    $0x1ff,%eax
80103025:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
8010302a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010302d:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103030:	83 c6 01             	add    $0x1,%esi
80103033:	eb cf                	jmp    80103004 <piperead+0x67>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103035:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010303b:	83 ec 0c             	sub    $0xc,%esp
8010303e:	50                   	push   %eax
8010303f:	e8 a4 09 00 00       	call   801039e8 <wakeup>
  release(&p->lock);
80103044:	89 1c 24             	mov    %ebx,(%esp)
80103047:	e8 5d 11 00 00       	call   801041a9 <release>
  return i;
8010304c:	83 c4 10             	add    $0x10,%esp
}
8010304f:	89 f0                	mov    %esi,%eax
80103051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103054:	5b                   	pop    %ebx
80103055:	5e                   	pop    %esi
80103056:	5f                   	pop    %edi
80103057:	5d                   	pop    %ebp
80103058:	c3                   	ret    

80103059 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103059:	55                   	push   %ebp
8010305a:	89 e5                	mov    %esp,%ebp
8010305c:	56                   	push   %esi
8010305d:	53                   	push   %ebx
8010305e:	83 ec 10             	sub    $0x10,%esp
80103061:	89 c6                	mov    %eax,%esi
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103063:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103068:	eb 06                	jmp    80103070 <wakeup1+0x17>
8010306a:	81 c2 10 01 00 00    	add    $0x110,%edx
80103070:	81 fa 54 71 11 80    	cmp    $0x80117154,%edx
80103076:	73 74                	jae    801030ec <pass79+0x13>
    if((p->state == SLEEPING || p->state == MINUS_SLEEPING) && p->chan == chan){
80103078:	8b 42 0c             	mov    0xc(%edx),%eax
8010307b:	8d 48 fd             	lea    -0x3(%eax),%ecx
8010307e:	83 f9 01             	cmp    $0x1,%ecx
80103081:	77 e7                	ja     8010306a <wakeup1+0x11>
80103083:	39 72 20             	cmp    %esi,0x20(%edx)
80103086:	75 e2                	jne    8010306a <wakeup1+0x11>
        while(p->state == MINUS_SLEEPING){
80103088:	83 f8 04             	cmp    $0x4,%eax
8010308b:	74 fb                	je     80103088 <wakeup1+0x2f>
          //wating until process will become sleeping and then we will put it as runnable!
        }
        if(cas((int*)(&p->state), SLEEPING, MINUS_RUNNABLE)){
8010308d:	8d 5a 0c             	lea    0xc(%edx),%ebx

  static inline int
cas(volatile void *addr, int expected, int newval)
{
  
  int ret_val = 1;
80103090:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103097:	b8 03 00 00 00       	mov    $0x3,%eax
8010309c:	b9 06 00 00 00       	mov    $0x6,%ecx
801030a1:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
801030a5:	74 07                	je     801030ae <pass60>
801030a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

801030ae <pass60>:
801030ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801030b2:	74 b6                	je     8010306a <wakeup1+0x11>
          p->chan = 0; //reseting process's chan now to prevent it from running the process with not 0 chanel!
801030b4:	c7 42 20 00 00 00 00 	movl   $0x0,0x20(%edx)
  int ret_val = 1;
801030bb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801030c2:	b8 06 00 00 00       	mov    $0x6,%eax
801030c7:	b9 05 00 00 00       	mov    $0x5,%ecx
801030cc:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
801030d0:	74 07                	je     801030d9 <pass79>
801030d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

801030d9 <pass79>:
          if(!cas((int*)(&p->state), MINUS_RUNNABLE, RUNNABLE)){
801030d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801030dd:	75 8b                	jne    8010306a <wakeup1+0x11>
            panic("error at wakeup1, process should be minus_runnable!");
801030df:	83 ec 0c             	sub    $0xc,%esp
801030e2:	68 f8 6f 10 80       	push   $0x80106ff8
801030e7:	e8 5c d2 ff ff       	call   80100348 <panic>
  // {
  //   if((p->state == SLEEPING && p->chan == chan)){  
  //       p->state = RUNNABLE; 
  //     }
  // } u check
}
801030ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801030ef:	5b                   	pop    %ebx
801030f0:	5e                   	pop    %esi
801030f1:	5d                   	pop    %ebp
801030f2:	c3                   	ret    

801030f3 <forkret>:
{
801030f3:	55                   	push   %ebp
801030f4:	89 e5                	mov    %esp,%ebp
801030f6:	83 ec 08             	sub    $0x8,%esp
  popcli();
801030f9:	e8 a6 0f 00 00       	call   801040a4 <popcli>
  if (first) {
801030fe:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
80103105:	75 02                	jne    80103109 <forkret+0x16>
}
80103107:	c9                   	leave  
80103108:	c3                   	ret    
    first = 0;
80103109:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103110:	00 00 00 
    iinit(ROOTDEV);
80103113:	83 ec 0c             	sub    $0xc,%esp
80103116:	6a 01                	push   $0x1
80103118:	e8 f2 e1 ff ff       	call   8010130f <iinit>
    initlog(ROOTDEV);
8010311d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103124:	e8 5f f6 ff ff       	call   80102788 <initlog>
80103129:	83 c4 10             	add    $0x10,%esp
}
8010312c:	eb d9                	jmp    80103107 <forkret+0x14>

8010312e <pinit>:
{
8010312e:	55                   	push   %ebp
8010312f:	89 e5                	mov    %esp,%ebp
80103131:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103134:	68 0d 71 10 80       	push   $0x8010710d
80103139:	68 20 2d 11 80       	push   $0x80112d20
8010313e:	e8 c5 0e 00 00       	call   80104008 <initlock>
}
80103143:	83 c4 10             	add    $0x10,%esp
80103146:	c9                   	leave  
80103147:	c3                   	ret    

80103148 <mycpu>:
{
80103148:	55                   	push   %ebp
80103149:	89 e5                	mov    %esp,%ebp
8010314b:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010314e:	9c                   	pushf  
8010314f:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103150:	f6 c4 02             	test   $0x2,%ah
80103153:	75 28                	jne    8010317d <mycpu+0x35>
  apicid = lapicid();
80103155:	e8 47 f2 ff ff       	call   801023a1 <lapicid>
  for (i = 0; i < ncpu; ++i) {
8010315a:	ba 00 00 00 00       	mov    $0x0,%edx
8010315f:	39 15 00 2d 11 80    	cmp    %edx,0x80112d00
80103165:	7e 23                	jle    8010318a <mycpu+0x42>
    if (cpus[i].apicid == apicid)
80103167:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010316d:	0f b6 89 80 27 11 80 	movzbl -0x7feed880(%ecx),%ecx
80103174:	39 c1                	cmp    %eax,%ecx
80103176:	74 1f                	je     80103197 <mycpu+0x4f>
  for (i = 0; i < ncpu; ++i) {
80103178:	83 c2 01             	add    $0x1,%edx
8010317b:	eb e2                	jmp    8010315f <mycpu+0x17>
    panic("mycpu called with interrupts enabled\n");
8010317d:	83 ec 0c             	sub    $0xc,%esp
80103180:	68 2c 70 10 80       	push   $0x8010702c
80103185:	e8 be d1 ff ff       	call   80100348 <panic>
  panic("unknown apicid\n");
8010318a:	83 ec 0c             	sub    $0xc,%esp
8010318d:	68 14 71 10 80       	push   $0x80107114
80103192:	e8 b1 d1 ff ff       	call   80100348 <panic>
      return &cpus[i];
80103197:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010319d:	05 80 27 11 80       	add    $0x80112780,%eax
}
801031a2:	c9                   	leave  
801031a3:	c3                   	ret    

801031a4 <cpuid>:
cpuid() {
801031a4:	55                   	push   %ebp
801031a5:	89 e5                	mov    %esp,%ebp
801031a7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801031aa:	e8 99 ff ff ff       	call   80103148 <mycpu>
801031af:	2d 80 27 11 80       	sub    $0x80112780,%eax
801031b4:	c1 f8 04             	sar    $0x4,%eax
801031b7:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801031bd:	c9                   	leave  
801031be:	c3                   	ret    

801031bf <myproc>:
myproc(void) {
801031bf:	55                   	push   %ebp
801031c0:	89 e5                	mov    %esp,%ebp
801031c2:	53                   	push   %ebx
801031c3:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801031c6:	e8 9c 0e 00 00       	call   80104067 <pushcli>
  c = mycpu();
801031cb:	e8 78 ff ff ff       	call   80103148 <mycpu>
  p = c->proc;
801031d0:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801031d6:	e8 c9 0e 00 00       	call   801040a4 <popcli>
}
801031db:	89 d8                	mov    %ebx,%eax
801031dd:	83 c4 04             	add    $0x4,%esp
801031e0:	5b                   	pop    %ebx
801031e1:	5d                   	pop    %ebp
801031e2:	c3                   	ret    

801031e3 <allocpid>:
{
801031e3:	55                   	push   %ebp
801031e4:	89 e5                	mov    %esp,%ebp
801031e6:	56                   	push   %esi
801031e7:	53                   	push   %ebx
801031e8:	83 ec 10             	sub    $0x10,%esp
  pushcli();
801031eb:	e8 77 0e 00 00       	call   80104067 <pushcli>
    pid = nextpid;
801031f0:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  }while(!cas(&nextpid, pid, pid + 1));
801031f5:	8d 70 01             	lea    0x1(%eax),%esi
  int ret_val = 1;
801031f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801031ff:	bb 04 a0 10 80       	mov    $0x8010a004,%ebx
80103204:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
80103208:	74 07                	je     80103211 <pass336>
8010320a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

80103211 <pass336>:
80103211:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103215:	74 d9                	je     801031f0 <allocpid+0xd>
  popcli();
80103217:	e8 88 0e 00 00       	call   801040a4 <popcli>
}
8010321c:	89 f0                	mov    %esi,%eax
8010321e:	83 c4 10             	add    $0x10,%esp
80103221:	5b                   	pop    %ebx
80103222:	5e                   	pop    %esi
80103223:	5d                   	pop    %ebp
80103224:	c3                   	ret    

80103225 <allocproc>:
{
80103225:	55                   	push   %ebp
80103226:	89 e5                	mov    %esp,%ebp
80103228:	56                   	push   %esi
80103229:	53                   	push   %ebx
8010322a:	83 ec 10             	sub    $0x10,%esp
  pushcli();
8010322d:	e8 35 0e 00 00       	call   80104067 <pushcli>
80103232:	eb 2f                	jmp    80103263 <pass398+0x6>
    if (p == &ptable.proc[NPROC]) {
80103234:	81 fe 54 71 11 80    	cmp    $0x80117154,%esi
8010323a:	74 42                	je     8010327e <pass398+0x21>
  } while (!cas((int*)(&p->state), UNUSED, EMBRYO));
8010323c:	8d 5e 0c             	lea    0xc(%esi),%ebx
  int ret_val = 1;
8010323f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103246:	b8 00 00 00 00       	mov    $0x0,%eax
8010324b:	ba 02 00 00 00       	mov    $0x2,%edx
80103250:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103254:	74 07                	je     8010325d <pass398>
80103256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

8010325d <pass398>:
8010325d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103261:	75 2e                	jne    80103291 <pass398+0x34>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103263:	be 54 2d 11 80       	mov    $0x80112d54,%esi
80103268:	81 fe 54 71 11 80    	cmp    $0x80117154,%esi
8010326e:	73 c4                	jae    80103234 <allocproc+0xf>
      if(p->state == UNUSED)
80103270:	83 7e 0c 00          	cmpl   $0x0,0xc(%esi)
80103274:	74 be                	je     80103234 <allocproc+0xf>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103276:	81 c6 10 01 00 00    	add    $0x110,%esi
8010327c:	eb ea                	jmp    80103268 <pass398+0xb>
      popcli();
8010327e:	e8 21 0e 00 00       	call   801040a4 <popcli>
      return 0; // err no space in ptable
80103283:	be 00 00 00 00       	mov    $0x0,%esi
}
80103288:	89 f0                	mov    %esi,%eax
8010328a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010328d:	5b                   	pop    %ebx
8010328e:	5e                   	pop    %esi
8010328f:	5d                   	pop    %ebp
80103290:	c3                   	ret    
  popcli();
80103291:	e8 0e 0e 00 00       	call   801040a4 <popcli>
  p->pid = allocpid();
80103296:	e8 48 ff ff ff       	call   801031e3 <allocpid>
8010329b:	89 46 10             	mov    %eax,0x10(%esi)
  if((p->kstack = kalloc()) == 0){
8010329e:	e8 3b ee ff ff       	call   801020de <kalloc>
801032a3:	89 46 08             	mov    %eax,0x8(%esi)
801032a6:	85 c0                	test   %eax,%eax
801032a8:	74 4d                	je     801032f7 <pass398+0x9a>
  sp -= sizeof *p->tf;
801032aa:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
801032b0:	89 56 18             	mov    %edx,0x18(%esi)
  *(uint*)sp = (uint)trapret;
801032b3:	c7 80 b0 0f 00 00 5f 	movl   $0x8010535f,0xfb0(%eax)
801032ba:	53 10 80 
  sp -= sizeof *p->context;
801032bd:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
801032c2:	89 46 1c             	mov    %eax,0x1c(%esi)
  memset(p->context, 0, sizeof *p->context);
801032c5:	83 ec 04             	sub    $0x4,%esp
801032c8:	6a 14                	push   $0x14
801032ca:	6a 00                	push   $0x0
801032cc:	50                   	push   %eax
801032cd:	e8 1e 0f 00 00       	call   801041f0 <memset>
  p->context->eip = (uint)forkret;
801032d2:	8b 46 1c             	mov    0x1c(%esi),%eax
801032d5:	c7 40 10 f3 30 10 80 	movl   $0x801030f3,0x10(%eax)
  p->psignals = 0;
801032dc:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
  p->sigmask = 0;
801032e3:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
801032ea:	00 00 00 
  for (int i = SIG_MIN; i <= SIG_MAX; i++) // setting all sig handlers to default
801032ed:	83 c4 10             	add    $0x10,%esp
801032f0:	b8 00 00 00 00       	mov    $0x0,%eax
801032f5:	eb 1c                	jmp    80103313 <pass398+0xb6>
    p->state = UNUSED;
801032f7:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return 0;
801032fe:	be 00 00 00 00       	mov    $0x0,%esi
80103303:	eb 83                	jmp    80103288 <pass398+0x2b>
    p->sig_handlers[i] = SIG_DFL;
80103305:	c7 84 86 84 00 00 00 	movl   $0x0,0x84(%esi,%eax,4)
8010330c:	00 00 00 00 
  for (int i = SIG_MIN; i <= SIG_MAX; i++) // setting all sig handlers to default
80103310:	83 c0 01             	add    $0x1,%eax
80103313:	83 f8 1f             	cmp    $0x1f,%eax
80103316:	7e ed                	jle    80103305 <pass398+0xa8>
80103318:	e9 6b ff ff ff       	jmp    80103288 <pass398+0x2b>

8010331d <userinit>:
{
8010331d:	55                   	push   %ebp
8010331e:	89 e5                	mov    %esp,%ebp
80103320:	53                   	push   %ebx
80103321:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103324:	e8 fc fe ff ff       	call   80103225 <allocproc>
80103329:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010332b:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103330:	e8 1a 35 00 00       	call   8010684f <setupkvm>
80103335:	89 43 04             	mov    %eax,0x4(%ebx)
80103338:	85 c0                	test   %eax,%eax
8010333a:	0f 84 a9 00 00 00    	je     801033e9 <userinit+0xcc>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103340:	83 ec 04             	sub    $0x4,%esp
80103343:	68 2c 00 00 00       	push   $0x2c
80103348:	68 60 a4 10 80       	push   $0x8010a460
8010334d:	50                   	push   %eax
8010334e:	e8 07 32 00 00       	call   8010655a <inituvm>
  p->sz = PGSIZE;
80103353:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103359:	83 c4 0c             	add    $0xc,%esp
8010335c:	6a 4c                	push   $0x4c
8010335e:	6a 00                	push   $0x0
80103360:	ff 73 18             	pushl  0x18(%ebx)
80103363:	e8 88 0e 00 00       	call   801041f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103368:	8b 43 18             	mov    0x18(%ebx),%eax
8010336b:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103371:	8b 43 18             	mov    0x18(%ebx),%eax
80103374:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010337a:	8b 43 18             	mov    0x18(%ebx),%eax
8010337d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103381:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103385:	8b 43 18             	mov    0x18(%ebx),%eax
80103388:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010338c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103390:	8b 43 18             	mov    0x18(%ebx),%eax
80103393:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010339a:	8b 43 18             	mov    0x18(%ebx),%eax
8010339d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801033a4:	8b 43 18             	mov    0x18(%ebx),%eax
801033a7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801033ae:	8d 43 6c             	lea    0x6c(%ebx),%eax
801033b1:	83 c4 0c             	add    $0xc,%esp
801033b4:	6a 10                	push   $0x10
801033b6:	68 3d 71 10 80       	push   $0x8010713d
801033bb:	50                   	push   %eax
801033bc:	e8 96 0f 00 00       	call   80104357 <safestrcpy>
  p->cwd = namei("/");
801033c1:	c7 04 24 46 71 10 80 	movl   $0x80107146,(%esp)
801033c8:	e8 37 e8 ff ff       	call   80101c04 <namei>
801033cd:	89 43 68             	mov    %eax,0x68(%ebx)
  pushcli();
801033d0:	e8 92 0c 00 00       	call   80104067 <pushcli>
  p->state = RUNNABLE;
801033d5:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  popcli();
801033dc:	e8 c3 0c 00 00       	call   801040a4 <popcli>
}
801033e1:	83 c4 10             	add    $0x10,%esp
801033e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033e7:	c9                   	leave  
801033e8:	c3                   	ret    
    panic("userinit: out of memory?");
801033e9:	83 ec 0c             	sub    $0xc,%esp
801033ec:	68 24 71 10 80       	push   $0x80107124
801033f1:	e8 52 cf ff ff       	call   80100348 <panic>

801033f6 <growproc>:
{
801033f6:	55                   	push   %ebp
801033f7:	89 e5                	mov    %esp,%ebp
801033f9:	56                   	push   %esi
801033fa:	53                   	push   %ebx
801033fb:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801033fe:	e8 bc fd ff ff       	call   801031bf <myproc>
80103403:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103405:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103407:	85 f6                	test   %esi,%esi
80103409:	7f 21                	jg     8010342c <growproc+0x36>
  } else if(n < 0){
8010340b:	85 f6                	test   %esi,%esi
8010340d:	79 33                	jns    80103442 <growproc+0x4c>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010340f:	83 ec 04             	sub    $0x4,%esp
80103412:	01 c6                	add    %eax,%esi
80103414:	56                   	push   %esi
80103415:	50                   	push   %eax
80103416:	ff 73 04             	pushl  0x4(%ebx)
80103419:	e8 45 32 00 00       	call   80106663 <deallocuvm>
8010341e:	83 c4 10             	add    $0x10,%esp
80103421:	85 c0                	test   %eax,%eax
80103423:	75 1d                	jne    80103442 <growproc+0x4c>
      return -1;
80103425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010342a:	eb 29                	jmp    80103455 <growproc+0x5f>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010342c:	83 ec 04             	sub    $0x4,%esp
8010342f:	01 c6                	add    %eax,%esi
80103431:	56                   	push   %esi
80103432:	50                   	push   %eax
80103433:	ff 73 04             	pushl  0x4(%ebx)
80103436:	e8 ba 32 00 00       	call   801066f5 <allocuvm>
8010343b:	83 c4 10             	add    $0x10,%esp
8010343e:	85 c0                	test   %eax,%eax
80103440:	74 1a                	je     8010345c <growproc+0x66>
  curproc->sz = sz;
80103442:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103444:	83 ec 0c             	sub    $0xc,%esp
80103447:	53                   	push   %ebx
80103448:	e8 f5 2f 00 00       	call   80106442 <switchuvm>
  return 0;
8010344d:	83 c4 10             	add    $0x10,%esp
80103450:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103455:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103458:	5b                   	pop    %ebx
80103459:	5e                   	pop    %esi
8010345a:	5d                   	pop    %ebp
8010345b:	c3                   	ret    
      return -1;
8010345c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103461:	eb f2                	jmp    80103455 <growproc+0x5f>

80103463 <canRunEvenIfFrozen>:
{
80103463:	55                   	push   %ebp
80103464:	89 e5                	mov    %esp,%ebp
80103466:	57                   	push   %edi
80103467:	56                   	push   %esi
80103468:	53                   	push   %ebx
80103469:	8b 7d 08             	mov    0x8(%ebp),%edi
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
8010346c:	b9 00 00 00 00       	mov    $0x0,%ecx
80103471:	eb 13                	jmp    80103486 <canRunEvenIfFrozen+0x23>
      if(handler == (void (*)())SIGCONT || handler == (void (*)())SIGKILL)
80103473:	83 f8 13             	cmp    $0x13,%eax
80103476:	0f 94 c3             	sete   %bl
80103479:	83 f8 09             	cmp    $0x9,%eax
8010347c:	0f 94 c0             	sete   %al
8010347f:	08 c3                	or     %al,%bl
80103481:	75 44                	jne    801034c7 <canRunEvenIfFrozen+0x64>
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
80103483:	83 c1 01             	add    $0x1,%ecx
80103486:	83 f9 1f             	cmp    $0x1f,%ecx
80103489:	77 32                	ja     801034bd <canRunEvenIfFrozen+0x5a>
    if(p->psignals & (1 << sig)) {
8010348b:	b8 01 00 00 00       	mov    $0x1,%eax
80103490:	d3 e0                	shl    %cl,%eax
80103492:	85 47 7c             	test   %eax,0x7c(%edi)
80103495:	74 ec                	je     80103483 <canRunEvenIfFrozen+0x20>
      handler = ((struct sigaction*)&p->sig_handlers[sig])->sa_handler;
80103497:	8b 84 8f 84 00 00 00 	mov    0x84(%edi,%ecx,4),%eax
      if(handler == SIG_DFL && (sig == SIGCONT || sig == SIGKILL))
8010349e:	85 c0                	test   %eax,%eax
801034a0:	75 d1                	jne    80103473 <canRunEvenIfFrozen+0x10>
801034a2:	83 f9 13             	cmp    $0x13,%ecx
801034a5:	0f 94 c3             	sete   %bl
801034a8:	89 de                	mov    %ebx,%esi
801034aa:	83 f9 09             	cmp    $0x9,%ecx
801034ad:	0f 94 c3             	sete   %bl
801034b0:	89 f2                	mov    %esi,%edx
801034b2:	08 da                	or     %bl,%dl
801034b4:	74 bd                	je     80103473 <canRunEvenIfFrozen+0x10>
        return 1;
801034b6:	b8 01 00 00 00       	mov    $0x1,%eax
801034bb:	eb 05                	jmp    801034c2 <canRunEvenIfFrozen+0x5f>
  return 0;
801034bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801034c2:	5b                   	pop    %ebx
801034c3:	5e                   	pop    %esi
801034c4:	5f                   	pop    %edi
801034c5:	5d                   	pop    %ebp
801034c6:	c3                   	ret    
        return 1;
801034c7:	b8 01 00 00 00       	mov    $0x1,%eax
801034cc:	eb f4                	jmp    801034c2 <canRunEvenIfFrozen+0x5f>

801034ce <scheduler>:
{
801034ce:	55                   	push   %ebp
801034cf:	89 e5                	mov    %esp,%ebp
801034d1:	57                   	push   %edi
801034d2:	56                   	push   %esi
801034d3:	53                   	push   %ebx
801034d4:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
801034d7:	e8 6c fc ff ff       	call   80103148 <mycpu>
801034dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  c->proc = 0;
801034df:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801034e6:	00 00 00 
801034e9:	e9 a3 01 00 00       	jmp    80103691 <pass1022+0x1f>
  int ret_val = 1;
801034ee:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801034f5:	b8 07 00 00 00       	mov    $0x7,%eax
801034fa:	ba 05 00 00 00       	mov    $0x5,%edx
801034ff:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103503:	74 07                	je     8010350c <pass864>
80103505:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

8010350c <pass864>:
          continue;
8010350c:	eb 37                	jmp    80103545 <pass883+0x17>
  int ret_val = 1;
8010350e:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103515:	b8 06 00 00 00       	mov    $0x6,%eax
8010351a:	ba 05 00 00 00       	mov    $0x5,%edx
8010351f:	89 fb                	mov    %edi,%ebx
80103521:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103525:	74 07                	je     8010352e <pass883>
80103527:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

8010352e <pass883>:
        if(p->state == MINUS_ZOMBIE){
8010352e:	83 7e 0c 09          	cmpl   $0x9,0xc(%esi)
80103532:	0f 84 f1 00 00 00    	je     80103629 <pass988+0x16>
        c->proc = 0;
80103538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010353b:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103542:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103545:	81 c6 10 01 00 00    	add    $0x110,%esi
8010354b:	81 fe 54 71 11 80    	cmp    $0x80117154,%esi
80103551:	0f 83 35 01 00 00    	jae    8010368c <pass1022+0x1a>
      if(!cas((int*)(&p->state), RUNNABLE, RUNNING)) // this line elminate from 2 cpu's run the same process!
80103557:	8d 7e 0c             	lea    0xc(%esi),%edi
  int ret_val = 1;
8010355a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103561:	b8 05 00 00 00       	mov    $0x5,%eax
80103566:	ba 07 00 00 00       	mov    $0x7,%edx
8010356b:	89 fb                	mov    %edi,%ebx
8010356d:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103571:	74 07                	je     8010357a <pass921>
80103573:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

8010357a <pass921>:
8010357a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010357e:	74 c5                	je     80103545 <pass883+0x17>
      if(p->frozen)
80103580:	83 be 08 01 00 00 00 	cmpl   $0x0,0x108(%esi)
80103587:	74 14                	je     8010359d <pass921+0x23>
        if(canRunEvenIfFrozen(p))
80103589:	83 ec 0c             	sub    $0xc,%esp
8010358c:	56                   	push   %esi
8010358d:	e8 d1 fe ff ff       	call   80103463 <canRunEvenIfFrozen>
80103592:	83 c4 10             	add    $0x10,%esp
80103595:	85 c0                	test   %eax,%eax
80103597:	0f 84 51 ff ff ff    	je     801034ee <scheduler+0x20>
        c->proc = p;
8010359d:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
801035a0:	89 b3 ac 00 00 00    	mov    %esi,0xac(%ebx)
        switchuvm(p);
801035a6:	83 ec 0c             	sub    $0xc,%esp
801035a9:	56                   	push   %esi
801035aa:	e8 93 2e 00 00       	call   80106442 <switchuvm>
        swtch(&(c->scheduler), p->context);
801035af:	83 c4 08             	add    $0x8,%esp
801035b2:	ff 76 1c             	pushl  0x1c(%esi)
801035b5:	89 d8                	mov    %ebx,%eax
801035b7:	83 c0 04             	add    $0x4,%eax
801035ba:	50                   	push   %eax
801035bb:	e8 ea 0d 00 00       	call   801043aa <swtch>
        switchkvm();
801035c0:	e8 6b 2e 00 00       	call   80106430 <switchkvm>
  int ret_val = 1;
801035c5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801035cc:	b8 04 00 00 00       	mov    $0x4,%eax
801035d1:	ba 03 00 00 00       	mov    $0x3,%edx
801035d6:	89 fb                	mov    %edi,%ebx
801035d8:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801035dc:	74 07                	je     801035e5 <pass968>
801035de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

801035e5 <pass968>:
        if (cas((int*)(&p->state), MINUS_SLEEPING, SLEEPING)) {
801035e5:	83 c4 10             	add    $0x10,%esp
801035e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801035ec:	0f 84 1c ff ff ff    	je     8010350e <pass864+0x2>
          if (cas((int*)(&p->killed), 1, 0))
801035f2:	8d 5e 24             	lea    0x24(%esi),%ebx
  int ret_val = 1;
801035f5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801035fc:	b8 01 00 00 00       	mov    $0x1,%eax
80103601:	ba 00 00 00 00       	mov    $0x0,%edx
80103606:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
8010360a:	74 07                	je     80103613 <pass988>
8010360c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103613 <pass988>:
80103613:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80103617:	0f 84 f1 fe ff ff    	je     8010350e <pass864+0x2>
            p->state = RUNNABLE;
8010361d:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
80103624:	e9 e5 fe ff ff       	jmp    8010350e <pass864+0x2>
          kfree(p->kstack);
80103629:	83 ec 0c             	sub    $0xc,%esp
8010362c:	ff 76 08             	pushl  0x8(%esi)
8010362f:	e8 93 e9 ff ff       	call   80101fc7 <kfree>
          p->kstack = 0;
80103634:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
          freevm(p->pgdir);
8010363b:	83 c4 04             	add    $0x4,%esp
8010363e:	ff 76 04             	pushl  0x4(%esi)
80103641:	e8 99 31 00 00       	call   801067df <freevm>
          p->killed = 0;
80103646:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
          p->chan = 0; // all this transition is instead of the transion in wait from zombie to unused!
8010364d:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
  int ret_val = 1;
80103654:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
8010365b:	b8 09 00 00 00       	mov    $0x9,%eax
80103660:	ba 08 00 00 00       	mov    $0x8,%edx
80103665:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103669:	74 07                	je     80103672 <pass1022>
8010366b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103672 <pass1022>:
          if (cas((int*)(&p->state), MINUS_ZOMBIE, ZOMBIE)) //c_check
80103672:	83 c4 10             	add    $0x10,%esp
80103675:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80103679:	0f 84 b9 fe ff ff    	je     80103538 <pass883+0xa>
            wakeup1(p->parent); // DELAYED WAKEUP UNTIL process is actually zombie!
8010367f:	8b 46 14             	mov    0x14(%esi),%eax
80103682:	e8 d2 f9 ff ff       	call   80103059 <wakeup1>
80103687:	e9 ac fe ff ff       	jmp    80103538 <pass883+0xa>
    popcli();
8010368c:	e8 13 0a 00 00       	call   801040a4 <popcli>
  asm volatile("sti");
80103691:	fb                   	sti    
    pushcli();
80103692:	e8 d0 09 00 00       	call   80104067 <pushcli>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103697:	be 54 2d 11 80       	mov    $0x80112d54,%esi
8010369c:	e9 aa fe ff ff       	jmp    8010354b <pass883+0x1d>

801036a1 <sched>:
{
801036a1:	55                   	push   %ebp
801036a2:	89 e5                	mov    %esp,%ebp
801036a4:	56                   	push   %esi
801036a5:	53                   	push   %ebx
  struct proc *p = myproc();
801036a6:	e8 14 fb ff ff       	call   801031bf <myproc>
801036ab:	89 c3                	mov    %eax,%ebx
  if(mycpu()->ncli != 1)
801036ad:	e8 96 fa ff ff       	call   80103148 <mycpu>
801036b2:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801036b9:	75 41                	jne    801036fc <sched+0x5b>
  if(p->state == RUNNING)
801036bb:	83 7b 0c 07          	cmpl   $0x7,0xc(%ebx)
801036bf:	74 48                	je     80103709 <sched+0x68>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036c1:	9c                   	pushf  
801036c2:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801036c3:	f6 c4 02             	test   $0x2,%ah
801036c6:	75 4e                	jne    80103716 <sched+0x75>
  intena = mycpu()->intena;
801036c8:	e8 7b fa ff ff       	call   80103148 <mycpu>
801036cd:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801036d3:	e8 70 fa ff ff       	call   80103148 <mycpu>
801036d8:	83 ec 08             	sub    $0x8,%esp
801036db:	ff 70 04             	pushl  0x4(%eax)
801036de:	83 c3 1c             	add    $0x1c,%ebx
801036e1:	53                   	push   %ebx
801036e2:	e8 c3 0c 00 00       	call   801043aa <swtch>
  mycpu()->intena = intena;
801036e7:	e8 5c fa ff ff       	call   80103148 <mycpu>
801036ec:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801036f2:	83 c4 10             	add    $0x10,%esp
801036f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036f8:	5b                   	pop    %ebx
801036f9:	5e                   	pop    %esi
801036fa:	5d                   	pop    %ebp
801036fb:	c3                   	ret    
    panic("sched locks");
801036fc:	83 ec 0c             	sub    $0xc,%esp
801036ff:	68 48 71 10 80       	push   $0x80107148
80103704:	e8 3f cc ff ff       	call   80100348 <panic>
    panic("sched running");
80103709:	83 ec 0c             	sub    $0xc,%esp
8010370c:	68 54 71 10 80       	push   $0x80107154
80103711:	e8 32 cc ff ff       	call   80100348 <panic>
    panic("sched interruptible");
80103716:	83 ec 0c             	sub    $0xc,%esp
80103719:	68 62 71 10 80       	push   $0x80107162
8010371e:	e8 25 cc ff ff       	call   80100348 <panic>

80103723 <exit>:
{
80103723:	55                   	push   %ebp
80103724:	89 e5                	mov    %esp,%ebp
80103726:	56                   	push   %esi
80103727:	53                   	push   %ebx
80103728:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
8010372b:	e8 8f fa ff ff       	call   801031bf <myproc>
  if(curproc == initproc)
80103730:	39 05 b8 a5 10 80    	cmp    %eax,0x8010a5b8
80103736:	74 09                	je     80103741 <exit+0x1e>
80103738:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010373a:	bb 00 00 00 00       	mov    $0x0,%ebx
8010373f:	eb 10                	jmp    80103751 <exit+0x2e>
    panic("init exiting");
80103741:	83 ec 0c             	sub    $0xc,%esp
80103744:	68 76 71 10 80       	push   $0x80107176
80103749:	e8 fa cb ff ff       	call   80100348 <panic>
  for(fd = 0; fd < NOFILE; fd++){
8010374e:	83 c3 01             	add    $0x1,%ebx
80103751:	83 fb 0f             	cmp    $0xf,%ebx
80103754:	7f 1e                	jg     80103774 <exit+0x51>
    if(curproc->ofile[fd]){
80103756:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
8010375a:	85 c0                	test   %eax,%eax
8010375c:	74 f0                	je     8010374e <exit+0x2b>
      fileclose(curproc->ofile[fd]);
8010375e:	83 ec 0c             	sub    $0xc,%esp
80103761:	50                   	push   %eax
80103762:	e8 a1 d5 ff ff       	call   80100d08 <fileclose>
      curproc->ofile[fd] = 0;
80103767:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
8010376e:	00 
8010376f:	83 c4 10             	add    $0x10,%esp
80103772:	eb da                	jmp    8010374e <exit+0x2b>
  begin_op();
80103774:	e8 58 f0 ff ff       	call   801027d1 <begin_op>
  iput(curproc->cwd);
80103779:	83 ec 0c             	sub    $0xc,%esp
8010377c:	ff 76 68             	pushl  0x68(%esi)
8010377f:	e8 27 df ff ff       	call   801016ab <iput>
  end_op();
80103784:	e8 c2 f0 ff ff       	call   8010284b <end_op>
  curproc->cwd = 0;
80103789:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  pushcli();
80103790:	e8 d2 08 00 00       	call   80104067 <pushcli>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010379d:	eb 06                	jmp    801037a5 <exit+0x82>
8010379f:	81 c3 10 01 00 00    	add    $0x110,%ebx
801037a5:	81 fb 54 71 11 80    	cmp    $0x80117154,%ebx
801037ab:	73 1a                	jae    801037c7 <exit+0xa4>
    if(p->parent == curproc){
801037ad:	39 73 14             	cmp    %esi,0x14(%ebx)
801037b0:	75 ed                	jne    8010379f <exit+0x7c>
      p->parent = initproc;
801037b2:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801037b7:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801037ba:	83 7b 0c 08          	cmpl   $0x8,0xc(%ebx)
801037be:	75 df                	jne    8010379f <exit+0x7c>
        wakeup1(initproc);
801037c0:	e8 94 f8 ff ff       	call   80103059 <wakeup1>
801037c5:	eb d8                	jmp    8010379f <exit+0x7c>
  if(!cas((int*)(&curproc->state), RUNNING, MINUS_ZOMBIE))
801037c7:	8d 5e 0c             	lea    0xc(%esi),%ebx
  int ret_val = 1;
801037ca:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801037d1:	b8 07 00 00 00       	mov    $0x7,%eax
801037d6:	ba 09 00 00 00       	mov    $0x9,%edx
801037db:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801037df:	74 07                	je     801037e8 <pass1278>
801037e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

801037e8 <pass1278>:
801037e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037ec:	75 0d                	jne    801037fb <pass1278+0x13>
      panic("process should be at running state!");
801037ee:	83 ec 0c             	sub    $0xc,%esp
801037f1:	68 54 70 10 80       	push   $0x80107054
801037f6:	e8 4d cb ff ff       	call   80100348 <panic>
  sched();
801037fb:	e8 a1 fe ff ff       	call   801036a1 <sched>
  panic("zombie exit");
80103800:	83 ec 0c             	sub    $0xc,%esp
80103803:	68 83 71 10 80       	push   $0x80107183
80103808:	e8 3b cb ff ff       	call   80100348 <panic>

8010380d <wait>:
{
8010380d:	55                   	push   %ebp
8010380e:	89 e5                	mov    %esp,%ebp
80103810:	56                   	push   %esi
80103811:	53                   	push   %ebx
80103812:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103815:	e8 a5 f9 ff ff       	call   801031bf <myproc>
8010381a:	89 c6                	mov    %eax,%esi
  pushcli();
8010381c:	e8 46 08 00 00       	call   80104067 <pushcli>
    if (!cas((int*)(&curproc->state), RUNNING, MINUS_SLEEPING)) {
80103821:	8d 5e 0c             	lea    0xc(%esi),%ebx
  int ret_val = 1;
80103824:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
8010382b:	b8 07 00 00 00       	mov    $0x7,%eax
80103830:	ba 04 00 00 00       	mov    $0x4,%edx
80103835:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103839:	74 07                	je     80103842 <pass1335>
8010383b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

80103842 <pass1335>:
80103842:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103846:	74 0f                	je     80103857 <pass1335+0x15>
    curproc->chan = curproc; // setting the proc chan
80103848:	89 76 20             	mov    %esi,0x20(%esi)
    havekids = 0;
8010384b:	ba 00 00 00 00       	mov    $0x0,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103850:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103855:	eb 4a                	jmp    801038a1 <pass1335+0x5f>
      panic("wait: failed  process should be running!");
80103857:	83 ec 0c             	sub    $0xc,%esp
8010385a:	68 78 70 10 80       	push   $0x80107078
8010385f:	e8 e4 ca ff ff       	call   80100348 <panic>
        pid = p->pid;
80103864:	8b 58 10             	mov    0x10(%eax),%ebx
        p->pid = 0;
80103867:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010386e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80103875:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        curproc->chan = 0; //reseting cur proc chan because wern't going to sleep!
80103879:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
        curproc->state = RUNNING; //reseting cur proc chan because wern't going to sleep!
80103880:	c7 46 0c 07 00 00 00 	movl   $0x7,0xc(%esi)
        p->state = UNUSED; //u_check
80103887:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        popcli();
8010388e:	e8 11 08 00 00       	call   801040a4 <popcli>
}
80103893:	89 d8                	mov    %ebx,%eax
80103895:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103898:	5b                   	pop    %ebx
80103899:	5e                   	pop    %esi
8010389a:	5d                   	pop    %ebp
8010389b:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010389c:	05 10 01 00 00       	add    $0x110,%eax
801038a1:	3d 54 71 11 80       	cmp    $0x80117154,%eax
801038a6:	73 12                	jae    801038ba <pass1335+0x78>
      if(p->parent != curproc)
801038a8:	39 70 14             	cmp    %esi,0x14(%eax)
801038ab:	75 ef                	jne    8010389c <pass1335+0x5a>
        if((p->state == ZOMBIE)){  // u_check
801038ad:	83 78 0c 08          	cmpl   $0x8,0xc(%eax)
801038b1:	74 b1                	je     80103864 <pass1335+0x22>
      havekids = 1;
801038b3:	ba 01 00 00 00       	mov    $0x1,%edx
801038b8:	eb e2                	jmp    8010389c <pass1335+0x5a>
    if(!havekids || curproc->killed){
801038ba:	85 d2                	test   %edx,%edx
801038bc:	74 10                	je     801038ce <pass1335+0x8c>
801038be:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
801038c2:	75 0a                	jne    801038ce <pass1335+0x8c>
    sched();
801038c4:	e8 d8 fd ff ff       	call   801036a1 <sched>
    if (!cas((int*)(&curproc->state), RUNNING, MINUS_SLEEPING)) {
801038c9:	e9 53 ff ff ff       	jmp    80103821 <wait+0x14>
      curproc->chan = 0; //reseting cur proc chan because wern't going to sleep!
801038ce:	c7 46 20 00 00 00 00 	movl   $0x0,0x20(%esi)
      curproc->state = RUNNING; //reseting cur proc chan because wern't going to sleep!
801038d5:	c7 46 0c 07 00 00 00 	movl   $0x7,0xc(%esi)
      popcli();
801038dc:	e8 c3 07 00 00       	call   801040a4 <popcli>
      return -1;
801038e1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801038e6:	eb ab                	jmp    80103893 <pass1335+0x51>

801038e8 <yield>:
{
801038e8:	55                   	push   %ebp
801038e9:	89 e5                	mov    %esp,%ebp
801038eb:	53                   	push   %ebx
801038ec:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801038ef:	e8 73 07 00 00       	call   80104067 <pushcli>
  if(!cas((int*)(&myproc()->state), RUNNING, MINUS_RUNNABLE)){
801038f4:	e8 c6 f8 ff ff       	call   801031bf <myproc>
801038f9:	8d 58 0c             	lea    0xc(%eax),%ebx
  int ret_val = 1;
801038fc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103903:	b8 07 00 00 00       	mov    $0x7,%eax
80103908:	ba 06 00 00 00       	mov    $0x6,%edx
8010390d:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103911:	74 07                	je     8010391a <pass1488>
80103913:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

8010391a <pass1488>:
8010391a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010391e:	74 0f                	je     8010392f <pass1488+0x15>
  sched();
80103920:	e8 7c fd ff ff       	call   801036a1 <sched>
  popcli();
80103925:	e8 7a 07 00 00       	call   801040a4 <popcli>
}
8010392a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010392d:	c9                   	leave  
8010392e:	c3                   	ret    
    panic("cas failed at yiled, process state should be running!");
8010392f:	83 ec 0c             	sub    $0xc,%esp
80103932:	68 a4 70 10 80       	push   $0x801070a4
80103937:	e8 0c ca ff ff       	call   80100348 <panic>

8010393c <sleep>:
{
8010393c:	55                   	push   %ebp
8010393d:	89 e5                	mov    %esp,%ebp
8010393f:	56                   	push   %esi
80103940:	53                   	push   %ebx
80103941:	83 ec 10             	sub    $0x10,%esp
80103944:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103947:	e8 73 f8 ff ff       	call   801031bf <myproc>
  if(p == 0)
8010394c:	85 c0                	test   %eax,%eax
8010394e:	74 71                	je     801039c1 <pass1562+0x3f>
80103950:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
80103952:	85 f6                	test   %esi,%esi
80103954:	74 78                	je     801039ce <pass1562+0x4c>
  pushcli();
80103956:	e8 0c 07 00 00       	call   80104067 <pushcli>
  p->chan = chan;
8010395b:	8b 45 08             	mov    0x8(%ebp),%eax
8010395e:	89 43 20             	mov    %eax,0x20(%ebx)
  if(!cas((int*)(&p->state), RUNNING, MINUS_SLEEPING)) // c_check
80103961:	83 c3 0c             	add    $0xc,%ebx
  int ret_val = 1;
80103964:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
8010396b:	b8 07 00 00 00       	mov    $0x7,%eax
80103970:	ba 04 00 00 00       	mov    $0x4,%edx
80103975:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103979:	74 07                	je     80103982 <pass1562>
8010397b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

80103982 <pass1562>:
80103982:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103986:	74 53                	je     801039db <pass1562+0x59>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103988:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010398e:	74 0c                	je     8010399c <pass1562+0x1a>
    release(lk);
80103990:	83 ec 0c             	sub    $0xc,%esp
80103993:	56                   	push   %esi
80103994:	e8 10 08 00 00       	call   801041a9 <release>
80103999:	83 c4 10             	add    $0x10,%esp
  sched();
8010399c:	e8 00 fd ff ff       	call   801036a1 <sched>
  if(lk != &ptable.lock){  //DOC: sleeplock2
801039a1:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801039a7:	74 0c                	je     801039b5 <pass1562+0x33>
    acquire(lk);
801039a9:	83 ec 0c             	sub    $0xc,%esp
801039ac:	56                   	push   %esi
801039ad:	e8 92 07 00 00       	call   80104144 <acquire>
801039b2:	83 c4 10             	add    $0x10,%esp
  popcli();
801039b5:	e8 ea 06 00 00       	call   801040a4 <popcli>
}
801039ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039bd:	5b                   	pop    %ebx
801039be:	5e                   	pop    %esi
801039bf:	5d                   	pop    %ebp
801039c0:	c3                   	ret    
    panic("sleep");
801039c1:	83 ec 0c             	sub    $0xc,%esp
801039c4:	68 8f 71 10 80       	push   $0x8010718f
801039c9:	e8 7a c9 ff ff       	call   80100348 <panic>
    panic("sleep without lk");
801039ce:	83 ec 0c             	sub    $0xc,%esp
801039d1:	68 95 71 10 80       	push   $0x80107195
801039d6:	e8 6d c9 ff ff       	call   80100348 <panic>
    panic("cas failed at sleeping, should be running state!");
801039db:	83 ec 0c             	sub    $0xc,%esp
801039de:	68 dc 70 10 80       	push   $0x801070dc
801039e3:	e8 60 c9 ff ff       	call   80100348 <panic>

801039e8 <wakeup>:
   

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801039e8:	55                   	push   %ebp
801039e9:	89 e5                	mov    %esp,%ebp
801039eb:	83 ec 08             	sub    $0x8,%esp
  // acquire(&ptable.lock);
  pushcli();
801039ee:	e8 74 06 00 00       	call   80104067 <pushcli>
  wakeup1(chan);
801039f3:	8b 45 08             	mov    0x8(%ebp),%eax
801039f6:	e8 5e f6 ff ff       	call   80103059 <wakeup1>
  popcli();
801039fb:	e8 a4 06 00 00       	call   801040a4 <popcli>
  // release(&ptable.lock);
}
80103a00:	c9                   	leave  
80103a01:	c3                   	ret    

80103a02 <kill>:
// Process won't exit until it returns
// to user space (see trap in trap.c).
// assignment 2 - modified
int
kill(int pid, int signum)
{
80103a02:	55                   	push   %ebp
80103a03:	89 e5                	mov    %esp,%ebp
80103a05:	57                   	push   %edi
80103a06:	56                   	push   %esi
80103a07:	53                   	push   %ebx
80103a08:	83 ec 1c             	sub    $0x1c,%esp
80103a0b:	8b 75 08             	mov    0x8(%ebp),%esi
80103a0e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(signum < SIG_MIN || signum > SIG_MAX)
80103a11:	83 ff 1f             	cmp    $0x1f,%edi
80103a14:	77 6e                	ja     80103a84 <pass1725+0x2a>
    return -1;
  struct proc *p;
  pushcli();
80103a16:	e8 4c 06 00 00       	call   80104067 <pushcli>
  // acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a1b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103a20:	eb 06                	jmp    80103a28 <kill+0x26>
80103a22:	81 c2 10 01 00 00    	add    $0x110,%edx
80103a28:	81 fa 54 71 11 80    	cmp    $0x80117154,%edx
80103a2e:	73 48                	jae    80103a78 <pass1725+0x1e>
  {
    if(p->pid == pid)
80103a30:	39 72 10             	cmp    %esi,0x10(%edx)
80103a33:	75 ed                	jne    80103a22 <kill+0x20>
    {
      int expected_on = p->psignals | (1 << signum);
80103a35:	b8 01 00 00 00       	mov    $0x1,%eax
80103a3a:	89 f9                	mov    %edi,%ecx
80103a3c:	d3 e0                	shl    %cl,%eax
80103a3e:	89 c1                	mov    %eax,%ecx
80103a40:	0b 42 7c             	or     0x7c(%edx),%eax
      if(!cas((int*)(&p->psignals), expected_on, expected_on))
80103a43:	8d 5a 7c             	lea    0x7c(%edx),%ebx
  int ret_val = 1;
80103a46:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103a4d:	f0 0f b1 03          	lock cmpxchg %eax,(%ebx)
80103a51:	74 07                	je     80103a5a <pass1725>
80103a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103a5a <pass1725>:
                "movl $0, %0\n\t"
                "pass%=:\n\t"
                : "+m"(ret_val)
                : "a"(expected), "b"(addr), "r"(newval)
                : "memory");
  return ret_val;
80103a5a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103a5d:	85 db                	test   %ebx,%ebx
80103a5f:	75 c1                	jne    80103a22 <kill+0x20>
      {
        if(signum != 1)
80103a61:	83 ff 01             	cmp    $0x1,%edi
80103a64:	74 03                	je     80103a69 <pass1725+0xf>
        {
          p->psignals |= (1 << signum);
80103a66:	09 4a 7c             	or     %ecx,0x7c(%edx)
        }
        popcli();
80103a69:	e8 36 06 00 00       	call   801040a4 <popcli>
    }
  }
  // release(&ptable.lock);
  popcli();
  return -1;
}
80103a6e:	89 d8                	mov    %ebx,%eax
80103a70:	83 c4 1c             	add    $0x1c,%esp
80103a73:	5b                   	pop    %ebx
80103a74:	5e                   	pop    %esi
80103a75:	5f                   	pop    %edi
80103a76:	5d                   	pop    %ebp
80103a77:	c3                   	ret    
  popcli();
80103a78:	e8 27 06 00 00       	call   801040a4 <popcli>
  return -1;
80103a7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a82:	eb ea                	jmp    80103a6e <pass1725+0x14>
    return -1;
80103a84:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103a89:	eb e3                	jmp    80103a6e <pass1725+0x14>

80103a8b <sigprocmask>:


// system call: updating the process signal mask ass2
uint
sigprocmask(uint mask)
{
80103a8b:	55                   	push   %ebp
80103a8c:	89 e5                	mov    %esp,%ebp
80103a8e:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80103a91:	e8 29 f7 ff ff       	call   801031bf <myproc>
80103a96:	89 c2                	mov    %eax,%edx
  uint old = curproc -> sigmask;
80103a98:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  curproc->sigmask = mask;
80103a9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103aa1:	89 8a 80 00 00 00    	mov    %ecx,0x80(%edx)
  return old;
}
80103aa7:	c9                   	leave  
80103aa8:	c3                   	ret    

80103aa9 <procdump>:
// // Print a process listing to console.  For debugging.
// // Runs when user types ^P on console.
// // No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103aa9:	55                   	push   %ebp
80103aaa:	89 e5                	mov    %esp,%ebp
80103aac:	56                   	push   %esi
80103aad:	53                   	push   %ebx
80103aae:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab1:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ab6:	eb 36                	jmp    80103aee <procdump+0x45>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103ab8:	b8 a6 71 10 80       	mov    $0x801071a6,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
80103abd:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103ac0:	52                   	push   %edx
80103ac1:	50                   	push   %eax
80103ac2:	ff 73 10             	pushl  0x10(%ebx)
80103ac5:	68 aa 71 10 80       	push   $0x801071aa
80103aca:	e8 3c cb ff ff       	call   8010060b <cprintf>
    if(p->state == SLEEPING){
80103acf:	83 c4 10             	add    $0x10,%esp
80103ad2:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ad6:	74 3c                	je     80103b14 <procdump+0x6b>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ad8:	83 ec 0c             	sub    $0xc,%esp
80103adb:	68 43 75 10 80       	push   $0x80107543
80103ae0:	e8 26 cb ff ff       	call   8010060b <cprintf>
80103ae5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae8:	81 c3 10 01 00 00    	add    $0x110,%ebx
80103aee:	81 fb 54 71 11 80    	cmp    $0x80117154,%ebx
80103af4:	73 61                	jae    80103b57 <procdump+0xae>
    if(p->state == UNUSED)
80103af6:	8b 43 0c             	mov    0xc(%ebx),%eax
80103af9:	85 c0                	test   %eax,%eax
80103afb:	74 eb                	je     80103ae8 <procdump+0x3f>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103afd:	83 f8 09             	cmp    $0x9,%eax
80103b00:	77 b6                	ja     80103ab8 <procdump+0xf>
80103b02:	8b 04 85 20 72 10 80 	mov    -0x7fef8de0(,%eax,4),%eax
80103b09:	85 c0                	test   %eax,%eax
80103b0b:	75 b0                	jne    80103abd <procdump+0x14>
      state = "???";
80103b0d:	b8 a6 71 10 80       	mov    $0x801071a6,%eax
80103b12:	eb a9                	jmp    80103abd <procdump+0x14>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103b14:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103b17:	8b 40 0c             	mov    0xc(%eax),%eax
80103b1a:	83 c0 08             	add    $0x8,%eax
80103b1d:	83 ec 08             	sub    $0x8,%esp
80103b20:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103b23:	52                   	push   %edx
80103b24:	50                   	push   %eax
80103b25:	e8 f9 04 00 00       	call   80104023 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103b2a:	83 c4 10             	add    $0x10,%esp
80103b2d:	be 00 00 00 00       	mov    $0x0,%esi
80103b32:	eb 14                	jmp    80103b48 <procdump+0x9f>
        cprintf(" %p", pc[i]);
80103b34:	83 ec 08             	sub    $0x8,%esp
80103b37:	50                   	push   %eax
80103b38:	68 e1 6a 10 80       	push   $0x80106ae1
80103b3d:	e8 c9 ca ff ff       	call   8010060b <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103b42:	83 c6 01             	add    $0x1,%esi
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	83 fe 09             	cmp    $0x9,%esi
80103b4b:	7f 8b                	jg     80103ad8 <procdump+0x2f>
80103b4d:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103b51:	85 c0                	test   %eax,%eax
80103b53:	75 df                	jne    80103b34 <procdump+0x8b>
80103b55:	eb 81                	jmp    80103ad8 <procdump+0x2f>
  }
}
80103b57:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b5a:	5b                   	pop    %ebx
80103b5b:	5e                   	pop    %esi
80103b5c:	5d                   	pop    %ebp
80103b5d:	c3                   	ret    

80103b5e <sigkill_handler>:

// implmntation of SIGKILL, will cause the process to be killed (similar to orig xv6 kill) ass2
void
sigkill_handler(){
80103b5e:	55                   	push   %ebp
80103b5f:	89 e5                	mov    %esp,%ebp
80103b61:	83 ec 08             	sub    $0x8,%esp
  //cprintf("sigkill handler was fired\n");
  struct proc *p = myproc();
80103b64:	e8 56 f6 ff ff       	call   801031bf <myproc>
  p->killed = 1;
80103b69:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  // Wake process from sleep if necessary.
  if(p->state == SLEEPING)
80103b70:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103b74:	74 02                	je     80103b78 <sigkill_handler+0x1a>
    p->state = RUNNABLE;
  return;
}
80103b76:	c9                   	leave  
80103b77:	c3                   	ret    
    p->state = RUNNABLE;
80103b78:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  return;
80103b7f:	eb f5                	jmp    80103b76 <sigkill_handler+0x18>

80103b81 <sigstop_handler>:

void
sigstop_handler(){
80103b81:	55                   	push   %ebp
80103b82:	89 e5                	mov    %esp,%ebp
80103b84:	83 ec 08             	sub    $0x8,%esp
  struct proc *p = myproc();
80103b87:	e8 33 f6 ff ff       	call   801031bf <myproc>
  p->frozen = 1;
80103b8c:	c7 80 08 01 00 00 01 	movl   $0x1,0x108(%eax)
80103b93:	00 00 00 
  if(p-> state == SLEEPING)
80103b96:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103b9a:	74 05                	je     80103ba1 <sigstop_handler+0x20>
    return;

  // release(&ptable.lock);
  yield();
80103b9c:	e8 47 fd ff ff       	call   801038e8 <yield>
  // acquire(&ptable.lock);
}
80103ba1:	c9                   	leave  
80103ba2:	c3                   	ret    

80103ba3 <sigcont_handler>:

void
sigcont_handler(){
80103ba3:	55                   	push   %ebp
80103ba4:	89 e5                	mov    %esp,%ebp
80103ba6:	83 ec 08             	sub    $0x8,%esp
  struct proc* p = myproc();
80103ba9:	e8 11 f6 ff ff       	call   801031bf <myproc>
  p->frozen = 0;
80103bae:	c7 80 08 01 00 00 00 	movl   $0x0,0x108(%eax)
80103bb5:	00 00 00 
  return;
}
80103bb8:	c9                   	leave  
80103bb9:	c3                   	ret    

80103bba <copySigHandlers>:

void
copySigHandlers(void** new_sighandlers, void** old_sighandlers) {
80103bba:	55                   	push   %ebp
80103bbb:	89 e5                	mov    %esp,%ebp
80103bbd:	53                   	push   %ebx
80103bbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  int i;
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80103bc4:	b8 00 00 00 00       	mov    $0x0,%eax
80103bc9:	eb 09                	jmp    80103bd4 <copySigHandlers+0x1a>
    new_sighandlers[i] = old_sighandlers[i];
80103bcb:	8b 14 81             	mov    (%ecx,%eax,4),%edx
80103bce:	89 14 83             	mov    %edx,(%ebx,%eax,4)
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80103bd1:	83 c0 01             	add    $0x1,%eax
80103bd4:	83 f8 1f             	cmp    $0x1f,%eax
80103bd7:	7e f2                	jle    80103bcb <copySigHandlers+0x11>
  }
}
80103bd9:	5b                   	pop    %ebx
80103bda:	5d                   	pop    %ebp
80103bdb:	c3                   	ret    

80103bdc <fork>:
{
80103bdc:	55                   	push   %ebp
80103bdd:	89 e5                	mov    %esp,%ebp
80103bdf:	57                   	push   %edi
80103be0:	56                   	push   %esi
80103be1:	53                   	push   %ebx
80103be2:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103be5:	e8 d5 f5 ff ff       	call   801031bf <myproc>
80103bea:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103bec:	e8 34 f6 ff ff       	call   80103225 <allocproc>
80103bf1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103bf4:	85 c0                	test   %eax,%eax
80103bf6:	0f 84 f7 00 00 00    	je     80103cf3 <fork+0x117>
80103bfc:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103bfe:	83 ec 08             	sub    $0x8,%esp
80103c01:	ff 33                	pushl  (%ebx)
80103c03:	ff 73 04             	pushl  0x4(%ebx)
80103c06:	e8 f5 2c 00 00       	call   80106900 <copyuvm>
80103c0b:	89 47 04             	mov    %eax,0x4(%edi)
80103c0e:	83 c4 10             	add    $0x10,%esp
80103c11:	85 c0                	test   %eax,%eax
80103c13:	74 4f                	je     80103c64 <fork+0x88>
  np->sz = curproc->sz;
80103c15:	8b 03                	mov    (%ebx),%eax
80103c17:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c1a:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103c1c:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103c1f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c22:	8b 7a 18             	mov    0x18(%edx),%edi
80103c25:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c2a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->sigmask = curproc->sigmask;
80103c2c:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103c32:	89 d7                	mov    %edx,%edi
80103c34:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  copySigHandlers((void**)&np->sig_handlers, (void**)&curproc->sig_handlers);
80103c3a:	8d 93 84 00 00 00    	lea    0x84(%ebx),%edx
80103c40:	8d 87 84 00 00 00    	lea    0x84(%edi),%eax
80103c46:	83 ec 08             	sub    $0x8,%esp
80103c49:	52                   	push   %edx
80103c4a:	50                   	push   %eax
80103c4b:	e8 6a ff ff ff       	call   80103bba <copySigHandlers>
  np->tf->eax = 0;
80103c50:	8b 47 18             	mov    0x18(%edi),%eax
80103c53:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103c5a:	83 c4 10             	add    $0x10,%esp
80103c5d:	be 00 00 00 00       	mov    $0x0,%esi
80103c62:	eb 29                	jmp    80103c8d <fork+0xb1>
    kfree(np->kstack);
80103c64:	83 ec 0c             	sub    $0xc,%esp
80103c67:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c6a:	ff 73 08             	pushl  0x8(%ebx)
80103c6d:	e8 55 e3 ff ff       	call   80101fc7 <kfree>
    np->kstack = 0;
80103c72:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c79:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c80:	83 c4 10             	add    $0x10,%esp
80103c83:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c88:	eb 5f                	jmp    80103ce9 <fork+0x10d>
  for(i = 0; i < NOFILE; i++)
80103c8a:	83 c6 01             	add    $0x1,%esi
80103c8d:	83 fe 0f             	cmp    $0xf,%esi
80103c90:	7f 1d                	jg     80103caf <fork+0xd3>
    if(curproc->ofile[i])
80103c92:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c96:	85 c0                	test   %eax,%eax
80103c98:	74 f0                	je     80103c8a <fork+0xae>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c9a:	83 ec 0c             	sub    $0xc,%esp
80103c9d:	50                   	push   %eax
80103c9e:	e8 20 d0 ff ff       	call   80100cc3 <filedup>
80103ca3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ca6:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103caa:	83 c4 10             	add    $0x10,%esp
80103cad:	eb db                	jmp    80103c8a <fork+0xae>
  np->cwd = idup(curproc->cwd);
80103caf:	83 ec 0c             	sub    $0xc,%esp
80103cb2:	ff 73 68             	pushl  0x68(%ebx)
80103cb5:	e8 ba d8 ff ff       	call   80101574 <idup>
80103cba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103cbd:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cc0:	83 c3 6c             	add    $0x6c,%ebx
80103cc3:	8d 47 6c             	lea    0x6c(%edi),%eax
80103cc6:	83 c4 0c             	add    $0xc,%esp
80103cc9:	6a 10                	push   $0x10
80103ccb:	53                   	push   %ebx
80103ccc:	50                   	push   %eax
80103ccd:	e8 85 06 00 00       	call   80104357 <safestrcpy>
  pid = np->pid;
80103cd2:	8b 5f 10             	mov    0x10(%edi),%ebx
  pushcli();
80103cd5:	e8 8d 03 00 00       	call   80104067 <pushcli>
  np->state = RUNNABLE;
80103cda:	c7 47 0c 05 00 00 00 	movl   $0x5,0xc(%edi)
  popcli();
80103ce1:	e8 be 03 00 00       	call   801040a4 <popcli>
  return pid;
80103ce6:	83 c4 10             	add    $0x10,%esp
}
80103ce9:	89 d8                	mov    %ebx,%eax
80103ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cee:	5b                   	pop    %ebx
80103cef:	5e                   	pop    %esi
80103cf0:	5f                   	pop    %edi
80103cf1:	5d                   	pop    %ebp
80103cf2:	c3                   	ret    
    return -1;
80103cf3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cf8:	eb ef                	jmp    80103ce9 <fork+0x10d>

80103cfa <sigaction>:

int 
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact) 
{
80103cfa:	55                   	push   %ebp
80103cfb:	89 e5                	mov    %esp,%ebp
80103cfd:	57                   	push   %edi
80103cfe:	56                   	push   %esi
80103cff:	53                   	push   %ebx
80103d00:	83 ec 0c             	sub    $0xc,%esp
80103d03:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d06:	8b 75 0c             	mov    0xc(%ebp),%esi
80103d09:	8b 7d 10             	mov    0x10(%ebp),%edi
  struct proc* curproc = myproc();
80103d0c:	e8 ae f4 ff ff       	call   801031bf <myproc>

  if(signum == SIGSTOP || signum == SIGKILL) // they cannot be modified, blocked or ignored
80103d11:	83 fb 11             	cmp    $0x11,%ebx
80103d14:	0f 94 c1             	sete   %cl
80103d17:	83 fb 09             	cmp    $0x9,%ebx
80103d1a:	0f 94 c2             	sete   %dl
80103d1d:	08 d1                	or     %dl,%cl
80103d1f:	75 3c                	jne    80103d5d <sigaction+0x63>
    return 1;

  if(oldact != null) {
80103d21:	85 ff                	test   %edi,%edi
80103d23:	74 12                	je     80103d37 <sigaction+0x3d>
    oldact->sa_handler = ((struct sigaction*)&curproc->sig_handlers[signum])->sa_handler;              // old handler
80103d25:	8d 94 98 80 00 00 00 	lea    0x80(%eax,%ebx,4),%edx
80103d2c:	8b 4a 04             	mov    0x4(%edx),%ecx
80103d2f:	89 0f                	mov    %ecx,(%edi)
    oldact->sigmask = ((struct sigaction*)&curproc->sig_handlers[signum])->sigmask;                    // old sigmask
80103d31:	8b 52 08             	mov    0x8(%edx),%edx
80103d34:	89 57 04             	mov    %edx,0x4(%edi)
  }

  ((struct sigaction*)&curproc->sig_handlers[signum])->sa_handler = act->sa_handler;
80103d37:	8d 84 98 80 00 00 00 	lea    0x80(%eax,%ebx,4),%eax
80103d3e:	8b 16                	mov    (%esi),%edx
80103d40:	89 50 04             	mov    %edx,0x4(%eax)
  ((struct sigaction*)&curproc->sig_handlers[signum])->sigmask = act->sigmask;
80103d43:	8b 56 04             	mov    0x4(%esi),%edx
80103d46:	89 50 08             	mov    %edx,0x8(%eax)

  if(act->sigmask <= 0) // sigmask must be positive
80103d49:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80103d4d:	74 07                	je     80103d56 <sigaction+0x5c>
    return 1;

  return 0;
80103d4f:	b8 00 00 00 00       	mov    $0x0,%eax
80103d54:	eb 0c                	jmp    80103d62 <sigaction+0x68>
    return 1;
80103d56:	b8 01 00 00 00       	mov    $0x1,%eax
80103d5b:	eb 05                	jmp    80103d62 <sigaction+0x68>
    return 1;
80103d5d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103d62:	83 c4 0c             	add    $0xc,%esp
80103d65:	5b                   	pop    %ebx
80103d66:	5e                   	pop    %esi
80103d67:	5f                   	pop    %edi
80103d68:	5d                   	pop    %ebp
80103d69:	c3                   	ret    

80103d6a <user_handler>:

void
user_handler(struct proc* p, uint sig)
{
80103d6a:	55                   	push   %ebp
80103d6b:	89 e5                	mov    %esp,%ebp
80103d6d:	57                   	push   %edi
80103d6e:	56                   	push   %esi
80103d6f:	53                   	push   %ebx
80103d70:	83 ec 10             	sub    $0x10,%esp
80103d73:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d76:	8b 75 0c             	mov    0xc(%ebp),%esi

    char *sigret_caller_addr;
    uint sigret_size;

    // back-up trap frame
    memmove(p->kstack, p->tf, sizeof(*p->tf));
80103d79:	6a 4c                	push   $0x4c
80103d7b:	ff 73 18             	pushl  0x18(%ebx)
80103d7e:	ff 73 08             	pushl  0x8(%ebx)
80103d81:	e8 e5 04 00 00       	call   8010426b <memmove>
    p->tf_backup = (struct trapframe*)p->kstack;
80103d86:	8b 43 08             	mov    0x8(%ebx),%eax
80103d89:	89 83 04 01 00 00    	mov    %eax,0x104(%ebx)

    // changing the user space stack
    sigret_size = sigret_caller_end - sigret_caller_start;
80103d8f:	b8 76 53 10 80       	mov    $0x80105376,%eax
80103d94:	2d 6f 53 10 80       	sub    $0x8010536f,%eax
    p->tf->esp = p->tf->esp - sigret_size; // make room for sigret code
80103d99:	8b 4b 18             	mov    0x18(%ebx),%ecx
80103d9c:	8b 51 44             	mov    0x44(%ecx),%edx
80103d9f:	29 c2                	sub    %eax,%edx
80103da1:	89 51 44             	mov    %edx,0x44(%ecx)

    sigret_caller_addr = (char*)p->tf->esp;
80103da4:	8b 53 18             	mov    0x18(%ebx),%edx
80103da7:	8b 7a 44             	mov    0x44(%edx),%edi

    memmove((char*)p->tf->esp, sigret_caller_start, sigret_size);
80103daa:	83 c4 0c             	add    $0xc,%esp
80103dad:	50                   	push   %eax
80103dae:	68 6f 53 10 80       	push   $0x8010536f
80103db3:	57                   	push   %edi
80103db4:	e8 b2 04 00 00       	call   8010426b <memmove>

    // pushing signum
    p->tf->esp = p->tf->esp-UINT_SIZE;
80103db9:	8b 53 18             	mov    0x18(%ebx),%edx
80103dbc:	8b 42 44             	mov    0x44(%edx),%eax
80103dbf:	83 e8 04             	sub    $0x4,%eax
80103dc2:	89 42 44             	mov    %eax,0x44(%edx)
    *((uint*)(p->tf->esp)) = sig;
80103dc5:	8b 43 18             	mov    0x18(%ebx),%eax
80103dc8:	8b 40 44             	mov    0x44(%eax),%eax
80103dcb:	89 30                	mov    %esi,(%eax)

    // pushing sigret caller
    p->tf->esp = p->tf->esp-UINT_SIZE;
80103dcd:	8b 53 18             	mov    0x18(%ebx),%edx
80103dd0:	8b 42 44             	mov    0x44(%edx),%eax
80103dd3:	83 e8 04             	sub    $0x4,%eax
80103dd6:	89 42 44             	mov    %eax,0x44(%edx)
    *((uint*)(p->tf->esp)) = (uint)sigret_caller_addr;
80103dd9:	8b 43 18             	mov    0x18(%ebx),%eax
80103ddc:	8b 40 44             	mov    0x44(%eax),%eax
80103ddf:	89 38                	mov    %edi,(%eax)

    // updating user eip to user handler's address
    p->tf->eip = (uint)&((struct sigaction*)p->sig_handlers[sig])->sa_handler;
80103de1:	8b 94 b3 84 00 00 00 	mov    0x84(%ebx,%esi,4),%edx
80103de8:	8b 43 18             	mov    0x18(%ebx),%eax
80103deb:	89 50 38             	mov    %edx,0x38(%eax)
    return;
80103dee:	83 c4 10             	add    $0x10,%esp
}
80103df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103df4:	5b                   	pop    %ebx
80103df5:	5e                   	pop    %esi
80103df6:	5f                   	pop    %edi
80103df7:	5d                   	pop    %ebp
80103df8:	c3                   	ret    

80103df9 <handleSignal>:

void
handleSignal (int sig) {
80103df9:	55                   	push   %ebp
80103dfa:	89 e5                	mov    %esp,%ebp
80103dfc:	53                   	push   %ebx
80103dfd:	83 ec 04             	sub    $0x4,%esp
80103e00:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p = myproc();
80103e03:	e8 b7 f3 ff ff       	call   801031bf <myproc>
  if(p->sig_handlers[sig] == SIG_IGN)
80103e08:	8b 94 98 84 00 00 00 	mov    0x84(%eax,%ebx,4),%edx
80103e0f:	83 fa 01             	cmp    $0x1,%edx
80103e12:	74 11                	je     80103e25 <handleSignal+0x2c>
  {
    // do nothing
  }

  else if(p->sig_handlers[sig] == SIG_DFL)
80103e14:	85 d2                	test   %edx,%edx
80103e16:	74 12                	je     80103e2a <handleSignal+0x31>
      
    }
  }

  else
    user_handler(p, sig);
80103e18:	83 ec 08             	sub    $0x8,%esp
80103e1b:	53                   	push   %ebx
80103e1c:	50                   	push   %eax
80103e1d:	e8 48 ff ff ff       	call   80103d6a <user_handler>
80103e22:	83 c4 10             	add    $0x10,%esp
}
80103e25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e28:	c9                   	leave  
80103e29:	c3                   	ret    
    switch (sig) 
80103e2a:	83 fb 11             	cmp    $0x11,%ebx
80103e2d:	74 2d                	je     80103e5c <handleSignal+0x63>
80103e2f:	83 fb 13             	cmp    $0x13,%ebx
80103e32:	74 21                	je     80103e55 <handleSignal+0x5c>
80103e34:	83 fb 09             	cmp    $0x9,%ebx
80103e37:	74 2a                	je     80103e63 <handleSignal+0x6a>
        if(sig != SIGKILL && sig != SIGSTOP && sig != SIGCONT) {
80103e39:	83 fb 09             	cmp    $0x9,%ebx
80103e3c:	0f 95 c2             	setne  %dl
80103e3f:	83 fb 11             	cmp    $0x11,%ebx
80103e42:	0f 95 c0             	setne  %al
80103e45:	84 c2                	test   %al,%dl
80103e47:	74 dc                	je     80103e25 <handleSignal+0x2c>
80103e49:	83 fb 13             	cmp    $0x13,%ebx
80103e4c:	74 d7                	je     80103e25 <handleSignal+0x2c>
          sigkill_handler();
80103e4e:	e8 0b fd ff ff       	call   80103b5e <sigkill_handler>
80103e53:	eb d0                	jmp    80103e25 <handleSignal+0x2c>
        sigcont_handler();
80103e55:	e8 49 fd ff ff       	call   80103ba3 <sigcont_handler>
        break;
80103e5a:	eb c9                	jmp    80103e25 <handleSignal+0x2c>
        sigstop_handler();
80103e5c:	e8 20 fd ff ff       	call   80103b81 <sigstop_handler>
        break;
80103e61:	eb c2                	jmp    80103e25 <handleSignal+0x2c>
        sigkill_handler();
80103e63:	e8 f6 fc ff ff       	call   80103b5e <sigkill_handler>
        break;
80103e68:	eb bb                	jmp    80103e25 <handleSignal+0x2c>

80103e6a <handle_signals>:

void
handle_signals (){
80103e6a:	55                   	push   %ebp
80103e6b:	89 e5                	mov    %esp,%ebp
80103e6d:	57                   	push   %edi
80103e6e:	56                   	push   %esi
80103e6f:	53                   	push   %ebx
80103e70:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p = myproc();
80103e73:	e8 47 f3 ff ff       	call   801031bf <myproc>
  uint sig;

  if(p == 0)
80103e78:	85 c0                	test   %eax,%eax
80103e7a:	74 54                	je     80103ed0 <pass2587+0x14>
80103e7c:	89 c7                	mov    %eax,%edi
    return;

  // acquire(&ptable.lock);
  // pushcli();
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
80103e7e:	be 00 00 00 00       	mov    $0x0,%esi
80103e83:	eb 03                	jmp    80103e88 <handle_signals+0x1e>
80103e85:	83 c6 01             	add    $0x1,%esi
80103e88:	83 fe 1f             	cmp    $0x1f,%esi
80103e8b:	77 43                	ja     80103ed0 <pass2587+0x14>
  //signal sig is pending and is not blocked
  if(p->sigmask & (1 << sig))
80103e8d:	ba 01 00 00 00       	mov    $0x1,%edx
80103e92:	89 f1                	mov    %esi,%ecx
80103e94:	d3 e2                	shl    %cl,%edx
80103e96:	85 97 80 00 00 00    	test   %edx,0x80(%edi)
80103e9c:	75 e7                	jne    80103e85 <handle_signals+0x1b>
  {
    continue;
  }
  int expected = p->psignals | (1 << sig) ;
80103e9e:	89 d0                	mov    %edx,%eax
80103ea0:	0b 47 7c             	or     0x7c(%edi),%eax
  if(cas((int*)(&p->psignals), expected, expected ^ (1 << sig)))
80103ea3:	31 c2                	xor    %eax,%edx
80103ea5:	8d 5f 7c             	lea    0x7c(%edi),%ebx
  int ret_val = 1;
80103ea8:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103eaf:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103eb3:	74 07                	je     80103ebc <pass2587>
80103eb5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103ebc <pass2587>:
80103ebc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80103ec0:	74 c3                	je     80103e85 <handle_signals+0x1b>
  {
    handleSignal(sig);           // handle it
80103ec2:	83 ec 0c             	sub    $0xc,%esp
80103ec5:	56                   	push   %esi
80103ec6:	e8 2e ff ff ff       	call   80103df9 <handleSignal>
80103ecb:	83 c4 10             	add    $0x10,%esp
80103ece:	eb b5                	jmp    80103e85 <handle_signals+0x1b>
  //   }
  }
  // popcli();
  // release(&ptable.lock);
  return;
}
80103ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ed3:	5b                   	pop    %ebx
80103ed4:	5e                   	pop    %esi
80103ed5:	5f                   	pop    %edi
80103ed6:	5d                   	pop    %ebp
80103ed7:	c3                   	ret    

80103ed8 <sigret>:

int
sigret(void) {
80103ed8:	55                   	push   %ebp
80103ed9:	89 e5                	mov    %esp,%ebp
80103edb:	83 ec 08             	sub    $0x8,%esp
  struct proc* p = myproc();
80103ede:	e8 dc f2 ff ff       	call   801031bf <myproc>
  memmove(p->tf, p->tf_backup, sizeof(struct trapframe)); // trapframe restore
80103ee3:	83 ec 04             	sub    $0x4,%esp
80103ee6:	6a 4c                	push   $0x4c
80103ee8:	ff b0 04 01 00 00    	pushl  0x104(%eax)
80103eee:	ff 70 18             	pushl  0x18(%eax)
80103ef1:	e8 75 03 00 00       	call   8010426b <memmove>
  return 0;
80103ef6:	b8 00 00 00 00       	mov    $0x0,%eax
80103efb:	c9                   	leave  
80103efc:	c3                   	ret    

80103efd <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103efd:	55                   	push   %ebp
80103efe:	89 e5                	mov    %esp,%ebp
80103f00:	53                   	push   %ebx
80103f01:	83 ec 0c             	sub    $0xc,%esp
80103f04:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f07:	68 48 72 10 80       	push   $0x80107248
80103f0c:	8d 43 04             	lea    0x4(%ebx),%eax
80103f0f:	50                   	push   %eax
80103f10:	e8 f3 00 00 00       	call   80104008 <initlock>
  lk->name = name;
80103f15:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f18:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103f1b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f21:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103f28:	83 c4 10             	add    $0x10,%esp
80103f2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f2e:	c9                   	leave  
80103f2f:	c3                   	ret    

80103f30 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	56                   	push   %esi
80103f34:	53                   	push   %ebx
80103f35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f38:	8d 73 04             	lea    0x4(%ebx),%esi
80103f3b:	83 ec 0c             	sub    $0xc,%esp
80103f3e:	56                   	push   %esi
80103f3f:	e8 00 02 00 00       	call   80104144 <acquire>
  while (lk->locked) {
80103f44:	83 c4 10             	add    $0x10,%esp
80103f47:	eb 0d                	jmp    80103f56 <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103f49:	83 ec 08             	sub    $0x8,%esp
80103f4c:	56                   	push   %esi
80103f4d:	53                   	push   %ebx
80103f4e:	e8 e9 f9 ff ff       	call   8010393c <sleep>
80103f53:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103f56:	83 3b 00             	cmpl   $0x0,(%ebx)
80103f59:	75 ee                	jne    80103f49 <acquiresleep+0x19>
  }
  lk->locked = 1;
80103f5b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103f61:	e8 59 f2 ff ff       	call   801031bf <myproc>
80103f66:	8b 40 10             	mov    0x10(%eax),%eax
80103f69:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103f6c:	83 ec 0c             	sub    $0xc,%esp
80103f6f:	56                   	push   %esi
80103f70:	e8 34 02 00 00       	call   801041a9 <release>
}
80103f75:	83 c4 10             	add    $0x10,%esp
80103f78:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f7b:	5b                   	pop    %ebx
80103f7c:	5e                   	pop    %esi
80103f7d:	5d                   	pop    %ebp
80103f7e:	c3                   	ret    

80103f7f <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103f7f:	55                   	push   %ebp
80103f80:	89 e5                	mov    %esp,%ebp
80103f82:	56                   	push   %esi
80103f83:	53                   	push   %ebx
80103f84:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103f87:	8d 73 04             	lea    0x4(%ebx),%esi
80103f8a:	83 ec 0c             	sub    $0xc,%esp
80103f8d:	56                   	push   %esi
80103f8e:	e8 b1 01 00 00       	call   80104144 <acquire>
  lk->locked = 0;
80103f93:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103f99:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103fa0:	89 1c 24             	mov    %ebx,(%esp)
80103fa3:	e8 40 fa ff ff       	call   801039e8 <wakeup>
  release(&lk->lk);
80103fa8:	89 34 24             	mov    %esi,(%esp)
80103fab:	e8 f9 01 00 00       	call   801041a9 <release>
}
80103fb0:	83 c4 10             	add    $0x10,%esp
80103fb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb6:	5b                   	pop    %ebx
80103fb7:	5e                   	pop    %esi
80103fb8:	5d                   	pop    %ebp
80103fb9:	c3                   	ret    

80103fba <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103fba:	55                   	push   %ebp
80103fbb:	89 e5                	mov    %esp,%ebp
80103fbd:	56                   	push   %esi
80103fbe:	53                   	push   %ebx
80103fbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103fc2:	8d 73 04             	lea    0x4(%ebx),%esi
80103fc5:	83 ec 0c             	sub    $0xc,%esp
80103fc8:	56                   	push   %esi
80103fc9:	e8 76 01 00 00       	call   80104144 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103fce:	83 c4 10             	add    $0x10,%esp
80103fd1:	83 3b 00             	cmpl   $0x0,(%ebx)
80103fd4:	75 17                	jne    80103fed <holdingsleep+0x33>
80103fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103fdb:	83 ec 0c             	sub    $0xc,%esp
80103fde:	56                   	push   %esi
80103fdf:	e8 c5 01 00 00       	call   801041a9 <release>
  return r;
}
80103fe4:	89 d8                	mov    %ebx,%eax
80103fe6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fe9:	5b                   	pop    %ebx
80103fea:	5e                   	pop    %esi
80103feb:	5d                   	pop    %ebp
80103fec:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103fed:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103ff0:	e8 ca f1 ff ff       	call   801031bf <myproc>
80103ff5:	3b 58 10             	cmp    0x10(%eax),%ebx
80103ff8:	74 07                	je     80104001 <holdingsleep+0x47>
80103ffa:	bb 00 00 00 00       	mov    $0x0,%ebx
80103fff:	eb da                	jmp    80103fdb <holdingsleep+0x21>
80104001:	bb 01 00 00 00       	mov    $0x1,%ebx
80104006:	eb d3                	jmp    80103fdb <holdingsleep+0x21>

80104008 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104008:	55                   	push   %ebp
80104009:	89 e5                	mov    %esp,%ebp
8010400b:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010400e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104011:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104014:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010401a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104021:	5d                   	pop    %ebp
80104022:	c3                   	ret    

80104023 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104023:	55                   	push   %ebp
80104024:	89 e5                	mov    %esp,%ebp
80104026:	53                   	push   %ebx
80104027:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010402a:	8b 45 08             	mov    0x8(%ebp),%eax
8010402d:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104030:	b8 00 00 00 00       	mov    $0x0,%eax
80104035:	83 f8 09             	cmp    $0x9,%eax
80104038:	7f 25                	jg     8010405f <getcallerpcs+0x3c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010403a:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104040:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104046:	77 17                	ja     8010405f <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104048:	8b 5a 04             	mov    0x4(%edx),%ebx
8010404b:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
8010404e:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104050:	83 c0 01             	add    $0x1,%eax
80104053:	eb e0                	jmp    80104035 <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104055:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010405c:	83 c0 01             	add    $0x1,%eax
8010405f:	83 f8 09             	cmp    $0x9,%eax
80104062:	7e f1                	jle    80104055 <getcallerpcs+0x32>
}
80104064:	5b                   	pop    %ebx
80104065:	5d                   	pop    %ebp
80104066:	c3                   	ret    

80104067 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104067:	55                   	push   %ebp
80104068:	89 e5                	mov    %esp,%ebp
8010406a:	53                   	push   %ebx
8010406b:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010406e:	9c                   	pushf  
8010406f:	5b                   	pop    %ebx
  asm volatile("cli");
80104070:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104071:	e8 d2 f0 ff ff       	call   80103148 <mycpu>
80104076:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
8010407d:	74 12                	je     80104091 <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010407f:	e8 c4 f0 ff ff       	call   80103148 <mycpu>
80104084:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
8010408b:	83 c4 04             	add    $0x4,%esp
8010408e:	5b                   	pop    %ebx
8010408f:	5d                   	pop    %ebp
80104090:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80104091:	e8 b2 f0 ff ff       	call   80103148 <mycpu>
80104096:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010409c:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801040a2:	eb db                	jmp    8010407f <pushcli+0x18>

801040a4 <popcli>:

void
popcli(void)
{
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040aa:	9c                   	pushf  
801040ab:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040ac:	f6 c4 02             	test   $0x2,%ah
801040af:	75 28                	jne    801040d9 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801040b1:	e8 92 f0 ff ff       	call   80103148 <mycpu>
801040b6:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801040bc:	8d 51 ff             	lea    -0x1(%ecx),%edx
801040bf:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801040c5:	85 d2                	test   %edx,%edx
801040c7:	78 1d                	js     801040e6 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801040c9:	e8 7a f0 ff ff       	call   80103148 <mycpu>
801040ce:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
801040d5:	74 1c                	je     801040f3 <popcli+0x4f>
    sti();
}
801040d7:	c9                   	leave  
801040d8:	c3                   	ret    
    panic("popcli - interruptible");
801040d9:	83 ec 0c             	sub    $0xc,%esp
801040dc:	68 53 72 10 80       	push   $0x80107253
801040e1:	e8 62 c2 ff ff       	call   80100348 <panic>
    panic("popcli");
801040e6:	83 ec 0c             	sub    $0xc,%esp
801040e9:	68 6a 72 10 80       	push   $0x8010726a
801040ee:	e8 55 c2 ff ff       	call   80100348 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
801040f3:	e8 50 f0 ff ff       	call   80103148 <mycpu>
801040f8:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
801040ff:	74 d6                	je     801040d7 <popcli+0x33>
  asm volatile("sti");
80104101:	fb                   	sti    
}
80104102:	eb d3                	jmp    801040d7 <popcli+0x33>

80104104 <holding>:
{
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	53                   	push   %ebx
80104108:	83 ec 04             	sub    $0x4,%esp
8010410b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010410e:	e8 54 ff ff ff       	call   80104067 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104113:	83 3b 00             	cmpl   $0x0,(%ebx)
80104116:	75 12                	jne    8010412a <holding+0x26>
80104118:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
8010411d:	e8 82 ff ff ff       	call   801040a4 <popcli>
}
80104122:	89 d8                	mov    %ebx,%eax
80104124:	83 c4 04             	add    $0x4,%esp
80104127:	5b                   	pop    %ebx
80104128:	5d                   	pop    %ebp
80104129:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
8010412a:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010412d:	e8 16 f0 ff ff       	call   80103148 <mycpu>
80104132:	39 c3                	cmp    %eax,%ebx
80104134:	74 07                	je     8010413d <holding+0x39>
80104136:	bb 00 00 00 00       	mov    $0x0,%ebx
8010413b:	eb e0                	jmp    8010411d <holding+0x19>
8010413d:	bb 01 00 00 00       	mov    $0x1,%ebx
80104142:	eb d9                	jmp    8010411d <holding+0x19>

80104144 <acquire>:
{
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	53                   	push   %ebx
80104148:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010414b:	e8 17 ff ff ff       	call   80104067 <pushcli>
  if(holding(lk))
80104150:	83 ec 0c             	sub    $0xc,%esp
80104153:	ff 75 08             	pushl  0x8(%ebp)
80104156:	e8 a9 ff ff ff       	call   80104104 <holding>
8010415b:	83 c4 10             	add    $0x10,%esp
8010415e:	85 c0                	test   %eax,%eax
80104160:	75 3a                	jne    8010419c <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80104162:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80104165:	b8 01 00 00 00       	mov    $0x1,%eax
8010416a:	f0 87 02             	lock xchg %eax,(%edx)
8010416d:	85 c0                	test   %eax,%eax
8010416f:	75 f1                	jne    80104162 <acquire+0x1e>
  __sync_synchronize();
80104171:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104176:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104179:	e8 ca ef ff ff       	call   80103148 <mycpu>
8010417e:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80104181:	8b 45 08             	mov    0x8(%ebp),%eax
80104184:	83 c0 0c             	add    $0xc,%eax
80104187:	83 ec 08             	sub    $0x8,%esp
8010418a:	50                   	push   %eax
8010418b:	8d 45 08             	lea    0x8(%ebp),%eax
8010418e:	50                   	push   %eax
8010418f:	e8 8f fe ff ff       	call   80104023 <getcallerpcs>
}
80104194:	83 c4 10             	add    $0x10,%esp
80104197:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010419a:	c9                   	leave  
8010419b:	c3                   	ret    
    panic("acquire");
8010419c:	83 ec 0c             	sub    $0xc,%esp
8010419f:	68 71 72 10 80       	push   $0x80107271
801041a4:	e8 9f c1 ff ff       	call   80100348 <panic>

801041a9 <release>:
{
801041a9:	55                   	push   %ebp
801041aa:	89 e5                	mov    %esp,%ebp
801041ac:	53                   	push   %ebx
801041ad:	83 ec 10             	sub    $0x10,%esp
801041b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801041b3:	53                   	push   %ebx
801041b4:	e8 4b ff ff ff       	call   80104104 <holding>
801041b9:	83 c4 10             	add    $0x10,%esp
801041bc:	85 c0                	test   %eax,%eax
801041be:	74 23                	je     801041e3 <release+0x3a>
  lk->pcs[0] = 0;
801041c0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801041c7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801041ce:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801041d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
801041d9:	e8 c6 fe ff ff       	call   801040a4 <popcli>
}
801041de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041e1:	c9                   	leave  
801041e2:	c3                   	ret    
    panic("release");
801041e3:	83 ec 0c             	sub    $0xc,%esp
801041e6:	68 79 72 10 80       	push   $0x80107279
801041eb:	e8 58 c1 ff ff       	call   80100348 <panic>

801041f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
801041f4:	53                   	push   %ebx
801041f5:	8b 55 08             	mov    0x8(%ebp),%edx
801041f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801041fb:	f6 c2 03             	test   $0x3,%dl
801041fe:	75 05                	jne    80104205 <memset+0x15>
80104200:	f6 c1 03             	test   $0x3,%cl
80104203:	74 0e                	je     80104213 <memset+0x23>
  asm volatile("cld; rep stosb" :
80104205:	89 d7                	mov    %edx,%edi
80104207:	8b 45 0c             	mov    0xc(%ebp),%eax
8010420a:	fc                   	cld    
8010420b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010420d:	89 d0                	mov    %edx,%eax
8010420f:	5b                   	pop    %ebx
80104210:	5f                   	pop    %edi
80104211:	5d                   	pop    %ebp
80104212:	c3                   	ret    
    c &= 0xFF;
80104213:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104217:	c1 e9 02             	shr    $0x2,%ecx
8010421a:	89 f8                	mov    %edi,%eax
8010421c:	c1 e0 18             	shl    $0x18,%eax
8010421f:	89 fb                	mov    %edi,%ebx
80104221:	c1 e3 10             	shl    $0x10,%ebx
80104224:	09 d8                	or     %ebx,%eax
80104226:	89 fb                	mov    %edi,%ebx
80104228:	c1 e3 08             	shl    $0x8,%ebx
8010422b:	09 d8                	or     %ebx,%eax
8010422d:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
8010422f:	89 d7                	mov    %edx,%edi
80104231:	fc                   	cld    
80104232:	f3 ab                	rep stos %eax,%es:(%edi)
80104234:	eb d7                	jmp    8010420d <memset+0x1d>

80104236 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104236:	55                   	push   %ebp
80104237:	89 e5                	mov    %esp,%ebp
80104239:	56                   	push   %esi
8010423a:	53                   	push   %ebx
8010423b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010423e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104241:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104244:	8d 70 ff             	lea    -0x1(%eax),%esi
80104247:	85 c0                	test   %eax,%eax
80104249:	74 1c                	je     80104267 <memcmp+0x31>
    if(*s1 != *s2)
8010424b:	0f b6 01             	movzbl (%ecx),%eax
8010424e:	0f b6 1a             	movzbl (%edx),%ebx
80104251:	38 d8                	cmp    %bl,%al
80104253:	75 0a                	jne    8010425f <memcmp+0x29>
      return *s1 - *s2;
    s1++, s2++;
80104255:	83 c1 01             	add    $0x1,%ecx
80104258:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
8010425b:	89 f0                	mov    %esi,%eax
8010425d:	eb e5                	jmp    80104244 <memcmp+0xe>
      return *s1 - *s2;
8010425f:	0f b6 c0             	movzbl %al,%eax
80104262:	0f b6 db             	movzbl %bl,%ebx
80104265:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104267:	5b                   	pop    %ebx
80104268:	5e                   	pop    %esi
80104269:	5d                   	pop    %ebp
8010426a:	c3                   	ret    

8010426b <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010426b:	55                   	push   %ebp
8010426c:	89 e5                	mov    %esp,%ebp
8010426e:	56                   	push   %esi
8010426f:	53                   	push   %ebx
80104270:	8b 45 08             	mov    0x8(%ebp),%eax
80104273:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104276:	8b 55 10             	mov    0x10(%ebp),%edx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104279:	39 c1                	cmp    %eax,%ecx
8010427b:	73 3a                	jae    801042b7 <memmove+0x4c>
8010427d:	8d 1c 11             	lea    (%ecx,%edx,1),%ebx
80104280:	39 c3                	cmp    %eax,%ebx
80104282:	76 37                	jbe    801042bb <memmove+0x50>
    s += n;
    d += n;
80104284:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
    while(n-- > 0)
80104287:	eb 0d                	jmp    80104296 <memmove+0x2b>
      *--d = *--s;
80104289:	83 eb 01             	sub    $0x1,%ebx
8010428c:	83 e9 01             	sub    $0x1,%ecx
8010428f:	0f b6 13             	movzbl (%ebx),%edx
80104292:	88 11                	mov    %dl,(%ecx)
    while(n-- > 0)
80104294:	89 f2                	mov    %esi,%edx
80104296:	8d 72 ff             	lea    -0x1(%edx),%esi
80104299:	85 d2                	test   %edx,%edx
8010429b:	75 ec                	jne    80104289 <memmove+0x1e>
8010429d:	eb 14                	jmp    801042b3 <memmove+0x48>
  } else
    while(n-- > 0)
      *d++ = *s++;
8010429f:	0f b6 11             	movzbl (%ecx),%edx
801042a2:	88 13                	mov    %dl,(%ebx)
801042a4:	8d 5b 01             	lea    0x1(%ebx),%ebx
801042a7:	8d 49 01             	lea    0x1(%ecx),%ecx
    while(n-- > 0)
801042aa:	89 f2                	mov    %esi,%edx
801042ac:	8d 72 ff             	lea    -0x1(%edx),%esi
801042af:	85 d2                	test   %edx,%edx
801042b1:	75 ec                	jne    8010429f <memmove+0x34>

  return dst;
}
801042b3:	5b                   	pop    %ebx
801042b4:	5e                   	pop    %esi
801042b5:	5d                   	pop    %ebp
801042b6:	c3                   	ret    
801042b7:	89 c3                	mov    %eax,%ebx
801042b9:	eb f1                	jmp    801042ac <memmove+0x41>
801042bb:	89 c3                	mov    %eax,%ebx
801042bd:	eb ed                	jmp    801042ac <memmove+0x41>

801042bf <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801042bf:	55                   	push   %ebp
801042c0:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801042c2:	ff 75 10             	pushl  0x10(%ebp)
801042c5:	ff 75 0c             	pushl  0xc(%ebp)
801042c8:	ff 75 08             	pushl  0x8(%ebp)
801042cb:	e8 9b ff ff ff       	call   8010426b <memmove>
}
801042d0:	c9                   	leave  
801042d1:	c3                   	ret    

801042d2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801042d2:	55                   	push   %ebp
801042d3:	89 e5                	mov    %esp,%ebp
801042d5:	53                   	push   %ebx
801042d6:	8b 55 08             	mov    0x8(%ebp),%edx
801042d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801042dc:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801042df:	eb 09                	jmp    801042ea <strncmp+0x18>
    n--, p++, q++;
801042e1:	83 e8 01             	sub    $0x1,%eax
801042e4:	83 c2 01             	add    $0x1,%edx
801042e7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 0b                	je     801042f9 <strncmp+0x27>
801042ee:	0f b6 1a             	movzbl (%edx),%ebx
801042f1:	84 db                	test   %bl,%bl
801042f3:	74 04                	je     801042f9 <strncmp+0x27>
801042f5:	3a 19                	cmp    (%ecx),%bl
801042f7:	74 e8                	je     801042e1 <strncmp+0xf>
  if(n == 0)
801042f9:	85 c0                	test   %eax,%eax
801042fb:	74 0b                	je     80104308 <strncmp+0x36>
    return 0;
  return (uchar)*p - (uchar)*q;
801042fd:	0f b6 02             	movzbl (%edx),%eax
80104300:	0f b6 11             	movzbl (%ecx),%edx
80104303:	29 d0                	sub    %edx,%eax
}
80104305:	5b                   	pop    %ebx
80104306:	5d                   	pop    %ebp
80104307:	c3                   	ret    
    return 0;
80104308:	b8 00 00 00 00       	mov    $0x0,%eax
8010430d:	eb f6                	jmp    80104305 <strncmp+0x33>

8010430f <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010430f:	55                   	push   %ebp
80104310:	89 e5                	mov    %esp,%ebp
80104312:	57                   	push   %edi
80104313:	56                   	push   %esi
80104314:	53                   	push   %ebx
80104315:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104318:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010431b:	8b 45 08             	mov    0x8(%ebp),%eax
8010431e:	eb 04                	jmp    80104324 <strncpy+0x15>
80104320:	89 fb                	mov    %edi,%ebx
80104322:	89 f0                	mov    %esi,%eax
80104324:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104327:	85 c9                	test   %ecx,%ecx
80104329:	7e 1d                	jle    80104348 <strncpy+0x39>
8010432b:	8d 7b 01             	lea    0x1(%ebx),%edi
8010432e:	8d 70 01             	lea    0x1(%eax),%esi
80104331:	0f b6 1b             	movzbl (%ebx),%ebx
80104334:	88 18                	mov    %bl,(%eax)
80104336:	89 d1                	mov    %edx,%ecx
80104338:	84 db                	test   %bl,%bl
8010433a:	75 e4                	jne    80104320 <strncpy+0x11>
8010433c:	89 f0                	mov    %esi,%eax
8010433e:	eb 08                	jmp    80104348 <strncpy+0x39>
    ;
  while(n-- > 0)
    *s++ = 0;
80104340:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
80104343:	89 ca                	mov    %ecx,%edx
    *s++ = 0;
80104345:	8d 40 01             	lea    0x1(%eax),%eax
  while(n-- > 0)
80104348:	8d 4a ff             	lea    -0x1(%edx),%ecx
8010434b:	85 d2                	test   %edx,%edx
8010434d:	7f f1                	jg     80104340 <strncpy+0x31>
  return os;
}
8010434f:	8b 45 08             	mov    0x8(%ebp),%eax
80104352:	5b                   	pop    %ebx
80104353:	5e                   	pop    %esi
80104354:	5f                   	pop    %edi
80104355:	5d                   	pop    %ebp
80104356:	c3                   	ret    

80104357 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104357:	55                   	push   %ebp
80104358:	89 e5                	mov    %esp,%ebp
8010435a:	57                   	push   %edi
8010435b:	56                   	push   %esi
8010435c:	53                   	push   %ebx
8010435d:	8b 45 08             	mov    0x8(%ebp),%eax
80104360:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104363:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104366:	85 d2                	test   %edx,%edx
80104368:	7e 23                	jle    8010438d <safestrcpy+0x36>
8010436a:	89 c1                	mov    %eax,%ecx
8010436c:	eb 04                	jmp    80104372 <safestrcpy+0x1b>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
8010436e:	89 fb                	mov    %edi,%ebx
80104370:	89 f1                	mov    %esi,%ecx
80104372:	83 ea 01             	sub    $0x1,%edx
80104375:	85 d2                	test   %edx,%edx
80104377:	7e 11                	jle    8010438a <safestrcpy+0x33>
80104379:	8d 7b 01             	lea    0x1(%ebx),%edi
8010437c:	8d 71 01             	lea    0x1(%ecx),%esi
8010437f:	0f b6 1b             	movzbl (%ebx),%ebx
80104382:	88 19                	mov    %bl,(%ecx)
80104384:	84 db                	test   %bl,%bl
80104386:	75 e6                	jne    8010436e <safestrcpy+0x17>
80104388:	89 f1                	mov    %esi,%ecx
    ;
  *s = 0;
8010438a:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
8010438d:	5b                   	pop    %ebx
8010438e:	5e                   	pop    %esi
8010438f:	5f                   	pop    %edi
80104390:	5d                   	pop    %ebp
80104391:	c3                   	ret    

80104392 <strlen>:

int
strlen(const char *s)
{
80104392:	55                   	push   %ebp
80104393:	89 e5                	mov    %esp,%ebp
80104395:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104398:	b8 00 00 00 00       	mov    $0x0,%eax
8010439d:	eb 03                	jmp    801043a2 <strlen+0x10>
8010439f:	83 c0 01             	add    $0x1,%eax
801043a2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801043a6:	75 f7                	jne    8010439f <strlen+0xd>
    ;
  return n;
}
801043a8:	5d                   	pop    %ebp
801043a9:	c3                   	ret    

801043aa <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801043aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801043ae:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801043b2:	55                   	push   %ebp
  pushl %ebx
801043b3:	53                   	push   %ebx
  pushl %esi
801043b4:	56                   	push   %esi
  pushl %edi
801043b5:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801043b6:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801043b8:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801043ba:	5f                   	pop    %edi
  popl %esi
801043bb:	5e                   	pop    %esi
  popl %ebx
801043bc:	5b                   	pop    %ebx
  popl %ebp
801043bd:	5d                   	pop    %ebp
  ret
801043be:	c3                   	ret    

801043bf <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801043bf:	55                   	push   %ebp
801043c0:	89 e5                	mov    %esp,%ebp
801043c2:	53                   	push   %ebx
801043c3:	83 ec 04             	sub    $0x4,%esp
801043c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801043c9:	e8 f1 ed ff ff       	call   801031bf <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801043ce:	8b 00                	mov    (%eax),%eax
801043d0:	39 d8                	cmp    %ebx,%eax
801043d2:	76 19                	jbe    801043ed <fetchint+0x2e>
801043d4:	8d 53 04             	lea    0x4(%ebx),%edx
801043d7:	39 d0                	cmp    %edx,%eax
801043d9:	72 19                	jb     801043f4 <fetchint+0x35>
    return -1;
  *ip = *(int*)(addr);
801043db:	8b 13                	mov    (%ebx),%edx
801043dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801043e0:	89 10                	mov    %edx,(%eax)
  return 0;
801043e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801043e7:	83 c4 04             	add    $0x4,%esp
801043ea:	5b                   	pop    %ebx
801043eb:	5d                   	pop    %ebp
801043ec:	c3                   	ret    
    return -1;
801043ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043f2:	eb f3                	jmp    801043e7 <fetchint+0x28>
801043f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043f9:	eb ec                	jmp    801043e7 <fetchint+0x28>

801043fb <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801043fb:	55                   	push   %ebp
801043fc:	89 e5                	mov    %esp,%ebp
801043fe:	53                   	push   %ebx
801043ff:	83 ec 04             	sub    $0x4,%esp
80104402:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104405:	e8 b5 ed ff ff       	call   801031bf <myproc>

  if(addr >= curproc->sz)
8010440a:	39 18                	cmp    %ebx,(%eax)
8010440c:	76 26                	jbe    80104434 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
8010440e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104411:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104413:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104415:	89 d8                	mov    %ebx,%eax
80104417:	39 d0                	cmp    %edx,%eax
80104419:	73 0e                	jae    80104429 <fetchstr+0x2e>
    if(*s == 0)
8010441b:	80 38 00             	cmpb   $0x0,(%eax)
8010441e:	74 05                	je     80104425 <fetchstr+0x2a>
  for(s = *pp; s < ep; s++){
80104420:	83 c0 01             	add    $0x1,%eax
80104423:	eb f2                	jmp    80104417 <fetchstr+0x1c>
      return s - *pp;
80104425:	29 d8                	sub    %ebx,%eax
80104427:	eb 05                	jmp    8010442e <fetchstr+0x33>
  }
  return -1;
80104429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010442e:	83 c4 04             	add    $0x4,%esp
80104431:	5b                   	pop    %ebx
80104432:	5d                   	pop    %ebp
80104433:	c3                   	ret    
    return -1;
80104434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104439:	eb f3                	jmp    8010442e <fetchstr+0x33>

8010443b <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010443b:	55                   	push   %ebp
8010443c:	89 e5                	mov    %esp,%ebp
8010443e:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104441:	e8 79 ed ff ff       	call   801031bf <myproc>
80104446:	8b 50 18             	mov    0x18(%eax),%edx
80104449:	8b 45 08             	mov    0x8(%ebp),%eax
8010444c:	c1 e0 02             	shl    $0x2,%eax
8010444f:	03 42 44             	add    0x44(%edx),%eax
80104452:	83 ec 08             	sub    $0x8,%esp
80104455:	ff 75 0c             	pushl  0xc(%ebp)
80104458:	83 c0 04             	add    $0x4,%eax
8010445b:	50                   	push   %eax
8010445c:	e8 5e ff ff ff       	call   801043bf <fetchint>
}
80104461:	c9                   	leave  
80104462:	c3                   	ret    

80104463 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104463:	55                   	push   %ebp
80104464:	89 e5                	mov    %esp,%ebp
80104466:	56                   	push   %esi
80104467:	53                   	push   %ebx
80104468:	83 ec 10             	sub    $0x10,%esp
8010446b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010446e:	e8 4c ed ff ff       	call   801031bf <myproc>
80104473:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104475:	83 ec 08             	sub    $0x8,%esp
80104478:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010447b:	50                   	push   %eax
8010447c:	ff 75 08             	pushl  0x8(%ebp)
8010447f:	e8 b7 ff ff ff       	call   8010443b <argint>
80104484:	83 c4 10             	add    $0x10,%esp
80104487:	85 c0                	test   %eax,%eax
80104489:	78 24                	js     801044af <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010448b:	85 db                	test   %ebx,%ebx
8010448d:	78 27                	js     801044b6 <argptr+0x53>
8010448f:	8b 16                	mov    (%esi),%edx
80104491:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104494:	39 c2                	cmp    %eax,%edx
80104496:	76 25                	jbe    801044bd <argptr+0x5a>
80104498:	01 c3                	add    %eax,%ebx
8010449a:	39 da                	cmp    %ebx,%edx
8010449c:	72 26                	jb     801044c4 <argptr+0x61>
    return -1;
  *pp = (char*)i;
8010449e:	8b 55 0c             	mov    0xc(%ebp),%edx
801044a1:	89 02                	mov    %eax,(%edx)
  return 0;
801044a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044ab:	5b                   	pop    %ebx
801044ac:	5e                   	pop    %esi
801044ad:	5d                   	pop    %ebp
801044ae:	c3                   	ret    
    return -1;
801044af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044b4:	eb f2                	jmp    801044a8 <argptr+0x45>
    return -1;
801044b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044bb:	eb eb                	jmp    801044a8 <argptr+0x45>
801044bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044c2:	eb e4                	jmp    801044a8 <argptr+0x45>
801044c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044c9:	eb dd                	jmp    801044a8 <argptr+0x45>

801044cb <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801044cb:	55                   	push   %ebp
801044cc:	89 e5                	mov    %esp,%ebp
801044ce:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801044d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801044d4:	50                   	push   %eax
801044d5:	ff 75 08             	pushl  0x8(%ebp)
801044d8:	e8 5e ff ff ff       	call   8010443b <argint>
801044dd:	83 c4 10             	add    $0x10,%esp
801044e0:	85 c0                	test   %eax,%eax
801044e2:	78 13                	js     801044f7 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
801044e4:	83 ec 08             	sub    $0x8,%esp
801044e7:	ff 75 0c             	pushl  0xc(%ebp)
801044ea:	ff 75 f4             	pushl  -0xc(%ebp)
801044ed:	e8 09 ff ff ff       	call   801043fb <fetchstr>
801044f2:	83 c4 10             	add    $0x10,%esp
}
801044f5:	c9                   	leave  
801044f6:	c3                   	ret    
    return -1;
801044f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044fc:	eb f7                	jmp    801044f5 <argstr+0x2a>

801044fe <syscall>:
[SYS_sigret]      sys_sigret
};

void
syscall(void)
{
801044fe:	55                   	push   %ebp
801044ff:	89 e5                	mov    %esp,%ebp
80104501:	53                   	push   %ebx
80104502:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104505:	e8 b5 ec ff ff       	call   801031bf <myproc>
8010450a:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010450c:	8b 40 18             	mov    0x18(%eax),%eax
8010450f:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104512:	8d 50 ff             	lea    -0x1(%eax),%edx
80104515:	83 fa 17             	cmp    $0x17,%edx
80104518:	77 18                	ja     80104532 <syscall+0x34>
8010451a:	8b 14 85 a0 72 10 80 	mov    -0x7fef8d60(,%eax,4),%edx
80104521:	85 d2                	test   %edx,%edx
80104523:	74 0d                	je     80104532 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
80104525:	ff d2                	call   *%edx
80104527:	8b 53 18             	mov    0x18(%ebx),%edx
8010452a:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010452d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104530:	c9                   	leave  
80104531:	c3                   	ret    
            curproc->pid, curproc->name, num);
80104532:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104535:	50                   	push   %eax
80104536:	52                   	push   %edx
80104537:	ff 73 10             	pushl  0x10(%ebx)
8010453a:	68 81 72 10 80       	push   $0x80107281
8010453f:	e8 c7 c0 ff ff       	call   8010060b <cprintf>
    curproc->tf->eax = -1;
80104544:	8b 43 18             	mov    0x18(%ebx),%eax
80104547:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010454e:	83 c4 10             	add    $0x10,%esp
}
80104551:	eb da                	jmp    8010452d <syscall+0x2f>

80104553 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104553:	55                   	push   %ebp
80104554:	89 e5                	mov    %esp,%ebp
80104556:	56                   	push   %esi
80104557:	53                   	push   %ebx
80104558:	83 ec 18             	sub    $0x18,%esp
8010455b:	89 d6                	mov    %edx,%esi
8010455d:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010455f:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104562:	52                   	push   %edx
80104563:	50                   	push   %eax
80104564:	e8 d2 fe ff ff       	call   8010443b <argint>
80104569:	83 c4 10             	add    $0x10,%esp
8010456c:	85 c0                	test   %eax,%eax
8010456e:	78 2e                	js     8010459e <argfd+0x4b>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104570:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104574:	77 2f                	ja     801045a5 <argfd+0x52>
80104576:	e8 44 ec ff ff       	call   801031bf <myproc>
8010457b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010457e:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104582:	85 c0                	test   %eax,%eax
80104584:	74 26                	je     801045ac <argfd+0x59>
    return -1;
  if(pfd)
80104586:	85 f6                	test   %esi,%esi
80104588:	74 02                	je     8010458c <argfd+0x39>
    *pfd = fd;
8010458a:	89 16                	mov    %edx,(%esi)
  if(pf)
8010458c:	85 db                	test   %ebx,%ebx
8010458e:	74 23                	je     801045b3 <argfd+0x60>
    *pf = f;
80104590:	89 03                	mov    %eax,(%ebx)
  return 0;
80104592:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104597:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010459a:	5b                   	pop    %ebx
8010459b:	5e                   	pop    %esi
8010459c:	5d                   	pop    %ebp
8010459d:	c3                   	ret    
    return -1;
8010459e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045a3:	eb f2                	jmp    80104597 <argfd+0x44>
    return -1;
801045a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045aa:	eb eb                	jmp    80104597 <argfd+0x44>
801045ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045b1:	eb e4                	jmp    80104597 <argfd+0x44>
  return 0;
801045b3:	b8 00 00 00 00       	mov    $0x0,%eax
801045b8:	eb dd                	jmp    80104597 <argfd+0x44>

801045ba <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801045ba:	55                   	push   %ebp
801045bb:	89 e5                	mov    %esp,%ebp
801045bd:	53                   	push   %ebx
801045be:	83 ec 04             	sub    $0x4,%esp
801045c1:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
801045c3:	e8 f7 eb ff ff       	call   801031bf <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801045c8:	ba 00 00 00 00       	mov    $0x0,%edx
801045cd:	83 fa 0f             	cmp    $0xf,%edx
801045d0:	7f 18                	jg     801045ea <fdalloc+0x30>
    if(curproc->ofile[fd] == 0){
801045d2:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
801045d7:	74 05                	je     801045de <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
801045d9:	83 c2 01             	add    $0x1,%edx
801045dc:	eb ef                	jmp    801045cd <fdalloc+0x13>
      curproc->ofile[fd] = f;
801045de:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
801045e2:	89 d0                	mov    %edx,%eax
801045e4:	83 c4 04             	add    $0x4,%esp
801045e7:	5b                   	pop    %ebx
801045e8:	5d                   	pop    %ebp
801045e9:	c3                   	ret    
  return -1;
801045ea:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801045ef:	eb f1                	jmp    801045e2 <fdalloc+0x28>

801045f1 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801045f1:	55                   	push   %ebp
801045f2:	89 e5                	mov    %esp,%ebp
801045f4:	56                   	push   %esi
801045f5:	53                   	push   %ebx
801045f6:	83 ec 10             	sub    $0x10,%esp
801045f9:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801045fb:	b8 20 00 00 00       	mov    $0x20,%eax
80104600:	89 c6                	mov    %eax,%esi
80104602:	39 43 58             	cmp    %eax,0x58(%ebx)
80104605:	76 2e                	jbe    80104635 <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104607:	6a 10                	push   $0x10
80104609:	50                   	push   %eax
8010460a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010460d:	50                   	push   %eax
8010460e:	53                   	push   %ebx
8010460f:	e8 82 d1 ff ff       	call   80101796 <readi>
80104614:	83 c4 10             	add    $0x10,%esp
80104617:	83 f8 10             	cmp    $0x10,%eax
8010461a:	75 0c                	jne    80104628 <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010461c:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
80104621:	75 1e                	jne    80104641 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104623:	8d 46 10             	lea    0x10(%esi),%eax
80104626:	eb d8                	jmp    80104600 <isdirempty+0xf>
      panic("isdirempty: readi");
80104628:	83 ec 0c             	sub    $0xc,%esp
8010462b:	68 04 73 10 80       	push   $0x80107304
80104630:	e8 13 bd ff ff       	call   80100348 <panic>
      return 0;
  }
  return 1;
80104635:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010463a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010463d:	5b                   	pop    %ebx
8010463e:	5e                   	pop    %esi
8010463f:	5d                   	pop    %ebp
80104640:	c3                   	ret    
      return 0;
80104641:	b8 00 00 00 00       	mov    $0x0,%eax
80104646:	eb f2                	jmp    8010463a <isdirempty+0x49>

80104648 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104648:	55                   	push   %ebp
80104649:	89 e5                	mov    %esp,%ebp
8010464b:	57                   	push   %edi
8010464c:	56                   	push   %esi
8010464d:	53                   	push   %ebx
8010464e:	83 ec 34             	sub    $0x34,%esp
80104651:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104654:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104657:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010465a:	8d 55 da             	lea    -0x26(%ebp),%edx
8010465d:	52                   	push   %edx
8010465e:	50                   	push   %eax
8010465f:	e8 b8 d5 ff ff       	call   80101c1c <nameiparent>
80104664:	89 c6                	mov    %eax,%esi
80104666:	83 c4 10             	add    $0x10,%esp
80104669:	85 c0                	test   %eax,%eax
8010466b:	0f 84 38 01 00 00    	je     801047a9 <create+0x161>
    return 0;
  ilock(dp);
80104671:	83 ec 0c             	sub    $0xc,%esp
80104674:	50                   	push   %eax
80104675:	e8 2a cf ff ff       	call   801015a4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
8010467a:	83 c4 0c             	add    $0xc,%esp
8010467d:	6a 00                	push   $0x0
8010467f:	8d 45 da             	lea    -0x26(%ebp),%eax
80104682:	50                   	push   %eax
80104683:	56                   	push   %esi
80104684:	e8 4a d3 ff ff       	call   801019d3 <dirlookup>
80104689:	89 c3                	mov    %eax,%ebx
8010468b:	83 c4 10             	add    $0x10,%esp
8010468e:	85 c0                	test   %eax,%eax
80104690:	74 3f                	je     801046d1 <create+0x89>
    iunlockput(dp);
80104692:	83 ec 0c             	sub    $0xc,%esp
80104695:	56                   	push   %esi
80104696:	e8 b0 d0 ff ff       	call   8010174b <iunlockput>
    ilock(ip);
8010469b:	89 1c 24             	mov    %ebx,(%esp)
8010469e:	e8 01 cf ff ff       	call   801015a4 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801046a3:	83 c4 10             	add    $0x10,%esp
801046a6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801046ab:	75 11                	jne    801046be <create+0x76>
801046ad:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801046b2:	75 0a                	jne    801046be <create+0x76>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801046b4:	89 d8                	mov    %ebx,%eax
801046b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046b9:	5b                   	pop    %ebx
801046ba:	5e                   	pop    %esi
801046bb:	5f                   	pop    %edi
801046bc:	5d                   	pop    %ebp
801046bd:	c3                   	ret    
    iunlockput(ip);
801046be:	83 ec 0c             	sub    $0xc,%esp
801046c1:	53                   	push   %ebx
801046c2:	e8 84 d0 ff ff       	call   8010174b <iunlockput>
    return 0;
801046c7:	83 c4 10             	add    $0x10,%esp
801046ca:	bb 00 00 00 00       	mov    $0x0,%ebx
801046cf:	eb e3                	jmp    801046b4 <create+0x6c>
  if((ip = ialloc(dp->dev, type)) == 0)
801046d1:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801046d5:	83 ec 08             	sub    $0x8,%esp
801046d8:	50                   	push   %eax
801046d9:	ff 36                	pushl  (%esi)
801046db:	e8 c1 cc ff ff       	call   801013a1 <ialloc>
801046e0:	89 c3                	mov    %eax,%ebx
801046e2:	83 c4 10             	add    $0x10,%esp
801046e5:	85 c0                	test   %eax,%eax
801046e7:	74 55                	je     8010473e <create+0xf6>
  ilock(ip);
801046e9:	83 ec 0c             	sub    $0xc,%esp
801046ec:	50                   	push   %eax
801046ed:	e8 b2 ce ff ff       	call   801015a4 <ilock>
  ip->major = major;
801046f2:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801046f6:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801046fa:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
801046fe:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104704:	89 1c 24             	mov    %ebx,(%esp)
80104707:	e8 37 cd ff ff       	call   80101443 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
8010470c:	83 c4 10             	add    $0x10,%esp
8010470f:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104714:	74 35                	je     8010474b <create+0x103>
  if(dirlink(dp, name, ip->inum) < 0)
80104716:	83 ec 04             	sub    $0x4,%esp
80104719:	ff 73 04             	pushl  0x4(%ebx)
8010471c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010471f:	50                   	push   %eax
80104720:	56                   	push   %esi
80104721:	e8 2d d4 ff ff       	call   80101b53 <dirlink>
80104726:	83 c4 10             	add    $0x10,%esp
80104729:	85 c0                	test   %eax,%eax
8010472b:	78 6f                	js     8010479c <create+0x154>
  iunlockput(dp);
8010472d:	83 ec 0c             	sub    $0xc,%esp
80104730:	56                   	push   %esi
80104731:	e8 15 d0 ff ff       	call   8010174b <iunlockput>
  return ip;
80104736:	83 c4 10             	add    $0x10,%esp
80104739:	e9 76 ff ff ff       	jmp    801046b4 <create+0x6c>
    panic("create: ialloc");
8010473e:	83 ec 0c             	sub    $0xc,%esp
80104741:	68 16 73 10 80       	push   $0x80107316
80104746:	e8 fd bb ff ff       	call   80100348 <panic>
    dp->nlink++;  // for ".."
8010474b:	0f b7 46 56          	movzwl 0x56(%esi),%eax
8010474f:	83 c0 01             	add    $0x1,%eax
80104752:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104756:	83 ec 0c             	sub    $0xc,%esp
80104759:	56                   	push   %esi
8010475a:	e8 e4 cc ff ff       	call   80101443 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010475f:	83 c4 0c             	add    $0xc,%esp
80104762:	ff 73 04             	pushl  0x4(%ebx)
80104765:	68 26 73 10 80       	push   $0x80107326
8010476a:	53                   	push   %ebx
8010476b:	e8 e3 d3 ff ff       	call   80101b53 <dirlink>
80104770:	83 c4 10             	add    $0x10,%esp
80104773:	85 c0                	test   %eax,%eax
80104775:	78 18                	js     8010478f <create+0x147>
80104777:	83 ec 04             	sub    $0x4,%esp
8010477a:	ff 76 04             	pushl  0x4(%esi)
8010477d:	68 25 73 10 80       	push   $0x80107325
80104782:	53                   	push   %ebx
80104783:	e8 cb d3 ff ff       	call   80101b53 <dirlink>
80104788:	83 c4 10             	add    $0x10,%esp
8010478b:	85 c0                	test   %eax,%eax
8010478d:	79 87                	jns    80104716 <create+0xce>
      panic("create dots");
8010478f:	83 ec 0c             	sub    $0xc,%esp
80104792:	68 28 73 10 80       	push   $0x80107328
80104797:	e8 ac bb ff ff       	call   80100348 <panic>
    panic("create: dirlink");
8010479c:	83 ec 0c             	sub    $0xc,%esp
8010479f:	68 34 73 10 80       	push   $0x80107334
801047a4:	e8 9f bb ff ff       	call   80100348 <panic>
    return 0;
801047a9:	89 c3                	mov    %eax,%ebx
801047ab:	e9 04 ff ff ff       	jmp    801046b4 <create+0x6c>

801047b0 <sys_dup>:
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	53                   	push   %ebx
801047b4:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
801047b7:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801047ba:	ba 00 00 00 00       	mov    $0x0,%edx
801047bf:	b8 00 00 00 00       	mov    $0x0,%eax
801047c4:	e8 8a fd ff ff       	call   80104553 <argfd>
801047c9:	85 c0                	test   %eax,%eax
801047cb:	78 23                	js     801047f0 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
801047cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d0:	e8 e5 fd ff ff       	call   801045ba <fdalloc>
801047d5:	89 c3                	mov    %eax,%ebx
801047d7:	85 c0                	test   %eax,%eax
801047d9:	78 1c                	js     801047f7 <sys_dup+0x47>
  filedup(f);
801047db:	83 ec 0c             	sub    $0xc,%esp
801047de:	ff 75 f4             	pushl  -0xc(%ebp)
801047e1:	e8 dd c4 ff ff       	call   80100cc3 <filedup>
  return fd;
801047e6:	83 c4 10             	add    $0x10,%esp
}
801047e9:	89 d8                	mov    %ebx,%eax
801047eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047ee:	c9                   	leave  
801047ef:	c3                   	ret    
    return -1;
801047f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047f5:	eb f2                	jmp    801047e9 <sys_dup+0x39>
    return -1;
801047f7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047fc:	eb eb                	jmp    801047e9 <sys_dup+0x39>

801047fe <sys_read>:
{
801047fe:	55                   	push   %ebp
801047ff:	89 e5                	mov    %esp,%ebp
80104801:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104804:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104807:	ba 00 00 00 00       	mov    $0x0,%edx
8010480c:	b8 00 00 00 00       	mov    $0x0,%eax
80104811:	e8 3d fd ff ff       	call   80104553 <argfd>
80104816:	85 c0                	test   %eax,%eax
80104818:	78 43                	js     8010485d <sys_read+0x5f>
8010481a:	83 ec 08             	sub    $0x8,%esp
8010481d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104820:	50                   	push   %eax
80104821:	6a 02                	push   $0x2
80104823:	e8 13 fc ff ff       	call   8010443b <argint>
80104828:	83 c4 10             	add    $0x10,%esp
8010482b:	85 c0                	test   %eax,%eax
8010482d:	78 35                	js     80104864 <sys_read+0x66>
8010482f:	83 ec 04             	sub    $0x4,%esp
80104832:	ff 75 f0             	pushl  -0x10(%ebp)
80104835:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104838:	50                   	push   %eax
80104839:	6a 01                	push   $0x1
8010483b:	e8 23 fc ff ff       	call   80104463 <argptr>
80104840:	83 c4 10             	add    $0x10,%esp
80104843:	85 c0                	test   %eax,%eax
80104845:	78 24                	js     8010486b <sys_read+0x6d>
  return fileread(f, p, n);
80104847:	83 ec 04             	sub    $0x4,%esp
8010484a:	ff 75 f0             	pushl  -0x10(%ebp)
8010484d:	ff 75 ec             	pushl  -0x14(%ebp)
80104850:	ff 75 f4             	pushl  -0xc(%ebp)
80104853:	e8 b4 c5 ff ff       	call   80100e0c <fileread>
80104858:	83 c4 10             	add    $0x10,%esp
}
8010485b:	c9                   	leave  
8010485c:	c3                   	ret    
    return -1;
8010485d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104862:	eb f7                	jmp    8010485b <sys_read+0x5d>
80104864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104869:	eb f0                	jmp    8010485b <sys_read+0x5d>
8010486b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104870:	eb e9                	jmp    8010485b <sys_read+0x5d>

80104872 <sys_write>:
{
80104872:	55                   	push   %ebp
80104873:	89 e5                	mov    %esp,%ebp
80104875:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104878:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010487b:	ba 00 00 00 00       	mov    $0x0,%edx
80104880:	b8 00 00 00 00       	mov    $0x0,%eax
80104885:	e8 c9 fc ff ff       	call   80104553 <argfd>
8010488a:	85 c0                	test   %eax,%eax
8010488c:	78 43                	js     801048d1 <sys_write+0x5f>
8010488e:	83 ec 08             	sub    $0x8,%esp
80104891:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104894:	50                   	push   %eax
80104895:	6a 02                	push   $0x2
80104897:	e8 9f fb ff ff       	call   8010443b <argint>
8010489c:	83 c4 10             	add    $0x10,%esp
8010489f:	85 c0                	test   %eax,%eax
801048a1:	78 35                	js     801048d8 <sys_write+0x66>
801048a3:	83 ec 04             	sub    $0x4,%esp
801048a6:	ff 75 f0             	pushl  -0x10(%ebp)
801048a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
801048ac:	50                   	push   %eax
801048ad:	6a 01                	push   $0x1
801048af:	e8 af fb ff ff       	call   80104463 <argptr>
801048b4:	83 c4 10             	add    $0x10,%esp
801048b7:	85 c0                	test   %eax,%eax
801048b9:	78 24                	js     801048df <sys_write+0x6d>
  return filewrite(f, p, n);
801048bb:	83 ec 04             	sub    $0x4,%esp
801048be:	ff 75 f0             	pushl  -0x10(%ebp)
801048c1:	ff 75 ec             	pushl  -0x14(%ebp)
801048c4:	ff 75 f4             	pushl  -0xc(%ebp)
801048c7:	e8 c5 c5 ff ff       	call   80100e91 <filewrite>
801048cc:	83 c4 10             	add    $0x10,%esp
}
801048cf:	c9                   	leave  
801048d0:	c3                   	ret    
    return -1;
801048d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048d6:	eb f7                	jmp    801048cf <sys_write+0x5d>
801048d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048dd:	eb f0                	jmp    801048cf <sys_write+0x5d>
801048df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e4:	eb e9                	jmp    801048cf <sys_write+0x5d>

801048e6 <sys_close>:
{
801048e6:	55                   	push   %ebp
801048e7:	89 e5                	mov    %esp,%ebp
801048e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801048ec:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801048ef:	8d 55 f4             	lea    -0xc(%ebp),%edx
801048f2:	b8 00 00 00 00       	mov    $0x0,%eax
801048f7:	e8 57 fc ff ff       	call   80104553 <argfd>
801048fc:	85 c0                	test   %eax,%eax
801048fe:	78 25                	js     80104925 <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
80104900:	e8 ba e8 ff ff       	call   801031bf <myproc>
80104905:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104908:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010490f:	00 
  fileclose(f);
80104910:	83 ec 0c             	sub    $0xc,%esp
80104913:	ff 75 f0             	pushl  -0x10(%ebp)
80104916:	e8 ed c3 ff ff       	call   80100d08 <fileclose>
  return 0;
8010491b:	83 c4 10             	add    $0x10,%esp
8010491e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104923:	c9                   	leave  
80104924:	c3                   	ret    
    return -1;
80104925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010492a:	eb f7                	jmp    80104923 <sys_close+0x3d>

8010492c <sys_fstat>:
{
8010492c:	55                   	push   %ebp
8010492d:	89 e5                	mov    %esp,%ebp
8010492f:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104932:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104935:	ba 00 00 00 00       	mov    $0x0,%edx
8010493a:	b8 00 00 00 00       	mov    $0x0,%eax
8010493f:	e8 0f fc ff ff       	call   80104553 <argfd>
80104944:	85 c0                	test   %eax,%eax
80104946:	78 2a                	js     80104972 <sys_fstat+0x46>
80104948:	83 ec 04             	sub    $0x4,%esp
8010494b:	6a 14                	push   $0x14
8010494d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104950:	50                   	push   %eax
80104951:	6a 01                	push   $0x1
80104953:	e8 0b fb ff ff       	call   80104463 <argptr>
80104958:	83 c4 10             	add    $0x10,%esp
8010495b:	85 c0                	test   %eax,%eax
8010495d:	78 1a                	js     80104979 <sys_fstat+0x4d>
  return filestat(f, st);
8010495f:	83 ec 08             	sub    $0x8,%esp
80104962:	ff 75 f0             	pushl  -0x10(%ebp)
80104965:	ff 75 f4             	pushl  -0xc(%ebp)
80104968:	e8 58 c4 ff ff       	call   80100dc5 <filestat>
8010496d:	83 c4 10             	add    $0x10,%esp
}
80104970:	c9                   	leave  
80104971:	c3                   	ret    
    return -1;
80104972:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104977:	eb f7                	jmp    80104970 <sys_fstat+0x44>
80104979:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010497e:	eb f0                	jmp    80104970 <sys_fstat+0x44>

80104980 <sys_link>:
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104988:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010498b:	50                   	push   %eax
8010498c:	6a 00                	push   $0x0
8010498e:	e8 38 fb ff ff       	call   801044cb <argstr>
80104993:	83 c4 10             	add    $0x10,%esp
80104996:	85 c0                	test   %eax,%eax
80104998:	0f 88 32 01 00 00    	js     80104ad0 <sys_link+0x150>
8010499e:	83 ec 08             	sub    $0x8,%esp
801049a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801049a4:	50                   	push   %eax
801049a5:	6a 01                	push   $0x1
801049a7:	e8 1f fb ff ff       	call   801044cb <argstr>
801049ac:	83 c4 10             	add    $0x10,%esp
801049af:	85 c0                	test   %eax,%eax
801049b1:	0f 88 20 01 00 00    	js     80104ad7 <sys_link+0x157>
  begin_op();
801049b7:	e8 15 de ff ff       	call   801027d1 <begin_op>
  if((ip = namei(old)) == 0){
801049bc:	83 ec 0c             	sub    $0xc,%esp
801049bf:	ff 75 e0             	pushl  -0x20(%ebp)
801049c2:	e8 3d d2 ff ff       	call   80101c04 <namei>
801049c7:	89 c3                	mov    %eax,%ebx
801049c9:	83 c4 10             	add    $0x10,%esp
801049cc:	85 c0                	test   %eax,%eax
801049ce:	0f 84 99 00 00 00    	je     80104a6d <sys_link+0xed>
  ilock(ip);
801049d4:	83 ec 0c             	sub    $0xc,%esp
801049d7:	50                   	push   %eax
801049d8:	e8 c7 cb ff ff       	call   801015a4 <ilock>
  if(ip->type == T_DIR){
801049dd:	83 c4 10             	add    $0x10,%esp
801049e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801049e5:	0f 84 8e 00 00 00    	je     80104a79 <sys_link+0xf9>
  ip->nlink++;
801049eb:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
801049ef:	83 c0 01             	add    $0x1,%eax
801049f2:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801049f6:	83 ec 0c             	sub    $0xc,%esp
801049f9:	53                   	push   %ebx
801049fa:	e8 44 ca ff ff       	call   80101443 <iupdate>
  iunlock(ip);
801049ff:	89 1c 24             	mov    %ebx,(%esp)
80104a02:	e8 5f cc ff ff       	call   80101666 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104a07:	83 c4 08             	add    $0x8,%esp
80104a0a:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104a0d:	50                   	push   %eax
80104a0e:	ff 75 e4             	pushl  -0x1c(%ebp)
80104a11:	e8 06 d2 ff ff       	call   80101c1c <nameiparent>
80104a16:	89 c6                	mov    %eax,%esi
80104a18:	83 c4 10             	add    $0x10,%esp
80104a1b:	85 c0                	test   %eax,%eax
80104a1d:	74 7e                	je     80104a9d <sys_link+0x11d>
  ilock(dp);
80104a1f:	83 ec 0c             	sub    $0xc,%esp
80104a22:	50                   	push   %eax
80104a23:	e8 7c cb ff ff       	call   801015a4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104a28:	83 c4 10             	add    $0x10,%esp
80104a2b:	8b 03                	mov    (%ebx),%eax
80104a2d:	39 06                	cmp    %eax,(%esi)
80104a2f:	75 60                	jne    80104a91 <sys_link+0x111>
80104a31:	83 ec 04             	sub    $0x4,%esp
80104a34:	ff 73 04             	pushl  0x4(%ebx)
80104a37:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104a3a:	50                   	push   %eax
80104a3b:	56                   	push   %esi
80104a3c:	e8 12 d1 ff ff       	call   80101b53 <dirlink>
80104a41:	83 c4 10             	add    $0x10,%esp
80104a44:	85 c0                	test   %eax,%eax
80104a46:	78 49                	js     80104a91 <sys_link+0x111>
  iunlockput(dp);
80104a48:	83 ec 0c             	sub    $0xc,%esp
80104a4b:	56                   	push   %esi
80104a4c:	e8 fa cc ff ff       	call   8010174b <iunlockput>
  iput(ip);
80104a51:	89 1c 24             	mov    %ebx,(%esp)
80104a54:	e8 52 cc ff ff       	call   801016ab <iput>
  end_op();
80104a59:	e8 ed dd ff ff       	call   8010284b <end_op>
  return 0;
80104a5e:	83 c4 10             	add    $0x10,%esp
80104a61:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a69:	5b                   	pop    %ebx
80104a6a:	5e                   	pop    %esi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret    
    end_op();
80104a6d:	e8 d9 dd ff ff       	call   8010284b <end_op>
    return -1;
80104a72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a77:	eb ed                	jmp    80104a66 <sys_link+0xe6>
    iunlockput(ip);
80104a79:	83 ec 0c             	sub    $0xc,%esp
80104a7c:	53                   	push   %ebx
80104a7d:	e8 c9 cc ff ff       	call   8010174b <iunlockput>
    end_op();
80104a82:	e8 c4 dd ff ff       	call   8010284b <end_op>
    return -1;
80104a87:	83 c4 10             	add    $0x10,%esp
80104a8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a8f:	eb d5                	jmp    80104a66 <sys_link+0xe6>
    iunlockput(dp);
80104a91:	83 ec 0c             	sub    $0xc,%esp
80104a94:	56                   	push   %esi
80104a95:	e8 b1 cc ff ff       	call   8010174b <iunlockput>
    goto bad;
80104a9a:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104a9d:	83 ec 0c             	sub    $0xc,%esp
80104aa0:	53                   	push   %ebx
80104aa1:	e8 fe ca ff ff       	call   801015a4 <ilock>
  ip->nlink--;
80104aa6:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104aaa:	83 e8 01             	sub    $0x1,%eax
80104aad:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104ab1:	89 1c 24             	mov    %ebx,(%esp)
80104ab4:	e8 8a c9 ff ff       	call   80101443 <iupdate>
  iunlockput(ip);
80104ab9:	89 1c 24             	mov    %ebx,(%esp)
80104abc:	e8 8a cc ff ff       	call   8010174b <iunlockput>
  end_op();
80104ac1:	e8 85 dd ff ff       	call   8010284b <end_op>
  return -1;
80104ac6:	83 c4 10             	add    $0x10,%esp
80104ac9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ace:	eb 96                	jmp    80104a66 <sys_link+0xe6>
    return -1;
80104ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ad5:	eb 8f                	jmp    80104a66 <sys_link+0xe6>
80104ad7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104adc:	eb 88                	jmp    80104a66 <sys_link+0xe6>

80104ade <sys_unlink>:
{
80104ade:	55                   	push   %ebp
80104adf:	89 e5                	mov    %esp,%ebp
80104ae1:	57                   	push   %edi
80104ae2:	56                   	push   %esi
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104ae7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104aea:	50                   	push   %eax
80104aeb:	6a 00                	push   $0x0
80104aed:	e8 d9 f9 ff ff       	call   801044cb <argstr>
80104af2:	83 c4 10             	add    $0x10,%esp
80104af5:	85 c0                	test   %eax,%eax
80104af7:	0f 88 83 01 00 00    	js     80104c80 <sys_unlink+0x1a2>
  begin_op();
80104afd:	e8 cf dc ff ff       	call   801027d1 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104b02:	83 ec 08             	sub    $0x8,%esp
80104b05:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104b08:	50                   	push   %eax
80104b09:	ff 75 c4             	pushl  -0x3c(%ebp)
80104b0c:	e8 0b d1 ff ff       	call   80101c1c <nameiparent>
80104b11:	89 c6                	mov    %eax,%esi
80104b13:	83 c4 10             	add    $0x10,%esp
80104b16:	85 c0                	test   %eax,%eax
80104b18:	0f 84 ed 00 00 00    	je     80104c0b <sys_unlink+0x12d>
  ilock(dp);
80104b1e:	83 ec 0c             	sub    $0xc,%esp
80104b21:	50                   	push   %eax
80104b22:	e8 7d ca ff ff       	call   801015a4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104b27:	83 c4 08             	add    $0x8,%esp
80104b2a:	68 26 73 10 80       	push   $0x80107326
80104b2f:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104b32:	50                   	push   %eax
80104b33:	e8 86 ce ff ff       	call   801019be <namecmp>
80104b38:	83 c4 10             	add    $0x10,%esp
80104b3b:	85 c0                	test   %eax,%eax
80104b3d:	0f 84 fc 00 00 00    	je     80104c3f <sys_unlink+0x161>
80104b43:	83 ec 08             	sub    $0x8,%esp
80104b46:	68 25 73 10 80       	push   $0x80107325
80104b4b:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104b4e:	50                   	push   %eax
80104b4f:	e8 6a ce ff ff       	call   801019be <namecmp>
80104b54:	83 c4 10             	add    $0x10,%esp
80104b57:	85 c0                	test   %eax,%eax
80104b59:	0f 84 e0 00 00 00    	je     80104c3f <sys_unlink+0x161>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104b5f:	83 ec 04             	sub    $0x4,%esp
80104b62:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b65:	50                   	push   %eax
80104b66:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104b69:	50                   	push   %eax
80104b6a:	56                   	push   %esi
80104b6b:	e8 63 ce ff ff       	call   801019d3 <dirlookup>
80104b70:	89 c3                	mov    %eax,%ebx
80104b72:	83 c4 10             	add    $0x10,%esp
80104b75:	85 c0                	test   %eax,%eax
80104b77:	0f 84 c2 00 00 00    	je     80104c3f <sys_unlink+0x161>
  ilock(ip);
80104b7d:	83 ec 0c             	sub    $0xc,%esp
80104b80:	50                   	push   %eax
80104b81:	e8 1e ca ff ff       	call   801015a4 <ilock>
  if(ip->nlink < 1)
80104b86:	83 c4 10             	add    $0x10,%esp
80104b89:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104b8e:	0f 8e 83 00 00 00    	jle    80104c17 <sys_unlink+0x139>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104b94:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b99:	0f 84 85 00 00 00    	je     80104c24 <sys_unlink+0x146>
  memset(&de, 0, sizeof(de));
80104b9f:	83 ec 04             	sub    $0x4,%esp
80104ba2:	6a 10                	push   $0x10
80104ba4:	6a 00                	push   $0x0
80104ba6:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104ba9:	57                   	push   %edi
80104baa:	e8 41 f6 ff ff       	call   801041f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104baf:	6a 10                	push   $0x10
80104bb1:	ff 75 c0             	pushl  -0x40(%ebp)
80104bb4:	57                   	push   %edi
80104bb5:	56                   	push   %esi
80104bb6:	e8 d8 cc ff ff       	call   80101893 <writei>
80104bbb:	83 c4 20             	add    $0x20,%esp
80104bbe:	83 f8 10             	cmp    $0x10,%eax
80104bc1:	0f 85 90 00 00 00    	jne    80104c57 <sys_unlink+0x179>
  if(ip->type == T_DIR){
80104bc7:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104bcc:	0f 84 92 00 00 00    	je     80104c64 <sys_unlink+0x186>
  iunlockput(dp);
80104bd2:	83 ec 0c             	sub    $0xc,%esp
80104bd5:	56                   	push   %esi
80104bd6:	e8 70 cb ff ff       	call   8010174b <iunlockput>
  ip->nlink--;
80104bdb:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
80104bdf:	83 e8 01             	sub    $0x1,%eax
80104be2:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104be6:	89 1c 24             	mov    %ebx,(%esp)
80104be9:	e8 55 c8 ff ff       	call   80101443 <iupdate>
  iunlockput(ip);
80104bee:	89 1c 24             	mov    %ebx,(%esp)
80104bf1:	e8 55 cb ff ff       	call   8010174b <iunlockput>
  end_op();
80104bf6:	e8 50 dc ff ff       	call   8010284b <end_op>
  return 0;
80104bfb:	83 c4 10             	add    $0x10,%esp
80104bfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c06:	5b                   	pop    %ebx
80104c07:	5e                   	pop    %esi
80104c08:	5f                   	pop    %edi
80104c09:	5d                   	pop    %ebp
80104c0a:	c3                   	ret    
    end_op();
80104c0b:	e8 3b dc ff ff       	call   8010284b <end_op>
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c15:	eb ec                	jmp    80104c03 <sys_unlink+0x125>
    panic("unlink: nlink < 1");
80104c17:	83 ec 0c             	sub    $0xc,%esp
80104c1a:	68 44 73 10 80       	push   $0x80107344
80104c1f:	e8 24 b7 ff ff       	call   80100348 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104c24:	89 d8                	mov    %ebx,%eax
80104c26:	e8 c6 f9 ff ff       	call   801045f1 <isdirempty>
80104c2b:	85 c0                	test   %eax,%eax
80104c2d:	0f 85 6c ff ff ff    	jne    80104b9f <sys_unlink+0xc1>
    iunlockput(ip);
80104c33:	83 ec 0c             	sub    $0xc,%esp
80104c36:	53                   	push   %ebx
80104c37:	e8 0f cb ff ff       	call   8010174b <iunlockput>
    goto bad;
80104c3c:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104c3f:	83 ec 0c             	sub    $0xc,%esp
80104c42:	56                   	push   %esi
80104c43:	e8 03 cb ff ff       	call   8010174b <iunlockput>
  end_op();
80104c48:	e8 fe db ff ff       	call   8010284b <end_op>
  return -1;
80104c4d:	83 c4 10             	add    $0x10,%esp
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c55:	eb ac                	jmp    80104c03 <sys_unlink+0x125>
    panic("unlink: writei");
80104c57:	83 ec 0c             	sub    $0xc,%esp
80104c5a:	68 56 73 10 80       	push   $0x80107356
80104c5f:	e8 e4 b6 ff ff       	call   80100348 <panic>
    dp->nlink--;
80104c64:	0f b7 46 56          	movzwl 0x56(%esi),%eax
80104c68:	83 e8 01             	sub    $0x1,%eax
80104c6b:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104c6f:	83 ec 0c             	sub    $0xc,%esp
80104c72:	56                   	push   %esi
80104c73:	e8 cb c7 ff ff       	call   80101443 <iupdate>
80104c78:	83 c4 10             	add    $0x10,%esp
80104c7b:	e9 52 ff ff ff       	jmp    80104bd2 <sys_unlink+0xf4>
    return -1;
80104c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c85:	e9 79 ff ff ff       	jmp    80104c03 <sys_unlink+0x125>

80104c8a <sys_open>:

int
sys_open(void)
{
80104c8a:	55                   	push   %ebp
80104c8b:	89 e5                	mov    %esp,%ebp
80104c8d:	57                   	push   %edi
80104c8e:	56                   	push   %esi
80104c8f:	53                   	push   %ebx
80104c90:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104c93:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104c96:	50                   	push   %eax
80104c97:	6a 00                	push   $0x0
80104c99:	e8 2d f8 ff ff       	call   801044cb <argstr>
80104c9e:	83 c4 10             	add    $0x10,%esp
80104ca1:	85 c0                	test   %eax,%eax
80104ca3:	0f 88 30 01 00 00    	js     80104dd9 <sys_open+0x14f>
80104ca9:	83 ec 08             	sub    $0x8,%esp
80104cac:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104caf:	50                   	push   %eax
80104cb0:	6a 01                	push   $0x1
80104cb2:	e8 84 f7 ff ff       	call   8010443b <argint>
80104cb7:	83 c4 10             	add    $0x10,%esp
80104cba:	85 c0                	test   %eax,%eax
80104cbc:	0f 88 21 01 00 00    	js     80104de3 <sys_open+0x159>
    return -1;

  begin_op();
80104cc2:	e8 0a db ff ff       	call   801027d1 <begin_op>

  if(omode & O_CREATE){
80104cc7:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104ccb:	0f 84 84 00 00 00    	je     80104d55 <sys_open+0xcb>
    ip = create(path, T_FILE, 0, 0);
80104cd1:	83 ec 0c             	sub    $0xc,%esp
80104cd4:	6a 00                	push   $0x0
80104cd6:	b9 00 00 00 00       	mov    $0x0,%ecx
80104cdb:	ba 02 00 00 00       	mov    $0x2,%edx
80104ce0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104ce3:	e8 60 f9 ff ff       	call   80104648 <create>
80104ce8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104cea:	83 c4 10             	add    $0x10,%esp
80104ced:	85 c0                	test   %eax,%eax
80104cef:	74 58                	je     80104d49 <sys_open+0xbf>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104cf1:	e8 6c bf ff ff       	call   80100c62 <filealloc>
80104cf6:	89 c3                	mov    %eax,%ebx
80104cf8:	85 c0                	test   %eax,%eax
80104cfa:	0f 84 ae 00 00 00    	je     80104dae <sys_open+0x124>
80104d00:	e8 b5 f8 ff ff       	call   801045ba <fdalloc>
80104d05:	89 c7                	mov    %eax,%edi
80104d07:	85 c0                	test   %eax,%eax
80104d09:	0f 88 9f 00 00 00    	js     80104dae <sys_open+0x124>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104d0f:	83 ec 0c             	sub    $0xc,%esp
80104d12:	56                   	push   %esi
80104d13:	e8 4e c9 ff ff       	call   80101666 <iunlock>
  end_op();
80104d18:	e8 2e db ff ff       	call   8010284b <end_op>

  f->type = FD_INODE;
80104d1d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104d23:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104d26:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d30:	83 c4 10             	add    $0x10,%esp
80104d33:	a8 01                	test   $0x1,%al
80104d35:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104d39:	a8 03                	test   $0x3,%al
80104d3b:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104d3f:	89 f8                	mov    %edi,%eax
80104d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d44:	5b                   	pop    %ebx
80104d45:	5e                   	pop    %esi
80104d46:	5f                   	pop    %edi
80104d47:	5d                   	pop    %ebp
80104d48:	c3                   	ret    
      end_op();
80104d49:	e8 fd da ff ff       	call   8010284b <end_op>
      return -1;
80104d4e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104d53:	eb ea                	jmp    80104d3f <sys_open+0xb5>
    if((ip = namei(path)) == 0){
80104d55:	83 ec 0c             	sub    $0xc,%esp
80104d58:	ff 75 e4             	pushl  -0x1c(%ebp)
80104d5b:	e8 a4 ce ff ff       	call   80101c04 <namei>
80104d60:	89 c6                	mov    %eax,%esi
80104d62:	83 c4 10             	add    $0x10,%esp
80104d65:	85 c0                	test   %eax,%eax
80104d67:	74 39                	je     80104da2 <sys_open+0x118>
    ilock(ip);
80104d69:	83 ec 0c             	sub    $0xc,%esp
80104d6c:	50                   	push   %eax
80104d6d:	e8 32 c8 ff ff       	call   801015a4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104d72:	83 c4 10             	add    $0x10,%esp
80104d75:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104d7a:	0f 85 71 ff ff ff    	jne    80104cf1 <sys_open+0x67>
80104d80:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104d84:	0f 84 67 ff ff ff    	je     80104cf1 <sys_open+0x67>
      iunlockput(ip);
80104d8a:	83 ec 0c             	sub    $0xc,%esp
80104d8d:	56                   	push   %esi
80104d8e:	e8 b8 c9 ff ff       	call   8010174b <iunlockput>
      end_op();
80104d93:	e8 b3 da ff ff       	call   8010284b <end_op>
      return -1;
80104d98:	83 c4 10             	add    $0x10,%esp
80104d9b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104da0:	eb 9d                	jmp    80104d3f <sys_open+0xb5>
      end_op();
80104da2:	e8 a4 da ff ff       	call   8010284b <end_op>
      return -1;
80104da7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104dac:	eb 91                	jmp    80104d3f <sys_open+0xb5>
    if(f)
80104dae:	85 db                	test   %ebx,%ebx
80104db0:	74 0c                	je     80104dbe <sys_open+0x134>
      fileclose(f);
80104db2:	83 ec 0c             	sub    $0xc,%esp
80104db5:	53                   	push   %ebx
80104db6:	e8 4d bf ff ff       	call   80100d08 <fileclose>
80104dbb:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104dbe:	83 ec 0c             	sub    $0xc,%esp
80104dc1:	56                   	push   %esi
80104dc2:	e8 84 c9 ff ff       	call   8010174b <iunlockput>
    end_op();
80104dc7:	e8 7f da ff ff       	call   8010284b <end_op>
    return -1;
80104dcc:	83 c4 10             	add    $0x10,%esp
80104dcf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104dd4:	e9 66 ff ff ff       	jmp    80104d3f <sys_open+0xb5>
    return -1;
80104dd9:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104dde:	e9 5c ff ff ff       	jmp    80104d3f <sys_open+0xb5>
80104de3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104de8:	e9 52 ff ff ff       	jmp    80104d3f <sys_open+0xb5>

80104ded <sys_mkdir>:

int
sys_mkdir(void)
{
80104ded:	55                   	push   %ebp
80104dee:	89 e5                	mov    %esp,%ebp
80104df0:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104df3:	e8 d9 d9 ff ff       	call   801027d1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104df8:	83 ec 08             	sub    $0x8,%esp
80104dfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dfe:	50                   	push   %eax
80104dff:	6a 00                	push   $0x0
80104e01:	e8 c5 f6 ff ff       	call   801044cb <argstr>
80104e06:	83 c4 10             	add    $0x10,%esp
80104e09:	85 c0                	test   %eax,%eax
80104e0b:	78 36                	js     80104e43 <sys_mkdir+0x56>
80104e0d:	83 ec 0c             	sub    $0xc,%esp
80104e10:	6a 00                	push   $0x0
80104e12:	b9 00 00 00 00       	mov    $0x0,%ecx
80104e17:	ba 01 00 00 00       	mov    $0x1,%edx
80104e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e1f:	e8 24 f8 ff ff       	call   80104648 <create>
80104e24:	83 c4 10             	add    $0x10,%esp
80104e27:	85 c0                	test   %eax,%eax
80104e29:	74 18                	je     80104e43 <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104e2b:	83 ec 0c             	sub    $0xc,%esp
80104e2e:	50                   	push   %eax
80104e2f:	e8 17 c9 ff ff       	call   8010174b <iunlockput>
  end_op();
80104e34:	e8 12 da ff ff       	call   8010284b <end_op>
  return 0;
80104e39:	83 c4 10             	add    $0x10,%esp
80104e3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e41:	c9                   	leave  
80104e42:	c3                   	ret    
    end_op();
80104e43:	e8 03 da ff ff       	call   8010284b <end_op>
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e4d:	eb f2                	jmp    80104e41 <sys_mkdir+0x54>

80104e4f <sys_mknod>:

int
sys_mknod(void)
{
80104e4f:	55                   	push   %ebp
80104e50:	89 e5                	mov    %esp,%ebp
80104e52:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104e55:	e8 77 d9 ff ff       	call   801027d1 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104e5a:	83 ec 08             	sub    $0x8,%esp
80104e5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e60:	50                   	push   %eax
80104e61:	6a 00                	push   $0x0
80104e63:	e8 63 f6 ff ff       	call   801044cb <argstr>
80104e68:	83 c4 10             	add    $0x10,%esp
80104e6b:	85 c0                	test   %eax,%eax
80104e6d:	78 62                	js     80104ed1 <sys_mknod+0x82>
     argint(1, &major) < 0 ||
80104e6f:	83 ec 08             	sub    $0x8,%esp
80104e72:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e75:	50                   	push   %eax
80104e76:	6a 01                	push   $0x1
80104e78:	e8 be f5 ff ff       	call   8010443b <argint>
  if((argstr(0, &path)) < 0 ||
80104e7d:	83 c4 10             	add    $0x10,%esp
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 4d                	js     80104ed1 <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
80104e84:	83 ec 08             	sub    $0x8,%esp
80104e87:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104e8a:	50                   	push   %eax
80104e8b:	6a 02                	push   $0x2
80104e8d:	e8 a9 f5 ff ff       	call   8010443b <argint>
     argint(1, &major) < 0 ||
80104e92:	83 c4 10             	add    $0x10,%esp
80104e95:	85 c0                	test   %eax,%eax
80104e97:	78 38                	js     80104ed1 <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104e99:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104e9d:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80104ea1:	83 ec 0c             	sub    $0xc,%esp
80104ea4:	50                   	push   %eax
80104ea5:	ba 03 00 00 00       	mov    $0x3,%edx
80104eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ead:	e8 96 f7 ff ff       	call   80104648 <create>
80104eb2:	83 c4 10             	add    $0x10,%esp
80104eb5:	85 c0                	test   %eax,%eax
80104eb7:	74 18                	je     80104ed1 <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104eb9:	83 ec 0c             	sub    $0xc,%esp
80104ebc:	50                   	push   %eax
80104ebd:	e8 89 c8 ff ff       	call   8010174b <iunlockput>
  end_op();
80104ec2:	e8 84 d9 ff ff       	call   8010284b <end_op>
  return 0;
80104ec7:	83 c4 10             	add    $0x10,%esp
80104eca:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ecf:	c9                   	leave  
80104ed0:	c3                   	ret    
    end_op();
80104ed1:	e8 75 d9 ff ff       	call   8010284b <end_op>
    return -1;
80104ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104edb:	eb f2                	jmp    80104ecf <sys_mknod+0x80>

80104edd <sys_chdir>:

int
sys_chdir(void)
{
80104edd:	55                   	push   %ebp
80104ede:	89 e5                	mov    %esp,%ebp
80104ee0:	56                   	push   %esi
80104ee1:	53                   	push   %ebx
80104ee2:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104ee5:	e8 d5 e2 ff ff       	call   801031bf <myproc>
80104eea:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104eec:	e8 e0 d8 ff ff       	call   801027d1 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104ef1:	83 ec 08             	sub    $0x8,%esp
80104ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ef7:	50                   	push   %eax
80104ef8:	6a 00                	push   $0x0
80104efa:	e8 cc f5 ff ff       	call   801044cb <argstr>
80104eff:	83 c4 10             	add    $0x10,%esp
80104f02:	85 c0                	test   %eax,%eax
80104f04:	78 52                	js     80104f58 <sys_chdir+0x7b>
80104f06:	83 ec 0c             	sub    $0xc,%esp
80104f09:	ff 75 f4             	pushl  -0xc(%ebp)
80104f0c:	e8 f3 cc ff ff       	call   80101c04 <namei>
80104f11:	89 c3                	mov    %eax,%ebx
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	74 3e                	je     80104f58 <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80104f1a:	83 ec 0c             	sub    $0xc,%esp
80104f1d:	50                   	push   %eax
80104f1e:	e8 81 c6 ff ff       	call   801015a4 <ilock>
  if(ip->type != T_DIR){
80104f23:	83 c4 10             	add    $0x10,%esp
80104f26:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f2b:	75 37                	jne    80104f64 <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f2d:	83 ec 0c             	sub    $0xc,%esp
80104f30:	53                   	push   %ebx
80104f31:	e8 30 c7 ff ff       	call   80101666 <iunlock>
  iput(curproc->cwd);
80104f36:	83 c4 04             	add    $0x4,%esp
80104f39:	ff 76 68             	pushl  0x68(%esi)
80104f3c:	e8 6a c7 ff ff       	call   801016ab <iput>
  end_op();
80104f41:	e8 05 d9 ff ff       	call   8010284b <end_op>
  curproc->cwd = ip;
80104f46:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104f49:	83 c4 10             	add    $0x10,%esp
80104f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104f51:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f54:	5b                   	pop    %ebx
80104f55:	5e                   	pop    %esi
80104f56:	5d                   	pop    %ebp
80104f57:	c3                   	ret    
    end_op();
80104f58:	e8 ee d8 ff ff       	call   8010284b <end_op>
    return -1;
80104f5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f62:	eb ed                	jmp    80104f51 <sys_chdir+0x74>
    iunlockput(ip);
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	53                   	push   %ebx
80104f68:	e8 de c7 ff ff       	call   8010174b <iunlockput>
    end_op();
80104f6d:	e8 d9 d8 ff ff       	call   8010284b <end_op>
    return -1;
80104f72:	83 c4 10             	add    $0x10,%esp
80104f75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f7a:	eb d5                	jmp    80104f51 <sys_chdir+0x74>

80104f7c <sys_exec>:

int
sys_exec(void)
{
80104f7c:	55                   	push   %ebp
80104f7d:	89 e5                	mov    %esp,%ebp
80104f7f:	53                   	push   %ebx
80104f80:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f89:	50                   	push   %eax
80104f8a:	6a 00                	push   $0x0
80104f8c:	e8 3a f5 ff ff       	call   801044cb <argstr>
80104f91:	83 c4 10             	add    $0x10,%esp
80104f94:	85 c0                	test   %eax,%eax
80104f96:	0f 88 a8 00 00 00    	js     80105044 <sys_exec+0xc8>
80104f9c:	83 ec 08             	sub    $0x8,%esp
80104f9f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104fa5:	50                   	push   %eax
80104fa6:	6a 01                	push   $0x1
80104fa8:	e8 8e f4 ff ff       	call   8010443b <argint>
80104fad:	83 c4 10             	add    $0x10,%esp
80104fb0:	85 c0                	test   %eax,%eax
80104fb2:	0f 88 93 00 00 00    	js     8010504b <sys_exec+0xcf>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104fb8:	83 ec 04             	sub    $0x4,%esp
80104fbb:	68 80 00 00 00       	push   $0x80
80104fc0:	6a 00                	push   $0x0
80104fc2:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104fc8:	50                   	push   %eax
80104fc9:	e8 22 f2 ff ff       	call   801041f0 <memset>
80104fce:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104fd1:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(i >= NELEM(argv))
80104fd6:	83 fb 1f             	cmp    $0x1f,%ebx
80104fd9:	77 77                	ja     80105052 <sys_exec+0xd6>
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104fdb:	83 ec 08             	sub    $0x8,%esp
80104fde:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104fe4:	50                   	push   %eax
80104fe5:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104feb:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104fee:	50                   	push   %eax
80104fef:	e8 cb f3 ff ff       	call   801043bf <fetchint>
80104ff4:	83 c4 10             	add    $0x10,%esp
80104ff7:	85 c0                	test   %eax,%eax
80104ff9:	78 5e                	js     80105059 <sys_exec+0xdd>
      return -1;
    if(uarg == 0){
80104ffb:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105001:	85 c0                	test   %eax,%eax
80105003:	74 1d                	je     80105022 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105005:	83 ec 08             	sub    $0x8,%esp
80105008:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
8010500f:	52                   	push   %edx
80105010:	50                   	push   %eax
80105011:	e8 e5 f3 ff ff       	call   801043fb <fetchstr>
80105016:	83 c4 10             	add    $0x10,%esp
80105019:	85 c0                	test   %eax,%eax
8010501b:	78 46                	js     80105063 <sys_exec+0xe7>
  for(i=0;; i++){
8010501d:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105020:	eb b4                	jmp    80104fd6 <sys_exec+0x5a>
      argv[i] = 0;
80105022:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80105029:	00 00 00 00 
      return -1;
  }
  return exec(path, argv);
8010502d:	83 ec 08             	sub    $0x8,%esp
80105030:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80105036:	50                   	push   %eax
80105037:	ff 75 f4             	pushl  -0xc(%ebp)
8010503a:	e8 c0 b8 ff ff       	call   801008ff <exec>
8010503f:	83 c4 10             	add    $0x10,%esp
80105042:	eb 1a                	jmp    8010505e <sys_exec+0xe2>
    return -1;
80105044:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105049:	eb 13                	jmp    8010505e <sys_exec+0xe2>
8010504b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105050:	eb 0c                	jmp    8010505e <sys_exec+0xe2>
      return -1;
80105052:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105057:	eb 05                	jmp    8010505e <sys_exec+0xe2>
      return -1;
80105059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010505e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105061:	c9                   	leave  
80105062:	c3                   	ret    
      return -1;
80105063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105068:	eb f4                	jmp    8010505e <sys_exec+0xe2>

8010506a <sys_pipe>:

int
sys_pipe(void)
{
8010506a:	55                   	push   %ebp
8010506b:	89 e5                	mov    %esp,%ebp
8010506d:	53                   	push   %ebx
8010506e:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105071:	6a 08                	push   $0x8
80105073:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105076:	50                   	push   %eax
80105077:	6a 00                	push   $0x0
80105079:	e8 e5 f3 ff ff       	call   80104463 <argptr>
8010507e:	83 c4 10             	add    $0x10,%esp
80105081:	85 c0                	test   %eax,%eax
80105083:	78 77                	js     801050fc <sys_pipe+0x92>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105085:	83 ec 08             	sub    $0x8,%esp
80105088:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010508b:	50                   	push   %eax
8010508c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010508f:	50                   	push   %eax
80105090:	e8 c3 dc ff ff       	call   80102d58 <pipealloc>
80105095:	83 c4 10             	add    $0x10,%esp
80105098:	85 c0                	test   %eax,%eax
8010509a:	78 67                	js     80105103 <sys_pipe+0x99>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010509c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010509f:	e8 16 f5 ff ff       	call   801045ba <fdalloc>
801050a4:	89 c3                	mov    %eax,%ebx
801050a6:	85 c0                	test   %eax,%eax
801050a8:	78 21                	js     801050cb <sys_pipe+0x61>
801050aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050ad:	e8 08 f5 ff ff       	call   801045ba <fdalloc>
801050b2:	85 c0                	test   %eax,%eax
801050b4:	78 15                	js     801050cb <sys_pipe+0x61>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801050b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050b9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801050bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050be:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
801050c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050c9:	c9                   	leave  
801050ca:	c3                   	ret    
    if(fd0 >= 0)
801050cb:	85 db                	test   %ebx,%ebx
801050cd:	78 0d                	js     801050dc <sys_pipe+0x72>
      myproc()->ofile[fd0] = 0;
801050cf:	e8 eb e0 ff ff       	call   801031bf <myproc>
801050d4:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801050db:	00 
    fileclose(rf);
801050dc:	83 ec 0c             	sub    $0xc,%esp
801050df:	ff 75 f0             	pushl  -0x10(%ebp)
801050e2:	e8 21 bc ff ff       	call   80100d08 <fileclose>
    fileclose(wf);
801050e7:	83 c4 04             	add    $0x4,%esp
801050ea:	ff 75 ec             	pushl  -0x14(%ebp)
801050ed:	e8 16 bc ff ff       	call   80100d08 <fileclose>
    return -1;
801050f2:	83 c4 10             	add    $0x10,%esp
801050f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fa:	eb ca                	jmp    801050c6 <sys_pipe+0x5c>
    return -1;
801050fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105101:	eb c3                	jmp    801050c6 <sys_pipe+0x5c>
    return -1;
80105103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105108:	eb bc                	jmp    801050c6 <sys_pipe+0x5c>

8010510a <sys_fork>:
#include "proc.h"


int
sys_fork(void)
{
8010510a:	55                   	push   %ebp
8010510b:	89 e5                	mov    %esp,%ebp
8010510d:	83 ec 08             	sub    $0x8,%esp
  return fork();
80105110:	e8 c7 ea ff ff       	call   80103bdc <fork>
}
80105115:	c9                   	leave  
80105116:	c3                   	ret    

80105117 <sys_exit>:

int
sys_exit(void)
{
80105117:	55                   	push   %ebp
80105118:	89 e5                	mov    %esp,%ebp
8010511a:	83 ec 08             	sub    $0x8,%esp
  exit();
8010511d:	e8 01 e6 ff ff       	call   80103723 <exit>
  return 0;  // not reached
}
80105122:	b8 00 00 00 00       	mov    $0x0,%eax
80105127:	c9                   	leave  
80105128:	c3                   	ret    

80105129 <sys_wait>:

int
sys_wait(void)
{
80105129:	55                   	push   %ebp
8010512a:	89 e5                	mov    %esp,%ebp
8010512c:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010512f:	e8 d9 e6 ff ff       	call   8010380d <wait>
}
80105134:	c9                   	leave  
80105135:	c3                   	ret    

80105136 <sys_kill>:

int
sys_kill(void)
{
80105136:	55                   	push   %ebp
80105137:	89 e5                	mov    %esp,%ebp
80105139:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int signum;

  if(argint(0, &pid) < 0)
8010513c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513f:	50                   	push   %eax
80105140:	6a 00                	push   $0x0
80105142:	e8 f4 f2 ff ff       	call   8010443b <argint>
80105147:	83 c4 10             	add    $0x10,%esp
8010514a:	85 c0                	test   %eax,%eax
8010514c:	78 28                	js     80105176 <sys_kill+0x40>
    return -1;
  if(argint(1, &signum) < 0)
8010514e:	83 ec 08             	sub    $0x8,%esp
80105151:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105154:	50                   	push   %eax
80105155:	6a 01                	push   $0x1
80105157:	e8 df f2 ff ff       	call   8010443b <argint>
8010515c:	83 c4 10             	add    $0x10,%esp
8010515f:	85 c0                	test   %eax,%eax
80105161:	78 1a                	js     8010517d <sys_kill+0x47>
    return -1;
  return kill(pid, signum);
80105163:	83 ec 08             	sub    $0x8,%esp
80105166:	ff 75 f0             	pushl  -0x10(%ebp)
80105169:	ff 75 f4             	pushl  -0xc(%ebp)
8010516c:	e8 91 e8 ff ff       	call   80103a02 <kill>
80105171:	83 c4 10             	add    $0x10,%esp
}
80105174:	c9                   	leave  
80105175:	c3                   	ret    
    return -1;
80105176:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517b:	eb f7                	jmp    80105174 <sys_kill+0x3e>
    return -1;
8010517d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105182:	eb f0                	jmp    80105174 <sys_kill+0x3e>

80105184 <sys_getpid>:

int
sys_getpid(void)
{
80105184:	55                   	push   %ebp
80105185:	89 e5                	mov    %esp,%ebp
80105187:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010518a:	e8 30 e0 ff ff       	call   801031bf <myproc>
8010518f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105192:	c9                   	leave  
80105193:	c3                   	ret    

80105194 <sys_sbrk>:

int
sys_sbrk(void)
{
80105194:	55                   	push   %ebp
80105195:	89 e5                	mov    %esp,%ebp
80105197:	53                   	push   %ebx
80105198:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010519b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010519e:	50                   	push   %eax
8010519f:	6a 00                	push   $0x0
801051a1:	e8 95 f2 ff ff       	call   8010443b <argint>
801051a6:	83 c4 10             	add    $0x10,%esp
801051a9:	85 c0                	test   %eax,%eax
801051ab:	78 27                	js     801051d4 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801051ad:	e8 0d e0 ff ff       	call   801031bf <myproc>
801051b2:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801051b4:	83 ec 0c             	sub    $0xc,%esp
801051b7:	ff 75 f4             	pushl  -0xc(%ebp)
801051ba:	e8 37 e2 ff ff       	call   801033f6 <growproc>
801051bf:	83 c4 10             	add    $0x10,%esp
801051c2:	85 c0                	test   %eax,%eax
801051c4:	78 07                	js     801051cd <sys_sbrk+0x39>
    return -1;
  return addr;
}
801051c6:	89 d8                	mov    %ebx,%eax
801051c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051cb:	c9                   	leave  
801051cc:	c3                   	ret    
    return -1;
801051cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051d2:	eb f2                	jmp    801051c6 <sys_sbrk+0x32>
    return -1;
801051d4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051d9:	eb eb                	jmp    801051c6 <sys_sbrk+0x32>

801051db <sys_sleep>:

int
sys_sleep(void)
{
801051db:	55                   	push   %ebp
801051dc:	89 e5                	mov    %esp,%ebp
801051de:	53                   	push   %ebx
801051df:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801051e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e5:	50                   	push   %eax
801051e6:	6a 00                	push   $0x0
801051e8:	e8 4e f2 ff ff       	call   8010443b <argint>
801051ed:	83 c4 10             	add    $0x10,%esp
801051f0:	85 c0                	test   %eax,%eax
801051f2:	78 75                	js     80105269 <sys_sleep+0x8e>
    return -1;
  acquire(&tickslock);
801051f4:	83 ec 0c             	sub    $0xc,%esp
801051f7:	68 60 71 11 80       	push   $0x80117160
801051fc:	e8 43 ef ff ff       	call   80104144 <acquire>
  ticks0 = ticks;
80105201:	8b 1d a0 79 11 80    	mov    0x801179a0,%ebx
  while(ticks - ticks0 < n){
80105207:	83 c4 10             	add    $0x10,%esp
8010520a:	a1 a0 79 11 80       	mov    0x801179a0,%eax
8010520f:	29 d8                	sub    %ebx,%eax
80105211:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105214:	73 39                	jae    8010524f <sys_sleep+0x74>
    if(myproc()->killed){
80105216:	e8 a4 df ff ff       	call   801031bf <myproc>
8010521b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010521f:	75 17                	jne    80105238 <sys_sleep+0x5d>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105221:	83 ec 08             	sub    $0x8,%esp
80105224:	68 60 71 11 80       	push   $0x80117160
80105229:	68 a0 79 11 80       	push   $0x801179a0
8010522e:	e8 09 e7 ff ff       	call   8010393c <sleep>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	eb d2                	jmp    8010520a <sys_sleep+0x2f>
      release(&tickslock);
80105238:	83 ec 0c             	sub    $0xc,%esp
8010523b:	68 60 71 11 80       	push   $0x80117160
80105240:	e8 64 ef ff ff       	call   801041a9 <release>
      return -1;
80105245:	83 c4 10             	add    $0x10,%esp
80105248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524d:	eb 15                	jmp    80105264 <sys_sleep+0x89>
  }
  release(&tickslock);
8010524f:	83 ec 0c             	sub    $0xc,%esp
80105252:	68 60 71 11 80       	push   $0x80117160
80105257:	e8 4d ef ff ff       	call   801041a9 <release>
  return 0;
8010525c:	83 c4 10             	add    $0x10,%esp
8010525f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105264:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105267:	c9                   	leave  
80105268:	c3                   	ret    
    return -1;
80105269:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526e:	eb f4                	jmp    80105264 <sys_sleep+0x89>

80105270 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	53                   	push   %ebx
80105274:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105277:	68 60 71 11 80       	push   $0x80117160
8010527c:	e8 c3 ee ff ff       	call   80104144 <acquire>
  xticks = ticks;
80105281:	8b 1d a0 79 11 80    	mov    0x801179a0,%ebx
  release(&tickslock);
80105287:	c7 04 24 60 71 11 80 	movl   $0x80117160,(%esp)
8010528e:	e8 16 ef ff ff       	call   801041a9 <release>
  return xticks;
}
80105293:	89 d8                	mov    %ebx,%eax
80105295:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105298:	c9                   	leave  
80105299:	c3                   	ret    

8010529a <sys_sigprocmask>:

// assignment 2
uint
sys_sigprocmask(void)
{
8010529a:	55                   	push   %ebp
8010529b:	89 e5                	mov    %esp,%ebp
8010529d:	83 ec 20             	sub    $0x20,%esp
  uint new_mask;
  if (argint(0, (int*)&new_mask) < 0)
801052a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a3:	50                   	push   %eax
801052a4:	6a 00                	push   $0x0
801052a6:	e8 90 f1 ff ff       	call   8010443b <argint>
801052ab:	83 c4 10             	add    $0x10,%esp
801052ae:	85 c0                	test   %eax,%eax
801052b0:	78 10                	js     801052c2 <sys_sigprocmask+0x28>
    return -1;
  return sigprocmask(new_mask);
801052b2:	83 ec 0c             	sub    $0xc,%esp
801052b5:	ff 75 f4             	pushl  -0xc(%ebp)
801052b8:	e8 ce e7 ff ff       	call   80103a8b <sigprocmask>
801052bd:	83 c4 10             	add    $0x10,%esp
}
801052c0:	c9                   	leave  
801052c1:	c3                   	ret    
    return -1;
801052c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052c7:	eb f7                	jmp    801052c0 <sys_sigprocmask+0x26>

801052c9 <sys_sigaction>:


int
sys_sigaction(void)
{
801052c9:	55                   	push   %ebp
801052ca:	89 e5                	mov    %esp,%ebp
801052cc:	83 ec 20             	sub    $0x20,%esp
  int signum;
  struct sigaction *act;
  struct sigaction *oldact;

  if(argint(0, &signum) < 0)
801052cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052d2:	50                   	push   %eax
801052d3:	6a 00                	push   $0x0
801052d5:	e8 61 f1 ff ff       	call   8010443b <argint>
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	85 c0                	test   %eax,%eax
801052df:	78 44                	js     80105325 <sys_sigaction+0x5c>
    return -1;

  if(argptr(1, (char**)&act, sizeof(struct sigaction)) < 0)
801052e1:	83 ec 04             	sub    $0x4,%esp
801052e4:	6a 08                	push   $0x8
801052e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052e9:	50                   	push   %eax
801052ea:	6a 01                	push   $0x1
801052ec:	e8 72 f1 ff ff       	call   80104463 <argptr>
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	85 c0                	test   %eax,%eax
801052f6:	78 34                	js     8010532c <sys_sigaction+0x63>
    return -1;

  if(argptr(2, (char**)&oldact, sizeof(struct sigaction)) < 0)
801052f8:	83 ec 04             	sub    $0x4,%esp
801052fb:	6a 08                	push   $0x8
801052fd:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105300:	50                   	push   %eax
80105301:	6a 02                	push   $0x2
80105303:	e8 5b f1 ff ff       	call   80104463 <argptr>
80105308:	83 c4 10             	add    $0x10,%esp
8010530b:	85 c0                	test   %eax,%eax
8010530d:	78 24                	js     80105333 <sys_sigaction+0x6a>
    return -1;

  return sigaction(signum, act, oldact);
8010530f:	83 ec 04             	sub    $0x4,%esp
80105312:	ff 75 ec             	pushl  -0x14(%ebp)
80105315:	ff 75 f0             	pushl  -0x10(%ebp)
80105318:	ff 75 f4             	pushl  -0xc(%ebp)
8010531b:	e8 da e9 ff ff       	call   80103cfa <sigaction>
80105320:	83 c4 10             	add    $0x10,%esp

}
80105323:	c9                   	leave  
80105324:	c3                   	ret    
    return -1;
80105325:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010532a:	eb f7                	jmp    80105323 <sys_sigaction+0x5a>
    return -1;
8010532c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105331:	eb f0                	jmp    80105323 <sys_sigaction+0x5a>
    return -1;
80105333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105338:	eb e9                	jmp    80105323 <sys_sigaction+0x5a>

8010533a <sys_sigret>:

int
sys_sigret(void) 
{
8010533a:	55                   	push   %ebp
8010533b:	89 e5                	mov    %esp,%ebp
8010533d:	83 ec 08             	sub    $0x8,%esp
  return sigret();
80105340:	e8 93 eb ff ff       	call   80103ed8 <sigret>
80105345:	c9                   	leave  
80105346:	c3                   	ret    

80105347 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105347:	1e                   	push   %ds
  pushl %es
80105348:	06                   	push   %es
  pushl %fs
80105349:	0f a0                	push   %fs
  pushl %gs
8010534b:	0f a8                	push   %gs
  pushal
8010534d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010534e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105352:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105354:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105356:	54                   	push   %esp
  call trap
80105357:	e8 ef 00 00 00       	call   8010544b <trap>
  addl $4, %esp
8010535c:	83 c4 04             	add    $0x4,%esp

8010535f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  call handle_signals
8010535f:	e8 06 eb ff ff       	call   80103e6a <handle_signals>
  popal
80105364:	61                   	popa   
  popl %gs
80105365:	0f a9                	pop    %gs
  popl %fs
80105367:	0f a1                	pop    %fs
  popl %es
80105369:	07                   	pop    %es
  popl %ds
8010536a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010536b:	83 c4 08             	add    $0x8,%esp
  iret
8010536e:	cf                   	iret   

8010536f <sigret_caller_start>:


.globl sigret_caller_start
.globl sigret_caller_end
sigret_caller_start:
  movl $SYS_sigret, %eax
8010536f:	b8 18 00 00 00       	mov    $0x18,%eax
  int $T_SYSCALL
80105374:	cd 40                	int    $0x40

80105376 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105376:	55                   	push   %ebp
80105377:	89 e5                	mov    %esp,%ebp
80105379:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
8010537c:	b8 00 00 00 00       	mov    $0x0,%eax
80105381:	eb 4a                	jmp    801053cd <tvinit+0x57>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105383:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
8010538a:	66 89 0c c5 a0 71 11 	mov    %cx,-0x7fee8e60(,%eax,8)
80105391:	80 
80105392:	66 c7 04 c5 a2 71 11 	movw   $0x8,-0x7fee8e5e(,%eax,8)
80105399:	80 08 00 
8010539c:	c6 04 c5 a4 71 11 80 	movb   $0x0,-0x7fee8e5c(,%eax,8)
801053a3:	00 
801053a4:	0f b6 14 c5 a5 71 11 	movzbl -0x7fee8e5b(,%eax,8),%edx
801053ab:	80 
801053ac:	83 e2 f0             	and    $0xfffffff0,%edx
801053af:	83 ca 0e             	or     $0xe,%edx
801053b2:	83 e2 8f             	and    $0xffffff8f,%edx
801053b5:	83 ca 80             	or     $0xffffff80,%edx
801053b8:	88 14 c5 a5 71 11 80 	mov    %dl,-0x7fee8e5b(,%eax,8)
801053bf:	c1 e9 10             	shr    $0x10,%ecx
801053c2:	66 89 0c c5 a6 71 11 	mov    %cx,-0x7fee8e5a(,%eax,8)
801053c9:	80 
  for(i = 0; i < 256; i++)
801053ca:	83 c0 01             	add    $0x1,%eax
801053cd:	3d ff 00 00 00       	cmp    $0xff,%eax
801053d2:	7e af                	jle    80105383 <tvinit+0xd>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801053d4:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
801053da:	66 89 15 a0 73 11 80 	mov    %dx,0x801173a0
801053e1:	66 c7 05 a2 73 11 80 	movw   $0x8,0x801173a2
801053e8:	08 00 
801053ea:	c6 05 a4 73 11 80 00 	movb   $0x0,0x801173a4
801053f1:	0f b6 05 a5 73 11 80 	movzbl 0x801173a5,%eax
801053f8:	83 c8 0f             	or     $0xf,%eax
801053fb:	83 e0 ef             	and    $0xffffffef,%eax
801053fe:	83 c8 e0             	or     $0xffffffe0,%eax
80105401:	a2 a5 73 11 80       	mov    %al,0x801173a5
80105406:	c1 ea 10             	shr    $0x10,%edx
80105409:	66 89 15 a6 73 11 80 	mov    %dx,0x801173a6

  initlock(&tickslock, "time");
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	68 65 73 10 80       	push   $0x80107365
80105418:	68 60 71 11 80       	push   $0x80117160
8010541d:	e8 e6 eb ff ff       	call   80104008 <initlock>
}
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	c9                   	leave  
80105426:	c3                   	ret    

80105427 <idtinit>:

void
idtinit(void)
{
80105427:	55                   	push   %ebp
80105428:	89 e5                	mov    %esp,%ebp
8010542a:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
8010542d:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80105433:	b8 a0 71 11 80       	mov    $0x801171a0,%eax
80105438:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010543c:	c1 e8 10             	shr    $0x10,%eax
8010543f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105443:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105446:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105449:	c9                   	leave  
8010544a:	c3                   	ret    

8010544b <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010544b:	55                   	push   %ebp
8010544c:	89 e5                	mov    %esp,%ebp
8010544e:	57                   	push   %edi
8010544f:	56                   	push   %esi
80105450:	53                   	push   %ebx
80105451:	83 ec 1c             	sub    $0x1c,%esp
80105454:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105457:	8b 43 30             	mov    0x30(%ebx),%eax
8010545a:	83 f8 40             	cmp    $0x40,%eax
8010545d:	74 13                	je     80105472 <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010545f:	83 e8 20             	sub    $0x20,%eax
80105462:	83 f8 1f             	cmp    $0x1f,%eax
80105465:	0f 87 3a 01 00 00    	ja     801055a5 <trap+0x15a>
8010546b:	ff 24 85 0c 74 10 80 	jmp    *-0x7fef8bf4(,%eax,4)
    if(myproc()->killed)
80105472:	e8 48 dd ff ff       	call   801031bf <myproc>
80105477:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010547b:	75 1f                	jne    8010549c <trap+0x51>
    myproc()->tf = tf;
8010547d:	e8 3d dd ff ff       	call   801031bf <myproc>
80105482:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105485:	e8 74 f0 ff ff       	call   801044fe <syscall>
    if(myproc()->killed)
8010548a:	e8 30 dd ff ff       	call   801031bf <myproc>
8010548f:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105493:	74 7e                	je     80105513 <trap+0xc8>
      exit();
80105495:	e8 89 e2 ff ff       	call   80103723 <exit>
8010549a:	eb 77                	jmp    80105513 <trap+0xc8>
      exit();
8010549c:	e8 82 e2 ff ff       	call   80103723 <exit>
801054a1:	eb da                	jmp    8010547d <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801054a3:	e8 fc dc ff ff       	call   801031a4 <cpuid>
801054a8:	85 c0                	test   %eax,%eax
801054aa:	74 6f                	je     8010551b <trap+0xd0>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
801054ac:	e8 0b cf ff ff       	call   801023bc <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801054b1:	e8 09 dd ff ff       	call   801031bf <myproc>
801054b6:	85 c0                	test   %eax,%eax
801054b8:	74 1c                	je     801054d6 <trap+0x8b>
801054ba:	e8 00 dd ff ff       	call   801031bf <myproc>
801054bf:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801054c3:	74 11                	je     801054d6 <trap+0x8b>
801054c5:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801054c9:	83 e0 03             	and    $0x3,%eax
801054cc:	66 83 f8 03          	cmp    $0x3,%ax
801054d0:	0f 84 62 01 00 00    	je     80105638 <trap+0x1ed>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801054d6:	e8 e4 dc ff ff       	call   801031bf <myproc>
801054db:	85 c0                	test   %eax,%eax
801054dd:	74 0f                	je     801054ee <trap+0xa3>
801054df:	e8 db dc ff ff       	call   801031bf <myproc>
801054e4:	83 78 0c 07          	cmpl   $0x7,0xc(%eax)
801054e8:	0f 84 54 01 00 00    	je     80105642 <trap+0x1f7>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801054ee:	e8 cc dc ff ff       	call   801031bf <myproc>
801054f3:	85 c0                	test   %eax,%eax
801054f5:	74 1c                	je     80105513 <trap+0xc8>
801054f7:	e8 c3 dc ff ff       	call   801031bf <myproc>
801054fc:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105500:	74 11                	je     80105513 <trap+0xc8>
80105502:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105506:	83 e0 03             	and    $0x3,%eax
80105509:	66 83 f8 03          	cmp    $0x3,%ax
8010550d:	0f 84 43 01 00 00    	je     80105656 <trap+0x20b>
    exit();
}
80105513:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105516:	5b                   	pop    %ebx
80105517:	5e                   	pop    %esi
80105518:	5f                   	pop    %edi
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
      acquire(&tickslock);
8010551b:	83 ec 0c             	sub    $0xc,%esp
8010551e:	68 60 71 11 80       	push   $0x80117160
80105523:	e8 1c ec ff ff       	call   80104144 <acquire>
      ticks++;
80105528:	83 05 a0 79 11 80 01 	addl   $0x1,0x801179a0
      wakeup(&ticks);
8010552f:	c7 04 24 a0 79 11 80 	movl   $0x801179a0,(%esp)
80105536:	e8 ad e4 ff ff       	call   801039e8 <wakeup>
      release(&tickslock);
8010553b:	c7 04 24 60 71 11 80 	movl   $0x80117160,(%esp)
80105542:	e8 62 ec ff ff       	call   801041a9 <release>
80105547:	83 c4 10             	add    $0x10,%esp
8010554a:	e9 5d ff ff ff       	jmp    801054ac <trap+0x61>
    ideintr();
8010554f:	e8 42 c8 ff ff       	call   80101d96 <ideintr>
    lapiceoi();
80105554:	e8 63 ce ff ff       	call   801023bc <lapiceoi>
    break;
80105559:	e9 53 ff ff ff       	jmp    801054b1 <trap+0x66>
    kbdintr();
8010555e:	e8 9d cc ff ff       	call   80102200 <kbdintr>
    lapiceoi();
80105563:	e8 54 ce ff ff       	call   801023bc <lapiceoi>
    break;
80105568:	e9 44 ff ff ff       	jmp    801054b1 <trap+0x66>
    uartintr();
8010556d:	e8 05 02 00 00       	call   80105777 <uartintr>
    lapiceoi();
80105572:	e8 45 ce ff ff       	call   801023bc <lapiceoi>
    break;
80105577:	e9 35 ff ff ff       	jmp    801054b1 <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010557c:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
8010557f:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105583:	e8 1c dc ff ff       	call   801031a4 <cpuid>
80105588:	57                   	push   %edi
80105589:	0f b7 f6             	movzwl %si,%esi
8010558c:	56                   	push   %esi
8010558d:	50                   	push   %eax
8010558e:	68 70 73 10 80       	push   $0x80107370
80105593:	e8 73 b0 ff ff       	call   8010060b <cprintf>
    lapiceoi();
80105598:	e8 1f ce ff ff       	call   801023bc <lapiceoi>
    break;
8010559d:	83 c4 10             	add    $0x10,%esp
801055a0:	e9 0c ff ff ff       	jmp    801054b1 <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
801055a5:	e8 15 dc ff ff       	call   801031bf <myproc>
801055aa:	85 c0                	test   %eax,%eax
801055ac:	74 5f                	je     8010560d <trap+0x1c2>
801055ae:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801055b2:	74 59                	je     8010560d <trap+0x1c2>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801055b4:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055b7:	8b 43 38             	mov    0x38(%ebx),%eax
801055ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801055bd:	e8 e2 db ff ff       	call   801031a4 <cpuid>
801055c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801055c5:	8b 53 34             	mov    0x34(%ebx),%edx
801055c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
801055cb:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
801055ce:	e8 ec db ff ff       	call   801031bf <myproc>
801055d3:	8d 48 6c             	lea    0x6c(%eax),%ecx
801055d6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801055d9:	e8 e1 db ff ff       	call   801031bf <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801055de:	57                   	push   %edi
801055df:	ff 75 e4             	pushl  -0x1c(%ebp)
801055e2:	ff 75 e0             	pushl  -0x20(%ebp)
801055e5:	ff 75 dc             	pushl  -0x24(%ebp)
801055e8:	56                   	push   %esi
801055e9:	ff 75 d8             	pushl  -0x28(%ebp)
801055ec:	ff 70 10             	pushl  0x10(%eax)
801055ef:	68 c8 73 10 80       	push   $0x801073c8
801055f4:	e8 12 b0 ff ff       	call   8010060b <cprintf>
    myproc()->killed = 1;
801055f9:	83 c4 20             	add    $0x20,%esp
801055fc:	e8 be db ff ff       	call   801031bf <myproc>
80105601:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105608:	e9 a4 fe ff ff       	jmp    801054b1 <trap+0x66>
8010560d:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105610:	8b 73 38             	mov    0x38(%ebx),%esi
80105613:	e8 8c db ff ff       	call   801031a4 <cpuid>
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	57                   	push   %edi
8010561c:	56                   	push   %esi
8010561d:	50                   	push   %eax
8010561e:	ff 73 30             	pushl  0x30(%ebx)
80105621:	68 94 73 10 80       	push   $0x80107394
80105626:	e8 e0 af ff ff       	call   8010060b <cprintf>
      panic("trap");
8010562b:	83 c4 14             	add    $0x14,%esp
8010562e:	68 6a 73 10 80       	push   $0x8010736a
80105633:	e8 10 ad ff ff       	call   80100348 <panic>
    exit();
80105638:	e8 e6 e0 ff ff       	call   80103723 <exit>
8010563d:	e9 94 fe ff ff       	jmp    801054d6 <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
80105642:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105646:	0f 85 a2 fe ff ff    	jne    801054ee <trap+0xa3>
    yield();
8010564c:	e8 97 e2 ff ff       	call   801038e8 <yield>
80105651:	e9 98 fe ff ff       	jmp    801054ee <trap+0xa3>
    exit();
80105656:	e8 c8 e0 ff ff       	call   80103723 <exit>
8010565b:	e9 b3 fe ff ff       	jmp    80105513 <trap+0xc8>

80105660 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105663:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
8010566a:	74 15                	je     80105681 <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010566c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105671:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105672:	a8 01                	test   $0x1,%al
80105674:	74 12                	je     80105688 <uartgetc+0x28>
80105676:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010567b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010567c:	0f b6 c0             	movzbl %al,%eax
}
8010567f:	5d                   	pop    %ebp
80105680:	c3                   	ret    
    return -1;
80105681:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105686:	eb f7                	jmp    8010567f <uartgetc+0x1f>
    return -1;
80105688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568d:	eb f0                	jmp    8010567f <uartgetc+0x1f>

8010568f <uartputc>:
  if(!uart)
8010568f:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
80105696:	74 3b                	je     801056d3 <uartputc+0x44>
{
80105698:	55                   	push   %ebp
80105699:	89 e5                	mov    %esp,%ebp
8010569b:	53                   	push   %ebx
8010569c:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010569f:	bb 00 00 00 00       	mov    $0x0,%ebx
801056a4:	eb 10                	jmp    801056b6 <uartputc+0x27>
    microdelay(10);
801056a6:	83 ec 0c             	sub    $0xc,%esp
801056a9:	6a 0a                	push   $0xa
801056ab:	e8 2b cd ff ff       	call   801023db <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801056b0:	83 c3 01             	add    $0x1,%ebx
801056b3:	83 c4 10             	add    $0x10,%esp
801056b6:	83 fb 7f             	cmp    $0x7f,%ebx
801056b9:	7f 0a                	jg     801056c5 <uartputc+0x36>
801056bb:	ba fd 03 00 00       	mov    $0x3fd,%edx
801056c0:	ec                   	in     (%dx),%al
801056c1:	a8 20                	test   $0x20,%al
801056c3:	74 e1                	je     801056a6 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801056c5:	8b 45 08             	mov    0x8(%ebp),%eax
801056c8:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056cd:	ee                   	out    %al,(%dx)
}
801056ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056d1:	c9                   	leave  
801056d2:	c3                   	ret    
801056d3:	f3 c3                	repz ret 

801056d5 <uartinit>:
{
801056d5:	55                   	push   %ebp
801056d6:	89 e5                	mov    %esp,%ebp
801056d8:	56                   	push   %esi
801056d9:	53                   	push   %ebx
801056da:	b9 00 00 00 00       	mov    $0x0,%ecx
801056df:	ba fa 03 00 00       	mov    $0x3fa,%edx
801056e4:	89 c8                	mov    %ecx,%eax
801056e6:	ee                   	out    %al,(%dx)
801056e7:	be fb 03 00 00       	mov    $0x3fb,%esi
801056ec:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801056f1:	89 f2                	mov    %esi,%edx
801056f3:	ee                   	out    %al,(%dx)
801056f4:	b8 0c 00 00 00       	mov    $0xc,%eax
801056f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801056fe:	ee                   	out    %al,(%dx)
801056ff:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105704:	89 c8                	mov    %ecx,%eax
80105706:	89 da                	mov    %ebx,%edx
80105708:	ee                   	out    %al,(%dx)
80105709:	b8 03 00 00 00       	mov    $0x3,%eax
8010570e:	89 f2                	mov    %esi,%edx
80105710:	ee                   	out    %al,(%dx)
80105711:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105716:	89 c8                	mov    %ecx,%eax
80105718:	ee                   	out    %al,(%dx)
80105719:	b8 01 00 00 00       	mov    $0x1,%eax
8010571e:	89 da                	mov    %ebx,%edx
80105720:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105721:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105726:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105727:	3c ff                	cmp    $0xff,%al
80105729:	74 45                	je     80105770 <uartinit+0x9b>
  uart = 1;
8010572b:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105732:	00 00 00 
80105735:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010573a:	ec                   	in     (%dx),%al
8010573b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105740:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105741:	83 ec 08             	sub    $0x8,%esp
80105744:	6a 00                	push   $0x0
80105746:	6a 04                	push   $0x4
80105748:	e8 54 c8 ff ff       	call   80101fa1 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	bb 8c 74 10 80       	mov    $0x8010748c,%ebx
80105755:	eb 12                	jmp    80105769 <uartinit+0x94>
    uartputc(*p);
80105757:	83 ec 0c             	sub    $0xc,%esp
8010575a:	0f be c0             	movsbl %al,%eax
8010575d:	50                   	push   %eax
8010575e:	e8 2c ff ff ff       	call   8010568f <uartputc>
  for(p="xv6...\n"; *p; p++)
80105763:	83 c3 01             	add    $0x1,%ebx
80105766:	83 c4 10             	add    $0x10,%esp
80105769:	0f b6 03             	movzbl (%ebx),%eax
8010576c:	84 c0                	test   %al,%al
8010576e:	75 e7                	jne    80105757 <uartinit+0x82>
}
80105770:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105773:	5b                   	pop    %ebx
80105774:	5e                   	pop    %esi
80105775:	5d                   	pop    %ebp
80105776:	c3                   	ret    

80105777 <uartintr>:

void
uartintr(void)
{
80105777:	55                   	push   %ebp
80105778:	89 e5                	mov    %esp,%ebp
8010577a:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010577d:	68 60 56 10 80       	push   $0x80105660
80105782:	e8 b7 af ff ff       	call   8010073e <consoleintr>
}
80105787:	83 c4 10             	add    $0x10,%esp
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    

8010578c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010578c:	6a 00                	push   $0x0
  pushl $0
8010578e:	6a 00                	push   $0x0
  jmp alltraps
80105790:	e9 b2 fb ff ff       	jmp    80105347 <alltraps>

80105795 <vector1>:
.globl vector1
vector1:
  pushl $0
80105795:	6a 00                	push   $0x0
  pushl $1
80105797:	6a 01                	push   $0x1
  jmp alltraps
80105799:	e9 a9 fb ff ff       	jmp    80105347 <alltraps>

8010579e <vector2>:
.globl vector2
vector2:
  pushl $0
8010579e:	6a 00                	push   $0x0
  pushl $2
801057a0:	6a 02                	push   $0x2
  jmp alltraps
801057a2:	e9 a0 fb ff ff       	jmp    80105347 <alltraps>

801057a7 <vector3>:
.globl vector3
vector3:
  pushl $0
801057a7:	6a 00                	push   $0x0
  pushl $3
801057a9:	6a 03                	push   $0x3
  jmp alltraps
801057ab:	e9 97 fb ff ff       	jmp    80105347 <alltraps>

801057b0 <vector4>:
.globl vector4
vector4:
  pushl $0
801057b0:	6a 00                	push   $0x0
  pushl $4
801057b2:	6a 04                	push   $0x4
  jmp alltraps
801057b4:	e9 8e fb ff ff       	jmp    80105347 <alltraps>

801057b9 <vector5>:
.globl vector5
vector5:
  pushl $0
801057b9:	6a 00                	push   $0x0
  pushl $5
801057bb:	6a 05                	push   $0x5
  jmp alltraps
801057bd:	e9 85 fb ff ff       	jmp    80105347 <alltraps>

801057c2 <vector6>:
.globl vector6
vector6:
  pushl $0
801057c2:	6a 00                	push   $0x0
  pushl $6
801057c4:	6a 06                	push   $0x6
  jmp alltraps
801057c6:	e9 7c fb ff ff       	jmp    80105347 <alltraps>

801057cb <vector7>:
.globl vector7
vector7:
  pushl $0
801057cb:	6a 00                	push   $0x0
  pushl $7
801057cd:	6a 07                	push   $0x7
  jmp alltraps
801057cf:	e9 73 fb ff ff       	jmp    80105347 <alltraps>

801057d4 <vector8>:
.globl vector8
vector8:
  pushl $8
801057d4:	6a 08                	push   $0x8
  jmp alltraps
801057d6:	e9 6c fb ff ff       	jmp    80105347 <alltraps>

801057db <vector9>:
.globl vector9
vector9:
  pushl $0
801057db:	6a 00                	push   $0x0
  pushl $9
801057dd:	6a 09                	push   $0x9
  jmp alltraps
801057df:	e9 63 fb ff ff       	jmp    80105347 <alltraps>

801057e4 <vector10>:
.globl vector10
vector10:
  pushl $10
801057e4:	6a 0a                	push   $0xa
  jmp alltraps
801057e6:	e9 5c fb ff ff       	jmp    80105347 <alltraps>

801057eb <vector11>:
.globl vector11
vector11:
  pushl $11
801057eb:	6a 0b                	push   $0xb
  jmp alltraps
801057ed:	e9 55 fb ff ff       	jmp    80105347 <alltraps>

801057f2 <vector12>:
.globl vector12
vector12:
  pushl $12
801057f2:	6a 0c                	push   $0xc
  jmp alltraps
801057f4:	e9 4e fb ff ff       	jmp    80105347 <alltraps>

801057f9 <vector13>:
.globl vector13
vector13:
  pushl $13
801057f9:	6a 0d                	push   $0xd
  jmp alltraps
801057fb:	e9 47 fb ff ff       	jmp    80105347 <alltraps>

80105800 <vector14>:
.globl vector14
vector14:
  pushl $14
80105800:	6a 0e                	push   $0xe
  jmp alltraps
80105802:	e9 40 fb ff ff       	jmp    80105347 <alltraps>

80105807 <vector15>:
.globl vector15
vector15:
  pushl $0
80105807:	6a 00                	push   $0x0
  pushl $15
80105809:	6a 0f                	push   $0xf
  jmp alltraps
8010580b:	e9 37 fb ff ff       	jmp    80105347 <alltraps>

80105810 <vector16>:
.globl vector16
vector16:
  pushl $0
80105810:	6a 00                	push   $0x0
  pushl $16
80105812:	6a 10                	push   $0x10
  jmp alltraps
80105814:	e9 2e fb ff ff       	jmp    80105347 <alltraps>

80105819 <vector17>:
.globl vector17
vector17:
  pushl $17
80105819:	6a 11                	push   $0x11
  jmp alltraps
8010581b:	e9 27 fb ff ff       	jmp    80105347 <alltraps>

80105820 <vector18>:
.globl vector18
vector18:
  pushl $0
80105820:	6a 00                	push   $0x0
  pushl $18
80105822:	6a 12                	push   $0x12
  jmp alltraps
80105824:	e9 1e fb ff ff       	jmp    80105347 <alltraps>

80105829 <vector19>:
.globl vector19
vector19:
  pushl $0
80105829:	6a 00                	push   $0x0
  pushl $19
8010582b:	6a 13                	push   $0x13
  jmp alltraps
8010582d:	e9 15 fb ff ff       	jmp    80105347 <alltraps>

80105832 <vector20>:
.globl vector20
vector20:
  pushl $0
80105832:	6a 00                	push   $0x0
  pushl $20
80105834:	6a 14                	push   $0x14
  jmp alltraps
80105836:	e9 0c fb ff ff       	jmp    80105347 <alltraps>

8010583b <vector21>:
.globl vector21
vector21:
  pushl $0
8010583b:	6a 00                	push   $0x0
  pushl $21
8010583d:	6a 15                	push   $0x15
  jmp alltraps
8010583f:	e9 03 fb ff ff       	jmp    80105347 <alltraps>

80105844 <vector22>:
.globl vector22
vector22:
  pushl $0
80105844:	6a 00                	push   $0x0
  pushl $22
80105846:	6a 16                	push   $0x16
  jmp alltraps
80105848:	e9 fa fa ff ff       	jmp    80105347 <alltraps>

8010584d <vector23>:
.globl vector23
vector23:
  pushl $0
8010584d:	6a 00                	push   $0x0
  pushl $23
8010584f:	6a 17                	push   $0x17
  jmp alltraps
80105851:	e9 f1 fa ff ff       	jmp    80105347 <alltraps>

80105856 <vector24>:
.globl vector24
vector24:
  pushl $0
80105856:	6a 00                	push   $0x0
  pushl $24
80105858:	6a 18                	push   $0x18
  jmp alltraps
8010585a:	e9 e8 fa ff ff       	jmp    80105347 <alltraps>

8010585f <vector25>:
.globl vector25
vector25:
  pushl $0
8010585f:	6a 00                	push   $0x0
  pushl $25
80105861:	6a 19                	push   $0x19
  jmp alltraps
80105863:	e9 df fa ff ff       	jmp    80105347 <alltraps>

80105868 <vector26>:
.globl vector26
vector26:
  pushl $0
80105868:	6a 00                	push   $0x0
  pushl $26
8010586a:	6a 1a                	push   $0x1a
  jmp alltraps
8010586c:	e9 d6 fa ff ff       	jmp    80105347 <alltraps>

80105871 <vector27>:
.globl vector27
vector27:
  pushl $0
80105871:	6a 00                	push   $0x0
  pushl $27
80105873:	6a 1b                	push   $0x1b
  jmp alltraps
80105875:	e9 cd fa ff ff       	jmp    80105347 <alltraps>

8010587a <vector28>:
.globl vector28
vector28:
  pushl $0
8010587a:	6a 00                	push   $0x0
  pushl $28
8010587c:	6a 1c                	push   $0x1c
  jmp alltraps
8010587e:	e9 c4 fa ff ff       	jmp    80105347 <alltraps>

80105883 <vector29>:
.globl vector29
vector29:
  pushl $0
80105883:	6a 00                	push   $0x0
  pushl $29
80105885:	6a 1d                	push   $0x1d
  jmp alltraps
80105887:	e9 bb fa ff ff       	jmp    80105347 <alltraps>

8010588c <vector30>:
.globl vector30
vector30:
  pushl $0
8010588c:	6a 00                	push   $0x0
  pushl $30
8010588e:	6a 1e                	push   $0x1e
  jmp alltraps
80105890:	e9 b2 fa ff ff       	jmp    80105347 <alltraps>

80105895 <vector31>:
.globl vector31
vector31:
  pushl $0
80105895:	6a 00                	push   $0x0
  pushl $31
80105897:	6a 1f                	push   $0x1f
  jmp alltraps
80105899:	e9 a9 fa ff ff       	jmp    80105347 <alltraps>

8010589e <vector32>:
.globl vector32
vector32:
  pushl $0
8010589e:	6a 00                	push   $0x0
  pushl $32
801058a0:	6a 20                	push   $0x20
  jmp alltraps
801058a2:	e9 a0 fa ff ff       	jmp    80105347 <alltraps>

801058a7 <vector33>:
.globl vector33
vector33:
  pushl $0
801058a7:	6a 00                	push   $0x0
  pushl $33
801058a9:	6a 21                	push   $0x21
  jmp alltraps
801058ab:	e9 97 fa ff ff       	jmp    80105347 <alltraps>

801058b0 <vector34>:
.globl vector34
vector34:
  pushl $0
801058b0:	6a 00                	push   $0x0
  pushl $34
801058b2:	6a 22                	push   $0x22
  jmp alltraps
801058b4:	e9 8e fa ff ff       	jmp    80105347 <alltraps>

801058b9 <vector35>:
.globl vector35
vector35:
  pushl $0
801058b9:	6a 00                	push   $0x0
  pushl $35
801058bb:	6a 23                	push   $0x23
  jmp alltraps
801058bd:	e9 85 fa ff ff       	jmp    80105347 <alltraps>

801058c2 <vector36>:
.globl vector36
vector36:
  pushl $0
801058c2:	6a 00                	push   $0x0
  pushl $36
801058c4:	6a 24                	push   $0x24
  jmp alltraps
801058c6:	e9 7c fa ff ff       	jmp    80105347 <alltraps>

801058cb <vector37>:
.globl vector37
vector37:
  pushl $0
801058cb:	6a 00                	push   $0x0
  pushl $37
801058cd:	6a 25                	push   $0x25
  jmp alltraps
801058cf:	e9 73 fa ff ff       	jmp    80105347 <alltraps>

801058d4 <vector38>:
.globl vector38
vector38:
  pushl $0
801058d4:	6a 00                	push   $0x0
  pushl $38
801058d6:	6a 26                	push   $0x26
  jmp alltraps
801058d8:	e9 6a fa ff ff       	jmp    80105347 <alltraps>

801058dd <vector39>:
.globl vector39
vector39:
  pushl $0
801058dd:	6a 00                	push   $0x0
  pushl $39
801058df:	6a 27                	push   $0x27
  jmp alltraps
801058e1:	e9 61 fa ff ff       	jmp    80105347 <alltraps>

801058e6 <vector40>:
.globl vector40
vector40:
  pushl $0
801058e6:	6a 00                	push   $0x0
  pushl $40
801058e8:	6a 28                	push   $0x28
  jmp alltraps
801058ea:	e9 58 fa ff ff       	jmp    80105347 <alltraps>

801058ef <vector41>:
.globl vector41
vector41:
  pushl $0
801058ef:	6a 00                	push   $0x0
  pushl $41
801058f1:	6a 29                	push   $0x29
  jmp alltraps
801058f3:	e9 4f fa ff ff       	jmp    80105347 <alltraps>

801058f8 <vector42>:
.globl vector42
vector42:
  pushl $0
801058f8:	6a 00                	push   $0x0
  pushl $42
801058fa:	6a 2a                	push   $0x2a
  jmp alltraps
801058fc:	e9 46 fa ff ff       	jmp    80105347 <alltraps>

80105901 <vector43>:
.globl vector43
vector43:
  pushl $0
80105901:	6a 00                	push   $0x0
  pushl $43
80105903:	6a 2b                	push   $0x2b
  jmp alltraps
80105905:	e9 3d fa ff ff       	jmp    80105347 <alltraps>

8010590a <vector44>:
.globl vector44
vector44:
  pushl $0
8010590a:	6a 00                	push   $0x0
  pushl $44
8010590c:	6a 2c                	push   $0x2c
  jmp alltraps
8010590e:	e9 34 fa ff ff       	jmp    80105347 <alltraps>

80105913 <vector45>:
.globl vector45
vector45:
  pushl $0
80105913:	6a 00                	push   $0x0
  pushl $45
80105915:	6a 2d                	push   $0x2d
  jmp alltraps
80105917:	e9 2b fa ff ff       	jmp    80105347 <alltraps>

8010591c <vector46>:
.globl vector46
vector46:
  pushl $0
8010591c:	6a 00                	push   $0x0
  pushl $46
8010591e:	6a 2e                	push   $0x2e
  jmp alltraps
80105920:	e9 22 fa ff ff       	jmp    80105347 <alltraps>

80105925 <vector47>:
.globl vector47
vector47:
  pushl $0
80105925:	6a 00                	push   $0x0
  pushl $47
80105927:	6a 2f                	push   $0x2f
  jmp alltraps
80105929:	e9 19 fa ff ff       	jmp    80105347 <alltraps>

8010592e <vector48>:
.globl vector48
vector48:
  pushl $0
8010592e:	6a 00                	push   $0x0
  pushl $48
80105930:	6a 30                	push   $0x30
  jmp alltraps
80105932:	e9 10 fa ff ff       	jmp    80105347 <alltraps>

80105937 <vector49>:
.globl vector49
vector49:
  pushl $0
80105937:	6a 00                	push   $0x0
  pushl $49
80105939:	6a 31                	push   $0x31
  jmp alltraps
8010593b:	e9 07 fa ff ff       	jmp    80105347 <alltraps>

80105940 <vector50>:
.globl vector50
vector50:
  pushl $0
80105940:	6a 00                	push   $0x0
  pushl $50
80105942:	6a 32                	push   $0x32
  jmp alltraps
80105944:	e9 fe f9 ff ff       	jmp    80105347 <alltraps>

80105949 <vector51>:
.globl vector51
vector51:
  pushl $0
80105949:	6a 00                	push   $0x0
  pushl $51
8010594b:	6a 33                	push   $0x33
  jmp alltraps
8010594d:	e9 f5 f9 ff ff       	jmp    80105347 <alltraps>

80105952 <vector52>:
.globl vector52
vector52:
  pushl $0
80105952:	6a 00                	push   $0x0
  pushl $52
80105954:	6a 34                	push   $0x34
  jmp alltraps
80105956:	e9 ec f9 ff ff       	jmp    80105347 <alltraps>

8010595b <vector53>:
.globl vector53
vector53:
  pushl $0
8010595b:	6a 00                	push   $0x0
  pushl $53
8010595d:	6a 35                	push   $0x35
  jmp alltraps
8010595f:	e9 e3 f9 ff ff       	jmp    80105347 <alltraps>

80105964 <vector54>:
.globl vector54
vector54:
  pushl $0
80105964:	6a 00                	push   $0x0
  pushl $54
80105966:	6a 36                	push   $0x36
  jmp alltraps
80105968:	e9 da f9 ff ff       	jmp    80105347 <alltraps>

8010596d <vector55>:
.globl vector55
vector55:
  pushl $0
8010596d:	6a 00                	push   $0x0
  pushl $55
8010596f:	6a 37                	push   $0x37
  jmp alltraps
80105971:	e9 d1 f9 ff ff       	jmp    80105347 <alltraps>

80105976 <vector56>:
.globl vector56
vector56:
  pushl $0
80105976:	6a 00                	push   $0x0
  pushl $56
80105978:	6a 38                	push   $0x38
  jmp alltraps
8010597a:	e9 c8 f9 ff ff       	jmp    80105347 <alltraps>

8010597f <vector57>:
.globl vector57
vector57:
  pushl $0
8010597f:	6a 00                	push   $0x0
  pushl $57
80105981:	6a 39                	push   $0x39
  jmp alltraps
80105983:	e9 bf f9 ff ff       	jmp    80105347 <alltraps>

80105988 <vector58>:
.globl vector58
vector58:
  pushl $0
80105988:	6a 00                	push   $0x0
  pushl $58
8010598a:	6a 3a                	push   $0x3a
  jmp alltraps
8010598c:	e9 b6 f9 ff ff       	jmp    80105347 <alltraps>

80105991 <vector59>:
.globl vector59
vector59:
  pushl $0
80105991:	6a 00                	push   $0x0
  pushl $59
80105993:	6a 3b                	push   $0x3b
  jmp alltraps
80105995:	e9 ad f9 ff ff       	jmp    80105347 <alltraps>

8010599a <vector60>:
.globl vector60
vector60:
  pushl $0
8010599a:	6a 00                	push   $0x0
  pushl $60
8010599c:	6a 3c                	push   $0x3c
  jmp alltraps
8010599e:	e9 a4 f9 ff ff       	jmp    80105347 <alltraps>

801059a3 <vector61>:
.globl vector61
vector61:
  pushl $0
801059a3:	6a 00                	push   $0x0
  pushl $61
801059a5:	6a 3d                	push   $0x3d
  jmp alltraps
801059a7:	e9 9b f9 ff ff       	jmp    80105347 <alltraps>

801059ac <vector62>:
.globl vector62
vector62:
  pushl $0
801059ac:	6a 00                	push   $0x0
  pushl $62
801059ae:	6a 3e                	push   $0x3e
  jmp alltraps
801059b0:	e9 92 f9 ff ff       	jmp    80105347 <alltraps>

801059b5 <vector63>:
.globl vector63
vector63:
  pushl $0
801059b5:	6a 00                	push   $0x0
  pushl $63
801059b7:	6a 3f                	push   $0x3f
  jmp alltraps
801059b9:	e9 89 f9 ff ff       	jmp    80105347 <alltraps>

801059be <vector64>:
.globl vector64
vector64:
  pushl $0
801059be:	6a 00                	push   $0x0
  pushl $64
801059c0:	6a 40                	push   $0x40
  jmp alltraps
801059c2:	e9 80 f9 ff ff       	jmp    80105347 <alltraps>

801059c7 <vector65>:
.globl vector65
vector65:
  pushl $0
801059c7:	6a 00                	push   $0x0
  pushl $65
801059c9:	6a 41                	push   $0x41
  jmp alltraps
801059cb:	e9 77 f9 ff ff       	jmp    80105347 <alltraps>

801059d0 <vector66>:
.globl vector66
vector66:
  pushl $0
801059d0:	6a 00                	push   $0x0
  pushl $66
801059d2:	6a 42                	push   $0x42
  jmp alltraps
801059d4:	e9 6e f9 ff ff       	jmp    80105347 <alltraps>

801059d9 <vector67>:
.globl vector67
vector67:
  pushl $0
801059d9:	6a 00                	push   $0x0
  pushl $67
801059db:	6a 43                	push   $0x43
  jmp alltraps
801059dd:	e9 65 f9 ff ff       	jmp    80105347 <alltraps>

801059e2 <vector68>:
.globl vector68
vector68:
  pushl $0
801059e2:	6a 00                	push   $0x0
  pushl $68
801059e4:	6a 44                	push   $0x44
  jmp alltraps
801059e6:	e9 5c f9 ff ff       	jmp    80105347 <alltraps>

801059eb <vector69>:
.globl vector69
vector69:
  pushl $0
801059eb:	6a 00                	push   $0x0
  pushl $69
801059ed:	6a 45                	push   $0x45
  jmp alltraps
801059ef:	e9 53 f9 ff ff       	jmp    80105347 <alltraps>

801059f4 <vector70>:
.globl vector70
vector70:
  pushl $0
801059f4:	6a 00                	push   $0x0
  pushl $70
801059f6:	6a 46                	push   $0x46
  jmp alltraps
801059f8:	e9 4a f9 ff ff       	jmp    80105347 <alltraps>

801059fd <vector71>:
.globl vector71
vector71:
  pushl $0
801059fd:	6a 00                	push   $0x0
  pushl $71
801059ff:	6a 47                	push   $0x47
  jmp alltraps
80105a01:	e9 41 f9 ff ff       	jmp    80105347 <alltraps>

80105a06 <vector72>:
.globl vector72
vector72:
  pushl $0
80105a06:	6a 00                	push   $0x0
  pushl $72
80105a08:	6a 48                	push   $0x48
  jmp alltraps
80105a0a:	e9 38 f9 ff ff       	jmp    80105347 <alltraps>

80105a0f <vector73>:
.globl vector73
vector73:
  pushl $0
80105a0f:	6a 00                	push   $0x0
  pushl $73
80105a11:	6a 49                	push   $0x49
  jmp alltraps
80105a13:	e9 2f f9 ff ff       	jmp    80105347 <alltraps>

80105a18 <vector74>:
.globl vector74
vector74:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $74
80105a1a:	6a 4a                	push   $0x4a
  jmp alltraps
80105a1c:	e9 26 f9 ff ff       	jmp    80105347 <alltraps>

80105a21 <vector75>:
.globl vector75
vector75:
  pushl $0
80105a21:	6a 00                	push   $0x0
  pushl $75
80105a23:	6a 4b                	push   $0x4b
  jmp alltraps
80105a25:	e9 1d f9 ff ff       	jmp    80105347 <alltraps>

80105a2a <vector76>:
.globl vector76
vector76:
  pushl $0
80105a2a:	6a 00                	push   $0x0
  pushl $76
80105a2c:	6a 4c                	push   $0x4c
  jmp alltraps
80105a2e:	e9 14 f9 ff ff       	jmp    80105347 <alltraps>

80105a33 <vector77>:
.globl vector77
vector77:
  pushl $0
80105a33:	6a 00                	push   $0x0
  pushl $77
80105a35:	6a 4d                	push   $0x4d
  jmp alltraps
80105a37:	e9 0b f9 ff ff       	jmp    80105347 <alltraps>

80105a3c <vector78>:
.globl vector78
vector78:
  pushl $0
80105a3c:	6a 00                	push   $0x0
  pushl $78
80105a3e:	6a 4e                	push   $0x4e
  jmp alltraps
80105a40:	e9 02 f9 ff ff       	jmp    80105347 <alltraps>

80105a45 <vector79>:
.globl vector79
vector79:
  pushl $0
80105a45:	6a 00                	push   $0x0
  pushl $79
80105a47:	6a 4f                	push   $0x4f
  jmp alltraps
80105a49:	e9 f9 f8 ff ff       	jmp    80105347 <alltraps>

80105a4e <vector80>:
.globl vector80
vector80:
  pushl $0
80105a4e:	6a 00                	push   $0x0
  pushl $80
80105a50:	6a 50                	push   $0x50
  jmp alltraps
80105a52:	e9 f0 f8 ff ff       	jmp    80105347 <alltraps>

80105a57 <vector81>:
.globl vector81
vector81:
  pushl $0
80105a57:	6a 00                	push   $0x0
  pushl $81
80105a59:	6a 51                	push   $0x51
  jmp alltraps
80105a5b:	e9 e7 f8 ff ff       	jmp    80105347 <alltraps>

80105a60 <vector82>:
.globl vector82
vector82:
  pushl $0
80105a60:	6a 00                	push   $0x0
  pushl $82
80105a62:	6a 52                	push   $0x52
  jmp alltraps
80105a64:	e9 de f8 ff ff       	jmp    80105347 <alltraps>

80105a69 <vector83>:
.globl vector83
vector83:
  pushl $0
80105a69:	6a 00                	push   $0x0
  pushl $83
80105a6b:	6a 53                	push   $0x53
  jmp alltraps
80105a6d:	e9 d5 f8 ff ff       	jmp    80105347 <alltraps>

80105a72 <vector84>:
.globl vector84
vector84:
  pushl $0
80105a72:	6a 00                	push   $0x0
  pushl $84
80105a74:	6a 54                	push   $0x54
  jmp alltraps
80105a76:	e9 cc f8 ff ff       	jmp    80105347 <alltraps>

80105a7b <vector85>:
.globl vector85
vector85:
  pushl $0
80105a7b:	6a 00                	push   $0x0
  pushl $85
80105a7d:	6a 55                	push   $0x55
  jmp alltraps
80105a7f:	e9 c3 f8 ff ff       	jmp    80105347 <alltraps>

80105a84 <vector86>:
.globl vector86
vector86:
  pushl $0
80105a84:	6a 00                	push   $0x0
  pushl $86
80105a86:	6a 56                	push   $0x56
  jmp alltraps
80105a88:	e9 ba f8 ff ff       	jmp    80105347 <alltraps>

80105a8d <vector87>:
.globl vector87
vector87:
  pushl $0
80105a8d:	6a 00                	push   $0x0
  pushl $87
80105a8f:	6a 57                	push   $0x57
  jmp alltraps
80105a91:	e9 b1 f8 ff ff       	jmp    80105347 <alltraps>

80105a96 <vector88>:
.globl vector88
vector88:
  pushl $0
80105a96:	6a 00                	push   $0x0
  pushl $88
80105a98:	6a 58                	push   $0x58
  jmp alltraps
80105a9a:	e9 a8 f8 ff ff       	jmp    80105347 <alltraps>

80105a9f <vector89>:
.globl vector89
vector89:
  pushl $0
80105a9f:	6a 00                	push   $0x0
  pushl $89
80105aa1:	6a 59                	push   $0x59
  jmp alltraps
80105aa3:	e9 9f f8 ff ff       	jmp    80105347 <alltraps>

80105aa8 <vector90>:
.globl vector90
vector90:
  pushl $0
80105aa8:	6a 00                	push   $0x0
  pushl $90
80105aaa:	6a 5a                	push   $0x5a
  jmp alltraps
80105aac:	e9 96 f8 ff ff       	jmp    80105347 <alltraps>

80105ab1 <vector91>:
.globl vector91
vector91:
  pushl $0
80105ab1:	6a 00                	push   $0x0
  pushl $91
80105ab3:	6a 5b                	push   $0x5b
  jmp alltraps
80105ab5:	e9 8d f8 ff ff       	jmp    80105347 <alltraps>

80105aba <vector92>:
.globl vector92
vector92:
  pushl $0
80105aba:	6a 00                	push   $0x0
  pushl $92
80105abc:	6a 5c                	push   $0x5c
  jmp alltraps
80105abe:	e9 84 f8 ff ff       	jmp    80105347 <alltraps>

80105ac3 <vector93>:
.globl vector93
vector93:
  pushl $0
80105ac3:	6a 00                	push   $0x0
  pushl $93
80105ac5:	6a 5d                	push   $0x5d
  jmp alltraps
80105ac7:	e9 7b f8 ff ff       	jmp    80105347 <alltraps>

80105acc <vector94>:
.globl vector94
vector94:
  pushl $0
80105acc:	6a 00                	push   $0x0
  pushl $94
80105ace:	6a 5e                	push   $0x5e
  jmp alltraps
80105ad0:	e9 72 f8 ff ff       	jmp    80105347 <alltraps>

80105ad5 <vector95>:
.globl vector95
vector95:
  pushl $0
80105ad5:	6a 00                	push   $0x0
  pushl $95
80105ad7:	6a 5f                	push   $0x5f
  jmp alltraps
80105ad9:	e9 69 f8 ff ff       	jmp    80105347 <alltraps>

80105ade <vector96>:
.globl vector96
vector96:
  pushl $0
80105ade:	6a 00                	push   $0x0
  pushl $96
80105ae0:	6a 60                	push   $0x60
  jmp alltraps
80105ae2:	e9 60 f8 ff ff       	jmp    80105347 <alltraps>

80105ae7 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ae7:	6a 00                	push   $0x0
  pushl $97
80105ae9:	6a 61                	push   $0x61
  jmp alltraps
80105aeb:	e9 57 f8 ff ff       	jmp    80105347 <alltraps>

80105af0 <vector98>:
.globl vector98
vector98:
  pushl $0
80105af0:	6a 00                	push   $0x0
  pushl $98
80105af2:	6a 62                	push   $0x62
  jmp alltraps
80105af4:	e9 4e f8 ff ff       	jmp    80105347 <alltraps>

80105af9 <vector99>:
.globl vector99
vector99:
  pushl $0
80105af9:	6a 00                	push   $0x0
  pushl $99
80105afb:	6a 63                	push   $0x63
  jmp alltraps
80105afd:	e9 45 f8 ff ff       	jmp    80105347 <alltraps>

80105b02 <vector100>:
.globl vector100
vector100:
  pushl $0
80105b02:	6a 00                	push   $0x0
  pushl $100
80105b04:	6a 64                	push   $0x64
  jmp alltraps
80105b06:	e9 3c f8 ff ff       	jmp    80105347 <alltraps>

80105b0b <vector101>:
.globl vector101
vector101:
  pushl $0
80105b0b:	6a 00                	push   $0x0
  pushl $101
80105b0d:	6a 65                	push   $0x65
  jmp alltraps
80105b0f:	e9 33 f8 ff ff       	jmp    80105347 <alltraps>

80105b14 <vector102>:
.globl vector102
vector102:
  pushl $0
80105b14:	6a 00                	push   $0x0
  pushl $102
80105b16:	6a 66                	push   $0x66
  jmp alltraps
80105b18:	e9 2a f8 ff ff       	jmp    80105347 <alltraps>

80105b1d <vector103>:
.globl vector103
vector103:
  pushl $0
80105b1d:	6a 00                	push   $0x0
  pushl $103
80105b1f:	6a 67                	push   $0x67
  jmp alltraps
80105b21:	e9 21 f8 ff ff       	jmp    80105347 <alltraps>

80105b26 <vector104>:
.globl vector104
vector104:
  pushl $0
80105b26:	6a 00                	push   $0x0
  pushl $104
80105b28:	6a 68                	push   $0x68
  jmp alltraps
80105b2a:	e9 18 f8 ff ff       	jmp    80105347 <alltraps>

80105b2f <vector105>:
.globl vector105
vector105:
  pushl $0
80105b2f:	6a 00                	push   $0x0
  pushl $105
80105b31:	6a 69                	push   $0x69
  jmp alltraps
80105b33:	e9 0f f8 ff ff       	jmp    80105347 <alltraps>

80105b38 <vector106>:
.globl vector106
vector106:
  pushl $0
80105b38:	6a 00                	push   $0x0
  pushl $106
80105b3a:	6a 6a                	push   $0x6a
  jmp alltraps
80105b3c:	e9 06 f8 ff ff       	jmp    80105347 <alltraps>

80105b41 <vector107>:
.globl vector107
vector107:
  pushl $0
80105b41:	6a 00                	push   $0x0
  pushl $107
80105b43:	6a 6b                	push   $0x6b
  jmp alltraps
80105b45:	e9 fd f7 ff ff       	jmp    80105347 <alltraps>

80105b4a <vector108>:
.globl vector108
vector108:
  pushl $0
80105b4a:	6a 00                	push   $0x0
  pushl $108
80105b4c:	6a 6c                	push   $0x6c
  jmp alltraps
80105b4e:	e9 f4 f7 ff ff       	jmp    80105347 <alltraps>

80105b53 <vector109>:
.globl vector109
vector109:
  pushl $0
80105b53:	6a 00                	push   $0x0
  pushl $109
80105b55:	6a 6d                	push   $0x6d
  jmp alltraps
80105b57:	e9 eb f7 ff ff       	jmp    80105347 <alltraps>

80105b5c <vector110>:
.globl vector110
vector110:
  pushl $0
80105b5c:	6a 00                	push   $0x0
  pushl $110
80105b5e:	6a 6e                	push   $0x6e
  jmp alltraps
80105b60:	e9 e2 f7 ff ff       	jmp    80105347 <alltraps>

80105b65 <vector111>:
.globl vector111
vector111:
  pushl $0
80105b65:	6a 00                	push   $0x0
  pushl $111
80105b67:	6a 6f                	push   $0x6f
  jmp alltraps
80105b69:	e9 d9 f7 ff ff       	jmp    80105347 <alltraps>

80105b6e <vector112>:
.globl vector112
vector112:
  pushl $0
80105b6e:	6a 00                	push   $0x0
  pushl $112
80105b70:	6a 70                	push   $0x70
  jmp alltraps
80105b72:	e9 d0 f7 ff ff       	jmp    80105347 <alltraps>

80105b77 <vector113>:
.globl vector113
vector113:
  pushl $0
80105b77:	6a 00                	push   $0x0
  pushl $113
80105b79:	6a 71                	push   $0x71
  jmp alltraps
80105b7b:	e9 c7 f7 ff ff       	jmp    80105347 <alltraps>

80105b80 <vector114>:
.globl vector114
vector114:
  pushl $0
80105b80:	6a 00                	push   $0x0
  pushl $114
80105b82:	6a 72                	push   $0x72
  jmp alltraps
80105b84:	e9 be f7 ff ff       	jmp    80105347 <alltraps>

80105b89 <vector115>:
.globl vector115
vector115:
  pushl $0
80105b89:	6a 00                	push   $0x0
  pushl $115
80105b8b:	6a 73                	push   $0x73
  jmp alltraps
80105b8d:	e9 b5 f7 ff ff       	jmp    80105347 <alltraps>

80105b92 <vector116>:
.globl vector116
vector116:
  pushl $0
80105b92:	6a 00                	push   $0x0
  pushl $116
80105b94:	6a 74                	push   $0x74
  jmp alltraps
80105b96:	e9 ac f7 ff ff       	jmp    80105347 <alltraps>

80105b9b <vector117>:
.globl vector117
vector117:
  pushl $0
80105b9b:	6a 00                	push   $0x0
  pushl $117
80105b9d:	6a 75                	push   $0x75
  jmp alltraps
80105b9f:	e9 a3 f7 ff ff       	jmp    80105347 <alltraps>

80105ba4 <vector118>:
.globl vector118
vector118:
  pushl $0
80105ba4:	6a 00                	push   $0x0
  pushl $118
80105ba6:	6a 76                	push   $0x76
  jmp alltraps
80105ba8:	e9 9a f7 ff ff       	jmp    80105347 <alltraps>

80105bad <vector119>:
.globl vector119
vector119:
  pushl $0
80105bad:	6a 00                	push   $0x0
  pushl $119
80105baf:	6a 77                	push   $0x77
  jmp alltraps
80105bb1:	e9 91 f7 ff ff       	jmp    80105347 <alltraps>

80105bb6 <vector120>:
.globl vector120
vector120:
  pushl $0
80105bb6:	6a 00                	push   $0x0
  pushl $120
80105bb8:	6a 78                	push   $0x78
  jmp alltraps
80105bba:	e9 88 f7 ff ff       	jmp    80105347 <alltraps>

80105bbf <vector121>:
.globl vector121
vector121:
  pushl $0
80105bbf:	6a 00                	push   $0x0
  pushl $121
80105bc1:	6a 79                	push   $0x79
  jmp alltraps
80105bc3:	e9 7f f7 ff ff       	jmp    80105347 <alltraps>

80105bc8 <vector122>:
.globl vector122
vector122:
  pushl $0
80105bc8:	6a 00                	push   $0x0
  pushl $122
80105bca:	6a 7a                	push   $0x7a
  jmp alltraps
80105bcc:	e9 76 f7 ff ff       	jmp    80105347 <alltraps>

80105bd1 <vector123>:
.globl vector123
vector123:
  pushl $0
80105bd1:	6a 00                	push   $0x0
  pushl $123
80105bd3:	6a 7b                	push   $0x7b
  jmp alltraps
80105bd5:	e9 6d f7 ff ff       	jmp    80105347 <alltraps>

80105bda <vector124>:
.globl vector124
vector124:
  pushl $0
80105bda:	6a 00                	push   $0x0
  pushl $124
80105bdc:	6a 7c                	push   $0x7c
  jmp alltraps
80105bde:	e9 64 f7 ff ff       	jmp    80105347 <alltraps>

80105be3 <vector125>:
.globl vector125
vector125:
  pushl $0
80105be3:	6a 00                	push   $0x0
  pushl $125
80105be5:	6a 7d                	push   $0x7d
  jmp alltraps
80105be7:	e9 5b f7 ff ff       	jmp    80105347 <alltraps>

80105bec <vector126>:
.globl vector126
vector126:
  pushl $0
80105bec:	6a 00                	push   $0x0
  pushl $126
80105bee:	6a 7e                	push   $0x7e
  jmp alltraps
80105bf0:	e9 52 f7 ff ff       	jmp    80105347 <alltraps>

80105bf5 <vector127>:
.globl vector127
vector127:
  pushl $0
80105bf5:	6a 00                	push   $0x0
  pushl $127
80105bf7:	6a 7f                	push   $0x7f
  jmp alltraps
80105bf9:	e9 49 f7 ff ff       	jmp    80105347 <alltraps>

80105bfe <vector128>:
.globl vector128
vector128:
  pushl $0
80105bfe:	6a 00                	push   $0x0
  pushl $128
80105c00:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105c05:	e9 3d f7 ff ff       	jmp    80105347 <alltraps>

80105c0a <vector129>:
.globl vector129
vector129:
  pushl $0
80105c0a:	6a 00                	push   $0x0
  pushl $129
80105c0c:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105c11:	e9 31 f7 ff ff       	jmp    80105347 <alltraps>

80105c16 <vector130>:
.globl vector130
vector130:
  pushl $0
80105c16:	6a 00                	push   $0x0
  pushl $130
80105c18:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105c1d:	e9 25 f7 ff ff       	jmp    80105347 <alltraps>

80105c22 <vector131>:
.globl vector131
vector131:
  pushl $0
80105c22:	6a 00                	push   $0x0
  pushl $131
80105c24:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105c29:	e9 19 f7 ff ff       	jmp    80105347 <alltraps>

80105c2e <vector132>:
.globl vector132
vector132:
  pushl $0
80105c2e:	6a 00                	push   $0x0
  pushl $132
80105c30:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105c35:	e9 0d f7 ff ff       	jmp    80105347 <alltraps>

80105c3a <vector133>:
.globl vector133
vector133:
  pushl $0
80105c3a:	6a 00                	push   $0x0
  pushl $133
80105c3c:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105c41:	e9 01 f7 ff ff       	jmp    80105347 <alltraps>

80105c46 <vector134>:
.globl vector134
vector134:
  pushl $0
80105c46:	6a 00                	push   $0x0
  pushl $134
80105c48:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105c4d:	e9 f5 f6 ff ff       	jmp    80105347 <alltraps>

80105c52 <vector135>:
.globl vector135
vector135:
  pushl $0
80105c52:	6a 00                	push   $0x0
  pushl $135
80105c54:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105c59:	e9 e9 f6 ff ff       	jmp    80105347 <alltraps>

80105c5e <vector136>:
.globl vector136
vector136:
  pushl $0
80105c5e:	6a 00                	push   $0x0
  pushl $136
80105c60:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105c65:	e9 dd f6 ff ff       	jmp    80105347 <alltraps>

80105c6a <vector137>:
.globl vector137
vector137:
  pushl $0
80105c6a:	6a 00                	push   $0x0
  pushl $137
80105c6c:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105c71:	e9 d1 f6 ff ff       	jmp    80105347 <alltraps>

80105c76 <vector138>:
.globl vector138
vector138:
  pushl $0
80105c76:	6a 00                	push   $0x0
  pushl $138
80105c78:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105c7d:	e9 c5 f6 ff ff       	jmp    80105347 <alltraps>

80105c82 <vector139>:
.globl vector139
vector139:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $139
80105c84:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105c89:	e9 b9 f6 ff ff       	jmp    80105347 <alltraps>

80105c8e <vector140>:
.globl vector140
vector140:
  pushl $0
80105c8e:	6a 00                	push   $0x0
  pushl $140
80105c90:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105c95:	e9 ad f6 ff ff       	jmp    80105347 <alltraps>

80105c9a <vector141>:
.globl vector141
vector141:
  pushl $0
80105c9a:	6a 00                	push   $0x0
  pushl $141
80105c9c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105ca1:	e9 a1 f6 ff ff       	jmp    80105347 <alltraps>

80105ca6 <vector142>:
.globl vector142
vector142:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $142
80105ca8:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105cad:	e9 95 f6 ff ff       	jmp    80105347 <alltraps>

80105cb2 <vector143>:
.globl vector143
vector143:
  pushl $0
80105cb2:	6a 00                	push   $0x0
  pushl $143
80105cb4:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105cb9:	e9 89 f6 ff ff       	jmp    80105347 <alltraps>

80105cbe <vector144>:
.globl vector144
vector144:
  pushl $0
80105cbe:	6a 00                	push   $0x0
  pushl $144
80105cc0:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105cc5:	e9 7d f6 ff ff       	jmp    80105347 <alltraps>

80105cca <vector145>:
.globl vector145
vector145:
  pushl $0
80105cca:	6a 00                	push   $0x0
  pushl $145
80105ccc:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105cd1:	e9 71 f6 ff ff       	jmp    80105347 <alltraps>

80105cd6 <vector146>:
.globl vector146
vector146:
  pushl $0
80105cd6:	6a 00                	push   $0x0
  pushl $146
80105cd8:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105cdd:	e9 65 f6 ff ff       	jmp    80105347 <alltraps>

80105ce2 <vector147>:
.globl vector147
vector147:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $147
80105ce4:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105ce9:	e9 59 f6 ff ff       	jmp    80105347 <alltraps>

80105cee <vector148>:
.globl vector148
vector148:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $148
80105cf0:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105cf5:	e9 4d f6 ff ff       	jmp    80105347 <alltraps>

80105cfa <vector149>:
.globl vector149
vector149:
  pushl $0
80105cfa:	6a 00                	push   $0x0
  pushl $149
80105cfc:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105d01:	e9 41 f6 ff ff       	jmp    80105347 <alltraps>

80105d06 <vector150>:
.globl vector150
vector150:
  pushl $0
80105d06:	6a 00                	push   $0x0
  pushl $150
80105d08:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105d0d:	e9 35 f6 ff ff       	jmp    80105347 <alltraps>

80105d12 <vector151>:
.globl vector151
vector151:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $151
80105d14:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105d19:	e9 29 f6 ff ff       	jmp    80105347 <alltraps>

80105d1e <vector152>:
.globl vector152
vector152:
  pushl $0
80105d1e:	6a 00                	push   $0x0
  pushl $152
80105d20:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105d25:	e9 1d f6 ff ff       	jmp    80105347 <alltraps>

80105d2a <vector153>:
.globl vector153
vector153:
  pushl $0
80105d2a:	6a 00                	push   $0x0
  pushl $153
80105d2c:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105d31:	e9 11 f6 ff ff       	jmp    80105347 <alltraps>

80105d36 <vector154>:
.globl vector154
vector154:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $154
80105d38:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105d3d:	e9 05 f6 ff ff       	jmp    80105347 <alltraps>

80105d42 <vector155>:
.globl vector155
vector155:
  pushl $0
80105d42:	6a 00                	push   $0x0
  pushl $155
80105d44:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105d49:	e9 f9 f5 ff ff       	jmp    80105347 <alltraps>

80105d4e <vector156>:
.globl vector156
vector156:
  pushl $0
80105d4e:	6a 00                	push   $0x0
  pushl $156
80105d50:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105d55:	e9 ed f5 ff ff       	jmp    80105347 <alltraps>

80105d5a <vector157>:
.globl vector157
vector157:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $157
80105d5c:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105d61:	e9 e1 f5 ff ff       	jmp    80105347 <alltraps>

80105d66 <vector158>:
.globl vector158
vector158:
  pushl $0
80105d66:	6a 00                	push   $0x0
  pushl $158
80105d68:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105d6d:	e9 d5 f5 ff ff       	jmp    80105347 <alltraps>

80105d72 <vector159>:
.globl vector159
vector159:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $159
80105d74:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105d79:	e9 c9 f5 ff ff       	jmp    80105347 <alltraps>

80105d7e <vector160>:
.globl vector160
vector160:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $160
80105d80:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105d85:	e9 bd f5 ff ff       	jmp    80105347 <alltraps>

80105d8a <vector161>:
.globl vector161
vector161:
  pushl $0
80105d8a:	6a 00                	push   $0x0
  pushl $161
80105d8c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105d91:	e9 b1 f5 ff ff       	jmp    80105347 <alltraps>

80105d96 <vector162>:
.globl vector162
vector162:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $162
80105d98:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105d9d:	e9 a5 f5 ff ff       	jmp    80105347 <alltraps>

80105da2 <vector163>:
.globl vector163
vector163:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $163
80105da4:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105da9:	e9 99 f5 ff ff       	jmp    80105347 <alltraps>

80105dae <vector164>:
.globl vector164
vector164:
  pushl $0
80105dae:	6a 00                	push   $0x0
  pushl $164
80105db0:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105db5:	e9 8d f5 ff ff       	jmp    80105347 <alltraps>

80105dba <vector165>:
.globl vector165
vector165:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $165
80105dbc:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105dc1:	e9 81 f5 ff ff       	jmp    80105347 <alltraps>

80105dc6 <vector166>:
.globl vector166
vector166:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $166
80105dc8:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105dcd:	e9 75 f5 ff ff       	jmp    80105347 <alltraps>

80105dd2 <vector167>:
.globl vector167
vector167:
  pushl $0
80105dd2:	6a 00                	push   $0x0
  pushl $167
80105dd4:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105dd9:	e9 69 f5 ff ff       	jmp    80105347 <alltraps>

80105dde <vector168>:
.globl vector168
vector168:
  pushl $0
80105dde:	6a 00                	push   $0x0
  pushl $168
80105de0:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105de5:	e9 5d f5 ff ff       	jmp    80105347 <alltraps>

80105dea <vector169>:
.globl vector169
vector169:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $169
80105dec:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105df1:	e9 51 f5 ff ff       	jmp    80105347 <alltraps>

80105df6 <vector170>:
.globl vector170
vector170:
  pushl $0
80105df6:	6a 00                	push   $0x0
  pushl $170
80105df8:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105dfd:	e9 45 f5 ff ff       	jmp    80105347 <alltraps>

80105e02 <vector171>:
.globl vector171
vector171:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $171
80105e04:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105e09:	e9 39 f5 ff ff       	jmp    80105347 <alltraps>

80105e0e <vector172>:
.globl vector172
vector172:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $172
80105e10:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105e15:	e9 2d f5 ff ff       	jmp    80105347 <alltraps>

80105e1a <vector173>:
.globl vector173
vector173:
  pushl $0
80105e1a:	6a 00                	push   $0x0
  pushl $173
80105e1c:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105e21:	e9 21 f5 ff ff       	jmp    80105347 <alltraps>

80105e26 <vector174>:
.globl vector174
vector174:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $174
80105e28:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105e2d:	e9 15 f5 ff ff       	jmp    80105347 <alltraps>

80105e32 <vector175>:
.globl vector175
vector175:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $175
80105e34:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80105e39:	e9 09 f5 ff ff       	jmp    80105347 <alltraps>

80105e3e <vector176>:
.globl vector176
vector176:
  pushl $0
80105e3e:	6a 00                	push   $0x0
  pushl $176
80105e40:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105e45:	e9 fd f4 ff ff       	jmp    80105347 <alltraps>

80105e4a <vector177>:
.globl vector177
vector177:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $177
80105e4c:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105e51:	e9 f1 f4 ff ff       	jmp    80105347 <alltraps>

80105e56 <vector178>:
.globl vector178
vector178:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $178
80105e58:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105e5d:	e9 e5 f4 ff ff       	jmp    80105347 <alltraps>

80105e62 <vector179>:
.globl vector179
vector179:
  pushl $0
80105e62:	6a 00                	push   $0x0
  pushl $179
80105e64:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105e69:	e9 d9 f4 ff ff       	jmp    80105347 <alltraps>

80105e6e <vector180>:
.globl vector180
vector180:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $180
80105e70:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105e75:	e9 cd f4 ff ff       	jmp    80105347 <alltraps>

80105e7a <vector181>:
.globl vector181
vector181:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $181
80105e7c:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105e81:	e9 c1 f4 ff ff       	jmp    80105347 <alltraps>

80105e86 <vector182>:
.globl vector182
vector182:
  pushl $0
80105e86:	6a 00                	push   $0x0
  pushl $182
80105e88:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105e8d:	e9 b5 f4 ff ff       	jmp    80105347 <alltraps>

80105e92 <vector183>:
.globl vector183
vector183:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $183
80105e94:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105e99:	e9 a9 f4 ff ff       	jmp    80105347 <alltraps>

80105e9e <vector184>:
.globl vector184
vector184:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $184
80105ea0:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105ea5:	e9 9d f4 ff ff       	jmp    80105347 <alltraps>

80105eaa <vector185>:
.globl vector185
vector185:
  pushl $0
80105eaa:	6a 00                	push   $0x0
  pushl $185
80105eac:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105eb1:	e9 91 f4 ff ff       	jmp    80105347 <alltraps>

80105eb6 <vector186>:
.globl vector186
vector186:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $186
80105eb8:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105ebd:	e9 85 f4 ff ff       	jmp    80105347 <alltraps>

80105ec2 <vector187>:
.globl vector187
vector187:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $187
80105ec4:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105ec9:	e9 79 f4 ff ff       	jmp    80105347 <alltraps>

80105ece <vector188>:
.globl vector188
vector188:
  pushl $0
80105ece:	6a 00                	push   $0x0
  pushl $188
80105ed0:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105ed5:	e9 6d f4 ff ff       	jmp    80105347 <alltraps>

80105eda <vector189>:
.globl vector189
vector189:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $189
80105edc:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105ee1:	e9 61 f4 ff ff       	jmp    80105347 <alltraps>

80105ee6 <vector190>:
.globl vector190
vector190:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $190
80105ee8:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105eed:	e9 55 f4 ff ff       	jmp    80105347 <alltraps>

80105ef2 <vector191>:
.globl vector191
vector191:
  pushl $0
80105ef2:	6a 00                	push   $0x0
  pushl $191
80105ef4:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105ef9:	e9 49 f4 ff ff       	jmp    80105347 <alltraps>

80105efe <vector192>:
.globl vector192
vector192:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $192
80105f00:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105f05:	e9 3d f4 ff ff       	jmp    80105347 <alltraps>

80105f0a <vector193>:
.globl vector193
vector193:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $193
80105f0c:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105f11:	e9 31 f4 ff ff       	jmp    80105347 <alltraps>

80105f16 <vector194>:
.globl vector194
vector194:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $194
80105f18:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105f1d:	e9 25 f4 ff ff       	jmp    80105347 <alltraps>

80105f22 <vector195>:
.globl vector195
vector195:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $195
80105f24:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105f29:	e9 19 f4 ff ff       	jmp    80105347 <alltraps>

80105f2e <vector196>:
.globl vector196
vector196:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $196
80105f30:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105f35:	e9 0d f4 ff ff       	jmp    80105347 <alltraps>

80105f3a <vector197>:
.globl vector197
vector197:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $197
80105f3c:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105f41:	e9 01 f4 ff ff       	jmp    80105347 <alltraps>

80105f46 <vector198>:
.globl vector198
vector198:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $198
80105f48:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105f4d:	e9 f5 f3 ff ff       	jmp    80105347 <alltraps>

80105f52 <vector199>:
.globl vector199
vector199:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $199
80105f54:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105f59:	e9 e9 f3 ff ff       	jmp    80105347 <alltraps>

80105f5e <vector200>:
.globl vector200
vector200:
  pushl $0
80105f5e:	6a 00                	push   $0x0
  pushl $200
80105f60:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105f65:	e9 dd f3 ff ff       	jmp    80105347 <alltraps>

80105f6a <vector201>:
.globl vector201
vector201:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $201
80105f6c:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105f71:	e9 d1 f3 ff ff       	jmp    80105347 <alltraps>

80105f76 <vector202>:
.globl vector202
vector202:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $202
80105f78:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105f7d:	e9 c5 f3 ff ff       	jmp    80105347 <alltraps>

80105f82 <vector203>:
.globl vector203
vector203:
  pushl $0
80105f82:	6a 00                	push   $0x0
  pushl $203
80105f84:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105f89:	e9 b9 f3 ff ff       	jmp    80105347 <alltraps>

80105f8e <vector204>:
.globl vector204
vector204:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $204
80105f90:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105f95:	e9 ad f3 ff ff       	jmp    80105347 <alltraps>

80105f9a <vector205>:
.globl vector205
vector205:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $205
80105f9c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105fa1:	e9 a1 f3 ff ff       	jmp    80105347 <alltraps>

80105fa6 <vector206>:
.globl vector206
vector206:
  pushl $0
80105fa6:	6a 00                	push   $0x0
  pushl $206
80105fa8:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105fad:	e9 95 f3 ff ff       	jmp    80105347 <alltraps>

80105fb2 <vector207>:
.globl vector207
vector207:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $207
80105fb4:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105fb9:	e9 89 f3 ff ff       	jmp    80105347 <alltraps>

80105fbe <vector208>:
.globl vector208
vector208:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $208
80105fc0:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105fc5:	e9 7d f3 ff ff       	jmp    80105347 <alltraps>

80105fca <vector209>:
.globl vector209
vector209:
  pushl $0
80105fca:	6a 00                	push   $0x0
  pushl $209
80105fcc:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105fd1:	e9 71 f3 ff ff       	jmp    80105347 <alltraps>

80105fd6 <vector210>:
.globl vector210
vector210:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $210
80105fd8:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105fdd:	e9 65 f3 ff ff       	jmp    80105347 <alltraps>

80105fe2 <vector211>:
.globl vector211
vector211:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $211
80105fe4:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105fe9:	e9 59 f3 ff ff       	jmp    80105347 <alltraps>

80105fee <vector212>:
.globl vector212
vector212:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $212
80105ff0:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105ff5:	e9 4d f3 ff ff       	jmp    80105347 <alltraps>

80105ffa <vector213>:
.globl vector213
vector213:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $213
80105ffc:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106001:	e9 41 f3 ff ff       	jmp    80105347 <alltraps>

80106006 <vector214>:
.globl vector214
vector214:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $214
80106008:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010600d:	e9 35 f3 ff ff       	jmp    80105347 <alltraps>

80106012 <vector215>:
.globl vector215
vector215:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $215
80106014:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106019:	e9 29 f3 ff ff       	jmp    80105347 <alltraps>

8010601e <vector216>:
.globl vector216
vector216:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $216
80106020:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106025:	e9 1d f3 ff ff       	jmp    80105347 <alltraps>

8010602a <vector217>:
.globl vector217
vector217:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $217
8010602c:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106031:	e9 11 f3 ff ff       	jmp    80105347 <alltraps>

80106036 <vector218>:
.globl vector218
vector218:
  pushl $0
80106036:	6a 00                	push   $0x0
  pushl $218
80106038:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010603d:	e9 05 f3 ff ff       	jmp    80105347 <alltraps>

80106042 <vector219>:
.globl vector219
vector219:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $219
80106044:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106049:	e9 f9 f2 ff ff       	jmp    80105347 <alltraps>

8010604e <vector220>:
.globl vector220
vector220:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $220
80106050:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106055:	e9 ed f2 ff ff       	jmp    80105347 <alltraps>

8010605a <vector221>:
.globl vector221
vector221:
  pushl $0
8010605a:	6a 00                	push   $0x0
  pushl $221
8010605c:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106061:	e9 e1 f2 ff ff       	jmp    80105347 <alltraps>

80106066 <vector222>:
.globl vector222
vector222:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $222
80106068:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010606d:	e9 d5 f2 ff ff       	jmp    80105347 <alltraps>

80106072 <vector223>:
.globl vector223
vector223:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $223
80106074:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106079:	e9 c9 f2 ff ff       	jmp    80105347 <alltraps>

8010607e <vector224>:
.globl vector224
vector224:
  pushl $0
8010607e:	6a 00                	push   $0x0
  pushl $224
80106080:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106085:	e9 bd f2 ff ff       	jmp    80105347 <alltraps>

8010608a <vector225>:
.globl vector225
vector225:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $225
8010608c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106091:	e9 b1 f2 ff ff       	jmp    80105347 <alltraps>

80106096 <vector226>:
.globl vector226
vector226:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $226
80106098:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010609d:	e9 a5 f2 ff ff       	jmp    80105347 <alltraps>

801060a2 <vector227>:
.globl vector227
vector227:
  pushl $0
801060a2:	6a 00                	push   $0x0
  pushl $227
801060a4:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801060a9:	e9 99 f2 ff ff       	jmp    80105347 <alltraps>

801060ae <vector228>:
.globl vector228
vector228:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $228
801060b0:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801060b5:	e9 8d f2 ff ff       	jmp    80105347 <alltraps>

801060ba <vector229>:
.globl vector229
vector229:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $229
801060bc:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801060c1:	e9 81 f2 ff ff       	jmp    80105347 <alltraps>

801060c6 <vector230>:
.globl vector230
vector230:
  pushl $0
801060c6:	6a 00                	push   $0x0
  pushl $230
801060c8:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801060cd:	e9 75 f2 ff ff       	jmp    80105347 <alltraps>

801060d2 <vector231>:
.globl vector231
vector231:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $231
801060d4:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801060d9:	e9 69 f2 ff ff       	jmp    80105347 <alltraps>

801060de <vector232>:
.globl vector232
vector232:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $232
801060e0:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801060e5:	e9 5d f2 ff ff       	jmp    80105347 <alltraps>

801060ea <vector233>:
.globl vector233
vector233:
  pushl $0
801060ea:	6a 00                	push   $0x0
  pushl $233
801060ec:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801060f1:	e9 51 f2 ff ff       	jmp    80105347 <alltraps>

801060f6 <vector234>:
.globl vector234
vector234:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $234
801060f8:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801060fd:	e9 45 f2 ff ff       	jmp    80105347 <alltraps>

80106102 <vector235>:
.globl vector235
vector235:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $235
80106104:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106109:	e9 39 f2 ff ff       	jmp    80105347 <alltraps>

8010610e <vector236>:
.globl vector236
vector236:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $236
80106110:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106115:	e9 2d f2 ff ff       	jmp    80105347 <alltraps>

8010611a <vector237>:
.globl vector237
vector237:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $237
8010611c:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106121:	e9 21 f2 ff ff       	jmp    80105347 <alltraps>

80106126 <vector238>:
.globl vector238
vector238:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $238
80106128:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010612d:	e9 15 f2 ff ff       	jmp    80105347 <alltraps>

80106132 <vector239>:
.globl vector239
vector239:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $239
80106134:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106139:	e9 09 f2 ff ff       	jmp    80105347 <alltraps>

8010613e <vector240>:
.globl vector240
vector240:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $240
80106140:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106145:	e9 fd f1 ff ff       	jmp    80105347 <alltraps>

8010614a <vector241>:
.globl vector241
vector241:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $241
8010614c:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106151:	e9 f1 f1 ff ff       	jmp    80105347 <alltraps>

80106156 <vector242>:
.globl vector242
vector242:
  pushl $0
80106156:	6a 00                	push   $0x0
  pushl $242
80106158:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010615d:	e9 e5 f1 ff ff       	jmp    80105347 <alltraps>

80106162 <vector243>:
.globl vector243
vector243:
  pushl $0
80106162:	6a 00                	push   $0x0
  pushl $243
80106164:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106169:	e9 d9 f1 ff ff       	jmp    80105347 <alltraps>

8010616e <vector244>:
.globl vector244
vector244:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $244
80106170:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106175:	e9 cd f1 ff ff       	jmp    80105347 <alltraps>

8010617a <vector245>:
.globl vector245
vector245:
  pushl $0
8010617a:	6a 00                	push   $0x0
  pushl $245
8010617c:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106181:	e9 c1 f1 ff ff       	jmp    80105347 <alltraps>

80106186 <vector246>:
.globl vector246
vector246:
  pushl $0
80106186:	6a 00                	push   $0x0
  pushl $246
80106188:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010618d:	e9 b5 f1 ff ff       	jmp    80105347 <alltraps>

80106192 <vector247>:
.globl vector247
vector247:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $247
80106194:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106199:	e9 a9 f1 ff ff       	jmp    80105347 <alltraps>

8010619e <vector248>:
.globl vector248
vector248:
  pushl $0
8010619e:	6a 00                	push   $0x0
  pushl $248
801061a0:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801061a5:	e9 9d f1 ff ff       	jmp    80105347 <alltraps>

801061aa <vector249>:
.globl vector249
vector249:
  pushl $0
801061aa:	6a 00                	push   $0x0
  pushl $249
801061ac:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801061b1:	e9 91 f1 ff ff       	jmp    80105347 <alltraps>

801061b6 <vector250>:
.globl vector250
vector250:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $250
801061b8:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801061bd:	e9 85 f1 ff ff       	jmp    80105347 <alltraps>

801061c2 <vector251>:
.globl vector251
vector251:
  pushl $0
801061c2:	6a 00                	push   $0x0
  pushl $251
801061c4:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801061c9:	e9 79 f1 ff ff       	jmp    80105347 <alltraps>

801061ce <vector252>:
.globl vector252
vector252:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $252
801061d0:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801061d5:	e9 6d f1 ff ff       	jmp    80105347 <alltraps>

801061da <vector253>:
.globl vector253
vector253:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $253
801061dc:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801061e1:	e9 61 f1 ff ff       	jmp    80105347 <alltraps>

801061e6 <vector254>:
.globl vector254
vector254:
  pushl $0
801061e6:	6a 00                	push   $0x0
  pushl $254
801061e8:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801061ed:	e9 55 f1 ff ff       	jmp    80105347 <alltraps>

801061f2 <vector255>:
.globl vector255
vector255:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $255
801061f4:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801061f9:	e9 49 f1 ff ff       	jmp    80105347 <alltraps>

801061fe <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801061fe:	55                   	push   %ebp
801061ff:	89 e5                	mov    %esp,%ebp
80106201:	57                   	push   %edi
80106202:	56                   	push   %esi
80106203:	53                   	push   %ebx
80106204:	83 ec 0c             	sub    $0xc,%esp
80106207:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106209:	c1 ea 16             	shr    $0x16,%edx
8010620c:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
8010620f:	8b 1f                	mov    (%edi),%ebx
80106211:	f6 c3 01             	test   $0x1,%bl
80106214:	74 22                	je     80106238 <walkpgdir+0x3a>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106216:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010621c:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106222:	c1 ee 0c             	shr    $0xc,%esi
80106225:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
8010622b:	8d 1c b3             	lea    (%ebx,%esi,4),%ebx
}
8010622e:	89 d8                	mov    %ebx,%eax
80106230:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106233:	5b                   	pop    %ebx
80106234:	5e                   	pop    %esi
80106235:	5f                   	pop    %edi
80106236:	5d                   	pop    %ebp
80106237:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106238:	85 c9                	test   %ecx,%ecx
8010623a:	74 2b                	je     80106267 <walkpgdir+0x69>
8010623c:	e8 9d be ff ff       	call   801020de <kalloc>
80106241:	89 c3                	mov    %eax,%ebx
80106243:	85 c0                	test   %eax,%eax
80106245:	74 e7                	je     8010622e <walkpgdir+0x30>
    memset(pgtab, 0, PGSIZE);
80106247:	83 ec 04             	sub    $0x4,%esp
8010624a:	68 00 10 00 00       	push   $0x1000
8010624f:	6a 00                	push   $0x0
80106251:	50                   	push   %eax
80106252:	e8 99 df ff ff       	call   801041f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106257:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010625d:	83 c8 07             	or     $0x7,%eax
80106260:	89 07                	mov    %eax,(%edi)
80106262:	83 c4 10             	add    $0x10,%esp
80106265:	eb bb                	jmp    80106222 <walkpgdir+0x24>
      return 0;
80106267:	bb 00 00 00 00       	mov    $0x0,%ebx
8010626c:	eb c0                	jmp    8010622e <walkpgdir+0x30>

8010626e <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010626e:	55                   	push   %ebp
8010626f:	89 e5                	mov    %esp,%ebp
80106271:	57                   	push   %edi
80106272:	56                   	push   %esi
80106273:	53                   	push   %ebx
80106274:	83 ec 1c             	sub    $0x1c,%esp
80106277:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010627a:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
8010627d:	89 d3                	mov    %edx,%ebx
8010627f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106285:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
80106289:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010628f:	b9 01 00 00 00       	mov    $0x1,%ecx
80106294:	89 da                	mov    %ebx,%edx
80106296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106299:	e8 60 ff ff ff       	call   801061fe <walkpgdir>
8010629e:	85 c0                	test   %eax,%eax
801062a0:	74 2e                	je     801062d0 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
801062a2:	f6 00 01             	testb  $0x1,(%eax)
801062a5:	75 1c                	jne    801062c3 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
801062a7:	89 f2                	mov    %esi,%edx
801062a9:	0b 55 0c             	or     0xc(%ebp),%edx
801062ac:	83 ca 01             	or     $0x1,%edx
801062af:	89 10                	mov    %edx,(%eax)
    if(a == last)
801062b1:	39 fb                	cmp    %edi,%ebx
801062b3:	74 28                	je     801062dd <mappages+0x6f>
      break;
    a += PGSIZE;
801062b5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
801062bb:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801062c1:	eb cc                	jmp    8010628f <mappages+0x21>
      panic("remap");
801062c3:	83 ec 0c             	sub    $0xc,%esp
801062c6:	68 94 74 10 80       	push   $0x80107494
801062cb:	e8 78 a0 ff ff       	call   80100348 <panic>
      return -1;
801062d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
801062d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062d8:	5b                   	pop    %ebx
801062d9:	5e                   	pop    %esi
801062da:	5f                   	pop    %edi
801062db:	5d                   	pop    %ebp
801062dc:	c3                   	ret    
  return 0;
801062dd:	b8 00 00 00 00       	mov    $0x0,%eax
801062e2:	eb f1                	jmp    801062d5 <mappages+0x67>

801062e4 <seginit>:
{
801062e4:	55                   	push   %ebp
801062e5:	89 e5                	mov    %esp,%ebp
801062e7:	53                   	push   %ebx
801062e8:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpuid()];
801062eb:	e8 b4 ce ff ff       	call   801031a4 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801062f0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801062f6:	66 c7 80 f8 27 11 80 	movw   $0xffff,-0x7feed808(%eax)
801062fd:	ff ff 
801062ff:	66 c7 80 fa 27 11 80 	movw   $0x0,-0x7feed806(%eax)
80106306:	00 00 
80106308:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
8010630f:	0f b6 88 fd 27 11 80 	movzbl -0x7feed803(%eax),%ecx
80106316:	83 e1 f0             	and    $0xfffffff0,%ecx
80106319:	83 c9 1a             	or     $0x1a,%ecx
8010631c:	83 e1 9f             	and    $0xffffff9f,%ecx
8010631f:	83 c9 80             	or     $0xffffff80,%ecx
80106322:	88 88 fd 27 11 80    	mov    %cl,-0x7feed803(%eax)
80106328:	0f b6 88 fe 27 11 80 	movzbl -0x7feed802(%eax),%ecx
8010632f:	83 c9 0f             	or     $0xf,%ecx
80106332:	83 e1 cf             	and    $0xffffffcf,%ecx
80106335:	83 c9 c0             	or     $0xffffffc0,%ecx
80106338:	88 88 fe 27 11 80    	mov    %cl,-0x7feed802(%eax)
8010633e:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106345:	66 c7 80 00 28 11 80 	movw   $0xffff,-0x7feed800(%eax)
8010634c:	ff ff 
8010634e:	66 c7 80 02 28 11 80 	movw   $0x0,-0x7feed7fe(%eax)
80106355:	00 00 
80106357:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
8010635e:	0f b6 88 05 28 11 80 	movzbl -0x7feed7fb(%eax),%ecx
80106365:	83 e1 f0             	and    $0xfffffff0,%ecx
80106368:	83 c9 12             	or     $0x12,%ecx
8010636b:	83 e1 9f             	and    $0xffffff9f,%ecx
8010636e:	83 c9 80             	or     $0xffffff80,%ecx
80106371:	88 88 05 28 11 80    	mov    %cl,-0x7feed7fb(%eax)
80106377:	0f b6 88 06 28 11 80 	movzbl -0x7feed7fa(%eax),%ecx
8010637e:	83 c9 0f             	or     $0xf,%ecx
80106381:	83 e1 cf             	and    $0xffffffcf,%ecx
80106384:	83 c9 c0             	or     $0xffffffc0,%ecx
80106387:	88 88 06 28 11 80    	mov    %cl,-0x7feed7fa(%eax)
8010638d:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106394:	66 c7 80 08 28 11 80 	movw   $0xffff,-0x7feed7f8(%eax)
8010639b:	ff ff 
8010639d:	66 c7 80 0a 28 11 80 	movw   $0x0,-0x7feed7f6(%eax)
801063a4:	00 00 
801063a6:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
801063ad:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
801063b4:	0f b6 88 0e 28 11 80 	movzbl -0x7feed7f2(%eax),%ecx
801063bb:	83 c9 0f             	or     $0xf,%ecx
801063be:	83 e1 cf             	and    $0xffffffcf,%ecx
801063c1:	83 c9 c0             	or     $0xffffffc0,%ecx
801063c4:	88 88 0e 28 11 80    	mov    %cl,-0x7feed7f2(%eax)
801063ca:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801063d1:	66 c7 80 10 28 11 80 	movw   $0xffff,-0x7feed7f0(%eax)
801063d8:	ff ff 
801063da:	66 c7 80 12 28 11 80 	movw   $0x0,-0x7feed7ee(%eax)
801063e1:	00 00 
801063e3:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
801063ea:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
801063f1:	0f b6 88 16 28 11 80 	movzbl -0x7feed7ea(%eax),%ecx
801063f8:	83 c9 0f             	or     $0xf,%ecx
801063fb:	83 e1 cf             	and    $0xffffffcf,%ecx
801063fe:	83 c9 c0             	or     $0xffffffc0,%ecx
80106401:	88 88 16 28 11 80    	mov    %cl,-0x7feed7ea(%eax)
80106407:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010640e:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[0] = size-1;
80106413:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80106419:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
8010641d:	c1 e8 10             	shr    $0x10,%eax
80106420:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106424:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106427:	0f 01 10             	lgdtl  (%eax)
}
8010642a:	83 c4 14             	add    $0x14,%esp
8010642d:	5b                   	pop    %ebx
8010642e:	5d                   	pop    %ebp
8010642f:	c3                   	ret    

80106430 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106433:	a1 a4 79 11 80       	mov    0x801179a4,%eax
80106438:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010643d:	0f 22 d8             	mov    %eax,%cr3
}
80106440:	5d                   	pop    %ebp
80106441:	c3                   	ret    

80106442 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106442:	55                   	push   %ebp
80106443:	89 e5                	mov    %esp,%ebp
80106445:	57                   	push   %edi
80106446:	56                   	push   %esi
80106447:	53                   	push   %ebx
80106448:	83 ec 1c             	sub    $0x1c,%esp
8010644b:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010644e:	85 f6                	test   %esi,%esi
80106450:	0f 84 dd 00 00 00    	je     80106533 <switchuvm+0xf1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106456:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
8010645a:	0f 84 e0 00 00 00    	je     80106540 <switchuvm+0xfe>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106460:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80106464:	0f 84 e3 00 00 00    	je     8010654d <switchuvm+0x10b>
    panic("switchuvm: no pgdir");

  pushcli();
8010646a:	e8 f8 db ff ff       	call   80104067 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010646f:	e8 d4 cc ff ff       	call   80103148 <mycpu>
80106474:	89 c3                	mov    %eax,%ebx
80106476:	e8 cd cc ff ff       	call   80103148 <mycpu>
8010647b:	8d 78 08             	lea    0x8(%eax),%edi
8010647e:	e8 c5 cc ff ff       	call   80103148 <mycpu>
80106483:	83 c0 08             	add    $0x8,%eax
80106486:	c1 e8 10             	shr    $0x10,%eax
80106489:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010648c:	e8 b7 cc ff ff       	call   80103148 <mycpu>
80106491:	83 c0 08             	add    $0x8,%eax
80106494:	c1 e8 18             	shr    $0x18,%eax
80106497:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
8010649e:	67 00 
801064a0:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801064a7:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
801064ab:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801064b1:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
801064b8:	83 e2 f0             	and    $0xfffffff0,%edx
801064bb:	83 ca 19             	or     $0x19,%edx
801064be:	83 e2 9f             	and    $0xffffff9f,%edx
801064c1:	83 ca 80             	or     $0xffffff80,%edx
801064c4:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801064ca:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801064d1:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
801064d7:	e8 6c cc ff ff       	call   80103148 <mycpu>
801064dc:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801064e3:	83 e2 ef             	and    $0xffffffef,%edx
801064e6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801064ec:	e8 57 cc ff ff       	call   80103148 <mycpu>
801064f1:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801064f7:	8b 5e 08             	mov    0x8(%esi),%ebx
801064fa:	e8 49 cc ff ff       	call   80103148 <mycpu>
801064ff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106505:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106508:	e8 3b cc ff ff       	call   80103148 <mycpu>
8010650d:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106513:	b8 28 00 00 00       	mov    $0x28,%eax
80106518:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010651b:	8b 46 04             	mov    0x4(%esi),%eax
8010651e:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106523:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106526:	e8 79 db ff ff       	call   801040a4 <popcli>
}
8010652b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010652e:	5b                   	pop    %ebx
8010652f:	5e                   	pop    %esi
80106530:	5f                   	pop    %edi
80106531:	5d                   	pop    %ebp
80106532:	c3                   	ret    
    panic("switchuvm: no process");
80106533:	83 ec 0c             	sub    $0xc,%esp
80106536:	68 9a 74 10 80       	push   $0x8010749a
8010653b:	e8 08 9e ff ff       	call   80100348 <panic>
    panic("switchuvm: no kstack");
80106540:	83 ec 0c             	sub    $0xc,%esp
80106543:	68 b0 74 10 80       	push   $0x801074b0
80106548:	e8 fb 9d ff ff       	call   80100348 <panic>
    panic("switchuvm: no pgdir");
8010654d:	83 ec 0c             	sub    $0xc,%esp
80106550:	68 c5 74 10 80       	push   $0x801074c5
80106555:	e8 ee 9d ff ff       	call   80100348 <panic>

8010655a <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010655a:	55                   	push   %ebp
8010655b:	89 e5                	mov    %esp,%ebp
8010655d:	56                   	push   %esi
8010655e:	53                   	push   %ebx
8010655f:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106562:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106568:	77 4c                	ja     801065b6 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
8010656a:	e8 6f bb ff ff       	call   801020de <kalloc>
8010656f:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106571:	83 ec 04             	sub    $0x4,%esp
80106574:	68 00 10 00 00       	push   $0x1000
80106579:	6a 00                	push   $0x0
8010657b:	50                   	push   %eax
8010657c:	e8 6f dc ff ff       	call   801041f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106581:	83 c4 08             	add    $0x8,%esp
80106584:	6a 06                	push   $0x6
80106586:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010658c:	50                   	push   %eax
8010658d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106592:	ba 00 00 00 00       	mov    $0x0,%edx
80106597:	8b 45 08             	mov    0x8(%ebp),%eax
8010659a:	e8 cf fc ff ff       	call   8010626e <mappages>
  memmove(mem, init, sz);
8010659f:	83 c4 0c             	add    $0xc,%esp
801065a2:	56                   	push   %esi
801065a3:	ff 75 0c             	pushl  0xc(%ebp)
801065a6:	53                   	push   %ebx
801065a7:	e8 bf dc ff ff       	call   8010426b <memmove>
}
801065ac:	83 c4 10             	add    $0x10,%esp
801065af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065b2:	5b                   	pop    %ebx
801065b3:	5e                   	pop    %esi
801065b4:	5d                   	pop    %ebp
801065b5:	c3                   	ret    
    panic("inituvm: more than a page");
801065b6:	83 ec 0c             	sub    $0xc,%esp
801065b9:	68 d9 74 10 80       	push   $0x801074d9
801065be:	e8 85 9d ff ff       	call   80100348 <panic>

801065c3 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801065c3:	55                   	push   %ebp
801065c4:	89 e5                	mov    %esp,%ebp
801065c6:	57                   	push   %edi
801065c7:	56                   	push   %esi
801065c8:	53                   	push   %ebx
801065c9:	83 ec 0c             	sub    $0xc,%esp
801065cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801065cf:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801065d6:	75 07                	jne    801065df <loaduvm+0x1c>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801065d8:	bb 00 00 00 00       	mov    $0x0,%ebx
801065dd:	eb 3c                	jmp    8010661b <loaduvm+0x58>
    panic("loaduvm: addr must be page aligned");
801065df:	83 ec 0c             	sub    $0xc,%esp
801065e2:	68 94 75 10 80       	push   $0x80107594
801065e7:	e8 5c 9d ff ff       	call   80100348 <panic>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801065ec:	83 ec 0c             	sub    $0xc,%esp
801065ef:	68 f3 74 10 80       	push   $0x801074f3
801065f4:	e8 4f 9d ff ff       	call   80100348 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801065f9:	05 00 00 00 80       	add    $0x80000000,%eax
801065fe:	56                   	push   %esi
801065ff:	89 da                	mov    %ebx,%edx
80106601:	03 55 14             	add    0x14(%ebp),%edx
80106604:	52                   	push   %edx
80106605:	50                   	push   %eax
80106606:	ff 75 10             	pushl  0x10(%ebp)
80106609:	e8 88 b1 ff ff       	call   80101796 <readi>
8010660e:	83 c4 10             	add    $0x10,%esp
80106611:	39 f0                	cmp    %esi,%eax
80106613:	75 47                	jne    8010665c <loaduvm+0x99>
  for(i = 0; i < sz; i += PGSIZE){
80106615:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010661b:	39 fb                	cmp    %edi,%ebx
8010661d:	73 30                	jae    8010664f <loaduvm+0x8c>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010661f:	89 da                	mov    %ebx,%edx
80106621:	03 55 0c             	add    0xc(%ebp),%edx
80106624:	b9 00 00 00 00       	mov    $0x0,%ecx
80106629:	8b 45 08             	mov    0x8(%ebp),%eax
8010662c:	e8 cd fb ff ff       	call   801061fe <walkpgdir>
80106631:	85 c0                	test   %eax,%eax
80106633:	74 b7                	je     801065ec <loaduvm+0x29>
    pa = PTE_ADDR(*pte);
80106635:	8b 00                	mov    (%eax),%eax
80106637:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010663c:	89 fe                	mov    %edi,%esi
8010663e:	29 de                	sub    %ebx,%esi
80106640:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106646:	76 b1                	jbe    801065f9 <loaduvm+0x36>
      n = PGSIZE;
80106648:	be 00 10 00 00       	mov    $0x1000,%esi
8010664d:	eb aa                	jmp    801065f9 <loaduvm+0x36>
      return -1;
  }
  return 0;
8010664f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106654:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106657:	5b                   	pop    %ebx
80106658:	5e                   	pop    %esi
80106659:	5f                   	pop    %edi
8010665a:	5d                   	pop    %ebp
8010665b:	c3                   	ret    
      return -1;
8010665c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106661:	eb f1                	jmp    80106654 <loaduvm+0x91>

80106663 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106663:	55                   	push   %ebp
80106664:	89 e5                	mov    %esp,%ebp
80106666:	57                   	push   %edi
80106667:	56                   	push   %esi
80106668:	53                   	push   %ebx
80106669:	83 ec 0c             	sub    $0xc,%esp
8010666c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010666f:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106672:	73 11                	jae    80106685 <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
80106674:	8b 45 10             	mov    0x10(%ebp),%eax
80106677:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010667d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106683:	eb 19                	jmp    8010669e <deallocuvm+0x3b>
    return oldsz;
80106685:	89 f8                	mov    %edi,%eax
80106687:	eb 64                	jmp    801066ed <deallocuvm+0x8a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106689:	c1 eb 16             	shr    $0x16,%ebx
8010668c:	83 c3 01             	add    $0x1,%ebx
8010668f:	c1 e3 16             	shl    $0x16,%ebx
80106692:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106698:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010669e:	39 fb                	cmp    %edi,%ebx
801066a0:	73 48                	jae    801066ea <deallocuvm+0x87>
    pte = walkpgdir(pgdir, (char*)a, 0);
801066a2:	b9 00 00 00 00       	mov    $0x0,%ecx
801066a7:	89 da                	mov    %ebx,%edx
801066a9:	8b 45 08             	mov    0x8(%ebp),%eax
801066ac:	e8 4d fb ff ff       	call   801061fe <walkpgdir>
801066b1:	89 c6                	mov    %eax,%esi
    if(!pte)
801066b3:	85 c0                	test   %eax,%eax
801066b5:	74 d2                	je     80106689 <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
801066b7:	8b 00                	mov    (%eax),%eax
801066b9:	a8 01                	test   $0x1,%al
801066bb:	74 db                	je     80106698 <deallocuvm+0x35>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801066bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066c2:	74 19                	je     801066dd <deallocuvm+0x7a>
        panic("kfree");
      char *v = P2V(pa);
801066c4:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801066c9:	83 ec 0c             	sub    $0xc,%esp
801066cc:	50                   	push   %eax
801066cd:	e8 f5 b8 ff ff       	call   80101fc7 <kfree>
      *pte = 0;
801066d2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801066d8:	83 c4 10             	add    $0x10,%esp
801066db:	eb bb                	jmp    80106698 <deallocuvm+0x35>
        panic("kfree");
801066dd:	83 ec 0c             	sub    $0xc,%esp
801066e0:	68 06 6d 10 80       	push   $0x80106d06
801066e5:	e8 5e 9c ff ff       	call   80100348 <panic>
    }
  }
  return newsz;
801066ea:	8b 45 10             	mov    0x10(%ebp),%eax
}
801066ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066f0:	5b                   	pop    %ebx
801066f1:	5e                   	pop    %esi
801066f2:	5f                   	pop    %edi
801066f3:	5d                   	pop    %ebp
801066f4:	c3                   	ret    

801066f5 <allocuvm>:
{
801066f5:	55                   	push   %ebp
801066f6:	89 e5                	mov    %esp,%ebp
801066f8:	57                   	push   %edi
801066f9:	56                   	push   %esi
801066fa:	53                   	push   %ebx
801066fb:	83 ec 1c             	sub    $0x1c,%esp
801066fe:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106701:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106704:	85 ff                	test   %edi,%edi
80106706:	0f 88 c1 00 00 00    	js     801067cd <allocuvm+0xd8>
  if(newsz < oldsz)
8010670c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010670f:	72 5c                	jb     8010676d <allocuvm+0x78>
  a = PGROUNDUP(oldsz);
80106711:	8b 45 0c             	mov    0xc(%ebp),%eax
80106714:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010671a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106720:	39 fb                	cmp    %edi,%ebx
80106722:	0f 83 ac 00 00 00    	jae    801067d4 <allocuvm+0xdf>
    mem = kalloc();
80106728:	e8 b1 b9 ff ff       	call   801020de <kalloc>
8010672d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010672f:	85 c0                	test   %eax,%eax
80106731:	74 42                	je     80106775 <allocuvm+0x80>
    memset(mem, 0, PGSIZE);
80106733:	83 ec 04             	sub    $0x4,%esp
80106736:	68 00 10 00 00       	push   $0x1000
8010673b:	6a 00                	push   $0x0
8010673d:	50                   	push   %eax
8010673e:	e8 ad da ff ff       	call   801041f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106743:	83 c4 08             	add    $0x8,%esp
80106746:	6a 06                	push   $0x6
80106748:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010674e:	50                   	push   %eax
8010674f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106754:	89 da                	mov    %ebx,%edx
80106756:	8b 45 08             	mov    0x8(%ebp),%eax
80106759:	e8 10 fb ff ff       	call   8010626e <mappages>
8010675e:	83 c4 10             	add    $0x10,%esp
80106761:	85 c0                	test   %eax,%eax
80106763:	78 38                	js     8010679d <allocuvm+0xa8>
  for(; a < newsz; a += PGSIZE){
80106765:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010676b:	eb b3                	jmp    80106720 <allocuvm+0x2b>
    return oldsz;
8010676d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106773:	eb 5f                	jmp    801067d4 <allocuvm+0xdf>
      cprintf("allocuvm out of memory\n");
80106775:	83 ec 0c             	sub    $0xc,%esp
80106778:	68 11 75 10 80       	push   $0x80107511
8010677d:	e8 89 9e ff ff       	call   8010060b <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106782:	83 c4 0c             	add    $0xc,%esp
80106785:	ff 75 0c             	pushl  0xc(%ebp)
80106788:	57                   	push   %edi
80106789:	ff 75 08             	pushl  0x8(%ebp)
8010678c:	e8 d2 fe ff ff       	call   80106663 <deallocuvm>
      return 0;
80106791:	83 c4 10             	add    $0x10,%esp
80106794:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010679b:	eb 37                	jmp    801067d4 <allocuvm+0xdf>
      cprintf("allocuvm out of memory (2)\n");
8010679d:	83 ec 0c             	sub    $0xc,%esp
801067a0:	68 29 75 10 80       	push   $0x80107529
801067a5:	e8 61 9e ff ff       	call   8010060b <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801067aa:	83 c4 0c             	add    $0xc,%esp
801067ad:	ff 75 0c             	pushl  0xc(%ebp)
801067b0:	57                   	push   %edi
801067b1:	ff 75 08             	pushl  0x8(%ebp)
801067b4:	e8 aa fe ff ff       	call   80106663 <deallocuvm>
      kfree(mem);
801067b9:	89 34 24             	mov    %esi,(%esp)
801067bc:	e8 06 b8 ff ff       	call   80101fc7 <kfree>
      return 0;
801067c1:	83 c4 10             	add    $0x10,%esp
801067c4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801067cb:	eb 07                	jmp    801067d4 <allocuvm+0xdf>
    return 0;
801067cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801067d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067da:	5b                   	pop    %ebx
801067db:	5e                   	pop    %esi
801067dc:	5f                   	pop    %edi
801067dd:	5d                   	pop    %ebp
801067de:	c3                   	ret    

801067df <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801067df:	55                   	push   %ebp
801067e0:	89 e5                	mov    %esp,%ebp
801067e2:	56                   	push   %esi
801067e3:	53                   	push   %ebx
801067e4:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801067e7:	85 f6                	test   %esi,%esi
801067e9:	74 1a                	je     80106805 <freevm+0x26>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
801067eb:	83 ec 04             	sub    $0x4,%esp
801067ee:	6a 00                	push   $0x0
801067f0:	68 00 00 00 80       	push   $0x80000000
801067f5:	56                   	push   %esi
801067f6:	e8 68 fe ff ff       	call   80106663 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801067fb:	83 c4 10             	add    $0x10,%esp
801067fe:	bb 00 00 00 00       	mov    $0x0,%ebx
80106803:	eb 10                	jmp    80106815 <freevm+0x36>
    panic("freevm: no pgdir");
80106805:	83 ec 0c             	sub    $0xc,%esp
80106808:	68 45 75 10 80       	push   $0x80107545
8010680d:	e8 36 9b ff ff       	call   80100348 <panic>
  for(i = 0; i < NPDENTRIES; i++){
80106812:	83 c3 01             	add    $0x1,%ebx
80106815:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
8010681b:	77 1f                	ja     8010683c <freevm+0x5d>
    if(pgdir[i] & PTE_P){
8010681d:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
80106820:	a8 01                	test   $0x1,%al
80106822:	74 ee                	je     80106812 <freevm+0x33>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106824:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106829:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010682e:	83 ec 0c             	sub    $0xc,%esp
80106831:	50                   	push   %eax
80106832:	e8 90 b7 ff ff       	call   80101fc7 <kfree>
80106837:	83 c4 10             	add    $0x10,%esp
8010683a:	eb d6                	jmp    80106812 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
8010683c:	83 ec 0c             	sub    $0xc,%esp
8010683f:	56                   	push   %esi
80106840:	e8 82 b7 ff ff       	call   80101fc7 <kfree>
}
80106845:	83 c4 10             	add    $0x10,%esp
80106848:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010684b:	5b                   	pop    %ebx
8010684c:	5e                   	pop    %esi
8010684d:	5d                   	pop    %ebp
8010684e:	c3                   	ret    

8010684f <setupkvm>:
{
8010684f:	55                   	push   %ebp
80106850:	89 e5                	mov    %esp,%ebp
80106852:	56                   	push   %esi
80106853:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106854:	e8 85 b8 ff ff       	call   801020de <kalloc>
80106859:	89 c6                	mov    %eax,%esi
8010685b:	85 c0                	test   %eax,%eax
8010685d:	74 55                	je     801068b4 <setupkvm+0x65>
  memset(pgdir, 0, PGSIZE);
8010685f:	83 ec 04             	sub    $0x4,%esp
80106862:	68 00 10 00 00       	push   $0x1000
80106867:	6a 00                	push   $0x0
80106869:	50                   	push   %eax
8010686a:	e8 81 d9 ff ff       	call   801041f0 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010686f:	83 c4 10             	add    $0x10,%esp
80106872:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106877:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
8010687d:	73 35                	jae    801068b4 <setupkvm+0x65>
                (uint)k->phys_start, k->perm) < 0) {
8010687f:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106882:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106885:	29 c1                	sub    %eax,%ecx
80106887:	83 ec 08             	sub    $0x8,%esp
8010688a:	ff 73 0c             	pushl  0xc(%ebx)
8010688d:	50                   	push   %eax
8010688e:	8b 13                	mov    (%ebx),%edx
80106890:	89 f0                	mov    %esi,%eax
80106892:	e8 d7 f9 ff ff       	call   8010626e <mappages>
80106897:	83 c4 10             	add    $0x10,%esp
8010689a:	85 c0                	test   %eax,%eax
8010689c:	78 05                	js     801068a3 <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010689e:	83 c3 10             	add    $0x10,%ebx
801068a1:	eb d4                	jmp    80106877 <setupkvm+0x28>
      freevm(pgdir);
801068a3:	83 ec 0c             	sub    $0xc,%esp
801068a6:	56                   	push   %esi
801068a7:	e8 33 ff ff ff       	call   801067df <freevm>
      return 0;
801068ac:	83 c4 10             	add    $0x10,%esp
801068af:	be 00 00 00 00       	mov    $0x0,%esi
}
801068b4:	89 f0                	mov    %esi,%eax
801068b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801068b9:	5b                   	pop    %ebx
801068ba:	5e                   	pop    %esi
801068bb:	5d                   	pop    %ebp
801068bc:	c3                   	ret    

801068bd <kvmalloc>:
{
801068bd:	55                   	push   %ebp
801068be:	89 e5                	mov    %esp,%ebp
801068c0:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801068c3:	e8 87 ff ff ff       	call   8010684f <setupkvm>
801068c8:	a3 a4 79 11 80       	mov    %eax,0x801179a4
  switchkvm();
801068cd:	e8 5e fb ff ff       	call   80106430 <switchkvm>
}
801068d2:	c9                   	leave  
801068d3:	c3                   	ret    

801068d4 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801068d4:	55                   	push   %ebp
801068d5:	89 e5                	mov    %esp,%ebp
801068d7:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801068da:	b9 00 00 00 00       	mov    $0x0,%ecx
801068df:	8b 55 0c             	mov    0xc(%ebp),%edx
801068e2:	8b 45 08             	mov    0x8(%ebp),%eax
801068e5:	e8 14 f9 ff ff       	call   801061fe <walkpgdir>
  if(pte == 0)
801068ea:	85 c0                	test   %eax,%eax
801068ec:	74 05                	je     801068f3 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801068ee:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801068f1:	c9                   	leave  
801068f2:	c3                   	ret    
    panic("clearpteu");
801068f3:	83 ec 0c             	sub    $0xc,%esp
801068f6:	68 56 75 10 80       	push   $0x80107556
801068fb:	e8 48 9a ff ff       	call   80100348 <panic>

80106900 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106909:	e8 41 ff ff ff       	call   8010684f <setupkvm>
8010690e:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106911:	85 c0                	test   %eax,%eax
80106913:	0f 84 c4 00 00 00    	je     801069dd <copyuvm+0xdd>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106919:	bf 00 00 00 00       	mov    $0x0,%edi
8010691e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106921:	0f 83 b6 00 00 00    	jae    801069dd <copyuvm+0xdd>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106927:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010692a:	b9 00 00 00 00       	mov    $0x0,%ecx
8010692f:	89 fa                	mov    %edi,%edx
80106931:	8b 45 08             	mov    0x8(%ebp),%eax
80106934:	e8 c5 f8 ff ff       	call   801061fe <walkpgdir>
80106939:	85 c0                	test   %eax,%eax
8010693b:	74 65                	je     801069a2 <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
8010693d:	8b 00                	mov    (%eax),%eax
8010693f:	a8 01                	test   $0x1,%al
80106941:	74 6c                	je     801069af <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106943:	89 c6                	mov    %eax,%esi
80106945:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
8010694b:	25 ff 0f 00 00       	and    $0xfff,%eax
80106950:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80106953:	e8 86 b7 ff ff       	call   801020de <kalloc>
80106958:	89 c3                	mov    %eax,%ebx
8010695a:	85 c0                	test   %eax,%eax
8010695c:	74 6a                	je     801069c8 <copyuvm+0xc8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010695e:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106964:	83 ec 04             	sub    $0x4,%esp
80106967:	68 00 10 00 00       	push   $0x1000
8010696c:	56                   	push   %esi
8010696d:	50                   	push   %eax
8010696e:	e8 f8 d8 ff ff       	call   8010426b <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106973:	83 c4 08             	add    $0x8,%esp
80106976:	ff 75 e0             	pushl  -0x20(%ebp)
80106979:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010697f:	50                   	push   %eax
80106980:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106985:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106988:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010698b:	e8 de f8 ff ff       	call   8010626e <mappages>
80106990:	83 c4 10             	add    $0x10,%esp
80106993:	85 c0                	test   %eax,%eax
80106995:	78 25                	js     801069bc <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
80106997:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010699d:	e9 7c ff ff ff       	jmp    8010691e <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
801069a2:	83 ec 0c             	sub    $0xc,%esp
801069a5:	68 60 75 10 80       	push   $0x80107560
801069aa:	e8 99 99 ff ff       	call   80100348 <panic>
      panic("copyuvm: page not present");
801069af:	83 ec 0c             	sub    $0xc,%esp
801069b2:	68 7a 75 10 80       	push   $0x8010757a
801069b7:	e8 8c 99 ff ff       	call   80100348 <panic>
      kfree(mem);
801069bc:	83 ec 0c             	sub    $0xc,%esp
801069bf:	53                   	push   %ebx
801069c0:	e8 02 b6 ff ff       	call   80101fc7 <kfree>
      goto bad;
801069c5:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
801069c8:	83 ec 0c             	sub    $0xc,%esp
801069cb:	ff 75 dc             	pushl  -0x24(%ebp)
801069ce:	e8 0c fe ff ff       	call   801067df <freevm>
  return 0;
801069d3:	83 c4 10             	add    $0x10,%esp
801069d6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
801069dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801069e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069e3:	5b                   	pop    %ebx
801069e4:	5e                   	pop    %esi
801069e5:	5f                   	pop    %edi
801069e6:	5d                   	pop    %ebp
801069e7:	c3                   	ret    

801069e8 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801069e8:	55                   	push   %ebp
801069e9:	89 e5                	mov    %esp,%ebp
801069eb:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801069ee:	b9 00 00 00 00       	mov    $0x0,%ecx
801069f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801069f6:	8b 45 08             	mov    0x8(%ebp),%eax
801069f9:	e8 00 f8 ff ff       	call   801061fe <walkpgdir>
  if((*pte & PTE_P) == 0)
801069fe:	8b 00                	mov    (%eax),%eax
80106a00:	a8 01                	test   $0x1,%al
80106a02:	74 10                	je     80106a14 <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
80106a04:	a8 04                	test   $0x4,%al
80106a06:	74 13                	je     80106a1b <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106a08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a0d:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106a12:	c9                   	leave  
80106a13:	c3                   	ret    
    return 0;
80106a14:	b8 00 00 00 00       	mov    $0x0,%eax
80106a19:	eb f7                	jmp    80106a12 <uva2ka+0x2a>
    return 0;
80106a1b:	b8 00 00 00 00       	mov    $0x0,%eax
80106a20:	eb f0                	jmp    80106a12 <uva2ka+0x2a>

80106a22 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106a22:	55                   	push   %ebp
80106a23:	89 e5                	mov    %esp,%ebp
80106a25:	57                   	push   %edi
80106a26:	56                   	push   %esi
80106a27:	53                   	push   %ebx
80106a28:	83 ec 0c             	sub    $0xc,%esp
80106a2b:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106a2e:	eb 25                	jmp    80106a55 <copyout+0x33>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106a30:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a33:	29 f2                	sub    %esi,%edx
80106a35:	01 d0                	add    %edx,%eax
80106a37:	83 ec 04             	sub    $0x4,%esp
80106a3a:	53                   	push   %ebx
80106a3b:	ff 75 10             	pushl  0x10(%ebp)
80106a3e:	50                   	push   %eax
80106a3f:	e8 27 d8 ff ff       	call   8010426b <memmove>
    len -= n;
80106a44:	29 df                	sub    %ebx,%edi
    buf += n;
80106a46:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106a49:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106a4f:	89 45 0c             	mov    %eax,0xc(%ebp)
80106a52:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106a55:	85 ff                	test   %edi,%edi
80106a57:	74 2f                	je     80106a88 <copyout+0x66>
    va0 = (uint)PGROUNDDOWN(va);
80106a59:	8b 75 0c             	mov    0xc(%ebp),%esi
80106a5c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106a62:	83 ec 08             	sub    $0x8,%esp
80106a65:	56                   	push   %esi
80106a66:	ff 75 08             	pushl  0x8(%ebp)
80106a69:	e8 7a ff ff ff       	call   801069e8 <uva2ka>
    if(pa0 == 0)
80106a6e:	83 c4 10             	add    $0x10,%esp
80106a71:	85 c0                	test   %eax,%eax
80106a73:	74 20                	je     80106a95 <copyout+0x73>
    n = PGSIZE - (va - va0);
80106a75:	89 f3                	mov    %esi,%ebx
80106a77:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106a7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106a80:	39 df                	cmp    %ebx,%edi
80106a82:	73 ac                	jae    80106a30 <copyout+0xe>
      n = len;
80106a84:	89 fb                	mov    %edi,%ebx
80106a86:	eb a8                	jmp    80106a30 <copyout+0xe>
  }
  return 0;
80106a88:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a90:	5b                   	pop    %ebx
80106a91:	5e                   	pop    %esi
80106a92:	5f                   	pop    %edi
80106a93:	5d                   	pop    %ebp
80106a94:	c3                   	ret    
      return -1;
80106a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9a:	eb f1                	jmp    80106a8d <copyout+0x6b>
