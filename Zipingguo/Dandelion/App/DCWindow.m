//
//  DCWindow.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCWindow.h"
#import "DCDirectionDispatcher.h"

@implementation DCWindow

-(void) sendEvent:(UIEvent *)event {

    NSSet* touches = [event touchesForWindow:self];
    UITouch* touch = [touches anyObject];

    if (event.type != UIEventTypeTouches) {
        [super sendEvent:event];
    }
    else if (touches.count == 1) {
        
        [[DCDirectionDispatcher defaultDispatcher] dispatchSingleTouch:touch];

        if ([DCDirectionDispatcher defaultDispatcher].sendWindowEvents || touch.phase == UITouchPhaseEnded || ![[DCDirectionDispatcher defaultDispatcher] dispatchTarget]) {
            [super sendEvent:event];
        }
    }
    else {

        [[DCDirectionDispatcher defaultDispatcher] dispatchMultipleTouchesWithTouches:touches event:event];
        
        if ([DCDirectionDispatcher defaultDispatcher].sendWindowEvents || touch.phase == UITouchPhaseEnded || ![[DCDirectionDispatcher defaultDispatcher] dispatchTarget]) {
            [super sendEvent:event];
        }
    }
}

@end