//
//  DCDraggableView.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-16.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDraggableView.h"
#import "DCDirectionDispatcher.h"
#import "AppContext.h"

@implementation DCDraggableView

-(id) init {
    self = [super init];
    if (self) {
        self.isDraggingEnabled = YES;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isDraggingEnabled = YES;
    }
    return self;
}


-(DCDirectionDecision) decisionFromDirection:(DCMoveDirection)direction touch:(UITouch *)touch xDirection:(int)xDirection yDirection:(int)yDirection {
    return self.isDraggingEnabled ? DCDirectionDecisionAccept : DCDirectionDecisionDiscard;
}

-(BOOL) isProperDirection:(DCMoveDirection) direction {
    return NO;
}

-(void) directionTouchesBegan:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:[AppContext controller].view];
    _x = point.x;
    _y = point.y;
}

-(void) directionTouchesMoved:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:[AppContext controller].view];
    [self moveToX:point.x y:point.y];
}

-(void) directionTouchesEnded:(UITouch *)touch {
}


-(void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (!newWindow) {
        [[DCDirectionDispatcher defaultDispatcher] unregisterHandler:self];
    }
    else {
        [[DCDirectionDispatcher defaultDispatcher] registerHandler:self];
    }
}

-(void) moveToX:(float) x y:(float) y {

    self.frame = CGRectMake(self.frame.origin.x + (x - _x), self.frame.origin.y + (y - _y), self.frame.size.width, self.frame.size.height);
    
    _x = x;
    _y = y;
}

@end
