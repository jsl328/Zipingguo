//
//  PRAnimatedGifEncoder.m
//  DandelionDemo
//
//  Created by Bob Li on 13-11-22.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCAnimatedGifEncoder.h"
#import "DCNeuQuant.h"
#import "LZWEncoder.h"
#import "DCImageHelper.h"

@implementation DCAnimatedGifEncoder

-(id) init {
    self = [super init];
    if (self) {
        transparent = [UIColor clearColor]; // transparent color if given
        repeat = -1; // no repeat
        delay = 0; // frame delay (hundredths)
        started = NO; // ready to output frames
        
        usedEntry = [[DCIntArray alloc] initWithSize:256]; // active palette entries
        for (int i = 0; i <= 255; i++) {
            usedEntry.a[i] = NO;
        }
        
        palSize = 7; // color table size (bits-1)
        dispose = -1; // disposal code (-1 = use default)
        closeStream = NO; // close stream when finished
        firstFrame = YES;
        sizeSet = NO; // if false, get size from first frame
        sample = 10; // default sample interval for quantizer
    }
    return self;
}

    /**
     * Sets the delay time between each frame, or changes it for subsequent frames
     * (applies to last frame added).
     *
     * @param ms
     *          int delay time in milliseconds
     */
-(void) setDelay:(int) ms {
    delay = round(ms / 10.0f);
}
    
    /**
     * Sets the GIF frame disposal code for the last added frame and any
     * subsequent frames. Default is 0 if no transparent color has been set,
     * otherwise 2.
     *
     * @param code
     *          int disposal code.
     */
-(void) setDispose:(int) code {
    if (code >= 0) {
        dispose = code;
    }
}
    
    /**
     * Sets the number of times the set of GIF frames should be played. Default is
     * 1; 0 means play indefinitely. Must be invoked before the first image is
     * added.
     *
     * @param iter
     *          int number of iterations.
     * @return
     */
-(void) setRepeat:(int) iter {
    if (iter >= 0) {
        repeat = iter;
    }
}
    
    /**
     * Sets the transparent color for the last added frame and any subsequent
     * frames. Since all colors are subject to modification in the quantization
     * process, the color in the final palette for each frame closest to the given
     * color becomes the transparent color for that frame. May be set to null to
     * indicate no transparent color.
     *
     * @param c
     *          Color to be treated as transparent on display.
     */
-(void) setTransparent:(UIColor*) c {
    transparent = c;
}
    
    /**
     * Adds next GIF frame. The frame is not written immediately, but is actually
     * deferred until the next frame is received so that timing data can be
     * inserted. Invoking <code>finish()</code> flushes all frames. If
     * <code>setSize</code> was not invoked, the size of the first image is used
     * for all subsequent frames.
     *
     * @param im
     *          BufferedImage containing frame to write.
     * @return true if successful.
     */
-(BOOL) addFrame:(UIImage*) im {
    
    if (!im || !started) {
        return NO;
    }

    if (!sizeSet) {
        // use first frame's size
        [self setSizeWithWidth:im.size.width height:im.size.height];
    }
    image = im;
    [self getImagePixels]; // convert to correct format if necessary
    [self analyzePixels]; // build color table & map pixels
    if (firstFrame) {
        [self writeLSD]; // logical screen descriptior
        [self writePalette]; // global color table
        if (repeat >= 0) {
            // use NS app extension to indicate reps
            [self writeNetscapeExt];
        }
    }
    [self writeGraphicCtrlExt]; // write graphic control extension
    [self writeImageDesc]; // image descriptor
    if (!firstFrame) {
        [self writePalette]; // local color table
    }
    [self writePixels]; // encode and write pixel data
    firstFrame = false;

    
    return YES;
}

    /**
     * Flushes any pending data and closes output file. If writing to an
     * OutputStream, the stream is not closed.
     */
-(BOOL) finish {
    
    if (!started)
        return false;

    started = NO;
        
    [stream writeByte:0x3b]; // gif trailer
    [stream flush];
    if (closeStream) {
        [stream close];
    }
  
    
    // reset for subsequent use
    transIndex = 0;
    stream = nil;
    image = nil;
    pixels = nil;
    indexedPixels = nil;
    colorTab = nil;
    closeStream = false;
    firstFrame = true;
    [pixels free];
    [indexedPixels free];
    [colorTab free];
    [usedEntry free];
    
    return YES;
}
    
    /**
     * Sets frame rate in frames per second. Equivalent to
     * <code>setDelay(1000/fps)</code>.
     *
     * @param fps
     *          float frame rate (frames per second)
     */
-(void) setFrameRate:(float) fps {
    if (fps != 0.0) {
        delay = round(100.0 / fps);
    }
}
    
    /**
     * Sets quality of color quantization (conversion of images to the maximum 256
     * colors allowed by the GIF specification). Lower values (minimum = 1)
     * produce better colors, but slow processing significantly. 10 is the
     * default, and produces good color mapping at reasonable speeds. Values
     * greater than 20 do not yield significant improvements in speed.
     *
     * @param quality
     *          int greater than 0.
     * @return
     */
-(void) setQuality:(int) quality {
    if (quality < 1)
        quality = 1;
    sample = quality;
}
    
    /**
     * Sets the GIF frame size. The default size is the size of the first frame
     * added if this method is not invoked.
     *
     * @param w
     *          int frame width.
     * @param h
     *          int frame width.
     */
-(void) setSizeWithWidth:(int) w height:(int) h {
    if (started && !firstFrame)
        return;
    width = w;
    height = h;
    if (width < 1)
        width = 320;
    if (height < 1)
        height = 240;
    sizeSet = YES;
}
    
    /**
     * Initiates GIF file creation on the given stream. The stream is not closed
     * automatically.
     *
     * @param os
     *          OutputStream on which GIF images are written.
     * @return false if initial write failed.
     */
-(BOOL) startWithStreamWriter:(DCStreamWriter*) os {
    if (!os)
        return NO;
    closeStream = NO;
    stream = os;
    [stream writeString:@"GIF89a"]; // header
    started = YES;
    return YES;
}
    
    /**
     * Initiates writing of a GIF file with the specified name.
     *
     * @param file
     *          String containing output file name.
     * @return false if open or initial write failed.
     */
-(BOOL) startWithFile:(NSString*) file {
    
    stream = [[DCStreamWriter alloc] initWithOutputStream:[NSOutputStream outputStreamToFileAtPath:file append:NO]];

    [self startWithStreamWriter:stream];
    closeStream = YES;
    
    started = YES;
    return YES;
}
    
    /**
     * Analyzes image colors and creates color map.
     */
    -(void) analyzePixels {
        int len = pixels.size;
        int nPix = len / 3;
        //indexedPixels = new byte[nPix];
        indexedPixels = [[DCByteArray alloc] initWithSize:nPix];
        
        DCNeuQuant* nq = [[DCNeuQuant alloc] initWithPic:pixels len:len sample:sample];
        
        // initialize quantizer
        colorTab = [nq process]; // create reduced palette
        // convert map from BGR to RGB
        for (int i = 0; i < colorTab.size; i += 3) {
            unsigned char temp = colorTab.a[i];
            colorTab.a[i] = colorTab.a[i + 2];
            colorTab.a[i + 2] = temp;
            usedEntry.a[i / 3] = NO;
        }
        // map image pixels to new palette
        int k = 0;
        for (int i = 0; i < nPix; i++) {
            int index = [nq mapWithB:pixels.a[k++] & 0xff g:pixels.a[k++] & 0xff r:pixels.a[k++] & 0xff];
            usedEntry.a[index] = YES;
            indexedPixels.a[i] = (unsigned char)index;
        }
        pixels = nil;
        colorDepth = 8;
        palSize = 7;
        // get closest match to transparent color if specified
        if (transparent) {
            transIndex = [self findClosest:transparent];
        }
        
        [nq free];
    }
    
    /**
     * Returns index of palette color closest to c
     *
     */
-(int) findClosest:(UIColor*) c {
        if (!colorTab)
            return -1;
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [c getRed:&red green:&green blue:&blue alpha:&alpha];
    
        int r = red * 255;
        int g = green * 255;
        int b = blue * 255;
        int minpos = 0;
        int dmin = 256 * 256 * 256;
        int len = colorTab.size;
        for (int i = 0; i < len;) {
            int dr = r - (colorTab.a[i++] & 0xff);
            int dg = g - (colorTab.a[i++] & 0xff);
            int db = b - (colorTab.a[i] & 0xff);
            int d = dr * dr + dg * dg + db * db;
            int index = i / 3;
            if (usedEntry.a[index] && (d < dmin)) {
                dmin = d;
                minpos = index;
            }
            i++;
        }
        return minpos;
    }
    
    /**
     * Extracts image pixels into byte array "pixels"
     */
    -(void) getImagePixels {
        
        //TYPE_3BYTE_BGR
        

        DCByteArray* pixelsRGBA = [DCImageHelper pixelsRGBADataFromImage:image size:CGSizeMake(width, height)];
        pixels = [[DCByteArray alloc] initWithSize:width * height * 3];
        
        
        int pixelsIndex = 0;
        
        for (int i = 0; i <= pixelsRGBA.size - 1; i += 4) {
            pixels.a[pixelsIndex] = pixelsRGBA.a[i + 2];
            pixels.a[pixelsIndex + 1] = pixelsRGBA.a[i + 1];
            pixels.a[pixelsIndex + 2] = pixelsRGBA.a[i + 0];
            pixelsIndex += 3;
        }
        
        [pixelsRGBA free];
    }

    
    /**
     * Writes Graphic Control Extension
     */
     -(void) writeGraphicCtrlExt {
        [stream writeByte:0x21]; // extension introducer
        [stream writeByte:0xf9]; // GCE label
        [stream writeByte:4]; // data block size
        int transp, disp;
        if (!transparent) {
            transp = 0;
            disp = 0; // dispose = no action
        } else {
            transp = 1;
            disp = 2; // force clear if using transparent color
        }
        if (dispose >= 0) {
            disp = dispose & 7; // user override
        }
        disp <<= 2;
        
        // packed fields
         [stream writeByte:0 | // 1:3 reserved
          disp | // 4:6 disposal
          0 | // 7 user input - 0 = none
          transp]; // 8 transparency flag
        
        [stream writeShort:delay]; // delay x 1/100 sec
        [stream writeByte:transIndex]; // transparent color index
        [stream writeByte:0]; // block terminator
    }
    
    /**
     * Writes Image Descriptor
     */
    -(void) writeImageDesc {
        [stream writeByte:0x2c]; // image separator
        [stream writeShort:0]; // image position x,y = 0,0
        [stream writeShort:0];
        [stream writeShort:width]; // image size
        [stream writeShort:height];
        // packed fields
        if (firstFrame) {
            // no LCT - GCT is used for first (or only) frame
            [stream writeByte:0];
        } else {
            // specify normal LCT
            [stream writeByte:0x80 | // 1 local color table 1=yes
                      0 | // 2 interlace - 0=no
                      0 | // 3 sorted - 0=no
                      0 | // 4-5 reserved
                      palSize]; // 6-8 size of color table
        }
    }
    
    /**
     * Writes Logical Screen Descriptor
     */
    -(void) writeLSD {
        // logical screen size
        [stream writeShort:width];
        [stream writeShort:height];
        // packed fields
        [stream writeByte:(0x80 | // 1 : global color table flag = 1 (gct used)
                   0x70 | // 2-4 : color resolution = 7
                   0x00 | // 5 : gct sort flag = 0
                   palSize)]; // 6-8 : gct size
        
        [stream writeByte:0]; // background color index
        [stream writeByte:0]; // pixel aspect ratio - assume 1:1
    }
    
    /**
     * Writes Netscape application extension to define repeat count.
     */
    -(void) writeNetscapeExt {
        [stream writeByte:0x21]; // extension introducer
        [stream writeByte:0xff]; // app extension label
        [stream writeByte:11]; // block size
        [stream writeString:@"NETSCAPE2.0"]; // app id + auth code
        [stream writeByte:3]; // sub-block size
        [stream writeByte:1]; // loop sub-block id
        [stream writeShort:repeat]; // loop count (extra iterations, 0=repeat forever)
        [stream writeByte:0]; // block terminator
    }
    
    /**
     * Writes color table
     */
     -(void) writePalette {
        [stream writeByteArray:colorTab.a length:colorTab.size];
        int n = (3 * 256) - colorTab.size;
        for (int i = 0; i < n; i++) {
            [stream writeByte:0];
        }
    }
    
    /**
     * Encodes and writes pixel data
     */
    -(void) writePixels {
        LZWEncoder* encoder = [[LZWEncoder alloc] initWithWidth:width height:height pixels:indexedPixels color_depth:colorDepth];
        [encoder encode:stream];
    }

@end
