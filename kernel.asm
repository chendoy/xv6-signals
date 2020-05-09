
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
8010002d:	b8 00 2f 10 80       	mov    $0x80102f00,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 75 10 80       	push   $0x80107520
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 35 47 00 00       	call   80104790 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 75 10 80       	push   $0x80107527
80100097:	50                   	push   %eax
80100098:	e8 c3 45 00 00       	call   80104660 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 e7 47 00 00       	call   801048d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 29 48 00 00       	call   80104990 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 45 00 00       	call   801046a0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 fd 1f 00 00       	call   80102180 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 75 10 80       	push   $0x8010752e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 8d 45 00 00       	call   80104740 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 b7 1f 00 00       	jmp    80102180 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 75 10 80       	push   $0x8010753f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 4c 45 00 00       	call   80104740 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 44 00 00       	call   80104700 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 c0 46 00 00       	call   801048d0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 2f 47 00 00       	jmp    80104990 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 75 10 80       	push   $0x80107546
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 3b 15 00 00       	call   801017c0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 3f 46 00 00       	call   801048d0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 d6 3c 00 00       	call   80103fa0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 c0 35 00 00       	call   801038a0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 9c 46 00 00       	call   80104990 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 e4 13 00 00       	call   801016e0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 3e 46 00 00       	call   80104990 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 86 13 00 00       	call   801016e0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 e2 23 00 00       	call   80102790 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 75 10 80       	push   $0x8010754d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 63 7f 10 80 	movl   $0x80107f63,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 d3 43 00 00       	call   801047b0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 75 10 80       	push   $0x80107561
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 f1 5c 00 00       	call   80106130 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 3f 5c 00 00       	call   80106130 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 5c 00 00       	call   80106130 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 5c 00 00       	call   80106130 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 67 45 00 00       	call   80104a90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 9a 44 00 00       	call   801049e0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 75 10 80       	push   $0x80107565
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 75 10 80 	movzbl -0x7fef8a70(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 ac 11 00 00       	call   801017c0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 b0 42 00 00       	call   801048d0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 44 43 00 00       	call   80104990 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 8b 10 00 00       	call   801016e0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 6c 42 00 00       	call   80104990 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 78 75 10 80       	mov    $0x80107578,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 db 40 00 00       	call   801048d0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 75 10 80       	push   $0x8010757f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 a8 40 00 00       	call   801048d0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 03 41 00 00       	call   80104990 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 85 38 00 00       	call   801041a0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 f4 38 00 00       	jmp    80104290 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 88 75 10 80       	push   $0x80107588
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 bb 3d 00 00       	call   80104790 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 32 19 00 00       	call   80102330 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:

void default_sighandlers (struct proc* currproc);

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 7f 2e 00 00       	call   801038a0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 d4 21 00 00       	call   80102c00 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 09 15 00 00       	call   80101f40 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 93 0c 00 00       	call   801016e0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 62 0f 00 00       	call   801019c0 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 01 0f 00 00       	call   80101970 <iunlockput>
    end_op();
80100a6f:	e8 fc 21 00 00       	call   80102c70 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 e7 67 00 00       	call   80107280 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 bb 02 00 00    	je     80100d7a <exec+0x36a>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 a5 65 00 00       	call   801070a0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 b3 64 00 00       	call   80106fe0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 63 0e 00 00       	call   801019c0 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 89 66 00 00       	call   80107200 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 d6 0d 00 00       	call   80101970 <iunlockput>
  end_op();
80100b9a:	e8 d1 20 00 00       	call   80102c70 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 f1 64 00 00       	call   801070a0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 3a 66 00 00       	call   80107200 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 98 20 00 00       	call   80102c70 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 a1 75 10 80       	push   $0x801075a1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 15 67 00 00       	call   80107320 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 c2 3f 00 00       	call   80104c00 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 af 3f 00 00       	call   80104c00 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 1e 68 00 00       	call   80107480 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 b4 67 00 00       	call   80107480 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	8d 47 6c             	lea    0x6c(%edi),%eax
80100d07:	50                   	push   %eax
80100d08:	e8 b3 3e 00 00       	call   80104bc0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d13:	89 fa                	mov    %edi,%edx
80100d15:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d18:	8b 42 18             	mov    0x18(%edx),%eax
  curproc->sz = sz;
80100d1b:	89 32                	mov    %esi,(%edx)
80100d1d:	83 c4 10             	add    $0x10,%esp
  curproc->pgdir = pgdir;
80100d20:	89 4a 04             	mov    %ecx,0x4(%edx)
  curproc->tf->eip = elf.entry;  // main
80100d23:	89 d1                	mov    %edx,%ecx
80100d25:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d2b:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2e:	8b 41 18             	mov    0x18(%ecx),%eax
80100d31:	89 ca                	mov    %ecx,%edx
80100d33:	81 c2 04 01 00 00    	add    $0x104,%edx
80100d39:	89 58 44             	mov    %ebx,0x44(%eax)


void
default_sighandlers (struct proc* currproc) {
  int i;
  void** sig_handlers = (void**) &currproc->sig_handlers;
80100d3c:	89 c8                	mov    %ecx,%eax
80100d3e:	05 84 00 00 00       	add    $0x84,%eax
80100d43:	90                   	nop
80100d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i < SIG_HANDLERS_NUM; i++)
  {
    if(sig_handlers[i] != SIG_DFL && sig_handlers[i] != SIG_IGN)
80100d48:	83 38 01             	cmpl   $0x1,(%eax)
80100d4b:	76 06                	jbe    80100d53 <exec+0x343>
      sig_handlers[i] = SIG_DFL;
80100d4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80100d53:	83 c0 04             	add    $0x4,%eax
  for (i = 0; i < SIG_HANDLERS_NUM; i++)
80100d56:	39 c2                	cmp    %eax,%edx
80100d58:	75 ee                	jne    80100d48 <exec+0x338>
  switchuvm(curproc);
80100d5a:	83 ec 0c             	sub    $0xc,%esp
80100d5d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d63:	e8 e8 60 00 00       	call   80106e50 <switchuvm>
  freevm(oldpgdir);
80100d68:	89 3c 24             	mov    %edi,(%esp)
80100d6b:	e8 90 64 00 00       	call   80107200 <freevm>
  return 0;
80100d70:	83 c4 10             	add    $0x10,%esp
80100d73:	31 c0                	xor    %eax,%eax
80100d75:	e9 02 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d7a:	be 00 20 00 00       	mov    $0x2000,%esi
80100d7f:	e9 0d fe ff ff       	jmp    80100b91 <exec+0x181>
80100d84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100d8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100d90 <default_sighandlers>:
default_sighandlers (struct proc* currproc) {
80100d90:	55                   	push   %ebp
80100d91:	89 e5                	mov    %esp,%ebp
80100d93:	8b 55 08             	mov    0x8(%ebp),%edx
  void** sig_handlers = (void**) &currproc->sig_handlers;
80100d96:	8d 82 84 00 00 00    	lea    0x84(%edx),%eax
80100d9c:	81 c2 04 01 00 00    	add    $0x104,%edx
80100da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(sig_handlers[i] != SIG_DFL && sig_handlers[i] != SIG_IGN)
80100da8:	83 38 01             	cmpl   $0x1,(%eax)
80100dab:	76 06                	jbe    80100db3 <default_sighandlers+0x23>
      sig_handlers[i] = SIG_DFL;
80100dad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80100db3:	83 c0 04             	add    $0x4,%eax
  for (i = 0; i < SIG_HANDLERS_NUM; i++)
80100db6:	39 d0                	cmp    %edx,%eax
80100db8:	75 ee                	jne    80100da8 <default_sighandlers+0x18>
  }
80100dba:	5d                   	pop    %ebp
80100dbb:	c3                   	ret    
80100dbc:	66 90                	xchg   %ax,%ax
80100dbe:	66 90                	xchg   %ax,%ax

80100dc0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dc6:	68 ad 75 10 80       	push   $0x801075ad
80100dcb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dd0:	e8 bb 39 00 00       	call   80104790 <initlock>
}
80100dd5:	83 c4 10             	add    $0x10,%esp
80100dd8:	c9                   	leave  
80100dd9:	c3                   	ret    
80100dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100de0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100de4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100de9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dec:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df1:	e8 da 3a 00 00       	call   801048d0 <acquire>
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	eb 10                	jmp    80100e0b <filealloc+0x2b>
80100dfb:	90                   	nop
80100dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e00:	83 c3 18             	add    $0x18,%ebx
80100e03:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e09:	73 25                	jae    80100e30 <filealloc+0x50>
    if(f->ref == 0){
80100e0b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e0e:	85 c0                	test   %eax,%eax
80100e10:	75 ee                	jne    80100e00 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e12:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e15:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e1c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e21:	e8 6a 3b 00 00       	call   80104990 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e26:	89 d8                	mov    %ebx,%eax
      return f;
80100e28:	83 c4 10             	add    $0x10,%esp
}
80100e2b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e2e:	c9                   	leave  
80100e2f:	c3                   	ret    
  release(&ftable.lock);
80100e30:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e33:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e35:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e3a:	e8 51 3b 00 00       	call   80104990 <release>
}
80100e3f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e41:	83 c4 10             	add    $0x10,%esp
}
80100e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e47:	c9                   	leave  
80100e48:	c3                   	ret    
80100e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e50 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
80100e54:	83 ec 10             	sub    $0x10,%esp
80100e57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e5a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5f:	e8 6c 3a 00 00       	call   801048d0 <acquire>
  if(f->ref < 1)
80100e64:	8b 43 04             	mov    0x4(%ebx),%eax
80100e67:	83 c4 10             	add    $0x10,%esp
80100e6a:	85 c0                	test   %eax,%eax
80100e6c:	7e 1a                	jle    80100e88 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e6e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e71:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e74:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e77:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e7c:	e8 0f 3b 00 00       	call   80104990 <release>
  return f;
}
80100e81:	89 d8                	mov    %ebx,%eax
80100e83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e86:	c9                   	leave  
80100e87:	c3                   	ret    
    panic("filedup");
80100e88:	83 ec 0c             	sub    $0xc,%esp
80100e8b:	68 b4 75 10 80       	push   $0x801075b4
80100e90:	e8 fb f4 ff ff       	call   80100390 <panic>
80100e95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ea0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	57                   	push   %edi
80100ea4:	56                   	push   %esi
80100ea5:	53                   	push   %ebx
80100ea6:	83 ec 28             	sub    $0x28,%esp
80100ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100eac:	68 c0 ff 10 80       	push   $0x8010ffc0
80100eb1:	e8 1a 3a 00 00       	call   801048d0 <acquire>
  if(f->ref < 1)
80100eb6:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb9:	83 c4 10             	add    $0x10,%esp
80100ebc:	85 c0                	test   %eax,%eax
80100ebe:	0f 8e 9b 00 00 00    	jle    80100f5f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ec4:	83 e8 01             	sub    $0x1,%eax
80100ec7:	85 c0                	test   %eax,%eax
80100ec9:	89 43 04             	mov    %eax,0x4(%ebx)
80100ecc:	74 1a                	je     80100ee8 <fileclose+0x48>
    release(&ftable.lock);
80100ece:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ed5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ed8:	5b                   	pop    %ebx
80100ed9:	5e                   	pop    %esi
80100eda:	5f                   	pop    %edi
80100edb:	5d                   	pop    %ebp
    release(&ftable.lock);
80100edc:	e9 af 3a 00 00       	jmp    80104990 <release>
80100ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ee8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100eec:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100eee:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ef4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100efa:	88 45 e7             	mov    %al,-0x19(%ebp)
80100efd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f00:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f05:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f08:	e8 83 3a 00 00       	call   80104990 <release>
  if(ff.type == FD_PIPE)
80100f0d:	83 c4 10             	add    $0x10,%esp
80100f10:	83 ff 01             	cmp    $0x1,%edi
80100f13:	74 13                	je     80100f28 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f15:	83 ff 02             	cmp    $0x2,%edi
80100f18:	74 26                	je     80100f40 <fileclose+0xa0>
}
80100f1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f1d:	5b                   	pop    %ebx
80100f1e:	5e                   	pop    %esi
80100f1f:	5f                   	pop    %edi
80100f20:	5d                   	pop    %ebp
80100f21:	c3                   	ret    
80100f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f28:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f2c:	83 ec 08             	sub    $0x8,%esp
80100f2f:	53                   	push   %ebx
80100f30:	56                   	push   %esi
80100f31:	e8 7a 24 00 00       	call   801033b0 <pipeclose>
80100f36:	83 c4 10             	add    $0x10,%esp
80100f39:	eb df                	jmp    80100f1a <fileclose+0x7a>
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f40:	e8 bb 1c 00 00       	call   80102c00 <begin_op>
    iput(ff.ip);
80100f45:	83 ec 0c             	sub    $0xc,%esp
80100f48:	ff 75 e0             	pushl  -0x20(%ebp)
80100f4b:	e8 c0 08 00 00       	call   80101810 <iput>
    end_op();
80100f50:	83 c4 10             	add    $0x10,%esp
}
80100f53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f56:	5b                   	pop    %ebx
80100f57:	5e                   	pop    %esi
80100f58:	5f                   	pop    %edi
80100f59:	5d                   	pop    %ebp
    end_op();
80100f5a:	e9 11 1d 00 00       	jmp    80102c70 <end_op>
    panic("fileclose");
80100f5f:	83 ec 0c             	sub    $0xc,%esp
80100f62:	68 bc 75 10 80       	push   $0x801075bc
80100f67:	e8 24 f4 ff ff       	call   80100390 <panic>
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f70 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	53                   	push   %ebx
80100f74:	83 ec 04             	sub    $0x4,%esp
80100f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f7a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f7d:	75 31                	jne    80100fb0 <filestat+0x40>
    ilock(f->ip);
80100f7f:	83 ec 0c             	sub    $0xc,%esp
80100f82:	ff 73 10             	pushl  0x10(%ebx)
80100f85:	e8 56 07 00 00       	call   801016e0 <ilock>
    stati(f->ip, st);
80100f8a:	58                   	pop    %eax
80100f8b:	5a                   	pop    %edx
80100f8c:	ff 75 0c             	pushl  0xc(%ebp)
80100f8f:	ff 73 10             	pushl  0x10(%ebx)
80100f92:	e8 f9 09 00 00       	call   80101990 <stati>
    iunlock(f->ip);
80100f97:	59                   	pop    %ecx
80100f98:	ff 73 10             	pushl  0x10(%ebx)
80100f9b:	e8 20 08 00 00       	call   801017c0 <iunlock>
    return 0;
80100fa0:	83 c4 10             	add    $0x10,%esp
80100fa3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fa8:	c9                   	leave  
80100fa9:	c3                   	ret    
80100faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fb5:	eb ee                	jmp    80100fa5 <filestat+0x35>
80100fb7:	89 f6                	mov    %esi,%esi
80100fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fc0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	57                   	push   %edi
80100fc4:	56                   	push   %esi
80100fc5:	53                   	push   %ebx
80100fc6:	83 ec 0c             	sub    $0xc,%esp
80100fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fcc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fcf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fd2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fd6:	74 60                	je     80101038 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fd8:	8b 03                	mov    (%ebx),%eax
80100fda:	83 f8 01             	cmp    $0x1,%eax
80100fdd:	74 41                	je     80101020 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fdf:	83 f8 02             	cmp    $0x2,%eax
80100fe2:	75 5b                	jne    8010103f <fileread+0x7f>
    ilock(f->ip);
80100fe4:	83 ec 0c             	sub    $0xc,%esp
80100fe7:	ff 73 10             	pushl  0x10(%ebx)
80100fea:	e8 f1 06 00 00       	call   801016e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fef:	57                   	push   %edi
80100ff0:	ff 73 14             	pushl  0x14(%ebx)
80100ff3:	56                   	push   %esi
80100ff4:	ff 73 10             	pushl  0x10(%ebx)
80100ff7:	e8 c4 09 00 00       	call   801019c0 <readi>
80100ffc:	83 c4 20             	add    $0x20,%esp
80100fff:	85 c0                	test   %eax,%eax
80101001:	89 c6                	mov    %eax,%esi
80101003:	7e 03                	jle    80101008 <fileread+0x48>
      f->off += r;
80101005:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101008:	83 ec 0c             	sub    $0xc,%esp
8010100b:	ff 73 10             	pushl  0x10(%ebx)
8010100e:	e8 ad 07 00 00       	call   801017c0 <iunlock>
    return r;
80101013:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101016:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101019:	89 f0                	mov    %esi,%eax
8010101b:	5b                   	pop    %ebx
8010101c:	5e                   	pop    %esi
8010101d:	5f                   	pop    %edi
8010101e:	5d                   	pop    %ebp
8010101f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101020:	8b 43 0c             	mov    0xc(%ebx),%eax
80101023:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101026:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101029:	5b                   	pop    %ebx
8010102a:	5e                   	pop    %esi
8010102b:	5f                   	pop    %edi
8010102c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010102d:	e9 2e 25 00 00       	jmp    80103560 <piperead>
80101032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101038:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010103d:	eb d7                	jmp    80101016 <fileread+0x56>
  panic("fileread");
8010103f:	83 ec 0c             	sub    $0xc,%esp
80101042:	68 c6 75 10 80       	push   $0x801075c6
80101047:	e8 44 f3 ff ff       	call   80100390 <panic>
8010104c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101050 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101050:	55                   	push   %ebp
80101051:	89 e5                	mov    %esp,%ebp
80101053:	57                   	push   %edi
80101054:	56                   	push   %esi
80101055:	53                   	push   %ebx
80101056:	83 ec 1c             	sub    $0x1c,%esp
80101059:	8b 75 08             	mov    0x8(%ebp),%esi
8010105c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010105f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101063:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101066:	8b 45 10             	mov    0x10(%ebp),%eax
80101069:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010106c:	0f 84 aa 00 00 00    	je     8010111c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101072:	8b 06                	mov    (%esi),%eax
80101074:	83 f8 01             	cmp    $0x1,%eax
80101077:	0f 84 c3 00 00 00    	je     80101140 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010107d:	83 f8 02             	cmp    $0x2,%eax
80101080:	0f 85 d9 00 00 00    	jne    8010115f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101089:	31 ff                	xor    %edi,%edi
    while(i < n){
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 34                	jg     801010c3 <filewrite+0x73>
8010108f:	e9 9c 00 00 00       	jmp    80101130 <filewrite+0xe0>
80101094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101098:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010109b:	83 ec 0c             	sub    $0xc,%esp
8010109e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010a4:	e8 17 07 00 00       	call   801017c0 <iunlock>
      end_op();
801010a9:	e8 c2 1b 00 00       	call   80102c70 <end_op>
801010ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801010b4:	39 c3                	cmp    %eax,%ebx
801010b6:	0f 85 96 00 00 00    	jne    80101152 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801010bc:	01 df                	add    %ebx,%edi
    while(i < n){
801010be:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010c1:	7e 6d                	jle    80101130 <filewrite+0xe0>
      int n1 = n - i;
801010c3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010c6:	b8 00 06 00 00       	mov    $0x600,%eax
801010cb:	29 fb                	sub    %edi,%ebx
801010cd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010d3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010d6:	e8 25 1b 00 00       	call   80102c00 <begin_op>
      ilock(f->ip);
801010db:	83 ec 0c             	sub    $0xc,%esp
801010de:	ff 76 10             	pushl  0x10(%esi)
801010e1:	e8 fa 05 00 00       	call   801016e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010e9:	53                   	push   %ebx
801010ea:	ff 76 14             	pushl  0x14(%esi)
801010ed:	01 f8                	add    %edi,%eax
801010ef:	50                   	push   %eax
801010f0:	ff 76 10             	pushl  0x10(%esi)
801010f3:	e8 c8 09 00 00       	call   80101ac0 <writei>
801010f8:	83 c4 20             	add    $0x20,%esp
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 99                	jg     80101098 <filewrite+0x48>
      iunlock(f->ip);
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	ff 76 10             	pushl  0x10(%esi)
80101105:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101108:	e8 b3 06 00 00       	call   801017c0 <iunlock>
      end_op();
8010110d:	e8 5e 1b 00 00       	call   80102c70 <end_op>
      if(r < 0)
80101112:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101115:	83 c4 10             	add    $0x10,%esp
80101118:	85 c0                	test   %eax,%eax
8010111a:	74 98                	je     801010b4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010111c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010111f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101124:	89 f8                	mov    %edi,%eax
80101126:	5b                   	pop    %ebx
80101127:	5e                   	pop    %esi
80101128:	5f                   	pop    %edi
80101129:	5d                   	pop    %ebp
8010112a:	c3                   	ret    
8010112b:	90                   	nop
8010112c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101130:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101133:	75 e7                	jne    8010111c <filewrite+0xcc>
}
80101135:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101138:	89 f8                	mov    %edi,%eax
8010113a:	5b                   	pop    %ebx
8010113b:	5e                   	pop    %esi
8010113c:	5f                   	pop    %edi
8010113d:	5d                   	pop    %ebp
8010113e:	c3                   	ret    
8010113f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101140:	8b 46 0c             	mov    0xc(%esi),%eax
80101143:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101149:	5b                   	pop    %ebx
8010114a:	5e                   	pop    %esi
8010114b:	5f                   	pop    %edi
8010114c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010114d:	e9 fe 22 00 00       	jmp    80103450 <pipewrite>
        panic("short filewrite");
80101152:	83 ec 0c             	sub    $0xc,%esp
80101155:	68 cf 75 10 80       	push   $0x801075cf
8010115a:	e8 31 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	68 d5 75 10 80       	push   $0x801075d5
80101167:	e8 24 f2 ff ff       	call   80100390 <panic>
8010116c:	66 90                	xchg   %ax,%ax
8010116e:	66 90                	xchg   %ax,%ax

80101170 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101170:	55                   	push   %ebp
80101171:	89 e5                	mov    %esp,%ebp
80101173:	56                   	push   %esi
80101174:	53                   	push   %ebx
80101175:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101177:	c1 ea 0c             	shr    $0xc,%edx
8010117a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101180:	83 ec 08             	sub    $0x8,%esp
80101183:	52                   	push   %edx
80101184:	50                   	push   %eax
80101185:	e8 46 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010118a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010118c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010118f:	ba 01 00 00 00       	mov    $0x1,%edx
80101194:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101197:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010119d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011a0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011a2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011a7:	85 d1                	test   %edx,%ecx
801011a9:	74 25                	je     801011d0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ab:	f7 d2                	not    %edx
801011ad:	89 c6                	mov    %eax,%esi
  log_write(bp);
801011af:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801011b2:	21 ca                	and    %ecx,%edx
801011b4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801011b8:	56                   	push   %esi
801011b9:	e8 12 1c 00 00       	call   80102dd0 <log_write>
  brelse(bp);
801011be:	89 34 24             	mov    %esi,(%esp)
801011c1:	e8 1a f0 ff ff       	call   801001e0 <brelse>
}
801011c6:	83 c4 10             	add    $0x10,%esp
801011c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801011cc:	5b                   	pop    %ebx
801011cd:	5e                   	pop    %esi
801011ce:	5d                   	pop    %ebp
801011cf:	c3                   	ret    
    panic("freeing free block");
801011d0:	83 ec 0c             	sub    $0xc,%esp
801011d3:	68 df 75 10 80       	push   $0x801075df
801011d8:	e8 b3 f1 ff ff       	call   80100390 <panic>
801011dd:	8d 76 00             	lea    0x0(%esi),%esi

801011e0 <balloc>:
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
801011ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 87 00 00 00    	je     80101281 <balloc+0xa1>
801011fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101201:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101204:	83 ec 08             	sub    $0x8,%esp
80101207:	89 f0                	mov    %esi,%eax
80101209:	c1 f8 0c             	sar    $0xc,%eax
8010120c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101212:	50                   	push   %eax
80101213:	ff 75 d8             	pushl  -0x28(%ebp)
80101216:	e8 b5 ee ff ff       	call   801000d0 <bread>
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101223:	83 c4 10             	add    $0x10,%esp
80101226:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101229:	31 c0                	xor    %eax,%eax
8010122b:	eb 2f                	jmp    8010125c <balloc+0x7c>
8010122d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101235:	bb 01 00 00 00       	mov    $0x1,%ebx
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101249:	85 df                	test   %ebx,%edi
8010124b:	89 fa                	mov    %edi,%edx
8010124d:	74 41                	je     80101290 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 05                	je     80101261 <balloc+0x81>
8010125c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010125f:	77 cf                	ja     80101230 <balloc+0x50>
    brelse(bp);
80101261:	83 ec 0c             	sub    $0xc,%esp
80101264:	ff 75 e4             	pushl  -0x1c(%ebp)
80101267:	e8 74 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101273:	83 c4 10             	add    $0x10,%esp
80101276:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101279:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010127f:	77 80                	ja     80101201 <balloc+0x21>
  panic("balloc: out of blocks");
80101281:	83 ec 0c             	sub    $0xc,%esp
80101284:	68 f2 75 10 80       	push   $0x801075f2
80101289:	e8 02 f1 ff ff       	call   80100390 <panic>
8010128e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101290:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101293:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101296:	09 da                	or     %ebx,%edx
80101298:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010129c:	57                   	push   %edi
8010129d:	e8 2e 1b 00 00       	call   80102dd0 <log_write>
        brelse(bp);
801012a2:	89 3c 24             	mov    %edi,(%esp)
801012a5:	e8 36 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801012aa:	58                   	pop    %eax
801012ab:	5a                   	pop    %edx
801012ac:	56                   	push   %esi
801012ad:	ff 75 d8             	pushl  -0x28(%ebp)
801012b0:	e8 1b ee ff ff       	call   801000d0 <bread>
801012b5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801012ba:	83 c4 0c             	add    $0xc,%esp
801012bd:	68 00 02 00 00       	push   $0x200
801012c2:	6a 00                	push   $0x0
801012c4:	50                   	push   %eax
801012c5:	e8 16 37 00 00       	call   801049e0 <memset>
  log_write(bp);
801012ca:	89 1c 24             	mov    %ebx,(%esp)
801012cd:	e8 fe 1a 00 00       	call   80102dd0 <log_write>
  brelse(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 06 ef ff ff       	call   801001e0 <brelse>
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	89 f0                	mov    %esi,%eax
801012df:	5b                   	pop    %ebx
801012e0:	5e                   	pop    %esi
801012e1:	5f                   	pop    %edi
801012e2:	5d                   	pop    %ebp
801012e3:	c3                   	ret    
801012e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 e0 09 11 80       	push   $0x801109e0
8010130a:	e8 c1 35 00 00       	call   801048d0 <acquire>
8010130f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101312:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101315:	eb 17                	jmp    8010132e <iget+0x3e>
80101317:	89 f6                	mov    %esi,%esi
80101319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101320:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101326:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010132c:	73 22                	jae    80101350 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010132e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101331:	85 c9                	test   %ecx,%ecx
80101333:	7e 04                	jle    80101339 <iget+0x49>
80101335:	39 3b                	cmp    %edi,(%ebx)
80101337:	74 4f                	je     80101388 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 f6                	test   %esi,%esi
8010133b:	75 e3                	jne    80101320 <iget+0x30>
8010133d:	85 c9                	test   %ecx,%ecx
8010133f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101342:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101348:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010134e:	72 de                	jb     8010132e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101350:	85 f6                	test   %esi,%esi
80101352:	74 5b                	je     801013af <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101354:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101357:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101359:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010135c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101363:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010136a:	68 e0 09 11 80       	push   $0x801109e0
8010136f:	e8 1c 36 00 00       	call   80104990 <release>

  return ip;
80101374:	83 c4 10             	add    $0x10,%esp
}
80101377:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137a:	89 f0                	mov    %esi,%eax
8010137c:	5b                   	pop    %ebx
8010137d:	5e                   	pop    %esi
8010137e:	5f                   	pop    %edi
8010137f:	5d                   	pop    %ebp
80101380:	c3                   	ret    
80101381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101388:	39 53 04             	cmp    %edx,0x4(%ebx)
8010138b:	75 ac                	jne    80101339 <iget+0x49>
      release(&icache.lock);
8010138d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101390:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101393:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101395:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
8010139a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010139d:	e8 ee 35 00 00       	call   80104990 <release>
      return ip;
801013a2:	83 c4 10             	add    $0x10,%esp
}
801013a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a8:	89 f0                	mov    %esi,%eax
801013aa:	5b                   	pop    %ebx
801013ab:	5e                   	pop    %esi
801013ac:	5f                   	pop    %edi
801013ad:	5d                   	pop    %ebp
801013ae:	c3                   	ret    
    panic("iget: no inodes");
801013af:	83 ec 0c             	sub    $0xc,%esp
801013b2:	68 08 76 10 80       	push   $0x80107608
801013b7:	e8 d4 ef ff ff       	call   80100390 <panic>
801013bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	56                   	push   %esi
801013c5:	53                   	push   %ebx
801013c6:	89 c6                	mov    %eax,%esi
801013c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013cb:	83 fa 0b             	cmp    $0xb,%edx
801013ce:	77 18                	ja     801013e8 <bmap+0x28>
801013d0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013d3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013d6:	85 db                	test   %ebx,%ebx
801013d8:	74 76                	je     80101450 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013dd:	89 d8                	mov    %ebx,%eax
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5f                   	pop    %edi
801013e2:	5d                   	pop    %ebp
801013e3:	c3                   	ret    
801013e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013e8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013eb:	83 fb 7f             	cmp    $0x7f,%ebx
801013ee:	0f 87 90 00 00 00    	ja     80101484 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013f4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013fa:	8b 00                	mov    (%eax),%eax
801013fc:	85 d2                	test   %edx,%edx
801013fe:	74 70                	je     80101470 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101400:	83 ec 08             	sub    $0x8,%esp
80101403:	52                   	push   %edx
80101404:	50                   	push   %eax
80101405:	e8 c6 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010140a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010140e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101411:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101413:	8b 1a                	mov    (%edx),%ebx
80101415:	85 db                	test   %ebx,%ebx
80101417:	75 1d                	jne    80101436 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101419:	8b 06                	mov    (%esi),%eax
8010141b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010141e:	e8 bd fd ff ff       	call   801011e0 <balloc>
80101423:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101426:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101429:	89 c3                	mov    %eax,%ebx
8010142b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010142d:	57                   	push   %edi
8010142e:	e8 9d 19 00 00       	call   80102dd0 <log_write>
80101433:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101436:	83 ec 0c             	sub    $0xc,%esp
80101439:	57                   	push   %edi
8010143a:	e8 a1 ed ff ff       	call   801001e0 <brelse>
8010143f:	83 c4 10             	add    $0x10,%esp
}
80101442:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101445:	89 d8                	mov    %ebx,%eax
80101447:	5b                   	pop    %ebx
80101448:	5e                   	pop    %esi
80101449:	5f                   	pop    %edi
8010144a:	5d                   	pop    %ebp
8010144b:	c3                   	ret    
8010144c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101450:	8b 00                	mov    (%eax),%eax
80101452:	e8 89 fd ff ff       	call   801011e0 <balloc>
80101457:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010145a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010145d:	89 c3                	mov    %eax,%ebx
}
8010145f:	89 d8                	mov    %ebx,%eax
80101461:	5b                   	pop    %ebx
80101462:	5e                   	pop    %esi
80101463:	5f                   	pop    %edi
80101464:	5d                   	pop    %ebp
80101465:	c3                   	ret    
80101466:	8d 76 00             	lea    0x0(%esi),%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101470:	e8 6b fd ff ff       	call   801011e0 <balloc>
80101475:	89 c2                	mov    %eax,%edx
80101477:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010147d:	8b 06                	mov    (%esi),%eax
8010147f:	e9 7c ff ff ff       	jmp    80101400 <bmap+0x40>
  panic("bmap: out of range");
80101484:	83 ec 0c             	sub    $0xc,%esp
80101487:	68 18 76 10 80       	push   $0x80107618
8010148c:	e8 ff ee ff ff       	call   80100390 <panic>
80101491:	eb 0d                	jmp    801014a0 <readsb>
80101493:	90                   	nop
80101494:	90                   	nop
80101495:	90                   	nop
80101496:	90                   	nop
80101497:	90                   	nop
80101498:	90                   	nop
80101499:	90                   	nop
8010149a:	90                   	nop
8010149b:	90                   	nop
8010149c:	90                   	nop
8010149d:	90                   	nop
8010149e:	90                   	nop
8010149f:	90                   	nop

801014a0 <readsb>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	56                   	push   %esi
801014a4:	53                   	push   %ebx
801014a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014a8:	83 ec 08             	sub    $0x8,%esp
801014ab:	6a 01                	push   $0x1
801014ad:	ff 75 08             	pushl  0x8(%ebp)
801014b0:	e8 1b ec ff ff       	call   801000d0 <bread>
801014b5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801014b7:	8d 40 5c             	lea    0x5c(%eax),%eax
801014ba:	83 c4 0c             	add    $0xc,%esp
801014bd:	6a 1c                	push   $0x1c
801014bf:	50                   	push   %eax
801014c0:	56                   	push   %esi
801014c1:	e8 ca 35 00 00       	call   80104a90 <memmove>
  brelse(bp);
801014c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014c9:	83 c4 10             	add    $0x10,%esp
}
801014cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014cf:	5b                   	pop    %ebx
801014d0:	5e                   	pop    %esi
801014d1:	5d                   	pop    %ebp
  brelse(bp);
801014d2:	e9 09 ed ff ff       	jmp    801001e0 <brelse>
801014d7:	89 f6                	mov    %esi,%esi
801014d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014e0 <iinit>:
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	53                   	push   %ebx
801014e4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014e9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014ec:	68 2b 76 10 80       	push   $0x8010762b
801014f1:	68 e0 09 11 80       	push   $0x801109e0
801014f6:	e8 95 32 00 00       	call   80104790 <initlock>
801014fb:	83 c4 10             	add    $0x10,%esp
801014fe:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101500:	83 ec 08             	sub    $0x8,%esp
80101503:	68 32 76 10 80       	push   $0x80107632
80101508:	53                   	push   %ebx
80101509:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010150f:	e8 4c 31 00 00       	call   80104660 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101514:	83 c4 10             	add    $0x10,%esp
80101517:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010151d:	75 e1                	jne    80101500 <iinit+0x20>
  readsb(dev, &sb);
8010151f:	83 ec 08             	sub    $0x8,%esp
80101522:	68 c0 09 11 80       	push   $0x801109c0
80101527:	ff 75 08             	pushl  0x8(%ebp)
8010152a:	e8 71 ff ff ff       	call   801014a0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010152f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101535:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010153b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101541:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101547:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010154d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101553:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101559:	68 98 76 10 80       	push   $0x80107698
8010155e:	e8 fd f0 ff ff       	call   80100660 <cprintf>
}
80101563:	83 c4 30             	add    $0x30,%esp
80101566:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101569:	c9                   	leave  
8010156a:	c3                   	ret    
8010156b:	90                   	nop
8010156c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101570 <ialloc>:
{
80101570:	55                   	push   %ebp
80101571:	89 e5                	mov    %esp,%ebp
80101573:	57                   	push   %edi
80101574:	56                   	push   %esi
80101575:	53                   	push   %ebx
80101576:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101579:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101580:	8b 45 0c             	mov    0xc(%ebp),%eax
80101583:	8b 75 08             	mov    0x8(%ebp),%esi
80101586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101589:	0f 86 91 00 00 00    	jbe    80101620 <ialloc+0xb0>
8010158f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101594:	eb 21                	jmp    801015b7 <ialloc+0x47>
80101596:	8d 76 00             	lea    0x0(%esi),%esi
80101599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801015a0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015a3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015a6:	57                   	push   %edi
801015a7:	e8 34 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015ac:	83 c4 10             	add    $0x10,%esp
801015af:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801015b5:	76 69                	jbe    80101620 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015b7:	89 d8                	mov    %ebx,%eax
801015b9:	83 ec 08             	sub    $0x8,%esp
801015bc:	c1 e8 03             	shr    $0x3,%eax
801015bf:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015c5:	50                   	push   %eax
801015c6:	56                   	push   %esi
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
801015cc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015ce:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015d0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015d3:	83 e0 07             	and    $0x7,%eax
801015d6:	c1 e0 06             	shl    $0x6,%eax
801015d9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015dd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015e1:	75 bd                	jne    801015a0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015e3:	83 ec 04             	sub    $0x4,%esp
801015e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015e9:	6a 40                	push   $0x40
801015eb:	6a 00                	push   $0x0
801015ed:	51                   	push   %ecx
801015ee:	e8 ed 33 00 00       	call   801049e0 <memset>
      dip->type = type;
801015f3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015f7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015fa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015fd:	89 3c 24             	mov    %edi,(%esp)
80101600:	e8 cb 17 00 00       	call   80102dd0 <log_write>
      brelse(bp);
80101605:	89 3c 24             	mov    %edi,(%esp)
80101608:	e8 d3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010160d:	83 c4 10             	add    $0x10,%esp
}
80101610:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101613:	89 da                	mov    %ebx,%edx
80101615:	89 f0                	mov    %esi,%eax
}
80101617:	5b                   	pop    %ebx
80101618:	5e                   	pop    %esi
80101619:	5f                   	pop    %edi
8010161a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010161b:	e9 d0 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
80101620:	83 ec 0c             	sub    $0xc,%esp
80101623:	68 38 76 10 80       	push   $0x80107638
80101628:	e8 63 ed ff ff       	call   80100390 <panic>
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <iupdate>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101638:	83 ec 08             	sub    $0x8,%esp
8010163b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101641:	c1 e8 03             	shr    $0x3,%eax
80101644:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010164a:	50                   	push   %eax
8010164b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010164e:	e8 7d ea ff ff       	call   801000d0 <bread>
80101653:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101655:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101658:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010165f:	83 e0 07             	and    $0x7,%eax
80101662:	c1 e0 06             	shl    $0x6,%eax
80101665:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101669:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010166c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101670:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101673:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101677:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010167b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010167f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101683:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101687:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010168a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010168d:	6a 34                	push   $0x34
8010168f:	53                   	push   %ebx
80101690:	50                   	push   %eax
80101691:	e8 fa 33 00 00       	call   80104a90 <memmove>
  log_write(bp);
80101696:	89 34 24             	mov    %esi,(%esp)
80101699:	e8 32 17 00 00       	call   80102dd0 <log_write>
  brelse(bp);
8010169e:	89 75 08             	mov    %esi,0x8(%ebp)
801016a1:	83 c4 10             	add    $0x10,%esp
}
801016a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a7:	5b                   	pop    %ebx
801016a8:	5e                   	pop    %esi
801016a9:	5d                   	pop    %ebp
  brelse(bp);
801016aa:	e9 31 eb ff ff       	jmp    801001e0 <brelse>
801016af:	90                   	nop

801016b0 <idup>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	53                   	push   %ebx
801016b4:	83 ec 10             	sub    $0x10,%esp
801016b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ba:	68 e0 09 11 80       	push   $0x801109e0
801016bf:	e8 0c 32 00 00       	call   801048d0 <acquire>
  ip->ref++;
801016c4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016c8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016cf:	e8 bc 32 00 00       	call   80104990 <release>
}
801016d4:	89 d8                	mov    %ebx,%eax
801016d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016d9:	c9                   	leave  
801016da:	c3                   	ret    
801016db:	90                   	nop
801016dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016e0 <ilock>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016e8:	85 db                	test   %ebx,%ebx
801016ea:	0f 84 b7 00 00 00    	je     801017a7 <ilock+0xc7>
801016f0:	8b 53 08             	mov    0x8(%ebx),%edx
801016f3:	85 d2                	test   %edx,%edx
801016f5:	0f 8e ac 00 00 00    	jle    801017a7 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016fb:	8d 43 0c             	lea    0xc(%ebx),%eax
801016fe:	83 ec 0c             	sub    $0xc,%esp
80101701:	50                   	push   %eax
80101702:	e8 99 2f 00 00       	call   801046a0 <acquiresleep>
  if(ip->valid == 0){
80101707:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010170a:	83 c4 10             	add    $0x10,%esp
8010170d:	85 c0                	test   %eax,%eax
8010170f:	74 0f                	je     80101720 <ilock+0x40>
}
80101711:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101714:	5b                   	pop    %ebx
80101715:	5e                   	pop    %esi
80101716:	5d                   	pop    %ebp
80101717:	c3                   	ret    
80101718:	90                   	nop
80101719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101720:	8b 43 04             	mov    0x4(%ebx),%eax
80101723:	83 ec 08             	sub    $0x8,%esp
80101726:	c1 e8 03             	shr    $0x3,%eax
80101729:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010172f:	50                   	push   %eax
80101730:	ff 33                	pushl  (%ebx)
80101732:	e8 99 e9 ff ff       	call   801000d0 <bread>
80101737:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101739:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010173c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010173f:	83 e0 07             	and    $0x7,%eax
80101742:	c1 e0 06             	shl    $0x6,%eax
80101745:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101749:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010174c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010174f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101753:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101757:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010175b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010175f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101763:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101767:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010176b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010176e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101771:	6a 34                	push   $0x34
80101773:	50                   	push   %eax
80101774:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101777:	50                   	push   %eax
80101778:	e8 13 33 00 00       	call   80104a90 <memmove>
    brelse(bp);
8010177d:	89 34 24             	mov    %esi,(%esp)
80101780:	e8 5b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101785:	83 c4 10             	add    $0x10,%esp
80101788:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010178d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101794:	0f 85 77 ff ff ff    	jne    80101711 <ilock+0x31>
      panic("ilock: no type");
8010179a:	83 ec 0c             	sub    $0xc,%esp
8010179d:	68 50 76 10 80       	push   $0x80107650
801017a2:	e8 e9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017a7:	83 ec 0c             	sub    $0xc,%esp
801017aa:	68 4a 76 10 80       	push   $0x8010764a
801017af:	e8 dc eb ff ff       	call   80100390 <panic>
801017b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017c0 <iunlock>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017c8:	85 db                	test   %ebx,%ebx
801017ca:	74 28                	je     801017f4 <iunlock+0x34>
801017cc:	8d 73 0c             	lea    0xc(%ebx),%esi
801017cf:	83 ec 0c             	sub    $0xc,%esp
801017d2:	56                   	push   %esi
801017d3:	e8 68 2f 00 00       	call   80104740 <holdingsleep>
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 c0                	test   %eax,%eax
801017dd:	74 15                	je     801017f4 <iunlock+0x34>
801017df:	8b 43 08             	mov    0x8(%ebx),%eax
801017e2:	85 c0                	test   %eax,%eax
801017e4:	7e 0e                	jle    801017f4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017e6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017ec:	5b                   	pop    %ebx
801017ed:	5e                   	pop    %esi
801017ee:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ef:	e9 0c 2f 00 00       	jmp    80104700 <releasesleep>
    panic("iunlock");
801017f4:	83 ec 0c             	sub    $0xc,%esp
801017f7:	68 5f 76 10 80       	push   $0x8010765f
801017fc:	e8 8f eb ff ff       	call   80100390 <panic>
80101801:	eb 0d                	jmp    80101810 <iput>
80101803:	90                   	nop
80101804:	90                   	nop
80101805:	90                   	nop
80101806:	90                   	nop
80101807:	90                   	nop
80101808:	90                   	nop
80101809:	90                   	nop
8010180a:	90                   	nop
8010180b:	90                   	nop
8010180c:	90                   	nop
8010180d:	90                   	nop
8010180e:	90                   	nop
8010180f:	90                   	nop

80101810 <iput>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	57                   	push   %edi
80101814:	56                   	push   %esi
80101815:	53                   	push   %ebx
80101816:	83 ec 28             	sub    $0x28,%esp
80101819:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010181c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010181f:	57                   	push   %edi
80101820:	e8 7b 2e 00 00       	call   801046a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101825:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101828:	83 c4 10             	add    $0x10,%esp
8010182b:	85 d2                	test   %edx,%edx
8010182d:	74 07                	je     80101836 <iput+0x26>
8010182f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101834:	74 32                	je     80101868 <iput+0x58>
  releasesleep(&ip->lock);
80101836:	83 ec 0c             	sub    $0xc,%esp
80101839:	57                   	push   %edi
8010183a:	e8 c1 2e 00 00       	call   80104700 <releasesleep>
  acquire(&icache.lock);
8010183f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101846:	e8 85 30 00 00       	call   801048d0 <acquire>
  ip->ref--;
8010184b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010184f:	83 c4 10             	add    $0x10,%esp
80101852:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010185c:	5b                   	pop    %ebx
8010185d:	5e                   	pop    %esi
8010185e:	5f                   	pop    %edi
8010185f:	5d                   	pop    %ebp
  release(&icache.lock);
80101860:	e9 2b 31 00 00       	jmp    80104990 <release>
80101865:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101868:	83 ec 0c             	sub    $0xc,%esp
8010186b:	68 e0 09 11 80       	push   $0x801109e0
80101870:	e8 5b 30 00 00       	call   801048d0 <acquire>
    int r = ip->ref;
80101875:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101878:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010187f:	e8 0c 31 00 00       	call   80104990 <release>
    if(r == 1){
80101884:	83 c4 10             	add    $0x10,%esp
80101887:	83 fe 01             	cmp    $0x1,%esi
8010188a:	75 aa                	jne    80101836 <iput+0x26>
8010188c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101892:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101895:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101898:	89 cf                	mov    %ecx,%edi
8010189a:	eb 0b                	jmp    801018a7 <iput+0x97>
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018a0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018a3:	39 fe                	cmp    %edi,%esi
801018a5:	74 19                	je     801018c0 <iput+0xb0>
    if(ip->addrs[i]){
801018a7:	8b 16                	mov    (%esi),%edx
801018a9:	85 d2                	test   %edx,%edx
801018ab:	74 f3                	je     801018a0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018ad:	8b 03                	mov    (%ebx),%eax
801018af:	e8 bc f8 ff ff       	call   80101170 <bfree>
      ip->addrs[i] = 0;
801018b4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018ba:	eb e4                	jmp    801018a0 <iput+0x90>
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018c0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018c9:	85 c0                	test   %eax,%eax
801018cb:	75 33                	jne    80101900 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018cd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018d0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018d7:	53                   	push   %ebx
801018d8:	e8 53 fd ff ff       	call   80101630 <iupdate>
      ip->type = 0;
801018dd:	31 c0                	xor    %eax,%eax
801018df:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018e3:	89 1c 24             	mov    %ebx,(%esp)
801018e6:	e8 45 fd ff ff       	call   80101630 <iupdate>
      ip->valid = 0;
801018eb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018f2:	83 c4 10             	add    $0x10,%esp
801018f5:	e9 3c ff ff ff       	jmp    80101836 <iput+0x26>
801018fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101900:	83 ec 08             	sub    $0x8,%esp
80101903:	50                   	push   %eax
80101904:	ff 33                	pushl  (%ebx)
80101906:	e8 c5 e7 ff ff       	call   801000d0 <bread>
8010190b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101911:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101914:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101917:	8d 70 5c             	lea    0x5c(%eax),%esi
8010191a:	83 c4 10             	add    $0x10,%esp
8010191d:	89 cf                	mov    %ecx,%edi
8010191f:	eb 0e                	jmp    8010192f <iput+0x11f>
80101921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101928:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 0f                	je     8010193e <iput+0x12e>
      if(a[j])
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x118>
        bfree(ip->dev, a[j]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 34 f8 ff ff       	call   80101170 <bfree>
8010193c:	eb ea                	jmp    80101928 <iput+0x118>
    brelse(bp);
8010193e:	83 ec 0c             	sub    $0xc,%esp
80101941:	ff 75 e4             	pushl  -0x1c(%ebp)
80101944:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101947:	e8 94 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010194c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101952:	8b 03                	mov    (%ebx),%eax
80101954:	e8 17 f8 ff ff       	call   80101170 <bfree>
    ip->addrs[NDIRECT] = 0;
80101959:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101960:	00 00 00 
80101963:	83 c4 10             	add    $0x10,%esp
80101966:	e9 62 ff ff ff       	jmp    801018cd <iput+0xbd>
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <iunlockput>:
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	53                   	push   %ebx
80101974:	83 ec 10             	sub    $0x10,%esp
80101977:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010197a:	53                   	push   %ebx
8010197b:	e8 40 fe ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101980:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101983:	83 c4 10             	add    $0x10,%esp
}
80101986:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101989:	c9                   	leave  
  iput(ip);
8010198a:	e9 81 fe ff ff       	jmp    80101810 <iput>
8010198f:	90                   	nop

80101990 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	8b 55 08             	mov    0x8(%ebp),%edx
80101996:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101999:	8b 0a                	mov    (%edx),%ecx
8010199b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010199e:	8b 4a 04             	mov    0x4(%edx),%ecx
801019a1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019a4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019a8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019ab:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019af:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019b3:	8b 52 58             	mov    0x58(%edx),%edx
801019b6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019b9:	5d                   	pop    %ebp
801019ba:	c3                   	ret    
801019bb:	90                   	nop
801019bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019c0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	57                   	push   %edi
801019c4:	56                   	push   %esi
801019c5:	53                   	push   %ebx
801019c6:	83 ec 1c             	sub    $0x1c,%esp
801019c9:	8b 45 08             	mov    0x8(%ebp),%eax
801019cc:	8b 75 0c             	mov    0xc(%ebp),%esi
801019cf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019d2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019d7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019da:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019dd:	8b 75 10             	mov    0x10(%ebp),%esi
801019e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019e3:	0f 84 a7 00 00 00    	je     80101a90 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019ec:	8b 40 58             	mov    0x58(%eax),%eax
801019ef:	39 c6                	cmp    %eax,%esi
801019f1:	0f 87 ba 00 00 00    	ja     80101ab1 <readi+0xf1>
801019f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019fa:	89 f9                	mov    %edi,%ecx
801019fc:	01 f1                	add    %esi,%ecx
801019fe:	0f 82 ad 00 00 00    	jb     80101ab1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a04:	89 c2                	mov    %eax,%edx
80101a06:	29 f2                	sub    %esi,%edx
80101a08:	39 c8                	cmp    %ecx,%eax
80101a0a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a0d:	31 ff                	xor    %edi,%edi
80101a0f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a11:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a14:	74 6c                	je     80101a82 <readi+0xc2>
80101a16:	8d 76 00             	lea    0x0(%esi),%esi
80101a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a20:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a23:	89 f2                	mov    %esi,%edx
80101a25:	c1 ea 09             	shr    $0x9,%edx
80101a28:	89 d8                	mov    %ebx,%eax
80101a2a:	e8 91 f9 ff ff       	call   801013c0 <bmap>
80101a2f:	83 ec 08             	sub    $0x8,%esp
80101a32:	50                   	push   %eax
80101a33:	ff 33                	pushl  (%ebx)
80101a35:	e8 96 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a3d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a3f:	89 f0                	mov    %esi,%eax
80101a41:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a46:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a4b:	83 c4 0c             	add    $0xc,%esp
80101a4e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a50:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a54:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a57:	29 fb                	sub    %edi,%ebx
80101a59:	39 d9                	cmp    %ebx,%ecx
80101a5b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a5e:	53                   	push   %ebx
80101a5f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a60:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a62:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a65:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a67:	e8 24 30 00 00       	call   80104a90 <memmove>
    brelse(bp);
80101a6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a6f:	89 14 24             	mov    %edx,(%esp)
80101a72:	e8 69 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a77:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a7a:	83 c4 10             	add    $0x10,%esp
80101a7d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a80:	77 9e                	ja     80101a20 <readi+0x60>
  }
  return n;
80101a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a88:	5b                   	pop    %ebx
80101a89:	5e                   	pop    %esi
80101a8a:	5f                   	pop    %edi
80101a8b:	5d                   	pop    %ebp
80101a8c:	c3                   	ret    
80101a8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a94:	66 83 f8 09          	cmp    $0x9,%ax
80101a98:	77 17                	ja     80101ab1 <readi+0xf1>
80101a9a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101aa1:	85 c0                	test   %eax,%eax
80101aa3:	74 0c                	je     80101ab1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101aa5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101aa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aab:	5b                   	pop    %ebx
80101aac:	5e                   	pop    %esi
80101aad:	5f                   	pop    %edi
80101aae:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101aaf:	ff e0                	jmp    *%eax
      return -1;
80101ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ab6:	eb cd                	jmp    80101a85 <readi+0xc5>
80101ab8:	90                   	nop
80101ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ac0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	57                   	push   %edi
80101ac4:	56                   	push   %esi
80101ac5:	53                   	push   %ebx
80101ac6:	83 ec 1c             	sub    $0x1c,%esp
80101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80101acc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101acf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ad2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ad7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101ada:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101add:	8b 75 10             	mov    0x10(%ebp),%esi
80101ae0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ae3:	0f 84 b7 00 00 00    	je     80101ba0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ae9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aec:	39 70 58             	cmp    %esi,0x58(%eax)
80101aef:	0f 82 eb 00 00 00    	jb     80101be0 <writei+0x120>
80101af5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101af8:	31 d2                	xor    %edx,%edx
80101afa:	89 f8                	mov    %edi,%eax
80101afc:	01 f0                	add    %esi,%eax
80101afe:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b01:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b06:	0f 87 d4 00 00 00    	ja     80101be0 <writei+0x120>
80101b0c:	85 d2                	test   %edx,%edx
80101b0e:	0f 85 cc 00 00 00    	jne    80101be0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b14:	85 ff                	test   %edi,%edi
80101b16:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b1d:	74 72                	je     80101b91 <writei+0xd1>
80101b1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b20:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b23:	89 f2                	mov    %esi,%edx
80101b25:	c1 ea 09             	shr    $0x9,%edx
80101b28:	89 f8                	mov    %edi,%eax
80101b2a:	e8 91 f8 ff ff       	call   801013c0 <bmap>
80101b2f:	83 ec 08             	sub    $0x8,%esp
80101b32:	50                   	push   %eax
80101b33:	ff 37                	pushl  (%edi)
80101b35:	e8 96 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b3a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b3d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b40:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b42:	89 f0                	mov    %esi,%eax
80101b44:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b49:	83 c4 0c             	add    $0xc,%esp
80101b4c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b51:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b53:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b57:	39 d9                	cmp    %ebx,%ecx
80101b59:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b5c:	53                   	push   %ebx
80101b5d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b60:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b62:	50                   	push   %eax
80101b63:	e8 28 2f 00 00       	call   80104a90 <memmove>
    log_write(bp);
80101b68:	89 3c 24             	mov    %edi,(%esp)
80101b6b:	e8 60 12 00 00       	call   80102dd0 <log_write>
    brelse(bp);
80101b70:	89 3c 24             	mov    %edi,(%esp)
80101b73:	e8 68 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b78:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b7b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b7e:	83 c4 10             	add    $0x10,%esp
80101b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b84:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b87:	77 97                	ja     80101b20 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b8c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b8f:	77 37                	ja     80101bc8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b91:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b97:	5b                   	pop    %ebx
80101b98:	5e                   	pop    %esi
80101b99:	5f                   	pop    %edi
80101b9a:	5d                   	pop    %ebp
80101b9b:	c3                   	ret    
80101b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ba0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ba4:	66 83 f8 09          	cmp    $0x9,%ax
80101ba8:	77 36                	ja     80101be0 <writei+0x120>
80101baa:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bb1:	85 c0                	test   %eax,%eax
80101bb3:	74 2b                	je     80101be0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101bb5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bbb:	5b                   	pop    %ebx
80101bbc:	5e                   	pop    %esi
80101bbd:	5f                   	pop    %edi
80101bbe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bbf:	ff e0                	jmp    *%eax
80101bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101bc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bcb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bce:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bd1:	50                   	push   %eax
80101bd2:	e8 59 fa ff ff       	call   80101630 <iupdate>
80101bd7:	83 c4 10             	add    $0x10,%esp
80101bda:	eb b5                	jmp    80101b91 <writei+0xd1>
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101be5:	eb ad                	jmp    80101b94 <writei+0xd4>
80101be7:	89 f6                	mov    %esi,%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bf6:	6a 0e                	push   $0xe
80101bf8:	ff 75 0c             	pushl  0xc(%ebp)
80101bfb:	ff 75 08             	pushl  0x8(%ebp)
80101bfe:	e8 fd 2e 00 00       	call   80104b00 <strncmp>
}
80101c03:	c9                   	leave  
80101c04:	c3                   	ret    
80101c05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	83 ec 1c             	sub    $0x1c,%esp
80101c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c1c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c21:	0f 85 85 00 00 00    	jne    80101cac <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c27:	8b 53 58             	mov    0x58(%ebx),%edx
80101c2a:	31 ff                	xor    %edi,%edi
80101c2c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c2f:	85 d2                	test   %edx,%edx
80101c31:	74 3e                	je     80101c71 <dirlookup+0x61>
80101c33:	90                   	nop
80101c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c38:	6a 10                	push   $0x10
80101c3a:	57                   	push   %edi
80101c3b:	56                   	push   %esi
80101c3c:	53                   	push   %ebx
80101c3d:	e8 7e fd ff ff       	call   801019c0 <readi>
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	83 f8 10             	cmp    $0x10,%eax
80101c48:	75 55                	jne    80101c9f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c4f:	74 18                	je     80101c69 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c54:	83 ec 04             	sub    $0x4,%esp
80101c57:	6a 0e                	push   $0xe
80101c59:	50                   	push   %eax
80101c5a:	ff 75 0c             	pushl  0xc(%ebp)
80101c5d:	e8 9e 2e 00 00       	call   80104b00 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c62:	83 c4 10             	add    $0x10,%esp
80101c65:	85 c0                	test   %eax,%eax
80101c67:	74 17                	je     80101c80 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c69:	83 c7 10             	add    $0x10,%edi
80101c6c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c6f:	72 c7                	jb     80101c38 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c71:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c74:	31 c0                	xor    %eax,%eax
}
80101c76:	5b                   	pop    %ebx
80101c77:	5e                   	pop    %esi
80101c78:	5f                   	pop    %edi
80101c79:	5d                   	pop    %ebp
80101c7a:	c3                   	ret    
80101c7b:	90                   	nop
80101c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c80:	8b 45 10             	mov    0x10(%ebp),%eax
80101c83:	85 c0                	test   %eax,%eax
80101c85:	74 05                	je     80101c8c <dirlookup+0x7c>
        *poff = off;
80101c87:	8b 45 10             	mov    0x10(%ebp),%eax
80101c8a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c8c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c90:	8b 03                	mov    (%ebx),%eax
80101c92:	e8 59 f6 ff ff       	call   801012f0 <iget>
}
80101c97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9a:	5b                   	pop    %ebx
80101c9b:	5e                   	pop    %esi
80101c9c:	5f                   	pop    %edi
80101c9d:	5d                   	pop    %ebp
80101c9e:	c3                   	ret    
      panic("dirlookup read");
80101c9f:	83 ec 0c             	sub    $0xc,%esp
80101ca2:	68 79 76 10 80       	push   $0x80107679
80101ca7:	e8 e4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cac:	83 ec 0c             	sub    $0xc,%esp
80101caf:	68 67 76 10 80       	push   $0x80107667
80101cb4:	e8 d7 e6 ff ff       	call   80100390 <panic>
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	57                   	push   %edi
80101cc4:	56                   	push   %esi
80101cc5:	53                   	push   %ebx
80101cc6:	89 cf                	mov    %ecx,%edi
80101cc8:	89 c3                	mov    %eax,%ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ccd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cd0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cd3:	0f 84 67 01 00 00    	je     80101e40 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cd9:	e8 c2 1b 00 00       	call   801038a0 <myproc>
  acquire(&icache.lock);
80101cde:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ce1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ce4:	68 e0 09 11 80       	push   $0x801109e0
80101ce9:	e8 e2 2b 00 00       	call   801048d0 <acquire>
  ip->ref++;
80101cee:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cf2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cf9:	e8 92 2c 00 00       	call   80104990 <release>
80101cfe:	83 c4 10             	add    $0x10,%esp
80101d01:	eb 08                	jmp    80101d0b <namex+0x4b>
80101d03:	90                   	nop
80101d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d08:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d0b:	0f b6 03             	movzbl (%ebx),%eax
80101d0e:	3c 2f                	cmp    $0x2f,%al
80101d10:	74 f6                	je     80101d08 <namex+0x48>
  if(*path == 0)
80101d12:	84 c0                	test   %al,%al
80101d14:	0f 84 ee 00 00 00    	je     80101e08 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d1a:	0f b6 03             	movzbl (%ebx),%eax
80101d1d:	3c 2f                	cmp    $0x2f,%al
80101d1f:	0f 84 b3 00 00 00    	je     80101dd8 <namex+0x118>
80101d25:	84 c0                	test   %al,%al
80101d27:	89 da                	mov    %ebx,%edx
80101d29:	75 09                	jne    80101d34 <namex+0x74>
80101d2b:	e9 a8 00 00 00       	jmp    80101dd8 <namex+0x118>
80101d30:	84 c0                	test   %al,%al
80101d32:	74 0a                	je     80101d3e <namex+0x7e>
    path++;
80101d34:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d37:	0f b6 02             	movzbl (%edx),%eax
80101d3a:	3c 2f                	cmp    $0x2f,%al
80101d3c:	75 f2                	jne    80101d30 <namex+0x70>
80101d3e:	89 d1                	mov    %edx,%ecx
80101d40:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d42:	83 f9 0d             	cmp    $0xd,%ecx
80101d45:	0f 8e 91 00 00 00    	jle    80101ddc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d4b:	83 ec 04             	sub    $0x4,%esp
80101d4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d51:	6a 0e                	push   $0xe
80101d53:	53                   	push   %ebx
80101d54:	57                   	push   %edi
80101d55:	e8 36 2d 00 00       	call   80104a90 <memmove>
    path++;
80101d5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d5d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d60:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d62:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d65:	75 11                	jne    80101d78 <namex+0xb8>
80101d67:	89 f6                	mov    %esi,%esi
80101d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d70:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d73:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d76:	74 f8                	je     80101d70 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d78:	83 ec 0c             	sub    $0xc,%esp
80101d7b:	56                   	push   %esi
80101d7c:	e8 5f f9 ff ff       	call   801016e0 <ilock>
    if(ip->type != T_DIR){
80101d81:	83 c4 10             	add    $0x10,%esp
80101d84:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d89:	0f 85 91 00 00 00    	jne    80101e20 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d92:	85 d2                	test   %edx,%edx
80101d94:	74 09                	je     80101d9f <namex+0xdf>
80101d96:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d99:	0f 84 b7 00 00 00    	je     80101e56 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d9f:	83 ec 04             	sub    $0x4,%esp
80101da2:	6a 00                	push   $0x0
80101da4:	57                   	push   %edi
80101da5:	56                   	push   %esi
80101da6:	e8 65 fe ff ff       	call   80101c10 <dirlookup>
80101dab:	83 c4 10             	add    $0x10,%esp
80101dae:	85 c0                	test   %eax,%eax
80101db0:	74 6e                	je     80101e20 <namex+0x160>
  iunlock(ip);
80101db2:	83 ec 0c             	sub    $0xc,%esp
80101db5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101db8:	56                   	push   %esi
80101db9:	e8 02 fa ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101dbe:	89 34 24             	mov    %esi,(%esp)
80101dc1:	e8 4a fa ff ff       	call   80101810 <iput>
80101dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dc9:	83 c4 10             	add    $0x10,%esp
80101dcc:	89 c6                	mov    %eax,%esi
80101dce:	e9 38 ff ff ff       	jmp    80101d0b <namex+0x4b>
80101dd3:	90                   	nop
80101dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101dd8:	89 da                	mov    %ebx,%edx
80101dda:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101ddc:	83 ec 04             	sub    $0x4,%esp
80101ddf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101de2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101de5:	51                   	push   %ecx
80101de6:	53                   	push   %ebx
80101de7:	57                   	push   %edi
80101de8:	e8 a3 2c 00 00       	call   80104a90 <memmove>
    name[len] = 0;
80101ded:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101df0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101df3:	83 c4 10             	add    $0x10,%esp
80101df6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dfa:	89 d3                	mov    %edx,%ebx
80101dfc:	e9 61 ff ff ff       	jmp    80101d62 <namex+0xa2>
80101e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e0b:	85 c0                	test   %eax,%eax
80101e0d:	75 5d                	jne    80101e6c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e12:	89 f0                	mov    %esi,%eax
80101e14:	5b                   	pop    %ebx
80101e15:	5e                   	pop    %esi
80101e16:	5f                   	pop    %edi
80101e17:	5d                   	pop    %ebp
80101e18:	c3                   	ret    
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e20:	83 ec 0c             	sub    $0xc,%esp
80101e23:	56                   	push   %esi
80101e24:	e8 97 f9 ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101e29:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e2c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e2e:	e8 dd f9 ff ff       	call   80101810 <iput>
      return 0;
80101e33:	83 c4 10             	add    $0x10,%esp
}
80101e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e39:	89 f0                	mov    %esi,%eax
80101e3b:	5b                   	pop    %ebx
80101e3c:	5e                   	pop    %esi
80101e3d:	5f                   	pop    %edi
80101e3e:	5d                   	pop    %ebp
80101e3f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e40:	ba 01 00 00 00       	mov    $0x1,%edx
80101e45:	b8 01 00 00 00       	mov    $0x1,%eax
80101e4a:	e8 a1 f4 ff ff       	call   801012f0 <iget>
80101e4f:	89 c6                	mov    %eax,%esi
80101e51:	e9 b5 fe ff ff       	jmp    80101d0b <namex+0x4b>
      iunlock(ip);
80101e56:	83 ec 0c             	sub    $0xc,%esp
80101e59:	56                   	push   %esi
80101e5a:	e8 61 f9 ff ff       	call   801017c0 <iunlock>
      return ip;
80101e5f:	83 c4 10             	add    $0x10,%esp
}
80101e62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e65:	89 f0                	mov    %esi,%eax
80101e67:	5b                   	pop    %ebx
80101e68:	5e                   	pop    %esi
80101e69:	5f                   	pop    %edi
80101e6a:	5d                   	pop    %ebp
80101e6b:	c3                   	ret    
    iput(ip);
80101e6c:	83 ec 0c             	sub    $0xc,%esp
80101e6f:	56                   	push   %esi
    return 0;
80101e70:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e72:	e8 99 f9 ff ff       	call   80101810 <iput>
    return 0;
80101e77:	83 c4 10             	add    $0x10,%esp
80101e7a:	eb 93                	jmp    80101e0f <namex+0x14f>
80101e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e80 <dirlink>:
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	83 ec 20             	sub    $0x20,%esp
80101e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e8c:	6a 00                	push   $0x0
80101e8e:	ff 75 0c             	pushl  0xc(%ebp)
80101e91:	53                   	push   %ebx
80101e92:	e8 79 fd ff ff       	call   80101c10 <dirlookup>
80101e97:	83 c4 10             	add    $0x10,%esp
80101e9a:	85 c0                	test   %eax,%eax
80101e9c:	75 67                	jne    80101f05 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e9e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ea1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ea4:	85 ff                	test   %edi,%edi
80101ea6:	74 29                	je     80101ed1 <dirlink+0x51>
80101ea8:	31 ff                	xor    %edi,%edi
80101eaa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ead:	eb 09                	jmp    80101eb8 <dirlink+0x38>
80101eaf:	90                   	nop
80101eb0:	83 c7 10             	add    $0x10,%edi
80101eb3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101eb6:	73 19                	jae    80101ed1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb8:	6a 10                	push   $0x10
80101eba:	57                   	push   %edi
80101ebb:	56                   	push   %esi
80101ebc:	53                   	push   %ebx
80101ebd:	e8 fe fa ff ff       	call   801019c0 <readi>
80101ec2:	83 c4 10             	add    $0x10,%esp
80101ec5:	83 f8 10             	cmp    $0x10,%eax
80101ec8:	75 4e                	jne    80101f18 <dirlink+0x98>
    if(de.inum == 0)
80101eca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ecf:	75 df                	jne    80101eb0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101ed1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ed4:	83 ec 04             	sub    $0x4,%esp
80101ed7:	6a 0e                	push   $0xe
80101ed9:	ff 75 0c             	pushl  0xc(%ebp)
80101edc:	50                   	push   %eax
80101edd:	e8 7e 2c 00 00       	call   80104b60 <strncpy>
  de.inum = inum;
80101ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee5:	6a 10                	push   $0x10
80101ee7:	57                   	push   %edi
80101ee8:	56                   	push   %esi
80101ee9:	53                   	push   %ebx
  de.inum = inum;
80101eea:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eee:	e8 cd fb ff ff       	call   80101ac0 <writei>
80101ef3:	83 c4 20             	add    $0x20,%esp
80101ef6:	83 f8 10             	cmp    $0x10,%eax
80101ef9:	75 2a                	jne    80101f25 <dirlink+0xa5>
  return 0;
80101efb:	31 c0                	xor    %eax,%eax
}
80101efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
    iput(ip);
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	50                   	push   %eax
80101f09:	e8 02 f9 ff ff       	call   80101810 <iput>
    return -1;
80101f0e:	83 c4 10             	add    $0x10,%esp
80101f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f16:	eb e5                	jmp    80101efd <dirlink+0x7d>
      panic("dirlink read");
80101f18:	83 ec 0c             	sub    $0xc,%esp
80101f1b:	68 88 76 10 80       	push   $0x80107688
80101f20:	e8 6b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f25:	83 ec 0c             	sub    $0xc,%esp
80101f28:	68 4a 7d 10 80       	push   $0x80107d4a
80101f2d:	e8 5e e4 ff ff       	call   80100390 <panic>
80101f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <namei>:

struct inode*
namei(char *path)
{
80101f40:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f41:	31 d2                	xor    %edx,%edx
{
80101f43:	89 e5                	mov    %esp,%ebp
80101f45:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f4e:	e8 6d fd ff ff       	call   80101cc0 <namex>
}
80101f53:	c9                   	leave  
80101f54:	c3                   	ret    
80101f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f60 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f60:	55                   	push   %ebp
  return namex(path, 1, name);
80101f61:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f66:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f6e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f6f:	e9 4c fd ff ff       	jmp    80101cc0 <namex>
80101f74:	66 90                	xchg   %ax,%ax
80101f76:	66 90                	xchg   %ax,%ax
80101f78:	66 90                	xchg   %ax,%ax
80101f7a:	66 90                	xchg   %ax,%ax
80101f7c:	66 90                	xchg   %ax,%ax
80101f7e:	66 90                	xchg   %ax,%ax

80101f80 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f80:	55                   	push   %ebp
80101f81:	89 e5                	mov    %esp,%ebp
80101f83:	57                   	push   %edi
80101f84:	56                   	push   %esi
80101f85:	53                   	push   %ebx
80101f86:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f89:	85 c0                	test   %eax,%eax
80101f8b:	0f 84 b4 00 00 00    	je     80102045 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f91:	8b 58 08             	mov    0x8(%eax),%ebx
80101f94:	89 c6                	mov    %eax,%esi
80101f96:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f9c:	0f 87 96 00 00 00    	ja     80102038 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fa2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101fa7:	89 f6                	mov    %esi,%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101fb0:	89 ca                	mov    %ecx,%edx
80101fb2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fb3:	83 e0 c0             	and    $0xffffffc0,%eax
80101fb6:	3c 40                	cmp    $0x40,%al
80101fb8:	75 f6                	jne    80101fb0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fba:	31 ff                	xor    %edi,%edi
80101fbc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fc1:	89 f8                	mov    %edi,%eax
80101fc3:	ee                   	out    %al,(%dx)
80101fc4:	b8 01 00 00 00       	mov    $0x1,%eax
80101fc9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fce:	ee                   	out    %al,(%dx)
80101fcf:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fd4:	89 d8                	mov    %ebx,%eax
80101fd6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fd7:	89 d8                	mov    %ebx,%eax
80101fd9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fde:	c1 f8 08             	sar    $0x8,%eax
80101fe1:	ee                   	out    %al,(%dx)
80101fe2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101fe7:	89 f8                	mov    %edi,%eax
80101fe9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fea:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fee:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ff3:	c1 e0 04             	shl    $0x4,%eax
80101ff6:	83 e0 10             	and    $0x10,%eax
80101ff9:	83 c8 e0             	or     $0xffffffe0,%eax
80101ffc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101ffd:	f6 06 04             	testb  $0x4,(%esi)
80102000:	75 16                	jne    80102018 <idestart+0x98>
80102002:	b8 20 00 00 00       	mov    $0x20,%eax
80102007:	89 ca                	mov    %ecx,%edx
80102009:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010200a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010200d:	5b                   	pop    %ebx
8010200e:	5e                   	pop    %esi
8010200f:	5f                   	pop    %edi
80102010:	5d                   	pop    %ebp
80102011:	c3                   	ret    
80102012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102018:	b8 30 00 00 00       	mov    $0x30,%eax
8010201d:	89 ca                	mov    %ecx,%edx
8010201f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102020:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102025:	83 c6 5c             	add    $0x5c,%esi
80102028:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010202d:	fc                   	cld    
8010202e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102030:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102033:	5b                   	pop    %ebx
80102034:	5e                   	pop    %esi
80102035:	5f                   	pop    %edi
80102036:	5d                   	pop    %ebp
80102037:	c3                   	ret    
    panic("incorrect blockno");
80102038:	83 ec 0c             	sub    $0xc,%esp
8010203b:	68 f4 76 10 80       	push   $0x801076f4
80102040:	e8 4b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	68 eb 76 10 80       	push   $0x801076eb
8010204d:	e8 3e e3 ff ff       	call   80100390 <panic>
80102052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102060 <ideinit>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102066:	68 06 77 10 80       	push   $0x80107706
8010206b:	68 80 a5 10 80       	push   $0x8010a580
80102070:	e8 1b 27 00 00       	call   80104790 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102075:	58                   	pop    %eax
80102076:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010207b:	5a                   	pop    %edx
8010207c:	83 e8 01             	sub    $0x1,%eax
8010207f:	50                   	push   %eax
80102080:	6a 0e                	push   $0xe
80102082:	e8 a9 02 00 00       	call   80102330 <ioapicenable>
80102087:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010208a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010208f:	90                   	nop
80102090:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102091:	83 e0 c0             	and    $0xffffffc0,%eax
80102094:	3c 40                	cmp    $0x40,%al
80102096:	75 f8                	jne    80102090 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102098:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010209d:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020a2:	ee                   	out    %al,(%dx)
801020a3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ad:	eb 06                	jmp    801020b5 <ideinit+0x55>
801020af:	90                   	nop
  for(i=0; i<1000; i++){
801020b0:	83 e9 01             	sub    $0x1,%ecx
801020b3:	74 0f                	je     801020c4 <ideinit+0x64>
801020b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020b6:	84 c0                	test   %al,%al
801020b8:	74 f6                	je     801020b0 <ideinit+0x50>
      havedisk1 = 1;
801020ba:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020ce:	ee                   	out    %al,(%dx)
}
801020cf:	c9                   	leave  
801020d0:	c3                   	ret    
801020d1:	eb 0d                	jmp    801020e0 <ideintr>
801020d3:	90                   	nop
801020d4:	90                   	nop
801020d5:	90                   	nop
801020d6:	90                   	nop
801020d7:	90                   	nop
801020d8:	90                   	nop
801020d9:	90                   	nop
801020da:	90                   	nop
801020db:	90                   	nop
801020dc:	90                   	nop
801020dd:	90                   	nop
801020de:	90                   	nop
801020df:	90                   	nop

801020e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	57                   	push   %edi
801020e4:	56                   	push   %esi
801020e5:	53                   	push   %ebx
801020e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020e9:	68 80 a5 10 80       	push   $0x8010a580
801020ee:	e8 dd 27 00 00       	call   801048d0 <acquire>

  if((b = idequeue) == 0){
801020f3:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020f9:	83 c4 10             	add    $0x10,%esp
801020fc:	85 db                	test   %ebx,%ebx
801020fe:	74 67                	je     80102167 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102100:	8b 43 58             	mov    0x58(%ebx),%eax
80102103:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102108:	8b 3b                	mov    (%ebx),%edi
8010210a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102110:	75 31                	jne    80102143 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102112:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102117:	89 f6                	mov    %esi,%esi
80102119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102120:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102121:	89 c6                	mov    %eax,%esi
80102123:	83 e6 c0             	and    $0xffffffc0,%esi
80102126:	89 f1                	mov    %esi,%ecx
80102128:	80 f9 40             	cmp    $0x40,%cl
8010212b:	75 f3                	jne    80102120 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010212d:	a8 21                	test   $0x21,%al
8010212f:	75 12                	jne    80102143 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102131:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102134:	b9 80 00 00 00       	mov    $0x80,%ecx
80102139:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010213e:	fc                   	cld    
8010213f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102141:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102143:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102146:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102149:	89 f9                	mov    %edi,%ecx
8010214b:	83 c9 02             	or     $0x2,%ecx
8010214e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102150:	53                   	push   %ebx
80102151:	e8 4a 20 00 00       	call   801041a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102156:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010215b:	83 c4 10             	add    $0x10,%esp
8010215e:	85 c0                	test   %eax,%eax
80102160:	74 05                	je     80102167 <ideintr+0x87>
    idestart(idequeue);
80102162:	e8 19 fe ff ff       	call   80101f80 <idestart>
    release(&idelock);
80102167:	83 ec 0c             	sub    $0xc,%esp
8010216a:	68 80 a5 10 80       	push   $0x8010a580
8010216f:	e8 1c 28 00 00       	call   80104990 <release>

  release(&idelock);
}
80102174:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102177:	5b                   	pop    %ebx
80102178:	5e                   	pop    %esi
80102179:	5f                   	pop    %edi
8010217a:	5d                   	pop    %ebp
8010217b:	c3                   	ret    
8010217c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102180 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	53                   	push   %ebx
80102184:	83 ec 10             	sub    $0x10,%esp
80102187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010218a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010218d:	50                   	push   %eax
8010218e:	e8 ad 25 00 00       	call   80104740 <holdingsleep>
80102193:	83 c4 10             	add    $0x10,%esp
80102196:	85 c0                	test   %eax,%eax
80102198:	0f 84 c6 00 00 00    	je     80102264 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010219e:	8b 03                	mov    (%ebx),%eax
801021a0:	83 e0 06             	and    $0x6,%eax
801021a3:	83 f8 02             	cmp    $0x2,%eax
801021a6:	0f 84 ab 00 00 00    	je     80102257 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021ac:	8b 53 04             	mov    0x4(%ebx),%edx
801021af:	85 d2                	test   %edx,%edx
801021b1:	74 0d                	je     801021c0 <iderw+0x40>
801021b3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801021b8:	85 c0                	test   %eax,%eax
801021ba:	0f 84 b1 00 00 00    	je     80102271 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021c0:	83 ec 0c             	sub    $0xc,%esp
801021c3:	68 80 a5 10 80       	push   $0x8010a580
801021c8:	e8 03 27 00 00       	call   801048d0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cd:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801021d3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021dd:	85 d2                	test   %edx,%edx
801021df:	75 09                	jne    801021ea <iderw+0x6a>
801021e1:	eb 6d                	jmp    80102250 <iderw+0xd0>
801021e3:	90                   	nop
801021e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021e8:	89 c2                	mov    %eax,%edx
801021ea:	8b 42 58             	mov    0x58(%edx),%eax
801021ed:	85 c0                	test   %eax,%eax
801021ef:	75 f7                	jne    801021e8 <iderw+0x68>
801021f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801021f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801021f6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021fc:	74 42                	je     80102240 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021fe:	8b 03                	mov    (%ebx),%eax
80102200:	83 e0 06             	and    $0x6,%eax
80102203:	83 f8 02             	cmp    $0x2,%eax
80102206:	74 23                	je     8010222b <iderw+0xab>
80102208:	90                   	nop
80102209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102210:	83 ec 08             	sub    $0x8,%esp
80102213:	68 80 a5 10 80       	push   $0x8010a580
80102218:	53                   	push   %ebx
80102219:	e8 82 1d 00 00       	call   80103fa0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010221e:	8b 03                	mov    (%ebx),%eax
80102220:	83 c4 10             	add    $0x10,%esp
80102223:	83 e0 06             	and    $0x6,%eax
80102226:	83 f8 02             	cmp    $0x2,%eax
80102229:	75 e5                	jne    80102210 <iderw+0x90>
  }


  release(&idelock);
8010222b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102235:	c9                   	leave  
  release(&idelock);
80102236:	e9 55 27 00 00       	jmp    80104990 <release>
8010223b:	90                   	nop
8010223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102240:	89 d8                	mov    %ebx,%eax
80102242:	e8 39 fd ff ff       	call   80101f80 <idestart>
80102247:	eb b5                	jmp    801021fe <iderw+0x7e>
80102249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102250:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102255:	eb 9d                	jmp    801021f4 <iderw+0x74>
    panic("iderw: nothing to do");
80102257:	83 ec 0c             	sub    $0xc,%esp
8010225a:	68 20 77 10 80       	push   $0x80107720
8010225f:	e8 2c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 0a 77 10 80       	push   $0x8010770a
8010226c:	e8 1f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102271:	83 ec 0c             	sub    $0xc,%esp
80102274:	68 35 77 10 80       	push   $0x80107735
80102279:	e8 12 e1 ff ff       	call   80100390 <panic>
8010227e:	66 90                	xchg   %ax,%ax

80102280 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102280:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102281:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102288:	00 c0 fe 
{
8010228b:	89 e5                	mov    %esp,%ebp
8010228d:	56                   	push   %esi
8010228e:	53                   	push   %ebx
  ioapic->reg = reg;
8010228f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102296:	00 00 00 
  return ioapic->data;
80102299:	a1 34 26 11 80       	mov    0x80112634,%eax
8010229e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801022a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801022a7:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022ad:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022b4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801022b7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022ba:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801022bd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022c0:	39 c2                	cmp    %eax,%edx
801022c2:	74 16                	je     801022da <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 54 77 10 80       	push   $0x80107754
801022cc:	e8 8f e3 ff ff       	call   80100660 <cprintf>
801022d1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022d7:	83 c4 10             	add    $0x10,%esp
801022da:	83 c3 21             	add    $0x21,%ebx
{
801022dd:	ba 10 00 00 00       	mov    $0x10,%edx
801022e2:	b8 20 00 00 00       	mov    $0x20,%eax
801022e7:	89 f6                	mov    %esi,%esi
801022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801022f0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801022f2:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022f8:	89 c6                	mov    %eax,%esi
801022fa:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102300:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102303:	89 71 10             	mov    %esi,0x10(%ecx)
80102306:	8d 72 01             	lea    0x1(%edx),%esi
80102309:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010230c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010230e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102310:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102316:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010231d:	75 d1                	jne    801022f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010231f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102322:	5b                   	pop    %ebx
80102323:	5e                   	pop    %esi
80102324:	5d                   	pop    %ebp
80102325:	c3                   	ret    
80102326:	8d 76 00             	lea    0x0(%esi),%esi
80102329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102330 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102330:	55                   	push   %ebp
  ioapic->reg = reg;
80102331:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102337:	89 e5                	mov    %esp,%ebp
80102339:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010233c:	8d 50 20             	lea    0x20(%eax),%edx
8010233f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102343:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102345:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010234b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010234e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102351:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102354:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102356:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010235b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010235e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102361:	5d                   	pop    %ebp
80102362:	c3                   	ret    
80102363:	66 90                	xchg   %ax,%ax
80102365:	66 90                	xchg   %ax,%ax
80102367:	66 90                	xchg   %ax,%ax
80102369:	66 90                	xchg   %ax,%ax
8010236b:	66 90                	xchg   %ax,%ax
8010236d:	66 90                	xchg   %ax,%ax
8010236f:	90                   	nop

80102370 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	53                   	push   %ebx
80102374:	83 ec 04             	sub    $0x4,%esp
80102377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010237a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102380:	75 70                	jne    801023f2 <kfree+0x82>
80102382:	81 fb a8 78 11 80    	cmp    $0x801178a8,%ebx
80102388:	72 68                	jb     801023f2 <kfree+0x82>
8010238a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102390:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102395:	77 5b                	ja     801023f2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102397:	83 ec 04             	sub    $0x4,%esp
8010239a:	68 00 10 00 00       	push   $0x1000
8010239f:	6a 01                	push   $0x1
801023a1:	53                   	push   %ebx
801023a2:	e8 39 26 00 00       	call   801049e0 <memset>

  if(kmem.use_lock)
801023a7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	85 d2                	test   %edx,%edx
801023b2:	75 2c                	jne    801023e0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023b4:	a1 78 26 11 80       	mov    0x80112678,%eax
801023b9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023bb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801023c0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801023c6:	85 c0                	test   %eax,%eax
801023c8:	75 06                	jne    801023d0 <kfree+0x60>
    release(&kmem.lock);
}
801023ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023cd:	c9                   	leave  
801023ce:	c3                   	ret    
801023cf:	90                   	nop
    release(&kmem.lock);
801023d0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801023d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023da:	c9                   	leave  
    release(&kmem.lock);
801023db:	e9 b0 25 00 00       	jmp    80104990 <release>
    acquire(&kmem.lock);
801023e0:	83 ec 0c             	sub    $0xc,%esp
801023e3:	68 40 26 11 80       	push   $0x80112640
801023e8:	e8 e3 24 00 00       	call   801048d0 <acquire>
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	eb c2                	jmp    801023b4 <kfree+0x44>
    panic("kfree");
801023f2:	83 ec 0c             	sub    $0xc,%esp
801023f5:	68 86 77 10 80       	push   $0x80107786
801023fa:	e8 91 df ff ff       	call   80100390 <panic>
801023ff:	90                   	nop

80102400 <freerange>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102405:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102408:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010240b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102411:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102417:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010241d:	39 de                	cmp    %ebx,%esi
8010241f:	72 23                	jb     80102444 <freerange+0x44>
80102421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102428:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010242e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102431:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102437:	50                   	push   %eax
80102438:	e8 33 ff ff ff       	call   80102370 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010243d:	83 c4 10             	add    $0x10,%esp
80102440:	39 f3                	cmp    %esi,%ebx
80102442:	76 e4                	jbe    80102428 <freerange+0x28>
}
80102444:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102447:	5b                   	pop    %ebx
80102448:	5e                   	pop    %esi
80102449:	5d                   	pop    %ebp
8010244a:	c3                   	ret    
8010244b:	90                   	nop
8010244c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102450 <kinit1>:
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
80102455:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102458:	83 ec 08             	sub    $0x8,%esp
8010245b:	68 8c 77 10 80       	push   $0x8010778c
80102460:	68 40 26 11 80       	push   $0x80112640
80102465:	e8 26 23 00 00       	call   80104790 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010246a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102470:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102477:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010247a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102480:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102486:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010248c:	39 de                	cmp    %ebx,%esi
8010248e:	72 1c                	jb     801024ac <kinit1+0x5c>
    kfree(p);
80102490:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102496:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102499:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010249f:	50                   	push   %eax
801024a0:	e8 cb fe ff ff       	call   80102370 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a5:	83 c4 10             	add    $0x10,%esp
801024a8:	39 de                	cmp    %ebx,%esi
801024aa:	73 e4                	jae    80102490 <kinit1+0x40>
}
801024ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024af:	5b                   	pop    %ebx
801024b0:	5e                   	pop    %esi
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024c0 <kinit2>:
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	56                   	push   %esi
801024c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024dd:	39 de                	cmp    %ebx,%esi
801024df:	72 23                	jb     80102504 <kinit2+0x44>
801024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024f7:	50                   	push   %eax
801024f8:	e8 73 fe ff ff       	call   80102370 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	39 de                	cmp    %ebx,%esi
80102502:	73 e4                	jae    801024e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102504:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010250b:	00 00 00 
}
8010250e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102511:	5b                   	pop    %ebx
80102512:	5e                   	pop    %esi
80102513:	5d                   	pop    %ebp
80102514:	c3                   	ret    
80102515:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102520 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102520:	a1 74 26 11 80       	mov    0x80112674,%eax
80102525:	85 c0                	test   %eax,%eax
80102527:	75 1f                	jne    80102548 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102529:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010252e:	85 c0                	test   %eax,%eax
80102530:	74 0e                	je     80102540 <kalloc+0x20>
    kmem.freelist = r->next;
80102532:	8b 10                	mov    (%eax),%edx
80102534:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010253a:	c3                   	ret    
8010253b:	90                   	nop
8010253c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102540:	f3 c3                	repz ret 
80102542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102548:	55                   	push   %ebp
80102549:	89 e5                	mov    %esp,%ebp
8010254b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010254e:	68 40 26 11 80       	push   $0x80112640
80102553:	e8 78 23 00 00       	call   801048d0 <acquire>
  r = kmem.freelist;
80102558:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102566:	85 c0                	test   %eax,%eax
80102568:	74 08                	je     80102572 <kalloc+0x52>
    kmem.freelist = r->next;
8010256a:	8b 08                	mov    (%eax),%ecx
8010256c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102572:	85 d2                	test   %edx,%edx
80102574:	74 16                	je     8010258c <kalloc+0x6c>
    release(&kmem.lock);
80102576:	83 ec 0c             	sub    $0xc,%esp
80102579:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010257c:	68 40 26 11 80       	push   $0x80112640
80102581:	e8 0a 24 00 00       	call   80104990 <release>
  return (char*)r;
80102586:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102589:	83 c4 10             	add    $0x10,%esp
}
8010258c:	c9                   	leave  
8010258d:	c3                   	ret    
8010258e:	66 90                	xchg   %ax,%ax

80102590 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102590:	ba 64 00 00 00       	mov    $0x64,%edx
80102595:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102596:	a8 01                	test   $0x1,%al
80102598:	0f 84 c2 00 00 00    	je     80102660 <kbdgetc+0xd0>
8010259e:	ba 60 00 00 00       	mov    $0x60,%edx
801025a3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025a4:	0f b6 d0             	movzbl %al,%edx
801025a7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801025ad:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801025b3:	0f 84 7f 00 00 00    	je     80102638 <kbdgetc+0xa8>
{
801025b9:	55                   	push   %ebp
801025ba:	89 e5                	mov    %esp,%ebp
801025bc:	53                   	push   %ebx
801025bd:	89 cb                	mov    %ecx,%ebx
801025bf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025c2:	84 c0                	test   %al,%al
801025c4:	78 4a                	js     80102610 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025c6:	85 db                	test   %ebx,%ebx
801025c8:	74 09                	je     801025d3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025ca:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025cd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025d0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025d3:	0f b6 82 c0 78 10 80 	movzbl -0x7fef8740(%edx),%eax
801025da:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025dc:	0f b6 82 c0 77 10 80 	movzbl -0x7fef8840(%edx),%eax
801025e3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025e5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025e7:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025ed:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025f0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025f3:	8b 04 85 a0 77 10 80 	mov    -0x7fef8860(,%eax,4),%eax
801025fa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801025fe:	74 31                	je     80102631 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102600:	8d 50 9f             	lea    -0x61(%eax),%edx
80102603:	83 fa 19             	cmp    $0x19,%edx
80102606:	77 40                	ja     80102648 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102608:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010260b:	5b                   	pop    %ebx
8010260c:	5d                   	pop    %ebp
8010260d:	c3                   	ret    
8010260e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102610:	83 e0 7f             	and    $0x7f,%eax
80102613:	85 db                	test   %ebx,%ebx
80102615:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102618:	0f b6 82 c0 78 10 80 	movzbl -0x7fef8740(%edx),%eax
8010261f:	83 c8 40             	or     $0x40,%eax
80102622:	0f b6 c0             	movzbl %al,%eax
80102625:	f7 d0                	not    %eax
80102627:	21 c1                	and    %eax,%ecx
    return 0;
80102629:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010262b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102631:	5b                   	pop    %ebx
80102632:	5d                   	pop    %ebp
80102633:	c3                   	ret    
80102634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102638:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010263b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010263d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102643:	c3                   	ret    
80102644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102648:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010264b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010264e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010264f:	83 f9 1a             	cmp    $0x1a,%ecx
80102652:	0f 42 c2             	cmovb  %edx,%eax
}
80102655:	5d                   	pop    %ebp
80102656:	c3                   	ret    
80102657:	89 f6                	mov    %esi,%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102660:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102665:	c3                   	ret    
80102666:	8d 76 00             	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <kbdintr>:

void
kbdintr(void)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102676:	68 90 25 10 80       	push   $0x80102590
8010267b:	e8 90 e1 ff ff       	call   80100810 <consoleintr>
}
80102680:	83 c4 10             	add    $0x10,%esp
80102683:	c9                   	leave  
80102684:	c3                   	ret    
80102685:	66 90                	xchg   %ax,%ax
80102687:	66 90                	xchg   %ax,%ax
80102689:	66 90                	xchg   %ax,%ax
8010268b:	66 90                	xchg   %ax,%ax
8010268d:	66 90                	xchg   %ax,%ax
8010268f:	90                   	nop

80102690 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102690:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102695:	55                   	push   %ebp
80102696:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102698:	85 c0                	test   %eax,%eax
8010269a:	0f 84 c8 00 00 00    	je     80102768 <lapicinit+0xd8>
  lapic[index] = value;
801026a0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026a7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ad:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026c1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026ce:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026db:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026ee:	8b 50 30             	mov    0x30(%eax),%edx
801026f1:	c1 ea 10             	shr    $0x10,%edx
801026f4:	80 fa 03             	cmp    $0x3,%dl
801026f7:	77 77                	ja     80102770 <lapicinit+0xe0>
  lapic[index] = value;
801026f9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102700:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102703:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102706:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102710:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102713:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102720:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102727:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010272d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102734:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102737:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102741:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102744:	8b 50 20             	mov    0x20(%eax),%edx
80102747:	89 f6                	mov    %esi,%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102750:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102756:	80 e6 10             	and    $0x10,%dh
80102759:	75 f5                	jne    80102750 <lapicinit+0xc0>
  lapic[index] = value;
8010275b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102762:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102765:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102768:	5d                   	pop    %ebp
80102769:	c3                   	ret    
8010276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102770:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102777:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010277a:	8b 50 20             	mov    0x20(%eax),%edx
8010277d:	e9 77 ff ff ff       	jmp    801026f9 <lapicinit+0x69>
80102782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102790:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102796:	55                   	push   %ebp
80102797:	31 c0                	xor    %eax,%eax
80102799:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010279b:	85 d2                	test   %edx,%edx
8010279d:	74 06                	je     801027a5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010279f:	8b 42 20             	mov    0x20(%edx),%eax
801027a2:	c1 e8 18             	shr    $0x18,%eax
}
801027a5:	5d                   	pop    %ebp
801027a6:	c3                   	ret    
801027a7:	89 f6                	mov    %esi,%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027b5:	55                   	push   %ebp
801027b6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027b8:	85 c0                	test   %eax,%eax
801027ba:	74 0d                	je     801027c9 <lapiceoi+0x19>
  lapic[index] = value;
801027bc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027c3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801027c9:	5d                   	pop    %ebp
801027ca:	c3                   	ret    
801027cb:	90                   	nop
801027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027d0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
}
801027d3:	5d                   	pop    %ebp
801027d4:	c3                   	ret    
801027d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027e6:	ba 70 00 00 00       	mov    $0x70,%edx
801027eb:	89 e5                	mov    %esp,%ebp
801027ed:	53                   	push   %ebx
801027ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027f4:	ee                   	out    %al,(%dx)
801027f5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027fa:	ba 71 00 00 00       	mov    $0x71,%edx
801027ff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102800:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102802:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102805:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010280b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010280d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102810:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102813:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102815:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102818:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010281e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102823:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102829:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010282c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102833:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102836:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102839:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102840:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102843:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102846:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010284c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010284f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102855:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102858:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010285e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102861:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010286a:	5b                   	pop    %ebx
8010286b:	5d                   	pop    %ebp
8010286c:	c3                   	ret    
8010286d:	8d 76 00             	lea    0x0(%esi),%esi

80102870 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102870:	55                   	push   %ebp
80102871:	b8 0b 00 00 00       	mov    $0xb,%eax
80102876:	ba 70 00 00 00       	mov    $0x70,%edx
8010287b:	89 e5                	mov    %esp,%ebp
8010287d:	57                   	push   %edi
8010287e:	56                   	push   %esi
8010287f:	53                   	push   %ebx
80102880:	83 ec 4c             	sub    $0x4c,%esp
80102883:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102884:	ba 71 00 00 00       	mov    $0x71,%edx
80102889:	ec                   	in     (%dx),%al
8010288a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010288d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102892:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102895:	8d 76 00             	lea    0x0(%esi),%esi
80102898:	31 c0                	xor    %eax,%eax
8010289a:	89 da                	mov    %ebx,%edx
8010289c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289d:	b9 71 00 00 00       	mov    $0x71,%ecx
801028a2:	89 ca                	mov    %ecx,%edx
801028a4:	ec                   	in     (%dx),%al
801028a5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a8:	89 da                	mov    %ebx,%edx
801028aa:	b8 02 00 00 00       	mov    $0x2,%eax
801028af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b0:	89 ca                	mov    %ecx,%edx
801028b2:	ec                   	in     (%dx),%al
801028b3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b6:	89 da                	mov    %ebx,%edx
801028b8:	b8 04 00 00 00       	mov    $0x4,%eax
801028bd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028be:	89 ca                	mov    %ecx,%edx
801028c0:	ec                   	in     (%dx),%al
801028c1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c4:	89 da                	mov    %ebx,%edx
801028c6:	b8 07 00 00 00       	mov    $0x7,%eax
801028cb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028cc:	89 ca                	mov    %ecx,%edx
801028ce:	ec                   	in     (%dx),%al
801028cf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d2:	89 da                	mov    %ebx,%edx
801028d4:	b8 08 00 00 00       	mov    $0x8,%eax
801028d9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028da:	89 ca                	mov    %ecx,%edx
801028dc:	ec                   	in     (%dx),%al
801028dd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028df:	89 da                	mov    %ebx,%edx
801028e1:	b8 09 00 00 00       	mov    $0x9,%eax
801028e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028e7:	89 ca                	mov    %ecx,%edx
801028e9:	ec                   	in     (%dx),%al
801028ea:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ec:	89 da                	mov    %ebx,%edx
801028ee:	b8 0a 00 00 00       	mov    $0xa,%eax
801028f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f4:	89 ca                	mov    %ecx,%edx
801028f6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028f7:	84 c0                	test   %al,%al
801028f9:	78 9d                	js     80102898 <cmostime+0x28>
  return inb(CMOS_RETURN);
801028fb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801028ff:	89 fa                	mov    %edi,%edx
80102901:	0f b6 fa             	movzbl %dl,%edi
80102904:	89 f2                	mov    %esi,%edx
80102906:	0f b6 f2             	movzbl %dl,%esi
80102909:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010290c:	89 da                	mov    %ebx,%edx
8010290e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102911:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102914:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102918:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010291b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010291f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102922:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102926:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102929:	31 c0                	xor    %eax,%eax
8010292b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292c:	89 ca                	mov    %ecx,%edx
8010292e:	ec                   	in     (%dx),%al
8010292f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102932:	89 da                	mov    %ebx,%edx
80102934:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102937:	b8 02 00 00 00       	mov    $0x2,%eax
8010293c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293d:	89 ca                	mov    %ecx,%edx
8010293f:	ec                   	in     (%dx),%al
80102940:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102943:	89 da                	mov    %ebx,%edx
80102945:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102948:	b8 04 00 00 00       	mov    $0x4,%eax
8010294d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294e:	89 ca                	mov    %ecx,%edx
80102950:	ec                   	in     (%dx),%al
80102951:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102954:	89 da                	mov    %ebx,%edx
80102956:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102959:	b8 07 00 00 00       	mov    $0x7,%eax
8010295e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295f:	89 ca                	mov    %ecx,%edx
80102961:	ec                   	in     (%dx),%al
80102962:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102965:	89 da                	mov    %ebx,%edx
80102967:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010296a:	b8 08 00 00 00       	mov    $0x8,%eax
8010296f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102970:	89 ca                	mov    %ecx,%edx
80102972:	ec                   	in     (%dx),%al
80102973:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102976:	89 da                	mov    %ebx,%edx
80102978:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010297b:	b8 09 00 00 00       	mov    $0x9,%eax
80102980:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102981:	89 ca                	mov    %ecx,%edx
80102983:	ec                   	in     (%dx),%al
80102984:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102987:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010298a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010298d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102990:	6a 18                	push   $0x18
80102992:	50                   	push   %eax
80102993:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102996:	50                   	push   %eax
80102997:	e8 94 20 00 00       	call   80104a30 <memcmp>
8010299c:	83 c4 10             	add    $0x10,%esp
8010299f:	85 c0                	test   %eax,%eax
801029a1:	0f 85 f1 fe ff ff    	jne    80102898 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801029a7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801029ab:	75 78                	jne    80102a25 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029ad:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029b0:	89 c2                	mov    %eax,%edx
801029b2:	83 e0 0f             	and    $0xf,%eax
801029b5:	c1 ea 04             	shr    $0x4,%edx
801029b8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029bb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029be:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029c1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029c4:	89 c2                	mov    %eax,%edx
801029c6:	83 e0 0f             	and    $0xf,%eax
801029c9:	c1 ea 04             	shr    $0x4,%edx
801029cc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029d2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029d5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029d8:	89 c2                	mov    %eax,%edx
801029da:	83 e0 0f             	and    $0xf,%eax
801029dd:	c1 ea 04             	shr    $0x4,%edx
801029e0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029e3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029e6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029e9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029ec:	89 c2                	mov    %eax,%edx
801029ee:	83 e0 0f             	and    $0xf,%eax
801029f1:	c1 ea 04             	shr    $0x4,%edx
801029f4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029f7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029fa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a00:	89 c2                	mov    %eax,%edx
80102a02:	83 e0 0f             	and    $0xf,%eax
80102a05:	c1 ea 04             	shr    $0x4,%edx
80102a08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a11:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a14:	89 c2                	mov    %eax,%edx
80102a16:	83 e0 0f             	and    $0xf,%eax
80102a19:	c1 ea 04             	shr    $0x4,%edx
80102a1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a22:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a25:	8b 75 08             	mov    0x8(%ebp),%esi
80102a28:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a2b:	89 06                	mov    %eax,(%esi)
80102a2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a30:	89 46 04             	mov    %eax,0x4(%esi)
80102a33:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a36:	89 46 08             	mov    %eax,0x8(%esi)
80102a39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a3c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a42:	89 46 10             	mov    %eax,0x10(%esi)
80102a45:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a48:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a4b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a55:	5b                   	pop    %ebx
80102a56:	5e                   	pop    %esi
80102a57:	5f                   	pop    %edi
80102a58:	5d                   	pop    %ebp
80102a59:	c3                   	ret    
80102a5a:	66 90                	xchg   %ax,%ax
80102a5c:	66 90                	xchg   %ax,%ax
80102a5e:	66 90                	xchg   %ax,%ax

80102a60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a60:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a66:	85 c9                	test   %ecx,%ecx
80102a68:	0f 8e 8a 00 00 00    	jle    80102af8 <install_trans+0x98>
{
80102a6e:	55                   	push   %ebp
80102a6f:	89 e5                	mov    %esp,%ebp
80102a71:	57                   	push   %edi
80102a72:	56                   	push   %esi
80102a73:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a74:	31 db                	xor    %ebx,%ebx
{
80102a76:	83 ec 0c             	sub    $0xc,%esp
80102a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a80:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a85:	83 ec 08             	sub    $0x8,%esp
80102a88:	01 d8                	add    %ebx,%eax
80102a8a:	83 c0 01             	add    $0x1,%eax
80102a8d:	50                   	push   %eax
80102a8e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a94:	e8 37 d6 ff ff       	call   801000d0 <bread>
80102a99:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a9b:	58                   	pop    %eax
80102a9c:	5a                   	pop    %edx
80102a9d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102aa4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102aaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102aad:	e8 1e d6 ff ff       	call   801000d0 <bread>
80102ab2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ab4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ab7:	83 c4 0c             	add    $0xc,%esp
80102aba:	68 00 02 00 00       	push   $0x200
80102abf:	50                   	push   %eax
80102ac0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ac3:	50                   	push   %eax
80102ac4:	e8 c7 1f 00 00       	call   80104a90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ac9:	89 34 24             	mov    %esi,(%esp)
80102acc:	e8 cf d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ad1:	89 3c 24             	mov    %edi,(%esp)
80102ad4:	e8 07 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ad9:	89 34 24             	mov    %esi,(%esp)
80102adc:	e8 ff d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ae1:	83 c4 10             	add    $0x10,%esp
80102ae4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102aea:	7f 94                	jg     80102a80 <install_trans+0x20>
  }
}
80102aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aef:	5b                   	pop    %ebx
80102af0:	5e                   	pop    %esi
80102af1:	5f                   	pop    %edi
80102af2:	5d                   	pop    %ebp
80102af3:	c3                   	ret    
80102af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102af8:	f3 c3                	repz ret 
80102afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	56                   	push   %esi
80102b04:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102b05:	83 ec 08             	sub    $0x8,%esp
80102b08:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102b0e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b14:	e8 b7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b19:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b1f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b22:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b24:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b26:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b29:	7e 16                	jle    80102b41 <write_head+0x41>
80102b2b:	c1 e3 02             	shl    $0x2,%ebx
80102b2e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b30:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102b36:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b3a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b3d:	39 da                	cmp    %ebx,%edx
80102b3f:	75 ef                	jne    80102b30 <write_head+0x30>
  }
  bwrite(buf);
80102b41:	83 ec 0c             	sub    $0xc,%esp
80102b44:	56                   	push   %esi
80102b45:	e8 56 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b4a:	89 34 24             	mov    %esi,(%esp)
80102b4d:	e8 8e d6 ff ff       	call   801001e0 <brelse>
}
80102b52:	83 c4 10             	add    $0x10,%esp
80102b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b58:	5b                   	pop    %ebx
80102b59:	5e                   	pop    %esi
80102b5a:	5d                   	pop    %ebp
80102b5b:	c3                   	ret    
80102b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b60 <initlog>:
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
80102b63:	53                   	push   %ebx
80102b64:	83 ec 2c             	sub    $0x2c,%esp
80102b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b6a:	68 c0 79 10 80       	push   $0x801079c0
80102b6f:	68 80 26 11 80       	push   $0x80112680
80102b74:	e8 17 1c 00 00       	call   80104790 <initlock>
  readsb(dev, &sb);
80102b79:	58                   	pop    %eax
80102b7a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b7d:	5a                   	pop    %edx
80102b7e:	50                   	push   %eax
80102b7f:	53                   	push   %ebx
80102b80:	e8 1b e9 ff ff       	call   801014a0 <readsb>
  log.size = sb.nlog;
80102b85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b8b:	59                   	pop    %ecx
  log.dev = dev;
80102b8c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102b92:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102b98:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102b9d:	5a                   	pop    %edx
80102b9e:	50                   	push   %eax
80102b9f:	53                   	push   %ebx
80102ba0:	e8 2b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ba5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ba8:	83 c4 10             	add    $0x10,%esp
80102bab:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102bad:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102bb3:	7e 1c                	jle    80102bd1 <initlog+0x71>
80102bb5:	c1 e3 02             	shl    $0x2,%ebx
80102bb8:	31 d2                	xor    %edx,%edx
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102bc0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102bc4:	83 c2 04             	add    $0x4,%edx
80102bc7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102bcd:	39 d3                	cmp    %edx,%ebx
80102bcf:	75 ef                	jne    80102bc0 <initlog+0x60>
  brelse(buf);
80102bd1:	83 ec 0c             	sub    $0xc,%esp
80102bd4:	50                   	push   %eax
80102bd5:	e8 06 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bda:	e8 81 fe ff ff       	call   80102a60 <install_trans>
  log.lh.n = 0;
80102bdf:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102be6:	00 00 00 
  write_head(); // clear the log
80102be9:	e8 12 ff ff ff       	call   80102b00 <write_head>
}
80102bee:	83 c4 10             	add    $0x10,%esp
80102bf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bf4:	c9                   	leave  
80102bf5:	c3                   	ret    
80102bf6:	8d 76 00             	lea    0x0(%esi),%esi
80102bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c06:	68 80 26 11 80       	push   $0x80112680
80102c0b:	e8 c0 1c 00 00       	call   801048d0 <acquire>
80102c10:	83 c4 10             	add    $0x10,%esp
80102c13:	eb 18                	jmp    80102c2d <begin_op+0x2d>
80102c15:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c18:	83 ec 08             	sub    $0x8,%esp
80102c1b:	68 80 26 11 80       	push   $0x80112680
80102c20:	68 80 26 11 80       	push   $0x80112680
80102c25:	e8 76 13 00 00       	call   80103fa0 <sleep>
80102c2a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c2d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c32:	85 c0                	test   %eax,%eax
80102c34:	75 e2                	jne    80102c18 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c36:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c3b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c41:	83 c0 01             	add    $0x1,%eax
80102c44:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c47:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c4a:	83 fa 1e             	cmp    $0x1e,%edx
80102c4d:	7f c9                	jg     80102c18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c4f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c52:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c57:	68 80 26 11 80       	push   $0x80112680
80102c5c:	e8 2f 1d 00 00       	call   80104990 <release>
      break;
    }
  }
}
80102c61:	83 c4 10             	add    $0x10,%esp
80102c64:	c9                   	leave  
80102c65:	c3                   	ret    
80102c66:	8d 76 00             	lea    0x0(%esi),%esi
80102c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	57                   	push   %edi
80102c74:	56                   	push   %esi
80102c75:	53                   	push   %ebx
80102c76:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c79:	68 80 26 11 80       	push   $0x80112680
80102c7e:	e8 4d 1c 00 00       	call   801048d0 <acquire>
  log.outstanding -= 1;
80102c83:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c88:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c8e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c91:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c94:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c96:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102c9c:	0f 85 1a 01 00 00    	jne    80102dbc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102ca2:	85 db                	test   %ebx,%ebx
80102ca4:	0f 85 ee 00 00 00    	jne    80102d98 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102caa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102cad:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102cb4:	00 00 00 
  release(&log.lock);
80102cb7:	68 80 26 11 80       	push   $0x80112680
80102cbc:	e8 cf 1c 00 00       	call   80104990 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102cc1:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102cc7:	83 c4 10             	add    $0x10,%esp
80102cca:	85 c9                	test   %ecx,%ecx
80102ccc:	0f 8e 85 00 00 00    	jle    80102d57 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cd2:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102cd7:	83 ec 08             	sub    $0x8,%esp
80102cda:	01 d8                	add    %ebx,%eax
80102cdc:	83 c0 01             	add    $0x1,%eax
80102cdf:	50                   	push   %eax
80102ce0:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ce6:	e8 e5 d3 ff ff       	call   801000d0 <bread>
80102ceb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ced:	58                   	pop    %eax
80102cee:	5a                   	pop    %edx
80102cef:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102cf6:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cfc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cff:	e8 cc d3 ff ff       	call   801000d0 <bread>
80102d04:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d06:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d09:	83 c4 0c             	add    $0xc,%esp
80102d0c:	68 00 02 00 00       	push   $0x200
80102d11:	50                   	push   %eax
80102d12:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d15:	50                   	push   %eax
80102d16:	e8 75 1d 00 00       	call   80104a90 <memmove>
    bwrite(to);  // write the log
80102d1b:	89 34 24             	mov    %esi,(%esp)
80102d1e:	e8 7d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d23:	89 3c 24             	mov    %edi,(%esp)
80102d26:	e8 b5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d2b:	89 34 24             	mov    %esi,(%esp)
80102d2e:	e8 ad d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d33:	83 c4 10             	add    $0x10,%esp
80102d36:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d3c:	7c 94                	jl     80102cd2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d3e:	e8 bd fd ff ff       	call   80102b00 <write_head>
    install_trans(); // Now install writes to home locations
80102d43:	e8 18 fd ff ff       	call   80102a60 <install_trans>
    log.lh.n = 0;
80102d48:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d4f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d52:	e8 a9 fd ff ff       	call   80102b00 <write_head>
    acquire(&log.lock);
80102d57:	83 ec 0c             	sub    $0xc,%esp
80102d5a:	68 80 26 11 80       	push   $0x80112680
80102d5f:	e8 6c 1b 00 00       	call   801048d0 <acquire>
    wakeup(&log);
80102d64:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d6b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d72:	00 00 00 
    wakeup(&log);
80102d75:	e8 26 14 00 00       	call   801041a0 <wakeup>
    release(&log.lock);
80102d7a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d81:	e8 0a 1c 00 00       	call   80104990 <release>
80102d86:	83 c4 10             	add    $0x10,%esp
}
80102d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d8c:	5b                   	pop    %ebx
80102d8d:	5e                   	pop    %esi
80102d8e:	5f                   	pop    %edi
80102d8f:	5d                   	pop    %ebp
80102d90:	c3                   	ret    
80102d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102d98:	83 ec 0c             	sub    $0xc,%esp
80102d9b:	68 80 26 11 80       	push   $0x80112680
80102da0:	e8 fb 13 00 00       	call   801041a0 <wakeup>
  release(&log.lock);
80102da5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dac:	e8 df 1b 00 00       	call   80104990 <release>
80102db1:	83 c4 10             	add    $0x10,%esp
}
80102db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102db7:	5b                   	pop    %ebx
80102db8:	5e                   	pop    %esi
80102db9:	5f                   	pop    %edi
80102dba:	5d                   	pop    %ebp
80102dbb:	c3                   	ret    
    panic("log.committing");
80102dbc:	83 ec 0c             	sub    $0xc,%esp
80102dbf:	68 c4 79 10 80       	push   $0x801079c4
80102dc4:	e8 c7 d5 ff ff       	call   80100390 <panic>
80102dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102dd0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102dd7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102ddd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102de0:	83 fa 1d             	cmp    $0x1d,%edx
80102de3:	0f 8f 9d 00 00 00    	jg     80102e86 <log_write+0xb6>
80102de9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102dee:	83 e8 01             	sub    $0x1,%eax
80102df1:	39 c2                	cmp    %eax,%edx
80102df3:	0f 8d 8d 00 00 00    	jge    80102e86 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102df9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102dfe:	85 c0                	test   %eax,%eax
80102e00:	0f 8e 8d 00 00 00    	jle    80102e93 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e06:	83 ec 0c             	sub    $0xc,%esp
80102e09:	68 80 26 11 80       	push   $0x80112680
80102e0e:	e8 bd 1a 00 00       	call   801048d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e13:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e19:	83 c4 10             	add    $0x10,%esp
80102e1c:	83 f9 00             	cmp    $0x0,%ecx
80102e1f:	7e 57                	jle    80102e78 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e21:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e24:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e26:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102e2c:	75 0b                	jne    80102e39 <log_write+0x69>
80102e2e:	eb 38                	jmp    80102e68 <log_write+0x98>
80102e30:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102e37:	74 2f                	je     80102e68 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e39:	83 c0 01             	add    $0x1,%eax
80102e3c:	39 c1                	cmp    %eax,%ecx
80102e3e:	75 f0                	jne    80102e30 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e40:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e47:	83 c0 01             	add    $0x1,%eax
80102e4a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e4f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e52:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e5c:	c9                   	leave  
  release(&log.lock);
80102e5d:	e9 2e 1b 00 00       	jmp    80104990 <release>
80102e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e68:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e6f:	eb de                	jmp    80102e4f <log_write+0x7f>
80102e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e78:	8b 43 08             	mov    0x8(%ebx),%eax
80102e7b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e80:	75 cd                	jne    80102e4f <log_write+0x7f>
80102e82:	31 c0                	xor    %eax,%eax
80102e84:	eb c1                	jmp    80102e47 <log_write+0x77>
    panic("too big a transaction");
80102e86:	83 ec 0c             	sub    $0xc,%esp
80102e89:	68 d3 79 10 80       	push   $0x801079d3
80102e8e:	e8 fd d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e93:	83 ec 0c             	sub    $0xc,%esp
80102e96:	68 e9 79 10 80       	push   $0x801079e9
80102e9b:	e8 f0 d4 ff ff       	call   80100390 <panic>

80102ea0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ea7:	e8 d4 09 00 00       	call   80103880 <cpuid>
80102eac:	89 c3                	mov    %eax,%ebx
80102eae:	e8 cd 09 00 00       	call   80103880 <cpuid>
80102eb3:	83 ec 04             	sub    $0x4,%esp
80102eb6:	53                   	push   %ebx
80102eb7:	50                   	push   %eax
80102eb8:	68 04 7a 10 80       	push   $0x80107a04
80102ebd:	e8 9e d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ec2:	e8 79 2e 00 00       	call   80105d40 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ec7:	e8 34 09 00 00       	call   80103800 <mycpu>
80102ecc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ece:	b8 01 00 00 00       	mov    $0x1,%eax
80102ed3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eda:	e8 51 0d 00 00       	call   80103c30 <scheduler>
80102edf:	90                   	nop

80102ee0 <mpenter>:
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ee6:	e8 45 3f 00 00       	call   80106e30 <switchkvm>
  seginit();
80102eeb:	e8 b0 3e 00 00       	call   80106da0 <seginit>
  lapicinit();
80102ef0:	e8 9b f7 ff ff       	call   80102690 <lapicinit>
  mpmain();
80102ef5:	e8 a6 ff ff ff       	call   80102ea0 <mpmain>
80102efa:	66 90                	xchg   %ax,%ax
80102efc:	66 90                	xchg   %ax,%ax
80102efe:	66 90                	xchg   %ax,%ax

80102f00 <main>:
{
80102f00:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f04:	83 e4 f0             	and    $0xfffffff0,%esp
80102f07:	ff 71 fc             	pushl  -0x4(%ecx)
80102f0a:	55                   	push   %ebp
80102f0b:	89 e5                	mov    %esp,%ebp
80102f0d:	53                   	push   %ebx
80102f0e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f0f:	83 ec 08             	sub    $0x8,%esp
80102f12:	68 00 00 40 80       	push   $0x80400000
80102f17:	68 a8 78 11 80       	push   $0x801178a8
80102f1c:	e8 2f f5 ff ff       	call   80102450 <kinit1>
  kvmalloc();      // kernel page table
80102f21:	e8 da 43 00 00       	call   80107300 <kvmalloc>
  mpinit();        // detect other processors
80102f26:	e8 75 01 00 00       	call   801030a0 <mpinit>
  lapicinit();     // interrupt controller
80102f2b:	e8 60 f7 ff ff       	call   80102690 <lapicinit>
  seginit();       // segment descriptors
80102f30:	e8 6b 3e 00 00       	call   80106da0 <seginit>
  picinit();       // disable pic
80102f35:	e8 46 03 00 00       	call   80103280 <picinit>
  ioapicinit();    // another interrupt controller
80102f3a:	e8 41 f3 ff ff       	call   80102280 <ioapicinit>
  consoleinit();   // console hardware
80102f3f:	e8 7c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f44:	e8 27 31 00 00       	call   80106070 <uartinit>
  pinit();         // process table
80102f49:	e8 92 08 00 00       	call   801037e0 <pinit>
  tvinit();        // trap vectors
80102f4e:	e8 6d 2d 00 00       	call   80105cc0 <tvinit>
  binit();         // buffer cache
80102f53:	e8 e8 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f58:	e8 63 de ff ff       	call   80100dc0 <fileinit>
  ideinit();       // disk 
80102f5d:	e8 fe f0 ff ff       	call   80102060 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f62:	83 c4 0c             	add    $0xc,%esp
80102f65:	68 8a 00 00 00       	push   $0x8a
80102f6a:	68 8c a4 10 80       	push   $0x8010a48c
80102f6f:	68 00 70 00 80       	push   $0x80007000
80102f74:	e8 17 1b 00 00       	call   80104a90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f79:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f80:	00 00 00 
80102f83:	83 c4 10             	add    $0x10,%esp
80102f86:	05 80 27 11 80       	add    $0x80112780,%eax
80102f8b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102f90:	76 71                	jbe    80103003 <main+0x103>
80102f92:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102f97:	89 f6                	mov    %esi,%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102fa0:	e8 5b 08 00 00       	call   80103800 <mycpu>
80102fa5:	39 d8                	cmp    %ebx,%eax
80102fa7:	74 41                	je     80102fea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fa9:	e8 72 f5 ff ff       	call   80102520 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fae:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102fb3:	c7 05 f8 6f 00 80 e0 	movl   $0x80102ee0,0x80006ff8
80102fba:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fbd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fc4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fc7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fcc:	0f b6 03             	movzbl (%ebx),%eax
80102fcf:	83 ec 08             	sub    $0x8,%esp
80102fd2:	68 00 70 00 00       	push   $0x7000
80102fd7:	50                   	push   %eax
80102fd8:	e8 03 f8 ff ff       	call   801027e0 <lapicstartap>
80102fdd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fe0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102fe6:	85 c0                	test   %eax,%eax
80102fe8:	74 f6                	je     80102fe0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102fea:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ff1:	00 00 00 
80102ff4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102ffa:	05 80 27 11 80       	add    $0x80112780,%eax
80102fff:	39 c3                	cmp    %eax,%ebx
80103001:	72 9d                	jb     80102fa0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103003:	83 ec 08             	sub    $0x8,%esp
80103006:	68 00 00 00 8e       	push   $0x8e000000
8010300b:	68 00 00 40 80       	push   $0x80400000
80103010:	e8 ab f4 ff ff       	call   801024c0 <kinit2>
  userinit();      // first user process
80103015:	e8 f6 08 00 00       	call   80103910 <userinit>
  mpmain();        // finish this processor's setup
8010301a:	e8 81 fe ff ff       	call   80102ea0 <mpmain>
8010301f:	90                   	nop

80103020 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	57                   	push   %edi
80103024:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103025:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010302b:	53                   	push   %ebx
  e = addr+len;
8010302c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010302f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103032:	39 de                	cmp    %ebx,%esi
80103034:	72 10                	jb     80103046 <mpsearch1+0x26>
80103036:	eb 50                	jmp    80103088 <mpsearch1+0x68>
80103038:	90                   	nop
80103039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103040:	39 fb                	cmp    %edi,%ebx
80103042:	89 fe                	mov    %edi,%esi
80103044:	76 42                	jbe    80103088 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103046:	83 ec 04             	sub    $0x4,%esp
80103049:	8d 7e 10             	lea    0x10(%esi),%edi
8010304c:	6a 04                	push   $0x4
8010304e:	68 18 7a 10 80       	push   $0x80107a18
80103053:	56                   	push   %esi
80103054:	e8 d7 19 00 00       	call   80104a30 <memcmp>
80103059:	83 c4 10             	add    $0x10,%esp
8010305c:	85 c0                	test   %eax,%eax
8010305e:	75 e0                	jne    80103040 <mpsearch1+0x20>
80103060:	89 f1                	mov    %esi,%ecx
80103062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103068:	0f b6 11             	movzbl (%ecx),%edx
8010306b:	83 c1 01             	add    $0x1,%ecx
8010306e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103070:	39 f9                	cmp    %edi,%ecx
80103072:	75 f4                	jne    80103068 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103074:	84 c0                	test   %al,%al
80103076:	75 c8                	jne    80103040 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103078:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010307b:	89 f0                	mov    %esi,%eax
8010307d:	5b                   	pop    %ebx
8010307e:	5e                   	pop    %esi
8010307f:	5f                   	pop    %edi
80103080:	5d                   	pop    %ebp
80103081:	c3                   	ret    
80103082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103088:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010308b:	31 f6                	xor    %esi,%esi
}
8010308d:	89 f0                	mov    %esi,%eax
8010308f:	5b                   	pop    %ebx
80103090:	5e                   	pop    %esi
80103091:	5f                   	pop    %edi
80103092:	5d                   	pop    %ebp
80103093:	c3                   	ret    
80103094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010309a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801030a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	57                   	push   %edi
801030a4:	56                   	push   %esi
801030a5:	53                   	push   %ebx
801030a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030b7:	c1 e0 08             	shl    $0x8,%eax
801030ba:	09 d0                	or     %edx,%eax
801030bc:	c1 e0 04             	shl    $0x4,%eax
801030bf:	85 c0                	test   %eax,%eax
801030c1:	75 1b                	jne    801030de <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030c3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030ca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030d1:	c1 e0 08             	shl    $0x8,%eax
801030d4:	09 d0                	or     %edx,%eax
801030d6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030d9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030de:	ba 00 04 00 00       	mov    $0x400,%edx
801030e3:	e8 38 ff ff ff       	call   80103020 <mpsearch1>
801030e8:	85 c0                	test   %eax,%eax
801030ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030ed:	0f 84 3d 01 00 00    	je     80103230 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801030f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030f6:	8b 58 04             	mov    0x4(%eax),%ebx
801030f9:	85 db                	test   %ebx,%ebx
801030fb:	0f 84 4f 01 00 00    	je     80103250 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103101:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103107:	83 ec 04             	sub    $0x4,%esp
8010310a:	6a 04                	push   $0x4
8010310c:	68 35 7a 10 80       	push   $0x80107a35
80103111:	56                   	push   %esi
80103112:	e8 19 19 00 00       	call   80104a30 <memcmp>
80103117:	83 c4 10             	add    $0x10,%esp
8010311a:	85 c0                	test   %eax,%eax
8010311c:	0f 85 2e 01 00 00    	jne    80103250 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103122:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103129:	3c 01                	cmp    $0x1,%al
8010312b:	0f 95 c2             	setne  %dl
8010312e:	3c 04                	cmp    $0x4,%al
80103130:	0f 95 c0             	setne  %al
80103133:	20 c2                	and    %al,%dl
80103135:	0f 85 15 01 00 00    	jne    80103250 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010313b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103142:	66 85 ff             	test   %di,%di
80103145:	74 1a                	je     80103161 <mpinit+0xc1>
80103147:	89 f0                	mov    %esi,%eax
80103149:	01 f7                	add    %esi,%edi
  sum = 0;
8010314b:	31 d2                	xor    %edx,%edx
8010314d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103150:	0f b6 08             	movzbl (%eax),%ecx
80103153:	83 c0 01             	add    $0x1,%eax
80103156:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103158:	39 c7                	cmp    %eax,%edi
8010315a:	75 f4                	jne    80103150 <mpinit+0xb0>
8010315c:	84 d2                	test   %dl,%dl
8010315e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103161:	85 f6                	test   %esi,%esi
80103163:	0f 84 e7 00 00 00    	je     80103250 <mpinit+0x1b0>
80103169:	84 d2                	test   %dl,%dl
8010316b:	0f 85 df 00 00 00    	jne    80103250 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103171:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103177:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010317c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103183:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103189:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010318e:	01 d6                	add    %edx,%esi
80103190:	39 c6                	cmp    %eax,%esi
80103192:	76 23                	jbe    801031b7 <mpinit+0x117>
    switch(*p){
80103194:	0f b6 10             	movzbl (%eax),%edx
80103197:	80 fa 04             	cmp    $0x4,%dl
8010319a:	0f 87 ca 00 00 00    	ja     8010326a <mpinit+0x1ca>
801031a0:	ff 24 95 5c 7a 10 80 	jmp    *-0x7fef85a4(,%edx,4)
801031a7:	89 f6                	mov    %esi,%esi
801031a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031b0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031b3:	39 c6                	cmp    %eax,%esi
801031b5:	77 dd                	ja     80103194 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801031b7:	85 db                	test   %ebx,%ebx
801031b9:	0f 84 9e 00 00 00    	je     8010325d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801031bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031c2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031c6:	74 15                	je     801031dd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031c8:	b8 70 00 00 00       	mov    $0x70,%eax
801031cd:	ba 22 00 00 00       	mov    $0x22,%edx
801031d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d3:	ba 23 00 00 00       	mov    $0x23,%edx
801031d8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031d9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031dc:	ee                   	out    %al,(%dx)
  }
}
801031dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031e0:	5b                   	pop    %ebx
801031e1:	5e                   	pop    %esi
801031e2:	5f                   	pop    %edi
801031e3:	5d                   	pop    %ebp
801031e4:	c3                   	ret    
801031e5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031e8:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801031ee:	83 f9 07             	cmp    $0x7,%ecx
801031f1:	7f 19                	jg     8010320c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031f3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031f7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031fd:	83 c1 01             	add    $0x1,%ecx
80103200:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103206:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010320c:	83 c0 14             	add    $0x14,%eax
      continue;
8010320f:	e9 7c ff ff ff       	jmp    80103190 <mpinit+0xf0>
80103214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103218:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010321c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010321f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103225:	e9 66 ff ff ff       	jmp    80103190 <mpinit+0xf0>
8010322a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103230:	ba 00 00 01 00       	mov    $0x10000,%edx
80103235:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010323a:	e8 e1 fd ff ff       	call   80103020 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010323f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103241:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103244:	0f 85 a9 fe ff ff    	jne    801030f3 <mpinit+0x53>
8010324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103250:	83 ec 0c             	sub    $0xc,%esp
80103253:	68 1d 7a 10 80       	push   $0x80107a1d
80103258:	e8 33 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010325d:	83 ec 0c             	sub    $0xc,%esp
80103260:	68 3c 7a 10 80       	push   $0x80107a3c
80103265:	e8 26 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010326a:	31 db                	xor    %ebx,%ebx
8010326c:	e9 26 ff ff ff       	jmp    80103197 <mpinit+0xf7>
80103271:	66 90                	xchg   %ax,%ax
80103273:	66 90                	xchg   %ax,%ax
80103275:	66 90                	xchg   %ax,%ax
80103277:	66 90                	xchg   %ax,%ax
80103279:	66 90                	xchg   %ax,%ax
8010327b:	66 90                	xchg   %ax,%ax
8010327d:	66 90                	xchg   %ax,%ax
8010327f:	90                   	nop

80103280 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103280:	55                   	push   %ebp
80103281:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103286:	ba 21 00 00 00       	mov    $0x21,%edx
8010328b:	89 e5                	mov    %esp,%ebp
8010328d:	ee                   	out    %al,(%dx)
8010328e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103293:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103294:	5d                   	pop    %ebp
80103295:	c3                   	ret    
80103296:	66 90                	xchg   %ax,%ax
80103298:	66 90                	xchg   %ax,%ax
8010329a:	66 90                	xchg   %ax,%ax
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
801032a5:	53                   	push   %ebx
801032a6:	83 ec 0c             	sub    $0xc,%esp
801032a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032af:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801032b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032bb:	e8 20 db ff ff       	call   80100de0 <filealloc>
801032c0:	85 c0                	test   %eax,%eax
801032c2:	89 03                	mov    %eax,(%ebx)
801032c4:	74 22                	je     801032e8 <pipealloc+0x48>
801032c6:	e8 15 db ff ff       	call   80100de0 <filealloc>
801032cb:	85 c0                	test   %eax,%eax
801032cd:	89 06                	mov    %eax,(%esi)
801032cf:	74 3f                	je     80103310 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032d1:	e8 4a f2 ff ff       	call   80102520 <kalloc>
801032d6:	85 c0                	test   %eax,%eax
801032d8:	89 c7                	mov    %eax,%edi
801032da:	75 54                	jne    80103330 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032dc:	8b 03                	mov    (%ebx),%eax
801032de:	85 c0                	test   %eax,%eax
801032e0:	75 34                	jne    80103316 <pipealloc+0x76>
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032e8:	8b 06                	mov    (%esi),%eax
801032ea:	85 c0                	test   %eax,%eax
801032ec:	74 0c                	je     801032fa <pipealloc+0x5a>
    fileclose(*f1);
801032ee:	83 ec 0c             	sub    $0xc,%esp
801032f1:	50                   	push   %eax
801032f2:	e8 a9 db ff ff       	call   80100ea0 <fileclose>
801032f7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801032fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103302:	5b                   	pop    %ebx
80103303:	5e                   	pop    %esi
80103304:	5f                   	pop    %edi
80103305:	5d                   	pop    %ebp
80103306:	c3                   	ret    
80103307:	89 f6                	mov    %esi,%esi
80103309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103310:	8b 03                	mov    (%ebx),%eax
80103312:	85 c0                	test   %eax,%eax
80103314:	74 e4                	je     801032fa <pipealloc+0x5a>
    fileclose(*f0);
80103316:	83 ec 0c             	sub    $0xc,%esp
80103319:	50                   	push   %eax
8010331a:	e8 81 db ff ff       	call   80100ea0 <fileclose>
  if(*f1)
8010331f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103321:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103324:	85 c0                	test   %eax,%eax
80103326:	75 c6                	jne    801032ee <pipealloc+0x4e>
80103328:	eb d0                	jmp    801032fa <pipealloc+0x5a>
8010332a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103330:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103333:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010333a:	00 00 00 
  p->writeopen = 1;
8010333d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103344:	00 00 00 
  p->nwrite = 0;
80103347:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010334e:	00 00 00 
  p->nread = 0;
80103351:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103358:	00 00 00 
  initlock(&p->lock, "pipe");
8010335b:	68 70 7a 10 80       	push   $0x80107a70
80103360:	50                   	push   %eax
80103361:	e8 2a 14 00 00       	call   80104790 <initlock>
  (*f0)->type = FD_PIPE;
80103366:	8b 03                	mov    (%ebx),%eax
  return 0;
80103368:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010336b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103371:	8b 03                	mov    (%ebx),%eax
80103373:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103377:	8b 03                	mov    (%ebx),%eax
80103379:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010337d:	8b 03                	mov    (%ebx),%eax
8010337f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103382:	8b 06                	mov    (%esi),%eax
80103384:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010338a:	8b 06                	mov    (%esi),%eax
8010338c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103390:	8b 06                	mov    (%esi),%eax
80103392:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103396:	8b 06                	mov    (%esi),%eax
80103398:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010339b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010339e:	31 c0                	xor    %eax,%eax
}
801033a0:	5b                   	pop    %ebx
801033a1:	5e                   	pop    %esi
801033a2:	5f                   	pop    %edi
801033a3:	5d                   	pop    %ebp
801033a4:	c3                   	ret    
801033a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	56                   	push   %esi
801033b4:	53                   	push   %ebx
801033b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033bb:	83 ec 0c             	sub    $0xc,%esp
801033be:	53                   	push   %ebx
801033bf:	e8 0c 15 00 00       	call   801048d0 <acquire>
  if(writable){
801033c4:	83 c4 10             	add    $0x10,%esp
801033c7:	85 f6                	test   %esi,%esi
801033c9:	74 45                	je     80103410 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033cb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033d1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033db:	00 00 00 
    wakeup(&p->nread);
801033de:	50                   	push   %eax
801033df:	e8 bc 0d 00 00       	call   801041a0 <wakeup>
801033e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033ed:	85 d2                	test   %edx,%edx
801033ef:	75 0a                	jne    801033fb <pipeclose+0x4b>
801033f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801033f7:	85 c0                	test   %eax,%eax
801033f9:	74 35                	je     80103430 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801033fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801033fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103401:	5b                   	pop    %ebx
80103402:	5e                   	pop    %esi
80103403:	5d                   	pop    %ebp
    release(&p->lock);
80103404:	e9 87 15 00 00       	jmp    80104990 <release>
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103410:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103416:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103419:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103420:	00 00 00 
    wakeup(&p->nwrite);
80103423:	50                   	push   %eax
80103424:	e8 77 0d 00 00       	call   801041a0 <wakeup>
80103429:	83 c4 10             	add    $0x10,%esp
8010342c:	eb b9                	jmp    801033e7 <pipeclose+0x37>
8010342e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103430:	83 ec 0c             	sub    $0xc,%esp
80103433:	53                   	push   %ebx
80103434:	e8 57 15 00 00       	call   80104990 <release>
    kfree((char*)p);
80103439:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010343c:	83 c4 10             	add    $0x10,%esp
}
8010343f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103442:	5b                   	pop    %ebx
80103443:	5e                   	pop    %esi
80103444:	5d                   	pop    %ebp
    kfree((char*)p);
80103445:	e9 26 ef ff ff       	jmp    80102370 <kfree>
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103450 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	57                   	push   %edi
80103454:	56                   	push   %esi
80103455:	53                   	push   %ebx
80103456:	83 ec 28             	sub    $0x28,%esp
80103459:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010345c:	53                   	push   %ebx
8010345d:	e8 6e 14 00 00       	call   801048d0 <acquire>
  for(i = 0; i < n; i++){
80103462:	8b 45 10             	mov    0x10(%ebp),%eax
80103465:	83 c4 10             	add    $0x10,%esp
80103468:	85 c0                	test   %eax,%eax
8010346a:	0f 8e c9 00 00 00    	jle    80103539 <pipewrite+0xe9>
80103470:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103473:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103479:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010347f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103482:	03 4d 10             	add    0x10(%ebp),%ecx
80103485:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103488:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010348e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103494:	39 d0                	cmp    %edx,%eax
80103496:	75 71                	jne    80103509 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103498:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010349e:	85 c0                	test   %eax,%eax
801034a0:	74 4e                	je     801034f0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034a2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801034a8:	eb 3a                	jmp    801034e4 <pipewrite+0x94>
801034aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801034b0:	83 ec 0c             	sub    $0xc,%esp
801034b3:	57                   	push   %edi
801034b4:	e8 e7 0c 00 00       	call   801041a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034b9:	5a                   	pop    %edx
801034ba:	59                   	pop    %ecx
801034bb:	53                   	push   %ebx
801034bc:	56                   	push   %esi
801034bd:	e8 de 0a 00 00       	call   80103fa0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034c2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034c8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034ce:	83 c4 10             	add    $0x10,%esp
801034d1:	05 00 02 00 00       	add    $0x200,%eax
801034d6:	39 c2                	cmp    %eax,%edx
801034d8:	75 36                	jne    80103510 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034da:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034e0:	85 c0                	test   %eax,%eax
801034e2:	74 0c                	je     801034f0 <pipewrite+0xa0>
801034e4:	e8 b7 03 00 00       	call   801038a0 <myproc>
801034e9:	8b 40 24             	mov    0x24(%eax),%eax
801034ec:	85 c0                	test   %eax,%eax
801034ee:	74 c0                	je     801034b0 <pipewrite+0x60>
        release(&p->lock);
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	53                   	push   %ebx
801034f4:	e8 97 14 00 00       	call   80104990 <release>
        return -1;
801034f9:	83 c4 10             	add    $0x10,%esp
801034fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103501:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103504:	5b                   	pop    %ebx
80103505:	5e                   	pop    %esi
80103506:	5f                   	pop    %edi
80103507:	5d                   	pop    %ebp
80103508:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103509:	89 c2                	mov    %eax,%edx
8010350b:	90                   	nop
8010350c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103510:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103513:	8d 42 01             	lea    0x1(%edx),%eax
80103516:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010351c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103522:	83 c6 01             	add    $0x1,%esi
80103525:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103529:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010352c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010352f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103533:	0f 85 4f ff ff ff    	jne    80103488 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103539:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010353f:	83 ec 0c             	sub    $0xc,%esp
80103542:	50                   	push   %eax
80103543:	e8 58 0c 00 00       	call   801041a0 <wakeup>
  release(&p->lock);
80103548:	89 1c 24             	mov    %ebx,(%esp)
8010354b:	e8 40 14 00 00       	call   80104990 <release>
  return n;
80103550:	83 c4 10             	add    $0x10,%esp
80103553:	8b 45 10             	mov    0x10(%ebp),%eax
80103556:	eb a9                	jmp    80103501 <pipewrite+0xb1>
80103558:	90                   	nop
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103560 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	57                   	push   %edi
80103564:	56                   	push   %esi
80103565:	53                   	push   %ebx
80103566:	83 ec 18             	sub    $0x18,%esp
80103569:	8b 75 08             	mov    0x8(%ebp),%esi
8010356c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010356f:	56                   	push   %esi
80103570:	e8 5b 13 00 00       	call   801048d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103575:	83 c4 10             	add    $0x10,%esp
80103578:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010357e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103584:	75 6a                	jne    801035f0 <piperead+0x90>
80103586:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010358c:	85 db                	test   %ebx,%ebx
8010358e:	0f 84 c4 00 00 00    	je     80103658 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103594:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010359a:	eb 2d                	jmp    801035c9 <piperead+0x69>
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	83 ec 08             	sub    $0x8,%esp
801035a3:	56                   	push   %esi
801035a4:	53                   	push   %ebx
801035a5:	e8 f6 09 00 00       	call   80103fa0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035aa:	83 c4 10             	add    $0x10,%esp
801035ad:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035b3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035b9:	75 35                	jne    801035f0 <piperead+0x90>
801035bb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035c1:	85 d2                	test   %edx,%edx
801035c3:	0f 84 8f 00 00 00    	je     80103658 <piperead+0xf8>
    if(myproc()->killed){
801035c9:	e8 d2 02 00 00       	call   801038a0 <myproc>
801035ce:	8b 48 24             	mov    0x24(%eax),%ecx
801035d1:	85 c9                	test   %ecx,%ecx
801035d3:	74 cb                	je     801035a0 <piperead+0x40>
      release(&p->lock);
801035d5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035d8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035dd:	56                   	push   %esi
801035de:	e8 ad 13 00 00       	call   80104990 <release>
      return -1;
801035e3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035e9:	89 d8                	mov    %ebx,%eax
801035eb:	5b                   	pop    %ebx
801035ec:	5e                   	pop    %esi
801035ed:	5f                   	pop    %edi
801035ee:	5d                   	pop    %ebp
801035ef:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f0:	8b 45 10             	mov    0x10(%ebp),%eax
801035f3:	85 c0                	test   %eax,%eax
801035f5:	7e 61                	jle    80103658 <piperead+0xf8>
    if(p->nread == p->nwrite)
801035f7:	31 db                	xor    %ebx,%ebx
801035f9:	eb 13                	jmp    8010360e <piperead+0xae>
801035fb:	90                   	nop
801035fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103600:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103606:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010360c:	74 1f                	je     8010362d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010360e:	8d 41 01             	lea    0x1(%ecx),%eax
80103611:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103617:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010361d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103622:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103625:	83 c3 01             	add    $0x1,%ebx
80103628:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010362b:	75 d3                	jne    80103600 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010362d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103633:	83 ec 0c             	sub    $0xc,%esp
80103636:	50                   	push   %eax
80103637:	e8 64 0b 00 00       	call   801041a0 <wakeup>
  release(&p->lock);
8010363c:	89 34 24             	mov    %esi,(%esp)
8010363f:	e8 4c 13 00 00       	call   80104990 <release>
  return i;
80103644:	83 c4 10             	add    $0x10,%esp
}
80103647:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364a:	89 d8                	mov    %ebx,%eax
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103658:	31 db                	xor    %ebx,%ebx
8010365a:	eb d1                	jmp    8010362d <piperead+0xcd>
8010365c:	66 90                	xchg   %ax,%ax
8010365e:	66 90                	xchg   %ax,%ax

80103660 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	56                   	push   %esi
80103664:	53                   	push   %ebx
80103665:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  // acquire(&ptable.lock);

  pushcli();
80103668:	e8 93 11 00 00       	call   80104800 <pushcli>
  ushort padding6;
};

static inline int cas(volatile int * addr, int expected, int newval) {
  int ret_val = 1;
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
8010366d:	31 c0                	xor    %eax,%eax
8010366f:	ba 02 00 00 00       	mov    $0x2,%edx
80103674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  do {
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103678:	be 54 2d 11 80       	mov    $0x80112d54,%esi
8010367d:	eb 0f                	jmp    8010368e <allocproc+0x2e>
8010367f:	90                   	nop
80103680:	81 c6 0c 01 00 00    	add    $0x10c,%esi
80103686:	81 fe 54 70 11 80    	cmp    $0x80117054,%esi
8010368c:	73 07                	jae    80103695 <allocproc+0x35>
      if(p->state == UNUSED)
8010368e:	8b 5e 0c             	mov    0xc(%esi),%ebx
80103691:	85 db                	test   %ebx,%ebx
80103693:	75 eb                	jne    80103680 <allocproc+0x20>
        break;
    if (p == &ptable.proc[NPROC]) {
80103695:	81 fe 54 70 11 80    	cmp    $0x80117054,%esi
8010369b:	0f 84 cd 00 00 00    	je     8010376e <pass98+0x82>
  int ret_val = 1;
801036a1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      popcli();
      return 0; // ptable is full
    }
  } while (!cas((int*)&p->state, UNUSED, EMBRYO));
801036a8:	8d 5e 0c             	lea    0xc(%esi),%ebx
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801036ab:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801036af:	74 07                	je     801036b8 <pass65>
801036b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

801036b8 <pass65>:
801036b8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801036bb:	85 c9                	test   %ecx,%ecx
801036bd:	74 b9                	je     80103678 <allocproc+0x18>
801036bf:	bb 04 a0 10 80       	mov    $0x8010a004,%ebx
  popcli();
801036c4:	e8 77 11 00 00       	call   80104840 <popcli>
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pid = nextpid;
801036d0:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  int ret_val = 1;
801036d5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  }while(!cas(&nextpid, pid, pid + 1));
801036dc:	8d 50 01             	lea    0x1(%eax),%edx
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801036df:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801036e3:	74 07                	je     801036ec <pass98>
801036e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

801036ec <pass98>:
801036ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036ef:	85 d2                	test   %edx,%edx
801036f1:	74 dd                	je     801036d0 <pass65+0x18>

// found:
  // p->state = EMBRYO;
  // release(&ptable.lock);

  p->pid = allocpid();
801036f3:	89 46 10             	mov    %eax,0x10(%esi)

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036f6:	e8 25 ee ff ff       	call   80102520 <kalloc>
801036fb:	85 c0                	test   %eax,%eax
801036fd:	89 46 08             	mov    %eax,0x8(%esi)
80103700:	74 7c                	je     8010377e <pass98+0x92>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103702:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103708:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010370b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103710:	89 56 18             	mov    %edx,0x18(%esi)
  *(uint*)sp = (uint)trapret;
80103713:	c7 40 14 a1 5c 10 80 	movl   $0x80105ca1,0x14(%eax)
  p->context = (struct context*)sp;
8010371a:	89 46 1c             	mov    %eax,0x1c(%esi)
  memset(p->context, 0, sizeof *p->context);
8010371d:	6a 14                	push   $0x14
8010371f:	6a 00                	push   $0x0
80103721:	50                   	push   %eax
80103722:	e8 b9 12 00 00       	call   801049e0 <memset>
  p->context->eip = (uint)forkret;
80103727:	8b 46 1c             	mov    0x1c(%esi),%eax
8010372a:	8d 96 04 01 00 00    	lea    0x104(%esi),%edx
80103730:	83 c4 10             	add    $0x10,%esp
80103733:	c7 40 10 90 37 10 80 	movl   $0x80103790,0x10(%eax)
8010373a:	8d 86 84 00 00 00    	lea    0x84(%esi),%eax

  p->psignals = 0;
80103740:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
  p->sigmask = 0;
80103747:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
8010374e:	00 00 00 
80103751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for (int i = SIG_MIN; i <= SIG_MAX; i++) // setting all sig handlers to default
    p->sig_handlers[i] = SIG_DFL;
80103758:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010375e:	83 c0 04             	add    $0x4,%eax
  for (int i = SIG_MIN; i <= SIG_MAX; i++) // setting all sig handlers to default
80103761:	39 d0                	cmp    %edx,%eax
80103763:	75 f3                	jne    80103758 <pass98+0x6c>
  
  return p;
}
80103765:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103768:	89 f0                	mov    %esi,%eax
8010376a:	5b                   	pop    %ebx
8010376b:	5e                   	pop    %esi
8010376c:	5d                   	pop    %ebp
8010376d:	c3                   	ret    
      return 0; // ptable is full
8010376e:	31 f6                	xor    %esi,%esi
      popcli();
80103770:	e8 cb 10 00 00       	call   80104840 <popcli>
}
80103775:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103778:	89 f0                	mov    %esi,%eax
8010377a:	5b                   	pop    %ebx
8010377b:	5e                   	pop    %esi
8010377c:	5d                   	pop    %ebp
8010377d:	c3                   	ret    
    p->state = UNUSED;
8010377e:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return 0;
80103785:	31 f6                	xor    %esi,%esi
80103787:	eb ec                	jmp    80103775 <pass98+0x89>
80103789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103790 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103796:	68 20 2d 11 80       	push   $0x80112d20
8010379b:	e8 f0 11 00 00       	call   80104990 <release>

  if (first) {
801037a0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 c0                	test   %eax,%eax
801037aa:	75 04                	jne    801037b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037ac:	c9                   	leave  
801037ad:	c3                   	ret    
801037ae:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801037b0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801037b3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037ba:	00 00 00 
    iinit(ROOTDEV);
801037bd:	6a 01                	push   $0x1
801037bf:	e8 1c dd ff ff       	call   801014e0 <iinit>
    initlog(ROOTDEV);
801037c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037cb:	e8 90 f3 ff ff       	call   80102b60 <initlog>
801037d0:	83 c4 10             	add    $0x10,%esp
}
801037d3:	c9                   	leave  
801037d4:	c3                   	ret    
801037d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037e0 <pinit>:
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037e6:	68 75 7a 10 80       	push   $0x80107a75
801037eb:	68 20 2d 11 80       	push   $0x80112d20
801037f0:	e8 9b 0f 00 00       	call   80104790 <initlock>
}
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	c9                   	leave  
801037f9:	c3                   	ret    
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103800 <mycpu>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103805:	9c                   	pushf  
80103806:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103807:	f6 c4 02             	test   $0x2,%ah
8010380a:	75 5e                	jne    8010386a <mycpu+0x6a>
  apicid = lapicid();
8010380c:	e8 7f ef ff ff       	call   80102790 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103811:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103817:	85 f6                	test   %esi,%esi
80103819:	7e 42                	jle    8010385d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010381b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103822:	39 d0                	cmp    %edx,%eax
80103824:	74 30                	je     80103856 <mycpu+0x56>
80103826:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010382b:	31 d2                	xor    %edx,%edx
8010382d:	8d 76 00             	lea    0x0(%esi),%esi
80103830:	83 c2 01             	add    $0x1,%edx
80103833:	39 f2                	cmp    %esi,%edx
80103835:	74 26                	je     8010385d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103837:	0f b6 19             	movzbl (%ecx),%ebx
8010383a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103840:	39 c3                	cmp    %eax,%ebx
80103842:	75 ec                	jne    80103830 <mycpu+0x30>
80103844:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010384a:	05 80 27 11 80       	add    $0x80112780,%eax
}
8010384f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103852:	5b                   	pop    %ebx
80103853:	5e                   	pop    %esi
80103854:	5d                   	pop    %ebp
80103855:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103856:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010385b:	eb f2                	jmp    8010384f <mycpu+0x4f>
  panic("unknown apicid\n");
8010385d:	83 ec 0c             	sub    $0xc,%esp
80103860:	68 7c 7a 10 80       	push   $0x80107a7c
80103865:	e8 26 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010386a:	83 ec 0c             	sub    $0xc,%esp
8010386d:	68 88 7b 10 80       	push   $0x80107b88
80103872:	e8 19 cb ff ff       	call   80100390 <panic>
80103877:	89 f6                	mov    %esi,%esi
80103879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103880 <cpuid>:
cpuid() {
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103886:	e8 75 ff ff ff       	call   80103800 <mycpu>
8010388b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103890:	c9                   	leave  
  return mycpu()-cpus;
80103891:	c1 f8 04             	sar    $0x4,%eax
80103894:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010389a:	c3                   	ret    
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038a0 <myproc>:
myproc(void) {
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	53                   	push   %ebx
801038a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038a7:	e8 54 0f 00 00       	call   80104800 <pushcli>
  c = mycpu();
801038ac:	e8 4f ff ff ff       	call   80103800 <mycpu>
  p = c->proc;
801038b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038b7:	e8 84 0f 00 00       	call   80104840 <popcli>
}
801038bc:	83 c4 04             	add    $0x4,%esp
801038bf:	89 d8                	mov    %ebx,%eax
801038c1:	5b                   	pop    %ebx
801038c2:	5d                   	pop    %ebp
801038c3:	c3                   	ret    
801038c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038d0 <allocpid>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	bb 04 a0 10 80       	mov    $0x8010a004,%ebx
801038d9:	83 ec 10             	sub    $0x10,%esp
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pid = nextpid;
801038e0:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  int ret_val = 1;
801038e5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
  }while(!cas(&nextpid, pid, pid + 1));
801038ec:	8d 50 01             	lea    0x1(%eax),%edx
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801038ef:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801038f3:	74 07                	je     801038fc <pass462>
801038f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

801038fc <pass462>:
801038fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
801038ff:	85 d2                	test   %edx,%edx
80103901:	74 dd                	je     801038e0 <allocpid+0x10>
}
80103903:	83 c4 10             	add    $0x10,%esp
80103906:	5b                   	pop    %ebx
80103907:	5d                   	pop    %ebp
80103908:	c3                   	ret    
80103909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103910 <userinit>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
80103915:	83 ec 10             	sub    $0x10,%esp
  p = allocproc();
80103918:	e8 43 fd ff ff       	call   80103660 <allocproc>
8010391d:	89 c6                	mov    %eax,%esi
  initproc = p;
8010391f:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103924:	e8 57 39 00 00       	call   80107280 <setupkvm>
80103929:	85 c0                	test   %eax,%eax
8010392b:	89 46 04             	mov    %eax,0x4(%esi)
8010392e:	0f 84 e5 00 00 00    	je     80103a19 <pass562+0x29>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103934:	83 ec 04             	sub    $0x4,%esp
  if(!cas((int*)&(p->state), EMBRYO, RUNNABLE)){
80103937:	8d 5e 0c             	lea    0xc(%esi),%ebx
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010393a:	68 2c 00 00 00       	push   $0x2c
8010393f:	68 60 a4 10 80       	push   $0x8010a460
80103944:	50                   	push   %eax
80103945:	e8 16 36 00 00       	call   80106f60 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010394a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010394d:	c7 06 00 10 00 00    	movl   $0x1000,(%esi)
  memset(p->tf, 0, sizeof(*p->tf));
80103953:	6a 4c                	push   $0x4c
80103955:	6a 00                	push   $0x0
80103957:	ff 76 18             	pushl  0x18(%esi)
8010395a:	e8 81 10 00 00       	call   801049e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010395f:	8b 46 18             	mov    0x18(%esi),%eax
80103962:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103967:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010396c:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010396f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103973:	8b 46 18             	mov    0x18(%esi),%eax
80103976:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010397a:	8b 46 18             	mov    0x18(%esi),%eax
8010397d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103981:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103985:	8b 46 18             	mov    0x18(%esi),%eax
80103988:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010398c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103990:	8b 46 18             	mov    0x18(%esi),%eax
80103993:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010399a:	8b 46 18             	mov    0x18(%esi),%eax
8010399d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039a4:	8b 46 18             	mov    0x18(%esi),%eax
801039a7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039ae:	8d 46 6c             	lea    0x6c(%esi),%eax
801039b1:	6a 10                	push   $0x10
801039b3:	68 a5 7a 10 80       	push   $0x80107aa5
801039b8:	50                   	push   %eax
801039b9:	e8 02 12 00 00       	call   80104bc0 <safestrcpy>
  p->cwd = namei("/");
801039be:	c7 04 24 ae 7a 10 80 	movl   $0x80107aae,(%esp)
801039c5:	e8 76 e5 ff ff       	call   80101f40 <namei>
801039ca:	89 46 68             	mov    %eax,0x68(%esi)
  pushcli();
801039cd:	e8 2e 0e 00 00       	call   80104800 <pushcli>
  int ret_val = 1;
801039d2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801039d9:	b8 02 00 00 00       	mov    $0x2,%eax
801039de:	ba 05 00 00 00       	mov    $0x5,%edx
801039e3:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801039e7:	74 07                	je     801039f0 <pass562>
801039e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

801039f0 <pass562>:
  if(!cas((int*)&(p->state), EMBRYO, RUNNABLE)){
801039f0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801039f3:	83 c4 10             	add    $0x10,%esp
801039f6:	85 db                	test   %ebx,%ebx
801039f8:	74 2c                	je     80103a26 <pass562+0x36>
  cprintf("should br runnable %d", p->state);
801039fa:	83 ec 08             	sub    $0x8,%esp
801039fd:	ff 76 0c             	pushl  0xc(%esi)
80103a00:	68 b0 7a 10 80       	push   $0x80107ab0
80103a05:	e8 56 cc ff ff       	call   80100660 <cprintf>
  popcli();
80103a0a:	e8 31 0e 00 00       	call   80104840 <popcli>
}
80103a0f:	83 c4 10             	add    $0x10,%esp
80103a12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a15:	5b                   	pop    %ebx
80103a16:	5e                   	pop    %esi
80103a17:	5d                   	pop    %ebp
80103a18:	c3                   	ret    
    panic("userinit: out of memory?");
80103a19:	83 ec 0c             	sub    $0xc,%esp
80103a1c:	68 8c 7a 10 80       	push   $0x80107a8c
80103a21:	e8 6a c9 ff ff       	call   80100390 <panic>
     panic("err in userinit: np state not embryo");
80103a26:	83 ec 0c             	sub    $0xc,%esp
80103a29:	68 b0 7b 10 80       	push   $0x80107bb0
80103a2e:	e8 5d c9 ff ff       	call   80100390 <panic>
80103a33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a40 <growproc>:
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	56                   	push   %esi
80103a44:	53                   	push   %ebx
80103a45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a48:	e8 b3 0d 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103a4d:	e8 ae fd ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103a52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a58:	e8 e3 0d 00 00       	call   80104840 <popcli>
  if(n > 0){
80103a5d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103a60:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a62:	7f 1c                	jg     80103a80 <growproc+0x40>
  } else if(n < 0){
80103a64:	75 3a                	jne    80103aa0 <growproc+0x60>
  switchuvm(curproc);
80103a66:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a69:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a6b:	53                   	push   %ebx
80103a6c:	e8 df 33 00 00       	call   80106e50 <switchuvm>
  return 0;
80103a71:	83 c4 10             	add    $0x10,%esp
80103a74:	31 c0                	xor    %eax,%eax
}
80103a76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a79:	5b                   	pop    %ebx
80103a7a:	5e                   	pop    %esi
80103a7b:	5d                   	pop    %ebp
80103a7c:	c3                   	ret    
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a80:	83 ec 04             	sub    $0x4,%esp
80103a83:	01 c6                	add    %eax,%esi
80103a85:	56                   	push   %esi
80103a86:	50                   	push   %eax
80103a87:	ff 73 04             	pushl  0x4(%ebx)
80103a8a:	e8 11 36 00 00       	call   801070a0 <allocuvm>
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	85 c0                	test   %eax,%eax
80103a94:	75 d0                	jne    80103a66 <growproc+0x26>
      return -1;
80103a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a9b:	eb d9                	jmp    80103a76 <growproc+0x36>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aa0:	83 ec 04             	sub    $0x4,%esp
80103aa3:	01 c6                	add    %eax,%esi
80103aa5:	56                   	push   %esi
80103aa6:	50                   	push   %eax
80103aa7:	ff 73 04             	pushl  0x4(%ebx)
80103aaa:	e8 21 37 00 00       	call   801071d0 <deallocuvm>
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 b0                	jne    80103a66 <growproc+0x26>
80103ab6:	eb de                	jmp    80103a96 <growproc+0x56>
80103ab8:	90                   	nop
80103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ac0 <fork>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	57                   	push   %edi
80103ac4:	56                   	push   %esi
80103ac5:	53                   	push   %ebx
80103ac6:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80103ac9:	e8 32 0d 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103ace:	e8 2d fd ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103ad3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad9:	e8 62 0d 00 00       	call   80104840 <popcli>
  if((np = allocproc()) == 0){
80103ade:	e8 7d fb ff ff       	call   80103660 <allocproc>
80103ae3:	85 c0                	test   %eax,%eax
80103ae5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103ae8:	0f 84 fa 00 00 00    	je     80103be8 <pass864+0x19>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103aee:	83 ec 08             	sub    $0x8,%esp
80103af1:	ff 33                	pushl  (%ebx)
80103af3:	ff 73 04             	pushl  0x4(%ebx)
80103af6:	89 c7                	mov    %eax,%edi
80103af8:	e8 53 38 00 00       	call   80107350 <copyuvm>
80103afd:	83 c4 10             	add    $0x10,%esp
80103b00:	85 c0                	test   %eax,%eax
80103b02:	89 47 04             	mov    %eax,0x4(%edi)
80103b05:	0f 84 e4 00 00 00    	je     80103bef <pass864+0x20>
  np->sz = curproc->sz;
80103b0b:	8b 03                	mov    (%ebx),%eax
80103b0d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  *np->tf = *curproc->tf;
80103b10:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103b15:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103b17:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103b1a:	8b 7a 18             	mov    0x18(%edx),%edi
80103b1d:	8b 73 18             	mov    0x18(%ebx),%esi
80103b20:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  copySigHandlers((void**)&np->sig_handlers, (void**)&curproc->sig_handlers);
80103b22:	8d b3 84 00 00 00    	lea    0x84(%ebx),%esi
80103b28:	8d 8a 84 00 00 00    	lea    0x84(%edx),%ecx
  np->sigmask = curproc->sigmask;
80103b2e:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103b34:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
}

void 
copySigHandlers(void** new_sighandlers, void** old_sighandlers) {
  int i;
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80103b3a:	31 c0                	xor    %eax,%eax
80103b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    new_sighandlers[i] = old_sighandlers[i];
80103b40:	8b 14 86             	mov    (%esi,%eax,4),%edx
80103b43:	89 14 81             	mov    %edx,(%ecx,%eax,4)
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80103b46:	83 c0 01             	add    $0x1,%eax
80103b49:	83 f8 20             	cmp    $0x20,%eax
80103b4c:	75 f2                	jne    80103b40 <fork+0x80>
  np->tf->eax = 0;
80103b4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  for(i = 0; i < NOFILE; i++)
80103b51:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b53:	8b 40 18             	mov    0x18(%eax),%eax
80103b56:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103b5d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103b60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b64:	85 c0                	test   %eax,%eax
80103b66:	74 13                	je     80103b7b <fork+0xbb>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b68:	83 ec 0c             	sub    $0xc,%esp
80103b6b:	50                   	push   %eax
80103b6c:	e8 df d2 ff ff       	call   80100e50 <filedup>
80103b71:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80103b74:	83 c4 10             	add    $0x10,%esp
80103b77:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b7b:	83 c6 01             	add    $0x1,%esi
80103b7e:	83 fe 10             	cmp    $0x10,%esi
80103b81:	75 dd                	jne    80103b60 <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103b83:	83 ec 0c             	sub    $0xc,%esp
80103b86:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b8c:	e8 1f db ff ff       	call   801016b0 <idup>
80103b91:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b9d:	6a 10                	push   $0x10
80103b9f:	53                   	push   %ebx
  if(!cas((int*)(&np->state), EMBRYO, RUNNABLE))
80103ba0:	8d 5f 0c             	lea    0xc(%edi),%ebx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ba3:	50                   	push   %eax
80103ba4:	e8 17 10 00 00       	call   80104bc0 <safestrcpy>
  pid = np->pid;
80103ba9:	8b 77 10             	mov    0x10(%edi),%esi
  pushcli();
80103bac:	e8 4f 0c 00 00       	call   80104800 <pushcli>
  int ret_val = 1;
80103bb1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103bb8:	b8 02 00 00 00       	mov    $0x2,%eax
80103bbd:	ba 05 00 00 00       	mov    $0x5,%edx
80103bc2:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103bc6:	74 07                	je     80103bcf <pass864>
80103bc8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103bcf <pass864>:
  if(!cas((int*)(&np->state), EMBRYO, RUNNABLE))
80103bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103bd2:	83 c4 10             	add    $0x10,%esp
80103bd5:	85 c0                	test   %eax,%eax
80103bd7:	74 3c                	je     80103c15 <pass864+0x46>
  popcli();
80103bd9:	e8 62 0c 00 00       	call   80104840 <popcli>
}
80103bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103be1:	89 f0                	mov    %esi,%eax
80103be3:	5b                   	pop    %ebx
80103be4:	5e                   	pop    %esi
80103be5:	5f                   	pop    %edi
80103be6:	5d                   	pop    %ebp
80103be7:	c3                   	ret    
    return -1;
80103be8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103bed:	eb ef                	jmp    80103bde <pass864+0xf>
    kfree(np->kstack);
80103bef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80103bf2:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103bf5:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103bfa:	ff 73 08             	pushl  0x8(%ebx)
80103bfd:	e8 6e e7 ff ff       	call   80102370 <kfree>
    np->kstack = 0;
80103c02:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103c09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c10:	83 c4 10             	add    $0x10,%esp
80103c13:	eb c9                	jmp    80103bde <pass864+0xf>
    panic("err in fork: np state npt embryo");
80103c15:	83 ec 0c             	sub    $0xc,%esp
80103c18:	68 d8 7b 10 80       	push   $0x80107bd8
80103c1d:	e8 6e c7 ff ff       	call   80100390 <panic>
80103c22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c30 <scheduler>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
80103c39:	e8 c2 fb ff ff       	call   80103800 <mycpu>
  c->proc = 0;
80103c3e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c45:	00 00 00 
  struct cpu *c = mycpu();
80103c48:	89 c6                	mov    %eax,%esi
80103c4a:	8d 40 04             	lea    0x4(%eax),%eax
80103c4d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  asm volatile("sti");
80103c50:	fb                   	sti    
    acquire(&ptable.lock);
80103c51:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c54:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
    acquire(&ptable.lock);
80103c59:	68 20 2d 11 80       	push   $0x80112d20
80103c5e:	e8 6d 0c 00 00       	call   801048d0 <acquire>
80103c63:	83 c4 10             	add    $0x10,%esp
80103c66:	e9 a4 00 00 00       	jmp    80103d0f <pass1026+0x26>
80103c6b:	90                   	nop
80103c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          p->psignals ^= 1 << SIGCONT;
80103c70:	35 00 00 08 00       	xor    $0x80000,%eax
          p->frozen = 0;
80103c75:	c7 87 08 01 00 00 00 	movl   $0x0,0x108(%edi)
80103c7c:	00 00 00 
          p->psignals ^= 1 << SIGCONT;
80103c7f:	89 47 7c             	mov    %eax,0x7c(%edi)
      switchuvm(p);
80103c82:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c85:	89 be ac 00 00 00    	mov    %edi,0xac(%esi)
      switchuvm(p);
80103c8b:	57                   	push   %edi
80103c8c:	e8 bf 31 00 00       	call   80106e50 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c91:	5a                   	pop    %edx
80103c92:	59                   	pop    %ecx
80103c93:	ff 77 1c             	pushl  0x1c(%edi)
80103c96:	ff 75 d4             	pushl  -0x2c(%ebp)
80103c99:	e8 7d 0f 00 00       	call   80104c1b <swtch>
      switchkvm();
80103c9e:	e8 8d 31 00 00       	call   80106e30 <switchkvm>
  int ret_val = 1;
80103ca3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103caa:	b8 04 00 00 00       	mov    $0x4,%eax
80103caf:	b9 03 00 00 00       	mov    $0x3,%ecx
80103cb4:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103cb8:	74 07                	je     80103cc1 <pass1003>
80103cba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103cc1 <pass1003>:
      if (cas((int*)(&p->state), MINUS_SLEEPING, SLEEPING)) {
80103cc1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103cc4:	83 c4 10             	add    $0x10,%esp
80103cc7:	85 db                	test   %ebx,%ebx
80103cc9:	74 2c                	je     80103cf7 <pass1026+0xe>
  int ret_val = 1;
80103ccb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103cd2:	8d 5f 24             	lea    0x24(%edi),%ebx
80103cd5:	b8 01 00 00 00       	mov    $0x1,%eax
80103cda:	31 c9                	xor    %ecx,%ecx
80103cdc:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103ce0:	74 07                	je     80103ce9 <pass1026>
80103ce2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103ce9 <pass1026>:
        if (cas((int*)(&p->killed), 1, 0))
80103ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cec:	85 c0                	test   %eax,%eax
80103cee:	74 07                	je     80103cf7 <pass1026+0xe>
          p->state = RUNNABLE;
80103cf0:	c7 47 0c 05 00 00 00 	movl   $0x5,0xc(%edi)
      c->proc = 0;
80103cf7:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cfe:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d01:	81 c7 0c 01 00 00    	add    $0x10c,%edi
80103d07:	81 ff 54 70 11 80    	cmp    $0x80117054,%edi
80103d0d:	73 61                	jae    80103d70 <pass1064+0x40>
80103d0f:	8d 5f 0c             	lea    0xc(%edi),%ebx
  int ret_val = 1;
80103d12:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103d19:	b8 05 00 00 00       	mov    $0x5,%eax
80103d1e:	ba 07 00 00 00       	mov    $0x7,%edx
80103d23:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103d27:	74 07                	je     80103d30 <pass1064>
80103d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103d30 <pass1064>:
      if(!cas((int*)&(p->state), RUNNABLE, RUNNING)){
80103d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d33:	85 c0                	test   %eax,%eax
80103d35:	74 ca                	je     80103d01 <pass1026+0x18>
      if(p->frozen) 
80103d37:	8b 87 08 01 00 00    	mov    0x108(%edi),%eax
80103d3d:	85 c0                	test   %eax,%eax
80103d3f:	0f 84 3d ff ff ff    	je     80103c82 <scheduler+0x52>
        if(p->psignals & (1 << SIGCONT)) // received cont
80103d45:	8b 47 7c             	mov    0x7c(%edi),%eax
80103d48:	a9 00 00 08 00       	test   $0x80000,%eax
80103d4d:	0f 85 1d ff ff ff    	jne    80103c70 <scheduler+0x40>
          p->state = RUNNABLE;
80103d53:	c7 47 0c 05 00 00 00 	movl   $0x5,0xc(%edi)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d5a:	81 c7 0c 01 00 00    	add    $0x10c,%edi
80103d60:	81 ff 54 70 11 80    	cmp    $0x80117054,%edi
80103d66:	72 a7                	jb     80103d0f <pass1026+0x26>
80103d68:	90                   	nop
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	68 20 2d 11 80       	push   $0x80112d20
80103d78:	e8 13 0c 00 00       	call   80104990 <release>
    sti();
80103d7d:	83 c4 10             	add    $0x10,%esp
80103d80:	e9 cb fe ff ff       	jmp    80103c50 <scheduler+0x20>
80103d85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d90 <sched>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
  pushcli();
80103d95:	e8 66 0a 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103d9a:	e8 61 fa ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103d9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103da5:	e8 96 0a 00 00       	call   80104840 <popcli>
  if(mycpu()->ncli != 1)
80103daa:	e8 51 fa ff ff       	call   80103800 <mycpu>
80103daf:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103db6:	75 41                	jne    80103df9 <sched+0x69>
  if(p->state == RUNNING)
80103db8:	83 7b 0c 07          	cmpl   $0x7,0xc(%ebx)
80103dbc:	74 55                	je     80103e13 <sched+0x83>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dbe:	9c                   	pushf  
80103dbf:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dc0:	f6 c4 02             	test   $0x2,%ah
80103dc3:	75 41                	jne    80103e06 <sched+0x76>
  intena = mycpu()->intena;
80103dc5:	e8 36 fa ff ff       	call   80103800 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dca:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103dcd:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103dd3:	e8 28 fa ff ff       	call   80103800 <mycpu>
80103dd8:	83 ec 08             	sub    $0x8,%esp
80103ddb:	ff 70 04             	pushl  0x4(%eax)
80103dde:	53                   	push   %ebx
80103ddf:	e8 37 0e 00 00       	call   80104c1b <swtch>
  mycpu()->intena = intena;
80103de4:	e8 17 fa ff ff       	call   80103800 <mycpu>
}
80103de9:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103dec:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103df5:	5b                   	pop    %ebx
80103df6:	5e                   	pop    %esi
80103df7:	5d                   	pop    %ebp
80103df8:	c3                   	ret    
    panic("sched locks");
80103df9:	83 ec 0c             	sub    $0xc,%esp
80103dfc:	68 c6 7a 10 80       	push   $0x80107ac6
80103e01:	e8 8a c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103e06:	83 ec 0c             	sub    $0xc,%esp
80103e09:	68 e0 7a 10 80       	push   $0x80107ae0
80103e0e:	e8 7d c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103e13:	83 ec 0c             	sub    $0xc,%esp
80103e16:	68 d2 7a 10 80       	push   $0x80107ad2
80103e1b:	e8 70 c5 ff ff       	call   80100390 <panic>

80103e20 <exit>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	57                   	push   %edi
80103e24:	56                   	push   %esi
80103e25:	53                   	push   %ebx
80103e26:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e29:	e8 d2 09 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103e2e:	e8 cd f9 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103e33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e39:	e8 02 0a 00 00       	call   80104840 <popcli>
  if(curproc == initproc)
80103e3e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103e44:	8d 5e 28             	lea    0x28(%esi),%ebx
80103e47:	8d 7e 68             	lea    0x68(%esi),%edi
80103e4a:	0f 84 f1 00 00 00    	je     80103f41 <exit+0x121>
    if(curproc->ofile[fd]){
80103e50:	8b 03                	mov    (%ebx),%eax
80103e52:	85 c0                	test   %eax,%eax
80103e54:	74 12                	je     80103e68 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103e56:	83 ec 0c             	sub    $0xc,%esp
80103e59:	50                   	push   %eax
80103e5a:	e8 41 d0 ff ff       	call   80100ea0 <fileclose>
      curproc->ofile[fd] = 0;
80103e5f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103e65:	83 c4 10             	add    $0x10,%esp
80103e68:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103e6b:	39 fb                	cmp    %edi,%ebx
80103e6d:	75 e1                	jne    80103e50 <exit+0x30>
  begin_op();
80103e6f:	e8 8c ed ff ff       	call   80102c00 <begin_op>
  iput(curproc->cwd);
80103e74:	83 ec 0c             	sub    $0xc,%esp
80103e77:	ff 76 68             	pushl  0x68(%esi)
80103e7a:	e8 91 d9 ff ff       	call   80101810 <iput>
  end_op();
80103e7f:	e8 ec ed ff ff       	call   80102c70 <end_op>
  curproc->cwd = 0;
80103e84:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103e8b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e92:	e8 39 0a 00 00       	call   801048d0 <acquire>
  wakeup1(curproc->parent);
80103e97:	8b 56 14             	mov    0x14(%esi),%edx
80103e9a:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ea2:	eb 10                	jmp    80103eb4 <exit+0x94>
80103ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea8:	05 0c 01 00 00       	add    $0x10c,%eax
80103ead:	3d 54 70 11 80       	cmp    $0x80117054,%eax
80103eb2:	73 1e                	jae    80103ed2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103eb4:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103eb8:	75 ee                	jne    80103ea8 <exit+0x88>
80103eba:	3b 50 20             	cmp    0x20(%eax),%edx
80103ebd:	75 e9                	jne    80103ea8 <exit+0x88>
      p->state = RUNNABLE;
80103ebf:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec6:	05 0c 01 00 00       	add    $0x10c,%eax
80103ecb:	3d 54 70 11 80       	cmp    $0x80117054,%eax
80103ed0:	72 e2                	jb     80103eb4 <exit+0x94>
      p->parent = initproc;
80103ed2:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ed8:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103edd:	eb 0f                	jmp    80103eee <exit+0xce>
80103edf:	90                   	nop
80103ee0:	81 c2 0c 01 00 00    	add    $0x10c,%edx
80103ee6:	81 fa 54 70 11 80    	cmp    $0x80117054,%edx
80103eec:	73 3a                	jae    80103f28 <exit+0x108>
    if(p->parent == curproc){
80103eee:	39 72 14             	cmp    %esi,0x14(%edx)
80103ef1:	75 ed                	jne    80103ee0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103ef3:	83 7a 0c 08          	cmpl   $0x8,0xc(%edx)
      p->parent = initproc;
80103ef7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103efa:	75 e4                	jne    80103ee0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103efc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f01:	eb 11                	jmp    80103f14 <exit+0xf4>
80103f03:	90                   	nop
80103f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f08:	05 0c 01 00 00       	add    $0x10c,%eax
80103f0d:	3d 54 70 11 80       	cmp    $0x80117054,%eax
80103f12:	73 cc                	jae    80103ee0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103f14:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103f18:	75 ee                	jne    80103f08 <exit+0xe8>
80103f1a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f1d:	75 e9                	jne    80103f08 <exit+0xe8>
      p->state = RUNNABLE;
80103f1f:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
80103f26:	eb e0                	jmp    80103f08 <exit+0xe8>
  curproc->state = ZOMBIE;
80103f28:	c7 46 0c 08 00 00 00 	movl   $0x8,0xc(%esi)
  sched();
80103f2f:	e8 5c fe ff ff       	call   80103d90 <sched>
  panic("zombie exit");
80103f34:	83 ec 0c             	sub    $0xc,%esp
80103f37:	68 01 7b 10 80       	push   $0x80107b01
80103f3c:	e8 4f c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103f41:	83 ec 0c             	sub    $0xc,%esp
80103f44:	68 f4 7a 10 80       	push   $0x80107af4
80103f49:	e8 42 c4 ff ff       	call   80100390 <panic>
80103f4e:	66 90                	xchg   %ax,%ax

80103f50 <yield>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	53                   	push   %ebx
80103f54:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f57:	68 20 2d 11 80       	push   $0x80112d20
80103f5c:	e8 6f 09 00 00       	call   801048d0 <acquire>
  pushcli();
80103f61:	e8 9a 08 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103f66:	e8 95 f8 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103f6b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f71:	e8 ca 08 00 00       	call   80104840 <popcli>
  myproc()->state = RUNNABLE;
80103f76:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f7d:	e8 0e fe ff ff       	call   80103d90 <sched>
  release(&ptable.lock);
80103f82:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f89:	e8 02 0a 00 00       	call   80104990 <release>
}
80103f8e:	83 c4 10             	add    $0x10,%esp
80103f91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f94:	c9                   	leave  
80103f95:	c3                   	ret    
80103f96:	8d 76 00             	lea    0x0(%esi),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <sleep>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	83 ec 1c             	sub    $0x1c,%esp
80103fa9:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103fac:	e8 4f 08 00 00       	call   80104800 <pushcli>
  c = mycpu();
80103fb1:	e8 4a f8 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80103fb6:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80103fbc:	e8 7f 08 00 00       	call   80104840 <popcli>
  if(p == 0)
80103fc1:	85 ff                	test   %edi,%edi
80103fc3:	0f 84 8a 00 00 00    	je     80104053 <pass1508+0x3b>
  if(lk == 0)
80103fc9:	85 f6                	test   %esi,%esi
80103fcb:	0f 84 9c 00 00 00    	je     8010406d <pass1508+0x55>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103fd1:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103fd7:	74 18                	je     80103ff1 <sleep+0x51>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103fd9:	83 ec 0c             	sub    $0xc,%esp
80103fdc:	68 20 2d 11 80       	push   $0x80112d20
80103fe1:	e8 ea 08 00 00       	call   801048d0 <acquire>
    release(lk);
80103fe6:	89 34 24             	mov    %esi,(%esp)
80103fe9:	e8 a2 09 00 00       	call   80104990 <release>
80103fee:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80103ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  int ret_val = 1;
80103ff4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  if(!cas((int*)(&p->state), RUNNING, MINUS_SLEEPING))
80103ffb:	8d 5f 0c             	lea    0xc(%edi),%ebx
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103ffe:	ba 04 00 00 00       	mov    $0x4,%edx
  p->chan = chan;
80104003:	89 47 20             	mov    %eax,0x20(%edi)
80104006:	b8 07 00 00 00       	mov    $0x7,%eax
8010400b:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
8010400f:	74 07                	je     80104018 <pass1508>
80104011:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80104018 <pass1508>:
  if(!cas((int*)(&p->state), RUNNING, MINUS_SLEEPING))
80104018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010401b:	85 c0                	test   %eax,%eax
8010401d:	74 41                	je     80104060 <pass1508+0x48>
  sched();
8010401f:	e8 6c fd ff ff       	call   80103d90 <sched>
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104024:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
  p->chan = 0;
8010402a:	c7 47 20 00 00 00 00 	movl   $0x0,0x20(%edi)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104031:	74 18                	je     8010404b <pass1508+0x33>
    release(&ptable.lock);
80104033:	83 ec 0c             	sub    $0xc,%esp
80104036:	68 20 2d 11 80       	push   $0x80112d20
8010403b:	e8 50 09 00 00       	call   80104990 <release>
    acquire(lk);
80104040:	89 34 24             	mov    %esi,(%esp)
80104043:	e8 88 08 00 00       	call   801048d0 <acquire>
80104048:	83 c4 10             	add    $0x10,%esp
}
8010404b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010404e:	5b                   	pop    %ebx
8010404f:	5e                   	pop    %esi
80104050:	5f                   	pop    %edi
80104051:	5d                   	pop    %ebp
80104052:	c3                   	ret    
    panic("sleep");
80104053:	83 ec 0c             	sub    $0xc,%esp
80104056:	68 0d 7b 10 80       	push   $0x80107b0d
8010405b:	e8 30 c3 ff ff       	call   80100390 <panic>
    panic("cas failed at sleeping, should be running state!");
80104060:	83 ec 0c             	sub    $0xc,%esp
80104063:	68 fc 7b 10 80       	push   $0x80107bfc
80104068:	e8 23 c3 ff ff       	call   80100390 <panic>
    panic("sleep without lk");
8010406d:	83 ec 0c             	sub    $0xc,%esp
80104070:	68 13 7b 10 80       	push   $0x80107b13
80104075:	e8 16 c3 ff ff       	call   80100390 <panic>
8010407a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104080 <wait>:
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	57                   	push   %edi
80104084:	56                   	push   %esi
80104085:	53                   	push   %ebx
80104086:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80104089:	e8 72 07 00 00       	call   80104800 <pushcli>
  c = mycpu();
8010408e:	e8 6d f7 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104093:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
80104099:	e8 a2 07 00 00       	call   80104840 <popcli>
  acquire(&ptable.lock);
8010409e:	83 ec 0c             	sub    $0xc,%esp
801040a1:	68 20 2d 11 80       	push   $0x80112d20
801040a6:	e8 25 08 00 00       	call   801048d0 <acquire>
801040ab:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801040ae:	31 d2                	xor    %edx,%edx
801040b0:	31 c9                	xor    %ecx,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b2:	be 54 2d 11 80       	mov    $0x80112d54,%esi
801040b7:	b8 08 00 00 00       	mov    $0x8,%eax
801040bc:	eb 10                	jmp    801040ce <wait+0x4e>
801040be:	66 90                	xchg   %ax,%ax
801040c0:	81 c6 0c 01 00 00    	add    $0x10c,%esi
801040c6:	81 fe 54 70 11 80    	cmp    $0x80117054,%esi
801040cc:	73 36                	jae    80104104 <pass1654+0x1a>
      if(p->parent != curproc)
801040ce:	39 7e 14             	cmp    %edi,0x14(%esi)
801040d1:	75 ed                	jne    801040c0 <wait+0x40>
  int ret_val = 1;
801040d3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801040da:	8d 5e 0c             	lea    0xc(%esi),%ebx
801040dd:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801040e1:	74 07                	je     801040ea <pass1654>
801040e3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

801040ea <pass1654>:
      if(cas((int*)&(p->state), ZOMBIE, UNUSED)){
801040ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801040ed:	85 c9                	test   %ecx,%ecx
801040ef:	75 3f                	jne    80104130 <pass1654+0x46>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040f1:	81 c6 0c 01 00 00    	add    $0x10c,%esi
      havekids = 1;
801040f7:	b9 01 00 00 00       	mov    $0x1,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040fc:	81 fe 54 70 11 80    	cmp    $0x80117054,%esi
80104102:	72 ca                	jb     801040ce <wait+0x4e>
    if(!havekids || curproc->killed){
80104104:	85 c9                	test   %ecx,%ecx
80104106:	74 78                	je     80104180 <pass1654+0x96>
80104108:	8b 47 24             	mov    0x24(%edi),%eax
8010410b:	85 c0                	test   %eax,%eax
8010410d:	75 71                	jne    80104180 <pass1654+0x96>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010410f:	83 ec 08             	sub    $0x8,%esp
80104112:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104115:	68 20 2d 11 80       	push   $0x80112d20
8010411a:	57                   	push   %edi
8010411b:	e8 80 fe ff ff       	call   80103fa0 <sleep>
    havekids = 0;
80104120:	83 c4 10             	add    $0x10,%esp
80104123:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80104126:	eb 88                	jmp    801040b0 <wait+0x30>
80104128:	90                   	nop
80104129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104130:	83 ec 0c             	sub    $0xc,%esp
80104133:	ff 76 08             	pushl  0x8(%esi)
        pid = p->pid;
80104136:	8b 5e 10             	mov    0x10(%esi),%ebx
        kfree(p->kstack);
80104139:	e8 32 e2 ff ff       	call   80102370 <kfree>
        freevm(p->pgdir);
8010413e:	5a                   	pop    %edx
8010413f:	ff 76 04             	pushl  0x4(%esi)
        p->kstack = 0;
80104142:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
        freevm(p->pgdir);
80104149:	e8 b2 30 00 00       	call   80107200 <freevm>
        release(&ptable.lock);
8010414e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80104155:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
        p->parent = 0;
8010415c:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
        p->name[0] = 0;
80104163:	c6 46 6c 00          	movb   $0x0,0x6c(%esi)
        p->killed = 0;
80104167:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
        release(&ptable.lock);
8010416e:	e8 1d 08 00 00       	call   80104990 <release>
        return pid;
80104173:	83 c4 10             	add    $0x10,%esp
}
80104176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104179:	89 d8                	mov    %ebx,%eax
8010417b:	5b                   	pop    %ebx
8010417c:	5e                   	pop    %esi
8010417d:	5f                   	pop    %edi
8010417e:	5d                   	pop    %ebp
8010417f:	c3                   	ret    
      release(&ptable.lock);
80104180:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104183:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&ptable.lock);
80104188:	68 20 2d 11 80       	push   $0x80112d20
8010418d:	e8 fe 07 00 00       	call   80104990 <release>
      return -1;
80104192:	83 c4 10             	add    $0x10,%esp
80104195:	eb df                	jmp    80104176 <pass1654+0x8c>
80104197:	89 f6                	mov    %esi,%esi
80104199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041a0 <wakeup>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 10             	sub    $0x10,%esp
801041a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041aa:	68 20 2d 11 80       	push   $0x80112d20
801041af:	e8 1c 07 00 00       	call   801048d0 <acquire>
801041b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801041bc:	eb 0e                	jmp    801041cc <wakeup+0x2c>
801041be:	66 90                	xchg   %ax,%ax
801041c0:	05 0c 01 00 00       	add    $0x10c,%eax
801041c5:	3d 54 70 11 80       	cmp    $0x80117054,%eax
801041ca:	73 1e                	jae    801041ea <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801041cc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801041d0:	75 ee                	jne    801041c0 <wakeup+0x20>
801041d2:	3b 58 20             	cmp    0x20(%eax),%ebx
801041d5:	75 e9                	jne    801041c0 <wakeup+0x20>
      p->state = RUNNABLE;
801041d7:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041de:	05 0c 01 00 00       	add    $0x10c,%eax
801041e3:	3d 54 70 11 80       	cmp    $0x80117054,%eax
801041e8:	72 e2                	jb     801041cc <wakeup+0x2c>
  release(&ptable.lock);
801041ea:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801041f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041f4:	c9                   	leave  
  release(&ptable.lock);
801041f5:	e9 96 07 00 00       	jmp    80104990 <release>
801041fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104200 <kill>:
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104206:	8b 55 08             	mov    0x8(%ebp),%edx
  if(signum < SIG_MIN || signum > SIG_MAX)
80104209:	83 f9 1f             	cmp    $0x1f,%ecx
8010420c:	77 32                	ja     80104240 <kill+0x40>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010420e:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104213:	eb 0f                	jmp    80104224 <kill+0x24>
80104215:	8d 76 00             	lea    0x0(%esi),%esi
80104218:	05 0c 01 00 00       	add    $0x10c,%eax
8010421d:	3d 54 70 11 80       	cmp    $0x80117054,%eax
80104222:	73 1c                	jae    80104240 <kill+0x40>
    if(p->pid == pid){
80104224:	39 50 10             	cmp    %edx,0x10(%eax)
80104227:	75 ef                	jne    80104218 <kill+0x18>
      p->psignals |= 1 << signum;
80104229:	ba 01 00 00 00       	mov    $0x1,%edx
8010422e:	d3 e2                	shl    %cl,%edx
80104230:	09 50 7c             	or     %edx,0x7c(%eax)
      return 0;
80104233:	31 c0                	xor    %eax,%eax
}
80104235:	5d                   	pop    %ebp
80104236:	c3                   	ret    
80104237:	89 f6                	mov    %esi,%esi
80104239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104245:	5d                   	pop    %ebp
80104246:	c3                   	ret    
80104247:	89 f6                	mov    %esi,%esi
80104249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104250 <sigprocmask>:
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	53                   	push   %ebx
80104254:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104257:	e8 a4 05 00 00       	call   80104800 <pushcli>
  c = mycpu();
8010425c:	e8 9f f5 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104261:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104267:	e8 d4 05 00 00       	call   80104840 <popcli>
  curproc->sigmask = mask;
8010426c:	8b 55 08             	mov    0x8(%ebp),%edx
  uint old = curproc -> sigmask;
8010426f:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  curproc->sigmask = mask;
80104275:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
}
8010427b:	83 c4 04             	add    $0x4,%esp
8010427e:	5b                   	pop    %ebx
8010427f:	5d                   	pop    %ebp
80104280:	c3                   	ret    
80104281:	eb 0d                	jmp    80104290 <procdump>
80104283:	90                   	nop
80104284:	90                   	nop
80104285:	90                   	nop
80104286:	90                   	nop
80104287:	90                   	nop
80104288:	90                   	nop
80104289:	90                   	nop
8010428a:	90                   	nop
8010428b:	90                   	nop
8010428c:	90                   	nop
8010428d:	90                   	nop
8010428e:	90                   	nop
8010428f:	90                   	nop

80104290 <procdump>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
80104296:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104299:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010429e:	83 ec 3c             	sub    $0x3c,%esp
801042a1:	eb 27                	jmp    801042ca <procdump+0x3a>
801042a3:	90                   	nop
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n");
801042a8:	83 ec 0c             	sub    $0xc,%esp
801042ab:	68 63 7f 10 80       	push   $0x80107f63
801042b0:	e8 ab c3 ff ff       	call   80100660 <cprintf>
801042b5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b8:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
801042be:	81 fb 54 70 11 80    	cmp    $0x80117054,%ebx
801042c4:	0f 83 86 00 00 00    	jae    80104350 <procdump+0xc0>
    if(p->state == UNUSED)
801042ca:	8b 43 0c             	mov    0xc(%ebx),%eax
801042cd:	85 c0                	test   %eax,%eax
801042cf:	74 e7                	je     801042b8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042d1:	83 f8 09             	cmp    $0x9,%eax
      state = "???";
801042d4:	ba 24 7b 10 80       	mov    $0x80107b24,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042d9:	77 11                	ja     801042ec <procdump+0x5c>
801042db:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
      state = "???";
801042e2:	b8 24 7b 10 80       	mov    $0x80107b24,%eax
801042e7:	85 d2                	test   %edx,%edx
801042e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042ec:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042ef:	50                   	push   %eax
801042f0:	52                   	push   %edx
801042f1:	ff 73 10             	pushl  0x10(%ebx)
801042f4:	68 28 7b 10 80       	push   $0x80107b28
801042f9:	e8 62 c3 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801042fe:	83 c4 10             	add    $0x10,%esp
80104301:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104305:	75 a1                	jne    801042a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104307:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010430a:	83 ec 08             	sub    $0x8,%esp
8010430d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104310:	50                   	push   %eax
80104311:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104314:	8b 40 0c             	mov    0xc(%eax),%eax
80104317:	83 c0 08             	add    $0x8,%eax
8010431a:	50                   	push   %eax
8010431b:	e8 90 04 00 00       	call   801047b0 <getcallerpcs>
80104320:	83 c4 10             	add    $0x10,%esp
80104323:	90                   	nop
80104324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104328:	8b 17                	mov    (%edi),%edx
8010432a:	85 d2                	test   %edx,%edx
8010432c:	0f 84 76 ff ff ff    	je     801042a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104332:	83 ec 08             	sub    $0x8,%esp
80104335:	83 c7 04             	add    $0x4,%edi
80104338:	52                   	push   %edx
80104339:	68 61 75 10 80       	push   $0x80107561
8010433e:	e8 1d c3 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104343:	83 c4 10             	add    $0x10,%esp
80104346:	39 fe                	cmp    %edi,%esi
80104348:	75 de                	jne    80104328 <procdump+0x98>
8010434a:	e9 59 ff ff ff       	jmp    801042a8 <procdump+0x18>
8010434f:	90                   	nop
}
80104350:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104353:	5b                   	pop    %ebx
80104354:	5e                   	pop    %esi
80104355:	5f                   	pop    %edi
80104356:	5d                   	pop    %ebp
80104357:	c3                   	ret    
80104358:	90                   	nop
80104359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104360 <sigkill_handler>:
sigkill_handler(){
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104367:	e8 94 04 00 00       	call   80104800 <pushcli>
  c = mycpu();
8010436c:	e8 8f f4 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104371:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104377:	e8 c4 04 00 00       	call   80104840 <popcli>
  if(p->state == SLEEPING)
8010437c:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
  p->killed = 1;
80104380:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
  if(p->state == SLEEPING)
80104387:	75 07                	jne    80104390 <sigkill_handler+0x30>
    p->state = RUNNABLE;
80104389:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
}
80104390:	83 c4 04             	add    $0x4,%esp
80104393:	31 c0                	xor    %eax,%eax
80104395:	5b                   	pop    %ebx
80104396:	5d                   	pop    %ebp
80104397:	c3                   	ret    
80104398:	90                   	nop
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043a0 <sigstop_handler>:
sigstop_handler(){
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801043a7:	e8 54 04 00 00       	call   80104800 <pushcli>
  c = mycpu();
801043ac:	e8 4f f4 ff ff       	call   80103800 <mycpu>
  p = c->proc;
801043b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043b7:	e8 84 04 00 00       	call   80104840 <popcli>
801043bc:	b8 01 00 00 00       	mov    $0x1,%eax
  if(p-> state == SLEEPING)
801043c1:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801043c5:	74 0c                	je     801043d3 <sigstop_handler+0x33>
  p->frozen = 1;
801043c7:	c7 83 08 01 00 00 01 	movl   $0x1,0x108(%ebx)
801043ce:	00 00 00 
  return 0;
801043d1:	31 c0                	xor    %eax,%eax
}
801043d3:	83 c4 04             	add    $0x4,%esp
801043d6:	5b                   	pop    %ebx
801043d7:	5d                   	pop    %ebp
801043d8:	c3                   	ret    
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043e0 <sigcont_handler>:
sigcont_handler(){
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
801043e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801043e7:	e8 14 04 00 00       	call   80104800 <pushcli>
  c = mycpu();
801043ec:	e8 0f f4 ff ff       	call   80103800 <mycpu>
  p = c->proc;
801043f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043f7:	e8 44 04 00 00       	call   80104840 <popcli>
}
801043fc:	31 c0                	xor    %eax,%eax
  p->frozen = 0;
801043fe:	c7 83 08 01 00 00 00 	movl   $0x0,0x108(%ebx)
80104405:	00 00 00 
}
80104408:	83 c4 04             	add    $0x4,%esp
8010440b:	5b                   	pop    %ebx
8010440c:	5d                   	pop    %ebp
8010440d:	c3                   	ret    
8010440e:	66 90                	xchg   %ax,%ax

80104410 <copySigHandlers>:
copySigHandlers(void** new_sighandlers, void** old_sighandlers) {
80104410:	55                   	push   %ebp
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80104411:	31 c0                	xor    %eax,%eax
copySigHandlers(void** new_sighandlers, void** old_sighandlers) {
80104413:	89 e5                	mov    %esp,%ebp
80104415:	53                   	push   %ebx
80104416:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104419:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    new_sighandlers[i] = old_sighandlers[i];
80104420:	8b 14 81             	mov    (%ecx,%eax,4),%edx
80104423:	89 14 83             	mov    %edx,(%ebx,%eax,4)
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80104426:	83 c0 01             	add    $0x1,%eax
80104429:	83 f8 20             	cmp    $0x20,%eax
8010442c:	75 f2                	jne    80104420 <copySigHandlers+0x10>
  }
}
8010442e:	5b                   	pop    %ebx
8010442f:	5d                   	pop    %ebp
80104430:	c3                   	ret    
80104431:	eb 0d                	jmp    80104440 <sigaction>
80104433:	90                   	nop
80104434:	90                   	nop
80104435:	90                   	nop
80104436:	90                   	nop
80104437:	90                   	nop
80104438:	90                   	nop
80104439:	90                   	nop
8010443a:	90                   	nop
8010443b:	90                   	nop
8010443c:	90                   	nop
8010443d:	90                   	nop
8010443e:	90                   	nop
8010443f:	90                   	nop

80104440 <sigaction>:

int 
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact) 
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	56                   	push   %esi
80104445:	53                   	push   %ebx
80104446:	83 ec 0c             	sub    $0xc,%esp
80104449:	8b 75 08             	mov    0x8(%ebp),%esi
8010444c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  pushcli();
8010444f:	e8 ac 03 00 00       	call   80104800 <pushcli>
  c = mycpu();
80104454:	e8 a7 f3 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104459:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
8010445f:	e8 dc 03 00 00       	call   80104840 <popcli>
  struct proc* curproc = myproc();

  if(signum == SIGSTOP || signum == SIGKILL) // they cannot be modified, blocked or ignored
80104464:	8d 56 f7             	lea    -0x9(%esi),%edx
80104467:	b8 01 00 00 00       	mov    $0x1,%eax
8010446c:	83 e2 f7             	and    $0xfffffff7,%edx
8010446f:	74 2f                	je     801044a0 <sigaction+0x60>
    return 1;

  if(oldact != null) {
80104471:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104474:	8d 84 b7 84 00 00 00 	lea    0x84(%edi,%esi,4),%eax
8010447b:	85 c9                	test   %ecx,%ecx
8010447d:	74 0d                	je     8010448c <sigaction+0x4c>
    oldact->sa_handler = ((struct sigaction*)&curproc->sig_handlers[signum])->sa_handler;              // old handler
8010447f:	8b 10                	mov    (%eax),%edx
80104481:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104484:	89 11                	mov    %edx,(%ecx)
    oldact->sigmask = ((struct sigaction*)&curproc->sig_handlers[signum])->sigmask;                    // old sigmask
80104486:	8b 50 04             	mov    0x4(%eax),%edx
80104489:	89 51 04             	mov    %edx,0x4(%ecx)
  }

  ((struct sigaction*)&curproc->sig_handlers[signum])->sa_handler = act->sa_handler;
8010448c:	8b 13                	mov    (%ebx),%edx
8010448e:	89 10                	mov    %edx,(%eax)
  ((struct sigaction*)&curproc->sig_handlers[signum])->sigmask = act->sigmask;
80104490:	8b 53 04             	mov    0x4(%ebx),%edx
80104493:	89 50 04             	mov    %edx,0x4(%eax)

  if(act->sigmask <= 0) // sigmask must be positive
80104496:	8b 53 04             	mov    0x4(%ebx),%edx
80104499:	31 c0                	xor    %eax,%eax
8010449b:	85 d2                	test   %edx,%edx
8010449d:	0f 94 c0             	sete   %al
    return 1;

  return 0;
}
801044a0:	83 c4 0c             	add    $0xc,%esp
801044a3:	5b                   	pop    %ebx
801044a4:	5e                   	pop    %esi
801044a5:	5f                   	pop    %edi
801044a6:	5d                   	pop    %ebp
801044a7:	c3                   	ret    
801044a8:	90                   	nop
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044b0 <user_handler>:

void
user_handler(struct proc* p, uint sig)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	57                   	push   %edi
801044b4:	56                   	push   %esi
801044b5:	53                   	push   %ebx
801044b6:	83 ec 10             	sub    $0x10,%esp
801044b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044bc:	8b 75 0c             	mov    0xc(%ebp),%esi

    char *sigret_caller_addr;
    uint sigret_size;

    // back-up trap frame
    memmove(p->kstack, p->tf, sizeof(*p->tf));
801044bf:	6a 4c                	push   $0x4c
801044c1:	ff 73 18             	pushl  0x18(%ebx)
801044c4:	ff 73 08             	pushl  0x8(%ebx)
801044c7:	e8 c4 05 00 00       	call   80104a90 <memmove>
    p->tf_backup = (struct trapframe*)p->kstack;
801044cc:	8b 43 08             	mov    0x8(%ebx),%eax

    // changing the user space stack
    sigret_size = sigret_caller_end - sigret_caller_start;
    p->tf->esp = p->tf->esp - sigret_size; // make room for sigret code
801044cf:	8b 53 18             	mov    0x18(%ebx),%edx

    sigret_caller_addr = (char*)p->tf->esp;

    memmove((char*)p->tf->esp, sigret_caller_start, sigret_size);
801044d2:	83 c4 0c             	add    $0xc,%esp
    p->tf_backup = (struct trapframe*)p->kstack;
801044d5:	89 83 04 01 00 00    	mov    %eax,0x104(%ebx)
    sigret_size = sigret_caller_end - sigret_caller_start;
801044db:	b8 b8 5c 10 80       	mov    $0x80105cb8,%eax
801044e0:	2d b1 5c 10 80       	sub    $0x80105cb1,%eax
    p->tf->esp = p->tf->esp - sigret_size; // make room for sigret code
801044e5:	29 42 44             	sub    %eax,0x44(%edx)
    sigret_caller_addr = (char*)p->tf->esp;
801044e8:	8b 53 18             	mov    0x18(%ebx),%edx
801044eb:	8b 7a 44             	mov    0x44(%edx),%edi
    memmove((char*)p->tf->esp, sigret_caller_start, sigret_size);
801044ee:	50                   	push   %eax
801044ef:	68 b1 5c 10 80       	push   $0x80105cb1
801044f4:	57                   	push   %edi
801044f5:	e8 96 05 00 00       	call   80104a90 <memmove>

    // pushing signum
    p->tf->esp = p->tf->esp-UINT_SIZE;
801044fa:	8b 43 18             	mov    0x18(%ebx),%eax
    p->tf->esp = p->tf->esp-UINT_SIZE;
    *((uint*)(p->tf->esp)) = (uint)sigret_caller_addr;

    // updating user eip to user handler's address
    p->tf->eip = (uint)&((struct sigaction*)p->sig_handlers[sig])->sa_handler;
    return;
801044fd:	83 c4 10             	add    $0x10,%esp
    p->tf->esp = p->tf->esp-UINT_SIZE;
80104500:	83 68 44 04          	subl   $0x4,0x44(%eax)
    *((uint*)(p->tf->esp)) = sig;
80104504:	8b 43 18             	mov    0x18(%ebx),%eax
80104507:	8b 40 44             	mov    0x44(%eax),%eax
8010450a:	89 30                	mov    %esi,(%eax)
    p->tf->esp = p->tf->esp-UINT_SIZE;
8010450c:	8b 43 18             	mov    0x18(%ebx),%eax
8010450f:	83 68 44 04          	subl   $0x4,0x44(%eax)
    *((uint*)(p->tf->esp)) = (uint)sigret_caller_addr;
80104513:	8b 43 18             	mov    0x18(%ebx),%eax
80104516:	8b 40 44             	mov    0x44(%eax),%eax
80104519:	89 38                	mov    %edi,(%eax)
    p->tf->eip = (uint)&((struct sigaction*)p->sig_handlers[sig])->sa_handler;
8010451b:	8b 94 b3 84 00 00 00 	mov    0x84(%ebx,%esi,4),%edx
80104522:	8b 43 18             	mov    0x18(%ebx),%eax
80104525:	89 50 38             	mov    %edx,0x38(%eax)
}
80104528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010452b:	5b                   	pop    %ebx
8010452c:	5e                   	pop    %esi
8010452d:	5f                   	pop    %edi
8010452e:	5d                   	pop    %ebp
8010452f:	c3                   	ret    

80104530 <handleSignal>:

void
handleSignal (int sig) {
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104538:	e8 c3 02 00 00       	call   80104800 <pushcli>
  c = mycpu();
8010453d:	e8 be f2 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104542:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104548:	e8 f3 02 00 00       	call   80104840 <popcli>
  struct proc *p = myproc();
  if(p->sig_handlers[sig] == SIG_IGN)
8010454d:	8b 84 9e 84 00 00 00 	mov    0x84(%esi,%ebx,4),%eax
80104554:	83 f8 01             	cmp    $0x1,%eax
80104557:	74 11                	je     8010456a <handleSignal+0x3a>
  {
    // do nothing
  }

  else if(p->sig_handlers[sig] == SIG_DFL)
80104559:	85 c0                	test   %eax,%eax
8010455b:	74 1b                	je     80104578 <handleSignal+0x48>
      
    }
  }

  else
    user_handler(p, sig);
8010455d:	83 ec 08             	sub    $0x8,%esp
80104560:	53                   	push   %ebx
80104561:	56                   	push   %esi
80104562:	e8 49 ff ff ff       	call   801044b0 <user_handler>
80104567:	83 c4 10             	add    $0x10,%esp
}
8010456a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010456d:	5b                   	pop    %ebx
8010456e:	5e                   	pop    %esi
8010456f:	5d                   	pop    %ebp
80104570:	c3                   	ret    
80104571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch (sig) 
80104578:	83 fb 11             	cmp    $0x11,%ebx
8010457b:	74 23                	je     801045a0 <handleSignal+0x70>
8010457d:	83 fb 13             	cmp    $0x13,%ebx
80104580:	75 0e                	jne    80104590 <handleSignal+0x60>
}
80104582:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104585:	5b                   	pop    %ebx
80104586:	5e                   	pop    %esi
80104587:	5d                   	pop    %ebp
        sigcont_handler();
80104588:	e9 53 fe ff ff       	jmp    801043e0 <sigcont_handler>
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
}
80104590:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104593:	5b                   	pop    %ebx
80104594:	5e                   	pop    %esi
80104595:	5d                   	pop    %ebp
        sigkill_handler();
80104596:	e9 c5 fd ff ff       	jmp    80104360 <sigkill_handler>
8010459b:	90                   	nop
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801045a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a3:	5b                   	pop    %ebx
801045a4:	5e                   	pop    %esi
801045a5:	5d                   	pop    %ebp
        sigstop_handler();
801045a6:	e9 f5 fd ff ff       	jmp    801043a0 <sigstop_handler>
801045ab:	90                   	nop
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045b0 <handle_signals>:

void
handle_signals (){
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	57                   	push   %edi
801045b4:	56                   	push   %esi
801045b5:	53                   	push   %ebx
801045b6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801045b9:	e8 42 02 00 00       	call   80104800 <pushcli>
  c = mycpu();
801045be:	e8 3d f2 ff ff       	call   80103800 <mycpu>
  p = c->proc;
801045c3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045c9:	e8 72 02 00 00       	call   80104840 <popcli>
  struct proc *p = myproc();
  uint sig;

  if(p == 0)
801045ce:	85 f6                	test   %esi,%esi
801045d0:	74 44                	je     80104616 <handle_signals+0x66>
    return;

  // acquire(&ptable.lock);
  
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
801045d2:	31 c9                	xor    %ecx,%ecx
  //signal sig is pending and is not blocked
  if((p->psignals & (1 << sig))  && !(p->sigmask & (1 << sig))) {
801045d4:	bf 01 00 00 00       	mov    $0x1,%edi
801045d9:	eb 0d                	jmp    801045e8 <handle_signals+0x38>
801045db:	90                   	nop
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
801045e0:	83 c1 01             	add    $0x1,%ecx
801045e3:	83 f9 20             	cmp    $0x20,%ecx
801045e6:	74 2e                	je     80104616 <handle_signals+0x66>
  if((p->psignals & (1 << sig))  && !(p->sigmask & (1 << sig))) {
801045e8:	89 fb                	mov    %edi,%ebx
801045ea:	d3 e3                	shl    %cl,%ebx
801045ec:	85 5e 7c             	test   %ebx,0x7c(%esi)
801045ef:	74 ef                	je     801045e0 <handle_signals+0x30>
801045f1:	85 9e 80 00 00 00    	test   %ebx,0x80(%esi)
801045f7:	75 e7                	jne    801045e0 <handle_signals+0x30>
    handleSignal(sig);           // handle it
801045f9:	83 ec 0c             	sub    $0xc,%esp
801045fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801045ff:	51                   	push   %ecx
80104600:	e8 2b ff ff ff       	call   80104530 <handleSignal>
    p->psignals ^= 1 << sig;     // turn off this bit
80104605:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104608:	31 5e 7c             	xor    %ebx,0x7c(%esi)
8010460b:	83 c4 10             	add    $0x10,%esp
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
8010460e:	83 c1 01             	add    $0x1,%ecx
80104611:	83 f9 20             	cmp    $0x20,%ecx
80104614:	75 d2                	jne    801045e8 <handle_signals+0x38>
    }
  }
  // release(&ptable.lock);
  return;
}
80104616:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104619:	5b                   	pop    %ebx
8010461a:	5e                   	pop    %esi
8010461b:	5f                   	pop    %edi
8010461c:	5d                   	pop    %ebp
8010461d:	c3                   	ret    
8010461e:	66 90                	xchg   %ax,%ax

80104620 <sigret>:

int
sigret(void) {
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104627:	e8 d4 01 00 00       	call   80104800 <pushcli>
  c = mycpu();
8010462c:	e8 cf f1 ff ff       	call   80103800 <mycpu>
  p = c->proc;
80104631:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104637:	e8 04 02 00 00       	call   80104840 <popcli>
  struct proc* p = myproc();
  memmove(p->tf, p->tf_backup, sizeof(struct trapframe)); // trapframe restore
8010463c:	83 ec 04             	sub    $0x4,%esp
8010463f:	6a 4c                	push   $0x4c
80104641:	ff b3 04 01 00 00    	pushl  0x104(%ebx)
80104647:	ff 73 18             	pushl  0x18(%ebx)
8010464a:	e8 41 04 00 00       	call   80104a90 <memmove>
  return 0;
8010464f:	31 c0                	xor    %eax,%eax
80104651:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104654:	c9                   	leave  
80104655:	c3                   	ret    
80104656:	66 90                	xchg   %ax,%ax
80104658:	66 90                	xchg   %ax,%ax
8010465a:	66 90                	xchg   %ax,%ax
8010465c:	66 90                	xchg   %ax,%ax
8010465e:	66 90                	xchg   %ax,%ax

80104660 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 0c             	sub    $0xc,%esp
80104667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010466a:	68 68 7c 10 80       	push   $0x80107c68
8010466f:	8d 43 04             	lea    0x4(%ebx),%eax
80104672:	50                   	push   %eax
80104673:	e8 18 01 00 00       	call   80104790 <initlock>
  lk->name = name;
80104678:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010467b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104681:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104684:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010468b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010468e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104691:	c9                   	leave  
80104692:	c3                   	ret    
80104693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	8d 73 04             	lea    0x4(%ebx),%esi
801046ae:	56                   	push   %esi
801046af:	e8 1c 02 00 00       	call   801048d0 <acquire>
  while (lk->locked) {
801046b4:	8b 13                	mov    (%ebx),%edx
801046b6:	83 c4 10             	add    $0x10,%esp
801046b9:	85 d2                	test   %edx,%edx
801046bb:	74 16                	je     801046d3 <acquiresleep+0x33>
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801046c0:	83 ec 08             	sub    $0x8,%esp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	e8 d6 f8 ff ff       	call   80103fa0 <sleep>
  while (lk->locked) {
801046ca:	8b 03                	mov    (%ebx),%eax
801046cc:	83 c4 10             	add    $0x10,%esp
801046cf:	85 c0                	test   %eax,%eax
801046d1:	75 ed                	jne    801046c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801046d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801046d9:	e8 c2 f1 ff ff       	call   801038a0 <myproc>
801046de:	8b 40 10             	mov    0x10(%eax),%eax
801046e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801046e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046ea:	5b                   	pop    %ebx
801046eb:	5e                   	pop    %esi
801046ec:	5d                   	pop    %ebp
  release(&lk->lk);
801046ed:	e9 9e 02 00 00       	jmp    80104990 <release>
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	56                   	push   %esi
80104704:	53                   	push   %ebx
80104705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104708:	83 ec 0c             	sub    $0xc,%esp
8010470b:	8d 73 04             	lea    0x4(%ebx),%esi
8010470e:	56                   	push   %esi
8010470f:	e8 bc 01 00 00       	call   801048d0 <acquire>
  lk->locked = 0;
80104714:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010471a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104721:	89 1c 24             	mov    %ebx,(%esp)
80104724:	e8 77 fa ff ff       	call   801041a0 <wakeup>
  release(&lk->lk);
80104729:	89 75 08             	mov    %esi,0x8(%ebp)
8010472c:	83 c4 10             	add    $0x10,%esp
}
8010472f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104732:	5b                   	pop    %ebx
80104733:	5e                   	pop    %esi
80104734:	5d                   	pop    %ebp
  release(&lk->lk);
80104735:	e9 56 02 00 00       	jmp    80104990 <release>
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104740 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	57                   	push   %edi
80104744:	56                   	push   %esi
80104745:	53                   	push   %ebx
80104746:	31 ff                	xor    %edi,%edi
80104748:	83 ec 18             	sub    $0x18,%esp
8010474b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010474e:	8d 73 04             	lea    0x4(%ebx),%esi
80104751:	56                   	push   %esi
80104752:	e8 79 01 00 00       	call   801048d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104757:	8b 03                	mov    (%ebx),%eax
80104759:	83 c4 10             	add    $0x10,%esp
8010475c:	85 c0                	test   %eax,%eax
8010475e:	74 13                	je     80104773 <holdingsleep+0x33>
80104760:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104763:	e8 38 f1 ff ff       	call   801038a0 <myproc>
80104768:	39 58 10             	cmp    %ebx,0x10(%eax)
8010476b:	0f 94 c0             	sete   %al
8010476e:	0f b6 c0             	movzbl %al,%eax
80104771:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104773:	83 ec 0c             	sub    $0xc,%esp
80104776:	56                   	push   %esi
80104777:	e8 14 02 00 00       	call   80104990 <release>
  return r;
}
8010477c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010477f:	89 f8                	mov    %edi,%eax
80104781:	5b                   	pop    %ebx
80104782:	5e                   	pop    %esi
80104783:	5f                   	pop    %edi
80104784:	5d                   	pop    %ebp
80104785:	c3                   	ret    
80104786:	66 90                	xchg   %ax,%ax
80104788:	66 90                	xchg   %ax,%ax
8010478a:	66 90                	xchg   %ax,%ax
8010478c:	66 90                	xchg   %ax,%ax
8010478e:	66 90                	xchg   %ax,%ax

80104790 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104796:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104799:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010479f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801047a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801047a9:	5d                   	pop    %ebp
801047aa:	c3                   	ret    
801047ab:	90                   	nop
801047ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047b0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047b1:	31 d2                	xor    %edx,%edx
{
801047b3:	89 e5                	mov    %esp,%ebp
801047b5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801047b6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801047b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801047bc:	83 e8 08             	sub    $0x8,%eax
801047bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047c0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047cc:	77 1a                	ja     801047e8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801047ce:	8b 58 04             	mov    0x4(%eax),%ebx
801047d1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047d4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047d7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047d9:	83 fa 0a             	cmp    $0xa,%edx
801047dc:	75 e2                	jne    801047c0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801047de:	5b                   	pop    %ebx
801047df:	5d                   	pop    %ebp
801047e0:	c3                   	ret    
801047e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801047eb:	83 c1 28             	add    $0x28,%ecx
801047ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801047f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801047f9:	39 c1                	cmp    %eax,%ecx
801047fb:	75 f3                	jne    801047f0 <getcallerpcs+0x40>
}
801047fd:	5b                   	pop    %ebx
801047fe:	5d                   	pop    %ebp
801047ff:	c3                   	ret    

80104800 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	53                   	push   %ebx
80104804:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104807:	9c                   	pushf  
80104808:	5b                   	pop    %ebx
  asm volatile("cli");
80104809:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010480a:	e8 f1 ef ff ff       	call   80103800 <mycpu>
8010480f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104815:	85 c0                	test   %eax,%eax
80104817:	75 11                	jne    8010482a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104819:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010481f:	e8 dc ef ff ff       	call   80103800 <mycpu>
80104824:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010482a:	e8 d1 ef ff ff       	call   80103800 <mycpu>
8010482f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104836:	83 c4 04             	add    $0x4,%esp
80104839:	5b                   	pop    %ebx
8010483a:	5d                   	pop    %ebp
8010483b:	c3                   	ret    
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <popcli>:

void
popcli(void)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104846:	9c                   	pushf  
80104847:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104848:	f6 c4 02             	test   $0x2,%ah
8010484b:	75 35                	jne    80104882 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010484d:	e8 ae ef ff ff       	call   80103800 <mycpu>
80104852:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104859:	78 34                	js     8010488f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010485b:	e8 a0 ef ff ff       	call   80103800 <mycpu>
80104860:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104866:	85 d2                	test   %edx,%edx
80104868:	74 06                	je     80104870 <popcli+0x30>
    sti();
}
8010486a:	c9                   	leave  
8010486b:	c3                   	ret    
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104870:	e8 8b ef ff ff       	call   80103800 <mycpu>
80104875:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010487b:	85 c0                	test   %eax,%eax
8010487d:	74 eb                	je     8010486a <popcli+0x2a>
  asm volatile("sti");
8010487f:	fb                   	sti    
}
80104880:	c9                   	leave  
80104881:	c3                   	ret    
    panic("popcli - interruptible");
80104882:	83 ec 0c             	sub    $0xc,%esp
80104885:	68 73 7c 10 80       	push   $0x80107c73
8010488a:	e8 01 bb ff ff       	call   80100390 <panic>
    panic("popcli");
8010488f:	83 ec 0c             	sub    $0xc,%esp
80104892:	68 8a 7c 10 80       	push   $0x80107c8a
80104897:	e8 f4 ba ff ff       	call   80100390 <panic>
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048a0 <holding>:
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	8b 75 08             	mov    0x8(%ebp),%esi
801048a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801048aa:	e8 51 ff ff ff       	call   80104800 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048af:	8b 06                	mov    (%esi),%eax
801048b1:	85 c0                	test   %eax,%eax
801048b3:	74 10                	je     801048c5 <holding+0x25>
801048b5:	8b 5e 08             	mov    0x8(%esi),%ebx
801048b8:	e8 43 ef ff ff       	call   80103800 <mycpu>
801048bd:	39 c3                	cmp    %eax,%ebx
801048bf:	0f 94 c3             	sete   %bl
801048c2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801048c5:	e8 76 ff ff ff       	call   80104840 <popcli>
}
801048ca:	89 d8                	mov    %ebx,%eax
801048cc:	5b                   	pop    %ebx
801048cd:	5e                   	pop    %esi
801048ce:	5d                   	pop    %ebp
801048cf:	c3                   	ret    

801048d0 <acquire>:
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801048d5:	e8 26 ff ff ff       	call   80104800 <pushcli>
  if(holding(lk))
801048da:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048dd:	83 ec 0c             	sub    $0xc,%esp
801048e0:	53                   	push   %ebx
801048e1:	e8 ba ff ff ff       	call   801048a0 <holding>
801048e6:	83 c4 10             	add    $0x10,%esp
801048e9:	85 c0                	test   %eax,%eax
801048eb:	0f 85 83 00 00 00    	jne    80104974 <acquire+0xa4>
801048f1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801048f3:	ba 01 00 00 00       	mov    $0x1,%edx
801048f8:	eb 09                	jmp    80104903 <acquire+0x33>
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104900:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104903:	89 d0                	mov    %edx,%eax
80104905:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104908:	85 c0                	test   %eax,%eax
8010490a:	75 f4                	jne    80104900 <acquire+0x30>
  __sync_synchronize();
8010490c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104911:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104914:	e8 e7 ee ff ff       	call   80103800 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104919:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010491c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010491f:	89 e8                	mov    %ebp,%eax
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104928:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010492e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104934:	77 1a                	ja     80104950 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104936:	8b 48 04             	mov    0x4(%eax),%ecx
80104939:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010493c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010493f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104941:	83 fe 0a             	cmp    $0xa,%esi
80104944:	75 e2                	jne    80104928 <acquire+0x58>
}
80104946:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104949:	5b                   	pop    %ebx
8010494a:	5e                   	pop    %esi
8010494b:	5d                   	pop    %ebp
8010494c:	c3                   	ret    
8010494d:	8d 76 00             	lea    0x0(%esi),%esi
80104950:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104953:	83 c2 28             	add    $0x28,%edx
80104956:	8d 76 00             	lea    0x0(%esi),%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104960:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104966:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104969:	39 d0                	cmp    %edx,%eax
8010496b:	75 f3                	jne    80104960 <acquire+0x90>
}
8010496d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104970:	5b                   	pop    %ebx
80104971:	5e                   	pop    %esi
80104972:	5d                   	pop    %ebp
80104973:	c3                   	ret    
    panic("acquire");
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	68 91 7c 10 80       	push   $0x80107c91
8010497c:	e8 0f ba ff ff       	call   80100390 <panic>
80104981:	eb 0d                	jmp    80104990 <release>
80104983:	90                   	nop
80104984:	90                   	nop
80104985:	90                   	nop
80104986:	90                   	nop
80104987:	90                   	nop
80104988:	90                   	nop
80104989:	90                   	nop
8010498a:	90                   	nop
8010498b:	90                   	nop
8010498c:	90                   	nop
8010498d:	90                   	nop
8010498e:	90                   	nop
8010498f:	90                   	nop

80104990 <release>:
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 10             	sub    $0x10,%esp
80104997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010499a:	53                   	push   %ebx
8010499b:	e8 00 ff ff ff       	call   801048a0 <holding>
801049a0:	83 c4 10             	add    $0x10,%esp
801049a3:	85 c0                	test   %eax,%eax
801049a5:	74 22                	je     801049c9 <release+0x39>
  lk->pcs[0] = 0;
801049a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801049ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801049b5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801049c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049c3:	c9                   	leave  
  popcli();
801049c4:	e9 77 fe ff ff       	jmp    80104840 <popcli>
    panic("release");
801049c9:	83 ec 0c             	sub    $0xc,%esp
801049cc:	68 99 7c 10 80       	push   $0x80107c99
801049d1:	e8 ba b9 ff ff       	call   80100390 <panic>
801049d6:	66 90                	xchg   %ax,%ax
801049d8:	66 90                	xchg   %ax,%ax
801049da:	66 90                	xchg   %ax,%ax
801049dc:	66 90                	xchg   %ax,%ax
801049de:	66 90                	xchg   %ax,%ax

801049e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	53                   	push   %ebx
801049e5:	8b 55 08             	mov    0x8(%ebp),%edx
801049e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801049eb:	f6 c2 03             	test   $0x3,%dl
801049ee:	75 05                	jne    801049f5 <memset+0x15>
801049f0:	f6 c1 03             	test   $0x3,%cl
801049f3:	74 13                	je     80104a08 <memset+0x28>
  asm volatile("cld; rep stosb" :
801049f5:	89 d7                	mov    %edx,%edi
801049f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801049fa:	fc                   	cld    
801049fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801049fd:	5b                   	pop    %ebx
801049fe:	89 d0                	mov    %edx,%eax
80104a00:	5f                   	pop    %edi
80104a01:	5d                   	pop    %ebp
80104a02:	c3                   	ret    
80104a03:	90                   	nop
80104a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104a08:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a0c:	c1 e9 02             	shr    $0x2,%ecx
80104a0f:	89 f8                	mov    %edi,%eax
80104a11:	89 fb                	mov    %edi,%ebx
80104a13:	c1 e0 18             	shl    $0x18,%eax
80104a16:	c1 e3 10             	shl    $0x10,%ebx
80104a19:	09 d8                	or     %ebx,%eax
80104a1b:	09 f8                	or     %edi,%eax
80104a1d:	c1 e7 08             	shl    $0x8,%edi
80104a20:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a22:	89 d7                	mov    %edx,%edi
80104a24:	fc                   	cld    
80104a25:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104a27:	5b                   	pop    %ebx
80104a28:	89 d0                	mov    %edx,%eax
80104a2a:	5f                   	pop    %edi
80104a2b:	5d                   	pop    %ebp
80104a2c:	c3                   	ret    
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi

80104a30 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	53                   	push   %ebx
80104a36:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a39:	8b 75 08             	mov    0x8(%ebp),%esi
80104a3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a3f:	85 db                	test   %ebx,%ebx
80104a41:	74 29                	je     80104a6c <memcmp+0x3c>
    if(*s1 != *s2)
80104a43:	0f b6 16             	movzbl (%esi),%edx
80104a46:	0f b6 0f             	movzbl (%edi),%ecx
80104a49:	38 d1                	cmp    %dl,%cl
80104a4b:	75 2b                	jne    80104a78 <memcmp+0x48>
80104a4d:	b8 01 00 00 00       	mov    $0x1,%eax
80104a52:	eb 14                	jmp    80104a68 <memcmp+0x38>
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a58:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104a5c:	83 c0 01             	add    $0x1,%eax
80104a5f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104a64:	38 ca                	cmp    %cl,%dl
80104a66:	75 10                	jne    80104a78 <memcmp+0x48>
  while(n-- > 0){
80104a68:	39 d8                	cmp    %ebx,%eax
80104a6a:	75 ec                	jne    80104a58 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104a6c:	5b                   	pop    %ebx
  return 0;
80104a6d:	31 c0                	xor    %eax,%eax
}
80104a6f:	5e                   	pop    %esi
80104a70:	5f                   	pop    %edi
80104a71:	5d                   	pop    %ebp
80104a72:	c3                   	ret    
80104a73:	90                   	nop
80104a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104a78:	0f b6 c2             	movzbl %dl,%eax
}
80104a7b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104a7c:	29 c8                	sub    %ecx,%eax
}
80104a7e:	5e                   	pop    %esi
80104a7f:	5f                   	pop    %edi
80104a80:	5d                   	pop    %ebp
80104a81:	c3                   	ret    
80104a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	56                   	push   %esi
80104a94:	53                   	push   %ebx
80104a95:	8b 45 08             	mov    0x8(%ebp),%eax
80104a98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a9b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a9e:	39 c3                	cmp    %eax,%ebx
80104aa0:	73 26                	jae    80104ac8 <memmove+0x38>
80104aa2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104aa5:	39 c8                	cmp    %ecx,%eax
80104aa7:	73 1f                	jae    80104ac8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104aa9:	85 f6                	test   %esi,%esi
80104aab:	8d 56 ff             	lea    -0x1(%esi),%edx
80104aae:	74 0f                	je     80104abf <memmove+0x2f>
      *--d = *--s;
80104ab0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ab4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104ab7:	83 ea 01             	sub    $0x1,%edx
80104aba:	83 fa ff             	cmp    $0xffffffff,%edx
80104abd:	75 f1                	jne    80104ab0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104abf:	5b                   	pop    %ebx
80104ac0:	5e                   	pop    %esi
80104ac1:	5d                   	pop    %ebp
80104ac2:	c3                   	ret    
80104ac3:	90                   	nop
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104ac8:	31 d2                	xor    %edx,%edx
80104aca:	85 f6                	test   %esi,%esi
80104acc:	74 f1                	je     80104abf <memmove+0x2f>
80104ace:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104ad0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ad4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ad7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104ada:	39 d6                	cmp    %edx,%esi
80104adc:	75 f2                	jne    80104ad0 <memmove+0x40>
}
80104ade:	5b                   	pop    %ebx
80104adf:	5e                   	pop    %esi
80104ae0:	5d                   	pop    %ebp
80104ae1:	c3                   	ret    
80104ae2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104af0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104af3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104af4:	eb 9a                	jmp    80104a90 <memmove>
80104af6:	8d 76 00             	lea    0x0(%esi),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b08:	53                   	push   %ebx
80104b09:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b0f:	85 ff                	test   %edi,%edi
80104b11:	74 2f                	je     80104b42 <strncmp+0x42>
80104b13:	0f b6 01             	movzbl (%ecx),%eax
80104b16:	0f b6 1e             	movzbl (%esi),%ebx
80104b19:	84 c0                	test   %al,%al
80104b1b:	74 37                	je     80104b54 <strncmp+0x54>
80104b1d:	38 c3                	cmp    %al,%bl
80104b1f:	75 33                	jne    80104b54 <strncmp+0x54>
80104b21:	01 f7                	add    %esi,%edi
80104b23:	eb 13                	jmp    80104b38 <strncmp+0x38>
80104b25:	8d 76 00             	lea    0x0(%esi),%esi
80104b28:	0f b6 01             	movzbl (%ecx),%eax
80104b2b:	84 c0                	test   %al,%al
80104b2d:	74 21                	je     80104b50 <strncmp+0x50>
80104b2f:	0f b6 1a             	movzbl (%edx),%ebx
80104b32:	89 d6                	mov    %edx,%esi
80104b34:	38 d8                	cmp    %bl,%al
80104b36:	75 1c                	jne    80104b54 <strncmp+0x54>
    n--, p++, q++;
80104b38:	8d 56 01             	lea    0x1(%esi),%edx
80104b3b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b3e:	39 fa                	cmp    %edi,%edx
80104b40:	75 e6                	jne    80104b28 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104b42:	5b                   	pop    %ebx
    return 0;
80104b43:	31 c0                	xor    %eax,%eax
}
80104b45:	5e                   	pop    %esi
80104b46:	5f                   	pop    %edi
80104b47:	5d                   	pop    %ebp
80104b48:	c3                   	ret    
80104b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b50:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104b54:	29 d8                	sub    %ebx,%eax
}
80104b56:	5b                   	pop    %ebx
80104b57:	5e                   	pop    %esi
80104b58:	5f                   	pop    %edi
80104b59:	5d                   	pop    %ebp
80104b5a:	c3                   	ret    
80104b5b:	90                   	nop
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b60 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
80104b65:	8b 45 08             	mov    0x8(%ebp),%eax
80104b68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b6e:	89 c2                	mov    %eax,%edx
80104b70:	eb 19                	jmp    80104b8b <strncpy+0x2b>
80104b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b78:	83 c3 01             	add    $0x1,%ebx
80104b7b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b7f:	83 c2 01             	add    $0x1,%edx
80104b82:	84 c9                	test   %cl,%cl
80104b84:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b87:	74 09                	je     80104b92 <strncpy+0x32>
80104b89:	89 f1                	mov    %esi,%ecx
80104b8b:	85 c9                	test   %ecx,%ecx
80104b8d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104b90:	7f e6                	jg     80104b78 <strncpy+0x18>
    ;
  while(n-- > 0)
80104b92:	31 c9                	xor    %ecx,%ecx
80104b94:	85 f6                	test   %esi,%esi
80104b96:	7e 17                	jle    80104baf <strncpy+0x4f>
80104b98:	90                   	nop
80104b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ba0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ba4:	89 f3                	mov    %esi,%ebx
80104ba6:	83 c1 01             	add    $0x1,%ecx
80104ba9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104bab:	85 db                	test   %ebx,%ebx
80104bad:	7f f1                	jg     80104ba0 <strncpy+0x40>
  return os;
}
80104baf:	5b                   	pop    %ebx
80104bb0:	5e                   	pop    %esi
80104bb1:	5d                   	pop    %ebp
80104bb2:	c3                   	ret    
80104bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bc8:	8b 45 08             	mov    0x8(%ebp),%eax
80104bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104bce:	85 c9                	test   %ecx,%ecx
80104bd0:	7e 26                	jle    80104bf8 <safestrcpy+0x38>
80104bd2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104bd6:	89 c1                	mov    %eax,%ecx
80104bd8:	eb 17                	jmp    80104bf1 <safestrcpy+0x31>
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104be0:	83 c2 01             	add    $0x1,%edx
80104be3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104be7:	83 c1 01             	add    $0x1,%ecx
80104bea:	84 db                	test   %bl,%bl
80104bec:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104bef:	74 04                	je     80104bf5 <safestrcpy+0x35>
80104bf1:	39 f2                	cmp    %esi,%edx
80104bf3:	75 eb                	jne    80104be0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bf5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104bf8:	5b                   	pop    %ebx
80104bf9:	5e                   	pop    %esi
80104bfa:	5d                   	pop    %ebp
80104bfb:	c3                   	ret    
80104bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c00 <strlen>:

int
strlen(const char *s)
{
80104c00:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c01:	31 c0                	xor    %eax,%eax
{
80104c03:	89 e5                	mov    %esp,%ebp
80104c05:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c08:	80 3a 00             	cmpb   $0x0,(%edx)
80104c0b:	74 0c                	je     80104c19 <strlen+0x19>
80104c0d:	8d 76 00             	lea    0x0(%esi),%esi
80104c10:	83 c0 01             	add    $0x1,%eax
80104c13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c17:	75 f7                	jne    80104c10 <strlen+0x10>
    ;
  return n;
}
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    

80104c1b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c1b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c1f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c23:	55                   	push   %ebp
  pushl %ebx
80104c24:	53                   	push   %ebx
  pushl %esi
80104c25:	56                   	push   %esi
  pushl %edi
80104c26:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c27:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c29:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c2b:	5f                   	pop    %edi
  popl %esi
80104c2c:	5e                   	pop    %esi
  popl %ebx
80104c2d:	5b                   	pop    %ebx
  popl %ebp
80104c2e:	5d                   	pop    %ebp
  ret
80104c2f:	c3                   	ret    

80104c30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
80104c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c3a:	e8 61 ec ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c3f:	8b 00                	mov    (%eax),%eax
80104c41:	39 d8                	cmp    %ebx,%eax
80104c43:	76 1b                	jbe    80104c60 <fetchint+0x30>
80104c45:	8d 53 04             	lea    0x4(%ebx),%edx
80104c48:	39 d0                	cmp    %edx,%eax
80104c4a:	72 14                	jb     80104c60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c4f:	8b 13                	mov    (%ebx),%edx
80104c51:	89 10                	mov    %edx,(%eax)
  return 0;
80104c53:	31 c0                	xor    %eax,%eax
}
80104c55:	83 c4 04             	add    $0x4,%esp
80104c58:	5b                   	pop    %ebx
80104c59:	5d                   	pop    %ebp
80104c5a:	c3                   	ret    
80104c5b:	90                   	nop
80104c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c65:	eb ee                	jmp    80104c55 <fetchint+0x25>
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 04             	sub    $0x4,%esp
80104c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c7a:	e8 21 ec ff ff       	call   801038a0 <myproc>

  if(addr >= curproc->sz)
80104c7f:	39 18                	cmp    %ebx,(%eax)
80104c81:	76 29                	jbe    80104cac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c86:	89 da                	mov    %ebx,%edx
80104c88:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c8a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c8c:	39 c3                	cmp    %eax,%ebx
80104c8e:	73 1c                	jae    80104cac <fetchstr+0x3c>
    if(*s == 0)
80104c90:	80 3b 00             	cmpb   $0x0,(%ebx)
80104c93:	75 10                	jne    80104ca5 <fetchstr+0x35>
80104c95:	eb 39                	jmp    80104cd0 <fetchstr+0x60>
80104c97:	89 f6                	mov    %esi,%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104ca0:	80 3a 00             	cmpb   $0x0,(%edx)
80104ca3:	74 1b                	je     80104cc0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104ca5:	83 c2 01             	add    $0x1,%edx
80104ca8:	39 d0                	cmp    %edx,%eax
80104caa:	77 f4                	ja     80104ca0 <fetchstr+0x30>
    return -1;
80104cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104cb1:	83 c4 04             	add    $0x4,%esp
80104cb4:	5b                   	pop    %ebx
80104cb5:	5d                   	pop    %ebp
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104cc0:	83 c4 04             	add    $0x4,%esp
80104cc3:	89 d0                	mov    %edx,%eax
80104cc5:	29 d8                	sub    %ebx,%eax
80104cc7:	5b                   	pop    %ebx
80104cc8:	5d                   	pop    %ebp
80104cc9:	c3                   	ret    
80104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104cd0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104cd2:	eb dd                	jmp    80104cb1 <fetchstr+0x41>
80104cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ce0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce5:	e8 b6 eb ff ff       	call   801038a0 <myproc>
80104cea:	8b 40 18             	mov    0x18(%eax),%eax
80104ced:	8b 55 08             	mov    0x8(%ebp),%edx
80104cf0:	8b 40 44             	mov    0x44(%eax),%eax
80104cf3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cf6:	e8 a5 eb ff ff       	call   801038a0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cfb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cfd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d00:	39 c6                	cmp    %eax,%esi
80104d02:	73 1c                	jae    80104d20 <argint+0x40>
80104d04:	8d 53 08             	lea    0x8(%ebx),%edx
80104d07:	39 d0                	cmp    %edx,%eax
80104d09:	72 15                	jb     80104d20 <argint+0x40>
  *ip = *(int*)(addr);
80104d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d0e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d11:	89 10                	mov    %edx,(%eax)
  return 0;
80104d13:	31 c0                	xor    %eax,%eax
}
80104d15:	5b                   	pop    %ebx
80104d16:	5e                   	pop    %esi
80104d17:	5d                   	pop    %ebp
80104d18:	c3                   	ret    
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d25:	eb ee                	jmp    80104d15 <argint+0x35>
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
80104d35:	83 ec 10             	sub    $0x10,%esp
80104d38:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d3b:	e8 60 eb ff ff       	call   801038a0 <myproc>
80104d40:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104d42:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d45:	83 ec 08             	sub    $0x8,%esp
80104d48:	50                   	push   %eax
80104d49:	ff 75 08             	pushl  0x8(%ebp)
80104d4c:	e8 8f ff ff ff       	call   80104ce0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d51:	83 c4 10             	add    $0x10,%esp
80104d54:	85 c0                	test   %eax,%eax
80104d56:	78 28                	js     80104d80 <argptr+0x50>
80104d58:	85 db                	test   %ebx,%ebx
80104d5a:	78 24                	js     80104d80 <argptr+0x50>
80104d5c:	8b 16                	mov    (%esi),%edx
80104d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d61:	39 c2                	cmp    %eax,%edx
80104d63:	76 1b                	jbe    80104d80 <argptr+0x50>
80104d65:	01 c3                	add    %eax,%ebx
80104d67:	39 da                	cmp    %ebx,%edx
80104d69:	72 15                	jb     80104d80 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104d6b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d6e:	89 02                	mov    %eax,(%edx)
  return 0;
80104d70:	31 c0                	xor    %eax,%eax
}
80104d72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d75:	5b                   	pop    %ebx
80104d76:	5e                   	pop    %esi
80104d77:	5d                   	pop    %ebp
80104d78:	c3                   	ret    
80104d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d85:	eb eb                	jmp    80104d72 <argptr+0x42>
80104d87:	89 f6                	mov    %esi,%esi
80104d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d90 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104d96:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d99:	50                   	push   %eax
80104d9a:	ff 75 08             	pushl  0x8(%ebp)
80104d9d:	e8 3e ff ff ff       	call   80104ce0 <argint>
80104da2:	83 c4 10             	add    $0x10,%esp
80104da5:	85 c0                	test   %eax,%eax
80104da7:	78 17                	js     80104dc0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104da9:	83 ec 08             	sub    $0x8,%esp
80104dac:	ff 75 0c             	pushl  0xc(%ebp)
80104daf:	ff 75 f4             	pushl  -0xc(%ebp)
80104db2:	e8 b9 fe ff ff       	call   80104c70 <fetchstr>
80104db7:	83 c4 10             	add    $0x10,%esp
}
80104dba:	c9                   	leave  
80104dbb:	c3                   	ret    
80104dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc5:	c9                   	leave  
80104dc6:	c3                   	ret    
80104dc7:	89 f6                	mov    %esi,%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <syscall>:
[SYS_sigret]      sys_sigret
};

void
syscall(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
80104dd4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104dd7:	e8 c4 ea ff ff       	call   801038a0 <myproc>
80104ddc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104dde:	8b 40 18             	mov    0x18(%eax),%eax
80104de1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104de4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104de7:	83 fa 17             	cmp    $0x17,%edx
80104dea:	77 1c                	ja     80104e08 <syscall+0x38>
80104dec:	8b 14 85 c0 7c 10 80 	mov    -0x7fef8340(,%eax,4),%edx
80104df3:	85 d2                	test   %edx,%edx
80104df5:	74 11                	je     80104e08 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104df7:	ff d2                	call   *%edx
80104df9:	8b 53 18             	mov    0x18(%ebx),%edx
80104dfc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e02:	c9                   	leave  
80104e03:	c3                   	ret    
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e08:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e09:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e0c:	50                   	push   %eax
80104e0d:	ff 73 10             	pushl  0x10(%ebx)
80104e10:	68 a1 7c 10 80       	push   $0x80107ca1
80104e15:	e8 46 b8 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104e1a:	8b 43 18             	mov    0x18(%ebx),%eax
80104e1d:	83 c4 10             	add    $0x10,%esp
80104e20:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e2a:	c9                   	leave  
80104e2b:	c3                   	ret    
80104e2c:	66 90                	xchg   %ax,%ax
80104e2e:	66 90                	xchg   %ax,%ax

80104e30 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	56                   	push   %esi
80104e35:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e36:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104e39:	83 ec 34             	sub    $0x34,%esp
80104e3c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e42:	56                   	push   %esi
80104e43:	50                   	push   %eax
{
80104e44:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e47:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e4a:	e8 11 d1 ff ff       	call   80101f60 <nameiparent>
80104e4f:	83 c4 10             	add    $0x10,%esp
80104e52:	85 c0                	test   %eax,%eax
80104e54:	0f 84 46 01 00 00    	je     80104fa0 <create+0x170>
    return 0;
  ilock(dp);
80104e5a:	83 ec 0c             	sub    $0xc,%esp
80104e5d:	89 c3                	mov    %eax,%ebx
80104e5f:	50                   	push   %eax
80104e60:	e8 7b c8 ff ff       	call   801016e0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e65:	83 c4 0c             	add    $0xc,%esp
80104e68:	6a 00                	push   $0x0
80104e6a:	56                   	push   %esi
80104e6b:	53                   	push   %ebx
80104e6c:	e8 9f cd ff ff       	call   80101c10 <dirlookup>
80104e71:	83 c4 10             	add    $0x10,%esp
80104e74:	85 c0                	test   %eax,%eax
80104e76:	89 c7                	mov    %eax,%edi
80104e78:	74 36                	je     80104eb0 <create+0x80>
    iunlockput(dp);
80104e7a:	83 ec 0c             	sub    $0xc,%esp
80104e7d:	53                   	push   %ebx
80104e7e:	e8 ed ca ff ff       	call   80101970 <iunlockput>
    ilock(ip);
80104e83:	89 3c 24             	mov    %edi,(%esp)
80104e86:	e8 55 c8 ff ff       	call   801016e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e8b:	83 c4 10             	add    $0x10,%esp
80104e8e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104e93:	0f 85 97 00 00 00    	jne    80104f30 <create+0x100>
80104e99:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104e9e:	0f 85 8c 00 00 00    	jne    80104f30 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ea7:	89 f8                	mov    %edi,%eax
80104ea9:	5b                   	pop    %ebx
80104eaa:	5e                   	pop    %esi
80104eab:	5f                   	pop    %edi
80104eac:	5d                   	pop    %ebp
80104ead:	c3                   	ret    
80104eae:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104eb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104eb4:	83 ec 08             	sub    $0x8,%esp
80104eb7:	50                   	push   %eax
80104eb8:	ff 33                	pushl  (%ebx)
80104eba:	e8 b1 c6 ff ff       	call   80101570 <ialloc>
80104ebf:	83 c4 10             	add    $0x10,%esp
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	89 c7                	mov    %eax,%edi
80104ec6:	0f 84 e8 00 00 00    	je     80104fb4 <create+0x184>
  ilock(ip);
80104ecc:	83 ec 0c             	sub    $0xc,%esp
80104ecf:	50                   	push   %eax
80104ed0:	e8 0b c8 ff ff       	call   801016e0 <ilock>
  ip->major = major;
80104ed5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ed9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104edd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ee1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104ee5:	b8 01 00 00 00       	mov    $0x1,%eax
80104eea:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104eee:	89 3c 24             	mov    %edi,(%esp)
80104ef1:	e8 3a c7 ff ff       	call   80101630 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ef6:	83 c4 10             	add    $0x10,%esp
80104ef9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104efe:	74 50                	je     80104f50 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f00:	83 ec 04             	sub    $0x4,%esp
80104f03:	ff 77 04             	pushl  0x4(%edi)
80104f06:	56                   	push   %esi
80104f07:	53                   	push   %ebx
80104f08:	e8 73 cf ff ff       	call   80101e80 <dirlink>
80104f0d:	83 c4 10             	add    $0x10,%esp
80104f10:	85 c0                	test   %eax,%eax
80104f12:	0f 88 8f 00 00 00    	js     80104fa7 <create+0x177>
  iunlockput(dp);
80104f18:	83 ec 0c             	sub    $0xc,%esp
80104f1b:	53                   	push   %ebx
80104f1c:	e8 4f ca ff ff       	call   80101970 <iunlockput>
  return ip;
80104f21:	83 c4 10             	add    $0x10,%esp
}
80104f24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f27:	89 f8                	mov    %edi,%eax
80104f29:	5b                   	pop    %ebx
80104f2a:	5e                   	pop    %esi
80104f2b:	5f                   	pop    %edi
80104f2c:	5d                   	pop    %ebp
80104f2d:	c3                   	ret    
80104f2e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104f30:	83 ec 0c             	sub    $0xc,%esp
80104f33:	57                   	push   %edi
    return 0;
80104f34:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104f36:	e8 35 ca ff ff       	call   80101970 <iunlockput>
    return 0;
80104f3b:	83 c4 10             	add    $0x10,%esp
}
80104f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f41:	89 f8                	mov    %edi,%eax
80104f43:	5b                   	pop    %ebx
80104f44:	5e                   	pop    %esi
80104f45:	5f                   	pop    %edi
80104f46:	5d                   	pop    %ebp
80104f47:	c3                   	ret    
80104f48:	90                   	nop
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104f50:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f55:	83 ec 0c             	sub    $0xc,%esp
80104f58:	53                   	push   %ebx
80104f59:	e8 d2 c6 ff ff       	call   80101630 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f5e:	83 c4 0c             	add    $0xc,%esp
80104f61:	ff 77 04             	pushl  0x4(%edi)
80104f64:	68 40 7d 10 80       	push   $0x80107d40
80104f69:	57                   	push   %edi
80104f6a:	e8 11 cf ff ff       	call   80101e80 <dirlink>
80104f6f:	83 c4 10             	add    $0x10,%esp
80104f72:	85 c0                	test   %eax,%eax
80104f74:	78 1c                	js     80104f92 <create+0x162>
80104f76:	83 ec 04             	sub    $0x4,%esp
80104f79:	ff 73 04             	pushl  0x4(%ebx)
80104f7c:	68 3f 7d 10 80       	push   $0x80107d3f
80104f81:	57                   	push   %edi
80104f82:	e8 f9 ce ff ff       	call   80101e80 <dirlink>
80104f87:	83 c4 10             	add    $0x10,%esp
80104f8a:	85 c0                	test   %eax,%eax
80104f8c:	0f 89 6e ff ff ff    	jns    80104f00 <create+0xd0>
      panic("create dots");
80104f92:	83 ec 0c             	sub    $0xc,%esp
80104f95:	68 33 7d 10 80       	push   $0x80107d33
80104f9a:	e8 f1 b3 ff ff       	call   80100390 <panic>
80104f9f:	90                   	nop
    return 0;
80104fa0:	31 ff                	xor    %edi,%edi
80104fa2:	e9 fd fe ff ff       	jmp    80104ea4 <create+0x74>
    panic("create: dirlink");
80104fa7:	83 ec 0c             	sub    $0xc,%esp
80104faa:	68 42 7d 10 80       	push   $0x80107d42
80104faf:	e8 dc b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104fb4:	83 ec 0c             	sub    $0xc,%esp
80104fb7:	68 24 7d 10 80       	push   $0x80107d24
80104fbc:	e8 cf b3 ff ff       	call   80100390 <panic>
80104fc1:	eb 0d                	jmp    80104fd0 <argfd.constprop.0>
80104fc3:	90                   	nop
80104fc4:	90                   	nop
80104fc5:	90                   	nop
80104fc6:	90                   	nop
80104fc7:	90                   	nop
80104fc8:	90                   	nop
80104fc9:	90                   	nop
80104fca:	90                   	nop
80104fcb:	90                   	nop
80104fcc:	90                   	nop
80104fcd:	90                   	nop
80104fce:	90                   	nop
80104fcf:	90                   	nop

80104fd0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
80104fd5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104fd7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104fda:	89 d6                	mov    %edx,%esi
80104fdc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fdf:	50                   	push   %eax
80104fe0:	6a 00                	push   $0x0
80104fe2:	e8 f9 fc ff ff       	call   80104ce0 <argint>
80104fe7:	83 c4 10             	add    $0x10,%esp
80104fea:	85 c0                	test   %eax,%eax
80104fec:	78 2a                	js     80105018 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104fee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ff2:	77 24                	ja     80105018 <argfd.constprop.0+0x48>
80104ff4:	e8 a7 e8 ff ff       	call   801038a0 <myproc>
80104ff9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ffc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105000:	85 c0                	test   %eax,%eax
80105002:	74 14                	je     80105018 <argfd.constprop.0+0x48>
  if(pfd)
80105004:	85 db                	test   %ebx,%ebx
80105006:	74 02                	je     8010500a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105008:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010500a:	89 06                	mov    %eax,(%esi)
  return 0;
8010500c:	31 c0                	xor    %eax,%eax
}
8010500e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105011:	5b                   	pop    %ebx
80105012:	5e                   	pop    %esi
80105013:	5d                   	pop    %ebp
80105014:	c3                   	ret    
80105015:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501d:	eb ef                	jmp    8010500e <argfd.constprop.0+0x3e>
8010501f:	90                   	nop

80105020 <sys_dup>:
{
80105020:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105021:	31 c0                	xor    %eax,%eax
{
80105023:	89 e5                	mov    %esp,%ebp
80105025:	56                   	push   %esi
80105026:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105027:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010502a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010502d:	e8 9e ff ff ff       	call   80104fd0 <argfd.constprop.0>
80105032:	85 c0                	test   %eax,%eax
80105034:	78 42                	js     80105078 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105036:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105039:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010503b:	e8 60 e8 ff ff       	call   801038a0 <myproc>
80105040:	eb 0e                	jmp    80105050 <sys_dup+0x30>
80105042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105048:	83 c3 01             	add    $0x1,%ebx
8010504b:	83 fb 10             	cmp    $0x10,%ebx
8010504e:	74 28                	je     80105078 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105050:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105054:	85 d2                	test   %edx,%edx
80105056:	75 f0                	jne    80105048 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105058:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010505c:	83 ec 0c             	sub    $0xc,%esp
8010505f:	ff 75 f4             	pushl  -0xc(%ebp)
80105062:	e8 e9 bd ff ff       	call   80100e50 <filedup>
  return fd;
80105067:	83 c4 10             	add    $0x10,%esp
}
8010506a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010506d:	89 d8                	mov    %ebx,%eax
8010506f:	5b                   	pop    %ebx
80105070:	5e                   	pop    %esi
80105071:	5d                   	pop    %ebp
80105072:	c3                   	ret    
80105073:	90                   	nop
80105074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105078:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010507b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105080:	89 d8                	mov    %ebx,%eax
80105082:	5b                   	pop    %ebx
80105083:	5e                   	pop    %esi
80105084:	5d                   	pop    %ebp
80105085:	c3                   	ret    
80105086:	8d 76 00             	lea    0x0(%esi),%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <sys_read>:
{
80105090:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105091:	31 c0                	xor    %eax,%eax
{
80105093:	89 e5                	mov    %esp,%ebp
80105095:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105098:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010509b:	e8 30 ff ff ff       	call   80104fd0 <argfd.constprop.0>
801050a0:	85 c0                	test   %eax,%eax
801050a2:	78 4c                	js     801050f0 <sys_read+0x60>
801050a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050a7:	83 ec 08             	sub    $0x8,%esp
801050aa:	50                   	push   %eax
801050ab:	6a 02                	push   $0x2
801050ad:	e8 2e fc ff ff       	call   80104ce0 <argint>
801050b2:	83 c4 10             	add    $0x10,%esp
801050b5:	85 c0                	test   %eax,%eax
801050b7:	78 37                	js     801050f0 <sys_read+0x60>
801050b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050bc:	83 ec 04             	sub    $0x4,%esp
801050bf:	ff 75 f0             	pushl  -0x10(%ebp)
801050c2:	50                   	push   %eax
801050c3:	6a 01                	push   $0x1
801050c5:	e8 66 fc ff ff       	call   80104d30 <argptr>
801050ca:	83 c4 10             	add    $0x10,%esp
801050cd:	85 c0                	test   %eax,%eax
801050cf:	78 1f                	js     801050f0 <sys_read+0x60>
  return fileread(f, p, n);
801050d1:	83 ec 04             	sub    $0x4,%esp
801050d4:	ff 75 f0             	pushl  -0x10(%ebp)
801050d7:	ff 75 f4             	pushl  -0xc(%ebp)
801050da:	ff 75 ec             	pushl  -0x14(%ebp)
801050dd:	e8 de be ff ff       	call   80100fc0 <fileread>
801050e2:	83 c4 10             	add    $0x10,%esp
}
801050e5:	c9                   	leave  
801050e6:	c3                   	ret    
801050e7:	89 f6                	mov    %esi,%esi
801050e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105100 <sys_write>:
{
80105100:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105101:	31 c0                	xor    %eax,%eax
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105108:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010510b:	e8 c0 fe ff ff       	call   80104fd0 <argfd.constprop.0>
80105110:	85 c0                	test   %eax,%eax
80105112:	78 4c                	js     80105160 <sys_write+0x60>
80105114:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105117:	83 ec 08             	sub    $0x8,%esp
8010511a:	50                   	push   %eax
8010511b:	6a 02                	push   $0x2
8010511d:	e8 be fb ff ff       	call   80104ce0 <argint>
80105122:	83 c4 10             	add    $0x10,%esp
80105125:	85 c0                	test   %eax,%eax
80105127:	78 37                	js     80105160 <sys_write+0x60>
80105129:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010512c:	83 ec 04             	sub    $0x4,%esp
8010512f:	ff 75 f0             	pushl  -0x10(%ebp)
80105132:	50                   	push   %eax
80105133:	6a 01                	push   $0x1
80105135:	e8 f6 fb ff ff       	call   80104d30 <argptr>
8010513a:	83 c4 10             	add    $0x10,%esp
8010513d:	85 c0                	test   %eax,%eax
8010513f:	78 1f                	js     80105160 <sys_write+0x60>
  return filewrite(f, p, n);
80105141:	83 ec 04             	sub    $0x4,%esp
80105144:	ff 75 f0             	pushl  -0x10(%ebp)
80105147:	ff 75 f4             	pushl  -0xc(%ebp)
8010514a:	ff 75 ec             	pushl  -0x14(%ebp)
8010514d:	e8 fe be ff ff       	call   80101050 <filewrite>
80105152:	83 c4 10             	add    $0x10,%esp
}
80105155:	c9                   	leave  
80105156:	c3                   	ret    
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105170 <sys_close>:
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105176:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105179:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010517c:	e8 4f fe ff ff       	call   80104fd0 <argfd.constprop.0>
80105181:	85 c0                	test   %eax,%eax
80105183:	78 2b                	js     801051b0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105185:	e8 16 e7 ff ff       	call   801038a0 <myproc>
8010518a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010518d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105190:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105197:	00 
  fileclose(f);
80105198:	ff 75 f4             	pushl  -0xc(%ebp)
8010519b:	e8 00 bd ff ff       	call   80100ea0 <fileclose>
  return 0;
801051a0:	83 c4 10             	add    $0x10,%esp
801051a3:	31 c0                	xor    %eax,%eax
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    
801051a7:	89 f6                	mov    %esi,%esi
801051a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051b5:	c9                   	leave  
801051b6:	c3                   	ret    
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051c0 <sys_fstat>:
{
801051c0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051c1:	31 c0                	xor    %eax,%eax
{
801051c3:	89 e5                	mov    %esp,%ebp
801051c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801051cb:	e8 00 fe ff ff       	call   80104fd0 <argfd.constprop.0>
801051d0:	85 c0                	test   %eax,%eax
801051d2:	78 2c                	js     80105200 <sys_fstat+0x40>
801051d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051d7:	83 ec 04             	sub    $0x4,%esp
801051da:	6a 14                	push   $0x14
801051dc:	50                   	push   %eax
801051dd:	6a 01                	push   $0x1
801051df:	e8 4c fb ff ff       	call   80104d30 <argptr>
801051e4:	83 c4 10             	add    $0x10,%esp
801051e7:	85 c0                	test   %eax,%eax
801051e9:	78 15                	js     80105200 <sys_fstat+0x40>
  return filestat(f, st);
801051eb:	83 ec 08             	sub    $0x8,%esp
801051ee:	ff 75 f4             	pushl  -0xc(%ebp)
801051f1:	ff 75 f0             	pushl  -0x10(%ebp)
801051f4:	e8 77 bd ff ff       	call   80100f70 <filestat>
801051f9:	83 c4 10             	add    $0x10,%esp
}
801051fc:	c9                   	leave  
801051fd:	c3                   	ret    
801051fe:	66 90                	xchg   %ax,%ax
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105205:	c9                   	leave  
80105206:	c3                   	ret    
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105210 <sys_link>:
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
80105215:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105216:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105219:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010521c:	50                   	push   %eax
8010521d:	6a 00                	push   $0x0
8010521f:	e8 6c fb ff ff       	call   80104d90 <argstr>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	0f 88 fb 00 00 00    	js     8010532a <sys_link+0x11a>
8010522f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105232:	83 ec 08             	sub    $0x8,%esp
80105235:	50                   	push   %eax
80105236:	6a 01                	push   $0x1
80105238:	e8 53 fb ff ff       	call   80104d90 <argstr>
8010523d:	83 c4 10             	add    $0x10,%esp
80105240:	85 c0                	test   %eax,%eax
80105242:	0f 88 e2 00 00 00    	js     8010532a <sys_link+0x11a>
  begin_op();
80105248:	e8 b3 d9 ff ff       	call   80102c00 <begin_op>
  if((ip = namei(old)) == 0){
8010524d:	83 ec 0c             	sub    $0xc,%esp
80105250:	ff 75 d4             	pushl  -0x2c(%ebp)
80105253:	e8 e8 cc ff ff       	call   80101f40 <namei>
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	85 c0                	test   %eax,%eax
8010525d:	89 c3                	mov    %eax,%ebx
8010525f:	0f 84 ea 00 00 00    	je     8010534f <sys_link+0x13f>
  ilock(ip);
80105265:	83 ec 0c             	sub    $0xc,%esp
80105268:	50                   	push   %eax
80105269:	e8 72 c4 ff ff       	call   801016e0 <ilock>
  if(ip->type == T_DIR){
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105276:	0f 84 bb 00 00 00    	je     80105337 <sys_link+0x127>
  ip->nlink++;
8010527c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105281:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105284:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105287:	53                   	push   %ebx
80105288:	e8 a3 c3 ff ff       	call   80101630 <iupdate>
  iunlock(ip);
8010528d:	89 1c 24             	mov    %ebx,(%esp)
80105290:	e8 2b c5 ff ff       	call   801017c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105295:	58                   	pop    %eax
80105296:	5a                   	pop    %edx
80105297:	57                   	push   %edi
80105298:	ff 75 d0             	pushl  -0x30(%ebp)
8010529b:	e8 c0 cc ff ff       	call   80101f60 <nameiparent>
801052a0:	83 c4 10             	add    $0x10,%esp
801052a3:	85 c0                	test   %eax,%eax
801052a5:	89 c6                	mov    %eax,%esi
801052a7:	74 5b                	je     80105304 <sys_link+0xf4>
  ilock(dp);
801052a9:	83 ec 0c             	sub    $0xc,%esp
801052ac:	50                   	push   %eax
801052ad:	e8 2e c4 ff ff       	call   801016e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	8b 03                	mov    (%ebx),%eax
801052b7:	39 06                	cmp    %eax,(%esi)
801052b9:	75 3d                	jne    801052f8 <sys_link+0xe8>
801052bb:	83 ec 04             	sub    $0x4,%esp
801052be:	ff 73 04             	pushl  0x4(%ebx)
801052c1:	57                   	push   %edi
801052c2:	56                   	push   %esi
801052c3:	e8 b8 cb ff ff       	call   80101e80 <dirlink>
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	85 c0                	test   %eax,%eax
801052cd:	78 29                	js     801052f8 <sys_link+0xe8>
  iunlockput(dp);
801052cf:	83 ec 0c             	sub    $0xc,%esp
801052d2:	56                   	push   %esi
801052d3:	e8 98 c6 ff ff       	call   80101970 <iunlockput>
  iput(ip);
801052d8:	89 1c 24             	mov    %ebx,(%esp)
801052db:	e8 30 c5 ff ff       	call   80101810 <iput>
  end_op();
801052e0:	e8 8b d9 ff ff       	call   80102c70 <end_op>
  return 0;
801052e5:	83 c4 10             	add    $0x10,%esp
801052e8:	31 c0                	xor    %eax,%eax
}
801052ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ed:	5b                   	pop    %ebx
801052ee:	5e                   	pop    %esi
801052ef:	5f                   	pop    %edi
801052f0:	5d                   	pop    %ebp
801052f1:	c3                   	ret    
801052f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801052f8:	83 ec 0c             	sub    $0xc,%esp
801052fb:	56                   	push   %esi
801052fc:	e8 6f c6 ff ff       	call   80101970 <iunlockput>
    goto bad;
80105301:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105304:	83 ec 0c             	sub    $0xc,%esp
80105307:	53                   	push   %ebx
80105308:	e8 d3 c3 ff ff       	call   801016e0 <ilock>
  ip->nlink--;
8010530d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105312:	89 1c 24             	mov    %ebx,(%esp)
80105315:	e8 16 c3 ff ff       	call   80101630 <iupdate>
  iunlockput(ip);
8010531a:	89 1c 24             	mov    %ebx,(%esp)
8010531d:	e8 4e c6 ff ff       	call   80101970 <iunlockput>
  end_op();
80105322:	e8 49 d9 ff ff       	call   80102c70 <end_op>
  return -1;
80105327:	83 c4 10             	add    $0x10,%esp
}
8010532a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010532d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105332:	5b                   	pop    %ebx
80105333:	5e                   	pop    %esi
80105334:	5f                   	pop    %edi
80105335:	5d                   	pop    %ebp
80105336:	c3                   	ret    
    iunlockput(ip);
80105337:	83 ec 0c             	sub    $0xc,%esp
8010533a:	53                   	push   %ebx
8010533b:	e8 30 c6 ff ff       	call   80101970 <iunlockput>
    end_op();
80105340:	e8 2b d9 ff ff       	call   80102c70 <end_op>
    return -1;
80105345:	83 c4 10             	add    $0x10,%esp
80105348:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010534d:	eb 9b                	jmp    801052ea <sys_link+0xda>
    end_op();
8010534f:	e8 1c d9 ff ff       	call   80102c70 <end_op>
    return -1;
80105354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105359:	eb 8f                	jmp    801052ea <sys_link+0xda>
8010535b:	90                   	nop
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105360 <sys_unlink>:
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105366:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105369:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010536c:	50                   	push   %eax
8010536d:	6a 00                	push   $0x0
8010536f:	e8 1c fa ff ff       	call   80104d90 <argstr>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	0f 88 77 01 00 00    	js     801054f6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010537f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105382:	e8 79 d8 ff ff       	call   80102c00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105387:	83 ec 08             	sub    $0x8,%esp
8010538a:	53                   	push   %ebx
8010538b:	ff 75 c0             	pushl  -0x40(%ebp)
8010538e:	e8 cd cb ff ff       	call   80101f60 <nameiparent>
80105393:	83 c4 10             	add    $0x10,%esp
80105396:	85 c0                	test   %eax,%eax
80105398:	89 c6                	mov    %eax,%esi
8010539a:	0f 84 60 01 00 00    	je     80105500 <sys_unlink+0x1a0>
  ilock(dp);
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	50                   	push   %eax
801053a4:	e8 37 c3 ff ff       	call   801016e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053a9:	58                   	pop    %eax
801053aa:	5a                   	pop    %edx
801053ab:	68 40 7d 10 80       	push   $0x80107d40
801053b0:	53                   	push   %ebx
801053b1:	e8 3a c8 ff ff       	call   80101bf0 <namecmp>
801053b6:	83 c4 10             	add    $0x10,%esp
801053b9:	85 c0                	test   %eax,%eax
801053bb:	0f 84 03 01 00 00    	je     801054c4 <sys_unlink+0x164>
801053c1:	83 ec 08             	sub    $0x8,%esp
801053c4:	68 3f 7d 10 80       	push   $0x80107d3f
801053c9:	53                   	push   %ebx
801053ca:	e8 21 c8 ff ff       	call   80101bf0 <namecmp>
801053cf:	83 c4 10             	add    $0x10,%esp
801053d2:	85 c0                	test   %eax,%eax
801053d4:	0f 84 ea 00 00 00    	je     801054c4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053da:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053dd:	83 ec 04             	sub    $0x4,%esp
801053e0:	50                   	push   %eax
801053e1:	53                   	push   %ebx
801053e2:	56                   	push   %esi
801053e3:	e8 28 c8 ff ff       	call   80101c10 <dirlookup>
801053e8:	83 c4 10             	add    $0x10,%esp
801053eb:	85 c0                	test   %eax,%eax
801053ed:	89 c3                	mov    %eax,%ebx
801053ef:	0f 84 cf 00 00 00    	je     801054c4 <sys_unlink+0x164>
  ilock(ip);
801053f5:	83 ec 0c             	sub    $0xc,%esp
801053f8:	50                   	push   %eax
801053f9:	e8 e2 c2 ff ff       	call   801016e0 <ilock>
  if(ip->nlink < 1)
801053fe:	83 c4 10             	add    $0x10,%esp
80105401:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105406:	0f 8e 10 01 00 00    	jle    8010551c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010540c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105411:	74 6d                	je     80105480 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105413:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105416:	83 ec 04             	sub    $0x4,%esp
80105419:	6a 10                	push   $0x10
8010541b:	6a 00                	push   $0x0
8010541d:	50                   	push   %eax
8010541e:	e8 bd f5 ff ff       	call   801049e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105423:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105426:	6a 10                	push   $0x10
80105428:	ff 75 c4             	pushl  -0x3c(%ebp)
8010542b:	50                   	push   %eax
8010542c:	56                   	push   %esi
8010542d:	e8 8e c6 ff ff       	call   80101ac0 <writei>
80105432:	83 c4 20             	add    $0x20,%esp
80105435:	83 f8 10             	cmp    $0x10,%eax
80105438:	0f 85 eb 00 00 00    	jne    80105529 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010543e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105443:	0f 84 97 00 00 00    	je     801054e0 <sys_unlink+0x180>
  iunlockput(dp);
80105449:	83 ec 0c             	sub    $0xc,%esp
8010544c:	56                   	push   %esi
8010544d:	e8 1e c5 ff ff       	call   80101970 <iunlockput>
  ip->nlink--;
80105452:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105457:	89 1c 24             	mov    %ebx,(%esp)
8010545a:	e8 d1 c1 ff ff       	call   80101630 <iupdate>
  iunlockput(ip);
8010545f:	89 1c 24             	mov    %ebx,(%esp)
80105462:	e8 09 c5 ff ff       	call   80101970 <iunlockput>
  end_op();
80105467:	e8 04 d8 ff ff       	call   80102c70 <end_op>
  return 0;
8010546c:	83 c4 10             	add    $0x10,%esp
8010546f:	31 c0                	xor    %eax,%eax
}
80105471:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105474:	5b                   	pop    %ebx
80105475:	5e                   	pop    %esi
80105476:	5f                   	pop    %edi
80105477:	5d                   	pop    %ebp
80105478:	c3                   	ret    
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105480:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105484:	76 8d                	jbe    80105413 <sys_unlink+0xb3>
80105486:	bf 20 00 00 00       	mov    $0x20,%edi
8010548b:	eb 0f                	jmp    8010549c <sys_unlink+0x13c>
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
80105490:	83 c7 10             	add    $0x10,%edi
80105493:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105496:	0f 83 77 ff ff ff    	jae    80105413 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010549c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010549f:	6a 10                	push   $0x10
801054a1:	57                   	push   %edi
801054a2:	50                   	push   %eax
801054a3:	53                   	push   %ebx
801054a4:	e8 17 c5 ff ff       	call   801019c0 <readi>
801054a9:	83 c4 10             	add    $0x10,%esp
801054ac:	83 f8 10             	cmp    $0x10,%eax
801054af:	75 5e                	jne    8010550f <sys_unlink+0x1af>
    if(de.inum != 0)
801054b1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054b6:	74 d8                	je     80105490 <sys_unlink+0x130>
    iunlockput(ip);
801054b8:	83 ec 0c             	sub    $0xc,%esp
801054bb:	53                   	push   %ebx
801054bc:	e8 af c4 ff ff       	call   80101970 <iunlockput>
    goto bad;
801054c1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801054c4:	83 ec 0c             	sub    $0xc,%esp
801054c7:	56                   	push   %esi
801054c8:	e8 a3 c4 ff ff       	call   80101970 <iunlockput>
  end_op();
801054cd:	e8 9e d7 ff ff       	call   80102c70 <end_op>
  return -1;
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054da:	eb 95                	jmp    80105471 <sys_unlink+0x111>
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801054e0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801054e5:	83 ec 0c             	sub    $0xc,%esp
801054e8:	56                   	push   %esi
801054e9:	e8 42 c1 ff ff       	call   80101630 <iupdate>
801054ee:	83 c4 10             	add    $0x10,%esp
801054f1:	e9 53 ff ff ff       	jmp    80105449 <sys_unlink+0xe9>
    return -1;
801054f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054fb:	e9 71 ff ff ff       	jmp    80105471 <sys_unlink+0x111>
    end_op();
80105500:	e8 6b d7 ff ff       	call   80102c70 <end_op>
    return -1;
80105505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550a:	e9 62 ff ff ff       	jmp    80105471 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010550f:	83 ec 0c             	sub    $0xc,%esp
80105512:	68 64 7d 10 80       	push   $0x80107d64
80105517:	e8 74 ae ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010551c:	83 ec 0c             	sub    $0xc,%esp
8010551f:	68 52 7d 10 80       	push   $0x80107d52
80105524:	e8 67 ae ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	68 76 7d 10 80       	push   $0x80107d76
80105531:	e8 5a ae ff ff       	call   80100390 <panic>
80105536:	8d 76 00             	lea    0x0(%esi),%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <sys_open>:

int
sys_open(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	57                   	push   %edi
80105544:	56                   	push   %esi
80105545:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105546:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105549:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010554c:	50                   	push   %eax
8010554d:	6a 00                	push   $0x0
8010554f:	e8 3c f8 ff ff       	call   80104d90 <argstr>
80105554:	83 c4 10             	add    $0x10,%esp
80105557:	85 c0                	test   %eax,%eax
80105559:	0f 88 1d 01 00 00    	js     8010567c <sys_open+0x13c>
8010555f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105562:	83 ec 08             	sub    $0x8,%esp
80105565:	50                   	push   %eax
80105566:	6a 01                	push   $0x1
80105568:	e8 73 f7 ff ff       	call   80104ce0 <argint>
8010556d:	83 c4 10             	add    $0x10,%esp
80105570:	85 c0                	test   %eax,%eax
80105572:	0f 88 04 01 00 00    	js     8010567c <sys_open+0x13c>
    return -1;

  begin_op();
80105578:	e8 83 d6 ff ff       	call   80102c00 <begin_op>

  if(omode & O_CREATE){
8010557d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105581:	0f 85 a9 00 00 00    	jne    80105630 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105587:	83 ec 0c             	sub    $0xc,%esp
8010558a:	ff 75 e0             	pushl  -0x20(%ebp)
8010558d:	e8 ae c9 ff ff       	call   80101f40 <namei>
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	85 c0                	test   %eax,%eax
80105597:	89 c6                	mov    %eax,%esi
80105599:	0f 84 b2 00 00 00    	je     80105651 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010559f:	83 ec 0c             	sub    $0xc,%esp
801055a2:	50                   	push   %eax
801055a3:	e8 38 c1 ff ff       	call   801016e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055b0:	0f 84 aa 00 00 00    	je     80105660 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055b6:	e8 25 b8 ff ff       	call   80100de0 <filealloc>
801055bb:	85 c0                	test   %eax,%eax
801055bd:	89 c7                	mov    %eax,%edi
801055bf:	0f 84 a6 00 00 00    	je     8010566b <sys_open+0x12b>
  struct proc *curproc = myproc();
801055c5:	e8 d6 e2 ff ff       	call   801038a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055ca:	31 db                	xor    %ebx,%ebx
801055cc:	eb 0e                	jmp    801055dc <sys_open+0x9c>
801055ce:	66 90                	xchg   %ax,%ax
801055d0:	83 c3 01             	add    $0x1,%ebx
801055d3:	83 fb 10             	cmp    $0x10,%ebx
801055d6:	0f 84 ac 00 00 00    	je     80105688 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801055dc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055e0:	85 d2                	test   %edx,%edx
801055e2:	75 ec                	jne    801055d0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055e4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055e7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055eb:	56                   	push   %esi
801055ec:	e8 cf c1 ff ff       	call   801017c0 <iunlock>
  end_op();
801055f1:	e8 7a d6 ff ff       	call   80102c70 <end_op>

  f->type = FD_INODE;
801055f6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801055fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801055ff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105602:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105605:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010560c:	89 d0                	mov    %edx,%eax
8010560e:	f7 d0                	not    %eax
80105610:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105613:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105616:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105619:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010561d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105620:	89 d8                	mov    %ebx,%eax
80105622:	5b                   	pop    %ebx
80105623:	5e                   	pop    %esi
80105624:	5f                   	pop    %edi
80105625:	5d                   	pop    %ebp
80105626:	c3                   	ret    
80105627:	89 f6                	mov    %esi,%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105630:	83 ec 0c             	sub    $0xc,%esp
80105633:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105636:	31 c9                	xor    %ecx,%ecx
80105638:	6a 00                	push   $0x0
8010563a:	ba 02 00 00 00       	mov    $0x2,%edx
8010563f:	e8 ec f7 ff ff       	call   80104e30 <create>
    if(ip == 0){
80105644:	83 c4 10             	add    $0x10,%esp
80105647:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105649:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010564b:	0f 85 65 ff ff ff    	jne    801055b6 <sys_open+0x76>
      end_op();
80105651:	e8 1a d6 ff ff       	call   80102c70 <end_op>
      return -1;
80105656:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010565b:	eb c0                	jmp    8010561d <sys_open+0xdd>
8010565d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105660:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105663:	85 c9                	test   %ecx,%ecx
80105665:	0f 84 4b ff ff ff    	je     801055b6 <sys_open+0x76>
    iunlockput(ip);
8010566b:	83 ec 0c             	sub    $0xc,%esp
8010566e:	56                   	push   %esi
8010566f:	e8 fc c2 ff ff       	call   80101970 <iunlockput>
    end_op();
80105674:	e8 f7 d5 ff ff       	call   80102c70 <end_op>
    return -1;
80105679:	83 c4 10             	add    $0x10,%esp
8010567c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105681:	eb 9a                	jmp    8010561d <sys_open+0xdd>
80105683:	90                   	nop
80105684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105688:	83 ec 0c             	sub    $0xc,%esp
8010568b:	57                   	push   %edi
8010568c:	e8 0f b8 ff ff       	call   80100ea0 <fileclose>
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	eb d5                	jmp    8010566b <sys_open+0x12b>
80105696:	8d 76 00             	lea    0x0(%esi),%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056a6:	e8 55 d5 ff ff       	call   80102c00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056ae:	83 ec 08             	sub    $0x8,%esp
801056b1:	50                   	push   %eax
801056b2:	6a 00                	push   $0x0
801056b4:	e8 d7 f6 ff ff       	call   80104d90 <argstr>
801056b9:	83 c4 10             	add    $0x10,%esp
801056bc:	85 c0                	test   %eax,%eax
801056be:	78 30                	js     801056f0 <sys_mkdir+0x50>
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c6:	31 c9                	xor    %ecx,%ecx
801056c8:	6a 00                	push   $0x0
801056ca:	ba 01 00 00 00       	mov    $0x1,%edx
801056cf:	e8 5c f7 ff ff       	call   80104e30 <create>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
801056d9:	74 15                	je     801056f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056db:	83 ec 0c             	sub    $0xc,%esp
801056de:	50                   	push   %eax
801056df:	e8 8c c2 ff ff       	call   80101970 <iunlockput>
  end_op();
801056e4:	e8 87 d5 ff ff       	call   80102c70 <end_op>
  return 0;
801056e9:	83 c4 10             	add    $0x10,%esp
801056ec:	31 c0                	xor    %eax,%eax
}
801056ee:	c9                   	leave  
801056ef:	c3                   	ret    
    end_op();
801056f0:	e8 7b d5 ff ff       	call   80102c70 <end_op>
    return -1;
801056f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056fa:	c9                   	leave  
801056fb:	c3                   	ret    
801056fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105700 <sys_mknod>:

int
sys_mknod(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105706:	e8 f5 d4 ff ff       	call   80102c00 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010570b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010570e:	83 ec 08             	sub    $0x8,%esp
80105711:	50                   	push   %eax
80105712:	6a 00                	push   $0x0
80105714:	e8 77 f6 ff ff       	call   80104d90 <argstr>
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	85 c0                	test   %eax,%eax
8010571e:	78 60                	js     80105780 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105720:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105723:	83 ec 08             	sub    $0x8,%esp
80105726:	50                   	push   %eax
80105727:	6a 01                	push   $0x1
80105729:	e8 b2 f5 ff ff       	call   80104ce0 <argint>
  if((argstr(0, &path)) < 0 ||
8010572e:	83 c4 10             	add    $0x10,%esp
80105731:	85 c0                	test   %eax,%eax
80105733:	78 4b                	js     80105780 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105735:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105738:	83 ec 08             	sub    $0x8,%esp
8010573b:	50                   	push   %eax
8010573c:	6a 02                	push   $0x2
8010573e:	e8 9d f5 ff ff       	call   80104ce0 <argint>
     argint(1, &major) < 0 ||
80105743:	83 c4 10             	add    $0x10,%esp
80105746:	85 c0                	test   %eax,%eax
80105748:	78 36                	js     80105780 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010574a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010574e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105751:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105755:	ba 03 00 00 00       	mov    $0x3,%edx
8010575a:	50                   	push   %eax
8010575b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010575e:	e8 cd f6 ff ff       	call   80104e30 <create>
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	85 c0                	test   %eax,%eax
80105768:	74 16                	je     80105780 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010576a:	83 ec 0c             	sub    $0xc,%esp
8010576d:	50                   	push   %eax
8010576e:	e8 fd c1 ff ff       	call   80101970 <iunlockput>
  end_op();
80105773:	e8 f8 d4 ff ff       	call   80102c70 <end_op>
  return 0;
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	31 c0                	xor    %eax,%eax
}
8010577d:	c9                   	leave  
8010577e:	c3                   	ret    
8010577f:	90                   	nop
    end_op();
80105780:	e8 eb d4 ff ff       	call   80102c70 <end_op>
    return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_chdir>:

int
sys_chdir(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	56                   	push   %esi
80105794:	53                   	push   %ebx
80105795:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105798:	e8 03 e1 ff ff       	call   801038a0 <myproc>
8010579d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010579f:	e8 5c d4 ff ff       	call   80102c00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057a7:	83 ec 08             	sub    $0x8,%esp
801057aa:	50                   	push   %eax
801057ab:	6a 00                	push   $0x0
801057ad:	e8 de f5 ff ff       	call   80104d90 <argstr>
801057b2:	83 c4 10             	add    $0x10,%esp
801057b5:	85 c0                	test   %eax,%eax
801057b7:	78 77                	js     80105830 <sys_chdir+0xa0>
801057b9:	83 ec 0c             	sub    $0xc,%esp
801057bc:	ff 75 f4             	pushl  -0xc(%ebp)
801057bf:	e8 7c c7 ff ff       	call   80101f40 <namei>
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	85 c0                	test   %eax,%eax
801057c9:	89 c3                	mov    %eax,%ebx
801057cb:	74 63                	je     80105830 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057cd:	83 ec 0c             	sub    $0xc,%esp
801057d0:	50                   	push   %eax
801057d1:	e8 0a bf ff ff       	call   801016e0 <ilock>
  if(ip->type != T_DIR){
801057d6:	83 c4 10             	add    $0x10,%esp
801057d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057de:	75 30                	jne    80105810 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057e0:	83 ec 0c             	sub    $0xc,%esp
801057e3:	53                   	push   %ebx
801057e4:	e8 d7 bf ff ff       	call   801017c0 <iunlock>
  iput(curproc->cwd);
801057e9:	58                   	pop    %eax
801057ea:	ff 76 68             	pushl  0x68(%esi)
801057ed:	e8 1e c0 ff ff       	call   80101810 <iput>
  end_op();
801057f2:	e8 79 d4 ff ff       	call   80102c70 <end_op>
  curproc->cwd = ip;
801057f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801057fa:	83 c4 10             	add    $0x10,%esp
801057fd:	31 c0                	xor    %eax,%eax
}
801057ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105802:	5b                   	pop    %ebx
80105803:	5e                   	pop    %esi
80105804:	5d                   	pop    %ebp
80105805:	c3                   	ret    
80105806:	8d 76 00             	lea    0x0(%esi),%esi
80105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	53                   	push   %ebx
80105814:	e8 57 c1 ff ff       	call   80101970 <iunlockput>
    end_op();
80105819:	e8 52 d4 ff ff       	call   80102c70 <end_op>
    return -1;
8010581e:	83 c4 10             	add    $0x10,%esp
80105821:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105826:	eb d7                	jmp    801057ff <sys_chdir+0x6f>
80105828:	90                   	nop
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105830:	e8 3b d4 ff ff       	call   80102c70 <end_op>
    return -1;
80105835:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583a:	eb c3                	jmp    801057ff <sys_chdir+0x6f>
8010583c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105840 <sys_exec>:

int
sys_exec(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	57                   	push   %edi
80105844:	56                   	push   %esi
80105845:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105846:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010584c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105852:	50                   	push   %eax
80105853:	6a 00                	push   $0x0
80105855:	e8 36 f5 ff ff       	call   80104d90 <argstr>
8010585a:	83 c4 10             	add    $0x10,%esp
8010585d:	85 c0                	test   %eax,%eax
8010585f:	0f 88 87 00 00 00    	js     801058ec <sys_exec+0xac>
80105865:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010586b:	83 ec 08             	sub    $0x8,%esp
8010586e:	50                   	push   %eax
8010586f:	6a 01                	push   $0x1
80105871:	e8 6a f4 ff ff       	call   80104ce0 <argint>
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	85 c0                	test   %eax,%eax
8010587b:	78 6f                	js     801058ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010587d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105883:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105886:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105888:	68 80 00 00 00       	push   $0x80
8010588d:	6a 00                	push   $0x0
8010588f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105895:	50                   	push   %eax
80105896:	e8 45 f1 ff ff       	call   801049e0 <memset>
8010589b:	83 c4 10             	add    $0x10,%esp
8010589e:	eb 2c                	jmp    801058cc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801058a0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058a6:	85 c0                	test   %eax,%eax
801058a8:	74 56                	je     80105900 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058aa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801058b0:	83 ec 08             	sub    $0x8,%esp
801058b3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801058b6:	52                   	push   %edx
801058b7:	50                   	push   %eax
801058b8:	e8 b3 f3 ff ff       	call   80104c70 <fetchstr>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	78 28                	js     801058ec <sys_exec+0xac>
  for(i=0;; i++){
801058c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801058c7:	83 fb 20             	cmp    $0x20,%ebx
801058ca:	74 20                	je     801058ec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058cc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058d2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801058d9:	83 ec 08             	sub    $0x8,%esp
801058dc:	57                   	push   %edi
801058dd:	01 f0                	add    %esi,%eax
801058df:	50                   	push   %eax
801058e0:	e8 4b f3 ff ff       	call   80104c30 <fetchint>
801058e5:	83 c4 10             	add    $0x10,%esp
801058e8:	85 c0                	test   %eax,%eax
801058ea:	79 b4                	jns    801058a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801058ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801058ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f4:	5b                   	pop    %ebx
801058f5:	5e                   	pop    %esi
801058f6:	5f                   	pop    %edi
801058f7:	5d                   	pop    %ebp
801058f8:	c3                   	ret    
801058f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105900:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105906:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105909:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105910:	00 00 00 00 
  return exec(path, argv);
80105914:	50                   	push   %eax
80105915:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010591b:	e8 f0 b0 ff ff       	call   80100a10 <exec>
80105920:	83 c4 10             	add    $0x10,%esp
}
80105923:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105926:	5b                   	pop    %ebx
80105927:	5e                   	pop    %esi
80105928:	5f                   	pop    %edi
80105929:	5d                   	pop    %ebp
8010592a:	c3                   	ret    
8010592b:	90                   	nop
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105930 <sys_pipe>:

int
sys_pipe(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	57                   	push   %edi
80105934:	56                   	push   %esi
80105935:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105936:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105939:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010593c:	6a 08                	push   $0x8
8010593e:	50                   	push   %eax
8010593f:	6a 00                	push   $0x0
80105941:	e8 ea f3 ff ff       	call   80104d30 <argptr>
80105946:	83 c4 10             	add    $0x10,%esp
80105949:	85 c0                	test   %eax,%eax
8010594b:	0f 88 ae 00 00 00    	js     801059ff <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105951:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105954:	83 ec 08             	sub    $0x8,%esp
80105957:	50                   	push   %eax
80105958:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010595b:	50                   	push   %eax
8010595c:	e8 3f d9 ff ff       	call   801032a0 <pipealloc>
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	85 c0                	test   %eax,%eax
80105966:	0f 88 93 00 00 00    	js     801059ff <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010596c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010596f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105971:	e8 2a df ff ff       	call   801038a0 <myproc>
80105976:	eb 10                	jmp    80105988 <sys_pipe+0x58>
80105978:	90                   	nop
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105980:	83 c3 01             	add    $0x1,%ebx
80105983:	83 fb 10             	cmp    $0x10,%ebx
80105986:	74 60                	je     801059e8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105988:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010598c:	85 f6                	test   %esi,%esi
8010598e:	75 f0                	jne    80105980 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105990:	8d 73 08             	lea    0x8(%ebx),%esi
80105993:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105997:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010599a:	e8 01 df ff ff       	call   801038a0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010599f:	31 d2                	xor    %edx,%edx
801059a1:	eb 0d                	jmp    801059b0 <sys_pipe+0x80>
801059a3:	90                   	nop
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059a8:	83 c2 01             	add    $0x1,%edx
801059ab:	83 fa 10             	cmp    $0x10,%edx
801059ae:	74 28                	je     801059d8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801059b0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059b4:	85 c9                	test   %ecx,%ecx
801059b6:	75 f0                	jne    801059a8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801059b8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801059bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059bf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801059c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059c4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801059c7:	31 c0                	xor    %eax,%eax
}
801059c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059cc:	5b                   	pop    %ebx
801059cd:	5e                   	pop    %esi
801059ce:	5f                   	pop    %edi
801059cf:	5d                   	pop    %ebp
801059d0:	c3                   	ret    
801059d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801059d8:	e8 c3 de ff ff       	call   801038a0 <myproc>
801059dd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059e4:	00 
801059e5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	ff 75 e0             	pushl  -0x20(%ebp)
801059ee:	e8 ad b4 ff ff       	call   80100ea0 <fileclose>
    fileclose(wf);
801059f3:	58                   	pop    %eax
801059f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801059f7:	e8 a4 b4 ff ff       	call   80100ea0 <fileclose>
    return -1;
801059fc:	83 c4 10             	add    $0x10,%esp
801059ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a04:	eb c3                	jmp    801059c9 <sys_pipe+0x99>
80105a06:	66 90                	xchg   %ax,%ax
80105a08:	66 90                	xchg   %ax,%ax
80105a0a:	66 90                	xchg   %ax,%ax
80105a0c:	66 90                	xchg   %ax,%ax
80105a0e:	66 90                	xchg   %ax,%ax

80105a10 <sys_fork>:
#include "proc.h"


int
sys_fork(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105a13:	5d                   	pop    %ebp
  return fork();
80105a14:	e9 a7 e0 ff ff       	jmp    80103ac0 <fork>
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_exit>:

int
sys_exit(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a26:	e8 f5 e3 ff ff       	call   80103e20 <exit>
  return 0;  // not reached
}
80105a2b:	31 c0                	xor    %eax,%eax
80105a2d:	c9                   	leave  
80105a2e:	c3                   	ret    
80105a2f:	90                   	nop

80105a30 <sys_wait>:

int
sys_wait(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105a33:	5d                   	pop    %ebp
  return wait();
80105a34:	e9 47 e6 ff ff       	jmp    80104080 <wait>
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_kill>:

int
sys_kill(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int signum;

  if(argint(0, &pid) < 0)
80105a46:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a49:	50                   	push   %eax
80105a4a:	6a 00                	push   $0x0
80105a4c:	e8 8f f2 ff ff       	call   80104ce0 <argint>
80105a51:	83 c4 10             	add    $0x10,%esp
80105a54:	85 c0                	test   %eax,%eax
80105a56:	78 28                	js     80105a80 <sys_kill+0x40>
    return -1;
  if(argint(1, &signum) < 0)
80105a58:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a5b:	83 ec 08             	sub    $0x8,%esp
80105a5e:	50                   	push   %eax
80105a5f:	6a 01                	push   $0x1
80105a61:	e8 7a f2 ff ff       	call   80104ce0 <argint>
80105a66:	83 c4 10             	add    $0x10,%esp
80105a69:	85 c0                	test   %eax,%eax
80105a6b:	78 13                	js     80105a80 <sys_kill+0x40>
    return -1;
  return kill(pid, signum);
80105a6d:	83 ec 08             	sub    $0x8,%esp
80105a70:	ff 75 f4             	pushl  -0xc(%ebp)
80105a73:	ff 75 f0             	pushl  -0x10(%ebp)
80105a76:	e8 85 e7 ff ff       	call   80104200 <kill>
80105a7b:	83 c4 10             	add    $0x10,%esp
}
80105a7e:	c9                   	leave  
80105a7f:	c3                   	ret    
    return -1;
80105a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a85:	c9                   	leave  
80105a86:	c3                   	ret    
80105a87:	89 f6                	mov    %esi,%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a90 <sys_getpid>:

int
sys_getpid(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a96:	e8 05 de ff ff       	call   801038a0 <myproc>
80105a9b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a9e:	c9                   	leave  
80105a9f:	c3                   	ret    

80105aa0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105aa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aaa:	50                   	push   %eax
80105aab:	6a 00                	push   $0x0
80105aad:	e8 2e f2 ff ff       	call   80104ce0 <argint>
80105ab2:	83 c4 10             	add    $0x10,%esp
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	78 27                	js     80105ae0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ab9:	e8 e2 dd ff ff       	call   801038a0 <myproc>
  if(growproc(n) < 0)
80105abe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ac1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ac3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ac6:	e8 75 df ff ff       	call   80103a40 <growproc>
80105acb:	83 c4 10             	add    $0x10,%esp
80105ace:	85 c0                	test   %eax,%eax
80105ad0:	78 0e                	js     80105ae0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ad2:	89 d8                	mov    %ebx,%eax
80105ad4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad7:	c9                   	leave  
80105ad8:	c3                   	ret    
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ae0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ae5:	eb eb                	jmp    80105ad2 <sys_sbrk+0x32>
80105ae7:	89 f6                	mov    %esi,%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105af0 <sys_sleep>:

int
sys_sleep(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105af7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105afa:	50                   	push   %eax
80105afb:	6a 00                	push   $0x0
80105afd:	e8 de f1 ff ff       	call   80104ce0 <argint>
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	0f 88 8a 00 00 00    	js     80105b97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b0d:	83 ec 0c             	sub    $0xc,%esp
80105b10:	68 60 70 11 80       	push   $0x80117060
80105b15:	e8 b6 ed ff ff       	call   801048d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b1d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105b20:	8b 1d a0 78 11 80    	mov    0x801178a0,%ebx
  while(ticks - ticks0 < n){
80105b26:	85 d2                	test   %edx,%edx
80105b28:	75 27                	jne    80105b51 <sys_sleep+0x61>
80105b2a:	eb 54                	jmp    80105b80 <sys_sleep+0x90>
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b30:	83 ec 08             	sub    $0x8,%esp
80105b33:	68 60 70 11 80       	push   $0x80117060
80105b38:	68 a0 78 11 80       	push   $0x801178a0
80105b3d:	e8 5e e4 ff ff       	call   80103fa0 <sleep>
  while(ticks - ticks0 < n){
80105b42:	a1 a0 78 11 80       	mov    0x801178a0,%eax
80105b47:	83 c4 10             	add    $0x10,%esp
80105b4a:	29 d8                	sub    %ebx,%eax
80105b4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b4f:	73 2f                	jae    80105b80 <sys_sleep+0x90>
    if(myproc()->killed){
80105b51:	e8 4a dd ff ff       	call   801038a0 <myproc>
80105b56:	8b 40 24             	mov    0x24(%eax),%eax
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	74 d3                	je     80105b30 <sys_sleep+0x40>
      release(&tickslock);
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	68 60 70 11 80       	push   $0x80117060
80105b65:	e8 26 ee ff ff       	call   80104990 <release>
      return -1;
80105b6a:	83 c4 10             	add    $0x10,%esp
80105b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105b72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	68 60 70 11 80       	push   $0x80117060
80105b88:	e8 03 ee ff ff       	call   80104990 <release>
  return 0;
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	31 c0                	xor    %eax,%eax
}
80105b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b95:	c9                   	leave  
80105b96:	c3                   	ret    
    return -1;
80105b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9c:	eb f4                	jmp    80105b92 <sys_sleep+0xa2>
80105b9e:	66 90                	xchg   %ax,%ax

80105ba0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	53                   	push   %ebx
80105ba4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ba7:	68 60 70 11 80       	push   $0x80117060
80105bac:	e8 1f ed ff ff       	call   801048d0 <acquire>
  xticks = ticks;
80105bb1:	8b 1d a0 78 11 80    	mov    0x801178a0,%ebx
  release(&tickslock);
80105bb7:	c7 04 24 60 70 11 80 	movl   $0x80117060,(%esp)
80105bbe:	e8 cd ed ff ff       	call   80104990 <release>
  return xticks;
}
80105bc3:	89 d8                	mov    %ebx,%eax
80105bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bc8:	c9                   	leave  
80105bc9:	c3                   	ret    
80105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bd0 <sys_sigprocmask>:

// assignment 2
uint
sys_sigprocmask(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 20             	sub    $0x20,%esp
  uint new_mask;
  if (argint(0, (int*)&new_mask) < 0)
80105bd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bd9:	50                   	push   %eax
80105bda:	6a 00                	push   $0x0
80105bdc:	e8 ff f0 ff ff       	call   80104ce0 <argint>
80105be1:	83 c4 10             	add    $0x10,%esp
80105be4:	85 c0                	test   %eax,%eax
80105be6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80105beb:	78 10                	js     80105bfd <sys_sigprocmask+0x2d>
    return -1;
  return sigprocmask(new_mask);
80105bed:	83 ec 0c             	sub    $0xc,%esp
80105bf0:	ff 75 f4             	pushl  -0xc(%ebp)
80105bf3:	e8 58 e6 ff ff       	call   80104250 <sigprocmask>
80105bf8:	83 c4 10             	add    $0x10,%esp
80105bfb:	89 c2                	mov    %eax,%edx
}
80105bfd:	89 d0                	mov    %edx,%eax
80105bff:	c9                   	leave  
80105c00:	c3                   	ret    
80105c01:	eb 0d                	jmp    80105c10 <sys_sigaction>
80105c03:	90                   	nop
80105c04:	90                   	nop
80105c05:	90                   	nop
80105c06:	90                   	nop
80105c07:	90                   	nop
80105c08:	90                   	nop
80105c09:	90                   	nop
80105c0a:	90                   	nop
80105c0b:	90                   	nop
80105c0c:	90                   	nop
80105c0d:	90                   	nop
80105c0e:	90                   	nop
80105c0f:	90                   	nop

80105c10 <sys_sigaction>:


int
sys_sigaction(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 20             	sub    $0x20,%esp
  int signum;
  struct sigaction *act;
  struct sigaction *oldact;

  if(argint(0, &signum) < 0)
80105c16:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c19:	50                   	push   %eax
80105c1a:	6a 00                	push   $0x0
80105c1c:	e8 bf f0 ff ff       	call   80104ce0 <argint>
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	85 c0                	test   %eax,%eax
80105c26:	78 48                	js     80105c70 <sys_sigaction+0x60>
    return -1;

  if(argptr(1, (char**)&act, sizeof(struct sigaction)) < 0)
80105c28:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c2b:	83 ec 04             	sub    $0x4,%esp
80105c2e:	6a 08                	push   $0x8
80105c30:	50                   	push   %eax
80105c31:	6a 01                	push   $0x1
80105c33:	e8 f8 f0 ff ff       	call   80104d30 <argptr>
80105c38:	83 c4 10             	add    $0x10,%esp
80105c3b:	85 c0                	test   %eax,%eax
80105c3d:	78 31                	js     80105c70 <sys_sigaction+0x60>
    return -1;

  if(argptr(2, (char**)&oldact, sizeof(struct sigaction)) < 0)
80105c3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c42:	83 ec 04             	sub    $0x4,%esp
80105c45:	6a 08                	push   $0x8
80105c47:	50                   	push   %eax
80105c48:	6a 02                	push   $0x2
80105c4a:	e8 e1 f0 ff ff       	call   80104d30 <argptr>
80105c4f:	83 c4 10             	add    $0x10,%esp
80105c52:	85 c0                	test   %eax,%eax
80105c54:	78 1a                	js     80105c70 <sys_sigaction+0x60>
    return -1;

  return sigaction(signum, act, oldact);
80105c56:	83 ec 04             	sub    $0x4,%esp
80105c59:	ff 75 f4             	pushl  -0xc(%ebp)
80105c5c:	ff 75 f0             	pushl  -0x10(%ebp)
80105c5f:	ff 75 ec             	pushl  -0x14(%ebp)
80105c62:	e8 d9 e7 ff ff       	call   80104440 <sigaction>
80105c67:	83 c4 10             	add    $0x10,%esp

}
80105c6a:	c9                   	leave  
80105c6b:	c3                   	ret    
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <sys_sigret>:

int
sys_sigret(void) 
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
  return sigret();
80105c83:	5d                   	pop    %ebp
  return sigret();
80105c84:	e9 97 e9 ff ff       	jmp    80104620 <sigret>

80105c89 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c89:	1e                   	push   %ds
  pushl %es
80105c8a:	06                   	push   %es
  pushl %fs
80105c8b:	0f a0                	push   %fs
  pushl %gs
80105c8d:	0f a8                	push   %gs
  pushal
80105c8f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c90:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c94:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c96:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c98:	54                   	push   %esp
  call trap
80105c99:	e8 d2 00 00 00       	call   80105d70 <trap>
  addl $4, %esp
80105c9e:	83 c4 04             	add    $0x4,%esp

80105ca1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  call handle_signals
80105ca1:	e8 0a e9 ff ff       	call   801045b0 <handle_signals>
  popal
80105ca6:	61                   	popa   
  popl %gs
80105ca7:	0f a9                	pop    %gs
  popl %fs
80105ca9:	0f a1                	pop    %fs
  popl %es
80105cab:	07                   	pop    %es
  popl %ds
80105cac:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105cad:	83 c4 08             	add    $0x8,%esp
  iret
80105cb0:	cf                   	iret   

80105cb1 <sigret_caller_start>:


.globl sigret_caller_start
.globl sigret_caller_end
sigret_caller_start:
  movl $SYS_sigret, %eax
80105cb1:	b8 18 00 00 00       	mov    $0x18,%eax
  int $T_SYSCALL
80105cb6:	cd 40                	int    $0x40

80105cb8 <sigret_caller_end>:
80105cb8:	66 90                	xchg   %ax,%ax
80105cba:	66 90                	xchg   %ax,%ax
80105cbc:	66 90                	xchg   %ax,%ax
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105cc0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105cc1:	31 c0                	xor    %eax,%eax
{
80105cc3:	89 e5                	mov    %esp,%ebp
80105cc5:	83 ec 08             	sub    $0x8,%esp
80105cc8:	90                   	nop
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105cd0:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105cd7:	c7 04 c5 a2 70 11 80 	movl   $0x8e000008,-0x7fee8f5e(,%eax,8)
80105cde:	08 00 00 8e 
80105ce2:	66 89 14 c5 a0 70 11 	mov    %dx,-0x7fee8f60(,%eax,8)
80105ce9:	80 
80105cea:	c1 ea 10             	shr    $0x10,%edx
80105ced:	66 89 14 c5 a6 70 11 	mov    %dx,-0x7fee8f5a(,%eax,8)
80105cf4:	80 
  for(i = 0; i < 256; i++)
80105cf5:	83 c0 01             	add    $0x1,%eax
80105cf8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105cfd:	75 d1                	jne    80105cd0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cff:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105d04:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d07:	c7 05 a2 72 11 80 08 	movl   $0xef000008,0x801172a2
80105d0e:	00 00 ef 
  initlock(&tickslock, "time");
80105d11:	68 85 7d 10 80       	push   $0x80107d85
80105d16:	68 60 70 11 80       	push   $0x80117060
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d1b:	66 a3 a0 72 11 80    	mov    %ax,0x801172a0
80105d21:	c1 e8 10             	shr    $0x10,%eax
80105d24:	66 a3 a6 72 11 80    	mov    %ax,0x801172a6
  initlock(&tickslock, "time");
80105d2a:	e8 61 ea ff ff       	call   80104790 <initlock>
}
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	c9                   	leave  
80105d33:	c3                   	ret    
80105d34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105d40 <idtinit>:

void
idtinit(void)
{
80105d40:	55                   	push   %ebp
  pd[0] = size-1;
80105d41:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d46:	89 e5                	mov    %esp,%ebp
80105d48:	83 ec 10             	sub    $0x10,%esp
80105d4b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d4f:	b8 a0 70 11 80       	mov    $0x801170a0,%eax
80105d54:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d58:	c1 e8 10             	shr    $0x10,%eax
80105d5b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d5f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d62:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d65:	c9                   	leave  
80105d66:	c3                   	ret    
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	57                   	push   %edi
80105d74:	56                   	push   %esi
80105d75:	53                   	push   %ebx
80105d76:	83 ec 1c             	sub    $0x1c,%esp
80105d79:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d7c:	8b 47 30             	mov    0x30(%edi),%eax
80105d7f:	83 f8 40             	cmp    $0x40,%eax
80105d82:	0f 84 f0 00 00 00    	je     80105e78 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d88:	83 e8 20             	sub    $0x20,%eax
80105d8b:	83 f8 1f             	cmp    $0x1f,%eax
80105d8e:	77 10                	ja     80105da0 <trap+0x30>
80105d90:	ff 24 85 2c 7e 10 80 	jmp    *-0x7fef81d4(,%eax,4)
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105da0:	e8 fb da ff ff       	call   801038a0 <myproc>
80105da5:	85 c0                	test   %eax,%eax
80105da7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105daa:	0f 84 14 02 00 00    	je     80105fc4 <trap+0x254>
80105db0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105db4:	0f 84 0a 02 00 00    	je     80105fc4 <trap+0x254>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105dba:	0f 20 d1             	mov    %cr2,%ecx
80105dbd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dc0:	e8 bb da ff ff       	call   80103880 <cpuid>
80105dc5:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105dc8:	8b 47 34             	mov    0x34(%edi),%eax
80105dcb:	8b 77 30             	mov    0x30(%edi),%esi
80105dce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105dd1:	e8 ca da ff ff       	call   801038a0 <myproc>
80105dd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105dd9:	e8 c2 da ff ff       	call   801038a0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dde:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105de4:	51                   	push   %ecx
80105de5:	53                   	push   %ebx
80105de6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105de7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105dea:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ded:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105dee:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105df1:	52                   	push   %edx
80105df2:	ff 70 10             	pushl  0x10(%eax)
80105df5:	68 e8 7d 10 80       	push   $0x80107de8
80105dfa:	e8 61 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105dff:	83 c4 20             	add    $0x20,%esp
80105e02:	e8 99 da ff ff       	call   801038a0 <myproc>
80105e07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e0e:	e8 8d da ff ff       	call   801038a0 <myproc>
80105e13:	85 c0                	test   %eax,%eax
80105e15:	74 1d                	je     80105e34 <trap+0xc4>
80105e17:	e8 84 da ff ff       	call   801038a0 <myproc>
80105e1c:	8b 50 24             	mov    0x24(%eax),%edx
80105e1f:	85 d2                	test   %edx,%edx
80105e21:	74 11                	je     80105e34 <trap+0xc4>
80105e23:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e27:	83 e0 03             	and    $0x3,%eax
80105e2a:	66 83 f8 03          	cmp    $0x3,%ax
80105e2e:	0f 84 4c 01 00 00    	je     80105f80 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e34:	e8 67 da ff ff       	call   801038a0 <myproc>
80105e39:	85 c0                	test   %eax,%eax
80105e3b:	74 0b                	je     80105e48 <trap+0xd8>
80105e3d:	e8 5e da ff ff       	call   801038a0 <myproc>
80105e42:	83 78 0c 07          	cmpl   $0x7,0xc(%eax)
80105e46:	74 68                	je     80105eb0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e48:	e8 53 da ff ff       	call   801038a0 <myproc>
80105e4d:	85 c0                	test   %eax,%eax
80105e4f:	74 19                	je     80105e6a <trap+0xfa>
80105e51:	e8 4a da ff ff       	call   801038a0 <myproc>
80105e56:	8b 40 24             	mov    0x24(%eax),%eax
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	74 0d                	je     80105e6a <trap+0xfa>
80105e5d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e61:	83 e0 03             	and    $0x3,%eax
80105e64:	66 83 f8 03          	cmp    $0x3,%ax
80105e68:	74 37                	je     80105ea1 <trap+0x131>
    exit();
}
80105e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e6d:	5b                   	pop    %ebx
80105e6e:	5e                   	pop    %esi
80105e6f:	5f                   	pop    %edi
80105e70:	5d                   	pop    %ebp
80105e71:	c3                   	ret    
80105e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105e78:	e8 23 da ff ff       	call   801038a0 <myproc>
80105e7d:	8b 58 24             	mov    0x24(%eax),%ebx
80105e80:	85 db                	test   %ebx,%ebx
80105e82:	0f 85 e8 00 00 00    	jne    80105f70 <trap+0x200>
    myproc()->tf = tf;
80105e88:	e8 13 da ff ff       	call   801038a0 <myproc>
80105e8d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105e90:	e8 3b ef ff ff       	call   80104dd0 <syscall>
    if(myproc()->killed)
80105e95:	e8 06 da ff ff       	call   801038a0 <myproc>
80105e9a:	8b 48 24             	mov    0x24(%eax),%ecx
80105e9d:	85 c9                	test   %ecx,%ecx
80105e9f:	74 c9                	je     80105e6a <trap+0xfa>
}
80105ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ea4:	5b                   	pop    %ebx
80105ea5:	5e                   	pop    %esi
80105ea6:	5f                   	pop    %edi
80105ea7:	5d                   	pop    %ebp
      exit();
80105ea8:	e9 73 df ff ff       	jmp    80103e20 <exit>
80105ead:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105eb0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105eb4:	75 92                	jne    80105e48 <trap+0xd8>
    yield();
80105eb6:	e8 95 e0 ff ff       	call   80103f50 <yield>
80105ebb:	eb 8b                	jmp    80105e48 <trap+0xd8>
80105ebd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105ec0:	e8 bb d9 ff ff       	call   80103880 <cpuid>
80105ec5:	85 c0                	test   %eax,%eax
80105ec7:	0f 84 c3 00 00 00    	je     80105f90 <trap+0x220>
    lapiceoi();
80105ecd:	e8 de c8 ff ff       	call   801027b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ed2:	e8 c9 d9 ff ff       	call   801038a0 <myproc>
80105ed7:	85 c0                	test   %eax,%eax
80105ed9:	0f 85 38 ff ff ff    	jne    80105e17 <trap+0xa7>
80105edf:	e9 50 ff ff ff       	jmp    80105e34 <trap+0xc4>
80105ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105ee8:	e8 83 c7 ff ff       	call   80102670 <kbdintr>
    lapiceoi();
80105eed:	e8 be c8 ff ff       	call   801027b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ef2:	e8 a9 d9 ff ff       	call   801038a0 <myproc>
80105ef7:	85 c0                	test   %eax,%eax
80105ef9:	0f 85 18 ff ff ff    	jne    80105e17 <trap+0xa7>
80105eff:	e9 30 ff ff ff       	jmp    80105e34 <trap+0xc4>
80105f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105f08:	e8 53 02 00 00       	call   80106160 <uartintr>
    lapiceoi();
80105f0d:	e8 9e c8 ff ff       	call   801027b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f12:	e8 89 d9 ff ff       	call   801038a0 <myproc>
80105f17:	85 c0                	test   %eax,%eax
80105f19:	0f 85 f8 fe ff ff    	jne    80105e17 <trap+0xa7>
80105f1f:	e9 10 ff ff ff       	jmp    80105e34 <trap+0xc4>
80105f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f28:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105f2c:	8b 77 38             	mov    0x38(%edi),%esi
80105f2f:	e8 4c d9 ff ff       	call   80103880 <cpuid>
80105f34:	56                   	push   %esi
80105f35:	53                   	push   %ebx
80105f36:	50                   	push   %eax
80105f37:	68 90 7d 10 80       	push   $0x80107d90
80105f3c:	e8 1f a7 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105f41:	e8 6a c8 ff ff       	call   801027b0 <lapiceoi>
    break;
80105f46:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f49:	e8 52 d9 ff ff       	call   801038a0 <myproc>
80105f4e:	85 c0                	test   %eax,%eax
80105f50:	0f 85 c1 fe ff ff    	jne    80105e17 <trap+0xa7>
80105f56:	e9 d9 fe ff ff       	jmp    80105e34 <trap+0xc4>
80105f5b:	90                   	nop
80105f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105f60:	e8 7b c1 ff ff       	call   801020e0 <ideintr>
80105f65:	e9 63 ff ff ff       	jmp    80105ecd <trap+0x15d>
80105f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f70:	e8 ab de ff ff       	call   80103e20 <exit>
80105f75:	e9 0e ff ff ff       	jmp    80105e88 <trap+0x118>
80105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105f80:	e8 9b de ff ff       	call   80103e20 <exit>
80105f85:	e9 aa fe ff ff       	jmp    80105e34 <trap+0xc4>
80105f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f90:	83 ec 0c             	sub    $0xc,%esp
80105f93:	68 60 70 11 80       	push   $0x80117060
80105f98:	e8 33 e9 ff ff       	call   801048d0 <acquire>
      wakeup(&ticks);
80105f9d:	c7 04 24 a0 78 11 80 	movl   $0x801178a0,(%esp)
      ticks++;
80105fa4:	83 05 a0 78 11 80 01 	addl   $0x1,0x801178a0
      wakeup(&ticks);
80105fab:	e8 f0 e1 ff ff       	call   801041a0 <wakeup>
      release(&tickslock);
80105fb0:	c7 04 24 60 70 11 80 	movl   $0x80117060,(%esp)
80105fb7:	e8 d4 e9 ff ff       	call   80104990 <release>
80105fbc:	83 c4 10             	add    $0x10,%esp
80105fbf:	e9 09 ff ff ff       	jmp    80105ecd <trap+0x15d>
80105fc4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105fc7:	e8 b4 d8 ff ff       	call   80103880 <cpuid>
80105fcc:	83 ec 0c             	sub    $0xc,%esp
80105fcf:	56                   	push   %esi
80105fd0:	53                   	push   %ebx
80105fd1:	50                   	push   %eax
80105fd2:	ff 77 30             	pushl  0x30(%edi)
80105fd5:	68 b4 7d 10 80       	push   $0x80107db4
80105fda:	e8 81 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105fdf:	83 c4 14             	add    $0x14,%esp
80105fe2:	68 8a 7d 10 80       	push   $0x80107d8a
80105fe7:	e8 a4 a3 ff ff       	call   80100390 <panic>
80105fec:	66 90                	xchg   %ax,%ax
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ff0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105ff5:	55                   	push   %ebp
80105ff6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ff8:	85 c0                	test   %eax,%eax
80105ffa:	74 1c                	je     80106018 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ffc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106001:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106002:	a8 01                	test   $0x1,%al
80106004:	74 12                	je     80106018 <uartgetc+0x28>
80106006:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010600b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010600c:	0f b6 c0             	movzbl %al,%eax
}
8010600f:	5d                   	pop    %ebp
80106010:	c3                   	ret    
80106011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106018:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010601d:	5d                   	pop    %ebp
8010601e:	c3                   	ret    
8010601f:	90                   	nop

80106020 <uartputc.part.0>:
uartputc(int c)
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	57                   	push   %edi
80106024:	56                   	push   %esi
80106025:	53                   	push   %ebx
80106026:	89 c7                	mov    %eax,%edi
80106028:	bb 80 00 00 00       	mov    $0x80,%ebx
8010602d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106032:	83 ec 0c             	sub    $0xc,%esp
80106035:	eb 1b                	jmp    80106052 <uartputc.part.0+0x32>
80106037:	89 f6                	mov    %esi,%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106040:	83 ec 0c             	sub    $0xc,%esp
80106043:	6a 0a                	push   $0xa
80106045:	e8 86 c7 ff ff       	call   801027d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010604a:	83 c4 10             	add    $0x10,%esp
8010604d:	83 eb 01             	sub    $0x1,%ebx
80106050:	74 07                	je     80106059 <uartputc.part.0+0x39>
80106052:	89 f2                	mov    %esi,%edx
80106054:	ec                   	in     (%dx),%al
80106055:	a8 20                	test   $0x20,%al
80106057:	74 e7                	je     80106040 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106059:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010605e:	89 f8                	mov    %edi,%eax
80106060:	ee                   	out    %al,(%dx)
}
80106061:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106064:	5b                   	pop    %ebx
80106065:	5e                   	pop    %esi
80106066:	5f                   	pop    %edi
80106067:	5d                   	pop    %ebp
80106068:	c3                   	ret    
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106070 <uartinit>:
{
80106070:	55                   	push   %ebp
80106071:	31 c9                	xor    %ecx,%ecx
80106073:	89 c8                	mov    %ecx,%eax
80106075:	89 e5                	mov    %esp,%ebp
80106077:	57                   	push   %edi
80106078:	56                   	push   %esi
80106079:	53                   	push   %ebx
8010607a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010607f:	89 da                	mov    %ebx,%edx
80106081:	83 ec 0c             	sub    $0xc,%esp
80106084:	ee                   	out    %al,(%dx)
80106085:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010608a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010608f:	89 fa                	mov    %edi,%edx
80106091:	ee                   	out    %al,(%dx)
80106092:	b8 0c 00 00 00       	mov    $0xc,%eax
80106097:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010609c:	ee                   	out    %al,(%dx)
8010609d:	be f9 03 00 00       	mov    $0x3f9,%esi
801060a2:	89 c8                	mov    %ecx,%eax
801060a4:	89 f2                	mov    %esi,%edx
801060a6:	ee                   	out    %al,(%dx)
801060a7:	b8 03 00 00 00       	mov    $0x3,%eax
801060ac:	89 fa                	mov    %edi,%edx
801060ae:	ee                   	out    %al,(%dx)
801060af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801060b4:	89 c8                	mov    %ecx,%eax
801060b6:	ee                   	out    %al,(%dx)
801060b7:	b8 01 00 00 00       	mov    $0x1,%eax
801060bc:	89 f2                	mov    %esi,%edx
801060be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801060bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801060c5:	3c ff                	cmp    $0xff,%al
801060c7:	74 5a                	je     80106123 <uartinit+0xb3>
  uart = 1;
801060c9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801060d0:	00 00 00 
801060d3:	89 da                	mov    %ebx,%edx
801060d5:	ec                   	in     (%dx),%al
801060d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060db:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801060dc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801060df:	bb ac 7e 10 80       	mov    $0x80107eac,%ebx
  ioapicenable(IRQ_COM1, 0);
801060e4:	6a 00                	push   $0x0
801060e6:	6a 04                	push   $0x4
801060e8:	e8 43 c2 ff ff       	call   80102330 <ioapicenable>
801060ed:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801060f0:	b8 78 00 00 00       	mov    $0x78,%eax
801060f5:	eb 13                	jmp    8010610a <uartinit+0x9a>
801060f7:	89 f6                	mov    %esi,%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106100:	83 c3 01             	add    $0x1,%ebx
80106103:	0f be 03             	movsbl (%ebx),%eax
80106106:	84 c0                	test   %al,%al
80106108:	74 19                	je     80106123 <uartinit+0xb3>
  if(!uart)
8010610a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80106110:	85 d2                	test   %edx,%edx
80106112:	74 ec                	je     80106100 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106114:	83 c3 01             	add    $0x1,%ebx
80106117:	e8 04 ff ff ff       	call   80106020 <uartputc.part.0>
8010611c:	0f be 03             	movsbl (%ebx),%eax
8010611f:	84 c0                	test   %al,%al
80106121:	75 e7                	jne    8010610a <uartinit+0x9a>
}
80106123:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106126:	5b                   	pop    %ebx
80106127:	5e                   	pop    %esi
80106128:	5f                   	pop    %edi
80106129:	5d                   	pop    %ebp
8010612a:	c3                   	ret    
8010612b:	90                   	nop
8010612c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106130 <uartputc>:
  if(!uart)
80106130:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80106136:	55                   	push   %ebp
80106137:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106139:	85 d2                	test   %edx,%edx
{
8010613b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010613e:	74 10                	je     80106150 <uartputc+0x20>
}
80106140:	5d                   	pop    %ebp
80106141:	e9 da fe ff ff       	jmp    80106020 <uartputc.part.0>
80106146:	8d 76 00             	lea    0x0(%esi),%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106150:	5d                   	pop    %ebp
80106151:	c3                   	ret    
80106152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106160 <uartintr>:

void
uartintr(void)
{
80106160:	55                   	push   %ebp
80106161:	89 e5                	mov    %esp,%ebp
80106163:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106166:	68 f0 5f 10 80       	push   $0x80105ff0
8010616b:	e8 a0 a6 ff ff       	call   80100810 <consoleintr>
}
80106170:	83 c4 10             	add    $0x10,%esp
80106173:	c9                   	leave  
80106174:	c3                   	ret    

80106175 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $0
80106177:	6a 00                	push   $0x0
  jmp alltraps
80106179:	e9 0b fb ff ff       	jmp    80105c89 <alltraps>

8010617e <vector1>:
.globl vector1
vector1:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $1
80106180:	6a 01                	push   $0x1
  jmp alltraps
80106182:	e9 02 fb ff ff       	jmp    80105c89 <alltraps>

80106187 <vector2>:
.globl vector2
vector2:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $2
80106189:	6a 02                	push   $0x2
  jmp alltraps
8010618b:	e9 f9 fa ff ff       	jmp    80105c89 <alltraps>

80106190 <vector3>:
.globl vector3
vector3:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $3
80106192:	6a 03                	push   $0x3
  jmp alltraps
80106194:	e9 f0 fa ff ff       	jmp    80105c89 <alltraps>

80106199 <vector4>:
.globl vector4
vector4:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $4
8010619b:	6a 04                	push   $0x4
  jmp alltraps
8010619d:	e9 e7 fa ff ff       	jmp    80105c89 <alltraps>

801061a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $5
801061a4:	6a 05                	push   $0x5
  jmp alltraps
801061a6:	e9 de fa ff ff       	jmp    80105c89 <alltraps>

801061ab <vector6>:
.globl vector6
vector6:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $6
801061ad:	6a 06                	push   $0x6
  jmp alltraps
801061af:	e9 d5 fa ff ff       	jmp    80105c89 <alltraps>

801061b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $7
801061b6:	6a 07                	push   $0x7
  jmp alltraps
801061b8:	e9 cc fa ff ff       	jmp    80105c89 <alltraps>

801061bd <vector8>:
.globl vector8
vector8:
  pushl $8
801061bd:	6a 08                	push   $0x8
  jmp alltraps
801061bf:	e9 c5 fa ff ff       	jmp    80105c89 <alltraps>

801061c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $9
801061c6:	6a 09                	push   $0x9
  jmp alltraps
801061c8:	e9 bc fa ff ff       	jmp    80105c89 <alltraps>

801061cd <vector10>:
.globl vector10
vector10:
  pushl $10
801061cd:	6a 0a                	push   $0xa
  jmp alltraps
801061cf:	e9 b5 fa ff ff       	jmp    80105c89 <alltraps>

801061d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801061d4:	6a 0b                	push   $0xb
  jmp alltraps
801061d6:	e9 ae fa ff ff       	jmp    80105c89 <alltraps>

801061db <vector12>:
.globl vector12
vector12:
  pushl $12
801061db:	6a 0c                	push   $0xc
  jmp alltraps
801061dd:	e9 a7 fa ff ff       	jmp    80105c89 <alltraps>

801061e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801061e2:	6a 0d                	push   $0xd
  jmp alltraps
801061e4:	e9 a0 fa ff ff       	jmp    80105c89 <alltraps>

801061e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801061e9:	6a 0e                	push   $0xe
  jmp alltraps
801061eb:	e9 99 fa ff ff       	jmp    80105c89 <alltraps>

801061f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $15
801061f2:	6a 0f                	push   $0xf
  jmp alltraps
801061f4:	e9 90 fa ff ff       	jmp    80105c89 <alltraps>

801061f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $16
801061fb:	6a 10                	push   $0x10
  jmp alltraps
801061fd:	e9 87 fa ff ff       	jmp    80105c89 <alltraps>

80106202 <vector17>:
.globl vector17
vector17:
  pushl $17
80106202:	6a 11                	push   $0x11
  jmp alltraps
80106204:	e9 80 fa ff ff       	jmp    80105c89 <alltraps>

80106209 <vector18>:
.globl vector18
vector18:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $18
8010620b:	6a 12                	push   $0x12
  jmp alltraps
8010620d:	e9 77 fa ff ff       	jmp    80105c89 <alltraps>

80106212 <vector19>:
.globl vector19
vector19:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $19
80106214:	6a 13                	push   $0x13
  jmp alltraps
80106216:	e9 6e fa ff ff       	jmp    80105c89 <alltraps>

8010621b <vector20>:
.globl vector20
vector20:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $20
8010621d:	6a 14                	push   $0x14
  jmp alltraps
8010621f:	e9 65 fa ff ff       	jmp    80105c89 <alltraps>

80106224 <vector21>:
.globl vector21
vector21:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $21
80106226:	6a 15                	push   $0x15
  jmp alltraps
80106228:	e9 5c fa ff ff       	jmp    80105c89 <alltraps>

8010622d <vector22>:
.globl vector22
vector22:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $22
8010622f:	6a 16                	push   $0x16
  jmp alltraps
80106231:	e9 53 fa ff ff       	jmp    80105c89 <alltraps>

80106236 <vector23>:
.globl vector23
vector23:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $23
80106238:	6a 17                	push   $0x17
  jmp alltraps
8010623a:	e9 4a fa ff ff       	jmp    80105c89 <alltraps>

8010623f <vector24>:
.globl vector24
vector24:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $24
80106241:	6a 18                	push   $0x18
  jmp alltraps
80106243:	e9 41 fa ff ff       	jmp    80105c89 <alltraps>

80106248 <vector25>:
.globl vector25
vector25:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $25
8010624a:	6a 19                	push   $0x19
  jmp alltraps
8010624c:	e9 38 fa ff ff       	jmp    80105c89 <alltraps>

80106251 <vector26>:
.globl vector26
vector26:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $26
80106253:	6a 1a                	push   $0x1a
  jmp alltraps
80106255:	e9 2f fa ff ff       	jmp    80105c89 <alltraps>

8010625a <vector27>:
.globl vector27
vector27:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $27
8010625c:	6a 1b                	push   $0x1b
  jmp alltraps
8010625e:	e9 26 fa ff ff       	jmp    80105c89 <alltraps>

80106263 <vector28>:
.globl vector28
vector28:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $28
80106265:	6a 1c                	push   $0x1c
  jmp alltraps
80106267:	e9 1d fa ff ff       	jmp    80105c89 <alltraps>

8010626c <vector29>:
.globl vector29
vector29:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $29
8010626e:	6a 1d                	push   $0x1d
  jmp alltraps
80106270:	e9 14 fa ff ff       	jmp    80105c89 <alltraps>

80106275 <vector30>:
.globl vector30
vector30:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $30
80106277:	6a 1e                	push   $0x1e
  jmp alltraps
80106279:	e9 0b fa ff ff       	jmp    80105c89 <alltraps>

8010627e <vector31>:
.globl vector31
vector31:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $31
80106280:	6a 1f                	push   $0x1f
  jmp alltraps
80106282:	e9 02 fa ff ff       	jmp    80105c89 <alltraps>

80106287 <vector32>:
.globl vector32
vector32:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $32
80106289:	6a 20                	push   $0x20
  jmp alltraps
8010628b:	e9 f9 f9 ff ff       	jmp    80105c89 <alltraps>

80106290 <vector33>:
.globl vector33
vector33:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $33
80106292:	6a 21                	push   $0x21
  jmp alltraps
80106294:	e9 f0 f9 ff ff       	jmp    80105c89 <alltraps>

80106299 <vector34>:
.globl vector34
vector34:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $34
8010629b:	6a 22                	push   $0x22
  jmp alltraps
8010629d:	e9 e7 f9 ff ff       	jmp    80105c89 <alltraps>

801062a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $35
801062a4:	6a 23                	push   $0x23
  jmp alltraps
801062a6:	e9 de f9 ff ff       	jmp    80105c89 <alltraps>

801062ab <vector36>:
.globl vector36
vector36:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $36
801062ad:	6a 24                	push   $0x24
  jmp alltraps
801062af:	e9 d5 f9 ff ff       	jmp    80105c89 <alltraps>

801062b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $37
801062b6:	6a 25                	push   $0x25
  jmp alltraps
801062b8:	e9 cc f9 ff ff       	jmp    80105c89 <alltraps>

801062bd <vector38>:
.globl vector38
vector38:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $38
801062bf:	6a 26                	push   $0x26
  jmp alltraps
801062c1:	e9 c3 f9 ff ff       	jmp    80105c89 <alltraps>

801062c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $39
801062c8:	6a 27                	push   $0x27
  jmp alltraps
801062ca:	e9 ba f9 ff ff       	jmp    80105c89 <alltraps>

801062cf <vector40>:
.globl vector40
vector40:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $40
801062d1:	6a 28                	push   $0x28
  jmp alltraps
801062d3:	e9 b1 f9 ff ff       	jmp    80105c89 <alltraps>

801062d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $41
801062da:	6a 29                	push   $0x29
  jmp alltraps
801062dc:	e9 a8 f9 ff ff       	jmp    80105c89 <alltraps>

801062e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $42
801062e3:	6a 2a                	push   $0x2a
  jmp alltraps
801062e5:	e9 9f f9 ff ff       	jmp    80105c89 <alltraps>

801062ea <vector43>:
.globl vector43
vector43:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $43
801062ec:	6a 2b                	push   $0x2b
  jmp alltraps
801062ee:	e9 96 f9 ff ff       	jmp    80105c89 <alltraps>

801062f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $44
801062f5:	6a 2c                	push   $0x2c
  jmp alltraps
801062f7:	e9 8d f9 ff ff       	jmp    80105c89 <alltraps>

801062fc <vector45>:
.globl vector45
vector45:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $45
801062fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106300:	e9 84 f9 ff ff       	jmp    80105c89 <alltraps>

80106305 <vector46>:
.globl vector46
vector46:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $46
80106307:	6a 2e                	push   $0x2e
  jmp alltraps
80106309:	e9 7b f9 ff ff       	jmp    80105c89 <alltraps>

8010630e <vector47>:
.globl vector47
vector47:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $47
80106310:	6a 2f                	push   $0x2f
  jmp alltraps
80106312:	e9 72 f9 ff ff       	jmp    80105c89 <alltraps>

80106317 <vector48>:
.globl vector48
vector48:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $48
80106319:	6a 30                	push   $0x30
  jmp alltraps
8010631b:	e9 69 f9 ff ff       	jmp    80105c89 <alltraps>

80106320 <vector49>:
.globl vector49
vector49:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $49
80106322:	6a 31                	push   $0x31
  jmp alltraps
80106324:	e9 60 f9 ff ff       	jmp    80105c89 <alltraps>

80106329 <vector50>:
.globl vector50
vector50:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $50
8010632b:	6a 32                	push   $0x32
  jmp alltraps
8010632d:	e9 57 f9 ff ff       	jmp    80105c89 <alltraps>

80106332 <vector51>:
.globl vector51
vector51:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $51
80106334:	6a 33                	push   $0x33
  jmp alltraps
80106336:	e9 4e f9 ff ff       	jmp    80105c89 <alltraps>

8010633b <vector52>:
.globl vector52
vector52:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $52
8010633d:	6a 34                	push   $0x34
  jmp alltraps
8010633f:	e9 45 f9 ff ff       	jmp    80105c89 <alltraps>

80106344 <vector53>:
.globl vector53
vector53:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $53
80106346:	6a 35                	push   $0x35
  jmp alltraps
80106348:	e9 3c f9 ff ff       	jmp    80105c89 <alltraps>

8010634d <vector54>:
.globl vector54
vector54:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $54
8010634f:	6a 36                	push   $0x36
  jmp alltraps
80106351:	e9 33 f9 ff ff       	jmp    80105c89 <alltraps>

80106356 <vector55>:
.globl vector55
vector55:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $55
80106358:	6a 37                	push   $0x37
  jmp alltraps
8010635a:	e9 2a f9 ff ff       	jmp    80105c89 <alltraps>

8010635f <vector56>:
.globl vector56
vector56:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $56
80106361:	6a 38                	push   $0x38
  jmp alltraps
80106363:	e9 21 f9 ff ff       	jmp    80105c89 <alltraps>

80106368 <vector57>:
.globl vector57
vector57:
  pushl $0
80106368:	6a 00                	push   $0x0
  pushl $57
8010636a:	6a 39                	push   $0x39
  jmp alltraps
8010636c:	e9 18 f9 ff ff       	jmp    80105c89 <alltraps>

80106371 <vector58>:
.globl vector58
vector58:
  pushl $0
80106371:	6a 00                	push   $0x0
  pushl $58
80106373:	6a 3a                	push   $0x3a
  jmp alltraps
80106375:	e9 0f f9 ff ff       	jmp    80105c89 <alltraps>

8010637a <vector59>:
.globl vector59
vector59:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $59
8010637c:	6a 3b                	push   $0x3b
  jmp alltraps
8010637e:	e9 06 f9 ff ff       	jmp    80105c89 <alltraps>

80106383 <vector60>:
.globl vector60
vector60:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $60
80106385:	6a 3c                	push   $0x3c
  jmp alltraps
80106387:	e9 fd f8 ff ff       	jmp    80105c89 <alltraps>

8010638c <vector61>:
.globl vector61
vector61:
  pushl $0
8010638c:	6a 00                	push   $0x0
  pushl $61
8010638e:	6a 3d                	push   $0x3d
  jmp alltraps
80106390:	e9 f4 f8 ff ff       	jmp    80105c89 <alltraps>

80106395 <vector62>:
.globl vector62
vector62:
  pushl $0
80106395:	6a 00                	push   $0x0
  pushl $62
80106397:	6a 3e                	push   $0x3e
  jmp alltraps
80106399:	e9 eb f8 ff ff       	jmp    80105c89 <alltraps>

8010639e <vector63>:
.globl vector63
vector63:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $63
801063a0:	6a 3f                	push   $0x3f
  jmp alltraps
801063a2:	e9 e2 f8 ff ff       	jmp    80105c89 <alltraps>

801063a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $64
801063a9:	6a 40                	push   $0x40
  jmp alltraps
801063ab:	e9 d9 f8 ff ff       	jmp    80105c89 <alltraps>

801063b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801063b0:	6a 00                	push   $0x0
  pushl $65
801063b2:	6a 41                	push   $0x41
  jmp alltraps
801063b4:	e9 d0 f8 ff ff       	jmp    80105c89 <alltraps>

801063b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801063b9:	6a 00                	push   $0x0
  pushl $66
801063bb:	6a 42                	push   $0x42
  jmp alltraps
801063bd:	e9 c7 f8 ff ff       	jmp    80105c89 <alltraps>

801063c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $67
801063c4:	6a 43                	push   $0x43
  jmp alltraps
801063c6:	e9 be f8 ff ff       	jmp    80105c89 <alltraps>

801063cb <vector68>:
.globl vector68
vector68:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $68
801063cd:	6a 44                	push   $0x44
  jmp alltraps
801063cf:	e9 b5 f8 ff ff       	jmp    80105c89 <alltraps>

801063d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801063d4:	6a 00                	push   $0x0
  pushl $69
801063d6:	6a 45                	push   $0x45
  jmp alltraps
801063d8:	e9 ac f8 ff ff       	jmp    80105c89 <alltraps>

801063dd <vector70>:
.globl vector70
vector70:
  pushl $0
801063dd:	6a 00                	push   $0x0
  pushl $70
801063df:	6a 46                	push   $0x46
  jmp alltraps
801063e1:	e9 a3 f8 ff ff       	jmp    80105c89 <alltraps>

801063e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $71
801063e8:	6a 47                	push   $0x47
  jmp alltraps
801063ea:	e9 9a f8 ff ff       	jmp    80105c89 <alltraps>

801063ef <vector72>:
.globl vector72
vector72:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $72
801063f1:	6a 48                	push   $0x48
  jmp alltraps
801063f3:	e9 91 f8 ff ff       	jmp    80105c89 <alltraps>

801063f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801063f8:	6a 00                	push   $0x0
  pushl $73
801063fa:	6a 49                	push   $0x49
  jmp alltraps
801063fc:	e9 88 f8 ff ff       	jmp    80105c89 <alltraps>

80106401 <vector74>:
.globl vector74
vector74:
  pushl $0
80106401:	6a 00                	push   $0x0
  pushl $74
80106403:	6a 4a                	push   $0x4a
  jmp alltraps
80106405:	e9 7f f8 ff ff       	jmp    80105c89 <alltraps>

8010640a <vector75>:
.globl vector75
vector75:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $75
8010640c:	6a 4b                	push   $0x4b
  jmp alltraps
8010640e:	e9 76 f8 ff ff       	jmp    80105c89 <alltraps>

80106413 <vector76>:
.globl vector76
vector76:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $76
80106415:	6a 4c                	push   $0x4c
  jmp alltraps
80106417:	e9 6d f8 ff ff       	jmp    80105c89 <alltraps>

8010641c <vector77>:
.globl vector77
vector77:
  pushl $0
8010641c:	6a 00                	push   $0x0
  pushl $77
8010641e:	6a 4d                	push   $0x4d
  jmp alltraps
80106420:	e9 64 f8 ff ff       	jmp    80105c89 <alltraps>

80106425 <vector78>:
.globl vector78
vector78:
  pushl $0
80106425:	6a 00                	push   $0x0
  pushl $78
80106427:	6a 4e                	push   $0x4e
  jmp alltraps
80106429:	e9 5b f8 ff ff       	jmp    80105c89 <alltraps>

8010642e <vector79>:
.globl vector79
vector79:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $79
80106430:	6a 4f                	push   $0x4f
  jmp alltraps
80106432:	e9 52 f8 ff ff       	jmp    80105c89 <alltraps>

80106437 <vector80>:
.globl vector80
vector80:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $80
80106439:	6a 50                	push   $0x50
  jmp alltraps
8010643b:	e9 49 f8 ff ff       	jmp    80105c89 <alltraps>

80106440 <vector81>:
.globl vector81
vector81:
  pushl $0
80106440:	6a 00                	push   $0x0
  pushl $81
80106442:	6a 51                	push   $0x51
  jmp alltraps
80106444:	e9 40 f8 ff ff       	jmp    80105c89 <alltraps>

80106449 <vector82>:
.globl vector82
vector82:
  pushl $0
80106449:	6a 00                	push   $0x0
  pushl $82
8010644b:	6a 52                	push   $0x52
  jmp alltraps
8010644d:	e9 37 f8 ff ff       	jmp    80105c89 <alltraps>

80106452 <vector83>:
.globl vector83
vector83:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $83
80106454:	6a 53                	push   $0x53
  jmp alltraps
80106456:	e9 2e f8 ff ff       	jmp    80105c89 <alltraps>

8010645b <vector84>:
.globl vector84
vector84:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $84
8010645d:	6a 54                	push   $0x54
  jmp alltraps
8010645f:	e9 25 f8 ff ff       	jmp    80105c89 <alltraps>

80106464 <vector85>:
.globl vector85
vector85:
  pushl $0
80106464:	6a 00                	push   $0x0
  pushl $85
80106466:	6a 55                	push   $0x55
  jmp alltraps
80106468:	e9 1c f8 ff ff       	jmp    80105c89 <alltraps>

8010646d <vector86>:
.globl vector86
vector86:
  pushl $0
8010646d:	6a 00                	push   $0x0
  pushl $86
8010646f:	6a 56                	push   $0x56
  jmp alltraps
80106471:	e9 13 f8 ff ff       	jmp    80105c89 <alltraps>

80106476 <vector87>:
.globl vector87
vector87:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $87
80106478:	6a 57                	push   $0x57
  jmp alltraps
8010647a:	e9 0a f8 ff ff       	jmp    80105c89 <alltraps>

8010647f <vector88>:
.globl vector88
vector88:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $88
80106481:	6a 58                	push   $0x58
  jmp alltraps
80106483:	e9 01 f8 ff ff       	jmp    80105c89 <alltraps>

80106488 <vector89>:
.globl vector89
vector89:
  pushl $0
80106488:	6a 00                	push   $0x0
  pushl $89
8010648a:	6a 59                	push   $0x59
  jmp alltraps
8010648c:	e9 f8 f7 ff ff       	jmp    80105c89 <alltraps>

80106491 <vector90>:
.globl vector90
vector90:
  pushl $0
80106491:	6a 00                	push   $0x0
  pushl $90
80106493:	6a 5a                	push   $0x5a
  jmp alltraps
80106495:	e9 ef f7 ff ff       	jmp    80105c89 <alltraps>

8010649a <vector91>:
.globl vector91
vector91:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $91
8010649c:	6a 5b                	push   $0x5b
  jmp alltraps
8010649e:	e9 e6 f7 ff ff       	jmp    80105c89 <alltraps>

801064a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $92
801064a5:	6a 5c                	push   $0x5c
  jmp alltraps
801064a7:	e9 dd f7 ff ff       	jmp    80105c89 <alltraps>

801064ac <vector93>:
.globl vector93
vector93:
  pushl $0
801064ac:	6a 00                	push   $0x0
  pushl $93
801064ae:	6a 5d                	push   $0x5d
  jmp alltraps
801064b0:	e9 d4 f7 ff ff       	jmp    80105c89 <alltraps>

801064b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801064b5:	6a 00                	push   $0x0
  pushl $94
801064b7:	6a 5e                	push   $0x5e
  jmp alltraps
801064b9:	e9 cb f7 ff ff       	jmp    80105c89 <alltraps>

801064be <vector95>:
.globl vector95
vector95:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $95
801064c0:	6a 5f                	push   $0x5f
  jmp alltraps
801064c2:	e9 c2 f7 ff ff       	jmp    80105c89 <alltraps>

801064c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $96
801064c9:	6a 60                	push   $0x60
  jmp alltraps
801064cb:	e9 b9 f7 ff ff       	jmp    80105c89 <alltraps>

801064d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801064d0:	6a 00                	push   $0x0
  pushl $97
801064d2:	6a 61                	push   $0x61
  jmp alltraps
801064d4:	e9 b0 f7 ff ff       	jmp    80105c89 <alltraps>

801064d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801064d9:	6a 00                	push   $0x0
  pushl $98
801064db:	6a 62                	push   $0x62
  jmp alltraps
801064dd:	e9 a7 f7 ff ff       	jmp    80105c89 <alltraps>

801064e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $99
801064e4:	6a 63                	push   $0x63
  jmp alltraps
801064e6:	e9 9e f7 ff ff       	jmp    80105c89 <alltraps>

801064eb <vector100>:
.globl vector100
vector100:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $100
801064ed:	6a 64                	push   $0x64
  jmp alltraps
801064ef:	e9 95 f7 ff ff       	jmp    80105c89 <alltraps>

801064f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801064f4:	6a 00                	push   $0x0
  pushl $101
801064f6:	6a 65                	push   $0x65
  jmp alltraps
801064f8:	e9 8c f7 ff ff       	jmp    80105c89 <alltraps>

801064fd <vector102>:
.globl vector102
vector102:
  pushl $0
801064fd:	6a 00                	push   $0x0
  pushl $102
801064ff:	6a 66                	push   $0x66
  jmp alltraps
80106501:	e9 83 f7 ff ff       	jmp    80105c89 <alltraps>

80106506 <vector103>:
.globl vector103
vector103:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $103
80106508:	6a 67                	push   $0x67
  jmp alltraps
8010650a:	e9 7a f7 ff ff       	jmp    80105c89 <alltraps>

8010650f <vector104>:
.globl vector104
vector104:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $104
80106511:	6a 68                	push   $0x68
  jmp alltraps
80106513:	e9 71 f7 ff ff       	jmp    80105c89 <alltraps>

80106518 <vector105>:
.globl vector105
vector105:
  pushl $0
80106518:	6a 00                	push   $0x0
  pushl $105
8010651a:	6a 69                	push   $0x69
  jmp alltraps
8010651c:	e9 68 f7 ff ff       	jmp    80105c89 <alltraps>

80106521 <vector106>:
.globl vector106
vector106:
  pushl $0
80106521:	6a 00                	push   $0x0
  pushl $106
80106523:	6a 6a                	push   $0x6a
  jmp alltraps
80106525:	e9 5f f7 ff ff       	jmp    80105c89 <alltraps>

8010652a <vector107>:
.globl vector107
vector107:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $107
8010652c:	6a 6b                	push   $0x6b
  jmp alltraps
8010652e:	e9 56 f7 ff ff       	jmp    80105c89 <alltraps>

80106533 <vector108>:
.globl vector108
vector108:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $108
80106535:	6a 6c                	push   $0x6c
  jmp alltraps
80106537:	e9 4d f7 ff ff       	jmp    80105c89 <alltraps>

8010653c <vector109>:
.globl vector109
vector109:
  pushl $0
8010653c:	6a 00                	push   $0x0
  pushl $109
8010653e:	6a 6d                	push   $0x6d
  jmp alltraps
80106540:	e9 44 f7 ff ff       	jmp    80105c89 <alltraps>

80106545 <vector110>:
.globl vector110
vector110:
  pushl $0
80106545:	6a 00                	push   $0x0
  pushl $110
80106547:	6a 6e                	push   $0x6e
  jmp alltraps
80106549:	e9 3b f7 ff ff       	jmp    80105c89 <alltraps>

8010654e <vector111>:
.globl vector111
vector111:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $111
80106550:	6a 6f                	push   $0x6f
  jmp alltraps
80106552:	e9 32 f7 ff ff       	jmp    80105c89 <alltraps>

80106557 <vector112>:
.globl vector112
vector112:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $112
80106559:	6a 70                	push   $0x70
  jmp alltraps
8010655b:	e9 29 f7 ff ff       	jmp    80105c89 <alltraps>

80106560 <vector113>:
.globl vector113
vector113:
  pushl $0
80106560:	6a 00                	push   $0x0
  pushl $113
80106562:	6a 71                	push   $0x71
  jmp alltraps
80106564:	e9 20 f7 ff ff       	jmp    80105c89 <alltraps>

80106569 <vector114>:
.globl vector114
vector114:
  pushl $0
80106569:	6a 00                	push   $0x0
  pushl $114
8010656b:	6a 72                	push   $0x72
  jmp alltraps
8010656d:	e9 17 f7 ff ff       	jmp    80105c89 <alltraps>

80106572 <vector115>:
.globl vector115
vector115:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $115
80106574:	6a 73                	push   $0x73
  jmp alltraps
80106576:	e9 0e f7 ff ff       	jmp    80105c89 <alltraps>

8010657b <vector116>:
.globl vector116
vector116:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $116
8010657d:	6a 74                	push   $0x74
  jmp alltraps
8010657f:	e9 05 f7 ff ff       	jmp    80105c89 <alltraps>

80106584 <vector117>:
.globl vector117
vector117:
  pushl $0
80106584:	6a 00                	push   $0x0
  pushl $117
80106586:	6a 75                	push   $0x75
  jmp alltraps
80106588:	e9 fc f6 ff ff       	jmp    80105c89 <alltraps>

8010658d <vector118>:
.globl vector118
vector118:
  pushl $0
8010658d:	6a 00                	push   $0x0
  pushl $118
8010658f:	6a 76                	push   $0x76
  jmp alltraps
80106591:	e9 f3 f6 ff ff       	jmp    80105c89 <alltraps>

80106596 <vector119>:
.globl vector119
vector119:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $119
80106598:	6a 77                	push   $0x77
  jmp alltraps
8010659a:	e9 ea f6 ff ff       	jmp    80105c89 <alltraps>

8010659f <vector120>:
.globl vector120
vector120:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $120
801065a1:	6a 78                	push   $0x78
  jmp alltraps
801065a3:	e9 e1 f6 ff ff       	jmp    80105c89 <alltraps>

801065a8 <vector121>:
.globl vector121
vector121:
  pushl $0
801065a8:	6a 00                	push   $0x0
  pushl $121
801065aa:	6a 79                	push   $0x79
  jmp alltraps
801065ac:	e9 d8 f6 ff ff       	jmp    80105c89 <alltraps>

801065b1 <vector122>:
.globl vector122
vector122:
  pushl $0
801065b1:	6a 00                	push   $0x0
  pushl $122
801065b3:	6a 7a                	push   $0x7a
  jmp alltraps
801065b5:	e9 cf f6 ff ff       	jmp    80105c89 <alltraps>

801065ba <vector123>:
.globl vector123
vector123:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $123
801065bc:	6a 7b                	push   $0x7b
  jmp alltraps
801065be:	e9 c6 f6 ff ff       	jmp    80105c89 <alltraps>

801065c3 <vector124>:
.globl vector124
vector124:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $124
801065c5:	6a 7c                	push   $0x7c
  jmp alltraps
801065c7:	e9 bd f6 ff ff       	jmp    80105c89 <alltraps>

801065cc <vector125>:
.globl vector125
vector125:
  pushl $0
801065cc:	6a 00                	push   $0x0
  pushl $125
801065ce:	6a 7d                	push   $0x7d
  jmp alltraps
801065d0:	e9 b4 f6 ff ff       	jmp    80105c89 <alltraps>

801065d5 <vector126>:
.globl vector126
vector126:
  pushl $0
801065d5:	6a 00                	push   $0x0
  pushl $126
801065d7:	6a 7e                	push   $0x7e
  jmp alltraps
801065d9:	e9 ab f6 ff ff       	jmp    80105c89 <alltraps>

801065de <vector127>:
.globl vector127
vector127:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $127
801065e0:	6a 7f                	push   $0x7f
  jmp alltraps
801065e2:	e9 a2 f6 ff ff       	jmp    80105c89 <alltraps>

801065e7 <vector128>:
.globl vector128
vector128:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $128
801065e9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801065ee:	e9 96 f6 ff ff       	jmp    80105c89 <alltraps>

801065f3 <vector129>:
.globl vector129
vector129:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $129
801065f5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801065fa:	e9 8a f6 ff ff       	jmp    80105c89 <alltraps>

801065ff <vector130>:
.globl vector130
vector130:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $130
80106601:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106606:	e9 7e f6 ff ff       	jmp    80105c89 <alltraps>

8010660b <vector131>:
.globl vector131
vector131:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $131
8010660d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106612:	e9 72 f6 ff ff       	jmp    80105c89 <alltraps>

80106617 <vector132>:
.globl vector132
vector132:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $132
80106619:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010661e:	e9 66 f6 ff ff       	jmp    80105c89 <alltraps>

80106623 <vector133>:
.globl vector133
vector133:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $133
80106625:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010662a:	e9 5a f6 ff ff       	jmp    80105c89 <alltraps>

8010662f <vector134>:
.globl vector134
vector134:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $134
80106631:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106636:	e9 4e f6 ff ff       	jmp    80105c89 <alltraps>

8010663b <vector135>:
.globl vector135
vector135:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $135
8010663d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106642:	e9 42 f6 ff ff       	jmp    80105c89 <alltraps>

80106647 <vector136>:
.globl vector136
vector136:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $136
80106649:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010664e:	e9 36 f6 ff ff       	jmp    80105c89 <alltraps>

80106653 <vector137>:
.globl vector137
vector137:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $137
80106655:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010665a:	e9 2a f6 ff ff       	jmp    80105c89 <alltraps>

8010665f <vector138>:
.globl vector138
vector138:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $138
80106661:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106666:	e9 1e f6 ff ff       	jmp    80105c89 <alltraps>

8010666b <vector139>:
.globl vector139
vector139:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $139
8010666d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106672:	e9 12 f6 ff ff       	jmp    80105c89 <alltraps>

80106677 <vector140>:
.globl vector140
vector140:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $140
80106679:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010667e:	e9 06 f6 ff ff       	jmp    80105c89 <alltraps>

80106683 <vector141>:
.globl vector141
vector141:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $141
80106685:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010668a:	e9 fa f5 ff ff       	jmp    80105c89 <alltraps>

8010668f <vector142>:
.globl vector142
vector142:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $142
80106691:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106696:	e9 ee f5 ff ff       	jmp    80105c89 <alltraps>

8010669b <vector143>:
.globl vector143
vector143:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $143
8010669d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066a2:	e9 e2 f5 ff ff       	jmp    80105c89 <alltraps>

801066a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $144
801066a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801066ae:	e9 d6 f5 ff ff       	jmp    80105c89 <alltraps>

801066b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $145
801066b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801066ba:	e9 ca f5 ff ff       	jmp    80105c89 <alltraps>

801066bf <vector146>:
.globl vector146
vector146:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $146
801066c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801066c6:	e9 be f5 ff ff       	jmp    80105c89 <alltraps>

801066cb <vector147>:
.globl vector147
vector147:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $147
801066cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801066d2:	e9 b2 f5 ff ff       	jmp    80105c89 <alltraps>

801066d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $148
801066d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801066de:	e9 a6 f5 ff ff       	jmp    80105c89 <alltraps>

801066e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $149
801066e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801066ea:	e9 9a f5 ff ff       	jmp    80105c89 <alltraps>

801066ef <vector150>:
.globl vector150
vector150:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $150
801066f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801066f6:	e9 8e f5 ff ff       	jmp    80105c89 <alltraps>

801066fb <vector151>:
.globl vector151
vector151:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $151
801066fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106702:	e9 82 f5 ff ff       	jmp    80105c89 <alltraps>

80106707 <vector152>:
.globl vector152
vector152:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $152
80106709:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010670e:	e9 76 f5 ff ff       	jmp    80105c89 <alltraps>

80106713 <vector153>:
.globl vector153
vector153:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $153
80106715:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010671a:	e9 6a f5 ff ff       	jmp    80105c89 <alltraps>

8010671f <vector154>:
.globl vector154
vector154:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $154
80106721:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106726:	e9 5e f5 ff ff       	jmp    80105c89 <alltraps>

8010672b <vector155>:
.globl vector155
vector155:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $155
8010672d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106732:	e9 52 f5 ff ff       	jmp    80105c89 <alltraps>

80106737 <vector156>:
.globl vector156
vector156:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $156
80106739:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010673e:	e9 46 f5 ff ff       	jmp    80105c89 <alltraps>

80106743 <vector157>:
.globl vector157
vector157:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $157
80106745:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010674a:	e9 3a f5 ff ff       	jmp    80105c89 <alltraps>

8010674f <vector158>:
.globl vector158
vector158:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $158
80106751:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106756:	e9 2e f5 ff ff       	jmp    80105c89 <alltraps>

8010675b <vector159>:
.globl vector159
vector159:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $159
8010675d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106762:	e9 22 f5 ff ff       	jmp    80105c89 <alltraps>

80106767 <vector160>:
.globl vector160
vector160:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $160
80106769:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010676e:	e9 16 f5 ff ff       	jmp    80105c89 <alltraps>

80106773 <vector161>:
.globl vector161
vector161:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $161
80106775:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010677a:	e9 0a f5 ff ff       	jmp    80105c89 <alltraps>

8010677f <vector162>:
.globl vector162
vector162:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $162
80106781:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106786:	e9 fe f4 ff ff       	jmp    80105c89 <alltraps>

8010678b <vector163>:
.globl vector163
vector163:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $163
8010678d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106792:	e9 f2 f4 ff ff       	jmp    80105c89 <alltraps>

80106797 <vector164>:
.globl vector164
vector164:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $164
80106799:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010679e:	e9 e6 f4 ff ff       	jmp    80105c89 <alltraps>

801067a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $165
801067a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067aa:	e9 da f4 ff ff       	jmp    80105c89 <alltraps>

801067af <vector166>:
.globl vector166
vector166:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $166
801067b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801067b6:	e9 ce f4 ff ff       	jmp    80105c89 <alltraps>

801067bb <vector167>:
.globl vector167
vector167:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $167
801067bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801067c2:	e9 c2 f4 ff ff       	jmp    80105c89 <alltraps>

801067c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $168
801067c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801067ce:	e9 b6 f4 ff ff       	jmp    80105c89 <alltraps>

801067d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $169
801067d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801067da:	e9 aa f4 ff ff       	jmp    80105c89 <alltraps>

801067df <vector170>:
.globl vector170
vector170:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $170
801067e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801067e6:	e9 9e f4 ff ff       	jmp    80105c89 <alltraps>

801067eb <vector171>:
.globl vector171
vector171:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $171
801067ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801067f2:	e9 92 f4 ff ff       	jmp    80105c89 <alltraps>

801067f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $172
801067f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801067fe:	e9 86 f4 ff ff       	jmp    80105c89 <alltraps>

80106803 <vector173>:
.globl vector173
vector173:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $173
80106805:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010680a:	e9 7a f4 ff ff       	jmp    80105c89 <alltraps>

8010680f <vector174>:
.globl vector174
vector174:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $174
80106811:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106816:	e9 6e f4 ff ff       	jmp    80105c89 <alltraps>

8010681b <vector175>:
.globl vector175
vector175:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $175
8010681d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106822:	e9 62 f4 ff ff       	jmp    80105c89 <alltraps>

80106827 <vector176>:
.globl vector176
vector176:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $176
80106829:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010682e:	e9 56 f4 ff ff       	jmp    80105c89 <alltraps>

80106833 <vector177>:
.globl vector177
vector177:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $177
80106835:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010683a:	e9 4a f4 ff ff       	jmp    80105c89 <alltraps>

8010683f <vector178>:
.globl vector178
vector178:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $178
80106841:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106846:	e9 3e f4 ff ff       	jmp    80105c89 <alltraps>

8010684b <vector179>:
.globl vector179
vector179:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $179
8010684d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106852:	e9 32 f4 ff ff       	jmp    80105c89 <alltraps>

80106857 <vector180>:
.globl vector180
vector180:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $180
80106859:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010685e:	e9 26 f4 ff ff       	jmp    80105c89 <alltraps>

80106863 <vector181>:
.globl vector181
vector181:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $181
80106865:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010686a:	e9 1a f4 ff ff       	jmp    80105c89 <alltraps>

8010686f <vector182>:
.globl vector182
vector182:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $182
80106871:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106876:	e9 0e f4 ff ff       	jmp    80105c89 <alltraps>

8010687b <vector183>:
.globl vector183
vector183:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $183
8010687d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106882:	e9 02 f4 ff ff       	jmp    80105c89 <alltraps>

80106887 <vector184>:
.globl vector184
vector184:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $184
80106889:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010688e:	e9 f6 f3 ff ff       	jmp    80105c89 <alltraps>

80106893 <vector185>:
.globl vector185
vector185:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $185
80106895:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010689a:	e9 ea f3 ff ff       	jmp    80105c89 <alltraps>

8010689f <vector186>:
.globl vector186
vector186:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $186
801068a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068a6:	e9 de f3 ff ff       	jmp    80105c89 <alltraps>

801068ab <vector187>:
.globl vector187
vector187:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $187
801068ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801068b2:	e9 d2 f3 ff ff       	jmp    80105c89 <alltraps>

801068b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $188
801068b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801068be:	e9 c6 f3 ff ff       	jmp    80105c89 <alltraps>

801068c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $189
801068c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801068ca:	e9 ba f3 ff ff       	jmp    80105c89 <alltraps>

801068cf <vector190>:
.globl vector190
vector190:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $190
801068d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801068d6:	e9 ae f3 ff ff       	jmp    80105c89 <alltraps>

801068db <vector191>:
.globl vector191
vector191:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $191
801068dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801068e2:	e9 a2 f3 ff ff       	jmp    80105c89 <alltraps>

801068e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $192
801068e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801068ee:	e9 96 f3 ff ff       	jmp    80105c89 <alltraps>

801068f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $193
801068f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801068fa:	e9 8a f3 ff ff       	jmp    80105c89 <alltraps>

801068ff <vector194>:
.globl vector194
vector194:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $194
80106901:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106906:	e9 7e f3 ff ff       	jmp    80105c89 <alltraps>

8010690b <vector195>:
.globl vector195
vector195:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $195
8010690d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106912:	e9 72 f3 ff ff       	jmp    80105c89 <alltraps>

80106917 <vector196>:
.globl vector196
vector196:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $196
80106919:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010691e:	e9 66 f3 ff ff       	jmp    80105c89 <alltraps>

80106923 <vector197>:
.globl vector197
vector197:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $197
80106925:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010692a:	e9 5a f3 ff ff       	jmp    80105c89 <alltraps>

8010692f <vector198>:
.globl vector198
vector198:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $198
80106931:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106936:	e9 4e f3 ff ff       	jmp    80105c89 <alltraps>

8010693b <vector199>:
.globl vector199
vector199:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $199
8010693d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106942:	e9 42 f3 ff ff       	jmp    80105c89 <alltraps>

80106947 <vector200>:
.globl vector200
vector200:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $200
80106949:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010694e:	e9 36 f3 ff ff       	jmp    80105c89 <alltraps>

80106953 <vector201>:
.globl vector201
vector201:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $201
80106955:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010695a:	e9 2a f3 ff ff       	jmp    80105c89 <alltraps>

8010695f <vector202>:
.globl vector202
vector202:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $202
80106961:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106966:	e9 1e f3 ff ff       	jmp    80105c89 <alltraps>

8010696b <vector203>:
.globl vector203
vector203:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $203
8010696d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106972:	e9 12 f3 ff ff       	jmp    80105c89 <alltraps>

80106977 <vector204>:
.globl vector204
vector204:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $204
80106979:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010697e:	e9 06 f3 ff ff       	jmp    80105c89 <alltraps>

80106983 <vector205>:
.globl vector205
vector205:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $205
80106985:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010698a:	e9 fa f2 ff ff       	jmp    80105c89 <alltraps>

8010698f <vector206>:
.globl vector206
vector206:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $206
80106991:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106996:	e9 ee f2 ff ff       	jmp    80105c89 <alltraps>

8010699b <vector207>:
.globl vector207
vector207:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $207
8010699d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069a2:	e9 e2 f2 ff ff       	jmp    80105c89 <alltraps>

801069a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $208
801069a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801069ae:	e9 d6 f2 ff ff       	jmp    80105c89 <alltraps>

801069b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $209
801069b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801069ba:	e9 ca f2 ff ff       	jmp    80105c89 <alltraps>

801069bf <vector210>:
.globl vector210
vector210:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $210
801069c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801069c6:	e9 be f2 ff ff       	jmp    80105c89 <alltraps>

801069cb <vector211>:
.globl vector211
vector211:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $211
801069cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801069d2:	e9 b2 f2 ff ff       	jmp    80105c89 <alltraps>

801069d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $212
801069d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801069de:	e9 a6 f2 ff ff       	jmp    80105c89 <alltraps>

801069e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $213
801069e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801069ea:	e9 9a f2 ff ff       	jmp    80105c89 <alltraps>

801069ef <vector214>:
.globl vector214
vector214:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $214
801069f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801069f6:	e9 8e f2 ff ff       	jmp    80105c89 <alltraps>

801069fb <vector215>:
.globl vector215
vector215:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $215
801069fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a02:	e9 82 f2 ff ff       	jmp    80105c89 <alltraps>

80106a07 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $216
80106a09:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a0e:	e9 76 f2 ff ff       	jmp    80105c89 <alltraps>

80106a13 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $217
80106a15:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a1a:	e9 6a f2 ff ff       	jmp    80105c89 <alltraps>

80106a1f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $218
80106a21:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a26:	e9 5e f2 ff ff       	jmp    80105c89 <alltraps>

80106a2b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $219
80106a2d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a32:	e9 52 f2 ff ff       	jmp    80105c89 <alltraps>

80106a37 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $220
80106a39:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a3e:	e9 46 f2 ff ff       	jmp    80105c89 <alltraps>

80106a43 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $221
80106a45:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a4a:	e9 3a f2 ff ff       	jmp    80105c89 <alltraps>

80106a4f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $222
80106a51:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106a56:	e9 2e f2 ff ff       	jmp    80105c89 <alltraps>

80106a5b <vector223>:
.globl vector223
vector223:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $223
80106a5d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106a62:	e9 22 f2 ff ff       	jmp    80105c89 <alltraps>

80106a67 <vector224>:
.globl vector224
vector224:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $224
80106a69:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106a6e:	e9 16 f2 ff ff       	jmp    80105c89 <alltraps>

80106a73 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $225
80106a75:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a7a:	e9 0a f2 ff ff       	jmp    80105c89 <alltraps>

80106a7f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $226
80106a81:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a86:	e9 fe f1 ff ff       	jmp    80105c89 <alltraps>

80106a8b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $227
80106a8d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a92:	e9 f2 f1 ff ff       	jmp    80105c89 <alltraps>

80106a97 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $228
80106a99:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a9e:	e9 e6 f1 ff ff       	jmp    80105c89 <alltraps>

80106aa3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $229
80106aa5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106aaa:	e9 da f1 ff ff       	jmp    80105c89 <alltraps>

80106aaf <vector230>:
.globl vector230
vector230:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $230
80106ab1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ab6:	e9 ce f1 ff ff       	jmp    80105c89 <alltraps>

80106abb <vector231>:
.globl vector231
vector231:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $231
80106abd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106ac2:	e9 c2 f1 ff ff       	jmp    80105c89 <alltraps>

80106ac7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $232
80106ac9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106ace:	e9 b6 f1 ff ff       	jmp    80105c89 <alltraps>

80106ad3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $233
80106ad5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106ada:	e9 aa f1 ff ff       	jmp    80105c89 <alltraps>

80106adf <vector234>:
.globl vector234
vector234:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $234
80106ae1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106ae6:	e9 9e f1 ff ff       	jmp    80105c89 <alltraps>

80106aeb <vector235>:
.globl vector235
vector235:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $235
80106aed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106af2:	e9 92 f1 ff ff       	jmp    80105c89 <alltraps>

80106af7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $236
80106af9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106afe:	e9 86 f1 ff ff       	jmp    80105c89 <alltraps>

80106b03 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $237
80106b05:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b0a:	e9 7a f1 ff ff       	jmp    80105c89 <alltraps>

80106b0f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $238
80106b11:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b16:	e9 6e f1 ff ff       	jmp    80105c89 <alltraps>

80106b1b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $239
80106b1d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b22:	e9 62 f1 ff ff       	jmp    80105c89 <alltraps>

80106b27 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $240
80106b29:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b2e:	e9 56 f1 ff ff       	jmp    80105c89 <alltraps>

80106b33 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $241
80106b35:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b3a:	e9 4a f1 ff ff       	jmp    80105c89 <alltraps>

80106b3f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $242
80106b41:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b46:	e9 3e f1 ff ff       	jmp    80105c89 <alltraps>

80106b4b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $243
80106b4d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106b52:	e9 32 f1 ff ff       	jmp    80105c89 <alltraps>

80106b57 <vector244>:
.globl vector244
vector244:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $244
80106b59:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106b5e:	e9 26 f1 ff ff       	jmp    80105c89 <alltraps>

80106b63 <vector245>:
.globl vector245
vector245:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $245
80106b65:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106b6a:	e9 1a f1 ff ff       	jmp    80105c89 <alltraps>

80106b6f <vector246>:
.globl vector246
vector246:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $246
80106b71:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b76:	e9 0e f1 ff ff       	jmp    80105c89 <alltraps>

80106b7b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $247
80106b7d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b82:	e9 02 f1 ff ff       	jmp    80105c89 <alltraps>

80106b87 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $248
80106b89:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b8e:	e9 f6 f0 ff ff       	jmp    80105c89 <alltraps>

80106b93 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $249
80106b95:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b9a:	e9 ea f0 ff ff       	jmp    80105c89 <alltraps>

80106b9f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $250
80106ba1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ba6:	e9 de f0 ff ff       	jmp    80105c89 <alltraps>

80106bab <vector251>:
.globl vector251
vector251:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $251
80106bad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106bb2:	e9 d2 f0 ff ff       	jmp    80105c89 <alltraps>

80106bb7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $252
80106bb9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106bbe:	e9 c6 f0 ff ff       	jmp    80105c89 <alltraps>

80106bc3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $253
80106bc5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106bca:	e9 ba f0 ff ff       	jmp    80105c89 <alltraps>

80106bcf <vector254>:
.globl vector254
vector254:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $254
80106bd1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106bd6:	e9 ae f0 ff ff       	jmp    80105c89 <alltraps>

80106bdb <vector255>:
.globl vector255
vector255:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $255
80106bdd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106be2:	e9 a2 f0 ff ff       	jmp    80105c89 <alltraps>
80106be7:	66 90                	xchg   %ax,%ax
80106be9:	66 90                	xchg   %ax,%ax
80106beb:	66 90                	xchg   %ax,%ax
80106bed:	66 90                	xchg   %ax,%ax
80106bef:	90                   	nop

80106bf0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106bf6:	89 d3                	mov    %edx,%ebx
{
80106bf8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106bfa:	c1 eb 16             	shr    $0x16,%ebx
80106bfd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106c00:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106c03:	8b 06                	mov    (%esi),%eax
80106c05:	a8 01                	test   $0x1,%al
80106c07:	74 27                	je     80106c30 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c0e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106c14:	c1 ef 0a             	shr    $0xa,%edi
}
80106c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c1a:	89 fa                	mov    %edi,%edx
80106c1c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c22:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106c25:	5b                   	pop    %ebx
80106c26:	5e                   	pop    %esi
80106c27:	5f                   	pop    %edi
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    
80106c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c30:	85 c9                	test   %ecx,%ecx
80106c32:	74 2c                	je     80106c60 <walkpgdir+0x70>
80106c34:	e8 e7 b8 ff ff       	call   80102520 <kalloc>
80106c39:	85 c0                	test   %eax,%eax
80106c3b:	89 c3                	mov    %eax,%ebx
80106c3d:	74 21                	je     80106c60 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106c3f:	83 ec 04             	sub    $0x4,%esp
80106c42:	68 00 10 00 00       	push   $0x1000
80106c47:	6a 00                	push   $0x0
80106c49:	50                   	push   %eax
80106c4a:	e8 91 dd ff ff       	call   801049e0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c4f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c55:	83 c4 10             	add    $0x10,%esp
80106c58:	83 c8 07             	or     $0x7,%eax
80106c5b:	89 06                	mov    %eax,(%esi)
80106c5d:	eb b5                	jmp    80106c14 <walkpgdir+0x24>
80106c5f:	90                   	nop
}
80106c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106c63:	31 c0                	xor    %eax,%eax
}
80106c65:	5b                   	pop    %ebx
80106c66:	5e                   	pop    %esi
80106c67:	5f                   	pop    %edi
80106c68:	5d                   	pop    %ebp
80106c69:	c3                   	ret    
80106c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c70 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c70:	55                   	push   %ebp
80106c71:	89 e5                	mov    %esp,%ebp
80106c73:	57                   	push   %edi
80106c74:	56                   	push   %esi
80106c75:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c76:	89 d3                	mov    %edx,%ebx
80106c78:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c7e:	83 ec 1c             	sub    $0x1c,%esp
80106c81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c84:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c88:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c96:	29 df                	sub    %ebx,%edi
80106c98:	83 c8 01             	or     $0x1,%eax
80106c9b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c9e:	eb 15                	jmp    80106cb5 <mappages+0x45>
    if(*pte & PTE_P)
80106ca0:	f6 00 01             	testb  $0x1,(%eax)
80106ca3:	75 45                	jne    80106cea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106ca5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ca8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106cab:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106cad:	74 31                	je     80106ce0 <mappages+0x70>
      break;
    a += PGSIZE;
80106caf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106cb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cb8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106cbd:	89 da                	mov    %ebx,%edx
80106cbf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106cc2:	e8 29 ff ff ff       	call   80106bf0 <walkpgdir>
80106cc7:	85 c0                	test   %eax,%eax
80106cc9:	75 d5                	jne    80106ca0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106cce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106cd3:	5b                   	pop    %ebx
80106cd4:	5e                   	pop    %esi
80106cd5:	5f                   	pop    %edi
80106cd6:	5d                   	pop    %ebp
80106cd7:	c3                   	ret    
80106cd8:	90                   	nop
80106cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ce3:	31 c0                	xor    %eax,%eax
}
80106ce5:	5b                   	pop    %ebx
80106ce6:	5e                   	pop    %esi
80106ce7:	5f                   	pop    %edi
80106ce8:	5d                   	pop    %ebp
80106ce9:	c3                   	ret    
      panic("remap");
80106cea:	83 ec 0c             	sub    $0xc,%esp
80106ced:	68 b4 7e 10 80       	push   $0x80107eb4
80106cf2:	e8 99 96 ff ff       	call   80100390 <panic>
80106cf7:	89 f6                	mov    %esi,%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d00 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d06:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d0c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106d0e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d14:	83 ec 1c             	sub    $0x1c,%esp
80106d17:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d1a:	39 d3                	cmp    %edx,%ebx
80106d1c:	73 66                	jae    80106d84 <deallocuvm.part.0+0x84>
80106d1e:	89 d6                	mov    %edx,%esi
80106d20:	eb 3d                	jmp    80106d5f <deallocuvm.part.0+0x5f>
80106d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106d28:	8b 10                	mov    (%eax),%edx
80106d2a:	f6 c2 01             	test   $0x1,%dl
80106d2d:	74 26                	je     80106d55 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106d2f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106d35:	74 58                	je     80106d8f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106d37:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d3a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106d40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106d43:	52                   	push   %edx
80106d44:	e8 27 b6 ff ff       	call   80102370 <kfree>
      *pte = 0;
80106d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d4c:	83 c4 10             	add    $0x10,%esp
80106d4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106d55:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d5b:	39 f3                	cmp    %esi,%ebx
80106d5d:	73 25                	jae    80106d84 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106d5f:	31 c9                	xor    %ecx,%ecx
80106d61:	89 da                	mov    %ebx,%edx
80106d63:	89 f8                	mov    %edi,%eax
80106d65:	e8 86 fe ff ff       	call   80106bf0 <walkpgdir>
    if(!pte)
80106d6a:	85 c0                	test   %eax,%eax
80106d6c:	75 ba                	jne    80106d28 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d6e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d74:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d7a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d80:	39 f3                	cmp    %esi,%ebx
80106d82:	72 db                	jb     80106d5f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d8a:	5b                   	pop    %ebx
80106d8b:	5e                   	pop    %esi
80106d8c:	5f                   	pop    %edi
80106d8d:	5d                   	pop    %ebp
80106d8e:	c3                   	ret    
        panic("kfree");
80106d8f:	83 ec 0c             	sub    $0xc,%esp
80106d92:	68 86 77 10 80       	push   $0x80107786
80106d97:	e8 f4 95 ff ff       	call   80100390 <panic>
80106d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106da0 <seginit>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106da6:	e8 d5 ca ff ff       	call   80103880 <cpuid>
80106dab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106db1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106db6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106dba:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106dc1:	ff 00 00 
80106dc4:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106dcb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106dce:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106dd5:	ff 00 00 
80106dd8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106ddf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106de2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106de9:	ff 00 00 
80106dec:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106df3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106df6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106dfd:	ff 00 00 
80106e00:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106e07:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106e0a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106e0f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106e13:	c1 e8 10             	shr    $0x10,%eax
80106e16:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106e1a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106e1d:	0f 01 10             	lgdtl  (%eax)
}
80106e20:	c9                   	leave  
80106e21:	c3                   	ret    
80106e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e30 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e30:	a1 a4 78 11 80       	mov    0x801178a4,%eax
{
80106e35:	55                   	push   %ebp
80106e36:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e38:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106e3d:	0f 22 d8             	mov    %eax,%cr3
}
80106e40:	5d                   	pop    %ebp
80106e41:	c3                   	ret    
80106e42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e50 <switchuvm>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 1c             	sub    $0x1c,%esp
80106e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106e5c:	85 db                	test   %ebx,%ebx
80106e5e:	0f 84 cb 00 00 00    	je     80106f2f <switchuvm+0xdf>
  if(p->kstack == 0)
80106e64:	8b 43 08             	mov    0x8(%ebx),%eax
80106e67:	85 c0                	test   %eax,%eax
80106e69:	0f 84 da 00 00 00    	je     80106f49 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106e6f:	8b 43 04             	mov    0x4(%ebx),%eax
80106e72:	85 c0                	test   %eax,%eax
80106e74:	0f 84 c2 00 00 00    	je     80106f3c <switchuvm+0xec>
  pushcli();
80106e7a:	e8 81 d9 ff ff       	call   80104800 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e7f:	e8 7c c9 ff ff       	call   80103800 <mycpu>
80106e84:	89 c6                	mov    %eax,%esi
80106e86:	e8 75 c9 ff ff       	call   80103800 <mycpu>
80106e8b:	89 c7                	mov    %eax,%edi
80106e8d:	e8 6e c9 ff ff       	call   80103800 <mycpu>
80106e92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e95:	83 c7 08             	add    $0x8,%edi
80106e98:	e8 63 c9 ff ff       	call   80103800 <mycpu>
80106e9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ea0:	83 c0 08             	add    $0x8,%eax
80106ea3:	ba 67 00 00 00       	mov    $0x67,%edx
80106ea8:	c1 e8 18             	shr    $0x18,%eax
80106eab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106eb2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106eb9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ebf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ec4:	83 c1 08             	add    $0x8,%ecx
80106ec7:	c1 e9 10             	shr    $0x10,%ecx
80106eca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106ed0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ed5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106edc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106ee1:	e8 1a c9 ff ff       	call   80103800 <mycpu>
80106ee6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106eed:	e8 0e c9 ff ff       	call   80103800 <mycpu>
80106ef2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ef6:	8b 73 08             	mov    0x8(%ebx),%esi
80106ef9:	e8 02 c9 ff ff       	call   80103800 <mycpu>
80106efe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f04:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f07:	e8 f4 c8 ff ff       	call   80103800 <mycpu>
80106f0c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106f10:	b8 28 00 00 00       	mov    $0x28,%eax
80106f15:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106f18:	8b 43 04             	mov    0x4(%ebx),%eax
80106f1b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f20:	0f 22 d8             	mov    %eax,%cr3
}
80106f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f26:	5b                   	pop    %ebx
80106f27:	5e                   	pop    %esi
80106f28:	5f                   	pop    %edi
80106f29:	5d                   	pop    %ebp
  popcli();
80106f2a:	e9 11 d9 ff ff       	jmp    80104840 <popcli>
    panic("switchuvm: no process");
80106f2f:	83 ec 0c             	sub    $0xc,%esp
80106f32:	68 ba 7e 10 80       	push   $0x80107eba
80106f37:	e8 54 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106f3c:	83 ec 0c             	sub    $0xc,%esp
80106f3f:	68 e5 7e 10 80       	push   $0x80107ee5
80106f44:	e8 47 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106f49:	83 ec 0c             	sub    $0xc,%esp
80106f4c:	68 d0 7e 10 80       	push   $0x80107ed0
80106f51:	e8 3a 94 ff ff       	call   80100390 <panic>
80106f56:	8d 76 00             	lea    0x0(%esi),%esi
80106f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f60 <inituvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
80106f69:	8b 75 10             	mov    0x10(%ebp),%esi
80106f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f6f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106f72:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f7b:	77 49                	ja     80106fc6 <inituvm+0x66>
  mem = kalloc();
80106f7d:	e8 9e b5 ff ff       	call   80102520 <kalloc>
  memset(mem, 0, PGSIZE);
80106f82:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f85:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f87:	68 00 10 00 00       	push   $0x1000
80106f8c:	6a 00                	push   $0x0
80106f8e:	50                   	push   %eax
80106f8f:	e8 4c da ff ff       	call   801049e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f94:	58                   	pop    %eax
80106f95:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f9b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fa0:	5a                   	pop    %edx
80106fa1:	6a 06                	push   $0x6
80106fa3:	50                   	push   %eax
80106fa4:	31 d2                	xor    %edx,%edx
80106fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fa9:	e8 c2 fc ff ff       	call   80106c70 <mappages>
  memmove(mem, init, sz);
80106fae:	89 75 10             	mov    %esi,0x10(%ebp)
80106fb1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106fb4:	83 c4 10             	add    $0x10,%esp
80106fb7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106fba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fbd:	5b                   	pop    %ebx
80106fbe:	5e                   	pop    %esi
80106fbf:	5f                   	pop    %edi
80106fc0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106fc1:	e9 ca da ff ff       	jmp    80104a90 <memmove>
    panic("inituvm: more than a page");
80106fc6:	83 ec 0c             	sub    $0xc,%esp
80106fc9:	68 f9 7e 10 80       	push   $0x80107ef9
80106fce:	e8 bd 93 ff ff       	call   80100390 <panic>
80106fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fe0 <loaduvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	57                   	push   %edi
80106fe4:	56                   	push   %esi
80106fe5:	53                   	push   %ebx
80106fe6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106fe9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ff0:	0f 85 91 00 00 00    	jne    80107087 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106ff6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ff9:	31 db                	xor    %ebx,%ebx
80106ffb:	85 f6                	test   %esi,%esi
80106ffd:	75 1a                	jne    80107019 <loaduvm+0x39>
80106fff:	eb 6f                	jmp    80107070 <loaduvm+0x90>
80107001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107008:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010700e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107014:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107017:	76 57                	jbe    80107070 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107019:	8b 55 0c             	mov    0xc(%ebp),%edx
8010701c:	8b 45 08             	mov    0x8(%ebp),%eax
8010701f:	31 c9                	xor    %ecx,%ecx
80107021:	01 da                	add    %ebx,%edx
80107023:	e8 c8 fb ff ff       	call   80106bf0 <walkpgdir>
80107028:	85 c0                	test   %eax,%eax
8010702a:	74 4e                	je     8010707a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
8010702c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010702e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107031:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107036:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010703b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107041:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107044:	01 d9                	add    %ebx,%ecx
80107046:	05 00 00 00 80       	add    $0x80000000,%eax
8010704b:	57                   	push   %edi
8010704c:	51                   	push   %ecx
8010704d:	50                   	push   %eax
8010704e:	ff 75 10             	pushl  0x10(%ebp)
80107051:	e8 6a a9 ff ff       	call   801019c0 <readi>
80107056:	83 c4 10             	add    $0x10,%esp
80107059:	39 f8                	cmp    %edi,%eax
8010705b:	74 ab                	je     80107008 <loaduvm+0x28>
}
8010705d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107065:	5b                   	pop    %ebx
80107066:	5e                   	pop    %esi
80107067:	5f                   	pop    %edi
80107068:	5d                   	pop    %ebp
80107069:	c3                   	ret    
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107070:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107073:	31 c0                	xor    %eax,%eax
}
80107075:	5b                   	pop    %ebx
80107076:	5e                   	pop    %esi
80107077:	5f                   	pop    %edi
80107078:	5d                   	pop    %ebp
80107079:	c3                   	ret    
      panic("loaduvm: address should exist");
8010707a:	83 ec 0c             	sub    $0xc,%esp
8010707d:	68 13 7f 10 80       	push   $0x80107f13
80107082:	e8 09 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107087:	83 ec 0c             	sub    $0xc,%esp
8010708a:	68 b4 7f 10 80       	push   $0x80107fb4
8010708f:	e8 fc 92 ff ff       	call   80100390 <panic>
80107094:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010709a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070a0 <allocuvm>:
{
801070a0:	55                   	push   %ebp
801070a1:	89 e5                	mov    %esp,%ebp
801070a3:	57                   	push   %edi
801070a4:	56                   	push   %esi
801070a5:	53                   	push   %ebx
801070a6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801070a9:	8b 7d 10             	mov    0x10(%ebp),%edi
801070ac:	85 ff                	test   %edi,%edi
801070ae:	0f 88 8e 00 00 00    	js     80107142 <allocuvm+0xa2>
  if(newsz < oldsz)
801070b4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801070b7:	0f 82 93 00 00 00    	jb     80107150 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
801070bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801070c0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801070c6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801070cc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801070cf:	0f 86 7e 00 00 00    	jbe    80107153 <allocuvm+0xb3>
801070d5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801070d8:	8b 7d 08             	mov    0x8(%ebp),%edi
801070db:	eb 42                	jmp    8010711f <allocuvm+0x7f>
801070dd:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
801070e0:	83 ec 04             	sub    $0x4,%esp
801070e3:	68 00 10 00 00       	push   $0x1000
801070e8:	6a 00                	push   $0x0
801070ea:	50                   	push   %eax
801070eb:	e8 f0 d8 ff ff       	call   801049e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801070f0:	58                   	pop    %eax
801070f1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070f7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070fc:	5a                   	pop    %edx
801070fd:	6a 06                	push   $0x6
801070ff:	50                   	push   %eax
80107100:	89 da                	mov    %ebx,%edx
80107102:	89 f8                	mov    %edi,%eax
80107104:	e8 67 fb ff ff       	call   80106c70 <mappages>
80107109:	83 c4 10             	add    $0x10,%esp
8010710c:	85 c0                	test   %eax,%eax
8010710e:	78 50                	js     80107160 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107110:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107116:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107119:	0f 86 81 00 00 00    	jbe    801071a0 <allocuvm+0x100>
    mem = kalloc();
8010711f:	e8 fc b3 ff ff       	call   80102520 <kalloc>
    if(mem == 0){
80107124:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107126:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107128:	75 b6                	jne    801070e0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
8010712a:	83 ec 0c             	sub    $0xc,%esp
8010712d:	68 31 7f 10 80       	push   $0x80107f31
80107132:	e8 29 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80107137:	83 c4 10             	add    $0x10,%esp
8010713a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010713d:	39 45 10             	cmp    %eax,0x10(%ebp)
80107140:	77 6e                	ja     801071b0 <allocuvm+0x110>
}
80107142:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107145:	31 ff                	xor    %edi,%edi
}
80107147:	89 f8                	mov    %edi,%eax
80107149:	5b                   	pop    %ebx
8010714a:	5e                   	pop    %esi
8010714b:	5f                   	pop    %edi
8010714c:	5d                   	pop    %ebp
8010714d:	c3                   	ret    
8010714e:	66 90                	xchg   %ax,%ax
    return oldsz;
80107150:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107153:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107156:	89 f8                	mov    %edi,%eax
80107158:	5b                   	pop    %ebx
80107159:	5e                   	pop    %esi
8010715a:	5f                   	pop    %edi
8010715b:	5d                   	pop    %ebp
8010715c:	c3                   	ret    
8010715d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107160:	83 ec 0c             	sub    $0xc,%esp
80107163:	68 49 7f 10 80       	push   $0x80107f49
80107168:	e8 f3 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010716d:	83 c4 10             	add    $0x10,%esp
80107170:	8b 45 0c             	mov    0xc(%ebp),%eax
80107173:	39 45 10             	cmp    %eax,0x10(%ebp)
80107176:	76 0d                	jbe    80107185 <allocuvm+0xe5>
80107178:	89 c1                	mov    %eax,%ecx
8010717a:	8b 55 10             	mov    0x10(%ebp),%edx
8010717d:	8b 45 08             	mov    0x8(%ebp),%eax
80107180:	e8 7b fb ff ff       	call   80106d00 <deallocuvm.part.0>
      kfree(mem);
80107185:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107188:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010718a:	56                   	push   %esi
8010718b:	e8 e0 b1 ff ff       	call   80102370 <kfree>
      return 0;
80107190:	83 c4 10             	add    $0x10,%esp
}
80107193:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107196:	89 f8                	mov    %edi,%eax
80107198:	5b                   	pop    %ebx
80107199:	5e                   	pop    %esi
8010719a:	5f                   	pop    %edi
8010719b:	5d                   	pop    %ebp
8010719c:	c3                   	ret    
8010719d:	8d 76 00             	lea    0x0(%esi),%esi
801071a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801071a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071a6:	5b                   	pop    %ebx
801071a7:	89 f8                	mov    %edi,%eax
801071a9:	5e                   	pop    %esi
801071aa:	5f                   	pop    %edi
801071ab:	5d                   	pop    %ebp
801071ac:	c3                   	ret    
801071ad:	8d 76 00             	lea    0x0(%esi),%esi
801071b0:	89 c1                	mov    %eax,%ecx
801071b2:	8b 55 10             	mov    0x10(%ebp),%edx
801071b5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
801071b8:	31 ff                	xor    %edi,%edi
801071ba:	e8 41 fb ff ff       	call   80106d00 <deallocuvm.part.0>
801071bf:	eb 92                	jmp    80107153 <allocuvm+0xb3>
801071c1:	eb 0d                	jmp    801071d0 <deallocuvm>
801071c3:	90                   	nop
801071c4:	90                   	nop
801071c5:	90                   	nop
801071c6:	90                   	nop
801071c7:	90                   	nop
801071c8:	90                   	nop
801071c9:	90                   	nop
801071ca:	90                   	nop
801071cb:	90                   	nop
801071cc:	90                   	nop
801071cd:	90                   	nop
801071ce:	90                   	nop
801071cf:	90                   	nop

801071d0 <deallocuvm>:
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801071d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801071d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801071dc:	39 d1                	cmp    %edx,%ecx
801071de:	73 10                	jae    801071f0 <deallocuvm+0x20>
}
801071e0:	5d                   	pop    %ebp
801071e1:	e9 1a fb ff ff       	jmp    80106d00 <deallocuvm.part.0>
801071e6:	8d 76 00             	lea    0x0(%esi),%esi
801071e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801071f0:	89 d0                	mov    %edx,%eax
801071f2:	5d                   	pop    %ebp
801071f3:	c3                   	ret    
801071f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107200 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 0c             	sub    $0xc,%esp
80107209:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010720c:	85 f6                	test   %esi,%esi
8010720e:	74 59                	je     80107269 <freevm+0x69>
80107210:	31 c9                	xor    %ecx,%ecx
80107212:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107217:	89 f0                	mov    %esi,%eax
80107219:	e8 e2 fa ff ff       	call   80106d00 <deallocuvm.part.0>
8010721e:	89 f3                	mov    %esi,%ebx
80107220:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107226:	eb 0f                	jmp    80107237 <freevm+0x37>
80107228:	90                   	nop
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107230:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107233:	39 fb                	cmp    %edi,%ebx
80107235:	74 23                	je     8010725a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107237:	8b 03                	mov    (%ebx),%eax
80107239:	a8 01                	test   $0x1,%al
8010723b:	74 f3                	je     80107230 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010723d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107242:	83 ec 0c             	sub    $0xc,%esp
80107245:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107248:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010724d:	50                   	push   %eax
8010724e:	e8 1d b1 ff ff       	call   80102370 <kfree>
80107253:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107256:	39 fb                	cmp    %edi,%ebx
80107258:	75 dd                	jne    80107237 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010725a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010725d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107260:	5b                   	pop    %ebx
80107261:	5e                   	pop    %esi
80107262:	5f                   	pop    %edi
80107263:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107264:	e9 07 b1 ff ff       	jmp    80102370 <kfree>
    panic("freevm: no pgdir");
80107269:	83 ec 0c             	sub    $0xc,%esp
8010726c:	68 65 7f 10 80       	push   $0x80107f65
80107271:	e8 1a 91 ff ff       	call   80100390 <panic>
80107276:	8d 76 00             	lea    0x0(%esi),%esi
80107279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107280 <setupkvm>:
{
80107280:	55                   	push   %ebp
80107281:	89 e5                	mov    %esp,%ebp
80107283:	56                   	push   %esi
80107284:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107285:	e8 96 b2 ff ff       	call   80102520 <kalloc>
8010728a:	85 c0                	test   %eax,%eax
8010728c:	89 c6                	mov    %eax,%esi
8010728e:	74 42                	je     801072d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107290:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107293:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107298:	68 00 10 00 00       	push   $0x1000
8010729d:	6a 00                	push   $0x0
8010729f:	50                   	push   %eax
801072a0:	e8 3b d7 ff ff       	call   801049e0 <memset>
801072a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801072a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801072ab:	8b 4b 08             	mov    0x8(%ebx),%ecx
801072ae:	83 ec 08             	sub    $0x8,%esp
801072b1:	8b 13                	mov    (%ebx),%edx
801072b3:	ff 73 0c             	pushl  0xc(%ebx)
801072b6:	50                   	push   %eax
801072b7:	29 c1                	sub    %eax,%ecx
801072b9:	89 f0                	mov    %esi,%eax
801072bb:	e8 b0 f9 ff ff       	call   80106c70 <mappages>
801072c0:	83 c4 10             	add    $0x10,%esp
801072c3:	85 c0                	test   %eax,%eax
801072c5:	78 19                	js     801072e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801072c7:	83 c3 10             	add    $0x10,%ebx
801072ca:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801072d0:	75 d6                	jne    801072a8 <setupkvm+0x28>
}
801072d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072d5:	89 f0                	mov    %esi,%eax
801072d7:	5b                   	pop    %ebx
801072d8:	5e                   	pop    %esi
801072d9:	5d                   	pop    %ebp
801072da:	c3                   	ret    
801072db:	90                   	nop
801072dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801072e0:	83 ec 0c             	sub    $0xc,%esp
801072e3:	56                   	push   %esi
      return 0;
801072e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801072e6:	e8 15 ff ff ff       	call   80107200 <freevm>
      return 0;
801072eb:	83 c4 10             	add    $0x10,%esp
}
801072ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072f1:	89 f0                	mov    %esi,%eax
801072f3:	5b                   	pop    %ebx
801072f4:	5e                   	pop    %esi
801072f5:	5d                   	pop    %ebp
801072f6:	c3                   	ret    
801072f7:	89 f6                	mov    %esi,%esi
801072f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107300 <kvmalloc>:
{
80107300:	55                   	push   %ebp
80107301:	89 e5                	mov    %esp,%ebp
80107303:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107306:	e8 75 ff ff ff       	call   80107280 <setupkvm>
8010730b:	a3 a4 78 11 80       	mov    %eax,0x801178a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107310:	05 00 00 00 80       	add    $0x80000000,%eax
80107315:	0f 22 d8             	mov    %eax,%cr3
}
80107318:	c9                   	leave  
80107319:	c3                   	ret    
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107320 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107320:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107321:	31 c9                	xor    %ecx,%ecx
{
80107323:	89 e5                	mov    %esp,%ebp
80107325:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107328:	8b 55 0c             	mov    0xc(%ebp),%edx
8010732b:	8b 45 08             	mov    0x8(%ebp),%eax
8010732e:	e8 bd f8 ff ff       	call   80106bf0 <walkpgdir>
  if(pte == 0)
80107333:	85 c0                	test   %eax,%eax
80107335:	74 05                	je     8010733c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107337:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010733a:	c9                   	leave  
8010733b:	c3                   	ret    
    panic("clearpteu");
8010733c:	83 ec 0c             	sub    $0xc,%esp
8010733f:	68 76 7f 10 80       	push   $0x80107f76
80107344:	e8 47 90 ff ff       	call   80100390 <panic>
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107350 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	53                   	push   %ebx
80107356:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107359:	e8 22 ff ff ff       	call   80107280 <setupkvm>
8010735e:	85 c0                	test   %eax,%eax
80107360:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107363:	0f 84 9f 00 00 00    	je     80107408 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107369:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010736c:	85 c9                	test   %ecx,%ecx
8010736e:	0f 84 94 00 00 00    	je     80107408 <copyuvm+0xb8>
80107374:	31 ff                	xor    %edi,%edi
80107376:	eb 4a                	jmp    801073c2 <copyuvm+0x72>
80107378:	90                   	nop
80107379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107380:	83 ec 04             	sub    $0x4,%esp
80107383:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107389:	68 00 10 00 00       	push   $0x1000
8010738e:	53                   	push   %ebx
8010738f:	50                   	push   %eax
80107390:	e8 fb d6 ff ff       	call   80104a90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107395:	58                   	pop    %eax
80107396:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010739c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801073a1:	5a                   	pop    %edx
801073a2:	ff 75 e4             	pushl  -0x1c(%ebp)
801073a5:	50                   	push   %eax
801073a6:	89 fa                	mov    %edi,%edx
801073a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ab:	e8 c0 f8 ff ff       	call   80106c70 <mappages>
801073b0:	83 c4 10             	add    $0x10,%esp
801073b3:	85 c0                	test   %eax,%eax
801073b5:	78 61                	js     80107418 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
801073b7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073bd:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801073c0:	76 46                	jbe    80107408 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801073c2:	8b 45 08             	mov    0x8(%ebp),%eax
801073c5:	31 c9                	xor    %ecx,%ecx
801073c7:	89 fa                	mov    %edi,%edx
801073c9:	e8 22 f8 ff ff       	call   80106bf0 <walkpgdir>
801073ce:	85 c0                	test   %eax,%eax
801073d0:	74 61                	je     80107433 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801073d2:	8b 00                	mov    (%eax),%eax
801073d4:	a8 01                	test   $0x1,%al
801073d6:	74 4e                	je     80107426 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801073d8:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
801073da:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801073df:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801073e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801073e8:	e8 33 b1 ff ff       	call   80102520 <kalloc>
801073ed:	85 c0                	test   %eax,%eax
801073ef:	89 c6                	mov    %eax,%esi
801073f1:	75 8d                	jne    80107380 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801073f3:	83 ec 0c             	sub    $0xc,%esp
801073f6:	ff 75 e0             	pushl  -0x20(%ebp)
801073f9:	e8 02 fe ff ff       	call   80107200 <freevm>
  return 0;
801073fe:	83 c4 10             	add    $0x10,%esp
80107401:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107408:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010740b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010740e:	5b                   	pop    %ebx
8010740f:	5e                   	pop    %esi
80107410:	5f                   	pop    %edi
80107411:	5d                   	pop    %ebp
80107412:	c3                   	ret    
80107413:	90                   	nop
80107414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107418:	83 ec 0c             	sub    $0xc,%esp
8010741b:	56                   	push   %esi
8010741c:	e8 4f af ff ff       	call   80102370 <kfree>
      goto bad;
80107421:	83 c4 10             	add    $0x10,%esp
80107424:	eb cd                	jmp    801073f3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107426:	83 ec 0c             	sub    $0xc,%esp
80107429:	68 9a 7f 10 80       	push   $0x80107f9a
8010742e:	e8 5d 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107433:	83 ec 0c             	sub    $0xc,%esp
80107436:	68 80 7f 10 80       	push   $0x80107f80
8010743b:	e8 50 8f ff ff       	call   80100390 <panic>

80107440 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107440:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107441:	31 c9                	xor    %ecx,%ecx
{
80107443:	89 e5                	mov    %esp,%ebp
80107445:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107448:	8b 55 0c             	mov    0xc(%ebp),%edx
8010744b:	8b 45 08             	mov    0x8(%ebp),%eax
8010744e:	e8 9d f7 ff ff       	call   80106bf0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107453:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107455:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107456:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107458:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010745d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107460:	05 00 00 00 80       	add    $0x80000000,%eax
80107465:	83 fa 05             	cmp    $0x5,%edx
80107468:	ba 00 00 00 00       	mov    $0x0,%edx
8010746d:	0f 45 c2             	cmovne %edx,%eax
}
80107470:	c3                   	ret    
80107471:	eb 0d                	jmp    80107480 <copyout>
80107473:	90                   	nop
80107474:	90                   	nop
80107475:	90                   	nop
80107476:	90                   	nop
80107477:	90                   	nop
80107478:	90                   	nop
80107479:	90                   	nop
8010747a:	90                   	nop
8010747b:	90                   	nop
8010747c:	90                   	nop
8010747d:	90                   	nop
8010747e:	90                   	nop
8010747f:	90                   	nop

80107480 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	57                   	push   %edi
80107484:	56                   	push   %esi
80107485:	53                   	push   %ebx
80107486:	83 ec 1c             	sub    $0x1c,%esp
80107489:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010748c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010748f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107492:	85 db                	test   %ebx,%ebx
80107494:	75 40                	jne    801074d6 <copyout+0x56>
80107496:	eb 70                	jmp    80107508 <copyout+0x88>
80107498:	90                   	nop
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801074a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074a3:	89 f1                	mov    %esi,%ecx
801074a5:	29 d1                	sub    %edx,%ecx
801074a7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801074ad:	39 d9                	cmp    %ebx,%ecx
801074af:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801074b2:	29 f2                	sub    %esi,%edx
801074b4:	83 ec 04             	sub    $0x4,%esp
801074b7:	01 d0                	add    %edx,%eax
801074b9:	51                   	push   %ecx
801074ba:	57                   	push   %edi
801074bb:	50                   	push   %eax
801074bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801074bf:	e8 cc d5 ff ff       	call   80104a90 <memmove>
    len -= n;
    buf += n;
801074c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801074c7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801074ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801074d0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801074d2:	29 cb                	sub    %ecx,%ebx
801074d4:	74 32                	je     80107508 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801074d6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074d8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801074db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801074de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801074e4:	56                   	push   %esi
801074e5:	ff 75 08             	pushl  0x8(%ebp)
801074e8:	e8 53 ff ff ff       	call   80107440 <uva2ka>
    if(pa0 == 0)
801074ed:	83 c4 10             	add    $0x10,%esp
801074f0:	85 c0                	test   %eax,%eax
801074f2:	75 ac                	jne    801074a0 <copyout+0x20>
  }
  return 0;
}
801074f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074fc:	5b                   	pop    %ebx
801074fd:	5e                   	pop    %esi
801074fe:	5f                   	pop    %edi
801074ff:	5d                   	pop    %ebp
80107500:	c3                   	ret    
80107501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107508:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010750b:	31 c0                	xor    %eax,%eax
}
8010750d:	5b                   	pop    %ebx
8010750e:	5e                   	pop    %esi
8010750f:	5f                   	pop    %edi
80107510:	5d                   	pop    %ebp
80107511:	c3                   	ret    
