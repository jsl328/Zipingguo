//
//  PRAnimatedGifEncoder.h
//  DandelionDemo
//
//  Created by Bob Li on 13-11-22.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

/**
 * Class AnimatedGifEncoder - Encodes a GIF file consisting of one or more
 * frames.
 *
 * <pre>
 *  Example:
 *     AnimatedGifEncoder e = new AnimatedGifEncoder();
 *     e.start(outputFileName);
 *     e.setDelay(1000);   // 1 frame per sec
 *     e.addFrame(image1);
 *     e.addFrame(image2);
 *     e.finish();
 * </pre>
 *
 * No copyright asserted on the source code of this class. May be used for any
 * purpose, however, refer to the Unisys LZW patent for restrictions on use of
 * the associated LZWEncoder class. Please forward any corrections to
 * kweiner@fmsware.com.
 *
 * @author Kevin Weiner, FM Software
 * @version 1.03 November 2003
 *
 */

#import <Foundation/Foundation.h>
#import "DCStreamWriter.h"
#import "DCByteArray.h"
#import "DCIntArray.h"

@interface DCAnimatedGifEncoder : NSObject {

    int width; // image size
    
    int height;
    
    UIColor* transparent; // transparent color if given
    
    int transIndex; // transparent index in color table
    
    int repeat; // no repeat
    
    int delay; // frame delay (hundredths)
    
    BOOL started; // ready to output frames
    
    DCStreamWriter* stream;
    
    UIImage* image; // current frame
    
    DCByteArray* pixels; // BGR byte array from frame
    
    DCByteArray* indexedPixels; // converted frame indexed to palette
    
    int colorDepth; // number of bit planes
    
    DCByteArray* colorTab; // RGB palette
    
    DCIntArray* usedEntry; // active palette entries
    
    int palSize; // color table size (bits-1)
    
    int dispose; // disposal code (-1 = use default)
    
    BOOL closeStream; // close stream when finished
    
    BOOL firstFrame;
    
    BOOL sizeSet; // if false, get size from first frame
    
    int sample; // default sample interval for quantizer
}

-(BOOL) startWithStreamWriter:(DCStreamWriter*) os;
-(BOOL) startWithFile:(NSString*) file;
-(BOOL) finish;

-(BOOL) addFrame:(UIImage*) im;
-(void) setDelay:(int) ms;
-(void) setRepeat:(int) iter;
-(void) setTransparent:(UIColor*) c;

@end
