//
//  DCTantativeEventDispatcher.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-11.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDirectionDispatcher.h"
#import "DCDirectionDetector.h"
#import "DCHandleDirection.h"


DCDirectionDispatcher* _defaultDispatcher;

@implementation DCDirectionDispatcher

+(DCDirectionDispatcher*) defaultDispatcher {

    if (!_defaultDispatcher) {
        _defaultDispatcher = [[DCDirectionDispatcher alloc] init];
    }
    
    return _defaultDispatcher;
}

-(id) init {
    self = [super init];
    if (self) {
        _handlers = [[NSMutableArray alloc] init];
    }
    return self;
}


-(BOOL) targetFound {
    return _targetFound;
}

-(UIView*) dispatchTarget {
    return _dispatchTarget;
}

-(BOOL) sendWindowEvents {
    return _sendWindowEvents;
}


-(void) registerHandler:(id<DCHandleDirection>)handler {
    [_handlers addObject:handler];
}

-(void) unregisterHandler:(id<DCHandleDirection>)handler {
    [_handlers removeObject:handler];
}

/*
-(void) waitForTouchUp:(id <DCHandleDirection>) handler {
    _waitForTouchUp = YES;
}
*/

-(void) dispatchSingleTouch:(UITouch *) touch {
    
    if (_handlers.count == 0) {
        _targetFound = YES;
        return;
    }
    

    if (touch.phase == UITouchPhaseBegan) {
        
        _dispatchTarget = nil;
        _targetFound = NO;
        _waitForTouchUp = NO;
        _touchesBeganInvoked = NO;
        
        CGPoint location = [touch locationInView:[AppContext rootController].view];
        [[DCDirectionDetector defaultDetector] initializeWithX:location.x y:location.y];
    }
    else if (touch.phase == UITouchPhaseMoved) {
    
        if ([[DCDirectionDetector defaultDetector] result] == DCMoveDirectionTentative) {
            CGPoint location = [touch locationInView:[AppContext rootController].view];
            [[DCDirectionDetector defaultDetector] detectWithX:location.x y:location.y];
        }
    }
    
    
    int direction = [[DCDirectionDetector defaultDetector] result];
    if (direction == DCMoveDirectionTentative) {
        return;
    }
    
    
    if (_targetFound) {
        
        if (!_dispatchTarget) {
            return;
        }
        
        if (touch.phase == UITouchPhaseMoved) {
            if (!_touchesBeganInvoked) {
                _touchesBeganInvoked = YES;
                [(id <DCHandleDirection>)_dispatchTarget directionTouchesBegan:touch];
            }
            else if (!_waitForTouchUp) {
                [(id <DCHandleDirection>)_dispatchTarget directionTouchesMoved:touch];
            }
        }
        else if (touch.phase == UITouchPhaseEnded) {
            [(id <DCHandleDirection>)_dispatchTarget directionTouchesEnded:touch];
        }
        
        return;
    }
    else {
        _targetFound = YES;
        _dispatchTarget = [self findDispatchTargetForSingleTouch:touch];
        _sendWindowEvents = [_dispatchTarget respondsToSelector:@selector(sendWindowEvents)]&& [_dispatchTarget performSelector:@selector(sendWindowEvents)];
    }
}

-(void) dispatchMultipleTouchesWithTouches:(NSSet *)touches event:(UIEvent *)event {
    
    if (_handlers.count == 0) {
        _targetFound = YES;
        return;
    }
    
    
    UITouch* touch = [touches anyObject];
    
    if (touch.phase == UITouchPhaseBegan) {
        _dispatchTarget = nil;
        _targetFound = NO;
        _waitForTouchUp = NO;
        _touchesBeganInvoked = NO;
    }
    
    
    if (_targetFound) {
        
        if (!_dispatchTarget) {
            return;
        }
        
        if (touch.phase == UITouchPhaseMoved) {
            if (!_touchesBeganInvoked) {
                _touchesBeganInvoked = YES;
                [_dispatchTarget touchesBegan:touches withEvent:event];
            }
            else if (!_waitForTouchUp) {
                [_dispatchTarget touchesMoved:touches withEvent:event];
            }
        }
        else if (touch.phase == UITouchPhaseEnded) {
            [_dispatchTarget touchesEnded:touches withEvent:event];
        }
        
        return;
    }
    else {
        _targetFound = YES;
        _dispatchTarget = [self findDispatchTargetForMultipleTouches];
        _sendWindowEvents = [_dispatchTarget respondsToSelector:@selector(sendWindowEvents)]&& [_dispatchTarget performSelector:@selector(sendWindowEvents)];
    }
}

-(UIView*) findDispatchTargetForSingleTouch:(UITouch*) touch {
    
    DCMoveDirection direction = [[DCDirectionDetector defaultDetector] result];
    
    
    UIView* rootView = [AppContext rootController].view;
    
    int score = 0;
    UIView* found = nil;
    DCDirectionDecision foundDecision = DCDirectionDecisionDiscard;
    
    for (UIView* view in _handlers) {
        
        int depth = [DCDirectionDispatcher depthOfView:view underRootView:rootView];
        if (depth == -1) {
            continue;
        }
        
        
        CGPoint location = [touch locationInView:view];
        
        if (!(location.x >= 0 && location.x <= view.frame.size.width && location.y >= 0 && location.y <= view.frame.size.height)) {
            continue;
        }
        
        
        DCDirectionDecision decision = [(id <DCHandleDirection>)view decisionFromDirection:direction touch:touch xDirection:[[DCDirectionDetector defaultDetector] xDirection] yDirection:[[DCDirectionDetector defaultDetector] yDirection]];
        BOOL isProperDirection = [(id <DCHandleDirection>)view isProperDirection:direction];

        int currentScore = (int)(decision - 1) * 9000 + (isProperDirection ? 90 : 0) + depth;
        
        if (score < currentScore) {
            score = currentScore;
            found = view;
            foundDecision = decision;
        }
    }
    
    if (foundDecision == DCDirectionDecisionDiscard) {
        found = nil;
    }
    
    return found;
}

-(UIView*) findDispatchTargetForMultipleTouches {
    
    
    UIView* rootView = [AppContext rootController].view;
    
    int score = 0;
    UIView* found = nil;
    
    for (UIView* view in _handlers) {
        
        int depth = [DCDirectionDispatcher depthOfView:view underRootView:rootView];
        if (depth == -1) {
            continue;
        }
        
        if (![view respondsToSelector:@selector(acceptMultipleTouches)]) {
            continue;
        }
        
        
        int currentScore = depth;
        
        if (score < currentScore) {
            score = currentScore;
            found = view;
        }
    }
    
    return found;
}


+(int) depthOfView:(UIView*) view underRootView:(UIView*) rootView {

    int depth = 0;
    
    UIView* current = view;
    
    while (current && current != rootView) {
        depth++;
        current = current.superview;
    }
    
    return current == rootView ? depth : -1;
}

@end
