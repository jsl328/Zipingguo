//
//  DCAnimationImageBox.m
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCAnimationImageBox.h"
#import "DCUrlEntityManager.h"
#import "AppContext.h"
#import "DCImageCache.h"
#import "DCUrlDownloader.h"
#import <QuartzCore/QuartzCore.h>

@implementation DCAnimationImageBox  {
    
    BOOL _isPlaying;
    
    DCFileSource* _source;
    
    NSString* _filePath;
}

@synthesize animationImage = _animationImage;
@synthesize isPlaying;

-(id) init {
    self = [super init];
    if (self) {
        [self initializeImageBox];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeImageBox];
    }
    return self;
}

-(void) initializeImageBox {
    self.contentMode = UIViewContentModeScaleAspectFit;
    _source = [[DCFileSource alloc] init];
    _source.delegate = self;
}

-(DCFileSource*) source {
    return _source;
}

-(void) acceptFile:(NSString *)filePath {

    if (![_filePath isEqualToString:filePath]) {
        
        if (!_filePath || _filePath.length == 0) {
            [self setAnimationImage:nil];
        }
        else {
            DCAnimationImage* image = [[DCAnimationImage alloc] init];
            [image loadFromGifAtFilePath:filePath decodeFirstFrame:NO];
            [self setAnimationImage:image];
        }
        
        _filePath = filePath;
    }
}


-(void) setAnimationImage:(DCAnimationImage *) animationImage {
    
    _animationImage = animationImage;
    _filePath = nil;
    
    if (!isPlaying) {
        [self showFirstFrame];
    }
    else {
        [self play];
    }
}


-(void) showFirstFrame {
    self.image = _animationImage && _animationImage.frameCount > 0 ? [_animationImage frameAtIndex:0].image : nil;
}

-(void) play {
    
    if (!_animationImage || _animationImage.frameCount == 0) {
        return;
    }
    
    if (isPlaying) {
        [self stop];
    }
    
    
    if (_animationImage.frameCount == 1) {
        [self showFirstFrame];
        return;
    }
    
    self.image = nil;
    isPlaying = YES;
    
    CAKeyframeAnimation *customFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    
    float timeOffset = 0;
    
    NSMutableArray* times = [[NSMutableArray alloc] init];
    NSMutableArray* images = [[NSMutableArray alloc] init];
    
    
    float totalDuration = 0;
    for (int i = 0; i <= _animationImage.frameCount - 1; i++) {
        DCAnimationImageFrame* frame = [_animationImage frameAtIndex:i];
        totalDuration += MAX(frame.duration, 120);
    }
    
    for (int i = 0; i <= _animationImage.frameCount; i++) {
        DCAnimationImageFrame* frame = [_animationImage frameAtIndex:i % _animationImage.frameCount];
        [images addObject:(id)frame.image.CGImage];
        [times addObject:[NSNumber numberWithFloat:timeOffset]];
        timeOffset += MAX(frame.duration, 120) / totalDuration;
    }
    
    NSArray *timingFunctions = [NSArray arrayWithObjects: [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault], nil];
    
    [customFrameAnimation setValues:images];
    [customFrameAnimation setKeyTimes:times];
    
    customFrameAnimation.duration = totalDuration / 1000;
    customFrameAnimation.repeatCount = HUGE_VALF;
    customFrameAnimation.autoreverses = NO;
    customFrameAnimation.calculationMode = kCAAnimationDiscrete;
    customFrameAnimation.timingFunctions = timingFunctions;
    [self.layer addAnimation:customFrameAnimation forKey:@"image"];
}

-(void) stop {
    if (isPlaying) {
        
        isPlaying = NO;
        [self.layer removeAllAnimations];

        [self showFirstFrame];
    }
}

-(void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [_source ownerWillMoveToWindow:newWindow];
}

@end
