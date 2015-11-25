//
//  DCViewEffects.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-22.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCViewEffects.h"
#import <QuartzCore/QuartzCore.h>

@implementation DCViewEffectsDelegate
@synthesize callback;

- (void) animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (flag) {
        
        if (callback) {
            ((void (^)(void))callback)();
        }
        
        callback = nil;
    }
}

@end


@implementation DCViewEffects

+(void) jitterView:(UIView*) view byOffset:(float) offset alongAngle:(float) angle withDuration:(double) duration forTimes:(int) times completeCallback:(void (^)(void)) completeCallback {

    float offsetX = offset * cos(angle * M_PI / 180);
    float offsetY = offset * sin(angle * M_PI / 180);

    
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= times; i++) {
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(offsetX, offsetY, 0)]];
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-offsetX, -offsetY, 0)]];
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-offsetX, -offsetY, 0)]];
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(offsetX, offsetY, 0)]];
    }
    
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = frames;
    animation.duration = duration * times;
    
    DCViewEffectsDelegate* delegate = [[DCViewEffectsDelegate alloc] init];
    delegate.callback = completeCallback;
    animation.delegate = delegate;
    
    
    [view.layer addAnimation:animation forKey:@"jitterView"];
}

+(void) blink:(UIView*) view withDuration:(double) duration forTimes:(int) times completeCallback:(void (^)(void)) completeCallback {
}

+(void) expandViews:(NSArray*) views withDuration:(double) duration completeCallback:(void (^)(void)) completeCallback {

    NSMutableArray* frames = [[NSMutableArray alloc] init];
    
    [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)]];
    [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = frames;
    animation.duration = duration;
    
    DCViewEffectsDelegate* delegate = [[DCViewEffectsDelegate alloc] init];
    delegate.callback = completeCallback;
    animation.delegate = delegate;
    
    
    for (UIView* view in views) {
        [view.layer addAnimation:animation forKey:@"expandViews"];
    }
}

+(void) shrinkViews:(NSArray*) views withDuration:(double) duration completeCallback:(void (^)(void)) completeCallback {

    NSMutableArray* frames = [[NSMutableArray alloc] init];
    
    [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)]];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = frames;
    animation.duration = duration;
    
    DCViewEffectsDelegate* delegate = [[DCViewEffectsDelegate alloc] init];
    delegate.callback = completeCallback;
    animation.delegate = delegate;
    
    
    for (UIView* view in views) {
        [view.layer addAnimation:animation forKey:@"shrinkViews"];
    }
}

+(void) startRotatingViews:(NSArray*) views clockwise:(BOOL) clockwise inDurationForOneRevolution:(NSTimeInterval)duration {

    
    NSMutableArray* frames = [[NSMutableArray alloc] init];

    if (clockwise) {
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 2, 0, 0, 1)]];
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)]];
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)]];
    }
    else {
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0, 0, 1)]];
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)]];
        [frames addObject:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 2, 0, 0, 1)]];
    }
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.values = frames;
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = NO;
    
    for (UIView* view in views) {
        [view.layer addAnimation:animation forKey:@"rotateViews"];
    }
}

+(void) stopRotatingViews:(NSArray *)views {

    for (UIView* view in views) {
        [view.layer removeAnimationForKey:@"rotateViews"];
    }
}

@end
