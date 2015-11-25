//
//  DCTickTimer.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-19.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCTickTimer.h"

@implementation DCTickTimer
@synthesize delegate;
@synthesize interpolator;

- (id)init
{
    self = [super init];
    if (self) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        interpolator = [[LinearInterpolator alloc] init];
    }
    return self;
}

-(int) countOfTicks {
    return _countOfTicks;
}

-(NSTimeInterval) tickInterval {
    return _interval;
}

-(void) setRangeFrom:(float) from to:(float) to changedInDuration:(NSTimeInterval) duration {

    _from = from;
    _to = to;
    _tickCount = 0;
    
    if (duration == 0) {
        _countOfTicks = 1;
        _interval = 0;
    }
    else if (duration < 0.025) {
        _countOfTicks = 1;
        _interval = 0.025;
    }
    else {
        _countOfTicks = duration / 0.025;
        _interval = 0.025;
    }
}

-(void) start {
    
    if (_countOfTicks == 1 && _interval == 0) {
        _tickCount = 1;
        [self tick];
        [self stop];
        return;
    }
    
    
    if (_isStarted) {
        return;
    }
    
    _isStarted = YES;
    if (!_isScheduling) {
        _isScheduling = YES;
        [self tick];
        [self scheduleNextTick];
    }
}

-(void) stop {
    _isStarted = NO;
    if ([delegate respondsToSelector:@selector(timerDidStop:)]) {
        [delegate timerDidStop:self];
    }
}


-(void) scheduleNextTick {

    dispatch_async(_queue, ^{
        [NSThread sleepForTimeInterval:_interval];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(_isStarted) {
                [self tick];
            }
            
            if (_countOfTicks > 0) {
                if (_tickCount == _countOfTicks) {
                    [self stop];
                }
                else {
                    _tickCount++;
                }
            }
            
            if (_isStarted) {
                [self scheduleNextTick];
            }
            else {
                _isScheduling = NO;
            }
        });
    });
}

-(void) tick {
    if (delegate) {
        [delegate timer:self didTickWithValue:[interpolator interpolateWithPercent:(float)_tickCount / _countOfTicks from:_from to:_to]];
    }
}

@end
