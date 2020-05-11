
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

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
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 76 10 80       	push   $0x801076a0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 b5 48 00 00       	call   80104910 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
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
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 76 10 80       	push   $0x801076a7
80100097:	50                   	push   %eax
80100098:	e8 43 47 00 00       	call   801047e0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
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
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 67 49 00 00       	call   80104a50 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
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
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 a9 49 00 00       	call   80104b10 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 46 00 00       	call   80104820 <acquiresleep>
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
80100193:	68 ae 76 10 80       	push   $0x801076ae
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
801001ae:	e8 0d 47 00 00       	call   801048c0 <holdingsleep>
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
801001cc:	68 bf 76 10 80       	push   $0x801076bf
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
801001ef:	e8 cc 46 00 00       	call   801048c0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 46 00 00       	call   80104880 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 40 48 00 00       	call   80104a50 <acquire>
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
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 af 48 00 00       	jmp    80104b10 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 76 10 80       	push   $0x801076c6
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
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 bf 47 00 00       	call   80104a50 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
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
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 f6 3d 00 00       	call   801040c0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 40 35 00 00       	call   80103820 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 1c 48 00 00       	call   80104b10 <release>
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
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
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
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 be 47 00 00       	call   80104b10 <release>
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
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
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
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 e2 23 00 00       	call   80102790 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 76 10 80       	push   $0x801076cd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 83 81 10 80 	movl   $0x80108183,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 53 45 00 00       	call   80104930 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 76 10 80       	push   $0x801076e1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
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
8010043a:	e8 71 5e 00 00       	call   801062b0 <uartputc>
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
801004ec:	e8 bf 5d 00 00       	call   801062b0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 b3 5d 00 00       	call   801062b0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 a7 5d 00 00       	call   801062b0 <uartputc>
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
80100524:	e8 e7 46 00 00       	call   80104c10 <memmove>
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
80100541:	e8 1a 46 00 00       	call   80104b60 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 76 10 80       	push   $0x801076e5
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
801005b1:	0f b6 92 10 77 10 80 	movzbl -0x7fef88f0(%edx),%edx
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
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 30 44 00 00       	call   80104a50 <acquire>
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
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 c4 44 00 00       	call   80104b10 <release>
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
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
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
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 ec 43 00 00       	call   80104b10 <release>
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
801007d0:	ba f8 76 10 80       	mov    $0x801076f8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 5b 42 00 00       	call   80104a50 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 76 10 80       	push   $0x801076ff
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
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 28 42 00 00       	call   80104a50 <acquire>
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
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
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
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 83 42 00 00       	call   80104b10 <release>
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
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 b5 39 00 00       	call   801042d0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
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
80100997:	e9 44 3a 00 00       	jmp    801043e0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
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
801009c6:	68 08 77 10 80       	push   $0x80107708
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 3b 3f 00 00       	call   80104910 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
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
80100a1c:	e8 ff 2d 00 00       	call   80103820 <myproc>
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
80100a94:	e8 67 69 00 00       	call   80107400 <setupkvm>
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
80100af6:	e8 25 67 00 00       	call   80107220 <allocuvm>
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
80100b28:	e8 33 66 00 00       	call   80107160 <loaduvm>
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
80100b72:	e8 09 68 00 00       	call   80107380 <freevm>
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
80100baa:	e8 71 66 00 00       	call   80107220 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ba 67 00 00       	call   80107380 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 98 20 00 00       	call   80102c70 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 77 10 80       	push   $0x80107721
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
80100c06:	e8 95 68 00 00       	call   801074a0 <clearpteu>
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
80100c39:	e8 42 41 00 00       	call   80104d80 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 2f 41 00 00       	call   80104d80 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 9e 69 00 00       	call   80107600 <copyout>
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
80100cc7:	e8 34 69 00 00       	call   80107600 <copyout>
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
80100d08:	e8 33 40 00 00       	call   80104d40 <safestrcpy>
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
80100d63:	e8 68 62 00 00       	call   80106fd0 <switchuvm>
  freevm(oldpgdir);
80100d68:	89 3c 24             	mov    %edi,(%esp)
80100d6b:	e8 10 66 00 00       	call   80107380 <freevm>
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
80100dc6:	68 2d 77 10 80       	push   $0x8010772d
80100dcb:	68 c0 0f 11 80       	push   $0x80110fc0
80100dd0:	e8 3b 3b 00 00       	call   80104910 <initlock>
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
80100de4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100de9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dec:	68 c0 0f 11 80       	push   $0x80110fc0
80100df1:	e8 5a 3c 00 00       	call   80104a50 <acquire>
80100df6:	83 c4 10             	add    $0x10,%esp
80100df9:	eb 10                	jmp    80100e0b <filealloc+0x2b>
80100dfb:	90                   	nop
80100dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e00:	83 c3 18             	add    $0x18,%ebx
80100e03:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
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
80100e1c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e21:	e8 ea 3c 00 00       	call   80104b10 <release>
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
80100e35:	68 c0 0f 11 80       	push   $0x80110fc0
80100e3a:	e8 d1 3c 00 00       	call   80104b10 <release>
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
80100e5a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5f:	e8 ec 3b 00 00       	call   80104a50 <acquire>
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
80100e77:	68 c0 0f 11 80       	push   $0x80110fc0
80100e7c:	e8 8f 3c 00 00       	call   80104b10 <release>
  return f;
}
80100e81:	89 d8                	mov    %ebx,%eax
80100e83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e86:	c9                   	leave  
80100e87:	c3                   	ret    
    panic("filedup");
80100e88:	83 ec 0c             	sub    $0xc,%esp
80100e8b:	68 34 77 10 80       	push   $0x80107734
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
80100eac:	68 c0 0f 11 80       	push   $0x80110fc0
80100eb1:	e8 9a 3b 00 00       	call   80104a50 <acquire>
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
80100ece:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
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
80100edc:	e9 2f 3c 00 00       	jmp    80104b10 <release>
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
80100f00:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f05:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f08:	e8 03 3c 00 00       	call   80104b10 <release>
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
80100f62:	68 3c 77 10 80       	push   $0x8010773c
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
80101042:	68 46 77 10 80       	push   $0x80107746
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
80101155:	68 4f 77 10 80       	push   $0x8010774f
8010115a:	e8 31 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	68 55 77 10 80       	push   $0x80107755
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
8010117a:	03 15 d8 19 11 80    	add    0x801119d8,%edx
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
801011d3:	68 5f 77 10 80       	push   $0x8010775f
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
801011e9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
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
8010120c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101212:	50                   	push   %eax
80101213:	ff 75 d8             	pushl  -0x28(%ebp)
80101216:	e8 b5 ee ff ff       	call   801000d0 <bread>
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 c0 19 11 80       	mov    0x801119c0,%eax
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
80101279:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010127f:	77 80                	ja     80101201 <balloc+0x21>
  panic("balloc: out of blocks");
80101281:	83 ec 0c             	sub    $0xc,%esp
80101284:	68 72 77 10 80       	push   $0x80107772
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
801012c5:	e8 96 38 00 00       	call   80104b60 <memset>
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
801012fa:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 e0 19 11 80       	push   $0x801119e0
8010130a:	e8 41 37 00 00       	call   80104a50 <acquire>
8010130f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101312:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101315:	eb 17                	jmp    8010132e <iget+0x3e>
80101317:	89 f6                	mov    %esi,%esi
80101319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101320:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101326:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
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
80101348:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
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
8010136a:	68 e0 19 11 80       	push   $0x801119e0
8010136f:	e8 9c 37 00 00       	call   80104b10 <release>

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
80101395:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
8010139a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010139d:	e8 6e 37 00 00       	call   80104b10 <release>
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
801013b2:	68 88 77 10 80       	push   $0x80107788
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
80101487:	68 98 77 10 80       	push   $0x80107798
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
801014c1:	e8 4a 37 00 00       	call   80104c10 <memmove>
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
801014e4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014e9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014ec:	68 ab 77 10 80       	push   $0x801077ab
801014f1:	68 e0 19 11 80       	push   $0x801119e0
801014f6:	e8 15 34 00 00       	call   80104910 <initlock>
801014fb:	83 c4 10             	add    $0x10,%esp
801014fe:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101500:	83 ec 08             	sub    $0x8,%esp
80101503:	68 b2 77 10 80       	push   $0x801077b2
80101508:	53                   	push   %ebx
80101509:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010150f:	e8 cc 32 00 00       	call   801047e0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101514:	83 c4 10             	add    $0x10,%esp
80101517:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010151d:	75 e1                	jne    80101500 <iinit+0x20>
  readsb(dev, &sb);
8010151f:	83 ec 08             	sub    $0x8,%esp
80101522:	68 c0 19 11 80       	push   $0x801119c0
80101527:	ff 75 08             	pushl  0x8(%ebp)
8010152a:	e8 71 ff ff ff       	call   801014a0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010152f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101535:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010153b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101541:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101547:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010154d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101553:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101559:	68 18 78 10 80       	push   $0x80107818
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
80101579:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
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
801015af:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
801015b5:	76 69                	jbe    80101620 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015b7:	89 d8                	mov    %ebx,%eax
801015b9:	83 ec 08             	sub    $0x8,%esp
801015bc:	c1 e8 03             	shr    $0x3,%eax
801015bf:	03 05 d4 19 11 80    	add    0x801119d4,%eax
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
801015ee:	e8 6d 35 00 00       	call   80104b60 <memset>
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
80101623:	68 b8 77 10 80       	push   $0x801077b8
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
80101644:	03 05 d4 19 11 80    	add    0x801119d4,%eax
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
80101691:	e8 7a 35 00 00       	call   80104c10 <memmove>
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
801016ba:	68 e0 19 11 80       	push   $0x801119e0
801016bf:	e8 8c 33 00 00       	call   80104a50 <acquire>
  ip->ref++;
801016c4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016c8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016cf:	e8 3c 34 00 00       	call   80104b10 <release>
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
80101702:	e8 19 31 00 00       	call   80104820 <acquiresleep>
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
80101729:	03 05 d4 19 11 80    	add    0x801119d4,%eax
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
80101778:	e8 93 34 00 00       	call   80104c10 <memmove>
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
8010179d:	68 d0 77 10 80       	push   $0x801077d0
801017a2:	e8 e9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017a7:	83 ec 0c             	sub    $0xc,%esp
801017aa:	68 ca 77 10 80       	push   $0x801077ca
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
801017d3:	e8 e8 30 00 00       	call   801048c0 <holdingsleep>
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
801017ef:	e9 8c 30 00 00       	jmp    80104880 <releasesleep>
    panic("iunlock");
801017f4:	83 ec 0c             	sub    $0xc,%esp
801017f7:	68 df 77 10 80       	push   $0x801077df
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
80101820:	e8 fb 2f 00 00       	call   80104820 <acquiresleep>
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
8010183a:	e8 41 30 00 00       	call   80104880 <releasesleep>
  acquire(&icache.lock);
8010183f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101846:	e8 05 32 00 00       	call   80104a50 <acquire>
  ip->ref--;
8010184b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010184f:	83 c4 10             	add    $0x10,%esp
80101852:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010185c:	5b                   	pop    %ebx
8010185d:	5e                   	pop    %esi
8010185e:	5f                   	pop    %edi
8010185f:	5d                   	pop    %ebp
  release(&icache.lock);
80101860:	e9 ab 32 00 00       	jmp    80104b10 <release>
80101865:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101868:	83 ec 0c             	sub    $0xc,%esp
8010186b:	68 e0 19 11 80       	push   $0x801119e0
80101870:	e8 db 31 00 00       	call   80104a50 <acquire>
    int r = ip->ref;
80101875:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101878:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010187f:	e8 8c 32 00 00       	call   80104b10 <release>
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
80101a67:	e8 a4 31 00 00       	call   80104c10 <memmove>
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
80101a9a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
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
80101b63:	e8 a8 30 00 00       	call   80104c10 <memmove>
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
80101baa:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
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
80101bfe:	e8 7d 30 00 00       	call   80104c80 <strncmp>
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
80101c5d:	e8 1e 30 00 00       	call   80104c80 <strncmp>
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
80101ca2:	68 f9 77 10 80       	push   $0x801077f9
80101ca7:	e8 e4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cac:	83 ec 0c             	sub    $0xc,%esp
80101caf:	68 e7 77 10 80       	push   $0x801077e7
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
80101cd9:	e8 42 1b 00 00       	call   80103820 <myproc>
  acquire(&icache.lock);
80101cde:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ce1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ce4:	68 e0 19 11 80       	push   $0x801119e0
80101ce9:	e8 62 2d 00 00       	call   80104a50 <acquire>
  ip->ref++;
80101cee:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cf2:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101cf9:	e8 12 2e 00 00       	call   80104b10 <release>
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
80101d55:	e8 b6 2e 00 00       	call   80104c10 <memmove>
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
80101de8:	e8 23 2e 00 00       	call   80104c10 <memmove>
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
80101edd:	e8 fe 2d 00 00       	call   80104ce0 <strncpy>
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
80101f1b:	68 08 78 10 80       	push   $0x80107808
80101f20:	e8 6b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f25:	83 ec 0c             	sub    $0xc,%esp
80101f28:	68 6a 7f 10 80       	push   $0x80107f6a
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
8010203b:	68 74 78 10 80       	push   $0x80107874
80102040:	e8 4b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	68 6b 78 10 80       	push   $0x8010786b
8010204d:	e8 3e e3 ff ff       	call   80100390 <panic>
80102052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102060 <ideinit>:
{
80102060:	55                   	push   %ebp
80102061:	89 e5                	mov    %esp,%ebp
80102063:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102066:	68 86 78 10 80       	push   $0x80107886
8010206b:	68 80 b5 10 80       	push   $0x8010b580
80102070:	e8 9b 28 00 00       	call   80104910 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102075:	58                   	pop    %eax
80102076:	a1 00 3d 11 80       	mov    0x80113d00,%eax
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
801020ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
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
801020e9:	68 80 b5 10 80       	push   $0x8010b580
801020ee:	e8 5d 29 00 00       	call   80104a50 <acquire>

  if((b = idequeue) == 0){
801020f3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801020f9:	83 c4 10             	add    $0x10,%esp
801020fc:	85 db                	test   %ebx,%ebx
801020fe:	74 67                	je     80102167 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102100:	8b 43 58             	mov    0x58(%ebx),%eax
80102103:	a3 64 b5 10 80       	mov    %eax,0x8010b564

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
80102151:	e8 7a 21 00 00       	call   801042d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102156:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010215b:	83 c4 10             	add    $0x10,%esp
8010215e:	85 c0                	test   %eax,%eax
80102160:	74 05                	je     80102167 <ideintr+0x87>
    idestart(idequeue);
80102162:	e8 19 fe ff ff       	call   80101f80 <idestart>
    release(&idelock);
80102167:	83 ec 0c             	sub    $0xc,%esp
8010216a:	68 80 b5 10 80       	push   $0x8010b580
8010216f:	e8 9c 29 00 00       	call   80104b10 <release>

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
8010218e:	e8 2d 27 00 00       	call   801048c0 <holdingsleep>
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
801021b3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801021b8:	85 c0                	test   %eax,%eax
801021ba:	0f 84 b1 00 00 00    	je     80102271 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021c0:	83 ec 0c             	sub    $0xc,%esp
801021c3:	68 80 b5 10 80       	push   $0x8010b580
801021c8:	e8 83 28 00 00       	call   80104a50 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021cd:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
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
801021f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
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
80102213:	68 80 b5 10 80       	push   $0x8010b580
80102218:	53                   	push   %ebx
80102219:	e8 a2 1e 00 00       	call   801040c0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010221e:	8b 03                	mov    (%ebx),%eax
80102220:	83 c4 10             	add    $0x10,%esp
80102223:	83 e0 06             	and    $0x6,%eax
80102226:	83 f8 02             	cmp    $0x2,%eax
80102229:	75 e5                	jne    80102210 <iderw+0x90>
  }


  release(&idelock);
8010222b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102232:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102235:	c9                   	leave  
  release(&idelock);
80102236:	e9 d5 28 00 00       	jmp    80104b10 <release>
8010223b:	90                   	nop
8010223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102240:	89 d8                	mov    %ebx,%eax
80102242:	e8 39 fd ff ff       	call   80101f80 <idestart>
80102247:	eb b5                	jmp    801021fe <iderw+0x7e>
80102249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102250:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102255:	eb 9d                	jmp    801021f4 <iderw+0x74>
    panic("iderw: nothing to do");
80102257:	83 ec 0c             	sub    $0xc,%esp
8010225a:	68 a0 78 10 80       	push   $0x801078a0
8010225f:	e8 2c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102264:	83 ec 0c             	sub    $0xc,%esp
80102267:	68 8a 78 10 80       	push   $0x8010788a
8010226c:	e8 1f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102271:	83 ec 0c             	sub    $0xc,%esp
80102274:	68 b5 78 10 80       	push   $0x801078b5
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
80102281:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102288:	00 c0 fe 
{
8010228b:	89 e5                	mov    %esp,%ebp
8010228d:	56                   	push   %esi
8010228e:	53                   	push   %ebx
  ioapic->reg = reg;
8010228f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102296:	00 00 00 
  return ioapic->data;
80102299:	a1 34 36 11 80       	mov    0x80113634,%eax
8010229e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801022a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801022a7:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022ad:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
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
801022c7:	68 d4 78 10 80       	push   $0x801078d4
801022cc:	e8 8f e3 ff ff       	call   80100660 <cprintf>
801022d1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
801022f2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

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
80102310:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102331:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
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
80102345:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010234b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010234e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102351:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102354:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102356:	a1 34 36 11 80       	mov    0x80113634,%eax
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
80102382:	81 fb a8 88 11 80    	cmp    $0x801188a8,%ebx
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
801023a2:	e8 b9 27 00 00       	call   80104b60 <memset>

  if(kmem.use_lock)
801023a7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	85 d2                	test   %edx,%edx
801023b2:	75 2c                	jne    801023e0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023b4:	a1 78 36 11 80       	mov    0x80113678,%eax
801023b9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023bb:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801023c0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
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
801023d0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801023d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023da:	c9                   	leave  
    release(&kmem.lock);
801023db:	e9 30 27 00 00       	jmp    80104b10 <release>
    acquire(&kmem.lock);
801023e0:	83 ec 0c             	sub    $0xc,%esp
801023e3:	68 40 36 11 80       	push   $0x80113640
801023e8:	e8 63 26 00 00       	call   80104a50 <acquire>
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	eb c2                	jmp    801023b4 <kfree+0x44>
    panic("kfree");
801023f2:	83 ec 0c             	sub    $0xc,%esp
801023f5:	68 06 79 10 80       	push   $0x80107906
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
8010245b:	68 0c 79 10 80       	push   $0x8010790c
80102460:	68 40 36 11 80       	push   $0x80113640
80102465:	e8 a6 24 00 00       	call   80104910 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010246a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102470:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
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
80102504:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
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
80102520:	a1 74 36 11 80       	mov    0x80113674,%eax
80102525:	85 c0                	test   %eax,%eax
80102527:	75 1f                	jne    80102548 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102529:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010252e:	85 c0                	test   %eax,%eax
80102530:	74 0e                	je     80102540 <kalloc+0x20>
    kmem.freelist = r->next;
80102532:	8b 10                	mov    (%eax),%edx
80102534:	89 15 78 36 11 80    	mov    %edx,0x80113678
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
8010254e:	68 40 36 11 80       	push   $0x80113640
80102553:	e8 f8 24 00 00       	call   80104a50 <acquire>
  r = kmem.freelist;
80102558:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102566:	85 c0                	test   %eax,%eax
80102568:	74 08                	je     80102572 <kalloc+0x52>
    kmem.freelist = r->next;
8010256a:	8b 08                	mov    (%eax),%ecx
8010256c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102572:	85 d2                	test   %edx,%edx
80102574:	74 16                	je     8010258c <kalloc+0x6c>
    release(&kmem.lock);
80102576:	83 ec 0c             	sub    $0xc,%esp
80102579:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010257c:	68 40 36 11 80       	push   $0x80113640
80102581:	e8 8a 25 00 00       	call   80104b10 <release>
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
801025a7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

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
801025d3:	0f b6 82 40 7a 10 80 	movzbl -0x7fef85c0(%edx),%eax
801025da:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025dc:	0f b6 82 40 79 10 80 	movzbl -0x7fef86c0(%edx),%eax
801025e3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025e5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025e7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025ed:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801025f0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025f3:	8b 04 85 20 79 10 80 	mov    -0x7fef86e0(,%eax,4),%eax
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
80102618:	0f b6 82 40 7a 10 80 	movzbl -0x7fef85c0(%edx),%eax
8010261f:	83 c8 40             	or     $0x40,%eax
80102622:	0f b6 c0             	movzbl %al,%eax
80102625:	f7 d0                	not    %eax
80102627:	21 c1                	and    %eax,%ecx
    return 0;
80102629:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010262b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
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
8010263d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
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
80102690:	a1 7c 36 11 80       	mov    0x8011367c,%eax
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
80102790:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
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
801027b0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
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
8010281e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
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
80102997:	e8 14 22 00 00       	call   80104bb0 <memcmp>
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
80102a60:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
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
80102a80:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102a85:	83 ec 08             	sub    $0x8,%esp
80102a88:	01 d8                	add    %ebx,%eax
80102a8a:	83 c0 01             	add    $0x1,%eax
80102a8d:	50                   	push   %eax
80102a8e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102a94:	e8 37 d6 ff ff       	call   801000d0 <bread>
80102a99:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a9b:	58                   	pop    %eax
80102a9c:	5a                   	pop    %edx
80102a9d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102aa4:	ff 35 c4 36 11 80    	pushl  0x801136c4
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
80102ac4:	e8 47 21 00 00       	call   80104c10 <memmove>
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
80102ae4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
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
80102b08:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102b0e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102b14:	e8 b7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b19:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
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
80102b30:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
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
80102b6a:	68 40 7b 10 80       	push   $0x80107b40
80102b6f:	68 80 36 11 80       	push   $0x80113680
80102b74:	e8 97 1d 00 00       	call   80104910 <initlock>
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
80102b8c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102b92:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102b98:	a3 b4 36 11 80       	mov    %eax,0x801136b4
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
80102bad:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102bb3:	7e 1c                	jle    80102bd1 <initlog+0x71>
80102bb5:	c1 e3 02             	shl    $0x2,%ebx
80102bb8:	31 d2                	xor    %edx,%edx
80102bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102bc0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102bc4:	83 c2 04             	add    $0x4,%edx
80102bc7:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
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
80102bdf:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
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
80102c06:	68 80 36 11 80       	push   $0x80113680
80102c0b:	e8 40 1e 00 00       	call   80104a50 <acquire>
80102c10:	83 c4 10             	add    $0x10,%esp
80102c13:	eb 18                	jmp    80102c2d <begin_op+0x2d>
80102c15:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c18:	83 ec 08             	sub    $0x8,%esp
80102c1b:	68 80 36 11 80       	push   $0x80113680
80102c20:	68 80 36 11 80       	push   $0x80113680
80102c25:	e8 96 14 00 00       	call   801040c0 <sleep>
80102c2a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c2d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102c32:	85 c0                	test   %eax,%eax
80102c34:	75 e2                	jne    80102c18 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c36:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102c3b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
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
80102c52:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102c57:	68 80 36 11 80       	push   $0x80113680
80102c5c:	e8 af 1e 00 00       	call   80104b10 <release>
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
80102c79:	68 80 36 11 80       	push   $0x80113680
80102c7e:	e8 cd 1d 00 00       	call   80104a50 <acquire>
  log.outstanding -= 1;
80102c83:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102c88:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102c8e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102c91:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102c94:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102c96:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
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
80102cad:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102cb4:	00 00 00 
  release(&log.lock);
80102cb7:	68 80 36 11 80       	push   $0x80113680
80102cbc:	e8 4f 1e 00 00       	call   80104b10 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102cc1:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102cc7:	83 c4 10             	add    $0x10,%esp
80102cca:	85 c9                	test   %ecx,%ecx
80102ccc:	0f 8e 85 00 00 00    	jle    80102d57 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cd2:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102cd7:	83 ec 08             	sub    $0x8,%esp
80102cda:	01 d8                	add    %ebx,%eax
80102cdc:	83 c0 01             	add    $0x1,%eax
80102cdf:	50                   	push   %eax
80102ce0:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ce6:	e8 e5 d3 ff ff       	call   801000d0 <bread>
80102ceb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ced:	58                   	pop    %eax
80102cee:	5a                   	pop    %edx
80102cef:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102cf6:	ff 35 c4 36 11 80    	pushl  0x801136c4
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
80102d16:	e8 f5 1e 00 00       	call   80104c10 <memmove>
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
80102d36:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102d3c:	7c 94                	jl     80102cd2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d3e:	e8 bd fd ff ff       	call   80102b00 <write_head>
    install_trans(); // Now install writes to home locations
80102d43:	e8 18 fd ff ff       	call   80102a60 <install_trans>
    log.lh.n = 0;
80102d48:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d4f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d52:	e8 a9 fd ff ff       	call   80102b00 <write_head>
    acquire(&log.lock);
80102d57:	83 ec 0c             	sub    $0xc,%esp
80102d5a:	68 80 36 11 80       	push   $0x80113680
80102d5f:	e8 ec 1c 00 00       	call   80104a50 <acquire>
    wakeup(&log);
80102d64:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102d6b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102d72:	00 00 00 
    wakeup(&log);
80102d75:	e8 56 15 00 00       	call   801042d0 <wakeup>
    release(&log.lock);
80102d7a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102d81:	e8 8a 1d 00 00       	call   80104b10 <release>
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
80102d9b:	68 80 36 11 80       	push   $0x80113680
80102da0:	e8 2b 15 00 00       	call   801042d0 <wakeup>
  release(&log.lock);
80102da5:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102dac:	e8 5f 1d 00 00       	call   80104b10 <release>
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
80102dbf:	68 44 7b 10 80       	push   $0x80107b44
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
80102dd7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102ddd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102de0:	83 fa 1d             	cmp    $0x1d,%edx
80102de3:	0f 8f 9d 00 00 00    	jg     80102e86 <log_write+0xb6>
80102de9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102dee:	83 e8 01             	sub    $0x1,%eax
80102df1:	39 c2                	cmp    %eax,%edx
80102df3:	0f 8d 8d 00 00 00    	jge    80102e86 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102df9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102dfe:	85 c0                	test   %eax,%eax
80102e00:	0f 8e 8d 00 00 00    	jle    80102e93 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e06:	83 ec 0c             	sub    $0xc,%esp
80102e09:	68 80 36 11 80       	push   $0x80113680
80102e0e:	e8 3d 1c 00 00       	call   80104a50 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e13:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e19:	83 c4 10             	add    $0x10,%esp
80102e1c:	83 f9 00             	cmp    $0x0,%ecx
80102e1f:	7e 57                	jle    80102e78 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e21:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e24:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e26:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
80102e2c:	75 0b                	jne    80102e39 <log_write+0x69>
80102e2e:	eb 38                	jmp    80102e68 <log_write+0x98>
80102e30:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
80102e37:	74 2f                	je     80102e68 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e39:	83 c0 01             	add    $0x1,%eax
80102e3c:	39 c1                	cmp    %eax,%ecx
80102e3e:	75 f0                	jne    80102e30 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e40:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e47:	83 c0 01             	add    $0x1,%eax
80102e4a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
80102e4f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e52:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102e59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e5c:	c9                   	leave  
  release(&log.lock);
80102e5d:	e9 ae 1c 00 00       	jmp    80104b10 <release>
80102e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e68:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
80102e6f:	eb de                	jmp    80102e4f <log_write+0x7f>
80102e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e78:	8b 43 08             	mov    0x8(%ebx),%eax
80102e7b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102e80:	75 cd                	jne    80102e4f <log_write+0x7f>
80102e82:	31 c0                	xor    %eax,%eax
80102e84:	eb c1                	jmp    80102e47 <log_write+0x77>
    panic("too big a transaction");
80102e86:	83 ec 0c             	sub    $0xc,%esp
80102e89:	68 53 7b 10 80       	push   $0x80107b53
80102e8e:	e8 fd d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102e93:	83 ec 0c             	sub    $0xc,%esp
80102e96:	68 69 7b 10 80       	push   $0x80107b69
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
80102ea7:	e8 54 09 00 00       	call   80103800 <cpuid>
80102eac:	89 c3                	mov    %eax,%ebx
80102eae:	e8 4d 09 00 00       	call   80103800 <cpuid>
80102eb3:	83 ec 04             	sub    $0x4,%esp
80102eb6:	53                   	push   %ebx
80102eb7:	50                   	push   %eax
80102eb8:	68 84 7b 10 80       	push   $0x80107b84
80102ebd:	e8 9e d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ec2:	e8 f9 2f 00 00       	call   80105ec0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ec7:	e8 b4 08 00 00       	call   80103780 <mycpu>
80102ecc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ece:	b8 01 00 00 00       	mov    $0x1,%eax
80102ed3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eda:	e8 f1 0d 00 00       	call   80103cd0 <scheduler>
80102edf:	90                   	nop

80102ee0 <mpenter>:
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ee6:	e8 c5 40 00 00       	call   80106fb0 <switchkvm>
  seginit();
80102eeb:	e8 30 40 00 00       	call   80106f20 <seginit>
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
80102f17:	68 a8 88 11 80       	push   $0x801188a8
80102f1c:	e8 2f f5 ff ff       	call   80102450 <kinit1>
  kvmalloc();      // kernel page table
80102f21:	e8 5a 45 00 00       	call   80107480 <kvmalloc>
  mpinit();        // detect other processors
80102f26:	e8 75 01 00 00       	call   801030a0 <mpinit>
  lapicinit();     // interrupt controller
80102f2b:	e8 60 f7 ff ff       	call   80102690 <lapicinit>
  seginit();       // segment descriptors
80102f30:	e8 eb 3f 00 00       	call   80106f20 <seginit>
  picinit();       // disable pic
80102f35:	e8 46 03 00 00       	call   80103280 <picinit>
  ioapicinit();    // another interrupt controller
80102f3a:	e8 41 f3 ff ff       	call   80102280 <ioapicinit>
  consoleinit();   // console hardware
80102f3f:	e8 7c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f44:	e8 a7 32 00 00       	call   801061f0 <uartinit>
  pinit();         // process table
80102f49:	e8 12 08 00 00       	call   80103760 <pinit>
  tvinit();        // trap vectors
80102f4e:	e8 ed 2e 00 00       	call   80105e40 <tvinit>
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
80102f6a:	68 8c b4 10 80       	push   $0x8010b48c
80102f6f:	68 00 70 00 80       	push   $0x80007000
80102f74:	e8 97 1c 00 00       	call   80104c10 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f79:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102f80:	00 00 00 
80102f83:	83 c4 10             	add    $0x10,%esp
80102f86:	05 80 37 11 80       	add    $0x80113780,%eax
80102f8b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80102f90:	76 71                	jbe    80103003 <main+0x103>
80102f92:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80102f97:	89 f6                	mov    %esi,%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102fa0:	e8 db 07 00 00       	call   80103780 <mycpu>
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
80102fbd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80102fc4:	a0 10 00 
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
80102fea:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80102ff1:	00 00 00 
80102ff4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102ffa:	05 80 37 11 80       	add    $0x80113780,%eax
80102fff:	39 c3                	cmp    %eax,%ebx
80103001:	72 9d                	jb     80102fa0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103003:	83 ec 08             	sub    $0x8,%esp
80103006:	68 00 00 00 8e       	push   $0x8e000000
8010300b:	68 00 00 40 80       	push   $0x80400000
80103010:	e8 ab f4 ff ff       	call   801024c0 <kinit2>
  userinit();      // first user process
80103015:	e8 96 09 00 00       	call   801039b0 <userinit>
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
8010304e:	68 98 7b 10 80       	push   $0x80107b98
80103053:	56                   	push   %esi
80103054:	e8 57 1b 00 00       	call   80104bb0 <memcmp>
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
8010310c:	68 b5 7b 10 80       	push   $0x80107bb5
80103111:	56                   	push   %esi
80103112:	e8 99 1a 00 00       	call   80104bb0 <memcmp>
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
80103177:	a3 7c 36 11 80       	mov    %eax,0x8011367c
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
801031a0:	ff 24 95 dc 7b 10 80 	jmp    *-0x7fef8424(,%edx,4)
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
801031e8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801031ee:	83 f9 07             	cmp    $0x7,%ecx
801031f1:	7f 19                	jg     8010320c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031f3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801031f7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801031fd:	83 c1 01             	add    $0x1,%ecx
80103200:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103206:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
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
8010321f:	88 15 60 37 11 80    	mov    %dl,0x80113760
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
80103253:	68 9d 7b 10 80       	push   $0x80107b9d
80103258:	e8 33 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010325d:	83 ec 0c             	sub    $0xc,%esp
80103260:	68 bc 7b 10 80       	push   $0x80107bbc
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
8010335b:	68 f0 7b 10 80       	push   $0x80107bf0
80103360:	50                   	push   %eax
80103361:	e8 aa 15 00 00       	call   80104910 <initlock>
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
801033bf:	e8 8c 16 00 00       	call   80104a50 <acquire>
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
801033df:	e8 ec 0e 00 00       	call   801042d0 <wakeup>
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
80103404:	e9 07 17 00 00       	jmp    80104b10 <release>
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103410:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103416:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103419:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103420:	00 00 00 
    wakeup(&p->nwrite);
80103423:	50                   	push   %eax
80103424:	e8 a7 0e 00 00       	call   801042d0 <wakeup>
80103429:	83 c4 10             	add    $0x10,%esp
8010342c:	eb b9                	jmp    801033e7 <pipeclose+0x37>
8010342e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103430:	83 ec 0c             	sub    $0xc,%esp
80103433:	53                   	push   %ebx
80103434:	e8 d7 16 00 00       	call   80104b10 <release>
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
8010345d:	e8 ee 15 00 00       	call   80104a50 <acquire>
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
801034b4:	e8 17 0e 00 00       	call   801042d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034b9:	5a                   	pop    %edx
801034ba:	59                   	pop    %ecx
801034bb:	53                   	push   %ebx
801034bc:	56                   	push   %esi
801034bd:	e8 fe 0b 00 00       	call   801040c0 <sleep>
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
801034e4:	e8 37 03 00 00       	call   80103820 <myproc>
801034e9:	8b 40 24             	mov    0x24(%eax),%eax
801034ec:	85 c0                	test   %eax,%eax
801034ee:	74 c0                	je     801034b0 <pipewrite+0x60>
        release(&p->lock);
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	53                   	push   %ebx
801034f4:	e8 17 16 00 00       	call   80104b10 <release>
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
80103543:	e8 88 0d 00 00       	call   801042d0 <wakeup>
  release(&p->lock);
80103548:	89 1c 24             	mov    %ebx,(%esp)
8010354b:	e8 c0 15 00 00       	call   80104b10 <release>
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
80103570:	e8 db 14 00 00       	call   80104a50 <acquire>
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
801035a5:	e8 16 0b 00 00       	call   801040c0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035aa:	83 c4 10             	add    $0x10,%esp
801035ad:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035b3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035b9:	75 35                	jne    801035f0 <piperead+0x90>
801035bb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035c1:	85 d2                	test   %edx,%edx
801035c3:	0f 84 8f 00 00 00    	je     80103658 <piperead+0xf8>
    if(myproc()->killed){
801035c9:	e8 52 02 00 00       	call   80103820 <myproc>
801035ce:	8b 48 24             	mov    0x24(%eax),%ecx
801035d1:	85 c9                	test   %ecx,%ecx
801035d3:	74 cb                	je     801035a0 <piperead+0x40>
      release(&p->lock);
801035d5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035d8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035dd:	56                   	push   %esi
801035de:	e8 2d 15 00 00       	call   80104b10 <release>
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
80103637:	e8 94 0c 00 00       	call   801042d0 <wakeup>
  release(&p->lock);
8010363c:	89 34 24             	mov    %esi,(%esp)
8010363f:	e8 cc 14 00 00       	call   80104b10 <release>
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

80103660 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103660:	55                   	push   %ebp
80103661:	89 c1                	mov    %eax,%ecx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103663:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
{
80103668:	89 e5                	mov    %esp,%ebp
8010366a:	57                   	push   %edi
8010366b:	56                   	push   %esi
8010366c:	53                   	push   %ebx
  ushort padding6;
};

static inline int cas(volatile int * addr, int expected, int newval) {
  int ret_val = 1;
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
8010366d:	be 06 00 00 00       	mov    $0x6,%esi
80103672:	83 ec 1c             	sub    $0x1c,%esp
80103675:	eb 17                	jmp    8010368e <wakeup1+0x2e>
80103677:	89 f6                	mov    %esi,%esi
80103679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103680:	81 c2 0c 01 00 00    	add    $0x10c,%edx
80103686:	81 fa 54 80 11 80    	cmp    $0x80118054,%edx
8010368c:	73 7a                	jae    80103708 <pass91+0x1b>
    if((p->state == SLEEPING || p->state == MINUS_SLEEPING) && p->chan == chan){
8010368e:	8b 42 0c             	mov    0xc(%edx),%eax
80103691:	8d 78 fd             	lea    -0x3(%eax),%edi
80103694:	83 ff 01             	cmp    $0x1,%edi
80103697:	77 e7                	ja     80103680 <wakeup1+0x20>
80103699:	39 4a 20             	cmp    %ecx,0x20(%edx)
8010369c:	75 e2                	jne    80103680 <wakeup1+0x20>
        while(p->state == MINUS_SLEEPING){
8010369e:	83 f8 04             	cmp    $0x4,%eax
801036a1:	75 05                	jne    801036a8 <wakeup1+0x48>
801036a3:	eb fe                	jmp    801036a3 <wakeup1+0x43>
801036a5:	8d 76 00             	lea    0x0(%esi),%esi
801036a8:	8d 5a 0c             	lea    0xc(%edx),%ebx
  int ret_val = 1;
801036ab:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801036b2:	b8 03 00 00 00       	mov    $0x3,%eax
801036b7:	f0 0f b1 33          	lock cmpxchg %esi,(%ebx)
801036bb:	74 07                	je     801036c4 <pass71>
801036bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

801036c4 <pass71>:
          //wating until process will become sleeping and then we will put it as runnable!
        }
        if(cas((int*)(&p->state), SLEEPING, MINUS_RUNNABLE)){
801036c4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801036c7:	85 ff                	test   %edi,%edi
801036c9:	74 b5                	je     80103680 <wakeup1+0x20>
          p->chan = 0; //reseting process's chan now to prevent it from running the process with not 0 chanel!
801036cb:	c7 42 20 00 00 00 00 	movl   $0x0,0x20(%edx)
  int ret_val = 1;
801036d2:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801036d9:	bf 05 00 00 00       	mov    $0x5,%edi
801036de:	89 f0                	mov    %esi,%eax
801036e0:	f0 0f b1 3b          	lock cmpxchg %edi,(%ebx)
801036e4:	74 07                	je     801036ed <pass91>
801036e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

801036ed <pass91>:
          if(!cas((int*)(&p->state), MINUS_RUNNABLE, RUNNABLE)){
801036ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801036f0:	85 c0                	test   %eax,%eax
801036f2:	75 8c                	jne    80103680 <wakeup1+0x20>
            panic("error at wakeup1, process should be minus_runnable!");
801036f4:	83 ec 0c             	sub    $0xc,%esp
801036f7:	68 f8 7b 10 80       	push   $0x80107bf8
801036fc:	e8 8f cc ff ff       	call   80100390 <panic>
80103701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          }
        }
    }
      // p->state = RUNNABLE;
}
80103708:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010370b:	5b                   	pop    %ebx
8010370c:	5e                   	pop    %esi
8010370d:	5f                   	pop    %edi
8010370e:	5d                   	pop    %ebp
8010370f:	c3                   	ret    

80103710 <forkret>:
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103716:	68 20 3d 11 80       	push   $0x80113d20
8010371b:	e8 f0 13 00 00       	call   80104b10 <release>
  if (first) {
80103720:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103725:	83 c4 10             	add    $0x10,%esp
80103728:	85 c0                	test   %eax,%eax
8010372a:	75 04                	jne    80103730 <forkret+0x20>
}
8010372c:	c9                   	leave  
8010372d:	c3                   	ret    
8010372e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103730:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103733:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010373a:	00 00 00 
    iinit(ROOTDEV);
8010373d:	6a 01                	push   $0x1
8010373f:	e8 9c dd ff ff       	call   801014e0 <iinit>
    initlog(ROOTDEV);
80103744:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010374b:	e8 10 f4 ff ff       	call   80102b60 <initlog>
80103750:	83 c4 10             	add    $0x10,%esp
}
80103753:	c9                   	leave  
80103754:	c3                   	ret    
80103755:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103760 <pinit>:
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103766:	68 2d 7d 10 80       	push   $0x80107d2d
8010376b:	68 20 3d 11 80       	push   $0x80113d20
80103770:	e8 9b 11 00 00       	call   80104910 <initlock>
}
80103775:	83 c4 10             	add    $0x10,%esp
80103778:	c9                   	leave  
80103779:	c3                   	ret    
8010377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103780 <mycpu>:
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	56                   	push   %esi
80103784:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103785:	9c                   	pushf  
80103786:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103787:	f6 c4 02             	test   $0x2,%ah
8010378a:	75 5e                	jne    801037ea <mycpu+0x6a>
  apicid = lapicid();
8010378c:	e8 ff ef ff ff       	call   80102790 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103791:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103797:	85 f6                	test   %esi,%esi
80103799:	7e 42                	jle    801037dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010379b:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
801037a2:	39 d0                	cmp    %edx,%eax
801037a4:	74 30                	je     801037d6 <mycpu+0x56>
801037a6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i) {
801037ab:	31 d2                	xor    %edx,%edx
801037ad:	8d 76 00             	lea    0x0(%esi),%esi
801037b0:	83 c2 01             	add    $0x1,%edx
801037b3:	39 f2                	cmp    %esi,%edx
801037b5:	74 26                	je     801037dd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801037b7:	0f b6 19             	movzbl (%ecx),%ebx
801037ba:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037c0:	39 c3                	cmp    %eax,%ebx
801037c2:	75 ec                	jne    801037b0 <mycpu+0x30>
801037c4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801037ca:	05 80 37 11 80       	add    $0x80113780,%eax
}
801037cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037d2:	5b                   	pop    %ebx
801037d3:	5e                   	pop    %esi
801037d4:	5d                   	pop    %ebp
801037d5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801037d6:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
801037db:	eb f2                	jmp    801037cf <mycpu+0x4f>
  panic("unknown apicid\n");
801037dd:	83 ec 0c             	sub    $0xc,%esp
801037e0:	68 34 7d 10 80       	push   $0x80107d34
801037e5:	e8 a6 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801037ea:	83 ec 0c             	sub    $0xc,%esp
801037ed:	68 2c 7c 10 80       	push   $0x80107c2c
801037f2:	e8 99 cb ff ff       	call   80100390 <panic>
801037f7:	89 f6                	mov    %esi,%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <cpuid>:
cpuid() {
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103806:	e8 75 ff ff ff       	call   80103780 <mycpu>
8010380b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103810:	c9                   	leave  
  return mycpu()-cpus;
80103811:	c1 f8 04             	sar    $0x4,%eax
80103814:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010381a:	c3                   	ret    
8010381b:	90                   	nop
8010381c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103820 <myproc>:
myproc(void) {
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
80103824:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103827:	e8 54 11 00 00       	call   80104980 <pushcli>
  c = mycpu();
8010382c:	e8 4f ff ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103831:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103837:	e8 84 11 00 00       	call   801049c0 <popcli>
}
8010383c:	83 c4 04             	add    $0x4,%esp
8010383f:	89 d8                	mov    %ebx,%eax
80103841:	5b                   	pop    %ebx
80103842:	5d                   	pop    %ebp
80103843:	c3                   	ret    
80103844:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010384a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103850 <allocpid>:
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	bb 04 b0 10 80       	mov    $0x8010b004,%ebx
80103859:	83 ec 24             	sub    $0x24,%esp
  pushcli();
8010385c:	e8 1f 11 00 00       	call   80104980 <pushcli>
80103861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pid = nextpid;
80103868:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  int ret_val = 1;
8010386d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  }while(!cas(&nextpid, pid, pid + 1));
80103874:	8d 50 01             	lea    0x1(%eax),%edx
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103877:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
8010387b:	74 07                	je     80103884 <pass385>
8010387d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

80103884 <pass385>:
80103884:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103887:	85 d2                	test   %edx,%edx
80103889:	74 dd                	je     80103868 <allocpid+0x18>
8010388b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  popcli();
8010388e:	e8 2d 11 00 00       	call   801049c0 <popcli>
}
80103893:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103896:	83 c4 24             	add    $0x24,%esp
80103899:	5b                   	pop    %ebx
8010389a:	5d                   	pop    %ebp
8010389b:	c3                   	ret    
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038a0 <allocproc>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	56                   	push   %esi
801038a4:	53                   	push   %ebx
801038a5:	83 ec 10             	sub    $0x10,%esp
  pushcli();
801038a8:	e8 d3 10 00 00       	call   80104980 <pushcli>
801038ad:	31 c0                	xor    %eax,%eax
801038af:	ba 02 00 00 00       	mov    $0x2,%edx
801038b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038b8:	be 54 3d 11 80       	mov    $0x80113d54,%esi
801038bd:	eb 0f                	jmp    801038ce <allocproc+0x2e>
801038bf:	90                   	nop
801038c0:	81 c6 0c 01 00 00    	add    $0x10c,%esi
801038c6:	81 fe 54 80 11 80    	cmp    $0x80118054,%esi
801038cc:	73 07                	jae    801038d5 <allocproc+0x35>
      if(p->state == UNUSED)
801038ce:	8b 5e 0c             	mov    0xc(%esi),%ebx
801038d1:	85 db                	test   %ebx,%ebx
801038d3:	75 eb                	jne    801038c0 <allocproc+0x20>
    if (p == &ptable.proc[NPROC]) {
801038d5:	81 fe 54 80 11 80    	cmp    $0x80118054,%esi
801038db:	0f 84 a5 00 00 00    	je     80103986 <pass476+0x8e>
  int ret_val = 1;
801038e1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  } while (!cas((int*)(&p->state), UNUSED, EMBRYO));
801038e8:	8d 5e 0c             	lea    0xc(%esi),%ebx
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801038eb:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
801038ef:	74 07                	je     801038f8 <pass476>
801038f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

801038f8 <pass476>:
801038f8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801038fb:	85 c9                	test   %ecx,%ecx
801038fd:	74 b9                	je     801038b8 <allocproc+0x18>
  popcli();
801038ff:	e8 bc 10 00 00       	call   801049c0 <popcli>
  p->pid = allocpid();
80103904:	e8 47 ff ff ff       	call   80103850 <allocpid>
80103909:	89 46 10             	mov    %eax,0x10(%esi)
  if((p->kstack = kalloc()) == 0){
8010390c:	e8 0f ec ff ff       	call   80102520 <kalloc>
80103911:	85 c0                	test   %eax,%eax
80103913:	89 46 08             	mov    %eax,0x8(%esi)
80103916:	74 7e                	je     80103996 <pass476+0x9e>
  sp -= sizeof *p->tf;
80103918:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  memset(p->context, 0, sizeof *p->context);
8010391e:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103921:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103926:	89 56 18             	mov    %edx,0x18(%esi)
  *(uint*)sp = (uint)trapret;
80103929:	c7 40 14 21 5e 10 80 	movl   $0x80105e21,0x14(%eax)
  p->context = (struct context*)sp;
80103930:	89 46 1c             	mov    %eax,0x1c(%esi)
  memset(p->context, 0, sizeof *p->context);
80103933:	6a 14                	push   $0x14
80103935:	6a 00                	push   $0x0
80103937:	50                   	push   %eax
80103938:	e8 23 12 00 00       	call   80104b60 <memset>
  p->context->eip = (uint)forkret;
8010393d:	8b 46 1c             	mov    0x1c(%esi),%eax
80103940:	8d 96 04 01 00 00    	lea    0x104(%esi),%edx
80103946:	83 c4 10             	add    $0x10,%esp
80103949:	c7 40 10 10 37 10 80 	movl   $0x80103710,0x10(%eax)
80103950:	8d 86 84 00 00 00    	lea    0x84(%esi),%eax
  p->psignals = 0;
80103956:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
  p->sigmask = 0;
8010395d:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
80103964:	00 00 00 
80103967:	89 f6                	mov    %esi,%esi
80103969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p->sig_handlers[i] = SIG_DFL;
80103970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103976:	83 c0 04             	add    $0x4,%eax
  for (int i = SIG_MIN; i <= SIG_MAX; i++) // setting all sig handlers to default
80103979:	39 d0                	cmp    %edx,%eax
8010397b:	75 f3                	jne    80103970 <pass476+0x78>
}
8010397d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103980:	89 f0                	mov    %esi,%eax
80103982:	5b                   	pop    %ebx
80103983:	5e                   	pop    %esi
80103984:	5d                   	pop    %ebp
80103985:	c3                   	ret    
      return 0; // ptable is full
80103986:	31 f6                	xor    %esi,%esi
      popcli();
80103988:	e8 33 10 00 00       	call   801049c0 <popcli>
}
8010398d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103990:	89 f0                	mov    %esi,%eax
80103992:	5b                   	pop    %ebx
80103993:	5e                   	pop    %esi
80103994:	5d                   	pop    %ebp
80103995:	c3                   	ret    
    p->state = UNUSED;
80103996:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return 0;
8010399d:	31 f6                	xor    %esi,%esi
8010399f:	eb ec                	jmp    8010398d <pass476+0x95>
801039a1:	eb 0d                	jmp    801039b0 <userinit>
801039a3:	90                   	nop
801039a4:	90                   	nop
801039a5:	90                   	nop
801039a6:	90                   	nop
801039a7:	90                   	nop
801039a8:	90                   	nop
801039a9:	90                   	nop
801039aa:	90                   	nop
801039ab:	90                   	nop
801039ac:	90                   	nop
801039ad:	90                   	nop
801039ae:	90                   	nop
801039af:	90                   	nop

801039b0 <userinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
801039b5:	83 ec 10             	sub    $0x10,%esp
  p = allocproc();
801039b8:	e8 e3 fe ff ff       	call   801038a0 <allocproc>
801039bd:	89 c6                	mov    %eax,%esi
  initproc = p;
801039bf:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801039c4:	e8 37 3a 00 00       	call   80107400 <setupkvm>
801039c9:	85 c0                	test   %eax,%eax
801039cb:	89 46 04             	mov    %eax,0x4(%esi)
801039ce:	0f 84 e5 00 00 00    	je     80103ab9 <pass665+0x29>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d4:	83 ec 04             	sub    $0x4,%esp
  if(!cas((int*)(&p->state), EMBRYO, RUNNABLE)){
801039d7:	8d 5e 0c             	lea    0xc(%esi),%ebx
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039da:	68 2c 00 00 00       	push   $0x2c
801039df:	68 60 b4 10 80       	push   $0x8010b460
801039e4:	50                   	push   %eax
801039e5:	e8 f6 36 00 00       	call   801070e0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039ea:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039ed:	c7 06 00 10 00 00    	movl   $0x1000,(%esi)
  memset(p->tf, 0, sizeof(*p->tf));
801039f3:	6a 4c                	push   $0x4c
801039f5:	6a 00                	push   $0x0
801039f7:	ff 76 18             	pushl  0x18(%esi)
801039fa:	e8 61 11 00 00       	call   80104b60 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ff:	8b 46 18             	mov    0x18(%esi),%eax
80103a02:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a07:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a0c:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a13:	8b 46 18             	mov    0x18(%esi),%eax
80103a16:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a1a:	8b 46 18             	mov    0x18(%esi),%eax
80103a1d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a21:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a25:	8b 46 18             	mov    0x18(%esi),%eax
80103a28:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a30:	8b 46 18             	mov    0x18(%esi),%eax
80103a33:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a3a:	8b 46 18             	mov    0x18(%esi),%eax
80103a3d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a44:	8b 46 18             	mov    0x18(%esi),%eax
80103a47:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4e:	8d 46 6c             	lea    0x6c(%esi),%eax
80103a51:	6a 10                	push   $0x10
80103a53:	68 5d 7d 10 80       	push   $0x80107d5d
80103a58:	50                   	push   %eax
80103a59:	e8 e2 12 00 00       	call   80104d40 <safestrcpy>
  p->cwd = namei("/");
80103a5e:	c7 04 24 66 7d 10 80 	movl   $0x80107d66,(%esp)
80103a65:	e8 d6 e4 ff ff       	call   80101f40 <namei>
80103a6a:	89 46 68             	mov    %eax,0x68(%esi)
  pushcli();
80103a6d:	e8 0e 0f 00 00       	call   80104980 <pushcli>
  int ret_val = 1;
80103a72:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103a79:	b8 02 00 00 00       	mov    $0x2,%eax
80103a7e:	ba 05 00 00 00       	mov    $0x5,%edx
80103a83:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103a87:	74 07                	je     80103a90 <pass665>
80103a89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

80103a90 <pass665>:
  if(!cas((int*)(&p->state), EMBRYO, RUNNABLE)){
80103a90:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80103a93:	83 c4 10             	add    $0x10,%esp
80103a96:	85 db                	test   %ebx,%ebx
80103a98:	74 2c                	je     80103ac6 <pass665+0x36>
  cprintf("should br runnable %d", p->state);
80103a9a:	83 ec 08             	sub    $0x8,%esp
80103a9d:	ff 76 0c             	pushl  0xc(%esi)
80103aa0:	68 68 7d 10 80       	push   $0x80107d68
80103aa5:	e8 b6 cb ff ff       	call   80100660 <cprintf>
  popcli();
80103aaa:	e8 11 0f 00 00       	call   801049c0 <popcli>
}
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ab5:	5b                   	pop    %ebx
80103ab6:	5e                   	pop    %esi
80103ab7:	5d                   	pop    %ebp
80103ab8:	c3                   	ret    
    panic("userinit: out of memory?");
80103ab9:	83 ec 0c             	sub    $0xc,%esp
80103abc:	68 44 7d 10 80       	push   $0x80107d44
80103ac1:	e8 ca c8 ff ff       	call   80100390 <panic>
     panic("err in userinit: np state not embryo");
80103ac6:	83 ec 0c             	sub    $0xc,%esp
80103ac9:	68 54 7c 10 80       	push   $0x80107c54
80103ace:	e8 bd c8 ff ff       	call   80100390 <panic>
80103ad3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ae0 <growproc>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
80103ae5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ae8:	e8 93 0e 00 00       	call   80104980 <pushcli>
  c = mycpu();
80103aed:	e8 8e fc ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103af2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103af8:	e8 c3 0e 00 00       	call   801049c0 <popcli>
  if(n > 0){
80103afd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103b00:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b02:	7f 1c                	jg     80103b20 <growproc+0x40>
  } else if(n < 0){
80103b04:	75 3a                	jne    80103b40 <growproc+0x60>
  switchuvm(curproc);
80103b06:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b09:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b0b:	53                   	push   %ebx
80103b0c:	e8 bf 34 00 00       	call   80106fd0 <switchuvm>
  return 0;
80103b11:	83 c4 10             	add    $0x10,%esp
80103b14:	31 c0                	xor    %eax,%eax
}
80103b16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b19:	5b                   	pop    %ebx
80103b1a:	5e                   	pop    %esi
80103b1b:	5d                   	pop    %ebp
80103b1c:	c3                   	ret    
80103b1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b20:	83 ec 04             	sub    $0x4,%esp
80103b23:	01 c6                	add    %eax,%esi
80103b25:	56                   	push   %esi
80103b26:	50                   	push   %eax
80103b27:	ff 73 04             	pushl  0x4(%ebx)
80103b2a:	e8 f1 36 00 00       	call   80107220 <allocuvm>
80103b2f:	83 c4 10             	add    $0x10,%esp
80103b32:	85 c0                	test   %eax,%eax
80103b34:	75 d0                	jne    80103b06 <growproc+0x26>
      return -1;
80103b36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b3b:	eb d9                	jmp    80103b16 <growproc+0x36>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b40:	83 ec 04             	sub    $0x4,%esp
80103b43:	01 c6                	add    %eax,%esi
80103b45:	56                   	push   %esi
80103b46:	50                   	push   %eax
80103b47:	ff 73 04             	pushl  0x4(%ebx)
80103b4a:	e8 01 38 00 00       	call   80107350 <deallocuvm>
80103b4f:	83 c4 10             	add    $0x10,%esp
80103b52:	85 c0                	test   %eax,%eax
80103b54:	75 b0                	jne    80103b06 <growproc+0x26>
80103b56:	eb de                	jmp    80103b36 <growproc+0x56>
80103b58:	90                   	nop
80103b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b60 <fork>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	57                   	push   %edi
80103b64:	56                   	push   %esi
80103b65:	53                   	push   %ebx
80103b66:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
80103b69:	e8 12 0e 00 00       	call   80104980 <pushcli>
  c = mycpu();
80103b6e:	e8 0d fc ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103b73:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b79:	e8 42 0e 00 00       	call   801049c0 <popcli>
  if((np = allocproc()) == 0){
80103b7e:	e8 1d fd ff ff       	call   801038a0 <allocproc>
80103b83:	85 c0                	test   %eax,%eax
80103b85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103b88:	0f 84 fa 00 00 00    	je     80103c88 <pass967+0x19>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b8e:	83 ec 08             	sub    $0x8,%esp
80103b91:	ff 33                	pushl  (%ebx)
80103b93:	ff 73 04             	pushl  0x4(%ebx)
80103b96:	89 c7                	mov    %eax,%edi
80103b98:	e8 33 39 00 00       	call   801074d0 <copyuvm>
80103b9d:	83 c4 10             	add    $0x10,%esp
80103ba0:	85 c0                	test   %eax,%eax
80103ba2:	89 47 04             	mov    %eax,0x4(%edi)
80103ba5:	0f 84 e4 00 00 00    	je     80103c8f <pass967+0x20>
  np->sz = curproc->sz;
80103bab:	8b 03                	mov    (%ebx),%eax
80103bad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  *np->tf = *curproc->tf;
80103bb0:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103bb5:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103bb7:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103bba:	8b 7a 18             	mov    0x18(%edx),%edi
80103bbd:	8b 73 18             	mov    0x18(%ebx),%esi
80103bc0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  copySigHandlers((void**)&np->sig_handlers, (void**)&curproc->sig_handlers);
80103bc2:	8d b3 84 00 00 00    	lea    0x84(%ebx),%esi
80103bc8:	8d 8a 84 00 00 00    	lea    0x84(%edx),%ecx
  np->sigmask = curproc->sigmask;
80103bce:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103bd4:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
}

void 
copySigHandlers(void** new_sighandlers, void** old_sighandlers) {
  int i;
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80103bda:	31 c0                	xor    %eax,%eax
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    new_sighandlers[i] = old_sighandlers[i];
80103be0:	8b 14 86             	mov    (%esi,%eax,4),%edx
80103be3:	89 14 81             	mov    %edx,(%ecx,%eax,4)
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80103be6:	83 c0 01             	add    $0x1,%eax
80103be9:	83 f8 20             	cmp    $0x20,%eax
80103bec:	75 f2                	jne    80103be0 <fork+0x80>
  np->tf->eax = 0;
80103bee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  for(i = 0; i < NOFILE; i++)
80103bf1:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103bf3:	8b 40 18             	mov    0x18(%eax),%eax
80103bf6:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103bfd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103c00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c04:	85 c0                	test   %eax,%eax
80103c06:	74 13                	je     80103c1b <fork+0xbb>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c08:	83 ec 0c             	sub    $0xc,%esp
80103c0b:	50                   	push   %eax
80103c0c:	e8 3f d2 ff ff       	call   80100e50 <filedup>
80103c11:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80103c14:	83 c4 10             	add    $0x10,%esp
80103c17:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c1b:	83 c6 01             	add    $0x1,%esi
80103c1e:	83 fe 10             	cmp    $0x10,%esi
80103c21:	75 dd                	jne    80103c00 <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103c23:	83 ec 0c             	sub    $0xc,%esp
80103c26:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c29:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c2c:	e8 7f da ff ff       	call   801016b0 <idup>
80103c31:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c34:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c37:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c3a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c3d:	6a 10                	push   $0x10
80103c3f:	53                   	push   %ebx
  if(!cas((int*)(&np->state), EMBRYO, RUNNABLE))
80103c40:	8d 5f 0c             	lea    0xc(%edi),%ebx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c43:	50                   	push   %eax
80103c44:	e8 f7 10 00 00       	call   80104d40 <safestrcpy>
  pid = np->pid;
80103c49:	8b 77 10             	mov    0x10(%edi),%esi
  pushcli();
80103c4c:	e8 2f 0d 00 00       	call   80104980 <pushcli>
  int ret_val = 1;
80103c51:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103c58:	b8 02 00 00 00       	mov    $0x2,%eax
80103c5d:	ba 05 00 00 00       	mov    $0x5,%edx
80103c62:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103c66:	74 07                	je     80103c6f <pass967>
80103c68:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103c6f <pass967>:
  if(!cas((int*)(&np->state), EMBRYO, RUNNABLE))
80103c6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103c72:	83 c4 10             	add    $0x10,%esp
80103c75:	85 c0                	test   %eax,%eax
80103c77:	74 3c                	je     80103cb5 <pass967+0x46>
  popcli();
80103c79:	e8 42 0d 00 00       	call   801049c0 <popcli>
}
80103c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c81:	89 f0                	mov    %esi,%eax
80103c83:	5b                   	pop    %ebx
80103c84:	5e                   	pop    %esi
80103c85:	5f                   	pop    %edi
80103c86:	5d                   	pop    %ebp
80103c87:	c3                   	ret    
    return -1;
80103c88:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103c8d:	eb ef                	jmp    80103c7e <pass967+0xf>
    kfree(np->kstack);
80103c8f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80103c92:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103c95:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103c9a:	ff 73 08             	pushl  0x8(%ebx)
80103c9d:	e8 ce e6 ff ff       	call   80102370 <kfree>
    np->kstack = 0;
80103ca2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103ca9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cb0:	83 c4 10             	add    $0x10,%esp
80103cb3:	eb c9                	jmp    80103c7e <pass967+0xf>
    panic("err in fork: np state npt embryo");
80103cb5:	83 ec 0c             	sub    $0xc,%esp
80103cb8:	68 7c 7c 10 80       	push   $0x80107c7c
80103cbd:	e8 ce c6 ff ff       	call   80100390 <panic>
80103cc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cd0 <scheduler>:
{
80103cd0:	55                   	push   %ebp
80103cd1:	89 e5                	mov    %esp,%ebp
80103cd3:	57                   	push   %edi
80103cd4:	56                   	push   %esi
80103cd5:	53                   	push   %ebx
80103cd6:	83 ec 2c             	sub    $0x2c,%esp
  struct cpu *c = mycpu();
80103cd9:	e8 a2 fa ff ff       	call   80103780 <mycpu>
  c->proc = 0;
80103cde:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ce5:	00 00 00 
  struct cpu *c = mycpu();
80103ce8:	89 c7                	mov    %eax,%edi
80103cea:	8d 40 04             	lea    0x4(%eax),%eax
80103ced:	89 45 d0             	mov    %eax,-0x30(%ebp)
  asm volatile("sti");
80103cf0:	fb                   	sti    
    acquire(&ptable.lock);
80103cf1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cf4:	be 54 3d 11 80       	mov    $0x80113d54,%esi
    acquire(&ptable.lock);
80103cf9:	68 20 3d 11 80       	push   $0x80113d20
80103cfe:	e8 4d 0d 00 00       	call   80104a50 <acquire>
80103d03:	83 c4 10             	add    $0x10,%esp
80103d06:	eb 24                	jmp    80103d2c <scheduler+0x5c>
80103d08:	90                   	nop
80103d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      c->proc = 0;
80103d10:	c7 87 ac 00 00 00 00 	movl   $0x0,0xac(%edi)
80103d17:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d1a:	81 c6 0c 01 00 00    	add    $0x10c,%esi
80103d20:	81 fe 54 80 11 80    	cmp    $0x80118054,%esi
80103d26:	0f 83 4c 01 00 00    	jae    80103e78 <pass1213+0x3d>
80103d2c:	8d 56 0c             	lea    0xc(%esi),%edx
  int ret_val = 1;
80103d2f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103d36:	b8 05 00 00 00       	mov    $0x5,%eax
80103d3b:	b9 07 00 00 00       	mov    $0x7,%ecx
80103d40:	89 d3                	mov    %edx,%ebx
80103d42:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103d46:	74 07                	je     80103d4f <pass1104>
80103d48:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103d4f <pass1104>:
      if(!cas((int*)(&p->state), RUNNABLE, RUNNING)){
80103d4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103d52:	85 c0                	test   %eax,%eax
80103d54:	74 c4                	je     80103d1a <scheduler+0x4a>
      if(p->frozen) 
80103d56:	8b 86 08 01 00 00    	mov    0x108(%esi),%eax
80103d5c:	85 c0                	test   %eax,%eax
80103d5e:	74 20                	je     80103d80 <pass1104+0x31>
        if(p->psignals & (1 << SIGCONT)) // received cont
80103d60:	8b 46 7c             	mov    0x7c(%esi),%eax
80103d63:	a9 00 00 08 00       	test   $0x80000,%eax
80103d68:	0f 84 ea 00 00 00    	je     80103e58 <pass1213+0x1d>
          p->psignals ^= 1 << SIGCONT;
80103d6e:	35 00 00 08 00       	xor    $0x80000,%eax
          p->frozen = 0;
80103d73:	c7 86 08 01 00 00 00 	movl   $0x0,0x108(%esi)
80103d7a:	00 00 00 
          p->psignals ^= 1 << SIGCONT;
80103d7d:	89 46 7c             	mov    %eax,0x7c(%esi)
      switchuvm(p);
80103d80:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d83:	89 b7 ac 00 00 00    	mov    %esi,0xac(%edi)
80103d89:	89 55 d4             	mov    %edx,-0x2c(%ebp)
      switchuvm(p);
80103d8c:	56                   	push   %esi
80103d8d:	e8 3e 32 00 00       	call   80106fd0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d92:	5b                   	pop    %ebx
80103d93:	58                   	pop    %eax
80103d94:	ff 76 1c             	pushl  0x1c(%esi)
80103d97:	ff 75 d0             	pushl  -0x30(%ebp)
80103d9a:	e8 fc 0f 00 00       	call   80104d9b <swtch>
      switchkvm();
80103d9f:	e8 0c 32 00 00       	call   80106fb0 <switchkvm>
80103da4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  int ret_val = 1;
80103da7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103dae:	b8 04 00 00 00       	mov    $0x4,%eax
80103db3:	b9 03 00 00 00       	mov    $0x3,%ecx
80103db8:	89 d3                	mov    %edx,%ebx
80103dba:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103dbe:	74 07                	je     80103dc7 <pass1154>
80103dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103dc7 <pass1154>:
      if (cas((int*)(&p->state), MINUS_SLEEPING, SLEEPING)) {
80103dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103dca:	83 c4 10             	add    $0x10,%esp
80103dcd:	85 c0                	test   %eax,%eax
80103dcf:	74 2c                	je     80103dfd <pass1176+0xe>
  int ret_val = 1;
80103dd1:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103dd8:	8d 5e 24             	lea    0x24(%esi),%ebx
80103ddb:	b8 01 00 00 00       	mov    $0x1,%eax
80103de0:	31 c9                	xor    %ecx,%ecx
80103de2:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103de6:	74 07                	je     80103def <pass1176>
80103de8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103def <pass1176>:
        if (cas((int*)(&p->killed), 1, 0))
80103def:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103df2:	85 c9                	test   %ecx,%ecx
80103df4:	74 07                	je     80103dfd <pass1176+0xe>
          p->state = RUNNABLE;
80103df6:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  int ret_val = 1;
80103dfd:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103e04:	b8 06 00 00 00       	mov    $0x6,%eax
80103e09:	89 d3                	mov    %edx,%ebx
80103e0b:	b9 05 00 00 00       	mov    $0x5,%ecx
80103e10:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103e14:	74 07                	je     80103e1d <pass1199>
80103e16:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103e1d <pass1199>:
80103e1d:	b8 09 00 00 00       	mov    $0x9,%eax
  int ret_val = 1;
80103e22:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103e29:	b9 08 00 00 00       	mov    $0x8,%ecx
80103e2e:	f0 0f b1 0b          	lock cmpxchg %ecx,(%ebx)
80103e32:	74 07                	je     80103e3b <pass1213>
80103e34:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80103e3b <pass1213>:
      if (cas((int*)(&p->state), MINUS_ZOMBIE, ZOMBIE))
80103e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e3e:	85 c0                	test   %eax,%eax
80103e40:	0f 84 ca fe ff ff    	je     80103d10 <scheduler+0x40>
          wakeup1(p->parent);
80103e46:	8b 46 14             	mov    0x14(%esi),%eax
80103e49:	e8 12 f8 ff ff       	call   80103660 <wakeup1>
80103e4e:	e9 bd fe ff ff       	jmp    80103d10 <scheduler+0x40>
80103e53:	90                   	nop
80103e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          p->state = RUNNABLE;
80103e58:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e5f:	81 c6 0c 01 00 00    	add    $0x10c,%esi
80103e65:	81 fe 54 80 11 80    	cmp    $0x80118054,%esi
80103e6b:	0f 82 bb fe ff ff    	jb     80103d2c <scheduler+0x5c>
80103e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&ptable.lock);
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	68 20 3d 11 80       	push   $0x80113d20
80103e80:	e8 8b 0c 00 00       	call   80104b10 <release>
    sti();
80103e85:	83 c4 10             	add    $0x10,%esp
80103e88:	e9 63 fe ff ff       	jmp    80103cf0 <scheduler+0x20>
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi

80103e90 <sched>:
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
80103e93:	56                   	push   %esi
80103e94:	53                   	push   %ebx
  pushcli();
80103e95:	e8 e6 0a 00 00       	call   80104980 <pushcli>
  c = mycpu();
80103e9a:	e8 e1 f8 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103e9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ea5:	e8 16 0b 00 00       	call   801049c0 <popcli>
  if(mycpu()->ncli != 1)
80103eaa:	e8 d1 f8 ff ff       	call   80103780 <mycpu>
80103eaf:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eb6:	75 41                	jne    80103ef9 <sched+0x69>
  if(p->state == RUNNING)
80103eb8:	83 7b 0c 07          	cmpl   $0x7,0xc(%ebx)
80103ebc:	74 55                	je     80103f13 <sched+0x83>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ebe:	9c                   	pushf  
80103ebf:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ec0:	f6 c4 02             	test   $0x2,%ah
80103ec3:	75 41                	jne    80103f06 <sched+0x76>
  intena = mycpu()->intena;
80103ec5:	e8 b6 f8 ff ff       	call   80103780 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103eca:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ecd:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ed3:	e8 a8 f8 ff ff       	call   80103780 <mycpu>
80103ed8:	83 ec 08             	sub    $0x8,%esp
80103edb:	ff 70 04             	pushl  0x4(%eax)
80103ede:	53                   	push   %ebx
80103edf:	e8 b7 0e 00 00       	call   80104d9b <swtch>
  mycpu()->intena = intena;
80103ee4:	e8 97 f8 ff ff       	call   80103780 <mycpu>
}
80103ee9:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103eec:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ef2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ef5:	5b                   	pop    %ebx
80103ef6:	5e                   	pop    %esi
80103ef7:	5d                   	pop    %ebp
80103ef8:	c3                   	ret    
    panic("sched locks");
80103ef9:	83 ec 0c             	sub    $0xc,%esp
80103efc:	68 7e 7d 10 80       	push   $0x80107d7e
80103f01:	e8 8a c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f06:	83 ec 0c             	sub    $0xc,%esp
80103f09:	68 98 7d 10 80       	push   $0x80107d98
80103f0e:	e8 7d c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f13:	83 ec 0c             	sub    $0xc,%esp
80103f16:	68 8a 7d 10 80       	push   $0x80107d8a
80103f1b:	e8 70 c4 ff ff       	call   80100390 <panic>

80103f20 <exit>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103f29:	e8 52 0a 00 00       	call   80104980 <pushcli>
  c = mycpu();
80103f2e:	e8 4d f8 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80103f33:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f39:	e8 82 0a 00 00       	call   801049c0 <popcli>
  if(curproc == initproc)
80103f3e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103f44:	8d 5e 28             	lea    0x28(%esi),%ebx
80103f47:	8d 7e 68             	lea    0x68(%esi),%edi
80103f4a:	0f 84 d7 00 00 00    	je     80104027 <pass1467+0x26>
    if(curproc->ofile[fd]){
80103f50:	8b 03                	mov    (%ebx),%eax
80103f52:	85 c0                	test   %eax,%eax
80103f54:	74 12                	je     80103f68 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103f56:	83 ec 0c             	sub    $0xc,%esp
80103f59:	50                   	push   %eax
80103f5a:	e8 41 cf ff ff       	call   80100ea0 <fileclose>
      curproc->ofile[fd] = 0;
80103f5f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103f65:	83 c4 10             	add    $0x10,%esp
80103f68:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103f6b:	39 df                	cmp    %ebx,%edi
80103f6d:	75 e1                	jne    80103f50 <exit+0x30>
  begin_op();
80103f6f:	e8 8c ec ff ff       	call   80102c00 <begin_op>
  iput(curproc->cwd);
80103f74:	83 ec 0c             	sub    $0xc,%esp
80103f77:	ff 76 68             	pushl  0x68(%esi)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7a:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  iput(curproc->cwd);
80103f7f:	e8 8c d8 ff ff       	call   80101810 <iput>
  end_op();
80103f84:	e8 e7 ec ff ff       	call   80102c70 <end_op>
  curproc->cwd = 0;
80103f89:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f90:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f97:	e8 b4 0a 00 00       	call   80104a50 <acquire>
80103f9c:	83 c4 10             	add    $0x10,%esp
80103f9f:	eb 15                	jmp    80103fb6 <exit+0x96>
80103fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa8:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
80103fae:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
80103fb4:	73 2a                	jae    80103fe0 <exit+0xc0>
    if(p->parent == curproc){
80103fb6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fb9:	75 ed                	jne    80103fa8 <exit+0x88>
      if(p->state == ZOMBIE)
80103fbb:	83 7b 0c 08          	cmpl   $0x8,0xc(%ebx)
      p->parent = initproc;
80103fbf:	a1 b8 b5 10 80       	mov    0x8010b5b8,%eax
80103fc4:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103fc7:	75 df                	jne    80103fa8 <exit+0x88>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc9:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
        wakeup1(initproc);
80103fcf:	e8 8c f6 ff ff       	call   80103660 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd4:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
80103fda:	72 da                	jb     80103fb6 <exit+0x96>
80103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int ret_val = 1;
80103fe0:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  if(!cas((int*)(&curproc->state), RUNNING, MINUS_ZOMBIE))
80103fe7:	8d 5e 0c             	lea    0xc(%esi),%ebx
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
80103fea:	b8 07 00 00 00       	mov    $0x7,%eax
80103fef:	ba 09 00 00 00       	mov    $0x9,%edx
80103ff4:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80103ff8:	74 07                	je     80104001 <pass1467>
80103ffa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

80104001 <pass1467>:
80104001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104004:	85 c0                	test   %eax,%eax
80104006:	75 0d                	jne    80104015 <pass1467+0x14>
      panic("process should be at running state!");
80104008:	83 ec 0c             	sub    $0xc,%esp
8010400b:	68 a0 7c 10 80       	push   $0x80107ca0
80104010:	e8 7b c3 ff ff       	call   80100390 <panic>
  sched();
80104015:	e8 76 fe ff ff       	call   80103e90 <sched>
  panic("zombie exit");
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 b9 7d 10 80       	push   $0x80107db9
80104022:	e8 69 c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104027:	83 ec 0c             	sub    $0xc,%esp
8010402a:	68 ac 7d 10 80       	push   $0x80107dac
8010402f:	e8 5c c3 ff ff       	call   80100390 <panic>
80104034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010403a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104040 <yield>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 20             	sub    $0x20,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104047:	68 20 3d 11 80       	push   $0x80113d20
8010404c:	e8 ff 09 00 00       	call   80104a50 <acquire>
  pushcli();
80104051:	e8 2a 09 00 00       	call   80104980 <pushcli>
  c = mycpu();
80104056:	e8 25 f7 ff ff       	call   80103780 <mycpu>
  p = c->proc;
8010405b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104061:	e8 5a 09 00 00       	call   801049c0 <popcli>
  int ret_val = 1;
80104066:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
8010406d:	b8 07 00 00 00       	mov    $0x7,%eax
80104072:	ba 06 00 00 00       	mov    $0x6,%edx
  if(!cas((int*)(&myproc()->state), RUNNING, MINUS_RUNNABLE)){
80104077:	83 c3 0c             	add    $0xc,%ebx
8010407a:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
8010407e:	74 07                	je     80104087 <pass1547>
80104080:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

80104087 <pass1547>:
80104087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010408a:	83 c4 10             	add    $0x10,%esp
8010408d:	85 c0                	test   %eax,%eax
8010408f:	74 1a                	je     801040ab <pass1547+0x24>
  sched();
80104091:	e8 fa fd ff ff       	call   80103e90 <sched>
  release(&ptable.lock);
80104096:	83 ec 0c             	sub    $0xc,%esp
80104099:	68 20 3d 11 80       	push   $0x80113d20
8010409e:	e8 6d 0a 00 00       	call   80104b10 <release>
}
801040a3:	83 c4 10             	add    $0x10,%esp
801040a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040a9:	c9                   	leave  
801040aa:	c3                   	ret    
    panic("cas failed at yiled, process state should be running!");
801040ab:	83 ec 0c             	sub    $0xc,%esp
801040ae:	68 c4 7c 10 80       	push   $0x80107cc4
801040b3:	e8 d8 c2 ff ff       	call   80100390 <panic>
801040b8:	90                   	nop
801040b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040c0 <sleep>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
801040c5:	83 ec 10             	sub    $0x10,%esp
801040c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040cb:	e8 b0 08 00 00       	call   80104980 <pushcli>
  c = mycpu();
801040d0:	e8 ab f6 ff ff       	call   80103780 <mycpu>
  p = c->proc;
801040d5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040db:	e8 e0 08 00 00       	call   801049c0 <popcli>
  if(p == 0)
801040e0:	85 db                	test   %ebx,%ebx
801040e2:	0f 84 82 00 00 00    	je     8010416a <pass1654+0x33>
  if(lk == 0)
801040e8:	85 f6                	test   %esi,%esi
801040ea:	0f 84 94 00 00 00    	je     80104184 <pass1654+0x4d>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801040f0:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
801040f6:	74 18                	je     80104110 <sleep+0x50>
    acquire(&ptable.lock);  //DOC: sleeplock1
801040f8:	83 ec 0c             	sub    $0xc,%esp
801040fb:	68 20 3d 11 80       	push   $0x80113d20
80104100:	e8 4b 09 00 00       	call   80104a50 <acquire>
    release(lk);
80104105:	89 34 24             	mov    %esi,(%esp)
80104108:	e8 03 0a 00 00       	call   80104b10 <release>
8010410d:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80104110:	8b 45 08             	mov    0x8(%ebp),%eax
  int ret_val = 1;
80104113:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  if(!cas((int*)(&p->state), RUNNING, MINUS_SLEEPING))
8010411a:	83 c3 0c             	add    $0xc,%ebx
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
8010411d:	ba 04 00 00 00       	mov    $0x4,%edx
  p->chan = chan;
80104122:	89 43 14             	mov    %eax,0x14(%ebx)
80104125:	b8 07 00 00 00       	mov    $0x7,%eax
8010412a:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
8010412e:	74 07                	je     80104137 <pass1654>
80104130:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

80104137 <pass1654>:
  if(!cas((int*)(&p->state), RUNNING, MINUS_SLEEPING))
80104137:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413a:	85 c0                	test   %eax,%eax
8010413c:	74 39                	je     80104177 <pass1654+0x40>
  sched();
8010413e:	e8 4d fd ff ff       	call   80103e90 <sched>
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104143:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104149:	74 18                	je     80104163 <pass1654+0x2c>
    release(&ptable.lock);
8010414b:	83 ec 0c             	sub    $0xc,%esp
8010414e:	68 20 3d 11 80       	push   $0x80113d20
80104153:	e8 b8 09 00 00       	call   80104b10 <release>
    acquire(lk);
80104158:	89 34 24             	mov    %esi,(%esp)
8010415b:	e8 f0 08 00 00       	call   80104a50 <acquire>
80104160:	83 c4 10             	add    $0x10,%esp
}
80104163:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104166:	5b                   	pop    %ebx
80104167:	5e                   	pop    %esi
80104168:	5d                   	pop    %ebp
80104169:	c3                   	ret    
    panic("sleep");
8010416a:	83 ec 0c             	sub    $0xc,%esp
8010416d:	68 c5 7d 10 80       	push   $0x80107dc5
80104172:	e8 19 c2 ff ff       	call   80100390 <panic>
    panic("cas failed at sleeping, should be running state!");
80104177:	83 ec 0c             	sub    $0xc,%esp
8010417a:	68 fc 7c 10 80       	push   $0x80107cfc
8010417f:	e8 0c c2 ff ff       	call   80100390 <panic>
    panic("sleep without lk");
80104184:	83 ec 0c             	sub    $0xc,%esp
80104187:	68 cb 7d 10 80       	push   $0x80107dcb
8010418c:	e8 ff c1 ff ff       	call   80100390 <panic>
80104191:	eb 0d                	jmp    801041a0 <wait>
80104193:	90                   	nop
80104194:	90                   	nop
80104195:	90                   	nop
80104196:	90                   	nop
80104197:	90                   	nop
80104198:	90                   	nop
80104199:	90                   	nop
8010419a:	90                   	nop
8010419b:	90                   	nop
8010419c:	90                   	nop
8010419d:	90                   	nop
8010419e:	90                   	nop
8010419f:	90                   	nop

801041a0 <wait>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
801041a9:	e8 d2 07 00 00       	call   80104980 <pushcli>
  c = mycpu();
801041ae:	e8 cd f5 ff ff       	call   80103780 <mycpu>
  p = c->proc;
801041b3:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801041b9:	e8 02 08 00 00       	call   801049c0 <popcli>
  acquire(&ptable.lock);
801041be:	83 ec 0c             	sub    $0xc,%esp
801041c1:	68 20 3d 11 80       	push   $0x80113d20
801041c6:	e8 85 08 00 00       	call   80104a50 <acquire>
801041cb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041ce:	31 d2                	xor    %edx,%edx
801041d0:	31 c9                	xor    %ecx,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d2:	be 54 3d 11 80       	mov    $0x80113d54,%esi
801041d7:	b8 08 00 00 00       	mov    $0x8,%eax
801041dc:	eb 10                	jmp    801041ee <wait+0x4e>
801041de:	66 90                	xchg   %ax,%ax
801041e0:	81 c6 0c 01 00 00    	add    $0x10c,%esi
801041e6:	81 fe 54 80 11 80    	cmp    $0x80118054,%esi
801041ec:	73 36                	jae    80104224 <pass1804+0x1a>
      if(p->parent != curproc)
801041ee:	39 7e 14             	cmp    %edi,0x14(%esi)
801041f1:	75 ed                	jne    801041e0 <wait+0x40>
  int ret_val = 1;
801041f3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  asm volatile("lock; cmpxchgl %3, (%2)\n\t"
801041fa:	8d 5e 0c             	lea    0xc(%esi),%ebx
801041fd:	f0 0f b1 13          	lock cmpxchg %edx,(%ebx)
80104201:	74 07                	je     8010420a <pass1804>
80104203:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

8010420a <pass1804>:
      if(cas((int*)(&p->state), ZOMBIE, UNUSED)){
8010420a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010420d:	85 db                	test   %ebx,%ebx
8010420f:	75 3f                	jne    80104250 <pass1804+0x46>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104211:	81 c6 0c 01 00 00    	add    $0x10c,%esi
      havekids = 1;
80104217:	b9 01 00 00 00       	mov    $0x1,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010421c:	81 fe 54 80 11 80    	cmp    $0x80118054,%esi
80104222:	72 ca                	jb     801041ee <wait+0x4e>
    if(!havekids || curproc->killed){
80104224:	85 c9                	test   %ecx,%ecx
80104226:	0f 84 7f 00 00 00    	je     801042ab <pass1804+0xa1>
8010422c:	8b 47 24             	mov    0x24(%edi),%eax
8010422f:	85 c0                	test   %eax,%eax
80104231:	75 78                	jne    801042ab <pass1804+0xa1>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104233:	83 ec 08             	sub    $0x8,%esp
80104236:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104239:	68 20 3d 11 80       	push   $0x80113d20
8010423e:	57                   	push   %edi
8010423f:	e8 7c fe ff ff       	call   801040c0 <sleep>
    havekids = 0;
80104244:	83 c4 10             	add    $0x10,%esp
80104247:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010424a:	eb 84                	jmp    801041d0 <wait+0x30>
8010424c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("found zombie!");
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	68 dc 7d 10 80       	push   $0x80107ddc
80104258:	e8 03 c4 ff ff       	call   80100660 <cprintf>
        kfree(p->kstack);
8010425d:	5a                   	pop    %edx
8010425e:	ff 76 08             	pushl  0x8(%esi)
        pid = p->pid;
80104261:	8b 5e 10             	mov    0x10(%esi),%ebx
        kfree(p->kstack);
80104264:	e8 07 e1 ff ff       	call   80102370 <kfree>
        freevm(p->pgdir);
80104269:	59                   	pop    %ecx
8010426a:	ff 76 04             	pushl  0x4(%esi)
        p->kstack = 0;
8010426d:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
        freevm(p->pgdir);
80104274:	e8 07 31 00 00       	call   80107380 <freevm>
        release(&ptable.lock);
80104279:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
80104280:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
        p->parent = 0;
80104287:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
        p->name[0] = 0;
8010428e:	c6 46 6c 00          	movb   $0x0,0x6c(%esi)
        p->killed = 0;
80104292:	c7 46 24 00 00 00 00 	movl   $0x0,0x24(%esi)
        release(&ptable.lock);
80104299:	e8 72 08 00 00       	call   80104b10 <release>
        return pid;
8010429e:	83 c4 10             	add    $0x10,%esp
}
801042a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042a4:	89 d8                	mov    %ebx,%eax
801042a6:	5b                   	pop    %ebx
801042a7:	5e                   	pop    %esi
801042a8:	5f                   	pop    %edi
801042a9:	5d                   	pop    %ebp
801042aa:	c3                   	ret    
      release(&ptable.lock);
801042ab:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042ae:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&ptable.lock);
801042b3:	68 20 3d 11 80       	push   $0x80113d20
801042b8:	e8 53 08 00 00       	call   80104b10 <release>
      return -1;
801042bd:	83 c4 10             	add    $0x10,%esp
801042c0:	eb df                	jmp    801042a1 <pass1804+0x97>
801042c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042d0 <wakeup>:
{
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 10             	sub    $0x10,%esp
801042d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042da:	68 20 3d 11 80       	push   $0x80113d20
801042df:	e8 6c 07 00 00       	call   80104a50 <acquire>
  wakeup1(chan);
801042e4:	89 d8                	mov    %ebx,%eax
801042e6:	e8 75 f3 ff ff       	call   80103660 <wakeup1>
  release(&ptable.lock);
801042eb:	83 c4 10             	add    $0x10,%esp
801042ee:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
801042f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f8:	c9                   	leave  
  release(&ptable.lock);
801042f9:	e9 12 08 00 00       	jmp    80104b10 <release>
801042fe:	66 90                	xchg   %ax,%ax

80104300 <kill>:
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	56                   	push   %esi
80104304:	53                   	push   %ebx
80104305:	8b 75 0c             	mov    0xc(%ebp),%esi
80104308:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(signum < SIG_MIN || signum > SIG_MAX)
8010430b:	83 fe 1f             	cmp    $0x1f,%esi
8010430e:	77 7c                	ja     8010438c <kill+0x8c>
  acquire(&ptable.lock);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	68 20 3d 11 80       	push   $0x80113d20
80104318:	e8 33 07 00 00       	call   80104a50 <acquire>
8010431d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104320:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104325:	eb 15                	jmp    8010433c <kill+0x3c>
80104327:	89 f6                	mov    %esi,%esi
80104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104330:	05 0c 01 00 00       	add    $0x10c,%eax
80104335:	3d 54 80 11 80       	cmp    $0x80118054,%eax
8010433a:	73 34                	jae    80104370 <kill+0x70>
    if(p->pid == pid){
8010433c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010433f:	75 ef                	jne    80104330 <kill+0x30>
      p->psignals |= 1 << signum;
80104341:	89 f1                	mov    %esi,%ecx
80104343:	ba 01 00 00 00       	mov    $0x1,%edx
      release(&ptable.lock);
80104348:	83 ec 0c             	sub    $0xc,%esp
      p->psignals |= 1 << signum;
8010434b:	d3 e2                	shl    %cl,%edx
8010434d:	09 50 7c             	or     %edx,0x7c(%eax)
      release(&ptable.lock);
80104350:	68 20 3d 11 80       	push   $0x80113d20
80104355:	e8 b6 07 00 00       	call   80104b10 <release>
      return 0;
8010435a:	83 c4 10             	add    $0x10,%esp
8010435d:	31 c0                	xor    %eax,%eax
}
8010435f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104362:	5b                   	pop    %ebx
80104363:	5e                   	pop    %esi
80104364:	5d                   	pop    %ebp
80104365:	c3                   	ret    
80104366:	8d 76 00             	lea    0x0(%esi),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&ptable.lock);
80104370:	83 ec 0c             	sub    $0xc,%esp
80104373:	68 20 3d 11 80       	push   $0x80113d20
80104378:	e8 93 07 00 00       	call   80104b10 <release>
  return -1;
8010437d:	83 c4 10             	add    $0x10,%esp
}
80104380:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
80104383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104388:	5b                   	pop    %ebx
80104389:	5e                   	pop    %esi
8010438a:	5d                   	pop    %ebp
8010438b:	c3                   	ret    
    return -1;
8010438c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104391:	eb cc                	jmp    8010435f <kill+0x5f>
80104393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <sigprocmask>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801043a7:	e8 d4 05 00 00       	call   80104980 <pushcli>
  c = mycpu();
801043ac:	e8 cf f3 ff ff       	call   80103780 <mycpu>
  p = c->proc;
801043b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043b7:	e8 04 06 00 00       	call   801049c0 <popcli>
  curproc->sigmask = mask;
801043bc:	8b 55 08             	mov    0x8(%ebp),%edx
  uint old = curproc -> sigmask;
801043bf:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  curproc->sigmask = mask;
801043c5:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
}
801043cb:	83 c4 04             	add    $0x4,%esp
801043ce:	5b                   	pop    %ebx
801043cf:	5d                   	pop    %ebp
801043d0:	c3                   	ret    
801043d1:	eb 0d                	jmp    801043e0 <procdump>
801043d3:	90                   	nop
801043d4:	90                   	nop
801043d5:	90                   	nop
801043d6:	90                   	nop
801043d7:	90                   	nop
801043d8:	90                   	nop
801043d9:	90                   	nop
801043da:	90                   	nop
801043db:	90                   	nop
801043dc:	90                   	nop
801043dd:	90                   	nop
801043de:	90                   	nop
801043df:	90                   	nop

801043e0 <procdump>:
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	53                   	push   %ebx
801043e6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043e9:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801043ee:	83 ec 3c             	sub    $0x3c,%esp
801043f1:	eb 27                	jmp    8010441a <procdump+0x3a>
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n");
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	68 83 81 10 80       	push   $0x80108183
80104400:	e8 5b c2 ff ff       	call   80100660 <cprintf>
80104405:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104408:	81 c3 0c 01 00 00    	add    $0x10c,%ebx
8010440e:	81 fb 54 80 11 80    	cmp    $0x80118054,%ebx
80104414:	0f 83 86 00 00 00    	jae    801044a0 <procdump+0xc0>
    if(p->state == UNUSED)
8010441a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010441d:	85 c0                	test   %eax,%eax
8010441f:	74 e7                	je     80104408 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104421:	83 f8 09             	cmp    $0x9,%eax
      state = "???";
80104424:	ba ea 7d 10 80       	mov    $0x80107dea,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104429:	77 11                	ja     8010443c <procdump+0x5c>
8010442b:	8b 14 85 60 7e 10 80 	mov    -0x7fef81a0(,%eax,4),%edx
      state = "???";
80104432:	b8 ea 7d 10 80       	mov    $0x80107dea,%eax
80104437:	85 d2                	test   %edx,%edx
80104439:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010443c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010443f:	50                   	push   %eax
80104440:	52                   	push   %edx
80104441:	ff 73 10             	pushl  0x10(%ebx)
80104444:	68 ee 7d 10 80       	push   $0x80107dee
80104449:	e8 12 c2 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010444e:	83 c4 10             	add    $0x10,%esp
80104451:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104455:	75 a1                	jne    801043f8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104457:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010445a:	83 ec 08             	sub    $0x8,%esp
8010445d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104460:	50                   	push   %eax
80104461:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104464:	8b 40 0c             	mov    0xc(%eax),%eax
80104467:	83 c0 08             	add    $0x8,%eax
8010446a:	50                   	push   %eax
8010446b:	e8 c0 04 00 00       	call   80104930 <getcallerpcs>
80104470:	83 c4 10             	add    $0x10,%esp
80104473:	90                   	nop
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104478:	8b 17                	mov    (%edi),%edx
8010447a:	85 d2                	test   %edx,%edx
8010447c:	0f 84 76 ff ff ff    	je     801043f8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104482:	83 ec 08             	sub    $0x8,%esp
80104485:	83 c7 04             	add    $0x4,%edi
80104488:	52                   	push   %edx
80104489:	68 e1 76 10 80       	push   $0x801076e1
8010448e:	e8 cd c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104493:	83 c4 10             	add    $0x10,%esp
80104496:	39 fe                	cmp    %edi,%esi
80104498:	75 de                	jne    80104478 <procdump+0x98>
8010449a:	e9 59 ff ff ff       	jmp    801043f8 <procdump+0x18>
8010449f:	90                   	nop
}
801044a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044a3:	5b                   	pop    %ebx
801044a4:	5e                   	pop    %esi
801044a5:	5f                   	pop    %edi
801044a6:	5d                   	pop    %ebp
801044a7:	c3                   	ret    
801044a8:	90                   	nop
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044b0 <sigkill_handler>:
sigkill_handler(){
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801044b7:	e8 c4 04 00 00       	call   80104980 <pushcli>
  c = mycpu();
801044bc:	e8 bf f2 ff ff       	call   80103780 <mycpu>
  p = c->proc;
801044c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044c7:	e8 f4 04 00 00       	call   801049c0 <popcli>
  if(p->state == SLEEPING)
801044cc:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
  p->killed = 1;
801044d0:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
  if(p->state == SLEEPING)
801044d7:	75 07                	jne    801044e0 <sigkill_handler+0x30>
    p->state = RUNNABLE;
801044d9:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
}
801044e0:	83 c4 04             	add    $0x4,%esp
801044e3:	31 c0                	xor    %eax,%eax
801044e5:	5b                   	pop    %ebx
801044e6:	5d                   	pop    %ebp
801044e7:	c3                   	ret    
801044e8:	90                   	nop
801044e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044f0 <sigstop_handler>:
sigstop_handler(){
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801044f7:	e8 84 04 00 00       	call   80104980 <pushcli>
  c = mycpu();
801044fc:	e8 7f f2 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80104501:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104507:	e8 b4 04 00 00       	call   801049c0 <popcli>
8010450c:	b8 01 00 00 00       	mov    $0x1,%eax
  if(p-> state == SLEEPING)
80104511:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104515:	74 0c                	je     80104523 <sigstop_handler+0x33>
  p->frozen = 1;
80104517:	c7 83 08 01 00 00 01 	movl   $0x1,0x108(%ebx)
8010451e:	00 00 00 
  return 0;
80104521:	31 c0                	xor    %eax,%eax
}
80104523:	83 c4 04             	add    $0x4,%esp
80104526:	5b                   	pop    %ebx
80104527:	5d                   	pop    %ebp
80104528:	c3                   	ret    
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104530 <sigcont_handler>:
sigcont_handler(){
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104537:	e8 44 04 00 00       	call   80104980 <pushcli>
  c = mycpu();
8010453c:	e8 3f f2 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80104541:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104547:	e8 74 04 00 00       	call   801049c0 <popcli>
}
8010454c:	31 c0                	xor    %eax,%eax
  p->frozen = 0;
8010454e:	c7 83 08 01 00 00 00 	movl   $0x0,0x108(%ebx)
80104555:	00 00 00 
}
80104558:	83 c4 04             	add    $0x4,%esp
8010455b:	5b                   	pop    %ebx
8010455c:	5d                   	pop    %ebp
8010455d:	c3                   	ret    
8010455e:	66 90                	xchg   %ax,%ax

80104560 <copySigHandlers>:
copySigHandlers(void** new_sighandlers, void** old_sighandlers) {
80104560:	55                   	push   %ebp
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80104561:	31 c0                	xor    %eax,%eax
copySigHandlers(void** new_sighandlers, void** old_sighandlers) {
80104563:	89 e5                	mov    %esp,%ebp
80104565:	53                   	push   %ebx
80104566:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104569:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    new_sighandlers[i] = old_sighandlers[i];
80104570:	8b 14 81             	mov    (%ecx,%eax,4),%edx
80104573:	89 14 83             	mov    %edx,(%ebx,%eax,4)
  for(i = 0; i < SIG_HANDLERS_NUM; i++) {
80104576:	83 c0 01             	add    $0x1,%eax
80104579:	83 f8 20             	cmp    $0x20,%eax
8010457c:	75 f2                	jne    80104570 <copySigHandlers+0x10>
  }
}
8010457e:	5b                   	pop    %ebx
8010457f:	5d                   	pop    %ebp
80104580:	c3                   	ret    
80104581:	eb 0d                	jmp    80104590 <sigaction>
80104583:	90                   	nop
80104584:	90                   	nop
80104585:	90                   	nop
80104586:	90                   	nop
80104587:	90                   	nop
80104588:	90                   	nop
80104589:	90                   	nop
8010458a:	90                   	nop
8010458b:	90                   	nop
8010458c:	90                   	nop
8010458d:	90                   	nop
8010458e:	90                   	nop
8010458f:	90                   	nop

80104590 <sigaction>:

int 
sigaction(int signum, const struct sigaction *act, struct sigaction *oldact) 
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
80104595:	53                   	push   %ebx
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	8b 75 08             	mov    0x8(%ebp),%esi
8010459c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  pushcli();
8010459f:	e8 dc 03 00 00       	call   80104980 <pushcli>
  c = mycpu();
801045a4:	e8 d7 f1 ff ff       	call   80103780 <mycpu>
  p = c->proc;
801045a9:	8b b8 ac 00 00 00    	mov    0xac(%eax),%edi
  popcli();
801045af:	e8 0c 04 00 00       	call   801049c0 <popcli>
  struct proc* curproc = myproc();

  if(signum == SIGSTOP || signum == SIGKILL) // they cannot be modified, blocked or ignored
801045b4:	8d 56 f7             	lea    -0x9(%esi),%edx
801045b7:	b8 01 00 00 00       	mov    $0x1,%eax
801045bc:	83 e2 f7             	and    $0xfffffff7,%edx
801045bf:	74 2f                	je     801045f0 <sigaction+0x60>
    return 1;

  if(oldact != null) {
801045c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045c4:	8d 84 b7 84 00 00 00 	lea    0x84(%edi,%esi,4),%eax
801045cb:	85 c9                	test   %ecx,%ecx
801045cd:	74 0d                	je     801045dc <sigaction+0x4c>
    oldact->sa_handler = ((struct sigaction*)&curproc->sig_handlers[signum])->sa_handler;              // old handler
801045cf:	8b 10                	mov    (%eax),%edx
801045d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045d4:	89 11                	mov    %edx,(%ecx)
    oldact->sigmask = ((struct sigaction*)&curproc->sig_handlers[signum])->sigmask;                    // old sigmask
801045d6:	8b 50 04             	mov    0x4(%eax),%edx
801045d9:	89 51 04             	mov    %edx,0x4(%ecx)
  }

  ((struct sigaction*)&curproc->sig_handlers[signum])->sa_handler = act->sa_handler;
801045dc:	8b 13                	mov    (%ebx),%edx
801045de:	89 10                	mov    %edx,(%eax)
  ((struct sigaction*)&curproc->sig_handlers[signum])->sigmask = act->sigmask;
801045e0:	8b 53 04             	mov    0x4(%ebx),%edx
801045e3:	89 50 04             	mov    %edx,0x4(%eax)

  if(act->sigmask <= 0) // sigmask must be positive
801045e6:	8b 53 04             	mov    0x4(%ebx),%edx
801045e9:	31 c0                	xor    %eax,%eax
801045eb:	85 d2                	test   %edx,%edx
801045ed:	0f 94 c0             	sete   %al
    return 1;

  return 0;
}
801045f0:	83 c4 0c             	add    $0xc,%esp
801045f3:	5b                   	pop    %ebx
801045f4:	5e                   	pop    %esi
801045f5:	5f                   	pop    %edi
801045f6:	5d                   	pop    %ebp
801045f7:	c3                   	ret    
801045f8:	90                   	nop
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104600 <user_handler>:

void
user_handler(struct proc* p, uint sig)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	57                   	push   %edi
80104604:	56                   	push   %esi
80104605:	53                   	push   %ebx
80104606:	83 ec 10             	sub    $0x10,%esp
80104609:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010460c:	8b 75 0c             	mov    0xc(%ebp),%esi

    char *sigret_caller_addr;
    uint sigret_size;

    // back-up trap frame
    memmove(p->kstack, p->tf, sizeof(*p->tf));
8010460f:	6a 4c                	push   $0x4c
80104611:	ff 73 18             	pushl  0x18(%ebx)
80104614:	ff 73 08             	pushl  0x8(%ebx)
80104617:	e8 f4 05 00 00       	call   80104c10 <memmove>
    p->tf_backup = (struct trapframe*)p->kstack;
8010461c:	8b 43 08             	mov    0x8(%ebx),%eax

    // changing the user space stack
    sigret_size = sigret_caller_end - sigret_caller_start;
    p->tf->esp = p->tf->esp - sigret_size; // make room for sigret code
8010461f:	8b 53 18             	mov    0x18(%ebx),%edx

    sigret_caller_addr = (char*)p->tf->esp;

    memmove((char*)p->tf->esp, sigret_caller_start, sigret_size);
80104622:	83 c4 0c             	add    $0xc,%esp
    p->tf_backup = (struct trapframe*)p->kstack;
80104625:	89 83 04 01 00 00    	mov    %eax,0x104(%ebx)
    sigret_size = sigret_caller_end - sigret_caller_start;
8010462b:	b8 38 5e 10 80       	mov    $0x80105e38,%eax
80104630:	2d 31 5e 10 80       	sub    $0x80105e31,%eax
    p->tf->esp = p->tf->esp - sigret_size; // make room for sigret code
80104635:	29 42 44             	sub    %eax,0x44(%edx)
    sigret_caller_addr = (char*)p->tf->esp;
80104638:	8b 53 18             	mov    0x18(%ebx),%edx
8010463b:	8b 7a 44             	mov    0x44(%edx),%edi
    memmove((char*)p->tf->esp, sigret_caller_start, sigret_size);
8010463e:	50                   	push   %eax
8010463f:	68 31 5e 10 80       	push   $0x80105e31
80104644:	57                   	push   %edi
80104645:	e8 c6 05 00 00       	call   80104c10 <memmove>

    // pushing signum
    p->tf->esp = p->tf->esp-UINT_SIZE;
8010464a:	8b 43 18             	mov    0x18(%ebx),%eax
    p->tf->esp = p->tf->esp-UINT_SIZE;
    *((uint*)(p->tf->esp)) = (uint)sigret_caller_addr;

    // updating user eip to user handler's address
    p->tf->eip = (uint)&((struct sigaction*)p->sig_handlers[sig])->sa_handler;
    return;
8010464d:	83 c4 10             	add    $0x10,%esp
    p->tf->esp = p->tf->esp-UINT_SIZE;
80104650:	83 68 44 04          	subl   $0x4,0x44(%eax)
    *((uint*)(p->tf->esp)) = sig;
80104654:	8b 43 18             	mov    0x18(%ebx),%eax
80104657:	8b 40 44             	mov    0x44(%eax),%eax
8010465a:	89 30                	mov    %esi,(%eax)
    p->tf->esp = p->tf->esp-UINT_SIZE;
8010465c:	8b 43 18             	mov    0x18(%ebx),%eax
8010465f:	83 68 44 04          	subl   $0x4,0x44(%eax)
    *((uint*)(p->tf->esp)) = (uint)sigret_caller_addr;
80104663:	8b 43 18             	mov    0x18(%ebx),%eax
80104666:	8b 40 44             	mov    0x44(%eax),%eax
80104669:	89 38                	mov    %edi,(%eax)
    p->tf->eip = (uint)&((struct sigaction*)p->sig_handlers[sig])->sa_handler;
8010466b:	8b 94 b3 84 00 00 00 	mov    0x84(%ebx,%esi,4),%edx
80104672:	8b 43 18             	mov    0x18(%ebx),%eax
80104675:	89 50 38             	mov    %edx,0x38(%eax)
}
80104678:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010467b:	5b                   	pop    %ebx
8010467c:	5e                   	pop    %esi
8010467d:	5f                   	pop    %edi
8010467e:	5d                   	pop    %ebp
8010467f:	c3                   	ret    

80104680 <handleSignal>:

void
handleSignal (int sig) {
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104688:	e8 f3 02 00 00       	call   80104980 <pushcli>
  c = mycpu();
8010468d:	e8 ee f0 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80104692:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104698:	e8 23 03 00 00       	call   801049c0 <popcli>
  struct proc *p = myproc();
  if(p->sig_handlers[sig] == SIG_IGN)
8010469d:	8b 84 9e 84 00 00 00 	mov    0x84(%esi,%ebx,4),%eax
801046a4:	83 f8 01             	cmp    $0x1,%eax
801046a7:	74 11                	je     801046ba <handleSignal+0x3a>
  {
    // do nothing
  }

  else if(p->sig_handlers[sig] == SIG_DFL)
801046a9:	85 c0                	test   %eax,%eax
801046ab:	74 1b                	je     801046c8 <handleSignal+0x48>
      
    }
  }

  else
    user_handler(p, sig);
801046ad:	83 ec 08             	sub    $0x8,%esp
801046b0:	53                   	push   %ebx
801046b1:	56                   	push   %esi
801046b2:	e8 49 ff ff ff       	call   80104600 <user_handler>
801046b7:	83 c4 10             	add    $0x10,%esp
}
801046ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046bd:	5b                   	pop    %ebx
801046be:	5e                   	pop    %esi
801046bf:	5d                   	pop    %ebp
801046c0:	c3                   	ret    
801046c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch (sig) 
801046c8:	83 fb 11             	cmp    $0x11,%ebx
801046cb:	74 23                	je     801046f0 <handleSignal+0x70>
801046cd:	83 fb 13             	cmp    $0x13,%ebx
801046d0:	75 0e                	jne    801046e0 <handleSignal+0x60>
}
801046d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046d5:	5b                   	pop    %ebx
801046d6:	5e                   	pop    %esi
801046d7:	5d                   	pop    %ebp
        sigcont_handler();
801046d8:	e9 53 fe ff ff       	jmp    80104530 <sigcont_handler>
801046dd:	8d 76 00             	lea    0x0(%esi),%esi
}
801046e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046e3:	5b                   	pop    %ebx
801046e4:	5e                   	pop    %esi
801046e5:	5d                   	pop    %ebp
        sigkill_handler();
801046e6:	e9 c5 fd ff ff       	jmp    801044b0 <sigkill_handler>
801046eb:	90                   	nop
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801046f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046f3:	5b                   	pop    %ebx
801046f4:	5e                   	pop    %esi
801046f5:	5d                   	pop    %ebp
        sigstop_handler();
801046f6:	e9 f5 fd ff ff       	jmp    801044f0 <sigstop_handler>
801046fb:	90                   	nop
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104700 <handle_signals>:

void
handle_signals (){
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	53                   	push   %ebx
80104706:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104709:	e8 72 02 00 00       	call   80104980 <pushcli>
  c = mycpu();
8010470e:	e8 6d f0 ff ff       	call   80103780 <mycpu>
  p = c->proc;
80104713:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104719:	e8 a2 02 00 00       	call   801049c0 <popcli>
  struct proc *p = myproc();
  uint sig;

  if(p == 0)
8010471e:	85 f6                	test   %esi,%esi
80104720:	74 6e                	je     80104790 <handle_signals+0x90>
    return;

  acquire(&ptable.lock);
80104722:	83 ec 0c             	sub    $0xc,%esp
  
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
  //signal sig is pending and is not blocked
  if((p->psignals & (1 << sig))  && !(p->sigmask & (1 << sig))) {
80104725:	bf 01 00 00 00       	mov    $0x1,%edi
  acquire(&ptable.lock);
8010472a:	68 20 3d 11 80       	push   $0x80113d20
8010472f:	e8 1c 03 00 00       	call   80104a50 <acquire>
80104734:	83 c4 10             	add    $0x10,%esp
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
80104737:	31 c9                	xor    %ecx,%ecx
80104739:	eb 0d                	jmp    80104748 <handle_signals+0x48>
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104740:	83 c1 01             	add    $0x1,%ecx
80104743:	83 f9 20             	cmp    $0x20,%ecx
80104746:	74 38                	je     80104780 <handle_signals+0x80>
  if((p->psignals & (1 << sig))  && !(p->sigmask & (1 << sig))) {
80104748:	89 fb                	mov    %edi,%ebx
8010474a:	d3 e3                	shl    %cl,%ebx
8010474c:	85 5e 7c             	test   %ebx,0x7c(%esi)
8010474f:	74 ef                	je     80104740 <handle_signals+0x40>
80104751:	85 9e 80 00 00 00    	test   %ebx,0x80(%esi)
80104757:	75 e7                	jne    80104740 <handle_signals+0x40>
    handleSignal(sig);           // handle it
80104759:	83 ec 0c             	sub    $0xc,%esp
8010475c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010475f:	51                   	push   %ecx
80104760:	e8 1b ff ff ff       	call   80104680 <handleSignal>
    p->psignals ^= 1 << sig;     // turn off this bit
80104765:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104768:	31 5e 7c             	xor    %ebx,0x7c(%esi)
8010476b:	83 c4 10             	add    $0x10,%esp
  for (sig = SIG_MIN; sig <= SIG_MAX; sig++) {
8010476e:	83 c1 01             	add    $0x1,%ecx
80104771:	83 f9 20             	cmp    $0x20,%ecx
80104774:	75 d2                	jne    80104748 <handle_signals+0x48>
80104776:	8d 76 00             	lea    0x0(%esi),%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
  }
  release(&ptable.lock);
80104780:	83 ec 0c             	sub    $0xc,%esp
80104783:	68 20 3d 11 80       	push   $0x80113d20
80104788:	e8 83 03 00 00       	call   80104b10 <release>
  return;
8010478d:	83 c4 10             	add    $0x10,%esp
}
80104790:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104793:	5b                   	pop    %ebx
80104794:	5e                   	pop    %esi
80104795:	5f                   	pop    %edi
80104796:	5d                   	pop    %ebp
80104797:	c3                   	ret    
80104798:	90                   	nop
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047a0 <sigret>:

int
sigret(void) {
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	53                   	push   %ebx
801047a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801047a7:	e8 d4 01 00 00       	call   80104980 <pushcli>
  c = mycpu();
801047ac:	e8 cf ef ff ff       	call   80103780 <mycpu>
  p = c->proc;
801047b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801047b7:	e8 04 02 00 00       	call   801049c0 <popcli>
  struct proc* p = myproc();
  memmove(p->tf, p->tf_backup, sizeof(struct trapframe)); // trapframe restore
801047bc:	83 ec 04             	sub    $0x4,%esp
801047bf:	6a 4c                	push   $0x4c
801047c1:	ff b3 04 01 00 00    	pushl  0x104(%ebx)
801047c7:	ff 73 18             	pushl  0x18(%ebx)
801047ca:	e8 41 04 00 00       	call   80104c10 <memmove>
  return 0;
801047cf:	31 c0                	xor    %eax,%eax
801047d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d4:	c9                   	leave  
801047d5:	c3                   	ret    
801047d6:	66 90                	xchg   %ax,%ax
801047d8:	66 90                	xchg   %ax,%ax
801047da:	66 90                	xchg   %ax,%ax
801047dc:	66 90                	xchg   %ax,%ax
801047de:	66 90                	xchg   %ax,%ax

801047e0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 0c             	sub    $0xc,%esp
801047e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801047ea:	68 88 7e 10 80       	push   $0x80107e88
801047ef:	8d 43 04             	lea    0x4(%ebx),%eax
801047f2:	50                   	push   %eax
801047f3:	e8 18 01 00 00       	call   80104910 <initlock>
  lk->name = name;
801047f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801047fb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104801:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104804:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010480b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010480e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104811:	c9                   	leave  
80104812:	c3                   	ret    
80104813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	56                   	push   %esi
80104824:	53                   	push   %ebx
80104825:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	8d 73 04             	lea    0x4(%ebx),%esi
8010482e:	56                   	push   %esi
8010482f:	e8 1c 02 00 00       	call   80104a50 <acquire>
  while (lk->locked) {
80104834:	8b 13                	mov    (%ebx),%edx
80104836:	83 c4 10             	add    $0x10,%esp
80104839:	85 d2                	test   %edx,%edx
8010483b:	74 16                	je     80104853 <acquiresleep+0x33>
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104840:	83 ec 08             	sub    $0x8,%esp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
80104845:	e8 76 f8 ff ff       	call   801040c0 <sleep>
  while (lk->locked) {
8010484a:	8b 03                	mov    (%ebx),%eax
8010484c:	83 c4 10             	add    $0x10,%esp
8010484f:	85 c0                	test   %eax,%eax
80104851:	75 ed                	jne    80104840 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104853:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104859:	e8 c2 ef ff ff       	call   80103820 <myproc>
8010485e:	8b 40 10             	mov    0x10(%eax),%eax
80104861:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104864:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104867:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010486a:	5b                   	pop    %ebx
8010486b:	5e                   	pop    %esi
8010486c:	5d                   	pop    %ebp
  release(&lk->lk);
8010486d:	e9 9e 02 00 00       	jmp    80104b10 <release>
80104872:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
80104885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104888:	83 ec 0c             	sub    $0xc,%esp
8010488b:	8d 73 04             	lea    0x4(%ebx),%esi
8010488e:	56                   	push   %esi
8010488f:	e8 bc 01 00 00       	call   80104a50 <acquire>
  lk->locked = 0;
80104894:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010489a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801048a1:	89 1c 24             	mov    %ebx,(%esp)
801048a4:	e8 27 fa ff ff       	call   801042d0 <wakeup>
  release(&lk->lk);
801048a9:	89 75 08             	mov    %esi,0x8(%ebp)
801048ac:	83 c4 10             	add    $0x10,%esp
}
801048af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b2:	5b                   	pop    %ebx
801048b3:	5e                   	pop    %esi
801048b4:	5d                   	pop    %ebp
  release(&lk->lk);
801048b5:	e9 56 02 00 00       	jmp    80104b10 <release>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	57                   	push   %edi
801048c4:	56                   	push   %esi
801048c5:	53                   	push   %ebx
801048c6:	31 ff                	xor    %edi,%edi
801048c8:	83 ec 18             	sub    $0x18,%esp
801048cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801048ce:	8d 73 04             	lea    0x4(%ebx),%esi
801048d1:	56                   	push   %esi
801048d2:	e8 79 01 00 00       	call   80104a50 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801048d7:	8b 03                	mov    (%ebx),%eax
801048d9:	83 c4 10             	add    $0x10,%esp
801048dc:	85 c0                	test   %eax,%eax
801048de:	74 13                	je     801048f3 <holdingsleep+0x33>
801048e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801048e3:	e8 38 ef ff ff       	call   80103820 <myproc>
801048e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801048eb:	0f 94 c0             	sete   %al
801048ee:	0f b6 c0             	movzbl %al,%eax
801048f1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801048f3:	83 ec 0c             	sub    $0xc,%esp
801048f6:	56                   	push   %esi
801048f7:	e8 14 02 00 00       	call   80104b10 <release>
  return r;
}
801048fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048ff:	89 f8                	mov    %edi,%eax
80104901:	5b                   	pop    %ebx
80104902:	5e                   	pop    %esi
80104903:	5f                   	pop    %edi
80104904:	5d                   	pop    %ebp
80104905:	c3                   	ret    
80104906:	66 90                	xchg   %ax,%ax
80104908:	66 90                	xchg   %ax,%ax
8010490a:	66 90                	xchg   %ax,%ax
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104916:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010491f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104922:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104929:	5d                   	pop    %ebp
8010492a:	c3                   	ret    
8010492b:	90                   	nop
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104930 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104930:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104931:	31 d2                	xor    %edx,%edx
{
80104933:	89 e5                	mov    %esp,%ebp
80104935:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104936:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104939:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010493c:	83 e8 08             	sub    $0x8,%eax
8010493f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104940:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104946:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010494c:	77 1a                	ja     80104968 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010494e:	8b 58 04             	mov    0x4(%eax),%ebx
80104951:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104954:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104957:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104959:	83 fa 0a             	cmp    $0xa,%edx
8010495c:	75 e2                	jne    80104940 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010495e:	5b                   	pop    %ebx
8010495f:	5d                   	pop    %ebp
80104960:	c3                   	ret    
80104961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104968:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010496b:	83 c1 28             	add    $0x28,%ecx
8010496e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104976:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104979:	39 c1                	cmp    %eax,%ecx
8010497b:	75 f3                	jne    80104970 <getcallerpcs+0x40>
}
8010497d:	5b                   	pop    %ebx
8010497e:	5d                   	pop    %ebp
8010497f:	c3                   	ret    

80104980 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104987:	9c                   	pushf  
80104988:	5b                   	pop    %ebx
  asm volatile("cli");
80104989:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010498a:	e8 f1 ed ff ff       	call   80103780 <mycpu>
8010498f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104995:	85 c0                	test   %eax,%eax
80104997:	75 11                	jne    801049aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104999:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010499f:	e8 dc ed ff ff       	call   80103780 <mycpu>
801049a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801049aa:	e8 d1 ed ff ff       	call   80103780 <mycpu>
801049af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801049b6:	83 c4 04             	add    $0x4,%esp
801049b9:	5b                   	pop    %ebx
801049ba:	5d                   	pop    %ebp
801049bb:	c3                   	ret    
801049bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049c0 <popcli>:

void
popcli(void)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049c6:	9c                   	pushf  
801049c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049c8:	f6 c4 02             	test   $0x2,%ah
801049cb:	75 35                	jne    80104a02 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801049cd:	e8 ae ed ff ff       	call   80103780 <mycpu>
801049d2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049d9:	78 34                	js     80104a0f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049db:	e8 a0 ed ff ff       	call   80103780 <mycpu>
801049e0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801049e6:	85 d2                	test   %edx,%edx
801049e8:	74 06                	je     801049f0 <popcli+0x30>
    sti();
}
801049ea:	c9                   	leave  
801049eb:	c3                   	ret    
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049f0:	e8 8b ed ff ff       	call   80103780 <mycpu>
801049f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049fb:	85 c0                	test   %eax,%eax
801049fd:	74 eb                	je     801049ea <popcli+0x2a>
  asm volatile("sti");
801049ff:	fb                   	sti    
}
80104a00:	c9                   	leave  
80104a01:	c3                   	ret    
    panic("popcli - interruptible");
80104a02:	83 ec 0c             	sub    $0xc,%esp
80104a05:	68 93 7e 10 80       	push   $0x80107e93
80104a0a:	e8 81 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
80104a0f:	83 ec 0c             	sub    $0xc,%esp
80104a12:	68 aa 7e 10 80       	push   $0x80107eaa
80104a17:	e8 74 b9 ff ff       	call   80100390 <panic>
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a20 <holding>:
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	53                   	push   %ebx
80104a25:	8b 75 08             	mov    0x8(%ebp),%esi
80104a28:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a2a:	e8 51 ff ff ff       	call   80104980 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104a2f:	8b 06                	mov    (%esi),%eax
80104a31:	85 c0                	test   %eax,%eax
80104a33:	74 10                	je     80104a45 <holding+0x25>
80104a35:	8b 5e 08             	mov    0x8(%esi),%ebx
80104a38:	e8 43 ed ff ff       	call   80103780 <mycpu>
80104a3d:	39 c3                	cmp    %eax,%ebx
80104a3f:	0f 94 c3             	sete   %bl
80104a42:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104a45:	e8 76 ff ff ff       	call   801049c0 <popcli>
}
80104a4a:	89 d8                	mov    %ebx,%eax
80104a4c:	5b                   	pop    %ebx
80104a4d:	5e                   	pop    %esi
80104a4e:	5d                   	pop    %ebp
80104a4f:	c3                   	ret    

80104a50 <acquire>:
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104a55:	e8 26 ff ff ff       	call   80104980 <pushcli>
  if(holding(lk))
80104a5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a5d:	83 ec 0c             	sub    $0xc,%esp
80104a60:	53                   	push   %ebx
80104a61:	e8 ba ff ff ff       	call   80104a20 <holding>
80104a66:	83 c4 10             	add    $0x10,%esp
80104a69:	85 c0                	test   %eax,%eax
80104a6b:	0f 85 83 00 00 00    	jne    80104af4 <acquire+0xa4>
80104a71:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104a73:	ba 01 00 00 00       	mov    $0x1,%edx
80104a78:	eb 09                	jmp    80104a83 <acquire+0x33>
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a80:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a83:	89 d0                	mov    %edx,%eax
80104a85:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104a88:	85 c0                	test   %eax,%eax
80104a8a:	75 f4                	jne    80104a80 <acquire+0x30>
  __sync_synchronize();
80104a8c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104a91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a94:	e8 e7 ec ff ff       	call   80103780 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104a99:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104a9c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104a9f:	89 e8                	mov    %ebp,%eax
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104aa8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104aae:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104ab4:	77 1a                	ja     80104ad0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104ab6:	8b 48 04             	mov    0x4(%eax),%ecx
80104ab9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104abc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104abf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ac1:	83 fe 0a             	cmp    $0xa,%esi
80104ac4:	75 e2                	jne    80104aa8 <acquire+0x58>
}
80104ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ac9:	5b                   	pop    %ebx
80104aca:	5e                   	pop    %esi
80104acb:	5d                   	pop    %ebp
80104acc:	c3                   	ret    
80104acd:	8d 76 00             	lea    0x0(%esi),%esi
80104ad0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104ad3:	83 c2 28             	add    $0x28,%edx
80104ad6:	8d 76 00             	lea    0x0(%esi),%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ae6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ae9:	39 d0                	cmp    %edx,%eax
80104aeb:	75 f3                	jne    80104ae0 <acquire+0x90>
}
80104aed:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104af0:	5b                   	pop    %ebx
80104af1:	5e                   	pop    %esi
80104af2:	5d                   	pop    %ebp
80104af3:	c3                   	ret    
    panic("acquire");
80104af4:	83 ec 0c             	sub    $0xc,%esp
80104af7:	68 b1 7e 10 80       	push   $0x80107eb1
80104afc:	e8 8f b8 ff ff       	call   80100390 <panic>
80104b01:	eb 0d                	jmp    80104b10 <release>
80104b03:	90                   	nop
80104b04:	90                   	nop
80104b05:	90                   	nop
80104b06:	90                   	nop
80104b07:	90                   	nop
80104b08:	90                   	nop
80104b09:	90                   	nop
80104b0a:	90                   	nop
80104b0b:	90                   	nop
80104b0c:	90                   	nop
80104b0d:	90                   	nop
80104b0e:	90                   	nop
80104b0f:	90                   	nop

80104b10 <release>:
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	53                   	push   %ebx
80104b14:	83 ec 10             	sub    $0x10,%esp
80104b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104b1a:	53                   	push   %ebx
80104b1b:	e8 00 ff ff ff       	call   80104a20 <holding>
80104b20:	83 c4 10             	add    $0x10,%esp
80104b23:	85 c0                	test   %eax,%eax
80104b25:	74 22                	je     80104b49 <release+0x39>
  lk->pcs[0] = 0;
80104b27:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104b2e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104b35:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104b3a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b43:	c9                   	leave  
  popcli();
80104b44:	e9 77 fe ff ff       	jmp    801049c0 <popcli>
    panic("release");
80104b49:	83 ec 0c             	sub    $0xc,%esp
80104b4c:	68 b9 7e 10 80       	push   $0x80107eb9
80104b51:	e8 3a b8 ff ff       	call   80100390 <panic>
80104b56:	66 90                	xchg   %ax,%ax
80104b58:	66 90                	xchg   %ax,%ax
80104b5a:	66 90                	xchg   %ax,%ax
80104b5c:	66 90                	xchg   %ax,%ax
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	57                   	push   %edi
80104b64:	53                   	push   %ebx
80104b65:	8b 55 08             	mov    0x8(%ebp),%edx
80104b68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104b6b:	f6 c2 03             	test   $0x3,%dl
80104b6e:	75 05                	jne    80104b75 <memset+0x15>
80104b70:	f6 c1 03             	test   $0x3,%cl
80104b73:	74 13                	je     80104b88 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104b75:	89 d7                	mov    %edx,%edi
80104b77:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b7a:	fc                   	cld    
80104b7b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104b7d:	5b                   	pop    %ebx
80104b7e:	89 d0                	mov    %edx,%eax
80104b80:	5f                   	pop    %edi
80104b81:	5d                   	pop    %ebp
80104b82:	c3                   	ret    
80104b83:	90                   	nop
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104b88:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104b8c:	c1 e9 02             	shr    $0x2,%ecx
80104b8f:	89 f8                	mov    %edi,%eax
80104b91:	89 fb                	mov    %edi,%ebx
80104b93:	c1 e0 18             	shl    $0x18,%eax
80104b96:	c1 e3 10             	shl    $0x10,%ebx
80104b99:	09 d8                	or     %ebx,%eax
80104b9b:	09 f8                	or     %edi,%eax
80104b9d:	c1 e7 08             	shl    $0x8,%edi
80104ba0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ba2:	89 d7                	mov    %edx,%edi
80104ba4:	fc                   	cld    
80104ba5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104ba7:	5b                   	pop    %ebx
80104ba8:	89 d0                	mov    %edx,%eax
80104baa:	5f                   	pop    %edi
80104bab:	5d                   	pop    %ebp
80104bac:	c3                   	ret    
80104bad:	8d 76 00             	lea    0x0(%esi),%esi

80104bb0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104bb9:	8b 75 08             	mov    0x8(%ebp),%esi
80104bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104bbf:	85 db                	test   %ebx,%ebx
80104bc1:	74 29                	je     80104bec <memcmp+0x3c>
    if(*s1 != *s2)
80104bc3:	0f b6 16             	movzbl (%esi),%edx
80104bc6:	0f b6 0f             	movzbl (%edi),%ecx
80104bc9:	38 d1                	cmp    %dl,%cl
80104bcb:	75 2b                	jne    80104bf8 <memcmp+0x48>
80104bcd:	b8 01 00 00 00       	mov    $0x1,%eax
80104bd2:	eb 14                	jmp    80104be8 <memcmp+0x38>
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bd8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104bdc:	83 c0 01             	add    $0x1,%eax
80104bdf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104be4:	38 ca                	cmp    %cl,%dl
80104be6:	75 10                	jne    80104bf8 <memcmp+0x48>
  while(n-- > 0){
80104be8:	39 d8                	cmp    %ebx,%eax
80104bea:	75 ec                	jne    80104bd8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104bec:	5b                   	pop    %ebx
  return 0;
80104bed:	31 c0                	xor    %eax,%eax
}
80104bef:	5e                   	pop    %esi
80104bf0:	5f                   	pop    %edi
80104bf1:	5d                   	pop    %ebp
80104bf2:	c3                   	ret    
80104bf3:	90                   	nop
80104bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104bf8:	0f b6 c2             	movzbl %dl,%eax
}
80104bfb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104bfc:	29 c8                	sub    %ecx,%eax
}
80104bfe:	5e                   	pop    %esi
80104bff:	5f                   	pop    %edi
80104c00:	5d                   	pop    %ebp
80104c01:	c3                   	ret    
80104c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	56                   	push   %esi
80104c14:	53                   	push   %ebx
80104c15:	8b 45 08             	mov    0x8(%ebp),%eax
80104c18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c1b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c1e:	39 c3                	cmp    %eax,%ebx
80104c20:	73 26                	jae    80104c48 <memmove+0x38>
80104c22:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104c25:	39 c8                	cmp    %ecx,%eax
80104c27:	73 1f                	jae    80104c48 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104c29:	85 f6                	test   %esi,%esi
80104c2b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104c2e:	74 0f                	je     80104c3f <memmove+0x2f>
      *--d = *--s;
80104c30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104c37:	83 ea 01             	sub    $0x1,%edx
80104c3a:	83 fa ff             	cmp    $0xffffffff,%edx
80104c3d:	75 f1                	jne    80104c30 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104c3f:	5b                   	pop    %ebx
80104c40:	5e                   	pop    %esi
80104c41:	5d                   	pop    %ebp
80104c42:	c3                   	ret    
80104c43:	90                   	nop
80104c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104c48:	31 d2                	xor    %edx,%edx
80104c4a:	85 f6                	test   %esi,%esi
80104c4c:	74 f1                	je     80104c3f <memmove+0x2f>
80104c4e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104c50:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104c54:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104c57:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104c5a:	39 d6                	cmp    %edx,%esi
80104c5c:	75 f2                	jne    80104c50 <memmove+0x40>
}
80104c5e:	5b                   	pop    %ebx
80104c5f:	5e                   	pop    %esi
80104c60:	5d                   	pop    %ebp
80104c61:	c3                   	ret    
80104c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104c73:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104c74:	eb 9a                	jmp    80104c10 <memmove>
80104c76:	8d 76 00             	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
80104c85:	8b 7d 10             	mov    0x10(%ebp),%edi
80104c88:	53                   	push   %ebx
80104c89:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104c8f:	85 ff                	test   %edi,%edi
80104c91:	74 2f                	je     80104cc2 <strncmp+0x42>
80104c93:	0f b6 01             	movzbl (%ecx),%eax
80104c96:	0f b6 1e             	movzbl (%esi),%ebx
80104c99:	84 c0                	test   %al,%al
80104c9b:	74 37                	je     80104cd4 <strncmp+0x54>
80104c9d:	38 c3                	cmp    %al,%bl
80104c9f:	75 33                	jne    80104cd4 <strncmp+0x54>
80104ca1:	01 f7                	add    %esi,%edi
80104ca3:	eb 13                	jmp    80104cb8 <strncmp+0x38>
80104ca5:	8d 76 00             	lea    0x0(%esi),%esi
80104ca8:	0f b6 01             	movzbl (%ecx),%eax
80104cab:	84 c0                	test   %al,%al
80104cad:	74 21                	je     80104cd0 <strncmp+0x50>
80104caf:	0f b6 1a             	movzbl (%edx),%ebx
80104cb2:	89 d6                	mov    %edx,%esi
80104cb4:	38 d8                	cmp    %bl,%al
80104cb6:	75 1c                	jne    80104cd4 <strncmp+0x54>
    n--, p++, q++;
80104cb8:	8d 56 01             	lea    0x1(%esi),%edx
80104cbb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104cbe:	39 fa                	cmp    %edi,%edx
80104cc0:	75 e6                	jne    80104ca8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104cc2:	5b                   	pop    %ebx
    return 0;
80104cc3:	31 c0                	xor    %eax,%eax
}
80104cc5:	5e                   	pop    %esi
80104cc6:	5f                   	pop    %edi
80104cc7:	5d                   	pop    %ebp
80104cc8:	c3                   	ret    
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cd0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104cd4:	29 d8                	sub    %ebx,%eax
}
80104cd6:	5b                   	pop    %ebx
80104cd7:	5e                   	pop    %esi
80104cd8:	5f                   	pop    %edi
80104cd9:	5d                   	pop    %ebp
80104cda:	c3                   	ret    
80104cdb:	90                   	nop
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ce0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	56                   	push   %esi
80104ce4:	53                   	push   %ebx
80104ce5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ceb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104cee:	89 c2                	mov    %eax,%edx
80104cf0:	eb 19                	jmp    80104d0b <strncpy+0x2b>
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cf8:	83 c3 01             	add    $0x1,%ebx
80104cfb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104cff:	83 c2 01             	add    $0x1,%edx
80104d02:	84 c9                	test   %cl,%cl
80104d04:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d07:	74 09                	je     80104d12 <strncpy+0x32>
80104d09:	89 f1                	mov    %esi,%ecx
80104d0b:	85 c9                	test   %ecx,%ecx
80104d0d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104d10:	7f e6                	jg     80104cf8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d12:	31 c9                	xor    %ecx,%ecx
80104d14:	85 f6                	test   %esi,%esi
80104d16:	7e 17                	jle    80104d2f <strncpy+0x4f>
80104d18:	90                   	nop
80104d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104d20:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104d24:	89 f3                	mov    %esi,%ebx
80104d26:	83 c1 01             	add    $0x1,%ecx
80104d29:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104d2b:	85 db                	test   %ebx,%ebx
80104d2d:	7f f1                	jg     80104d20 <strncpy+0x40>
  return os;
}
80104d2f:	5b                   	pop    %ebx
80104d30:	5e                   	pop    %esi
80104d31:	5d                   	pop    %ebp
80104d32:	c3                   	ret    
80104d33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d48:	8b 45 08             	mov    0x8(%ebp),%eax
80104d4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104d4e:	85 c9                	test   %ecx,%ecx
80104d50:	7e 26                	jle    80104d78 <safestrcpy+0x38>
80104d52:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104d56:	89 c1                	mov    %eax,%ecx
80104d58:	eb 17                	jmp    80104d71 <safestrcpy+0x31>
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104d60:	83 c2 01             	add    $0x1,%edx
80104d63:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104d67:	83 c1 01             	add    $0x1,%ecx
80104d6a:	84 db                	test   %bl,%bl
80104d6c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104d6f:	74 04                	je     80104d75 <safestrcpy+0x35>
80104d71:	39 f2                	cmp    %esi,%edx
80104d73:	75 eb                	jne    80104d60 <safestrcpy+0x20>
    ;
  *s = 0;
80104d75:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104d78:	5b                   	pop    %ebx
80104d79:	5e                   	pop    %esi
80104d7a:	5d                   	pop    %ebp
80104d7b:	c3                   	ret    
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d80 <strlen>:

int
strlen(const char *s)
{
80104d80:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104d81:	31 c0                	xor    %eax,%eax
{
80104d83:	89 e5                	mov    %esp,%ebp
80104d85:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104d88:	80 3a 00             	cmpb   $0x0,(%edx)
80104d8b:	74 0c                	je     80104d99 <strlen+0x19>
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
80104d90:	83 c0 01             	add    $0x1,%eax
80104d93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104d97:	75 f7                	jne    80104d90 <strlen+0x10>
    ;
  return n;
}
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    

80104d9b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104d9b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104d9f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104da3:	55                   	push   %ebp
  pushl %ebx
80104da4:	53                   	push   %ebx
  pushl %esi
80104da5:	56                   	push   %esi
  pushl %edi
80104da6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104da7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104da9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104dab:	5f                   	pop    %edi
  popl %esi
80104dac:	5e                   	pop    %esi
  popl %ebx
80104dad:	5b                   	pop    %ebx
  popl %ebp
80104dae:	5d                   	pop    %ebp
  ret
80104daf:	c3                   	ret    

80104db0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	53                   	push   %ebx
80104db4:	83 ec 04             	sub    $0x4,%esp
80104db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104dba:	e8 61 ea ff ff       	call   80103820 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dbf:	8b 00                	mov    (%eax),%eax
80104dc1:	39 d8                	cmp    %ebx,%eax
80104dc3:	76 1b                	jbe    80104de0 <fetchint+0x30>
80104dc5:	8d 53 04             	lea    0x4(%ebx),%edx
80104dc8:	39 d0                	cmp    %edx,%eax
80104dca:	72 14                	jb     80104de0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dcf:	8b 13                	mov    (%ebx),%edx
80104dd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dd3:	31 c0                	xor    %eax,%eax
}
80104dd5:	83 c4 04             	add    $0x4,%esp
80104dd8:	5b                   	pop    %ebx
80104dd9:	5d                   	pop    %ebp
80104dda:	c3                   	ret    
80104ddb:	90                   	nop
80104ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104de5:	eb ee                	jmp    80104dd5 <fetchint+0x25>
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	53                   	push   %ebx
80104df4:	83 ec 04             	sub    $0x4,%esp
80104df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104dfa:	e8 21 ea ff ff       	call   80103820 <myproc>

  if(addr >= curproc->sz)
80104dff:	39 18                	cmp    %ebx,(%eax)
80104e01:	76 29                	jbe    80104e2c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104e06:	89 da                	mov    %ebx,%edx
80104e08:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104e0a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104e0c:	39 c3                	cmp    %eax,%ebx
80104e0e:	73 1c                	jae    80104e2c <fetchstr+0x3c>
    if(*s == 0)
80104e10:	80 3b 00             	cmpb   $0x0,(%ebx)
80104e13:	75 10                	jne    80104e25 <fetchstr+0x35>
80104e15:	eb 39                	jmp    80104e50 <fetchstr+0x60>
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e20:	80 3a 00             	cmpb   $0x0,(%edx)
80104e23:	74 1b                	je     80104e40 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104e25:	83 c2 01             	add    $0x1,%edx
80104e28:	39 d0                	cmp    %edx,%eax
80104e2a:	77 f4                	ja     80104e20 <fetchstr+0x30>
    return -1;
80104e2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104e31:	83 c4 04             	add    $0x4,%esp
80104e34:	5b                   	pop    %ebx
80104e35:	5d                   	pop    %ebp
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104e40:	83 c4 04             	add    $0x4,%esp
80104e43:	89 d0                	mov    %edx,%eax
80104e45:	29 d8                	sub    %ebx,%eax
80104e47:	5b                   	pop    %ebx
80104e48:	5d                   	pop    %ebp
80104e49:	c3                   	ret    
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104e50:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104e52:	eb dd                	jmp    80104e31 <fetchstr+0x41>
80104e54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e60 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e65:	e8 b6 e9 ff ff       	call   80103820 <myproc>
80104e6a:	8b 40 18             	mov    0x18(%eax),%eax
80104e6d:	8b 55 08             	mov    0x8(%ebp),%edx
80104e70:	8b 40 44             	mov    0x44(%eax),%eax
80104e73:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104e76:	e8 a5 e9 ff ff       	call   80103820 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e7b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104e7d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e80:	39 c6                	cmp    %eax,%esi
80104e82:	73 1c                	jae    80104ea0 <argint+0x40>
80104e84:	8d 53 08             	lea    0x8(%ebx),%edx
80104e87:	39 d0                	cmp    %edx,%eax
80104e89:	72 15                	jb     80104ea0 <argint+0x40>
  *ip = *(int*)(addr);
80104e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e8e:	8b 53 04             	mov    0x4(%ebx),%edx
80104e91:	89 10                	mov    %edx,(%eax)
  return 0;
80104e93:	31 c0                	xor    %eax,%eax
}
80104e95:	5b                   	pop    %ebx
80104e96:	5e                   	pop    %esi
80104e97:	5d                   	pop    %ebp
80104e98:	c3                   	ret    
80104e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ea5:	eb ee                	jmp    80104e95 <argint+0x35>
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
80104eb5:	83 ec 10             	sub    $0x10,%esp
80104eb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104ebb:	e8 60 e9 ff ff       	call   80103820 <myproc>
80104ec0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ec2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ec5:	83 ec 08             	sub    $0x8,%esp
80104ec8:	50                   	push   %eax
80104ec9:	ff 75 08             	pushl  0x8(%ebp)
80104ecc:	e8 8f ff ff ff       	call   80104e60 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ed1:	83 c4 10             	add    $0x10,%esp
80104ed4:	85 c0                	test   %eax,%eax
80104ed6:	78 28                	js     80104f00 <argptr+0x50>
80104ed8:	85 db                	test   %ebx,%ebx
80104eda:	78 24                	js     80104f00 <argptr+0x50>
80104edc:	8b 16                	mov    (%esi),%edx
80104ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee1:	39 c2                	cmp    %eax,%edx
80104ee3:	76 1b                	jbe    80104f00 <argptr+0x50>
80104ee5:	01 c3                	add    %eax,%ebx
80104ee7:	39 da                	cmp    %ebx,%edx
80104ee9:	72 15                	jb     80104f00 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104eeb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104eee:	89 02                	mov    %eax,(%edx)
  return 0;
80104ef0:	31 c0                	xor    %eax,%eax
}
80104ef2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ef5:	5b                   	pop    %ebx
80104ef6:	5e                   	pop    %esi
80104ef7:	5d                   	pop    %ebp
80104ef8:	c3                   	ret    
80104ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f05:	eb eb                	jmp    80104ef2 <argptr+0x42>
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f19:	50                   	push   %eax
80104f1a:	ff 75 08             	pushl  0x8(%ebp)
80104f1d:	e8 3e ff ff ff       	call   80104e60 <argint>
80104f22:	83 c4 10             	add    $0x10,%esp
80104f25:	85 c0                	test   %eax,%eax
80104f27:	78 17                	js     80104f40 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f29:	83 ec 08             	sub    $0x8,%esp
80104f2c:	ff 75 0c             	pushl  0xc(%ebp)
80104f2f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f32:	e8 b9 fe ff ff       	call   80104df0 <fetchstr>
80104f37:	83 c4 10             	add    $0x10,%esp
}
80104f3a:	c9                   	leave  
80104f3b:	c3                   	ret    
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f45:	c9                   	leave  
80104f46:	c3                   	ret    
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <syscall>:
[SYS_sigret]      sys_sigret
};

void
syscall(void)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
80104f54:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104f57:	e8 c4 e8 ff ff       	call   80103820 <myproc>
80104f5c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104f5e:	8b 40 18             	mov    0x18(%eax),%eax
80104f61:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104f64:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f67:	83 fa 17             	cmp    $0x17,%edx
80104f6a:	77 1c                	ja     80104f88 <syscall+0x38>
80104f6c:	8b 14 85 e0 7e 10 80 	mov    -0x7fef8120(,%eax,4),%edx
80104f73:	85 d2                	test   %edx,%edx
80104f75:	74 11                	je     80104f88 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104f77:	ff d2                	call   *%edx
80104f79:	8b 53 18             	mov    0x18(%ebx),%edx
80104f7c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104f7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f82:	c9                   	leave  
80104f83:	c3                   	ret    
80104f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104f88:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104f89:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104f8c:	50                   	push   %eax
80104f8d:	ff 73 10             	pushl  0x10(%ebx)
80104f90:	68 c1 7e 10 80       	push   $0x80107ec1
80104f95:	e8 c6 b6 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104f9a:	8b 43 18             	mov    0x18(%ebx),%eax
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104fa7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104faa:	c9                   	leave  
80104fab:	c3                   	ret    
80104fac:	66 90                	xchg   %ax,%ax
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	57                   	push   %edi
80104fb4:	56                   	push   %esi
80104fb5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104fb6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104fb9:	83 ec 34             	sub    $0x34,%esp
80104fbc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104fbf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104fc2:	56                   	push   %esi
80104fc3:	50                   	push   %eax
{
80104fc4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104fc7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104fca:	e8 91 cf ff ff       	call   80101f60 <nameiparent>
80104fcf:	83 c4 10             	add    $0x10,%esp
80104fd2:	85 c0                	test   %eax,%eax
80104fd4:	0f 84 46 01 00 00    	je     80105120 <create+0x170>
    return 0;
  ilock(dp);
80104fda:	83 ec 0c             	sub    $0xc,%esp
80104fdd:	89 c3                	mov    %eax,%ebx
80104fdf:	50                   	push   %eax
80104fe0:	e8 fb c6 ff ff       	call   801016e0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104fe5:	83 c4 0c             	add    $0xc,%esp
80104fe8:	6a 00                	push   $0x0
80104fea:	56                   	push   %esi
80104feb:	53                   	push   %ebx
80104fec:	e8 1f cc ff ff       	call   80101c10 <dirlookup>
80104ff1:	83 c4 10             	add    $0x10,%esp
80104ff4:	85 c0                	test   %eax,%eax
80104ff6:	89 c7                	mov    %eax,%edi
80104ff8:	74 36                	je     80105030 <create+0x80>
    iunlockput(dp);
80104ffa:	83 ec 0c             	sub    $0xc,%esp
80104ffd:	53                   	push   %ebx
80104ffe:	e8 6d c9 ff ff       	call   80101970 <iunlockput>
    ilock(ip);
80105003:	89 3c 24             	mov    %edi,(%esp)
80105006:	e8 d5 c6 ff ff       	call   801016e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010500b:	83 c4 10             	add    $0x10,%esp
8010500e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105013:	0f 85 97 00 00 00    	jne    801050b0 <create+0x100>
80105019:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
8010501e:	0f 85 8c 00 00 00    	jne    801050b0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105024:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105027:	89 f8                	mov    %edi,%eax
80105029:	5b                   	pop    %ebx
8010502a:	5e                   	pop    %esi
8010502b:	5f                   	pop    %edi
8010502c:	5d                   	pop    %ebp
8010502d:	c3                   	ret    
8010502e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80105030:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105034:	83 ec 08             	sub    $0x8,%esp
80105037:	50                   	push   %eax
80105038:	ff 33                	pushl  (%ebx)
8010503a:	e8 31 c5 ff ff       	call   80101570 <ialloc>
8010503f:	83 c4 10             	add    $0x10,%esp
80105042:	85 c0                	test   %eax,%eax
80105044:	89 c7                	mov    %eax,%edi
80105046:	0f 84 e8 00 00 00    	je     80105134 <create+0x184>
  ilock(ip);
8010504c:	83 ec 0c             	sub    $0xc,%esp
8010504f:	50                   	push   %eax
80105050:	e8 8b c6 ff ff       	call   801016e0 <ilock>
  ip->major = major;
80105055:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105059:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010505d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105061:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105065:	b8 01 00 00 00       	mov    $0x1,%eax
8010506a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010506e:	89 3c 24             	mov    %edi,(%esp)
80105071:	e8 ba c5 ff ff       	call   80101630 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105076:	83 c4 10             	add    $0x10,%esp
80105079:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010507e:	74 50                	je     801050d0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105080:	83 ec 04             	sub    $0x4,%esp
80105083:	ff 77 04             	pushl  0x4(%edi)
80105086:	56                   	push   %esi
80105087:	53                   	push   %ebx
80105088:	e8 f3 cd ff ff       	call   80101e80 <dirlink>
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 c0                	test   %eax,%eax
80105092:	0f 88 8f 00 00 00    	js     80105127 <create+0x177>
  iunlockput(dp);
80105098:	83 ec 0c             	sub    $0xc,%esp
8010509b:	53                   	push   %ebx
8010509c:	e8 cf c8 ff ff       	call   80101970 <iunlockput>
  return ip;
801050a1:	83 c4 10             	add    $0x10,%esp
}
801050a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050a7:	89 f8                	mov    %edi,%eax
801050a9:	5b                   	pop    %ebx
801050aa:	5e                   	pop    %esi
801050ab:	5f                   	pop    %edi
801050ac:	5d                   	pop    %ebp
801050ad:	c3                   	ret    
801050ae:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	57                   	push   %edi
    return 0;
801050b4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801050b6:	e8 b5 c8 ff ff       	call   80101970 <iunlockput>
    return 0;
801050bb:	83 c4 10             	add    $0x10,%esp
}
801050be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050c1:	89 f8                	mov    %edi,%eax
801050c3:	5b                   	pop    %ebx
801050c4:	5e                   	pop    %esi
801050c5:	5f                   	pop    %edi
801050c6:	5d                   	pop    %ebp
801050c7:	c3                   	ret    
801050c8:	90                   	nop
801050c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801050d0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801050d5:	83 ec 0c             	sub    $0xc,%esp
801050d8:	53                   	push   %ebx
801050d9:	e8 52 c5 ff ff       	call   80101630 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801050de:	83 c4 0c             	add    $0xc,%esp
801050e1:	ff 77 04             	pushl  0x4(%edi)
801050e4:	68 60 7f 10 80       	push   $0x80107f60
801050e9:	57                   	push   %edi
801050ea:	e8 91 cd ff ff       	call   80101e80 <dirlink>
801050ef:	83 c4 10             	add    $0x10,%esp
801050f2:	85 c0                	test   %eax,%eax
801050f4:	78 1c                	js     80105112 <create+0x162>
801050f6:	83 ec 04             	sub    $0x4,%esp
801050f9:	ff 73 04             	pushl  0x4(%ebx)
801050fc:	68 5f 7f 10 80       	push   $0x80107f5f
80105101:	57                   	push   %edi
80105102:	e8 79 cd ff ff       	call   80101e80 <dirlink>
80105107:	83 c4 10             	add    $0x10,%esp
8010510a:	85 c0                	test   %eax,%eax
8010510c:	0f 89 6e ff ff ff    	jns    80105080 <create+0xd0>
      panic("create dots");
80105112:	83 ec 0c             	sub    $0xc,%esp
80105115:	68 53 7f 10 80       	push   $0x80107f53
8010511a:	e8 71 b2 ff ff       	call   80100390 <panic>
8010511f:	90                   	nop
    return 0;
80105120:	31 ff                	xor    %edi,%edi
80105122:	e9 fd fe ff ff       	jmp    80105024 <create+0x74>
    panic("create: dirlink");
80105127:	83 ec 0c             	sub    $0xc,%esp
8010512a:	68 62 7f 10 80       	push   $0x80107f62
8010512f:	e8 5c b2 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105134:	83 ec 0c             	sub    $0xc,%esp
80105137:	68 44 7f 10 80       	push   $0x80107f44
8010513c:	e8 4f b2 ff ff       	call   80100390 <panic>
80105141:	eb 0d                	jmp    80105150 <argfd.constprop.0>
80105143:	90                   	nop
80105144:	90                   	nop
80105145:	90                   	nop
80105146:	90                   	nop
80105147:	90                   	nop
80105148:	90                   	nop
80105149:	90                   	nop
8010514a:	90                   	nop
8010514b:	90                   	nop
8010514c:	90                   	nop
8010514d:	90                   	nop
8010514e:	90                   	nop
8010514f:	90                   	nop

80105150 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	56                   	push   %esi
80105154:	53                   	push   %ebx
80105155:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105157:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010515a:	89 d6                	mov    %edx,%esi
8010515c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010515f:	50                   	push   %eax
80105160:	6a 00                	push   $0x0
80105162:	e8 f9 fc ff ff       	call   80104e60 <argint>
80105167:	83 c4 10             	add    $0x10,%esp
8010516a:	85 c0                	test   %eax,%eax
8010516c:	78 2a                	js     80105198 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010516e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105172:	77 24                	ja     80105198 <argfd.constprop.0+0x48>
80105174:	e8 a7 e6 ff ff       	call   80103820 <myproc>
80105179:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010517c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105180:	85 c0                	test   %eax,%eax
80105182:	74 14                	je     80105198 <argfd.constprop.0+0x48>
  if(pfd)
80105184:	85 db                	test   %ebx,%ebx
80105186:	74 02                	je     8010518a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105188:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010518a:	89 06                	mov    %eax,(%esi)
  return 0;
8010518c:	31 c0                	xor    %eax,%eax
}
8010518e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105191:	5b                   	pop    %ebx
80105192:	5e                   	pop    %esi
80105193:	5d                   	pop    %ebp
80105194:	c3                   	ret    
80105195:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519d:	eb ef                	jmp    8010518e <argfd.constprop.0+0x3e>
8010519f:	90                   	nop

801051a0 <sys_dup>:
{
801051a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801051a1:	31 c0                	xor    %eax,%eax
{
801051a3:	89 e5                	mov    %esp,%ebp
801051a5:	56                   	push   %esi
801051a6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801051a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801051aa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801051ad:	e8 9e ff ff ff       	call   80105150 <argfd.constprop.0>
801051b2:	85 c0                	test   %eax,%eax
801051b4:	78 42                	js     801051f8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801051b6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801051b9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801051bb:	e8 60 e6 ff ff       	call   80103820 <myproc>
801051c0:	eb 0e                	jmp    801051d0 <sys_dup+0x30>
801051c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801051c8:	83 c3 01             	add    $0x1,%ebx
801051cb:	83 fb 10             	cmp    $0x10,%ebx
801051ce:	74 28                	je     801051f8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801051d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051d4:	85 d2                	test   %edx,%edx
801051d6:	75 f0                	jne    801051c8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801051d8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801051dc:	83 ec 0c             	sub    $0xc,%esp
801051df:	ff 75 f4             	pushl  -0xc(%ebp)
801051e2:	e8 69 bc ff ff       	call   80100e50 <filedup>
  return fd;
801051e7:	83 c4 10             	add    $0x10,%esp
}
801051ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ed:	89 d8                	mov    %ebx,%eax
801051ef:	5b                   	pop    %ebx
801051f0:	5e                   	pop    %esi
801051f1:	5d                   	pop    %ebp
801051f2:	c3                   	ret    
801051f3:	90                   	nop
801051f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105200:	89 d8                	mov    %ebx,%eax
80105202:	5b                   	pop    %ebx
80105203:	5e                   	pop    %esi
80105204:	5d                   	pop    %ebp
80105205:	c3                   	ret    
80105206:	8d 76 00             	lea    0x0(%esi),%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105210 <sys_read>:
{
80105210:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105211:	31 c0                	xor    %eax,%eax
{
80105213:	89 e5                	mov    %esp,%ebp
80105215:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105218:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010521b:	e8 30 ff ff ff       	call   80105150 <argfd.constprop.0>
80105220:	85 c0                	test   %eax,%eax
80105222:	78 4c                	js     80105270 <sys_read+0x60>
80105224:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105227:	83 ec 08             	sub    $0x8,%esp
8010522a:	50                   	push   %eax
8010522b:	6a 02                	push   $0x2
8010522d:	e8 2e fc ff ff       	call   80104e60 <argint>
80105232:	83 c4 10             	add    $0x10,%esp
80105235:	85 c0                	test   %eax,%eax
80105237:	78 37                	js     80105270 <sys_read+0x60>
80105239:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010523c:	83 ec 04             	sub    $0x4,%esp
8010523f:	ff 75 f0             	pushl  -0x10(%ebp)
80105242:	50                   	push   %eax
80105243:	6a 01                	push   $0x1
80105245:	e8 66 fc ff ff       	call   80104eb0 <argptr>
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	85 c0                	test   %eax,%eax
8010524f:	78 1f                	js     80105270 <sys_read+0x60>
  return fileread(f, p, n);
80105251:	83 ec 04             	sub    $0x4,%esp
80105254:	ff 75 f0             	pushl  -0x10(%ebp)
80105257:	ff 75 f4             	pushl  -0xc(%ebp)
8010525a:	ff 75 ec             	pushl  -0x14(%ebp)
8010525d:	e8 5e bd ff ff       	call   80100fc0 <fileread>
80105262:	83 c4 10             	add    $0x10,%esp
}
80105265:	c9                   	leave  
80105266:	c3                   	ret    
80105267:	89 f6                	mov    %esi,%esi
80105269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <sys_write>:
{
80105280:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105281:	31 c0                	xor    %eax,%eax
{
80105283:	89 e5                	mov    %esp,%ebp
80105285:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105288:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010528b:	e8 c0 fe ff ff       	call   80105150 <argfd.constprop.0>
80105290:	85 c0                	test   %eax,%eax
80105292:	78 4c                	js     801052e0 <sys_write+0x60>
80105294:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105297:	83 ec 08             	sub    $0x8,%esp
8010529a:	50                   	push   %eax
8010529b:	6a 02                	push   $0x2
8010529d:	e8 be fb ff ff       	call   80104e60 <argint>
801052a2:	83 c4 10             	add    $0x10,%esp
801052a5:	85 c0                	test   %eax,%eax
801052a7:	78 37                	js     801052e0 <sys_write+0x60>
801052a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ac:	83 ec 04             	sub    $0x4,%esp
801052af:	ff 75 f0             	pushl  -0x10(%ebp)
801052b2:	50                   	push   %eax
801052b3:	6a 01                	push   $0x1
801052b5:	e8 f6 fb ff ff       	call   80104eb0 <argptr>
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	85 c0                	test   %eax,%eax
801052bf:	78 1f                	js     801052e0 <sys_write+0x60>
  return filewrite(f, p, n);
801052c1:	83 ec 04             	sub    $0x4,%esp
801052c4:	ff 75 f0             	pushl  -0x10(%ebp)
801052c7:	ff 75 f4             	pushl  -0xc(%ebp)
801052ca:	ff 75 ec             	pushl  -0x14(%ebp)
801052cd:	e8 7e bd ff ff       	call   80101050 <filewrite>
801052d2:	83 c4 10             	add    $0x10,%esp
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052f0 <sys_close>:
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801052f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052fc:	e8 4f fe ff ff       	call   80105150 <argfd.constprop.0>
80105301:	85 c0                	test   %eax,%eax
80105303:	78 2b                	js     80105330 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105305:	e8 16 e5 ff ff       	call   80103820 <myproc>
8010530a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010530d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105310:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105317:	00 
  fileclose(f);
80105318:	ff 75 f4             	pushl  -0xc(%ebp)
8010531b:	e8 80 bb ff ff       	call   80100ea0 <fileclose>
  return 0;
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	31 c0                	xor    %eax,%eax
}
80105325:	c9                   	leave  
80105326:	c3                   	ret    
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    
80105337:	89 f6                	mov    %esi,%esi
80105339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105340 <sys_fstat>:
{
80105340:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105341:	31 c0                	xor    %eax,%eax
{
80105343:	89 e5                	mov    %esp,%ebp
80105345:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105348:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010534b:	e8 00 fe ff ff       	call   80105150 <argfd.constprop.0>
80105350:	85 c0                	test   %eax,%eax
80105352:	78 2c                	js     80105380 <sys_fstat+0x40>
80105354:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105357:	83 ec 04             	sub    $0x4,%esp
8010535a:	6a 14                	push   $0x14
8010535c:	50                   	push   %eax
8010535d:	6a 01                	push   $0x1
8010535f:	e8 4c fb ff ff       	call   80104eb0 <argptr>
80105364:	83 c4 10             	add    $0x10,%esp
80105367:	85 c0                	test   %eax,%eax
80105369:	78 15                	js     80105380 <sys_fstat+0x40>
  return filestat(f, st);
8010536b:	83 ec 08             	sub    $0x8,%esp
8010536e:	ff 75 f4             	pushl  -0xc(%ebp)
80105371:	ff 75 f0             	pushl  -0x10(%ebp)
80105374:	e8 f7 bb ff ff       	call   80100f70 <filestat>
80105379:	83 c4 10             	add    $0x10,%esp
}
8010537c:	c9                   	leave  
8010537d:	c3                   	ret    
8010537e:	66 90                	xchg   %ax,%ax
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105385:	c9                   	leave  
80105386:	c3                   	ret    
80105387:	89 f6                	mov    %esi,%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <sys_link>:
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105396:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105399:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010539c:	50                   	push   %eax
8010539d:	6a 00                	push   $0x0
8010539f:	e8 6c fb ff ff       	call   80104f10 <argstr>
801053a4:	83 c4 10             	add    $0x10,%esp
801053a7:	85 c0                	test   %eax,%eax
801053a9:	0f 88 fb 00 00 00    	js     801054aa <sys_link+0x11a>
801053af:	8d 45 d0             	lea    -0x30(%ebp),%eax
801053b2:	83 ec 08             	sub    $0x8,%esp
801053b5:	50                   	push   %eax
801053b6:	6a 01                	push   $0x1
801053b8:	e8 53 fb ff ff       	call   80104f10 <argstr>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	0f 88 e2 00 00 00    	js     801054aa <sys_link+0x11a>
  begin_op();
801053c8:	e8 33 d8 ff ff       	call   80102c00 <begin_op>
  if((ip = namei(old)) == 0){
801053cd:	83 ec 0c             	sub    $0xc,%esp
801053d0:	ff 75 d4             	pushl  -0x2c(%ebp)
801053d3:	e8 68 cb ff ff       	call   80101f40 <namei>
801053d8:	83 c4 10             	add    $0x10,%esp
801053db:	85 c0                	test   %eax,%eax
801053dd:	89 c3                	mov    %eax,%ebx
801053df:	0f 84 ea 00 00 00    	je     801054cf <sys_link+0x13f>
  ilock(ip);
801053e5:	83 ec 0c             	sub    $0xc,%esp
801053e8:	50                   	push   %eax
801053e9:	e8 f2 c2 ff ff       	call   801016e0 <ilock>
  if(ip->type == T_DIR){
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053f6:	0f 84 bb 00 00 00    	je     801054b7 <sys_link+0x127>
  ip->nlink++;
801053fc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105401:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105404:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105407:	53                   	push   %ebx
80105408:	e8 23 c2 ff ff       	call   80101630 <iupdate>
  iunlock(ip);
8010540d:	89 1c 24             	mov    %ebx,(%esp)
80105410:	e8 ab c3 ff ff       	call   801017c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105415:	58                   	pop    %eax
80105416:	5a                   	pop    %edx
80105417:	57                   	push   %edi
80105418:	ff 75 d0             	pushl  -0x30(%ebp)
8010541b:	e8 40 cb ff ff       	call   80101f60 <nameiparent>
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	85 c0                	test   %eax,%eax
80105425:	89 c6                	mov    %eax,%esi
80105427:	74 5b                	je     80105484 <sys_link+0xf4>
  ilock(dp);
80105429:	83 ec 0c             	sub    $0xc,%esp
8010542c:	50                   	push   %eax
8010542d:	e8 ae c2 ff ff       	call   801016e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105432:	83 c4 10             	add    $0x10,%esp
80105435:	8b 03                	mov    (%ebx),%eax
80105437:	39 06                	cmp    %eax,(%esi)
80105439:	75 3d                	jne    80105478 <sys_link+0xe8>
8010543b:	83 ec 04             	sub    $0x4,%esp
8010543e:	ff 73 04             	pushl  0x4(%ebx)
80105441:	57                   	push   %edi
80105442:	56                   	push   %esi
80105443:	e8 38 ca ff ff       	call   80101e80 <dirlink>
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	85 c0                	test   %eax,%eax
8010544d:	78 29                	js     80105478 <sys_link+0xe8>
  iunlockput(dp);
8010544f:	83 ec 0c             	sub    $0xc,%esp
80105452:	56                   	push   %esi
80105453:	e8 18 c5 ff ff       	call   80101970 <iunlockput>
  iput(ip);
80105458:	89 1c 24             	mov    %ebx,(%esp)
8010545b:	e8 b0 c3 ff ff       	call   80101810 <iput>
  end_op();
80105460:	e8 0b d8 ff ff       	call   80102c70 <end_op>
  return 0;
80105465:	83 c4 10             	add    $0x10,%esp
80105468:	31 c0                	xor    %eax,%eax
}
8010546a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010546d:	5b                   	pop    %ebx
8010546e:	5e                   	pop    %esi
8010546f:	5f                   	pop    %edi
80105470:	5d                   	pop    %ebp
80105471:	c3                   	ret    
80105472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	56                   	push   %esi
8010547c:	e8 ef c4 ff ff       	call   80101970 <iunlockput>
    goto bad;
80105481:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105484:	83 ec 0c             	sub    $0xc,%esp
80105487:	53                   	push   %ebx
80105488:	e8 53 c2 ff ff       	call   801016e0 <ilock>
  ip->nlink--;
8010548d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105492:	89 1c 24             	mov    %ebx,(%esp)
80105495:	e8 96 c1 ff ff       	call   80101630 <iupdate>
  iunlockput(ip);
8010549a:	89 1c 24             	mov    %ebx,(%esp)
8010549d:	e8 ce c4 ff ff       	call   80101970 <iunlockput>
  end_op();
801054a2:	e8 c9 d7 ff ff       	call   80102c70 <end_op>
  return -1;
801054a7:	83 c4 10             	add    $0x10,%esp
}
801054aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801054ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054b2:	5b                   	pop    %ebx
801054b3:	5e                   	pop    %esi
801054b4:	5f                   	pop    %edi
801054b5:	5d                   	pop    %ebp
801054b6:	c3                   	ret    
    iunlockput(ip);
801054b7:	83 ec 0c             	sub    $0xc,%esp
801054ba:	53                   	push   %ebx
801054bb:	e8 b0 c4 ff ff       	call   80101970 <iunlockput>
    end_op();
801054c0:	e8 ab d7 ff ff       	call   80102c70 <end_op>
    return -1;
801054c5:	83 c4 10             	add    $0x10,%esp
801054c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054cd:	eb 9b                	jmp    8010546a <sys_link+0xda>
    end_op();
801054cf:	e8 9c d7 ff ff       	call   80102c70 <end_op>
    return -1;
801054d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d9:	eb 8f                	jmp    8010546a <sys_link+0xda>
801054db:	90                   	nop
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_unlink>:
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	57                   	push   %edi
801054e4:	56                   	push   %esi
801054e5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801054e6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801054e9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801054ec:	50                   	push   %eax
801054ed:	6a 00                	push   $0x0
801054ef:	e8 1c fa ff ff       	call   80104f10 <argstr>
801054f4:	83 c4 10             	add    $0x10,%esp
801054f7:	85 c0                	test   %eax,%eax
801054f9:	0f 88 77 01 00 00    	js     80105676 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801054ff:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105502:	e8 f9 d6 ff ff       	call   80102c00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105507:	83 ec 08             	sub    $0x8,%esp
8010550a:	53                   	push   %ebx
8010550b:	ff 75 c0             	pushl  -0x40(%ebp)
8010550e:	e8 4d ca ff ff       	call   80101f60 <nameiparent>
80105513:	83 c4 10             	add    $0x10,%esp
80105516:	85 c0                	test   %eax,%eax
80105518:	89 c6                	mov    %eax,%esi
8010551a:	0f 84 60 01 00 00    	je     80105680 <sys_unlink+0x1a0>
  ilock(dp);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	50                   	push   %eax
80105524:	e8 b7 c1 ff ff       	call   801016e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105529:	58                   	pop    %eax
8010552a:	5a                   	pop    %edx
8010552b:	68 60 7f 10 80       	push   $0x80107f60
80105530:	53                   	push   %ebx
80105531:	e8 ba c6 ff ff       	call   80101bf0 <namecmp>
80105536:	83 c4 10             	add    $0x10,%esp
80105539:	85 c0                	test   %eax,%eax
8010553b:	0f 84 03 01 00 00    	je     80105644 <sys_unlink+0x164>
80105541:	83 ec 08             	sub    $0x8,%esp
80105544:	68 5f 7f 10 80       	push   $0x80107f5f
80105549:	53                   	push   %ebx
8010554a:	e8 a1 c6 ff ff       	call   80101bf0 <namecmp>
8010554f:	83 c4 10             	add    $0x10,%esp
80105552:	85 c0                	test   %eax,%eax
80105554:	0f 84 ea 00 00 00    	je     80105644 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010555a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010555d:	83 ec 04             	sub    $0x4,%esp
80105560:	50                   	push   %eax
80105561:	53                   	push   %ebx
80105562:	56                   	push   %esi
80105563:	e8 a8 c6 ff ff       	call   80101c10 <dirlookup>
80105568:	83 c4 10             	add    $0x10,%esp
8010556b:	85 c0                	test   %eax,%eax
8010556d:	89 c3                	mov    %eax,%ebx
8010556f:	0f 84 cf 00 00 00    	je     80105644 <sys_unlink+0x164>
  ilock(ip);
80105575:	83 ec 0c             	sub    $0xc,%esp
80105578:	50                   	push   %eax
80105579:	e8 62 c1 ff ff       	call   801016e0 <ilock>
  if(ip->nlink < 1)
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105586:	0f 8e 10 01 00 00    	jle    8010569c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010558c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105591:	74 6d                	je     80105600 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105593:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105596:	83 ec 04             	sub    $0x4,%esp
80105599:	6a 10                	push   $0x10
8010559b:	6a 00                	push   $0x0
8010559d:	50                   	push   %eax
8010559e:	e8 bd f5 ff ff       	call   80104b60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801055a6:	6a 10                	push   $0x10
801055a8:	ff 75 c4             	pushl  -0x3c(%ebp)
801055ab:	50                   	push   %eax
801055ac:	56                   	push   %esi
801055ad:	e8 0e c5 ff ff       	call   80101ac0 <writei>
801055b2:	83 c4 20             	add    $0x20,%esp
801055b5:	83 f8 10             	cmp    $0x10,%eax
801055b8:	0f 85 eb 00 00 00    	jne    801056a9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801055be:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055c3:	0f 84 97 00 00 00    	je     80105660 <sys_unlink+0x180>
  iunlockput(dp);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	56                   	push   %esi
801055cd:	e8 9e c3 ff ff       	call   80101970 <iunlockput>
  ip->nlink--;
801055d2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055d7:	89 1c 24             	mov    %ebx,(%esp)
801055da:	e8 51 c0 ff ff       	call   80101630 <iupdate>
  iunlockput(ip);
801055df:	89 1c 24             	mov    %ebx,(%esp)
801055e2:	e8 89 c3 ff ff       	call   80101970 <iunlockput>
  end_op();
801055e7:	e8 84 d6 ff ff       	call   80102c70 <end_op>
  return 0;
801055ec:	83 c4 10             	add    $0x10,%esp
801055ef:	31 c0                	xor    %eax,%eax
}
801055f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055f4:	5b                   	pop    %ebx
801055f5:	5e                   	pop    %esi
801055f6:	5f                   	pop    %edi
801055f7:	5d                   	pop    %ebp
801055f8:	c3                   	ret    
801055f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105600:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105604:	76 8d                	jbe    80105593 <sys_unlink+0xb3>
80105606:	bf 20 00 00 00       	mov    $0x20,%edi
8010560b:	eb 0f                	jmp    8010561c <sys_unlink+0x13c>
8010560d:	8d 76 00             	lea    0x0(%esi),%esi
80105610:	83 c7 10             	add    $0x10,%edi
80105613:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105616:	0f 83 77 ff ff ff    	jae    80105593 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010561c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010561f:	6a 10                	push   $0x10
80105621:	57                   	push   %edi
80105622:	50                   	push   %eax
80105623:	53                   	push   %ebx
80105624:	e8 97 c3 ff ff       	call   801019c0 <readi>
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	83 f8 10             	cmp    $0x10,%eax
8010562f:	75 5e                	jne    8010568f <sys_unlink+0x1af>
    if(de.inum != 0)
80105631:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105636:	74 d8                	je     80105610 <sys_unlink+0x130>
    iunlockput(ip);
80105638:	83 ec 0c             	sub    $0xc,%esp
8010563b:	53                   	push   %ebx
8010563c:	e8 2f c3 ff ff       	call   80101970 <iunlockput>
    goto bad;
80105641:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105644:	83 ec 0c             	sub    $0xc,%esp
80105647:	56                   	push   %esi
80105648:	e8 23 c3 ff ff       	call   80101970 <iunlockput>
  end_op();
8010564d:	e8 1e d6 ff ff       	call   80102c70 <end_op>
  return -1;
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565a:	eb 95                	jmp    801055f1 <sys_unlink+0x111>
8010565c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105660:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105665:	83 ec 0c             	sub    $0xc,%esp
80105668:	56                   	push   %esi
80105669:	e8 c2 bf ff ff       	call   80101630 <iupdate>
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	e9 53 ff ff ff       	jmp    801055c9 <sys_unlink+0xe9>
    return -1;
80105676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010567b:	e9 71 ff ff ff       	jmp    801055f1 <sys_unlink+0x111>
    end_op();
80105680:	e8 eb d5 ff ff       	call   80102c70 <end_op>
    return -1;
80105685:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568a:	e9 62 ff ff ff       	jmp    801055f1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010568f:	83 ec 0c             	sub    $0xc,%esp
80105692:	68 84 7f 10 80       	push   $0x80107f84
80105697:	e8 f4 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010569c:	83 ec 0c             	sub    $0xc,%esp
8010569f:	68 72 7f 10 80       	push   $0x80107f72
801056a4:	e8 e7 ac ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801056a9:	83 ec 0c             	sub    $0xc,%esp
801056ac:	68 96 7f 10 80       	push   $0x80107f96
801056b1:	e8 da ac ff ff       	call   80100390 <panic>
801056b6:	8d 76 00             	lea    0x0(%esi),%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056c0 <sys_open>:

int
sys_open(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
801056c5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801056c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801056cc:	50                   	push   %eax
801056cd:	6a 00                	push   $0x0
801056cf:	e8 3c f8 ff ff       	call   80104f10 <argstr>
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
801056d9:	0f 88 1d 01 00 00    	js     801057fc <sys_open+0x13c>
801056df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056e2:	83 ec 08             	sub    $0x8,%esp
801056e5:	50                   	push   %eax
801056e6:	6a 01                	push   $0x1
801056e8:	e8 73 f7 ff ff       	call   80104e60 <argint>
801056ed:	83 c4 10             	add    $0x10,%esp
801056f0:	85 c0                	test   %eax,%eax
801056f2:	0f 88 04 01 00 00    	js     801057fc <sys_open+0x13c>
    return -1;

  begin_op();
801056f8:	e8 03 d5 ff ff       	call   80102c00 <begin_op>

  if(omode & O_CREATE){
801056fd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105701:	0f 85 a9 00 00 00    	jne    801057b0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105707:	83 ec 0c             	sub    $0xc,%esp
8010570a:	ff 75 e0             	pushl  -0x20(%ebp)
8010570d:	e8 2e c8 ff ff       	call   80101f40 <namei>
80105712:	83 c4 10             	add    $0x10,%esp
80105715:	85 c0                	test   %eax,%eax
80105717:	89 c6                	mov    %eax,%esi
80105719:	0f 84 b2 00 00 00    	je     801057d1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010571f:	83 ec 0c             	sub    $0xc,%esp
80105722:	50                   	push   %eax
80105723:	e8 b8 bf ff ff       	call   801016e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105728:	83 c4 10             	add    $0x10,%esp
8010572b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105730:	0f 84 aa 00 00 00    	je     801057e0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105736:	e8 a5 b6 ff ff       	call   80100de0 <filealloc>
8010573b:	85 c0                	test   %eax,%eax
8010573d:	89 c7                	mov    %eax,%edi
8010573f:	0f 84 a6 00 00 00    	je     801057eb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105745:	e8 d6 e0 ff ff       	call   80103820 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010574a:	31 db                	xor    %ebx,%ebx
8010574c:	eb 0e                	jmp    8010575c <sys_open+0x9c>
8010574e:	66 90                	xchg   %ax,%ax
80105750:	83 c3 01             	add    $0x1,%ebx
80105753:	83 fb 10             	cmp    $0x10,%ebx
80105756:	0f 84 ac 00 00 00    	je     80105808 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010575c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105760:	85 d2                	test   %edx,%edx
80105762:	75 ec                	jne    80105750 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105764:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105767:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010576b:	56                   	push   %esi
8010576c:	e8 4f c0 ff ff       	call   801017c0 <iunlock>
  end_op();
80105771:	e8 fa d4 ff ff       	call   80102c70 <end_op>

  f->type = FD_INODE;
80105776:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010577c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010577f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105782:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105785:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010578c:	89 d0                	mov    %edx,%eax
8010578e:	f7 d0                	not    %eax
80105790:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105793:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105796:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105799:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010579d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057a0:	89 d8                	mov    %ebx,%eax
801057a2:	5b                   	pop    %ebx
801057a3:	5e                   	pop    %esi
801057a4:	5f                   	pop    %edi
801057a5:	5d                   	pop    %ebp
801057a6:	c3                   	ret    
801057a7:	89 f6                	mov    %esi,%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801057b6:	31 c9                	xor    %ecx,%ecx
801057b8:	6a 00                	push   $0x0
801057ba:	ba 02 00 00 00       	mov    $0x2,%edx
801057bf:	e8 ec f7 ff ff       	call   80104fb0 <create>
    if(ip == 0){
801057c4:	83 c4 10             	add    $0x10,%esp
801057c7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801057c9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801057cb:	0f 85 65 ff ff ff    	jne    80105736 <sys_open+0x76>
      end_op();
801057d1:	e8 9a d4 ff ff       	call   80102c70 <end_op>
      return -1;
801057d6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801057db:	eb c0                	jmp    8010579d <sys_open+0xdd>
801057dd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801057e0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801057e3:	85 c9                	test   %ecx,%ecx
801057e5:	0f 84 4b ff ff ff    	je     80105736 <sys_open+0x76>
    iunlockput(ip);
801057eb:	83 ec 0c             	sub    $0xc,%esp
801057ee:	56                   	push   %esi
801057ef:	e8 7c c1 ff ff       	call   80101970 <iunlockput>
    end_op();
801057f4:	e8 77 d4 ff ff       	call   80102c70 <end_op>
    return -1;
801057f9:	83 c4 10             	add    $0x10,%esp
801057fc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105801:	eb 9a                	jmp    8010579d <sys_open+0xdd>
80105803:	90                   	nop
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105808:	83 ec 0c             	sub    $0xc,%esp
8010580b:	57                   	push   %edi
8010580c:	e8 8f b6 ff ff       	call   80100ea0 <fileclose>
80105811:	83 c4 10             	add    $0x10,%esp
80105814:	eb d5                	jmp    801057eb <sys_open+0x12b>
80105816:	8d 76 00             	lea    0x0(%esi),%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105820 <sys_mkdir>:

int
sys_mkdir(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105826:	e8 d5 d3 ff ff       	call   80102c00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010582b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010582e:	83 ec 08             	sub    $0x8,%esp
80105831:	50                   	push   %eax
80105832:	6a 00                	push   $0x0
80105834:	e8 d7 f6 ff ff       	call   80104f10 <argstr>
80105839:	83 c4 10             	add    $0x10,%esp
8010583c:	85 c0                	test   %eax,%eax
8010583e:	78 30                	js     80105870 <sys_mkdir+0x50>
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105846:	31 c9                	xor    %ecx,%ecx
80105848:	6a 00                	push   $0x0
8010584a:	ba 01 00 00 00       	mov    $0x1,%edx
8010584f:	e8 5c f7 ff ff       	call   80104fb0 <create>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	74 15                	je     80105870 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010585b:	83 ec 0c             	sub    $0xc,%esp
8010585e:	50                   	push   %eax
8010585f:	e8 0c c1 ff ff       	call   80101970 <iunlockput>
  end_op();
80105864:	e8 07 d4 ff ff       	call   80102c70 <end_op>
  return 0;
80105869:	83 c4 10             	add    $0x10,%esp
8010586c:	31 c0                	xor    %eax,%eax
}
8010586e:	c9                   	leave  
8010586f:	c3                   	ret    
    end_op();
80105870:	e8 fb d3 ff ff       	call   80102c70 <end_op>
    return -1;
80105875:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010587a:	c9                   	leave  
8010587b:	c3                   	ret    
8010587c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_mknod>:

int
sys_mknod(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105886:	e8 75 d3 ff ff       	call   80102c00 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010588b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010588e:	83 ec 08             	sub    $0x8,%esp
80105891:	50                   	push   %eax
80105892:	6a 00                	push   $0x0
80105894:	e8 77 f6 ff ff       	call   80104f10 <argstr>
80105899:	83 c4 10             	add    $0x10,%esp
8010589c:	85 c0                	test   %eax,%eax
8010589e:	78 60                	js     80105900 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801058a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a3:	83 ec 08             	sub    $0x8,%esp
801058a6:	50                   	push   %eax
801058a7:	6a 01                	push   $0x1
801058a9:	e8 b2 f5 ff ff       	call   80104e60 <argint>
  if((argstr(0, &path)) < 0 ||
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	85 c0                	test   %eax,%eax
801058b3:	78 4b                	js     80105900 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801058b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b8:	83 ec 08             	sub    $0x8,%esp
801058bb:	50                   	push   %eax
801058bc:	6a 02                	push   $0x2
801058be:	e8 9d f5 ff ff       	call   80104e60 <argint>
     argint(1, &major) < 0 ||
801058c3:	83 c4 10             	add    $0x10,%esp
801058c6:	85 c0                	test   %eax,%eax
801058c8:	78 36                	js     80105900 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801058ca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801058ce:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801058d1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801058d5:	ba 03 00 00 00       	mov    $0x3,%edx
801058da:	50                   	push   %eax
801058db:	8b 45 ec             	mov    -0x14(%ebp),%eax
801058de:	e8 cd f6 ff ff       	call   80104fb0 <create>
801058e3:	83 c4 10             	add    $0x10,%esp
801058e6:	85 c0                	test   %eax,%eax
801058e8:	74 16                	je     80105900 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058ea:	83 ec 0c             	sub    $0xc,%esp
801058ed:	50                   	push   %eax
801058ee:	e8 7d c0 ff ff       	call   80101970 <iunlockput>
  end_op();
801058f3:	e8 78 d3 ff ff       	call   80102c70 <end_op>
  return 0;
801058f8:	83 c4 10             	add    $0x10,%esp
801058fb:	31 c0                	xor    %eax,%eax
}
801058fd:	c9                   	leave  
801058fe:	c3                   	ret    
801058ff:	90                   	nop
    end_op();
80105900:	e8 6b d3 ff ff       	call   80102c70 <end_op>
    return -1;
80105905:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010590a:	c9                   	leave  
8010590b:	c3                   	ret    
8010590c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105910 <sys_chdir>:

int
sys_chdir(void)
{
80105910:	55                   	push   %ebp
80105911:	89 e5                	mov    %esp,%ebp
80105913:	56                   	push   %esi
80105914:	53                   	push   %ebx
80105915:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105918:	e8 03 df ff ff       	call   80103820 <myproc>
8010591d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010591f:	e8 dc d2 ff ff       	call   80102c00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105924:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105927:	83 ec 08             	sub    $0x8,%esp
8010592a:	50                   	push   %eax
8010592b:	6a 00                	push   $0x0
8010592d:	e8 de f5 ff ff       	call   80104f10 <argstr>
80105932:	83 c4 10             	add    $0x10,%esp
80105935:	85 c0                	test   %eax,%eax
80105937:	78 77                	js     801059b0 <sys_chdir+0xa0>
80105939:	83 ec 0c             	sub    $0xc,%esp
8010593c:	ff 75 f4             	pushl  -0xc(%ebp)
8010593f:	e8 fc c5 ff ff       	call   80101f40 <namei>
80105944:	83 c4 10             	add    $0x10,%esp
80105947:	85 c0                	test   %eax,%eax
80105949:	89 c3                	mov    %eax,%ebx
8010594b:	74 63                	je     801059b0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010594d:	83 ec 0c             	sub    $0xc,%esp
80105950:	50                   	push   %eax
80105951:	e8 8a bd ff ff       	call   801016e0 <ilock>
  if(ip->type != T_DIR){
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010595e:	75 30                	jne    80105990 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	53                   	push   %ebx
80105964:	e8 57 be ff ff       	call   801017c0 <iunlock>
  iput(curproc->cwd);
80105969:	58                   	pop    %eax
8010596a:	ff 76 68             	pushl  0x68(%esi)
8010596d:	e8 9e be ff ff       	call   80101810 <iput>
  end_op();
80105972:	e8 f9 d2 ff ff       	call   80102c70 <end_op>
  curproc->cwd = ip;
80105977:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010597a:	83 c4 10             	add    $0x10,%esp
8010597d:	31 c0                	xor    %eax,%eax
}
8010597f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105982:	5b                   	pop    %ebx
80105983:	5e                   	pop    %esi
80105984:	5d                   	pop    %ebp
80105985:	c3                   	ret    
80105986:	8d 76 00             	lea    0x0(%esi),%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	53                   	push   %ebx
80105994:	e8 d7 bf ff ff       	call   80101970 <iunlockput>
    end_op();
80105999:	e8 d2 d2 ff ff       	call   80102c70 <end_op>
    return -1;
8010599e:	83 c4 10             	add    $0x10,%esp
801059a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a6:	eb d7                	jmp    8010597f <sys_chdir+0x6f>
801059a8:	90                   	nop
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801059b0:	e8 bb d2 ff ff       	call   80102c70 <end_op>
    return -1;
801059b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ba:	eb c3                	jmp    8010597f <sys_chdir+0x6f>
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059c0 <sys_exec>:

int
sys_exec(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	57                   	push   %edi
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059c6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801059cc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801059d2:	50                   	push   %eax
801059d3:	6a 00                	push   $0x0
801059d5:	e8 36 f5 ff ff       	call   80104f10 <argstr>
801059da:	83 c4 10             	add    $0x10,%esp
801059dd:	85 c0                	test   %eax,%eax
801059df:	0f 88 87 00 00 00    	js     80105a6c <sys_exec+0xac>
801059e5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801059eb:	83 ec 08             	sub    $0x8,%esp
801059ee:	50                   	push   %eax
801059ef:	6a 01                	push   $0x1
801059f1:	e8 6a f4 ff ff       	call   80104e60 <argint>
801059f6:	83 c4 10             	add    $0x10,%esp
801059f9:	85 c0                	test   %eax,%eax
801059fb:	78 6f                	js     80105a6c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801059fd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a03:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105a06:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105a08:	68 80 00 00 00       	push   $0x80
80105a0d:	6a 00                	push   $0x0
80105a0f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105a15:	50                   	push   %eax
80105a16:	e8 45 f1 ff ff       	call   80104b60 <memset>
80105a1b:	83 c4 10             	add    $0x10,%esp
80105a1e:	eb 2c                	jmp    80105a4c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105a20:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105a26:	85 c0                	test   %eax,%eax
80105a28:	74 56                	je     80105a80 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105a2a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105a30:	83 ec 08             	sub    $0x8,%esp
80105a33:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105a36:	52                   	push   %edx
80105a37:	50                   	push   %eax
80105a38:	e8 b3 f3 ff ff       	call   80104df0 <fetchstr>
80105a3d:	83 c4 10             	add    $0x10,%esp
80105a40:	85 c0                	test   %eax,%eax
80105a42:	78 28                	js     80105a6c <sys_exec+0xac>
  for(i=0;; i++){
80105a44:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105a47:	83 fb 20             	cmp    $0x20,%ebx
80105a4a:	74 20                	je     80105a6c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105a4c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105a52:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105a59:	83 ec 08             	sub    $0x8,%esp
80105a5c:	57                   	push   %edi
80105a5d:	01 f0                	add    %esi,%eax
80105a5f:	50                   	push   %eax
80105a60:	e8 4b f3 ff ff       	call   80104db0 <fetchint>
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	85 c0                	test   %eax,%eax
80105a6a:	79 b4                	jns    80105a20 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105a6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a74:	5b                   	pop    %ebx
80105a75:	5e                   	pop    %esi
80105a76:	5f                   	pop    %edi
80105a77:	5d                   	pop    %ebp
80105a78:	c3                   	ret    
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105a80:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a86:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105a89:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a90:	00 00 00 00 
  return exec(path, argv);
80105a94:	50                   	push   %eax
80105a95:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105a9b:	e8 70 af ff ff       	call   80100a10 <exec>
80105aa0:	83 c4 10             	add    $0x10,%esp
}
80105aa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aa6:	5b                   	pop    %ebx
80105aa7:	5e                   	pop    %esi
80105aa8:	5f                   	pop    %edi
80105aa9:	5d                   	pop    %ebp
80105aaa:	c3                   	ret    
80105aab:	90                   	nop
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_pipe>:

int
sys_pipe(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	57                   	push   %edi
80105ab4:	56                   	push   %esi
80105ab5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ab6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ab9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105abc:	6a 08                	push   $0x8
80105abe:	50                   	push   %eax
80105abf:	6a 00                	push   $0x0
80105ac1:	e8 ea f3 ff ff       	call   80104eb0 <argptr>
80105ac6:	83 c4 10             	add    $0x10,%esp
80105ac9:	85 c0                	test   %eax,%eax
80105acb:	0f 88 ae 00 00 00    	js     80105b7f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ad1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ad4:	83 ec 08             	sub    $0x8,%esp
80105ad7:	50                   	push   %eax
80105ad8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105adb:	50                   	push   %eax
80105adc:	e8 bf d7 ff ff       	call   801032a0 <pipealloc>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	0f 88 93 00 00 00    	js     80105b7f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105aec:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105aef:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105af1:	e8 2a dd ff ff       	call   80103820 <myproc>
80105af6:	eb 10                	jmp    80105b08 <sys_pipe+0x58>
80105af8:	90                   	nop
80105af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105b00:	83 c3 01             	add    $0x1,%ebx
80105b03:	83 fb 10             	cmp    $0x10,%ebx
80105b06:	74 60                	je     80105b68 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105b08:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105b0c:	85 f6                	test   %esi,%esi
80105b0e:	75 f0                	jne    80105b00 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105b10:	8d 73 08             	lea    0x8(%ebx),%esi
80105b13:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105b1a:	e8 01 dd ff ff       	call   80103820 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b1f:	31 d2                	xor    %edx,%edx
80105b21:	eb 0d                	jmp    80105b30 <sys_pipe+0x80>
80105b23:	90                   	nop
80105b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b28:	83 c2 01             	add    $0x1,%edx
80105b2b:	83 fa 10             	cmp    $0x10,%edx
80105b2e:	74 28                	je     80105b58 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105b30:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105b34:	85 c9                	test   %ecx,%ecx
80105b36:	75 f0                	jne    80105b28 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105b38:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105b3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b3f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105b41:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b44:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105b47:	31 c0                	xor    %eax,%eax
}
80105b49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b4c:	5b                   	pop    %ebx
80105b4d:	5e                   	pop    %esi
80105b4e:	5f                   	pop    %edi
80105b4f:	5d                   	pop    %ebp
80105b50:	c3                   	ret    
80105b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105b58:	e8 c3 dc ff ff       	call   80103820 <myproc>
80105b5d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105b64:	00 
80105b65:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105b68:	83 ec 0c             	sub    $0xc,%esp
80105b6b:	ff 75 e0             	pushl  -0x20(%ebp)
80105b6e:	e8 2d b3 ff ff       	call   80100ea0 <fileclose>
    fileclose(wf);
80105b73:	58                   	pop    %eax
80105b74:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b77:	e8 24 b3 ff ff       	call   80100ea0 <fileclose>
    return -1;
80105b7c:	83 c4 10             	add    $0x10,%esp
80105b7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b84:	eb c3                	jmp    80105b49 <sys_pipe+0x99>
80105b86:	66 90                	xchg   %ax,%ax
80105b88:	66 90                	xchg   %ax,%ax
80105b8a:	66 90                	xchg   %ax,%ax
80105b8c:	66 90                	xchg   %ax,%ax
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <sys_fork>:
#include "proc.h"


int
sys_fork(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105b93:	5d                   	pop    %ebp
  return fork();
80105b94:	e9 c7 df ff ff       	jmp    80103b60 <fork>
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ba0 <sys_exit>:

int
sys_exit(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ba6:	e8 75 e3 ff ff       	call   80103f20 <exit>
  return 0;  // not reached
}
80105bab:	31 c0                	xor    %eax,%eax
80105bad:	c9                   	leave  
80105bae:	c3                   	ret    
80105baf:	90                   	nop

80105bb0 <sys_wait>:

int
sys_wait(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105bb3:	5d                   	pop    %ebp
  return wait();
80105bb4:	e9 e7 e5 ff ff       	jmp    801041a0 <wait>
80105bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <sys_kill>:

int
sys_kill(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int signum;

  if(argint(0, &pid) < 0)
80105bc6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105bc9:	50                   	push   %eax
80105bca:	6a 00                	push   $0x0
80105bcc:	e8 8f f2 ff ff       	call   80104e60 <argint>
80105bd1:	83 c4 10             	add    $0x10,%esp
80105bd4:	85 c0                	test   %eax,%eax
80105bd6:	78 28                	js     80105c00 <sys_kill+0x40>
    return -1;
  if(argint(1, &signum) < 0)
80105bd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bdb:	83 ec 08             	sub    $0x8,%esp
80105bde:	50                   	push   %eax
80105bdf:	6a 01                	push   $0x1
80105be1:	e8 7a f2 ff ff       	call   80104e60 <argint>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	85 c0                	test   %eax,%eax
80105beb:	78 13                	js     80105c00 <sys_kill+0x40>
    return -1;
  return kill(pid, signum);
80105bed:	83 ec 08             	sub    $0x8,%esp
80105bf0:	ff 75 f4             	pushl  -0xc(%ebp)
80105bf3:	ff 75 f0             	pushl  -0x10(%ebp)
80105bf6:	e8 05 e7 ff ff       	call   80104300 <kill>
80105bfb:	83 c4 10             	add    $0x10,%esp
}
80105bfe:	c9                   	leave  
80105bff:	c3                   	ret    
    return -1;
80105c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c05:	c9                   	leave  
80105c06:	c3                   	ret    
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c10 <sys_getpid>:

int
sys_getpid(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105c16:	e8 05 dc ff ff       	call   80103820 <myproc>
80105c1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105c1e:	c9                   	leave  
80105c1f:	c3                   	ret    

80105c20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105c24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c2a:	50                   	push   %eax
80105c2b:	6a 00                	push   $0x0
80105c2d:	e8 2e f2 ff ff       	call   80104e60 <argint>
80105c32:	83 c4 10             	add    $0x10,%esp
80105c35:	85 c0                	test   %eax,%eax
80105c37:	78 27                	js     80105c60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105c39:	e8 e2 db ff ff       	call   80103820 <myproc>
  if(growproc(n) < 0)
80105c3e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105c41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105c43:	ff 75 f4             	pushl  -0xc(%ebp)
80105c46:	e8 95 de ff ff       	call   80103ae0 <growproc>
80105c4b:	83 c4 10             	add    $0x10,%esp
80105c4e:	85 c0                	test   %eax,%eax
80105c50:	78 0e                	js     80105c60 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c52:	89 d8                	mov    %ebx,%eax
80105c54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c57:	c9                   	leave  
80105c58:	c3                   	ret    
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c60:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c65:	eb eb                	jmp    80105c52 <sys_sbrk+0x32>
80105c67:	89 f6                	mov    %esi,%esi
80105c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c70 <sys_sleep>:

int
sys_sleep(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c74:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c77:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c7a:	50                   	push   %eax
80105c7b:	6a 00                	push   $0x0
80105c7d:	e8 de f1 ff ff       	call   80104e60 <argint>
80105c82:	83 c4 10             	add    $0x10,%esp
80105c85:	85 c0                	test   %eax,%eax
80105c87:	0f 88 8a 00 00 00    	js     80105d17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	68 60 80 11 80       	push   $0x80118060
80105c95:	e8 b6 ed ff ff       	call   80104a50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c9d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105ca0:	8b 1d a0 88 11 80    	mov    0x801188a0,%ebx
  while(ticks - ticks0 < n){
80105ca6:	85 d2                	test   %edx,%edx
80105ca8:	75 27                	jne    80105cd1 <sys_sleep+0x61>
80105caa:	eb 54                	jmp    80105d00 <sys_sleep+0x90>
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105cb0:	83 ec 08             	sub    $0x8,%esp
80105cb3:	68 60 80 11 80       	push   $0x80118060
80105cb8:	68 a0 88 11 80       	push   $0x801188a0
80105cbd:	e8 fe e3 ff ff       	call   801040c0 <sleep>
  while(ticks - ticks0 < n){
80105cc2:	a1 a0 88 11 80       	mov    0x801188a0,%eax
80105cc7:	83 c4 10             	add    $0x10,%esp
80105cca:	29 d8                	sub    %ebx,%eax
80105ccc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105ccf:	73 2f                	jae    80105d00 <sys_sleep+0x90>
    if(myproc()->killed){
80105cd1:	e8 4a db ff ff       	call   80103820 <myproc>
80105cd6:	8b 40 24             	mov    0x24(%eax),%eax
80105cd9:	85 c0                	test   %eax,%eax
80105cdb:	74 d3                	je     80105cb0 <sys_sleep+0x40>
      release(&tickslock);
80105cdd:	83 ec 0c             	sub    $0xc,%esp
80105ce0:	68 60 80 11 80       	push   $0x80118060
80105ce5:	e8 26 ee ff ff       	call   80104b10 <release>
      return -1;
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105cf2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cf5:	c9                   	leave  
80105cf6:	c3                   	ret    
80105cf7:	89 f6                	mov    %esi,%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105d00:	83 ec 0c             	sub    $0xc,%esp
80105d03:	68 60 80 11 80       	push   $0x80118060
80105d08:	e8 03 ee ff ff       	call   80104b10 <release>
  return 0;
80105d0d:	83 c4 10             	add    $0x10,%esp
80105d10:	31 c0                	xor    %eax,%eax
}
80105d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d15:	c9                   	leave  
80105d16:	c3                   	ret    
    return -1;
80105d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d1c:	eb f4                	jmp    80105d12 <sys_sleep+0xa2>
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	53                   	push   %ebx
80105d24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105d27:	68 60 80 11 80       	push   $0x80118060
80105d2c:	e8 1f ed ff ff       	call   80104a50 <acquire>
  xticks = ticks;
80105d31:	8b 1d a0 88 11 80    	mov    0x801188a0,%ebx
  release(&tickslock);
80105d37:	c7 04 24 60 80 11 80 	movl   $0x80118060,(%esp)
80105d3e:	e8 cd ed ff ff       	call   80104b10 <release>
  return xticks;
}
80105d43:	89 d8                	mov    %ebx,%eax
80105d45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d48:	c9                   	leave  
80105d49:	c3                   	ret    
80105d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d50 <sys_sigprocmask>:

// assignment 2
uint
sys_sigprocmask(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 20             	sub    $0x20,%esp
  uint new_mask;
  if (argint(0, (int*)&new_mask) < 0)
80105d56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d59:	50                   	push   %eax
80105d5a:	6a 00                	push   $0x0
80105d5c:	e8 ff f0 ff ff       	call   80104e60 <argint>
80105d61:	83 c4 10             	add    $0x10,%esp
80105d64:	85 c0                	test   %eax,%eax
80105d66:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80105d6b:	78 10                	js     80105d7d <sys_sigprocmask+0x2d>
    return -1;
  return sigprocmask(new_mask);
80105d6d:	83 ec 0c             	sub    $0xc,%esp
80105d70:	ff 75 f4             	pushl  -0xc(%ebp)
80105d73:	e8 28 e6 ff ff       	call   801043a0 <sigprocmask>
80105d78:	83 c4 10             	add    $0x10,%esp
80105d7b:	89 c2                	mov    %eax,%edx
}
80105d7d:	89 d0                	mov    %edx,%eax
80105d7f:	c9                   	leave  
80105d80:	c3                   	ret    
80105d81:	eb 0d                	jmp    80105d90 <sys_sigaction>
80105d83:	90                   	nop
80105d84:	90                   	nop
80105d85:	90                   	nop
80105d86:	90                   	nop
80105d87:	90                   	nop
80105d88:	90                   	nop
80105d89:	90                   	nop
80105d8a:	90                   	nop
80105d8b:	90                   	nop
80105d8c:	90                   	nop
80105d8d:	90                   	nop
80105d8e:	90                   	nop
80105d8f:	90                   	nop

80105d90 <sys_sigaction>:


int
sys_sigaction(void)
{
80105d90:	55                   	push   %ebp
80105d91:	89 e5                	mov    %esp,%ebp
80105d93:	83 ec 20             	sub    $0x20,%esp
  int signum;
  struct sigaction *act;
  struct sigaction *oldact;

  if(argint(0, &signum) < 0)
80105d96:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d99:	50                   	push   %eax
80105d9a:	6a 00                	push   $0x0
80105d9c:	e8 bf f0 ff ff       	call   80104e60 <argint>
80105da1:	83 c4 10             	add    $0x10,%esp
80105da4:	85 c0                	test   %eax,%eax
80105da6:	78 48                	js     80105df0 <sys_sigaction+0x60>
    return -1;

  if(argptr(1, (char**)&act, sizeof(struct sigaction)) < 0)
80105da8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dab:	83 ec 04             	sub    $0x4,%esp
80105dae:	6a 08                	push   $0x8
80105db0:	50                   	push   %eax
80105db1:	6a 01                	push   $0x1
80105db3:	e8 f8 f0 ff ff       	call   80104eb0 <argptr>
80105db8:	83 c4 10             	add    $0x10,%esp
80105dbb:	85 c0                	test   %eax,%eax
80105dbd:	78 31                	js     80105df0 <sys_sigaction+0x60>
    return -1;

  if(argptr(2, (char**)&oldact, sizeof(struct sigaction)) < 0)
80105dbf:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dc2:	83 ec 04             	sub    $0x4,%esp
80105dc5:	6a 08                	push   $0x8
80105dc7:	50                   	push   %eax
80105dc8:	6a 02                	push   $0x2
80105dca:	e8 e1 f0 ff ff       	call   80104eb0 <argptr>
80105dcf:	83 c4 10             	add    $0x10,%esp
80105dd2:	85 c0                	test   %eax,%eax
80105dd4:	78 1a                	js     80105df0 <sys_sigaction+0x60>
    return -1;

  return sigaction(signum, act, oldact);
80105dd6:	83 ec 04             	sub    $0x4,%esp
80105dd9:	ff 75 f4             	pushl  -0xc(%ebp)
80105ddc:	ff 75 f0             	pushl  -0x10(%ebp)
80105ddf:	ff 75 ec             	pushl  -0x14(%ebp)
80105de2:	e8 a9 e7 ff ff       	call   80104590 <sigaction>
80105de7:	83 c4 10             	add    $0x10,%esp

}
80105dea:	c9                   	leave  
80105deb:	c3                   	ret    
80105dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105df5:	c9                   	leave  
80105df6:	c3                   	ret    
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <sys_sigret>:

int
sys_sigret(void) 
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
  return sigret();
80105e03:	5d                   	pop    %ebp
  return sigret();
80105e04:	e9 97 e9 ff ff       	jmp    801047a0 <sigret>

80105e09 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e09:	1e                   	push   %ds
  pushl %es
80105e0a:	06                   	push   %es
  pushl %fs
80105e0b:	0f a0                	push   %fs
  pushl %gs
80105e0d:	0f a8                	push   %gs
  pushal
80105e0f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e10:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e14:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e16:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e18:	54                   	push   %esp
  call trap
80105e19:	e8 d2 00 00 00       	call   80105ef0 <trap>
  addl $4, %esp
80105e1e:	83 c4 04             	add    $0x4,%esp

80105e21 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  call handle_signals
80105e21:	e8 da e8 ff ff       	call   80104700 <handle_signals>
  popal
80105e26:	61                   	popa   
  popl %gs
80105e27:	0f a9                	pop    %gs
  popl %fs
80105e29:	0f a1                	pop    %fs
  popl %es
80105e2b:	07                   	pop    %es
  popl %ds
80105e2c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e2d:	83 c4 08             	add    $0x8,%esp
  iret
80105e30:	cf                   	iret   

80105e31 <sigret_caller_start>:


.globl sigret_caller_start
.globl sigret_caller_end
sigret_caller_start:
  movl $SYS_sigret, %eax
80105e31:	b8 18 00 00 00       	mov    $0x18,%eax
  int $T_SYSCALL
80105e36:	cd 40                	int    $0x40

80105e38 <sigret_caller_end>:
80105e38:	66 90                	xchg   %ax,%ax
80105e3a:	66 90                	xchg   %ax,%ax
80105e3c:	66 90                	xchg   %ax,%ax
80105e3e:	66 90                	xchg   %ax,%ax

80105e40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105e40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105e41:	31 c0                	xor    %eax,%eax
{
80105e43:	89 e5                	mov    %esp,%ebp
80105e45:	83 ec 08             	sub    $0x8,%esp
80105e48:	90                   	nop
80105e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e57:	c7 04 c5 a2 80 11 80 	movl   $0x8e000008,-0x7fee7f5e(,%eax,8)
80105e5e:	08 00 00 8e 
80105e62:	66 89 14 c5 a0 80 11 	mov    %dx,-0x7fee7f60(,%eax,8)
80105e69:	80 
80105e6a:	c1 ea 10             	shr    $0x10,%edx
80105e6d:	66 89 14 c5 a6 80 11 	mov    %dx,-0x7fee7f5a(,%eax,8)
80105e74:	80 
  for(i = 0; i < 256; i++)
80105e75:	83 c0 01             	add    $0x1,%eax
80105e78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e7d:	75 d1                	jne    80105e50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e7f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105e84:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e87:	c7 05 a2 82 11 80 08 	movl   $0xef000008,0x801182a2
80105e8e:	00 00 ef 
  initlock(&tickslock, "time");
80105e91:	68 a5 7f 10 80       	push   $0x80107fa5
80105e96:	68 60 80 11 80       	push   $0x80118060
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e9b:	66 a3 a0 82 11 80    	mov    %ax,0x801182a0
80105ea1:	c1 e8 10             	shr    $0x10,%eax
80105ea4:	66 a3 a6 82 11 80    	mov    %ax,0x801182a6
  initlock(&tickslock, "time");
80105eaa:	e8 61 ea ff ff       	call   80104910 <initlock>
}
80105eaf:	83 c4 10             	add    $0x10,%esp
80105eb2:	c9                   	leave  
80105eb3:	c3                   	ret    
80105eb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105eba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105ec0 <idtinit>:

void
idtinit(void)
{
80105ec0:	55                   	push   %ebp
  pd[0] = size-1;
80105ec1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ec6:	89 e5                	mov    %esp,%ebp
80105ec8:	83 ec 10             	sub    $0x10,%esp
80105ecb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105ecf:	b8 a0 80 11 80       	mov    $0x801180a0,%eax
80105ed4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ed8:	c1 e8 10             	shr    $0x10,%eax
80105edb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105edf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ee2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ee5:	c9                   	leave  
80105ee6:	c3                   	ret    
80105ee7:	89 f6                	mov    %esi,%esi
80105ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ef0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	57                   	push   %edi
80105ef4:	56                   	push   %esi
80105ef5:	53                   	push   %ebx
80105ef6:	83 ec 1c             	sub    $0x1c,%esp
80105ef9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105efc:	8b 47 30             	mov    0x30(%edi),%eax
80105eff:	83 f8 40             	cmp    $0x40,%eax
80105f02:	0f 84 f0 00 00 00    	je     80105ff8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f08:	83 e8 20             	sub    $0x20,%eax
80105f0b:	83 f8 1f             	cmp    $0x1f,%eax
80105f0e:	77 10                	ja     80105f20 <trap+0x30>
80105f10:	ff 24 85 4c 80 10 80 	jmp    *-0x7fef7fb4(,%eax,4)
80105f17:	89 f6                	mov    %esi,%esi
80105f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f20:	e8 fb d8 ff ff       	call   80103820 <myproc>
80105f25:	85 c0                	test   %eax,%eax
80105f27:	8b 5f 38             	mov    0x38(%edi),%ebx
80105f2a:	0f 84 14 02 00 00    	je     80106144 <trap+0x254>
80105f30:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105f34:	0f 84 0a 02 00 00    	je     80106144 <trap+0x254>
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f3a:	0f 20 d1             	mov    %cr2,%ecx
80105f3d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f40:	e8 bb d8 ff ff       	call   80103800 <cpuid>
80105f45:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f48:	8b 47 34             	mov    0x34(%edi),%eax
80105f4b:	8b 77 30             	mov    0x30(%edi),%esi
80105f4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105f51:	e8 ca d8 ff ff       	call   80103820 <myproc>
80105f56:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f59:	e8 c2 d8 ff ff       	call   80103820 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f5e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f61:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f64:	51                   	push   %ecx
80105f65:	53                   	push   %ebx
80105f66:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105f67:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f6a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f6d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105f6e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f71:	52                   	push   %edx
80105f72:	ff 70 10             	pushl  0x10(%eax)
80105f75:	68 08 80 10 80       	push   $0x80108008
80105f7a:	e8 e1 a6 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105f7f:	83 c4 20             	add    $0x20,%esp
80105f82:	e8 99 d8 ff ff       	call   80103820 <myproc>
80105f87:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f8e:	e8 8d d8 ff ff       	call   80103820 <myproc>
80105f93:	85 c0                	test   %eax,%eax
80105f95:	74 1d                	je     80105fb4 <trap+0xc4>
80105f97:	e8 84 d8 ff ff       	call   80103820 <myproc>
80105f9c:	8b 50 24             	mov    0x24(%eax),%edx
80105f9f:	85 d2                	test   %edx,%edx
80105fa1:	74 11                	je     80105fb4 <trap+0xc4>
80105fa3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105fa7:	83 e0 03             	and    $0x3,%eax
80105faa:	66 83 f8 03          	cmp    $0x3,%ax
80105fae:	0f 84 4c 01 00 00    	je     80106100 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105fb4:	e8 67 d8 ff ff       	call   80103820 <myproc>
80105fb9:	85 c0                	test   %eax,%eax
80105fbb:	74 0b                	je     80105fc8 <trap+0xd8>
80105fbd:	e8 5e d8 ff ff       	call   80103820 <myproc>
80105fc2:	83 78 0c 07          	cmpl   $0x7,0xc(%eax)
80105fc6:	74 68                	je     80106030 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fc8:	e8 53 d8 ff ff       	call   80103820 <myproc>
80105fcd:	85 c0                	test   %eax,%eax
80105fcf:	74 19                	je     80105fea <trap+0xfa>
80105fd1:	e8 4a d8 ff ff       	call   80103820 <myproc>
80105fd6:	8b 40 24             	mov    0x24(%eax),%eax
80105fd9:	85 c0                	test   %eax,%eax
80105fdb:	74 0d                	je     80105fea <trap+0xfa>
80105fdd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105fe1:	83 e0 03             	and    $0x3,%eax
80105fe4:	66 83 f8 03          	cmp    $0x3,%ax
80105fe8:	74 37                	je     80106021 <trap+0x131>
    exit();
}
80105fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fed:	5b                   	pop    %ebx
80105fee:	5e                   	pop    %esi
80105fef:	5f                   	pop    %edi
80105ff0:	5d                   	pop    %ebp
80105ff1:	c3                   	ret    
80105ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105ff8:	e8 23 d8 ff ff       	call   80103820 <myproc>
80105ffd:	8b 58 24             	mov    0x24(%eax),%ebx
80106000:	85 db                	test   %ebx,%ebx
80106002:	0f 85 e8 00 00 00    	jne    801060f0 <trap+0x200>
    myproc()->tf = tf;
80106008:	e8 13 d8 ff ff       	call   80103820 <myproc>
8010600d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106010:	e8 3b ef ff ff       	call   80104f50 <syscall>
    if(myproc()->killed)
80106015:	e8 06 d8 ff ff       	call   80103820 <myproc>
8010601a:	8b 48 24             	mov    0x24(%eax),%ecx
8010601d:	85 c9                	test   %ecx,%ecx
8010601f:	74 c9                	je     80105fea <trap+0xfa>
}
80106021:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106024:	5b                   	pop    %ebx
80106025:	5e                   	pop    %esi
80106026:	5f                   	pop    %edi
80106027:	5d                   	pop    %ebp
      exit();
80106028:	e9 f3 de ff ff       	jmp    80103f20 <exit>
8010602d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106030:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106034:	75 92                	jne    80105fc8 <trap+0xd8>
    yield();
80106036:	e8 05 e0 ff ff       	call   80104040 <yield>
8010603b:	eb 8b                	jmp    80105fc8 <trap+0xd8>
8010603d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106040:	e8 bb d7 ff ff       	call   80103800 <cpuid>
80106045:	85 c0                	test   %eax,%eax
80106047:	0f 84 c3 00 00 00    	je     80106110 <trap+0x220>
    lapiceoi();
8010604d:	e8 5e c7 ff ff       	call   801027b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106052:	e8 c9 d7 ff ff       	call   80103820 <myproc>
80106057:	85 c0                	test   %eax,%eax
80106059:	0f 85 38 ff ff ff    	jne    80105f97 <trap+0xa7>
8010605f:	e9 50 ff ff ff       	jmp    80105fb4 <trap+0xc4>
80106064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106068:	e8 03 c6 ff ff       	call   80102670 <kbdintr>
    lapiceoi();
8010606d:	e8 3e c7 ff ff       	call   801027b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106072:	e8 a9 d7 ff ff       	call   80103820 <myproc>
80106077:	85 c0                	test   %eax,%eax
80106079:	0f 85 18 ff ff ff    	jne    80105f97 <trap+0xa7>
8010607f:	e9 30 ff ff ff       	jmp    80105fb4 <trap+0xc4>
80106084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106088:	e8 53 02 00 00       	call   801062e0 <uartintr>
    lapiceoi();
8010608d:	e8 1e c7 ff ff       	call   801027b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106092:	e8 89 d7 ff ff       	call   80103820 <myproc>
80106097:	85 c0                	test   %eax,%eax
80106099:	0f 85 f8 fe ff ff    	jne    80105f97 <trap+0xa7>
8010609f:	e9 10 ff ff ff       	jmp    80105fb4 <trap+0xc4>
801060a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060a8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801060ac:	8b 77 38             	mov    0x38(%edi),%esi
801060af:	e8 4c d7 ff ff       	call   80103800 <cpuid>
801060b4:	56                   	push   %esi
801060b5:	53                   	push   %ebx
801060b6:	50                   	push   %eax
801060b7:	68 b0 7f 10 80       	push   $0x80107fb0
801060bc:	e8 9f a5 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801060c1:	e8 ea c6 ff ff       	call   801027b0 <lapiceoi>
    break;
801060c6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060c9:	e8 52 d7 ff ff       	call   80103820 <myproc>
801060ce:	85 c0                	test   %eax,%eax
801060d0:	0f 85 c1 fe ff ff    	jne    80105f97 <trap+0xa7>
801060d6:	e9 d9 fe ff ff       	jmp    80105fb4 <trap+0xc4>
801060db:	90                   	nop
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801060e0:	e8 fb bf ff ff       	call   801020e0 <ideintr>
801060e5:	e9 63 ff ff ff       	jmp    8010604d <trap+0x15d>
801060ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801060f0:	e8 2b de ff ff       	call   80103f20 <exit>
801060f5:	e9 0e ff ff ff       	jmp    80106008 <trap+0x118>
801060fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106100:	e8 1b de ff ff       	call   80103f20 <exit>
80106105:	e9 aa fe ff ff       	jmp    80105fb4 <trap+0xc4>
8010610a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	68 60 80 11 80       	push   $0x80118060
80106118:	e8 33 e9 ff ff       	call   80104a50 <acquire>
      wakeup(&ticks);
8010611d:	c7 04 24 a0 88 11 80 	movl   $0x801188a0,(%esp)
      ticks++;
80106124:	83 05 a0 88 11 80 01 	addl   $0x1,0x801188a0
      wakeup(&ticks);
8010612b:	e8 a0 e1 ff ff       	call   801042d0 <wakeup>
      release(&tickslock);
80106130:	c7 04 24 60 80 11 80 	movl   $0x80118060,(%esp)
80106137:	e8 d4 e9 ff ff       	call   80104b10 <release>
8010613c:	83 c4 10             	add    $0x10,%esp
8010613f:	e9 09 ff ff ff       	jmp    8010604d <trap+0x15d>
80106144:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106147:	e8 b4 d6 ff ff       	call   80103800 <cpuid>
8010614c:	83 ec 0c             	sub    $0xc,%esp
8010614f:	56                   	push   %esi
80106150:	53                   	push   %ebx
80106151:	50                   	push   %eax
80106152:	ff 77 30             	pushl  0x30(%edi)
80106155:	68 d4 7f 10 80       	push   $0x80107fd4
8010615a:	e8 01 a5 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010615f:	83 c4 14             	add    $0x14,%esp
80106162:	68 aa 7f 10 80       	push   $0x80107faa
80106167:	e8 24 a2 ff ff       	call   80100390 <panic>
8010616c:	66 90                	xchg   %ax,%ax
8010616e:	66 90                	xchg   %ax,%ax

80106170 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106170:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106175:	55                   	push   %ebp
80106176:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106178:	85 c0                	test   %eax,%eax
8010617a:	74 1c                	je     80106198 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010617c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106181:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106182:	a8 01                	test   $0x1,%al
80106184:	74 12                	je     80106198 <uartgetc+0x28>
80106186:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010618b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010618c:	0f b6 c0             	movzbl %al,%eax
}
8010618f:	5d                   	pop    %ebp
80106190:	c3                   	ret    
80106191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010619d:	5d                   	pop    %ebp
8010619e:	c3                   	ret    
8010619f:	90                   	nop

801061a0 <uartputc.part.0>:
uartputc(int c)
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	57                   	push   %edi
801061a4:	56                   	push   %esi
801061a5:	53                   	push   %ebx
801061a6:	89 c7                	mov    %eax,%edi
801061a8:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801061b2:	83 ec 0c             	sub    $0xc,%esp
801061b5:	eb 1b                	jmp    801061d2 <uartputc.part.0+0x32>
801061b7:	89 f6                	mov    %esi,%esi
801061b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801061c0:	83 ec 0c             	sub    $0xc,%esp
801061c3:	6a 0a                	push   $0xa
801061c5:	e8 06 c6 ff ff       	call   801027d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061ca:	83 c4 10             	add    $0x10,%esp
801061cd:	83 eb 01             	sub    $0x1,%ebx
801061d0:	74 07                	je     801061d9 <uartputc.part.0+0x39>
801061d2:	89 f2                	mov    %esi,%edx
801061d4:	ec                   	in     (%dx),%al
801061d5:	a8 20                	test   $0x20,%al
801061d7:	74 e7                	je     801061c0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061de:	89 f8                	mov    %edi,%eax
801061e0:	ee                   	out    %al,(%dx)
}
801061e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061e4:	5b                   	pop    %ebx
801061e5:	5e                   	pop    %esi
801061e6:	5f                   	pop    %edi
801061e7:	5d                   	pop    %ebp
801061e8:	c3                   	ret    
801061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801061f0 <uartinit>:
{
801061f0:	55                   	push   %ebp
801061f1:	31 c9                	xor    %ecx,%ecx
801061f3:	89 c8                	mov    %ecx,%eax
801061f5:	89 e5                	mov    %esp,%ebp
801061f7:	57                   	push   %edi
801061f8:	56                   	push   %esi
801061f9:	53                   	push   %ebx
801061fa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801061ff:	89 da                	mov    %ebx,%edx
80106201:	83 ec 0c             	sub    $0xc,%esp
80106204:	ee                   	out    %al,(%dx)
80106205:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010620a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010620f:	89 fa                	mov    %edi,%edx
80106211:	ee                   	out    %al,(%dx)
80106212:	b8 0c 00 00 00       	mov    $0xc,%eax
80106217:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010621c:	ee                   	out    %al,(%dx)
8010621d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106222:	89 c8                	mov    %ecx,%eax
80106224:	89 f2                	mov    %esi,%edx
80106226:	ee                   	out    %al,(%dx)
80106227:	b8 03 00 00 00       	mov    $0x3,%eax
8010622c:	89 fa                	mov    %edi,%edx
8010622e:	ee                   	out    %al,(%dx)
8010622f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106234:	89 c8                	mov    %ecx,%eax
80106236:	ee                   	out    %al,(%dx)
80106237:	b8 01 00 00 00       	mov    $0x1,%eax
8010623c:	89 f2                	mov    %esi,%edx
8010623e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010623f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106244:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106245:	3c ff                	cmp    $0xff,%al
80106247:	74 5a                	je     801062a3 <uartinit+0xb3>
  uart = 1;
80106249:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106250:	00 00 00 
80106253:	89 da                	mov    %ebx,%edx
80106255:	ec                   	in     (%dx),%al
80106256:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010625b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010625c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010625f:	bb cc 80 10 80       	mov    $0x801080cc,%ebx
  ioapicenable(IRQ_COM1, 0);
80106264:	6a 00                	push   $0x0
80106266:	6a 04                	push   $0x4
80106268:	e8 c3 c0 ff ff       	call   80102330 <ioapicenable>
8010626d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106270:	b8 78 00 00 00       	mov    $0x78,%eax
80106275:	eb 13                	jmp    8010628a <uartinit+0x9a>
80106277:	89 f6                	mov    %esi,%esi
80106279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106280:	83 c3 01             	add    $0x1,%ebx
80106283:	0f be 03             	movsbl (%ebx),%eax
80106286:	84 c0                	test   %al,%al
80106288:	74 19                	je     801062a3 <uartinit+0xb3>
  if(!uart)
8010628a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106290:	85 d2                	test   %edx,%edx
80106292:	74 ec                	je     80106280 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106294:	83 c3 01             	add    $0x1,%ebx
80106297:	e8 04 ff ff ff       	call   801061a0 <uartputc.part.0>
8010629c:	0f be 03             	movsbl (%ebx),%eax
8010629f:	84 c0                	test   %al,%al
801062a1:	75 e7                	jne    8010628a <uartinit+0x9a>
}
801062a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062a6:	5b                   	pop    %ebx
801062a7:	5e                   	pop    %esi
801062a8:	5f                   	pop    %edi
801062a9:	5d                   	pop    %ebp
801062aa:	c3                   	ret    
801062ab:	90                   	nop
801062ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062b0 <uartputc>:
  if(!uart)
801062b0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801062b6:	55                   	push   %ebp
801062b7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801062b9:	85 d2                	test   %edx,%edx
{
801062bb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801062be:	74 10                	je     801062d0 <uartputc+0x20>
}
801062c0:	5d                   	pop    %ebp
801062c1:	e9 da fe ff ff       	jmp    801061a0 <uartputc.part.0>
801062c6:	8d 76 00             	lea    0x0(%esi),%esi
801062c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801062d0:	5d                   	pop    %ebp
801062d1:	c3                   	ret    
801062d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062e0 <uartintr>:

void
uartintr(void)
{
801062e0:	55                   	push   %ebp
801062e1:	89 e5                	mov    %esp,%ebp
801062e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801062e6:	68 70 61 10 80       	push   $0x80106170
801062eb:	e8 20 a5 ff ff       	call   80100810 <consoleintr>
}
801062f0:	83 c4 10             	add    $0x10,%esp
801062f3:	c9                   	leave  
801062f4:	c3                   	ret    

801062f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $0
801062f7:	6a 00                	push   $0x0
  jmp alltraps
801062f9:	e9 0b fb ff ff       	jmp    80105e09 <alltraps>

801062fe <vector1>:
.globl vector1
vector1:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $1
80106300:	6a 01                	push   $0x1
  jmp alltraps
80106302:	e9 02 fb ff ff       	jmp    80105e09 <alltraps>

80106307 <vector2>:
.globl vector2
vector2:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $2
80106309:	6a 02                	push   $0x2
  jmp alltraps
8010630b:	e9 f9 fa ff ff       	jmp    80105e09 <alltraps>

80106310 <vector3>:
.globl vector3
vector3:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $3
80106312:	6a 03                	push   $0x3
  jmp alltraps
80106314:	e9 f0 fa ff ff       	jmp    80105e09 <alltraps>

80106319 <vector4>:
.globl vector4
vector4:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $4
8010631b:	6a 04                	push   $0x4
  jmp alltraps
8010631d:	e9 e7 fa ff ff       	jmp    80105e09 <alltraps>

80106322 <vector5>:
.globl vector5
vector5:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $5
80106324:	6a 05                	push   $0x5
  jmp alltraps
80106326:	e9 de fa ff ff       	jmp    80105e09 <alltraps>

8010632b <vector6>:
.globl vector6
vector6:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $6
8010632d:	6a 06                	push   $0x6
  jmp alltraps
8010632f:	e9 d5 fa ff ff       	jmp    80105e09 <alltraps>

80106334 <vector7>:
.globl vector7
vector7:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $7
80106336:	6a 07                	push   $0x7
  jmp alltraps
80106338:	e9 cc fa ff ff       	jmp    80105e09 <alltraps>

8010633d <vector8>:
.globl vector8
vector8:
  pushl $8
8010633d:	6a 08                	push   $0x8
  jmp alltraps
8010633f:	e9 c5 fa ff ff       	jmp    80105e09 <alltraps>

80106344 <vector9>:
.globl vector9
vector9:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $9
80106346:	6a 09                	push   $0x9
  jmp alltraps
80106348:	e9 bc fa ff ff       	jmp    80105e09 <alltraps>

8010634d <vector10>:
.globl vector10
vector10:
  pushl $10
8010634d:	6a 0a                	push   $0xa
  jmp alltraps
8010634f:	e9 b5 fa ff ff       	jmp    80105e09 <alltraps>

80106354 <vector11>:
.globl vector11
vector11:
  pushl $11
80106354:	6a 0b                	push   $0xb
  jmp alltraps
80106356:	e9 ae fa ff ff       	jmp    80105e09 <alltraps>

8010635b <vector12>:
.globl vector12
vector12:
  pushl $12
8010635b:	6a 0c                	push   $0xc
  jmp alltraps
8010635d:	e9 a7 fa ff ff       	jmp    80105e09 <alltraps>

80106362 <vector13>:
.globl vector13
vector13:
  pushl $13
80106362:	6a 0d                	push   $0xd
  jmp alltraps
80106364:	e9 a0 fa ff ff       	jmp    80105e09 <alltraps>

80106369 <vector14>:
.globl vector14
vector14:
  pushl $14
80106369:	6a 0e                	push   $0xe
  jmp alltraps
8010636b:	e9 99 fa ff ff       	jmp    80105e09 <alltraps>

80106370 <vector15>:
.globl vector15
vector15:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $15
80106372:	6a 0f                	push   $0xf
  jmp alltraps
80106374:	e9 90 fa ff ff       	jmp    80105e09 <alltraps>

80106379 <vector16>:
.globl vector16
vector16:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $16
8010637b:	6a 10                	push   $0x10
  jmp alltraps
8010637d:	e9 87 fa ff ff       	jmp    80105e09 <alltraps>

80106382 <vector17>:
.globl vector17
vector17:
  pushl $17
80106382:	6a 11                	push   $0x11
  jmp alltraps
80106384:	e9 80 fa ff ff       	jmp    80105e09 <alltraps>

80106389 <vector18>:
.globl vector18
vector18:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $18
8010638b:	6a 12                	push   $0x12
  jmp alltraps
8010638d:	e9 77 fa ff ff       	jmp    80105e09 <alltraps>

80106392 <vector19>:
.globl vector19
vector19:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $19
80106394:	6a 13                	push   $0x13
  jmp alltraps
80106396:	e9 6e fa ff ff       	jmp    80105e09 <alltraps>

8010639b <vector20>:
.globl vector20
vector20:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $20
8010639d:	6a 14                	push   $0x14
  jmp alltraps
8010639f:	e9 65 fa ff ff       	jmp    80105e09 <alltraps>

801063a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $21
801063a6:	6a 15                	push   $0x15
  jmp alltraps
801063a8:	e9 5c fa ff ff       	jmp    80105e09 <alltraps>

801063ad <vector22>:
.globl vector22
vector22:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $22
801063af:	6a 16                	push   $0x16
  jmp alltraps
801063b1:	e9 53 fa ff ff       	jmp    80105e09 <alltraps>

801063b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $23
801063b8:	6a 17                	push   $0x17
  jmp alltraps
801063ba:	e9 4a fa ff ff       	jmp    80105e09 <alltraps>

801063bf <vector24>:
.globl vector24
vector24:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $24
801063c1:	6a 18                	push   $0x18
  jmp alltraps
801063c3:	e9 41 fa ff ff       	jmp    80105e09 <alltraps>

801063c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $25
801063ca:	6a 19                	push   $0x19
  jmp alltraps
801063cc:	e9 38 fa ff ff       	jmp    80105e09 <alltraps>

801063d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $26
801063d3:	6a 1a                	push   $0x1a
  jmp alltraps
801063d5:	e9 2f fa ff ff       	jmp    80105e09 <alltraps>

801063da <vector27>:
.globl vector27
vector27:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $27
801063dc:	6a 1b                	push   $0x1b
  jmp alltraps
801063de:	e9 26 fa ff ff       	jmp    80105e09 <alltraps>

801063e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $28
801063e5:	6a 1c                	push   $0x1c
  jmp alltraps
801063e7:	e9 1d fa ff ff       	jmp    80105e09 <alltraps>

801063ec <vector29>:
.globl vector29
vector29:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $29
801063ee:	6a 1d                	push   $0x1d
  jmp alltraps
801063f0:	e9 14 fa ff ff       	jmp    80105e09 <alltraps>

801063f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $30
801063f7:	6a 1e                	push   $0x1e
  jmp alltraps
801063f9:	e9 0b fa ff ff       	jmp    80105e09 <alltraps>

801063fe <vector31>:
.globl vector31
vector31:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $31
80106400:	6a 1f                	push   $0x1f
  jmp alltraps
80106402:	e9 02 fa ff ff       	jmp    80105e09 <alltraps>

80106407 <vector32>:
.globl vector32
vector32:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $32
80106409:	6a 20                	push   $0x20
  jmp alltraps
8010640b:	e9 f9 f9 ff ff       	jmp    80105e09 <alltraps>

80106410 <vector33>:
.globl vector33
vector33:
  pushl $0
80106410:	6a 00                	push   $0x0
  pushl $33
80106412:	6a 21                	push   $0x21
  jmp alltraps
80106414:	e9 f0 f9 ff ff       	jmp    80105e09 <alltraps>

80106419 <vector34>:
.globl vector34
vector34:
  pushl $0
80106419:	6a 00                	push   $0x0
  pushl $34
8010641b:	6a 22                	push   $0x22
  jmp alltraps
8010641d:	e9 e7 f9 ff ff       	jmp    80105e09 <alltraps>

80106422 <vector35>:
.globl vector35
vector35:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $35
80106424:	6a 23                	push   $0x23
  jmp alltraps
80106426:	e9 de f9 ff ff       	jmp    80105e09 <alltraps>

8010642b <vector36>:
.globl vector36
vector36:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $36
8010642d:	6a 24                	push   $0x24
  jmp alltraps
8010642f:	e9 d5 f9 ff ff       	jmp    80105e09 <alltraps>

80106434 <vector37>:
.globl vector37
vector37:
  pushl $0
80106434:	6a 00                	push   $0x0
  pushl $37
80106436:	6a 25                	push   $0x25
  jmp alltraps
80106438:	e9 cc f9 ff ff       	jmp    80105e09 <alltraps>

8010643d <vector38>:
.globl vector38
vector38:
  pushl $0
8010643d:	6a 00                	push   $0x0
  pushl $38
8010643f:	6a 26                	push   $0x26
  jmp alltraps
80106441:	e9 c3 f9 ff ff       	jmp    80105e09 <alltraps>

80106446 <vector39>:
.globl vector39
vector39:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $39
80106448:	6a 27                	push   $0x27
  jmp alltraps
8010644a:	e9 ba f9 ff ff       	jmp    80105e09 <alltraps>

8010644f <vector40>:
.globl vector40
vector40:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $40
80106451:	6a 28                	push   $0x28
  jmp alltraps
80106453:	e9 b1 f9 ff ff       	jmp    80105e09 <alltraps>

80106458 <vector41>:
.globl vector41
vector41:
  pushl $0
80106458:	6a 00                	push   $0x0
  pushl $41
8010645a:	6a 29                	push   $0x29
  jmp alltraps
8010645c:	e9 a8 f9 ff ff       	jmp    80105e09 <alltraps>

80106461 <vector42>:
.globl vector42
vector42:
  pushl $0
80106461:	6a 00                	push   $0x0
  pushl $42
80106463:	6a 2a                	push   $0x2a
  jmp alltraps
80106465:	e9 9f f9 ff ff       	jmp    80105e09 <alltraps>

8010646a <vector43>:
.globl vector43
vector43:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $43
8010646c:	6a 2b                	push   $0x2b
  jmp alltraps
8010646e:	e9 96 f9 ff ff       	jmp    80105e09 <alltraps>

80106473 <vector44>:
.globl vector44
vector44:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $44
80106475:	6a 2c                	push   $0x2c
  jmp alltraps
80106477:	e9 8d f9 ff ff       	jmp    80105e09 <alltraps>

8010647c <vector45>:
.globl vector45
vector45:
  pushl $0
8010647c:	6a 00                	push   $0x0
  pushl $45
8010647e:	6a 2d                	push   $0x2d
  jmp alltraps
80106480:	e9 84 f9 ff ff       	jmp    80105e09 <alltraps>

80106485 <vector46>:
.globl vector46
vector46:
  pushl $0
80106485:	6a 00                	push   $0x0
  pushl $46
80106487:	6a 2e                	push   $0x2e
  jmp alltraps
80106489:	e9 7b f9 ff ff       	jmp    80105e09 <alltraps>

8010648e <vector47>:
.globl vector47
vector47:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $47
80106490:	6a 2f                	push   $0x2f
  jmp alltraps
80106492:	e9 72 f9 ff ff       	jmp    80105e09 <alltraps>

80106497 <vector48>:
.globl vector48
vector48:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $48
80106499:	6a 30                	push   $0x30
  jmp alltraps
8010649b:	e9 69 f9 ff ff       	jmp    80105e09 <alltraps>

801064a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801064a0:	6a 00                	push   $0x0
  pushl $49
801064a2:	6a 31                	push   $0x31
  jmp alltraps
801064a4:	e9 60 f9 ff ff       	jmp    80105e09 <alltraps>

801064a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801064a9:	6a 00                	push   $0x0
  pushl $50
801064ab:	6a 32                	push   $0x32
  jmp alltraps
801064ad:	e9 57 f9 ff ff       	jmp    80105e09 <alltraps>

801064b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $51
801064b4:	6a 33                	push   $0x33
  jmp alltraps
801064b6:	e9 4e f9 ff ff       	jmp    80105e09 <alltraps>

801064bb <vector52>:
.globl vector52
vector52:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $52
801064bd:	6a 34                	push   $0x34
  jmp alltraps
801064bf:	e9 45 f9 ff ff       	jmp    80105e09 <alltraps>

801064c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801064c4:	6a 00                	push   $0x0
  pushl $53
801064c6:	6a 35                	push   $0x35
  jmp alltraps
801064c8:	e9 3c f9 ff ff       	jmp    80105e09 <alltraps>

801064cd <vector54>:
.globl vector54
vector54:
  pushl $0
801064cd:	6a 00                	push   $0x0
  pushl $54
801064cf:	6a 36                	push   $0x36
  jmp alltraps
801064d1:	e9 33 f9 ff ff       	jmp    80105e09 <alltraps>

801064d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $55
801064d8:	6a 37                	push   $0x37
  jmp alltraps
801064da:	e9 2a f9 ff ff       	jmp    80105e09 <alltraps>

801064df <vector56>:
.globl vector56
vector56:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $56
801064e1:	6a 38                	push   $0x38
  jmp alltraps
801064e3:	e9 21 f9 ff ff       	jmp    80105e09 <alltraps>

801064e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801064e8:	6a 00                	push   $0x0
  pushl $57
801064ea:	6a 39                	push   $0x39
  jmp alltraps
801064ec:	e9 18 f9 ff ff       	jmp    80105e09 <alltraps>

801064f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801064f1:	6a 00                	push   $0x0
  pushl $58
801064f3:	6a 3a                	push   $0x3a
  jmp alltraps
801064f5:	e9 0f f9 ff ff       	jmp    80105e09 <alltraps>

801064fa <vector59>:
.globl vector59
vector59:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $59
801064fc:	6a 3b                	push   $0x3b
  jmp alltraps
801064fe:	e9 06 f9 ff ff       	jmp    80105e09 <alltraps>

80106503 <vector60>:
.globl vector60
vector60:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $60
80106505:	6a 3c                	push   $0x3c
  jmp alltraps
80106507:	e9 fd f8 ff ff       	jmp    80105e09 <alltraps>

8010650c <vector61>:
.globl vector61
vector61:
  pushl $0
8010650c:	6a 00                	push   $0x0
  pushl $61
8010650e:	6a 3d                	push   $0x3d
  jmp alltraps
80106510:	e9 f4 f8 ff ff       	jmp    80105e09 <alltraps>

80106515 <vector62>:
.globl vector62
vector62:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $62
80106517:	6a 3e                	push   $0x3e
  jmp alltraps
80106519:	e9 eb f8 ff ff       	jmp    80105e09 <alltraps>

8010651e <vector63>:
.globl vector63
vector63:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $63
80106520:	6a 3f                	push   $0x3f
  jmp alltraps
80106522:	e9 e2 f8 ff ff       	jmp    80105e09 <alltraps>

80106527 <vector64>:
.globl vector64
vector64:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $64
80106529:	6a 40                	push   $0x40
  jmp alltraps
8010652b:	e9 d9 f8 ff ff       	jmp    80105e09 <alltraps>

80106530 <vector65>:
.globl vector65
vector65:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $65
80106532:	6a 41                	push   $0x41
  jmp alltraps
80106534:	e9 d0 f8 ff ff       	jmp    80105e09 <alltraps>

80106539 <vector66>:
.globl vector66
vector66:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $66
8010653b:	6a 42                	push   $0x42
  jmp alltraps
8010653d:	e9 c7 f8 ff ff       	jmp    80105e09 <alltraps>

80106542 <vector67>:
.globl vector67
vector67:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $67
80106544:	6a 43                	push   $0x43
  jmp alltraps
80106546:	e9 be f8 ff ff       	jmp    80105e09 <alltraps>

8010654b <vector68>:
.globl vector68
vector68:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $68
8010654d:	6a 44                	push   $0x44
  jmp alltraps
8010654f:	e9 b5 f8 ff ff       	jmp    80105e09 <alltraps>

80106554 <vector69>:
.globl vector69
vector69:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $69
80106556:	6a 45                	push   $0x45
  jmp alltraps
80106558:	e9 ac f8 ff ff       	jmp    80105e09 <alltraps>

8010655d <vector70>:
.globl vector70
vector70:
  pushl $0
8010655d:	6a 00                	push   $0x0
  pushl $70
8010655f:	6a 46                	push   $0x46
  jmp alltraps
80106561:	e9 a3 f8 ff ff       	jmp    80105e09 <alltraps>

80106566 <vector71>:
.globl vector71
vector71:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $71
80106568:	6a 47                	push   $0x47
  jmp alltraps
8010656a:	e9 9a f8 ff ff       	jmp    80105e09 <alltraps>

8010656f <vector72>:
.globl vector72
vector72:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $72
80106571:	6a 48                	push   $0x48
  jmp alltraps
80106573:	e9 91 f8 ff ff       	jmp    80105e09 <alltraps>

80106578 <vector73>:
.globl vector73
vector73:
  pushl $0
80106578:	6a 00                	push   $0x0
  pushl $73
8010657a:	6a 49                	push   $0x49
  jmp alltraps
8010657c:	e9 88 f8 ff ff       	jmp    80105e09 <alltraps>

80106581 <vector74>:
.globl vector74
vector74:
  pushl $0
80106581:	6a 00                	push   $0x0
  pushl $74
80106583:	6a 4a                	push   $0x4a
  jmp alltraps
80106585:	e9 7f f8 ff ff       	jmp    80105e09 <alltraps>

8010658a <vector75>:
.globl vector75
vector75:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $75
8010658c:	6a 4b                	push   $0x4b
  jmp alltraps
8010658e:	e9 76 f8 ff ff       	jmp    80105e09 <alltraps>

80106593 <vector76>:
.globl vector76
vector76:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $76
80106595:	6a 4c                	push   $0x4c
  jmp alltraps
80106597:	e9 6d f8 ff ff       	jmp    80105e09 <alltraps>

8010659c <vector77>:
.globl vector77
vector77:
  pushl $0
8010659c:	6a 00                	push   $0x0
  pushl $77
8010659e:	6a 4d                	push   $0x4d
  jmp alltraps
801065a0:	e9 64 f8 ff ff       	jmp    80105e09 <alltraps>

801065a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801065a5:	6a 00                	push   $0x0
  pushl $78
801065a7:	6a 4e                	push   $0x4e
  jmp alltraps
801065a9:	e9 5b f8 ff ff       	jmp    80105e09 <alltraps>

801065ae <vector79>:
.globl vector79
vector79:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $79
801065b0:	6a 4f                	push   $0x4f
  jmp alltraps
801065b2:	e9 52 f8 ff ff       	jmp    80105e09 <alltraps>

801065b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $80
801065b9:	6a 50                	push   $0x50
  jmp alltraps
801065bb:	e9 49 f8 ff ff       	jmp    80105e09 <alltraps>

801065c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801065c0:	6a 00                	push   $0x0
  pushl $81
801065c2:	6a 51                	push   $0x51
  jmp alltraps
801065c4:	e9 40 f8 ff ff       	jmp    80105e09 <alltraps>

801065c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801065c9:	6a 00                	push   $0x0
  pushl $82
801065cb:	6a 52                	push   $0x52
  jmp alltraps
801065cd:	e9 37 f8 ff ff       	jmp    80105e09 <alltraps>

801065d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $83
801065d4:	6a 53                	push   $0x53
  jmp alltraps
801065d6:	e9 2e f8 ff ff       	jmp    80105e09 <alltraps>

801065db <vector84>:
.globl vector84
vector84:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $84
801065dd:	6a 54                	push   $0x54
  jmp alltraps
801065df:	e9 25 f8 ff ff       	jmp    80105e09 <alltraps>

801065e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801065e4:	6a 00                	push   $0x0
  pushl $85
801065e6:	6a 55                	push   $0x55
  jmp alltraps
801065e8:	e9 1c f8 ff ff       	jmp    80105e09 <alltraps>

801065ed <vector86>:
.globl vector86
vector86:
  pushl $0
801065ed:	6a 00                	push   $0x0
  pushl $86
801065ef:	6a 56                	push   $0x56
  jmp alltraps
801065f1:	e9 13 f8 ff ff       	jmp    80105e09 <alltraps>

801065f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $87
801065f8:	6a 57                	push   $0x57
  jmp alltraps
801065fa:	e9 0a f8 ff ff       	jmp    80105e09 <alltraps>

801065ff <vector88>:
.globl vector88
vector88:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $88
80106601:	6a 58                	push   $0x58
  jmp alltraps
80106603:	e9 01 f8 ff ff       	jmp    80105e09 <alltraps>

80106608 <vector89>:
.globl vector89
vector89:
  pushl $0
80106608:	6a 00                	push   $0x0
  pushl $89
8010660a:	6a 59                	push   $0x59
  jmp alltraps
8010660c:	e9 f8 f7 ff ff       	jmp    80105e09 <alltraps>

80106611 <vector90>:
.globl vector90
vector90:
  pushl $0
80106611:	6a 00                	push   $0x0
  pushl $90
80106613:	6a 5a                	push   $0x5a
  jmp alltraps
80106615:	e9 ef f7 ff ff       	jmp    80105e09 <alltraps>

8010661a <vector91>:
.globl vector91
vector91:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $91
8010661c:	6a 5b                	push   $0x5b
  jmp alltraps
8010661e:	e9 e6 f7 ff ff       	jmp    80105e09 <alltraps>

80106623 <vector92>:
.globl vector92
vector92:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $92
80106625:	6a 5c                	push   $0x5c
  jmp alltraps
80106627:	e9 dd f7 ff ff       	jmp    80105e09 <alltraps>

8010662c <vector93>:
.globl vector93
vector93:
  pushl $0
8010662c:	6a 00                	push   $0x0
  pushl $93
8010662e:	6a 5d                	push   $0x5d
  jmp alltraps
80106630:	e9 d4 f7 ff ff       	jmp    80105e09 <alltraps>

80106635 <vector94>:
.globl vector94
vector94:
  pushl $0
80106635:	6a 00                	push   $0x0
  pushl $94
80106637:	6a 5e                	push   $0x5e
  jmp alltraps
80106639:	e9 cb f7 ff ff       	jmp    80105e09 <alltraps>

8010663e <vector95>:
.globl vector95
vector95:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $95
80106640:	6a 5f                	push   $0x5f
  jmp alltraps
80106642:	e9 c2 f7 ff ff       	jmp    80105e09 <alltraps>

80106647 <vector96>:
.globl vector96
vector96:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $96
80106649:	6a 60                	push   $0x60
  jmp alltraps
8010664b:	e9 b9 f7 ff ff       	jmp    80105e09 <alltraps>

80106650 <vector97>:
.globl vector97
vector97:
  pushl $0
80106650:	6a 00                	push   $0x0
  pushl $97
80106652:	6a 61                	push   $0x61
  jmp alltraps
80106654:	e9 b0 f7 ff ff       	jmp    80105e09 <alltraps>

80106659 <vector98>:
.globl vector98
vector98:
  pushl $0
80106659:	6a 00                	push   $0x0
  pushl $98
8010665b:	6a 62                	push   $0x62
  jmp alltraps
8010665d:	e9 a7 f7 ff ff       	jmp    80105e09 <alltraps>

80106662 <vector99>:
.globl vector99
vector99:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $99
80106664:	6a 63                	push   $0x63
  jmp alltraps
80106666:	e9 9e f7 ff ff       	jmp    80105e09 <alltraps>

8010666b <vector100>:
.globl vector100
vector100:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $100
8010666d:	6a 64                	push   $0x64
  jmp alltraps
8010666f:	e9 95 f7 ff ff       	jmp    80105e09 <alltraps>

80106674 <vector101>:
.globl vector101
vector101:
  pushl $0
80106674:	6a 00                	push   $0x0
  pushl $101
80106676:	6a 65                	push   $0x65
  jmp alltraps
80106678:	e9 8c f7 ff ff       	jmp    80105e09 <alltraps>

8010667d <vector102>:
.globl vector102
vector102:
  pushl $0
8010667d:	6a 00                	push   $0x0
  pushl $102
8010667f:	6a 66                	push   $0x66
  jmp alltraps
80106681:	e9 83 f7 ff ff       	jmp    80105e09 <alltraps>

80106686 <vector103>:
.globl vector103
vector103:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $103
80106688:	6a 67                	push   $0x67
  jmp alltraps
8010668a:	e9 7a f7 ff ff       	jmp    80105e09 <alltraps>

8010668f <vector104>:
.globl vector104
vector104:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $104
80106691:	6a 68                	push   $0x68
  jmp alltraps
80106693:	e9 71 f7 ff ff       	jmp    80105e09 <alltraps>

80106698 <vector105>:
.globl vector105
vector105:
  pushl $0
80106698:	6a 00                	push   $0x0
  pushl $105
8010669a:	6a 69                	push   $0x69
  jmp alltraps
8010669c:	e9 68 f7 ff ff       	jmp    80105e09 <alltraps>

801066a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801066a1:	6a 00                	push   $0x0
  pushl $106
801066a3:	6a 6a                	push   $0x6a
  jmp alltraps
801066a5:	e9 5f f7 ff ff       	jmp    80105e09 <alltraps>

801066aa <vector107>:
.globl vector107
vector107:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $107
801066ac:	6a 6b                	push   $0x6b
  jmp alltraps
801066ae:	e9 56 f7 ff ff       	jmp    80105e09 <alltraps>

801066b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $108
801066b5:	6a 6c                	push   $0x6c
  jmp alltraps
801066b7:	e9 4d f7 ff ff       	jmp    80105e09 <alltraps>

801066bc <vector109>:
.globl vector109
vector109:
  pushl $0
801066bc:	6a 00                	push   $0x0
  pushl $109
801066be:	6a 6d                	push   $0x6d
  jmp alltraps
801066c0:	e9 44 f7 ff ff       	jmp    80105e09 <alltraps>

801066c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801066c5:	6a 00                	push   $0x0
  pushl $110
801066c7:	6a 6e                	push   $0x6e
  jmp alltraps
801066c9:	e9 3b f7 ff ff       	jmp    80105e09 <alltraps>

801066ce <vector111>:
.globl vector111
vector111:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $111
801066d0:	6a 6f                	push   $0x6f
  jmp alltraps
801066d2:	e9 32 f7 ff ff       	jmp    80105e09 <alltraps>

801066d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $112
801066d9:	6a 70                	push   $0x70
  jmp alltraps
801066db:	e9 29 f7 ff ff       	jmp    80105e09 <alltraps>

801066e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801066e0:	6a 00                	push   $0x0
  pushl $113
801066e2:	6a 71                	push   $0x71
  jmp alltraps
801066e4:	e9 20 f7 ff ff       	jmp    80105e09 <alltraps>

801066e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801066e9:	6a 00                	push   $0x0
  pushl $114
801066eb:	6a 72                	push   $0x72
  jmp alltraps
801066ed:	e9 17 f7 ff ff       	jmp    80105e09 <alltraps>

801066f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $115
801066f4:	6a 73                	push   $0x73
  jmp alltraps
801066f6:	e9 0e f7 ff ff       	jmp    80105e09 <alltraps>

801066fb <vector116>:
.globl vector116
vector116:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $116
801066fd:	6a 74                	push   $0x74
  jmp alltraps
801066ff:	e9 05 f7 ff ff       	jmp    80105e09 <alltraps>

80106704 <vector117>:
.globl vector117
vector117:
  pushl $0
80106704:	6a 00                	push   $0x0
  pushl $117
80106706:	6a 75                	push   $0x75
  jmp alltraps
80106708:	e9 fc f6 ff ff       	jmp    80105e09 <alltraps>

8010670d <vector118>:
.globl vector118
vector118:
  pushl $0
8010670d:	6a 00                	push   $0x0
  pushl $118
8010670f:	6a 76                	push   $0x76
  jmp alltraps
80106711:	e9 f3 f6 ff ff       	jmp    80105e09 <alltraps>

80106716 <vector119>:
.globl vector119
vector119:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $119
80106718:	6a 77                	push   $0x77
  jmp alltraps
8010671a:	e9 ea f6 ff ff       	jmp    80105e09 <alltraps>

8010671f <vector120>:
.globl vector120
vector120:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $120
80106721:	6a 78                	push   $0x78
  jmp alltraps
80106723:	e9 e1 f6 ff ff       	jmp    80105e09 <alltraps>

80106728 <vector121>:
.globl vector121
vector121:
  pushl $0
80106728:	6a 00                	push   $0x0
  pushl $121
8010672a:	6a 79                	push   $0x79
  jmp alltraps
8010672c:	e9 d8 f6 ff ff       	jmp    80105e09 <alltraps>

80106731 <vector122>:
.globl vector122
vector122:
  pushl $0
80106731:	6a 00                	push   $0x0
  pushl $122
80106733:	6a 7a                	push   $0x7a
  jmp alltraps
80106735:	e9 cf f6 ff ff       	jmp    80105e09 <alltraps>

8010673a <vector123>:
.globl vector123
vector123:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $123
8010673c:	6a 7b                	push   $0x7b
  jmp alltraps
8010673e:	e9 c6 f6 ff ff       	jmp    80105e09 <alltraps>

80106743 <vector124>:
.globl vector124
vector124:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $124
80106745:	6a 7c                	push   $0x7c
  jmp alltraps
80106747:	e9 bd f6 ff ff       	jmp    80105e09 <alltraps>

8010674c <vector125>:
.globl vector125
vector125:
  pushl $0
8010674c:	6a 00                	push   $0x0
  pushl $125
8010674e:	6a 7d                	push   $0x7d
  jmp alltraps
80106750:	e9 b4 f6 ff ff       	jmp    80105e09 <alltraps>

80106755 <vector126>:
.globl vector126
vector126:
  pushl $0
80106755:	6a 00                	push   $0x0
  pushl $126
80106757:	6a 7e                	push   $0x7e
  jmp alltraps
80106759:	e9 ab f6 ff ff       	jmp    80105e09 <alltraps>

8010675e <vector127>:
.globl vector127
vector127:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $127
80106760:	6a 7f                	push   $0x7f
  jmp alltraps
80106762:	e9 a2 f6 ff ff       	jmp    80105e09 <alltraps>

80106767 <vector128>:
.globl vector128
vector128:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $128
80106769:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010676e:	e9 96 f6 ff ff       	jmp    80105e09 <alltraps>

80106773 <vector129>:
.globl vector129
vector129:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $129
80106775:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010677a:	e9 8a f6 ff ff       	jmp    80105e09 <alltraps>

8010677f <vector130>:
.globl vector130
vector130:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $130
80106781:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106786:	e9 7e f6 ff ff       	jmp    80105e09 <alltraps>

8010678b <vector131>:
.globl vector131
vector131:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $131
8010678d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106792:	e9 72 f6 ff ff       	jmp    80105e09 <alltraps>

80106797 <vector132>:
.globl vector132
vector132:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $132
80106799:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010679e:	e9 66 f6 ff ff       	jmp    80105e09 <alltraps>

801067a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $133
801067a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801067aa:	e9 5a f6 ff ff       	jmp    80105e09 <alltraps>

801067af <vector134>:
.globl vector134
vector134:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $134
801067b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801067b6:	e9 4e f6 ff ff       	jmp    80105e09 <alltraps>

801067bb <vector135>:
.globl vector135
vector135:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $135
801067bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801067c2:	e9 42 f6 ff ff       	jmp    80105e09 <alltraps>

801067c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $136
801067c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801067ce:	e9 36 f6 ff ff       	jmp    80105e09 <alltraps>

801067d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $137
801067d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801067da:	e9 2a f6 ff ff       	jmp    80105e09 <alltraps>

801067df <vector138>:
.globl vector138
vector138:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $138
801067e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801067e6:	e9 1e f6 ff ff       	jmp    80105e09 <alltraps>

801067eb <vector139>:
.globl vector139
vector139:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $139
801067ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801067f2:	e9 12 f6 ff ff       	jmp    80105e09 <alltraps>

801067f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $140
801067f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801067fe:	e9 06 f6 ff ff       	jmp    80105e09 <alltraps>

80106803 <vector141>:
.globl vector141
vector141:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $141
80106805:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010680a:	e9 fa f5 ff ff       	jmp    80105e09 <alltraps>

8010680f <vector142>:
.globl vector142
vector142:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $142
80106811:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106816:	e9 ee f5 ff ff       	jmp    80105e09 <alltraps>

8010681b <vector143>:
.globl vector143
vector143:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $143
8010681d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106822:	e9 e2 f5 ff ff       	jmp    80105e09 <alltraps>

80106827 <vector144>:
.globl vector144
vector144:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $144
80106829:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010682e:	e9 d6 f5 ff ff       	jmp    80105e09 <alltraps>

80106833 <vector145>:
.globl vector145
vector145:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $145
80106835:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010683a:	e9 ca f5 ff ff       	jmp    80105e09 <alltraps>

8010683f <vector146>:
.globl vector146
vector146:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $146
80106841:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106846:	e9 be f5 ff ff       	jmp    80105e09 <alltraps>

8010684b <vector147>:
.globl vector147
vector147:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $147
8010684d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106852:	e9 b2 f5 ff ff       	jmp    80105e09 <alltraps>

80106857 <vector148>:
.globl vector148
vector148:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $148
80106859:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010685e:	e9 a6 f5 ff ff       	jmp    80105e09 <alltraps>

80106863 <vector149>:
.globl vector149
vector149:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $149
80106865:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010686a:	e9 9a f5 ff ff       	jmp    80105e09 <alltraps>

8010686f <vector150>:
.globl vector150
vector150:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $150
80106871:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106876:	e9 8e f5 ff ff       	jmp    80105e09 <alltraps>

8010687b <vector151>:
.globl vector151
vector151:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $151
8010687d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106882:	e9 82 f5 ff ff       	jmp    80105e09 <alltraps>

80106887 <vector152>:
.globl vector152
vector152:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $152
80106889:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010688e:	e9 76 f5 ff ff       	jmp    80105e09 <alltraps>

80106893 <vector153>:
.globl vector153
vector153:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $153
80106895:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010689a:	e9 6a f5 ff ff       	jmp    80105e09 <alltraps>

8010689f <vector154>:
.globl vector154
vector154:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $154
801068a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801068a6:	e9 5e f5 ff ff       	jmp    80105e09 <alltraps>

801068ab <vector155>:
.globl vector155
vector155:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $155
801068ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801068b2:	e9 52 f5 ff ff       	jmp    80105e09 <alltraps>

801068b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $156
801068b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801068be:	e9 46 f5 ff ff       	jmp    80105e09 <alltraps>

801068c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $157
801068c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801068ca:	e9 3a f5 ff ff       	jmp    80105e09 <alltraps>

801068cf <vector158>:
.globl vector158
vector158:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $158
801068d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801068d6:	e9 2e f5 ff ff       	jmp    80105e09 <alltraps>

801068db <vector159>:
.globl vector159
vector159:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $159
801068dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801068e2:	e9 22 f5 ff ff       	jmp    80105e09 <alltraps>

801068e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $160
801068e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801068ee:	e9 16 f5 ff ff       	jmp    80105e09 <alltraps>

801068f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $161
801068f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801068fa:	e9 0a f5 ff ff       	jmp    80105e09 <alltraps>

801068ff <vector162>:
.globl vector162
vector162:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $162
80106901:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106906:	e9 fe f4 ff ff       	jmp    80105e09 <alltraps>

8010690b <vector163>:
.globl vector163
vector163:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $163
8010690d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106912:	e9 f2 f4 ff ff       	jmp    80105e09 <alltraps>

80106917 <vector164>:
.globl vector164
vector164:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $164
80106919:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010691e:	e9 e6 f4 ff ff       	jmp    80105e09 <alltraps>

80106923 <vector165>:
.globl vector165
vector165:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $165
80106925:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010692a:	e9 da f4 ff ff       	jmp    80105e09 <alltraps>

8010692f <vector166>:
.globl vector166
vector166:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $166
80106931:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106936:	e9 ce f4 ff ff       	jmp    80105e09 <alltraps>

8010693b <vector167>:
.globl vector167
vector167:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $167
8010693d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106942:	e9 c2 f4 ff ff       	jmp    80105e09 <alltraps>

80106947 <vector168>:
.globl vector168
vector168:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $168
80106949:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010694e:	e9 b6 f4 ff ff       	jmp    80105e09 <alltraps>

80106953 <vector169>:
.globl vector169
vector169:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $169
80106955:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010695a:	e9 aa f4 ff ff       	jmp    80105e09 <alltraps>

8010695f <vector170>:
.globl vector170
vector170:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $170
80106961:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106966:	e9 9e f4 ff ff       	jmp    80105e09 <alltraps>

8010696b <vector171>:
.globl vector171
vector171:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $171
8010696d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106972:	e9 92 f4 ff ff       	jmp    80105e09 <alltraps>

80106977 <vector172>:
.globl vector172
vector172:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $172
80106979:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010697e:	e9 86 f4 ff ff       	jmp    80105e09 <alltraps>

80106983 <vector173>:
.globl vector173
vector173:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $173
80106985:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010698a:	e9 7a f4 ff ff       	jmp    80105e09 <alltraps>

8010698f <vector174>:
.globl vector174
vector174:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $174
80106991:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106996:	e9 6e f4 ff ff       	jmp    80105e09 <alltraps>

8010699b <vector175>:
.globl vector175
vector175:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $175
8010699d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801069a2:	e9 62 f4 ff ff       	jmp    80105e09 <alltraps>

801069a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $176
801069a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801069ae:	e9 56 f4 ff ff       	jmp    80105e09 <alltraps>

801069b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $177
801069b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801069ba:	e9 4a f4 ff ff       	jmp    80105e09 <alltraps>

801069bf <vector178>:
.globl vector178
vector178:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $178
801069c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801069c6:	e9 3e f4 ff ff       	jmp    80105e09 <alltraps>

801069cb <vector179>:
.globl vector179
vector179:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $179
801069cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801069d2:	e9 32 f4 ff ff       	jmp    80105e09 <alltraps>

801069d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $180
801069d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801069de:	e9 26 f4 ff ff       	jmp    80105e09 <alltraps>

801069e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $181
801069e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801069ea:	e9 1a f4 ff ff       	jmp    80105e09 <alltraps>

801069ef <vector182>:
.globl vector182
vector182:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $182
801069f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801069f6:	e9 0e f4 ff ff       	jmp    80105e09 <alltraps>

801069fb <vector183>:
.globl vector183
vector183:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $183
801069fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a02:	e9 02 f4 ff ff       	jmp    80105e09 <alltraps>

80106a07 <vector184>:
.globl vector184
vector184:
  pushl $0
80106a07:	6a 00                	push   $0x0
  pushl $184
80106a09:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106a0e:	e9 f6 f3 ff ff       	jmp    80105e09 <alltraps>

80106a13 <vector185>:
.globl vector185
vector185:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $185
80106a15:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106a1a:	e9 ea f3 ff ff       	jmp    80105e09 <alltraps>

80106a1f <vector186>:
.globl vector186
vector186:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $186
80106a21:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106a26:	e9 de f3 ff ff       	jmp    80105e09 <alltraps>

80106a2b <vector187>:
.globl vector187
vector187:
  pushl $0
80106a2b:	6a 00                	push   $0x0
  pushl $187
80106a2d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106a32:	e9 d2 f3 ff ff       	jmp    80105e09 <alltraps>

80106a37 <vector188>:
.globl vector188
vector188:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $188
80106a39:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106a3e:	e9 c6 f3 ff ff       	jmp    80105e09 <alltraps>

80106a43 <vector189>:
.globl vector189
vector189:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $189
80106a45:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106a4a:	e9 ba f3 ff ff       	jmp    80105e09 <alltraps>

80106a4f <vector190>:
.globl vector190
vector190:
  pushl $0
80106a4f:	6a 00                	push   $0x0
  pushl $190
80106a51:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a56:	e9 ae f3 ff ff       	jmp    80105e09 <alltraps>

80106a5b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $191
80106a5d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a62:	e9 a2 f3 ff ff       	jmp    80105e09 <alltraps>

80106a67 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $192
80106a69:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a6e:	e9 96 f3 ff ff       	jmp    80105e09 <alltraps>

80106a73 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $193
80106a75:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a7a:	e9 8a f3 ff ff       	jmp    80105e09 <alltraps>

80106a7f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $194
80106a81:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a86:	e9 7e f3 ff ff       	jmp    80105e09 <alltraps>

80106a8b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $195
80106a8d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a92:	e9 72 f3 ff ff       	jmp    80105e09 <alltraps>

80106a97 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $196
80106a99:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a9e:	e9 66 f3 ff ff       	jmp    80105e09 <alltraps>

80106aa3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $197
80106aa5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106aaa:	e9 5a f3 ff ff       	jmp    80105e09 <alltraps>

80106aaf <vector198>:
.globl vector198
vector198:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $198
80106ab1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106ab6:	e9 4e f3 ff ff       	jmp    80105e09 <alltraps>

80106abb <vector199>:
.globl vector199
vector199:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $199
80106abd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ac2:	e9 42 f3 ff ff       	jmp    80105e09 <alltraps>

80106ac7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $200
80106ac9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106ace:	e9 36 f3 ff ff       	jmp    80105e09 <alltraps>

80106ad3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $201
80106ad5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106ada:	e9 2a f3 ff ff       	jmp    80105e09 <alltraps>

80106adf <vector202>:
.globl vector202
vector202:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $202
80106ae1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106ae6:	e9 1e f3 ff ff       	jmp    80105e09 <alltraps>

80106aeb <vector203>:
.globl vector203
vector203:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $203
80106aed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106af2:	e9 12 f3 ff ff       	jmp    80105e09 <alltraps>

80106af7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $204
80106af9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106afe:	e9 06 f3 ff ff       	jmp    80105e09 <alltraps>

80106b03 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $205
80106b05:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b0a:	e9 fa f2 ff ff       	jmp    80105e09 <alltraps>

80106b0f <vector206>:
.globl vector206
vector206:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $206
80106b11:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106b16:	e9 ee f2 ff ff       	jmp    80105e09 <alltraps>

80106b1b <vector207>:
.globl vector207
vector207:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $207
80106b1d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106b22:	e9 e2 f2 ff ff       	jmp    80105e09 <alltraps>

80106b27 <vector208>:
.globl vector208
vector208:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $208
80106b29:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106b2e:	e9 d6 f2 ff ff       	jmp    80105e09 <alltraps>

80106b33 <vector209>:
.globl vector209
vector209:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $209
80106b35:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106b3a:	e9 ca f2 ff ff       	jmp    80105e09 <alltraps>

80106b3f <vector210>:
.globl vector210
vector210:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $210
80106b41:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106b46:	e9 be f2 ff ff       	jmp    80105e09 <alltraps>

80106b4b <vector211>:
.globl vector211
vector211:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $211
80106b4d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b52:	e9 b2 f2 ff ff       	jmp    80105e09 <alltraps>

80106b57 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $212
80106b59:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b5e:	e9 a6 f2 ff ff       	jmp    80105e09 <alltraps>

80106b63 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $213
80106b65:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b6a:	e9 9a f2 ff ff       	jmp    80105e09 <alltraps>

80106b6f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $214
80106b71:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b76:	e9 8e f2 ff ff       	jmp    80105e09 <alltraps>

80106b7b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $215
80106b7d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b82:	e9 82 f2 ff ff       	jmp    80105e09 <alltraps>

80106b87 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $216
80106b89:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b8e:	e9 76 f2 ff ff       	jmp    80105e09 <alltraps>

80106b93 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $217
80106b95:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b9a:	e9 6a f2 ff ff       	jmp    80105e09 <alltraps>

80106b9f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $218
80106ba1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ba6:	e9 5e f2 ff ff       	jmp    80105e09 <alltraps>

80106bab <vector219>:
.globl vector219
vector219:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $219
80106bad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106bb2:	e9 52 f2 ff ff       	jmp    80105e09 <alltraps>

80106bb7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $220
80106bb9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106bbe:	e9 46 f2 ff ff       	jmp    80105e09 <alltraps>

80106bc3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $221
80106bc5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106bca:	e9 3a f2 ff ff       	jmp    80105e09 <alltraps>

80106bcf <vector222>:
.globl vector222
vector222:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $222
80106bd1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106bd6:	e9 2e f2 ff ff       	jmp    80105e09 <alltraps>

80106bdb <vector223>:
.globl vector223
vector223:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $223
80106bdd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106be2:	e9 22 f2 ff ff       	jmp    80105e09 <alltraps>

80106be7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $224
80106be9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106bee:	e9 16 f2 ff ff       	jmp    80105e09 <alltraps>

80106bf3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $225
80106bf5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106bfa:	e9 0a f2 ff ff       	jmp    80105e09 <alltraps>

80106bff <vector226>:
.globl vector226
vector226:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $226
80106c01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c06:	e9 fe f1 ff ff       	jmp    80105e09 <alltraps>

80106c0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $227
80106c0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106c12:	e9 f2 f1 ff ff       	jmp    80105e09 <alltraps>

80106c17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $228
80106c19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106c1e:	e9 e6 f1 ff ff       	jmp    80105e09 <alltraps>

80106c23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $229
80106c25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106c2a:	e9 da f1 ff ff       	jmp    80105e09 <alltraps>

80106c2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $230
80106c31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106c36:	e9 ce f1 ff ff       	jmp    80105e09 <alltraps>

80106c3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $231
80106c3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106c42:	e9 c2 f1 ff ff       	jmp    80105e09 <alltraps>

80106c47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $232
80106c49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106c4e:	e9 b6 f1 ff ff       	jmp    80105e09 <alltraps>

80106c53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $233
80106c55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c5a:	e9 aa f1 ff ff       	jmp    80105e09 <alltraps>

80106c5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $234
80106c61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c66:	e9 9e f1 ff ff       	jmp    80105e09 <alltraps>

80106c6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $235
80106c6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c72:	e9 92 f1 ff ff       	jmp    80105e09 <alltraps>

80106c77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $236
80106c79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c7e:	e9 86 f1 ff ff       	jmp    80105e09 <alltraps>

80106c83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $237
80106c85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c8a:	e9 7a f1 ff ff       	jmp    80105e09 <alltraps>

80106c8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $238
80106c91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c96:	e9 6e f1 ff ff       	jmp    80105e09 <alltraps>

80106c9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $239
80106c9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ca2:	e9 62 f1 ff ff       	jmp    80105e09 <alltraps>

80106ca7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $240
80106ca9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106cae:	e9 56 f1 ff ff       	jmp    80105e09 <alltraps>

80106cb3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $241
80106cb5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106cba:	e9 4a f1 ff ff       	jmp    80105e09 <alltraps>

80106cbf <vector242>:
.globl vector242
vector242:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $242
80106cc1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106cc6:	e9 3e f1 ff ff       	jmp    80105e09 <alltraps>

80106ccb <vector243>:
.globl vector243
vector243:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $243
80106ccd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106cd2:	e9 32 f1 ff ff       	jmp    80105e09 <alltraps>

80106cd7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $244
80106cd9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106cde:	e9 26 f1 ff ff       	jmp    80105e09 <alltraps>

80106ce3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $245
80106ce5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106cea:	e9 1a f1 ff ff       	jmp    80105e09 <alltraps>

80106cef <vector246>:
.globl vector246
vector246:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $246
80106cf1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106cf6:	e9 0e f1 ff ff       	jmp    80105e09 <alltraps>

80106cfb <vector247>:
.globl vector247
vector247:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $247
80106cfd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d02:	e9 02 f1 ff ff       	jmp    80105e09 <alltraps>

80106d07 <vector248>:
.globl vector248
vector248:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $248
80106d09:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106d0e:	e9 f6 f0 ff ff       	jmp    80105e09 <alltraps>

80106d13 <vector249>:
.globl vector249
vector249:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $249
80106d15:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106d1a:	e9 ea f0 ff ff       	jmp    80105e09 <alltraps>

80106d1f <vector250>:
.globl vector250
vector250:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $250
80106d21:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106d26:	e9 de f0 ff ff       	jmp    80105e09 <alltraps>

80106d2b <vector251>:
.globl vector251
vector251:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $251
80106d2d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106d32:	e9 d2 f0 ff ff       	jmp    80105e09 <alltraps>

80106d37 <vector252>:
.globl vector252
vector252:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $252
80106d39:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106d3e:	e9 c6 f0 ff ff       	jmp    80105e09 <alltraps>

80106d43 <vector253>:
.globl vector253
vector253:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $253
80106d45:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106d4a:	e9 ba f0 ff ff       	jmp    80105e09 <alltraps>

80106d4f <vector254>:
.globl vector254
vector254:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $254
80106d51:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d56:	e9 ae f0 ff ff       	jmp    80105e09 <alltraps>

80106d5b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $255
80106d5d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d62:	e9 a2 f0 ff ff       	jmp    80105e09 <alltraps>
80106d67:	66 90                	xchg   %ax,%ax
80106d69:	66 90                	xchg   %ax,%ax
80106d6b:	66 90                	xchg   %ax,%ax
80106d6d:	66 90                	xchg   %ax,%ax
80106d6f:	90                   	nop

80106d70 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106d76:	89 d3                	mov    %edx,%ebx
{
80106d78:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106d7a:	c1 eb 16             	shr    $0x16,%ebx
80106d7d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106d80:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106d83:	8b 06                	mov    (%esi),%eax
80106d85:	a8 01                	test   $0x1,%al
80106d87:	74 27                	je     80106db0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d8e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106d94:	c1 ef 0a             	shr    $0xa,%edi
}
80106d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106d9a:	89 fa                	mov    %edi,%edx
80106d9c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106da2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106da5:	5b                   	pop    %ebx
80106da6:	5e                   	pop    %esi
80106da7:	5f                   	pop    %edi
80106da8:	5d                   	pop    %ebp
80106da9:	c3                   	ret    
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106db0:	85 c9                	test   %ecx,%ecx
80106db2:	74 2c                	je     80106de0 <walkpgdir+0x70>
80106db4:	e8 67 b7 ff ff       	call   80102520 <kalloc>
80106db9:	85 c0                	test   %eax,%eax
80106dbb:	89 c3                	mov    %eax,%ebx
80106dbd:	74 21                	je     80106de0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106dbf:	83 ec 04             	sub    $0x4,%esp
80106dc2:	68 00 10 00 00       	push   $0x1000
80106dc7:	6a 00                	push   $0x0
80106dc9:	50                   	push   %eax
80106dca:	e8 91 dd ff ff       	call   80104b60 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106dcf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106dd5:	83 c4 10             	add    $0x10,%esp
80106dd8:	83 c8 07             	or     $0x7,%eax
80106ddb:	89 06                	mov    %eax,(%esi)
80106ddd:	eb b5                	jmp    80106d94 <walkpgdir+0x24>
80106ddf:	90                   	nop
}
80106de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106de3:	31 c0                	xor    %eax,%eax
}
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret    
80106dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106df0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106df6:	89 d3                	mov    %edx,%ebx
80106df8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106dfe:	83 ec 1c             	sub    $0x1c,%esp
80106e01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e04:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106e08:	8b 7d 08             	mov    0x8(%ebp),%edi
80106e0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e10:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e13:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e16:	29 df                	sub    %ebx,%edi
80106e18:	83 c8 01             	or     $0x1,%eax
80106e1b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106e1e:	eb 15                	jmp    80106e35 <mappages+0x45>
    if(*pte & PTE_P)
80106e20:	f6 00 01             	testb  $0x1,(%eax)
80106e23:	75 45                	jne    80106e6a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106e25:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106e28:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106e2b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e2d:	74 31                	je     80106e60 <mappages+0x70>
      break;
    a += PGSIZE;
80106e2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e38:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e3d:	89 da                	mov    %ebx,%edx
80106e3f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106e42:	e8 29 ff ff ff       	call   80106d70 <walkpgdir>
80106e47:	85 c0                	test   %eax,%eax
80106e49:	75 d5                	jne    80106e20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e53:	5b                   	pop    %ebx
80106e54:	5e                   	pop    %esi
80106e55:	5f                   	pop    %edi
80106e56:	5d                   	pop    %ebp
80106e57:	c3                   	ret    
80106e58:	90                   	nop
80106e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e63:	31 c0                	xor    %eax,%eax
}
80106e65:	5b                   	pop    %ebx
80106e66:	5e                   	pop    %esi
80106e67:	5f                   	pop    %edi
80106e68:	5d                   	pop    %ebp
80106e69:	c3                   	ret    
      panic("remap");
80106e6a:	83 ec 0c             	sub    $0xc,%esp
80106e6d:	68 d4 80 10 80       	push   $0x801080d4
80106e72:	e8 19 95 ff ff       	call   80100390 <panic>
80106e77:	89 f6                	mov    %esi,%esi
80106e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e80 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106e86:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e8c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106e8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106e94:	83 ec 1c             	sub    $0x1c,%esp
80106e97:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106e9a:	39 d3                	cmp    %edx,%ebx
80106e9c:	73 66                	jae    80106f04 <deallocuvm.part.0+0x84>
80106e9e:	89 d6                	mov    %edx,%esi
80106ea0:	eb 3d                	jmp    80106edf <deallocuvm.part.0+0x5f>
80106ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ea8:	8b 10                	mov    (%eax),%edx
80106eaa:	f6 c2 01             	test   $0x1,%dl
80106ead:	74 26                	je     80106ed5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106eaf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106eb5:	74 58                	je     80106f0f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106eb7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106eba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ec0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ec3:	52                   	push   %edx
80106ec4:	e8 a7 b4 ff ff       	call   80102370 <kfree>
      *pte = 0;
80106ec9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ecc:	83 c4 10             	add    $0x10,%esp
80106ecf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106ed5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106edb:	39 f3                	cmp    %esi,%ebx
80106edd:	73 25                	jae    80106f04 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106edf:	31 c9                	xor    %ecx,%ecx
80106ee1:	89 da                	mov    %ebx,%edx
80106ee3:	89 f8                	mov    %edi,%eax
80106ee5:	e8 86 fe ff ff       	call   80106d70 <walkpgdir>
    if(!pte)
80106eea:	85 c0                	test   %eax,%eax
80106eec:	75 ba                	jne    80106ea8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106eee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ef4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106efa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f00:	39 f3                	cmp    %esi,%ebx
80106f02:	72 db                	jb     80106edf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106f04:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f0a:	5b                   	pop    %ebx
80106f0b:	5e                   	pop    %esi
80106f0c:	5f                   	pop    %edi
80106f0d:	5d                   	pop    %ebp
80106f0e:	c3                   	ret    
        panic("kfree");
80106f0f:	83 ec 0c             	sub    $0xc,%esp
80106f12:	68 06 79 10 80       	push   $0x80107906
80106f17:	e8 74 94 ff ff       	call   80100390 <panic>
80106f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f20 <seginit>:
{
80106f20:	55                   	push   %ebp
80106f21:	89 e5                	mov    %esp,%ebp
80106f23:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f26:	e8 d5 c8 ff ff       	call   80103800 <cpuid>
80106f2b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106f31:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f36:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f3a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106f41:	ff 00 00 
80106f44:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106f4b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f4e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106f55:	ff 00 00 
80106f58:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106f5f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f62:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106f69:	ff 00 00 
80106f6c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106f73:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f76:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106f7d:	ff 00 00 
80106f80:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106f87:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f8a:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106f8f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f93:	c1 e8 10             	shr    $0x10,%eax
80106f96:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f9a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f9d:	0f 01 10             	lgdtl  (%eax)
}
80106fa0:	c9                   	leave  
80106fa1:	c3                   	ret    
80106fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fb0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fb0:	a1 a4 88 11 80       	mov    0x801188a4,%eax
{
80106fb5:	55                   	push   %ebp
80106fb6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106fb8:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fbd:	0f 22 d8             	mov    %eax,%cr3
}
80106fc0:	5d                   	pop    %ebp
80106fc1:	c3                   	ret    
80106fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fd0 <switchuvm>:
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	57                   	push   %edi
80106fd4:	56                   	push   %esi
80106fd5:	53                   	push   %ebx
80106fd6:	83 ec 1c             	sub    $0x1c,%esp
80106fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106fdc:	85 db                	test   %ebx,%ebx
80106fde:	0f 84 cb 00 00 00    	je     801070af <switchuvm+0xdf>
  if(p->kstack == 0)
80106fe4:	8b 43 08             	mov    0x8(%ebx),%eax
80106fe7:	85 c0                	test   %eax,%eax
80106fe9:	0f 84 da 00 00 00    	je     801070c9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106fef:	8b 43 04             	mov    0x4(%ebx),%eax
80106ff2:	85 c0                	test   %eax,%eax
80106ff4:	0f 84 c2 00 00 00    	je     801070bc <switchuvm+0xec>
  pushcli();
80106ffa:	e8 81 d9 ff ff       	call   80104980 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fff:	e8 7c c7 ff ff       	call   80103780 <mycpu>
80107004:	89 c6                	mov    %eax,%esi
80107006:	e8 75 c7 ff ff       	call   80103780 <mycpu>
8010700b:	89 c7                	mov    %eax,%edi
8010700d:	e8 6e c7 ff ff       	call   80103780 <mycpu>
80107012:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107015:	83 c7 08             	add    $0x8,%edi
80107018:	e8 63 c7 ff ff       	call   80103780 <mycpu>
8010701d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107020:	83 c0 08             	add    $0x8,%eax
80107023:	ba 67 00 00 00       	mov    $0x67,%edx
80107028:	c1 e8 18             	shr    $0x18,%eax
8010702b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107032:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107039:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010703f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107044:	83 c1 08             	add    $0x8,%ecx
80107047:	c1 e9 10             	shr    $0x10,%ecx
8010704a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107050:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107055:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010705c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107061:	e8 1a c7 ff ff       	call   80103780 <mycpu>
80107066:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010706d:	e8 0e c7 ff ff       	call   80103780 <mycpu>
80107072:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107076:	8b 73 08             	mov    0x8(%ebx),%esi
80107079:	e8 02 c7 ff ff       	call   80103780 <mycpu>
8010707e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107084:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107087:	e8 f4 c6 ff ff       	call   80103780 <mycpu>
8010708c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107090:	b8 28 00 00 00       	mov    $0x28,%eax
80107095:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107098:	8b 43 04             	mov    0x4(%ebx),%eax
8010709b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070a0:	0f 22 d8             	mov    %eax,%cr3
}
801070a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070a6:	5b                   	pop    %ebx
801070a7:	5e                   	pop    %esi
801070a8:	5f                   	pop    %edi
801070a9:	5d                   	pop    %ebp
  popcli();
801070aa:	e9 11 d9 ff ff       	jmp    801049c0 <popcli>
    panic("switchuvm: no process");
801070af:	83 ec 0c             	sub    $0xc,%esp
801070b2:	68 da 80 10 80       	push   $0x801080da
801070b7:	e8 d4 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801070bc:	83 ec 0c             	sub    $0xc,%esp
801070bf:	68 05 81 10 80       	push   $0x80108105
801070c4:	e8 c7 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801070c9:	83 ec 0c             	sub    $0xc,%esp
801070cc:	68 f0 80 10 80       	push   $0x801080f0
801070d1:	e8 ba 92 ff ff       	call   80100390 <panic>
801070d6:	8d 76 00             	lea    0x0(%esi),%esi
801070d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070e0 <inituvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	57                   	push   %edi
801070e4:	56                   	push   %esi
801070e5:	53                   	push   %ebx
801070e6:	83 ec 1c             	sub    $0x1c,%esp
801070e9:	8b 75 10             	mov    0x10(%ebp),%esi
801070ec:	8b 45 08             	mov    0x8(%ebp),%eax
801070ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801070f2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801070f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801070fb:	77 49                	ja     80107146 <inituvm+0x66>
  mem = kalloc();
801070fd:	e8 1e b4 ff ff       	call   80102520 <kalloc>
  memset(mem, 0, PGSIZE);
80107102:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107105:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107107:	68 00 10 00 00       	push   $0x1000
8010710c:	6a 00                	push   $0x0
8010710e:	50                   	push   %eax
8010710f:	e8 4c da ff ff       	call   80104b60 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107114:	58                   	pop    %eax
80107115:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010711b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107120:	5a                   	pop    %edx
80107121:	6a 06                	push   $0x6
80107123:	50                   	push   %eax
80107124:	31 d2                	xor    %edx,%edx
80107126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107129:	e8 c2 fc ff ff       	call   80106df0 <mappages>
  memmove(mem, init, sz);
8010712e:	89 75 10             	mov    %esi,0x10(%ebp)
80107131:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107134:	83 c4 10             	add    $0x10,%esp
80107137:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010713a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010713d:	5b                   	pop    %ebx
8010713e:	5e                   	pop    %esi
8010713f:	5f                   	pop    %edi
80107140:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107141:	e9 ca da ff ff       	jmp    80104c10 <memmove>
    panic("inituvm: more than a page");
80107146:	83 ec 0c             	sub    $0xc,%esp
80107149:	68 19 81 10 80       	push   $0x80108119
8010714e:	e8 3d 92 ff ff       	call   80100390 <panic>
80107153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107160 <loaduvm>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	53                   	push   %ebx
80107166:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107169:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107170:	0f 85 91 00 00 00    	jne    80107207 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107176:	8b 75 18             	mov    0x18(%ebp),%esi
80107179:	31 db                	xor    %ebx,%ebx
8010717b:	85 f6                	test   %esi,%esi
8010717d:	75 1a                	jne    80107199 <loaduvm+0x39>
8010717f:	eb 6f                	jmp    801071f0 <loaduvm+0x90>
80107181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107188:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010718e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107194:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107197:	76 57                	jbe    801071f0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107199:	8b 55 0c             	mov    0xc(%ebp),%edx
8010719c:	8b 45 08             	mov    0x8(%ebp),%eax
8010719f:	31 c9                	xor    %ecx,%ecx
801071a1:	01 da                	add    %ebx,%edx
801071a3:	e8 c8 fb ff ff       	call   80106d70 <walkpgdir>
801071a8:	85 c0                	test   %eax,%eax
801071aa:	74 4e                	je     801071fa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801071ac:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071ae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801071b1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801071b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801071bb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801071c1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071c4:	01 d9                	add    %ebx,%ecx
801071c6:	05 00 00 00 80       	add    $0x80000000,%eax
801071cb:	57                   	push   %edi
801071cc:	51                   	push   %ecx
801071cd:	50                   	push   %eax
801071ce:	ff 75 10             	pushl  0x10(%ebp)
801071d1:	e8 ea a7 ff ff       	call   801019c0 <readi>
801071d6:	83 c4 10             	add    $0x10,%esp
801071d9:	39 f8                	cmp    %edi,%eax
801071db:	74 ab                	je     80107188 <loaduvm+0x28>
}
801071dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071e5:	5b                   	pop    %ebx
801071e6:	5e                   	pop    %esi
801071e7:	5f                   	pop    %edi
801071e8:	5d                   	pop    %ebp
801071e9:	c3                   	ret    
801071ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071f3:	31 c0                	xor    %eax,%eax
}
801071f5:	5b                   	pop    %ebx
801071f6:	5e                   	pop    %esi
801071f7:	5f                   	pop    %edi
801071f8:	5d                   	pop    %ebp
801071f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801071fa:	83 ec 0c             	sub    $0xc,%esp
801071fd:	68 33 81 10 80       	push   $0x80108133
80107202:	e8 89 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107207:	83 ec 0c             	sub    $0xc,%esp
8010720a:	68 d4 81 10 80       	push   $0x801081d4
8010720f:	e8 7c 91 ff ff       	call   80100390 <panic>
80107214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010721a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107220 <allocuvm>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107229:	8b 7d 10             	mov    0x10(%ebp),%edi
8010722c:	85 ff                	test   %edi,%edi
8010722e:	0f 88 8e 00 00 00    	js     801072c2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107234:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107237:	0f 82 93 00 00 00    	jb     801072d0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010723d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107240:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107246:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010724c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010724f:	0f 86 7e 00 00 00    	jbe    801072d3 <allocuvm+0xb3>
80107255:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107258:	8b 7d 08             	mov    0x8(%ebp),%edi
8010725b:	eb 42                	jmp    8010729f <allocuvm+0x7f>
8010725d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107260:	83 ec 04             	sub    $0x4,%esp
80107263:	68 00 10 00 00       	push   $0x1000
80107268:	6a 00                	push   $0x0
8010726a:	50                   	push   %eax
8010726b:	e8 f0 d8 ff ff       	call   80104b60 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107270:	58                   	pop    %eax
80107271:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107277:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010727c:	5a                   	pop    %edx
8010727d:	6a 06                	push   $0x6
8010727f:	50                   	push   %eax
80107280:	89 da                	mov    %ebx,%edx
80107282:	89 f8                	mov    %edi,%eax
80107284:	e8 67 fb ff ff       	call   80106df0 <mappages>
80107289:	83 c4 10             	add    $0x10,%esp
8010728c:	85 c0                	test   %eax,%eax
8010728e:	78 50                	js     801072e0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80107290:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107296:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107299:	0f 86 81 00 00 00    	jbe    80107320 <allocuvm+0x100>
    mem = kalloc();
8010729f:	e8 7c b2 ff ff       	call   80102520 <kalloc>
    if(mem == 0){
801072a4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801072a6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801072a8:	75 b6                	jne    80107260 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801072aa:	83 ec 0c             	sub    $0xc,%esp
801072ad:	68 51 81 10 80       	push   $0x80108151
801072b2:	e8 a9 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801072b7:	83 c4 10             	add    $0x10,%esp
801072ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801072bd:	39 45 10             	cmp    %eax,0x10(%ebp)
801072c0:	77 6e                	ja     80107330 <allocuvm+0x110>
}
801072c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801072c5:	31 ff                	xor    %edi,%edi
}
801072c7:	89 f8                	mov    %edi,%eax
801072c9:	5b                   	pop    %ebx
801072ca:	5e                   	pop    %esi
801072cb:	5f                   	pop    %edi
801072cc:	5d                   	pop    %ebp
801072cd:	c3                   	ret    
801072ce:	66 90                	xchg   %ax,%ax
    return oldsz;
801072d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801072d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072d6:	89 f8                	mov    %edi,%eax
801072d8:	5b                   	pop    %ebx
801072d9:	5e                   	pop    %esi
801072da:	5f                   	pop    %edi
801072db:	5d                   	pop    %ebp
801072dc:	c3                   	ret    
801072dd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072e0:	83 ec 0c             	sub    $0xc,%esp
801072e3:	68 69 81 10 80       	push   $0x80108169
801072e8:	e8 73 93 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801072ed:	83 c4 10             	add    $0x10,%esp
801072f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801072f3:	39 45 10             	cmp    %eax,0x10(%ebp)
801072f6:	76 0d                	jbe    80107305 <allocuvm+0xe5>
801072f8:	89 c1                	mov    %eax,%ecx
801072fa:	8b 55 10             	mov    0x10(%ebp),%edx
801072fd:	8b 45 08             	mov    0x8(%ebp),%eax
80107300:	e8 7b fb ff ff       	call   80106e80 <deallocuvm.part.0>
      kfree(mem);
80107305:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107308:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010730a:	56                   	push   %esi
8010730b:	e8 60 b0 ff ff       	call   80102370 <kfree>
      return 0;
80107310:	83 c4 10             	add    $0x10,%esp
}
80107313:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107316:	89 f8                	mov    %edi,%eax
80107318:	5b                   	pop    %ebx
80107319:	5e                   	pop    %esi
8010731a:	5f                   	pop    %edi
8010731b:	5d                   	pop    %ebp
8010731c:	c3                   	ret    
8010731d:	8d 76 00             	lea    0x0(%esi),%esi
80107320:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107323:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107326:	5b                   	pop    %ebx
80107327:	89 f8                	mov    %edi,%eax
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
8010732c:	c3                   	ret    
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
80107330:	89 c1                	mov    %eax,%ecx
80107332:	8b 55 10             	mov    0x10(%ebp),%edx
80107335:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107338:	31 ff                	xor    %edi,%edi
8010733a:	e8 41 fb ff ff       	call   80106e80 <deallocuvm.part.0>
8010733f:	eb 92                	jmp    801072d3 <allocuvm+0xb3>
80107341:	eb 0d                	jmp    80107350 <deallocuvm>
80107343:	90                   	nop
80107344:	90                   	nop
80107345:	90                   	nop
80107346:	90                   	nop
80107347:	90                   	nop
80107348:	90                   	nop
80107349:	90                   	nop
8010734a:	90                   	nop
8010734b:	90                   	nop
8010734c:	90                   	nop
8010734d:	90                   	nop
8010734e:	90                   	nop
8010734f:	90                   	nop

80107350 <deallocuvm>:
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	8b 55 0c             	mov    0xc(%ebp),%edx
80107356:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107359:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010735c:	39 d1                	cmp    %edx,%ecx
8010735e:	73 10                	jae    80107370 <deallocuvm+0x20>
}
80107360:	5d                   	pop    %ebp
80107361:	e9 1a fb ff ff       	jmp    80106e80 <deallocuvm.part.0>
80107366:	8d 76 00             	lea    0x0(%esi),%esi
80107369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107370:	89 d0                	mov    %edx,%eax
80107372:	5d                   	pop    %ebp
80107373:	c3                   	ret    
80107374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010737a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107380 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107380:	55                   	push   %ebp
80107381:	89 e5                	mov    %esp,%ebp
80107383:	57                   	push   %edi
80107384:	56                   	push   %esi
80107385:	53                   	push   %ebx
80107386:	83 ec 0c             	sub    $0xc,%esp
80107389:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010738c:	85 f6                	test   %esi,%esi
8010738e:	74 59                	je     801073e9 <freevm+0x69>
80107390:	31 c9                	xor    %ecx,%ecx
80107392:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107397:	89 f0                	mov    %esi,%eax
80107399:	e8 e2 fa ff ff       	call   80106e80 <deallocuvm.part.0>
8010739e:	89 f3                	mov    %esi,%ebx
801073a0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801073a6:	eb 0f                	jmp    801073b7 <freevm+0x37>
801073a8:	90                   	nop
801073a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073b0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801073b3:	39 fb                	cmp    %edi,%ebx
801073b5:	74 23                	je     801073da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801073b7:	8b 03                	mov    (%ebx),%eax
801073b9:	a8 01                	test   $0x1,%al
801073bb:	74 f3                	je     801073b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801073c2:	83 ec 0c             	sub    $0xc,%esp
801073c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801073c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801073cd:	50                   	push   %eax
801073ce:	e8 9d af ff ff       	call   80102370 <kfree>
801073d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801073d6:	39 fb                	cmp    %edi,%ebx
801073d8:	75 dd                	jne    801073b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801073da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801073dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073e0:	5b                   	pop    %ebx
801073e1:	5e                   	pop    %esi
801073e2:	5f                   	pop    %edi
801073e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073e4:	e9 87 af ff ff       	jmp    80102370 <kfree>
    panic("freevm: no pgdir");
801073e9:	83 ec 0c             	sub    $0xc,%esp
801073ec:	68 85 81 10 80       	push   $0x80108185
801073f1:	e8 9a 8f ff ff       	call   80100390 <panic>
801073f6:	8d 76 00             	lea    0x0(%esi),%esi
801073f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107400 <setupkvm>:
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	56                   	push   %esi
80107404:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107405:	e8 16 b1 ff ff       	call   80102520 <kalloc>
8010740a:	85 c0                	test   %eax,%eax
8010740c:	89 c6                	mov    %eax,%esi
8010740e:	74 42                	je     80107452 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107410:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107413:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107418:	68 00 10 00 00       	push   $0x1000
8010741d:	6a 00                	push   $0x0
8010741f:	50                   	push   %eax
80107420:	e8 3b d7 ff ff       	call   80104b60 <memset>
80107425:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107428:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010742b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010742e:	83 ec 08             	sub    $0x8,%esp
80107431:	8b 13                	mov    (%ebx),%edx
80107433:	ff 73 0c             	pushl  0xc(%ebx)
80107436:	50                   	push   %eax
80107437:	29 c1                	sub    %eax,%ecx
80107439:	89 f0                	mov    %esi,%eax
8010743b:	e8 b0 f9 ff ff       	call   80106df0 <mappages>
80107440:	83 c4 10             	add    $0x10,%esp
80107443:	85 c0                	test   %eax,%eax
80107445:	78 19                	js     80107460 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107447:	83 c3 10             	add    $0x10,%ebx
8010744a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107450:	75 d6                	jne    80107428 <setupkvm+0x28>
}
80107452:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107455:	89 f0                	mov    %esi,%eax
80107457:	5b                   	pop    %ebx
80107458:	5e                   	pop    %esi
80107459:	5d                   	pop    %ebp
8010745a:	c3                   	ret    
8010745b:	90                   	nop
8010745c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107460:	83 ec 0c             	sub    $0xc,%esp
80107463:	56                   	push   %esi
      return 0;
80107464:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107466:	e8 15 ff ff ff       	call   80107380 <freevm>
      return 0;
8010746b:	83 c4 10             	add    $0x10,%esp
}
8010746e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107471:	89 f0                	mov    %esi,%eax
80107473:	5b                   	pop    %ebx
80107474:	5e                   	pop    %esi
80107475:	5d                   	pop    %ebp
80107476:	c3                   	ret    
80107477:	89 f6                	mov    %esi,%esi
80107479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107480 <kvmalloc>:
{
80107480:	55                   	push   %ebp
80107481:	89 e5                	mov    %esp,%ebp
80107483:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107486:	e8 75 ff ff ff       	call   80107400 <setupkvm>
8010748b:	a3 a4 88 11 80       	mov    %eax,0x801188a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107490:	05 00 00 00 80       	add    $0x80000000,%eax
80107495:	0f 22 d8             	mov    %eax,%cr3
}
80107498:	c9                   	leave  
80107499:	c3                   	ret    
8010749a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801074a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801074a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074a1:	31 c9                	xor    %ecx,%ecx
{
801074a3:	89 e5                	mov    %esp,%ebp
801074a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074ab:	8b 45 08             	mov    0x8(%ebp),%eax
801074ae:	e8 bd f8 ff ff       	call   80106d70 <walkpgdir>
  if(pte == 0)
801074b3:	85 c0                	test   %eax,%eax
801074b5:	74 05                	je     801074bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801074b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074ba:	c9                   	leave  
801074bb:	c3                   	ret    
    panic("clearpteu");
801074bc:	83 ec 0c             	sub    $0xc,%esp
801074bf:	68 96 81 10 80       	push   $0x80108196
801074c4:	e8 c7 8e ff ff       	call   80100390 <panic>
801074c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
801074d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801074d9:	e8 22 ff ff ff       	call   80107400 <setupkvm>
801074de:	85 c0                	test   %eax,%eax
801074e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074e3:	0f 84 9f 00 00 00    	je     80107588 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074ec:	85 c9                	test   %ecx,%ecx
801074ee:	0f 84 94 00 00 00    	je     80107588 <copyuvm+0xb8>
801074f4:	31 ff                	xor    %edi,%edi
801074f6:	eb 4a                	jmp    80107542 <copyuvm+0x72>
801074f8:	90                   	nop
801074f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107500:	83 ec 04             	sub    $0x4,%esp
80107503:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107509:	68 00 10 00 00       	push   $0x1000
8010750e:	53                   	push   %ebx
8010750f:	50                   	push   %eax
80107510:	e8 fb d6 ff ff       	call   80104c10 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107515:	58                   	pop    %eax
80107516:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010751c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107521:	5a                   	pop    %edx
80107522:	ff 75 e4             	pushl  -0x1c(%ebp)
80107525:	50                   	push   %eax
80107526:	89 fa                	mov    %edi,%edx
80107528:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010752b:	e8 c0 f8 ff ff       	call   80106df0 <mappages>
80107530:	83 c4 10             	add    $0x10,%esp
80107533:	85 c0                	test   %eax,%eax
80107535:	78 61                	js     80107598 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107537:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010753d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107540:	76 46                	jbe    80107588 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107542:	8b 45 08             	mov    0x8(%ebp),%eax
80107545:	31 c9                	xor    %ecx,%ecx
80107547:	89 fa                	mov    %edi,%edx
80107549:	e8 22 f8 ff ff       	call   80106d70 <walkpgdir>
8010754e:	85 c0                	test   %eax,%eax
80107550:	74 61                	je     801075b3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107552:	8b 00                	mov    (%eax),%eax
80107554:	a8 01                	test   $0x1,%al
80107556:	74 4e                	je     801075a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107558:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010755a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010755f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107565:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107568:	e8 b3 af ff ff       	call   80102520 <kalloc>
8010756d:	85 c0                	test   %eax,%eax
8010756f:	89 c6                	mov    %eax,%esi
80107571:	75 8d                	jne    80107500 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107573:	83 ec 0c             	sub    $0xc,%esp
80107576:	ff 75 e0             	pushl  -0x20(%ebp)
80107579:	e8 02 fe ff ff       	call   80107380 <freevm>
  return 0;
8010757e:	83 c4 10             	add    $0x10,%esp
80107581:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107588:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010758b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758e:	5b                   	pop    %ebx
8010758f:	5e                   	pop    %esi
80107590:	5f                   	pop    %edi
80107591:	5d                   	pop    %ebp
80107592:	c3                   	ret    
80107593:	90                   	nop
80107594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107598:	83 ec 0c             	sub    $0xc,%esp
8010759b:	56                   	push   %esi
8010759c:	e8 cf ad ff ff       	call   80102370 <kfree>
      goto bad;
801075a1:	83 c4 10             	add    $0x10,%esp
801075a4:	eb cd                	jmp    80107573 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	68 ba 81 10 80       	push   $0x801081ba
801075ae:	e8 dd 8d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801075b3:	83 ec 0c             	sub    $0xc,%esp
801075b6:	68 a0 81 10 80       	push   $0x801081a0
801075bb:	e8 d0 8d ff ff       	call   80100390 <panic>

801075c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075c1:	31 c9                	xor    %ecx,%ecx
{
801075c3:	89 e5                	mov    %esp,%ebp
801075c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801075c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075cb:	8b 45 08             	mov    0x8(%ebp),%eax
801075ce:	e8 9d f7 ff ff       	call   80106d70 <walkpgdir>
  if((*pte & PTE_P) == 0)
801075d3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801075d5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801075d6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801075dd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801075e0:	05 00 00 00 80       	add    $0x80000000,%eax
801075e5:	83 fa 05             	cmp    $0x5,%edx
801075e8:	ba 00 00 00 00       	mov    $0x0,%edx
801075ed:	0f 45 c2             	cmovne %edx,%eax
}
801075f0:	c3                   	ret    
801075f1:	eb 0d                	jmp    80107600 <copyout>
801075f3:	90                   	nop
801075f4:	90                   	nop
801075f5:	90                   	nop
801075f6:	90                   	nop
801075f7:	90                   	nop
801075f8:	90                   	nop
801075f9:	90                   	nop
801075fa:	90                   	nop
801075fb:	90                   	nop
801075fc:	90                   	nop
801075fd:	90                   	nop
801075fe:	90                   	nop
801075ff:	90                   	nop

80107600 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	57                   	push   %edi
80107604:	56                   	push   %esi
80107605:	53                   	push   %ebx
80107606:	83 ec 1c             	sub    $0x1c,%esp
80107609:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010760c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010760f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107612:	85 db                	test   %ebx,%ebx
80107614:	75 40                	jne    80107656 <copyout+0x56>
80107616:	eb 70                	jmp    80107688 <copyout+0x88>
80107618:	90                   	nop
80107619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107620:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107623:	89 f1                	mov    %esi,%ecx
80107625:	29 d1                	sub    %edx,%ecx
80107627:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010762d:	39 d9                	cmp    %ebx,%ecx
8010762f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107632:	29 f2                	sub    %esi,%edx
80107634:	83 ec 04             	sub    $0x4,%esp
80107637:	01 d0                	add    %edx,%eax
80107639:	51                   	push   %ecx
8010763a:	57                   	push   %edi
8010763b:	50                   	push   %eax
8010763c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010763f:	e8 cc d5 ff ff       	call   80104c10 <memmove>
    len -= n;
    buf += n;
80107644:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107647:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010764a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107650:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107652:	29 cb                	sub    %ecx,%ebx
80107654:	74 32                	je     80107688 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107656:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107658:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010765b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010765e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107664:	56                   	push   %esi
80107665:	ff 75 08             	pushl  0x8(%ebp)
80107668:	e8 53 ff ff ff       	call   801075c0 <uva2ka>
    if(pa0 == 0)
8010766d:	83 c4 10             	add    $0x10,%esp
80107670:	85 c0                	test   %eax,%eax
80107672:	75 ac                	jne    80107620 <copyout+0x20>
  }
  return 0;
}
80107674:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107677:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010767c:	5b                   	pop    %ebx
8010767d:	5e                   	pop    %esi
8010767e:	5f                   	pop    %edi
8010767f:	5d                   	pop    %ebp
80107680:	c3                   	ret    
80107681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107688:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010768b:	31 c0                	xor    %eax,%eax
}
8010768d:	5b                   	pop    %ebx
8010768e:	5e                   	pop    %esi
8010768f:	5f                   	pop    %edi
80107690:	5d                   	pop    %ebp
80107691:	c3                   	ret    
