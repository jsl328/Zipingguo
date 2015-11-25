//
//  DCVolumnMeter.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-8.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCVolumnMeterViewDefaultImpl.h"

@implementation DCVolumnMeterViewDefaultImpl {

    float _speed1;
    float _speed2;
    
    float _x1;
    float _x2;
    
    float _t1;
    float _t2;
    
    float _p;
    
    
    UIColor* _lowColor;
    UIColor* _mediumColor;
    UIColor* _highColor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.opaque = NO;
        _speed1 = 5;
        _speed2 = 10;
        _t1 = 20;
        _t2 = 40;
        _lowColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.4];
        _mediumColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.4];
        _highColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.4];
    }
    return self;
}

-(void) setVolumn:(float)volumn {

    _x1 += _speed1;
    _x2 += _speed2;
    
    _p = volumn;
    
    [self setNeedsDisplay];
}

-(void) drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextClip(context);
    
    UIColor* color;
    
    if (_p <= 0.5) {
        color = _lowColor;
    }
    else if (_p <= 0.75) {
        color = _mediumColor;
    }
    else {
        color = _highColor;
    }
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    
    for (int i = 0; i <= 1; i++) {
    
        [self createPath:i context:context];
        
        CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
        CGContextAddLineToPoint(context, 0, self.frame.size.height);
        CGContextClosePath(context);

        CGContextDrawPath(context, kCGPathFill);
    }
}

-(void) createPath:(int) index context:(CGContextRef) context {

    float prevX = -1;
    float prevY = -1;
    
    if (index == 0) {
        
        for (float x = 0; x <= self.frame.size.width; x += 2) {
            
            float y = self.frame.size.height * (1 - _p) + sin(x / _t1 - _x1) * 5;
            
            if (prevX == -1) {
                CGContextMoveToPoint(context, x, y);
            }
            else {
                CGContextAddLineToPoint(context, x, y);
            }
            
            prevX = x;
            prevY = y;
        }
    }
    else {
        
        for (float x = 0; x <= self.frame.size.width; x += 2) {
            
            float y = self.frame.size.height * (1 - _p) + sin(x / _t2 - _x2) * 5;
            
            if (prevX == -1) {
                CGContextMoveToPoint(context, x, y);
            }
            else {
                CGContextAddLineToPoint(context, x, y);
            }
            
            prevX = x;
            prevY = y;
        }
    }
}

@end
