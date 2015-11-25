//
//  DCToastView.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-22.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCToast.h"
#import "DCContentPresenter.h"
#import "DCTickTimer.h"

static DCContentPresenter* _cp;

static DCToast* _instance;

static float _remainingTime;


@implementation DCToast
@synthesize content;
@synthesize size;
@synthesize horizontalGravity;
@synthesize verticalGravity;
@synthesize padding;
@synthesize inAnimation;
@synthesize outAnimation;

-(void) showShort {
    [self showForDuration:0.6];
}

-(void) showLong {
    [self showForDuration:1.8];
}

-(void) showForDuration:(NSTimeInterval) duration {
    
    _instance = self;
    
    if (_cp) {
        _cp.content = content;
        _remainingTime = duration;
        return;
    }
    
    
    _cp = [[DCContentPresenter alloc] init];
    _cp.content = content;
    [[AppContext window] addSubview:_cp];

    DCPerformAnimation(inAnimation, YES, _cp, DCGetFrameInWindow(size, horizontalGravity, verticalGravity, padding), ^{
        _remainingTime = duration;
        [self onTick];
    });
}

-(void) onTick {

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.2];
        dispatch_async(dispatch_get_main_queue(), ^{
            _remainingTime -= 0.2;
            if (_remainingTime <= 0) {

                DCPerformAnimation(outAnimation, NO, _cp, DCGetFrameInWindow(_instance.size, _instance.horizontalGravity, _instance.verticalGravity, _instance.padding), ^{
                    _remainingTime = 0;
                    [_cp removeFromSuperview];
                    _cp = nil;
                    _instance = nil;
                });
            }
            else {
                [self onTick];
            }
        });
    });
}

@end
