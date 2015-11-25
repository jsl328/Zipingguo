//
//  PRGifDecoder.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-11.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCGifDecoder.h"
#import "DCAnimationImageFrame.h"
#import "DCImageHelper.h"
#import "DCImageIO.h"

@implementation PRGifDecoder
@synthesize decodeFirstFrame;

-(id) init {
    self = [super init];
    if (self) {
        loopCount = 1; // iterations; 0 = repeat forever
        block = [[DCByteArray alloc] initWithSize:256]; // current data block
        blockSize = 0; // block size
        // last graphic control extension info
        dispose = 0;
        // 0=no action; 1=leave in place; 2=restore to bg; 3=restore to prev
        lastDispose = 0;
        lastFrameIndex = -1;
        transparency = NO; // use transparent color
        delay = 0; // delay in milliseconds
        framePixelDataList = [[NSMutableArray alloc] init];
    }
    return self;
}
    
    /**
     * Gets display duration for specified frame.
     *
     * @param n
     *          int index of frame
     * @return delay in milliseconds
     */
-(int) getDelay:(int) n {
        //
        delay = -1;
        if ((n >= 0) && (n < frameCount)) {
            delay = ((DCAnimationImageFrame*) [frames objectAtIndex:n]).duration;
        }
        return delay;
    }
    
    /**
     * Gets the number of frames read from file.
     *
     * @return frame count
     */
    -(int) getFrameCount {
        return frameCount;
    }
    
    /**
     * Gets the first (or only) image read.
     *
     * @return BufferedImage containing first frame, or null if none.
     */
    -(UIImage*) getImage {
        return [self getFrame:0];
    }
    
    /**
     * Gets the "Netscape" iteration count, if any. A count of 0 means repeat
     * indefinitiely.
     *
     * @return iteration count if one was specified, else 1.
     */
    -(int) getLoopCount {
        return loopCount;
    }
    
    /**
     * Creates new frame image from current data (and previous frames as specified
     * by their disposition codes).
     */
    -(void) setPixels {
        // expose destination image's pixels as int array
        DCByteArray* dest = currentFrameData;

        // fill in starting image contents based on last image's dispose code
        if (lastDispose > 0) {
            if (lastDispose == 3) {
                // use image before last
                int n = frameCount - 2;
                if (n > 0) {
                    lastFrameIndex = n - 1;
                } else {
                    lastFrameIndex = -1;
                }
            }
            
            if (lastFrameIndex >= 0) {
                [currentFrameData copyFromByteArray:(DCByteArray*)[framePixelDataList objectAtIndex:lastFrameIndex]];
                // copy pixels
                
                if (lastDispose == 2) {
                    // fill last image rect area with background color
                    UIColor* c;
                    if (transparency) {
                        c = [UIColor clearColor]; // assume background is transparent
                    } else {
                        c = [self colorFromARGB:lastBgColor]; // use given background color
                    }
                    CGContextSetFillColorWithColor(currentContext, c.CGColor);
                    CGContextSetBlendMode(currentContext, kCGBlendModeCopy); // replace area
                    CGContextFillRect(currentContext, lastRect);
                }
            }
        }
        
        // copy each source line to the appropriate place in the destination
        int pass = 1;
        int inc = 8;
        int iline = 0;
        for (int i = 0; i < ih; i++) {
            int line = i;
            if (interlace) {
                if (iline >= ih) {
                    pass++;
                    switch (pass) {
                        case 2:
                            iline = 4;
                            break;
                        case 3:
                            iline = 2;
                            inc = 4;
                            break;
                        case 4:
                            iline = 1;
                            inc = 2;
                    }
                }
                line = iline;
                iline += inc;
            }
            line += iy;
            if (line < height) {
                int k = line * width;
                int dx = k + ix; // start of line in dest
                int dlim = dx + iw; // end of dest line
                if ((k + width) < dlim) {
                    dlim = k + width; // past dest edge
                }
                int sx = i * iw; // start of line in source
                while (dx < dlim) {
                    // map color and insert in destination
                    int index = ((int) pixels.a[sx++]) & 0xff;
                    int c = act.a[index];
                    if (c != 0) {
                        dest.a[dx * 4] = (c >> 16) & 0xff;
                        dest.a[dx * 4 + 1] = (c >> 8) & 0xff;
                        dest.a[dx * 4 + 2] = c & 0xff;
                        dest.a[dx * 4 + 3] = c >> 24;
                    }
                    dx++;
                }
            }
        }
    }

-(UIColor*) colorFromARGB:(int) argb {
    float a = argb >> 24;
    float r = (argb >> 16) & 0xff;
    float g = (argb >> 8) & 0xff;
    float b = argb & 0xff;
    return [UIColor colorWithRed:r / 255 green:g / 255 blue:b / 255 alpha:a / 255];
}
    
    /**
     * Gets the image contents of frame n.
     *
     * @return BufferedImage representation of frame, or null if n is invalid.
     */
-(UIImage*) getFrame:(int) n {
        UIImage* im = nil;
        if ((n >= 0) && (n < frameCount)) {
            im = ((DCAnimationImageFrame*) [frames objectAtIndex:n]).image;
        }
        return im;
    }
    
    /**
     * Gets image size.
     *
     * @return GIF image dimensions
     */
    -(CGSize) getFrameSize {
        return CGSizeMake(width, height);
    }
    
    /**
     * Reads GIF image from stream
     *
     * @param InputStream
     *          containing GIF file.
     * @return read status code (0 = no errors)
     */
-(int) readFromStream:(DCStreamReader*) is {
    
    @autoreleasepool {
        
        [self initDecoder];
        if (is) {
            inStream = is;
            [self readHeader];
            if (![self err]) {
                [self readContents];
                if (frameCount < 0) {
                    status = STATUS_FORMAT_ERROR;
                }
            }
        } else {
            status = STATUS_OPEN_ERROR;
        }
    }
    

    
    for (DCByteArray* array in framePixelDataList) {
        [array free];
    }
    
    [gct free];
    [lct free];
    [act free];
    [block free];
    [prefix free];
    [suffix free];
    [pixelStack free];
    [pixels free];

    [is close];
    return status;
}
    
    /**
     * Reads GIF file from specified file/URL source (URL assumed if name contains
     * ":/" or "file:")
     *
     * @param name
     *          String containing source
     * @return read status code (0 = no errors)
     */
-(int) readFromFile:(NSString*) name {
    
    status = STATUS_OK;

    inStream = [[DCStreamReader alloc] initWithInputStream:[NSInputStream inputStreamWithFileAtPath:name]];
    status = [self readFromStream:inStream];

    return status;
}
    
    /**
     * Decodes LZW image data into pixel array. Adapted from John Cristy's
     * ImageMagick.
     */
     -(void) decodeImageData {
        int NullCode = -1;
        int npix = iw * ih;
        int available, clear, code_mask, code_size, end_of_information, in_code, old_code, bits, code, count, i, datum, data_size, first, top, bi, pi;
        
        if (!pixels || (pixels.size < npix)) {
            pixels = [[DCByteArray alloc] initWithSize:npix]; // allocate new pixel array
        }
        if (!prefix)
            prefix = [[DCIntArray alloc] initWithSize:MaxStackSize];
        if (!suffix)
            suffix = [[DCByteArray alloc] initWithSize:MaxStackSize];
        if (!pixelStack)
            pixelStack = [[DCByteArray alloc] initWithSize:MaxStackSize + 1];
        
        // Initialize GIF data stream decoder.
        
        data_size = [self read];
        clear = 1 << data_size;
        end_of_information = clear + 1;
        available = clear + 2;
        old_code = NullCode;
        code_size = data_size + 1;
        code_mask = (1 << code_size) - 1;
        for (code = 0; code < clear; code++) {
            prefix.a[code] = 0;
            suffix.a[code] = (unsigned char)code;
        }
        
        // Decode GIF pixel stream.
        
        datum = bits = count = first = top = pi = bi = 0;
        
        for (i = 0; i < npix;) {
            if (top == 0) {
                if (bits < code_size) {
                    // Load bytes until there are enough bits for a code.
                    if (count == 0) {
                        // Read a new data block.
                        count = [self readBlock];
                        if (count <= 0)
                            break;
                        bi = 0;
                    }
                    datum += (((int) block.a[bi]) & 0xff) << bits;
                    bits += 8;
                    bi++;
                    count--;
                    continue;
                }
                
                // Get the next code.
                
                code = datum & code_mask;
                datum >>= code_size;
                bits -= code_size;
                
                // Interpret the code
                
                if ((code > available) || (code == end_of_information))
                    break;
                if (code == clear) {
                    // Reset decoder.
                    code_size = data_size + 1;
                    code_mask = (1 << code_size) - 1;
                    available = clear + 2;
                    old_code = NullCode;
                    continue;
                }
                if (old_code == NullCode) {
                    pixelStack.a[top++] = suffix.a[code];
                    old_code = code;
                    first = code;
                    continue;
                }
                in_code = code;
                if (code == available) {
                    pixelStack.a[top++] = (unsigned char) first;
                    code = old_code;
                }
                while (code > clear) {
                    pixelStack.a[top++] = suffix.a[code];
                    code = prefix.a[code];
                }
                first = ((int) suffix.a[code]) & 0xff;
                
                // Add a new string to the string table,
                
                if (available >= MaxStackSize)
                    break;
                pixelStack.a[top++] = (unsigned char) first;
                prefix.a[available] = (short) old_code;
                suffix.a[available] = (unsigned char) first;
                available++;
                if (((available & code_mask) == 0) && (available < MaxStackSize)) {
                    code_size++;
                    code_mask += available;
                }
                old_code = in_code;
            }
            
            // Pop a pixel off the pixel stack.
            
            top--;
            pixels.a[pi++] = pixelStack.a[top];
            i++;
        }
        
        for (i = pi; i < npix; i++) {
            pixels.a[i] = 0; // clear missing pixels
        }
        
    }
    
    /**
     * Returns true if an error was encountered during reading/decoding
     */
    -(BOOL) err {
        return status != STATUS_OK;
    }

    /**
     * Initializes or re-initializes reader
     */
    -(void) initDecoder {
        status = STATUS_OK;
        frameCount = 0;
        frames = [[NSMutableArray alloc] init];
        gct = nil;
        lct = nil;
    }
    
    /**
     * Reads a single byte from the input stream.
     */
    -(int) read {
        int curByte = 0;

        curByte = [inStream readByte];

        return curByte;
    }
    
    /**
     * Reads next variable length block from input.
     *
     * @return number of bytes stored in "buffer"
     */
    -(int) readBlock {
        blockSize = [self read];
        int n = 0;
        if (blockSize > 0) {

            int count = 0;
            while (n < blockSize) {
                count = [inStream readBytes:block.a fromIndex:n maxLength:blockSize - n];
                if (count == -1)
                    break;
                n += count;
            }
            
            
            if (n < blockSize) {
                status = STATUS_FORMAT_ERROR;
            }
        }
        return n;
    }
    
    /**
     * Reads color table as 256 RGB integer values
     *
     * @param ncolors
     *          int number of colors to read
     * @return int array containing 256 colors (packed ARGB with full alpha)
     */
-(DCIntArray*) readColorTable:(int) ncolors {
        int nbytes = 3 * ncolors;
        DCIntArray* tab = nil;
        DCByteArray* c = [[DCByteArray alloc] initWithSize:nbytes];
        int n = [inStream readBytes:c.a fromIndex:0 maxLength:nbytes];
  
        if (n < nbytes) {
            status = STATUS_FORMAT_ERROR;
        } else {
            tab = [[DCIntArray alloc] initWithSize:256]; // max size to avoid bounds checks
            int i = 0;
            int j = 0;
            while (i < ncolors) {
                int r = ((int) c.a[j++]) & 0xff;
                int g = ((int) c.a[j++]) & 0xff;
                int b = ((int) c.a[j++]) & 0xff;
                tab.a[i++] = 0xff000000 | (r << 16) | (g << 8) | b;
            }
        }
        return tab;
    }
    
    /**
     * Main file parser. Reads GIF content blocks.
     */
    -(void) readContents {
        // read GIF file content blocks
        BOOL done = NO;
        while (!(done || [self err])) {
            int code = [self read];
            switch (code) {
                    
                case 0x2C: // image separator
                    [self readImage];
                    
                    if (decodeFirstFrame) {
                        done = YES;
                    }
                    
                    break;
                    
                case 0x21: // extension
                    code = [self read];
                    switch (code) {
                        case 0xf9: // graphics control extension
                            [self readGraphicControlExt];
                            break;
                            
                        case 0xff: // application extension
                        {
                            [self readBlock];
                            NSMutableString* app = [[NSMutableString alloc] init];
                            for (int i = 0; i < 11; i++) {
                                [app appendFormat:@"%c", (char) block.a[i]];
                            }
                            if ([app isEqualToString:@"NETSCAPE2.0"]) {
                                [self readNetscapeExt];
                            } else
                                [self skip]; // don't care
                        }
                            break;
                            
                        default: // uninteresting extension
                            [self skip];
                    }
                    break;
                    
                case 0x3b: // terminator
                    done = true;
                    break;
                    
                case 0x00: // bad byte, but keep going and see what happens
                    break;
                    
                default:
                    status = STATUS_FORMAT_ERROR;
            }
        }
    }

    /**
     * Reads Graphics Control Extension values
     */
    -(void) readGraphicControlExt {
        [self read]; // block size
        int packed = [self read]; // packed fields
        dispose = (packed & 0x1c) >> 2; // disposal method
        if (dispose == 0) {
            dispose = 1; // elect to keep old image if discretionary
        }
        transparency = (packed & 1) != 0;
        delay = [inStream readShort] * 10; // delay in milliseconds
        transIndex = [self read]; // transparent color index
        [self read]; // block terminator
    }
    
    /**
     * Reads GIF file header information.
     */
    -(void) readHeader {
        NSMutableString* ids = [[NSMutableString alloc] init];
        for (int i = 0; i < 6; i++) {
            [ids appendFormat:@"%c", (char) [self read]];
        }
        if (![[ids substringToIndex:3] isEqualToString:@"GIF"]) {
            status = STATUS_FORMAT_ERROR;
            return;
        }
        
        [self readLSD];
        if (gctFlag && ![self err]) {
            gct = [self readColorTable:gctSize];
            bgColor = gct.a[bgIndex];
        }
    }
    
    /**
     * Reads next frame image
     */
    -(void) readImage {
        ix = [inStream readShort]; // (sub)image position & size
        iy = [inStream readShort];
        iw = [inStream readShort];
        ih = [inStream readShort];
        
        int packed = [self read];
        lctFlag = (packed & 0x80) != 0; // 1 - local color table flag
        interlace = (packed & 0x40) != 0; // 2 - interlace flag
        // 3 - sort flag
        // 4-5 - reserved
        lctSize = 2 << (packed & 7); // 6-8 - local color table size
        
        if (lctFlag) {
            lct = [self readColorTable:lctSize]; // read table
            act = lct; // make local table active
        } else {
            act = gct; // make global table active
            if (bgIndex == transIndex)
                bgColor = 0;
        }
        int save = 0;
        if (transparency) {
            save = act.a[transIndex];
            act.a[transIndex] = 0; // set transparent color if specified
        }
        
        if (!act) {
            status = STATUS_FORMAT_ERROR; // no color table defined
        }
        
        if ([self err])
            return;
        
        [self decodeImageData]; // decode pixel data
        [self skip];
        
        if ([self err])
            return;
        
        frameCount++;
        
        
        // create new image to receive frame data
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        currentFrameData = [[DCByteArray alloc] initWithSize:height * width * 4];
        NSUInteger bytesPerPixel = 4;
        NSUInteger bytesPerRow = bytesPerPixel * width;
        NSUInteger bitsPerComponent = 8;
        currentContext = CGBitmapContextCreate(currentFrameData.a, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);

        
        [self setPixels]; // transfer pixel data to image


        
        CGImageRef toCGImage = CGBitmapContextCreateImage(currentContext);
        UIImage* image = [[UIImage alloc] initWithCGImage:toCGImage];

        
        CGImageRelease(toCGImage);
        CGContextRelease(currentContext);
        
        
        [frames addObject:[[DCAnimationImageFrame alloc] initWithImage:image duration:delay]]; // add image to frame list

        
        if (transparency) {
            act.a[transIndex] = save;
        }
        [self resetFrame];
        
    }
    
    /**
     * Reads Logical Screen Descriptor
     */
    -(void) readLSD {
        
        // logical screen size
        width = [inStream readShort];
        height = [inStream readShort];
        
        // packed fields
        int packed = [self read];
        gctFlag = (packed & 0x80) != 0; // 1 : global color table flag
        // 2-4 : color resolution
        // 5 : gct sort flag
        gctSize = 2 << (packed & 7); // 6-8 : gct size
        
        bgIndex = [self read]; // background color index
        pixelAspect = [self read]; // pixel aspect ratio
    }
    
    /**
     * Reads Netscape extenstion to obtain iteration count
     */
    -(void) readNetscapeExt {
        do {
            [self readBlock];
            if (block.a[0] == 1) {
                // loop count sub-block
                int b1 = ((int) block.a[1]) & 0xff;
                int b2 = ((int) block.a[2]) & 0xff;
                loopCount = (b2 << 8) | b1;
            }
        } while ((blockSize > 0) && ![self err]);
    }
    
    /**
     * Resets frame state for reading next image.
     */
    -(void) resetFrame {
        lastDispose = dispose;
        lastRect = CGRectMake(ix, iy, iw, ih);
        lastFrameIndex = frameCount - 1;
        [framePixelDataList addObject:currentFrameData];
        lastBgColor = bgColor;
        dispose = 0;
        transparency = NO;
        delay = 0;
        lct = nil;
    }
    
    /**
     * Skips variable length blocks up to and including next zero length block.
     */
    -(void) skip {
        do {
            [self readBlock];
        } while ((blockSize > 0) && ![self err]);
    }

@end
