//
//  DCDirectionDector.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-11.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//


#import "DCDirectionDetector.h"

static DCDirectionDetector* _defaultDetector;

@implementation DCDirectionDetector

+(DCDirectionDetector*) defaultDetector {
    if (!_defaultDetector) {
        _defaultDetector = [[DCDirectionDetector alloc] init];
    }
    return _defaultDetector;
}

-(void) initializeWithX:(int) x y:(int) y {
    _x = x;
    _y = y;
    _touchDownX = x;
    _touchDownY = y;
    _segmentIndex = 0;
    _result = DCMoveDirectionTentative;
}

-(void) detectWithX:(int) x y:(int) y {
    
    if (_result != DCMoveDirectionTentative) {
        return;
    }

    if (abs(x - _x) < 3 && abs(y - _y) < 3) {
        return;
    }
    
    
    if (_x == x) {
        _result = y < _y ? DCMoveDirectionUp : DCMoveDirectionDown;
    }
    else {
        double angle = atan(abs(y - _y) / abs(x - _x));
        if (angle <= 0.4) {
            _result = x > _x ? DCMoveDirectionRight : DCMoveDirectionLeft;
        }
        else if (angle >= 1.1) {
            _result = y < _y ? DCMoveDirectionUp : DCMoveDirectionDown;
        }
    }

    
    _x = x;
    _y = y;
    
    if (_result == DCMoveDirectionTentative && (abs(x - _x) >= 6 || abs(y - _y) >= 6)) {
        _segmentIndex++;
        if (_segmentIndex == 3) {
            _result = DCMoveDirectionInvalid;
        }
    }
}

-(int) xDirection {
    return _x >= _touchDownX ? 1 : -1;
}

-(int) yDirection {
    return _y > _touchDownY ? 1 : -1;
}


-(BOOL) isTentative {
    return _result == DCMoveDirectionTentative;
}

-(DCMoveDirection) result {
    return _result;
}

@end
