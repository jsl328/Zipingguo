//
//  DCDirectionDector.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-11.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DCMoveDirection {
    DCMoveDirectionLeft = 0,
    DCMoveDirectionRight = 1,
    DCMoveDirectionUp = 2,
    DCMoveDirectionDown = 3,
    DCMoveDirectionInvalid = 4,
    DCMoveDirectionTentative = 5
};
typedef enum DCMoveDirection DCMoveDirection;


@interface DCDirectionDetector : NSObject {
    
    DCMoveDirection _result;
    
    int _touchDownX;
    int _touchDownY;
    
    int _x;
    int _y;
    
    int _segmentIndex;
}

+(DCDirectionDetector*) defaultDetector;

-(void) initializeWithX:(int) x y:(int) y;
-(void) detectWithX:(int) x y:(int) y;

-(BOOL) isTentative;

-(DCMoveDirection) result;

-(int) xDirection;
-(int) yDirection;

@end

