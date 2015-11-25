//
//  PRAnimationImage.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCAnimationImage.h"
#import "DCAnimatedGifEncoder.h"
#import "DCGifDecoder.h"
#import "DCImageCache.h"

@implementation DCAnimationImage

-(id) init {
    self = [super init];
    if (self) {
        _frames = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL) isLoadedFromFile {
    return _isLoadedFromFile;
}

-(void) addFrameWithImage:(UIImage*) image duration:(int) duration {
    
    _isLoadedFromFile = NO;
    
    [_frames addObject:[[DCAnimationImageFrame alloc] initWithImage:image duration:duration]];
}

-(void) saveAsGifAtFilePath:(NSString*) filePath {
    DCAnimatedGifEncoder* encoder = [[DCAnimatedGifEncoder alloc] init];
    [encoder startWithFile:filePath];
    [encoder setRepeat:0];
    for (DCAnimationImageFrame* frame in _frames) {
        [encoder setDelay:frame.duration];
        [encoder addFrame:frame.image];
    }
    [encoder finish];
}

-(void) loadFromGifAtFilePath:(NSString*) filePath decodeFirstFrame:(BOOL) decodeFirstFrame {

    PRGifDecoder* decoder = [[PRGifDecoder alloc] init];
    [decoder setDecodeFirstFrame:decodeFirstFrame];
    [decoder readFromFile:filePath];
    
    
    [_frames removeAllObjects];
    
    for (int i = 0; i <= [decoder getFrameCount] - 1; i++) {
        [_frames addObject:[[DCAnimationImageFrame alloc] initWithImage:[decoder getFrame:i] duration:[decoder getDelay:i]]];
    }
    
    _isLoadedFromFile = YES;
}


-(int) frameCount {
    return _frames.count;
}

-(DCAnimationImageFrame*) frameAtIndex:(int) index {
    return (DCAnimationImageFrame*)[_frames objectAtIndex:index];
}

-(void) keepFirstFrame {
    while (_frames.count > 1) {
        [_frames removeObjectAtIndex:_frames.count - 1];
    }
}

@end
