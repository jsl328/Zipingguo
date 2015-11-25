//
//  DCTickTimer.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-19.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Interpolator.h"

@protocol DCTickTimerDelegate <NSObject>

-(void) timer:(id) timer didTickWithValue:(float) value;

@optional

-(void) timerDidStop:(id) timer;

@end


@interface DCTickTimer : NSObject {

    float _from;
    
    float _to;
    
    int _isStarted;
    
    int _isScheduling;
    
    dispatch_queue_t _queue;
    
    int _tickCount;
    
    int _countOfTicks;
    
    double _interval;
}

@property (assign, nonatomic) id <DCTickTimerDelegate> delegate;
@property (retain, nonatomic) Interpolator* interpolator;

-(NSTimeInterval) tickInterval;

-(void) setRangeFrom:(float) from to:(float) to changedInDuration:(NSTimeInterval) duration;

-(void) start;
-(void) stop;

@end
