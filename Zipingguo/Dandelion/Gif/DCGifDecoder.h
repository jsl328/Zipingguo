//
//  PRGifDecoder.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-11.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//


/**
 * Class GifDecoder - Decodes a GIF file into one or more frames. <br>
 *
 * <pre>
 *  Example:
 *     GifDecoder d = new GifDecoder();
 *     d.read(&quot;sample.gif&quot;);
 *     int n = d.getFrameCount();
 *     for (int i = 0; i &lt; n; i++) {
 *        BufferedImage frame = d.getFrame(i);  // frame i
 *        int t = d.getDelay(i);  // display duration of frame in milliseconds
 *        // do something with frame
 *     }
 * </pre>
 *
 * No copyright asserted on the source code of this class. May be used for any
 * purpose, however, refer to the Unisys LZW patent for any additional
 * restrictions. Please forward any corrections to kweiner@fmsware.com.
 *
 * @author Kevin Weiner, FM Software; LZW decoder adapted from John Cristy's
 *         ImageMagick.
 * @version 1.03 November 2003
 *
 */

#import <Foundation/Foundation.h>
#import "DCByteArray.h"
#import "DCIntArray.h"
#import "DCStreamReader.h"

/**
 * File read status: No errors.
 */
#define STATUS_OK 0
/**
 * File read status: Error decoding file (may be partially decoded)
 */
#define STATUS_FORMAT_ERROR 1
/**
 * File read status: Unable to open source.
 */
#define STATUS_OPEN_ERROR 2

#define MaxStackSize 4096

@interface PRGifDecoder : NSObject {
    
    DCStreamReader* inStream;
    
    int status;
    
    int width; // full image width
    
    int height; // full image height
    
    BOOL gctFlag; // global color table used
    
    int gctSize; // size of global color table
    
    int loopCount; // iterations; 0 = repeat forever
    
    DCIntArray* gct; // global color table
    
    DCIntArray* lct; // local color table
    
    DCIntArray* act; // active color table
    
    int bgIndex; // background color index
    
    int bgColor; // background color
    
    int lastBgColor; // previous bg color
    
    int pixelAspect; // pixel aspect ratio
    
    BOOL lctFlag; // local color table flag
    
    BOOL interlace; // interlace flag
    
    int lctSize; // local color table size
    
    int ix, iy, iw, ih; // current image rectangle
    
    CGRect lastRect; // last image rect
    
    DCByteArray* block; // current data block
    
    DCByteArray* currentFrameData;
    
    NSMutableArray* framePixelDataList;
    
    int lastFrameIndex;
    
    CGContextRef currentContext;
    
    int blockSize; // block size
    
    // last graphic control extension info
    int dispose;
    
    // 0=no action; 1=leave in place; 2=restore to bg; 3=restore to prev
    int lastDispose;
    
    BOOL transparency; // use transparent color
    
    int delay; // delay in milliseconds
    
    int transIndex; // transparent color index
    
    // max decoder pixel stack size
    
    // LZW decoder working arrays
    DCIntArray* prefix;
    
    DCByteArray* suffix;
    
    DCByteArray* pixelStack;
    
    DCByteArray* pixels;
    
    NSMutableArray* frames; // frames read from current file
    
    int frameCount;
}

@property (nonatomic) BOOL decodeFirstFrame;

-(int) readFromFile:(NSString*) name;

-(int) getFrameCount;

-(UIImage*) getFrame:(int) n;

-(int) getDelay:(int) n;

@end
