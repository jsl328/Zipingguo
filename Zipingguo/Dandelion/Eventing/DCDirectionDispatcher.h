//
//  DCTantativeEventDispatcher.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-11.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHandleDirection.h"

@interface DCDirectionDispatcher : NSObject {

    NSMutableArray* _handlers;
    
    UIView* _dispatchTarget;
    
    BOOL _sendWindowEvents;
    
    BOOL _targetFound;
    
    BOOL _waitForTouchUp;
    
    BOOL _touchesBeganInvoked;
}

-(BOOL) targetFound;

-(UIView*) dispatchTarget;

-(BOOL) sendWindowEvents;


+(DCDirectionDispatcher*) defaultDispatcher;

-(void) registerHandler:(id <DCHandleDirection>) handler;

-(void) unregisterHandler:(id <DCHandleDirection>) handler;

-(void) dispatchSingleTouch:(UITouch*) touch;

-(void) dispatchMultipleTouchesWithTouches:(NSSet*) touches event:(UIEvent*) event;

//-(void) waitForTouchUp:(id <DCHandleDirection>) handler;

@end
