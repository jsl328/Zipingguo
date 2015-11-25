//
//  PRAnimationImage.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCAnimationImageFrame.h"

@interface DCAnimationImage : NSObject {

    NSMutableArray* _frames;
    
    BOOL _isLoadedFromFile;
}

-(BOOL) isLoadedFromFile;

-(void) addFrameWithImage:(UIImage*) image duration:(int) duration;

-(void) saveAsGifAtFilePath:(NSString*) filePath;
-(void) loadFromGifAtFilePath:(NSString*) filePath decodeFirstFrame:(BOOL) decodeFirstFrame;

-(int) frameCount;
-(DCAnimationImageFrame*) frameAtIndex:(int) index;
-(void) keepFirstFrame;

@end
