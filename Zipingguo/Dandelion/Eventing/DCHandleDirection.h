//
//  DCTantativeView.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-11.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDirectionDetector.h"

enum DCDirectionDecision {
    DCDirectionDecisionDiscard = 0,
    DCDirectionDecisionAccept = 1,
    DCDirectionDecisionSieze = 2
};
typedef enum DCDirectionDecision DCDirectionDecision;


@protocol DCHandleDirection <NSObject>

-(DCDirectionDecision) decisionFromDirection:(DCMoveDirection) direction touch:(UITouch*) touch xDirection:(int) xDirection yDirection:(int) yDirection;

-(BOOL) isProperDirection:(DCMoveDirection) direction;

-(void) directionTouchesBegan:(UITouch*) touch;

-(void) directionTouchesMoved:(UITouch*) touch;

-(void) directionTouchesEnded:(UITouch*) touch;

@optional

-(void) touchesBegan:(UITouch*) touch;

-(BOOL) sendWindowEvents;

-(BOOL) acceptMultipleTouches;

@end
