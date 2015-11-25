//
//  DCCircularProgressBar.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-10.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCCircularProgressBar.h"

@implementation DCCircularProgressBar {
    
    DCTickTimer* _rotatingTimer;
}

@synthesize rotatedAngle = _rotatedAngle;
@synthesize ringWidth = _ringWidth;
@synthesize progress = _progress;
@synthesize brightColor = _brightColor;
@synthesize faintColor = _faintColor;
@synthesize isRotating = _isRotating;

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
    self.opaque = NO;
    _brightColor = [UIColor whiteColor];
    _faintColor = [UIColor lightGrayColor];
}


-(void) setRingWidth:(float)ringWidth {
    _ringWidth = ringWidth;
    [self setNeedsDisplay];
}

-(void) setProgress:(float)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

-(void) setRotatedAngle:(float)rotatedAngle {
    _rotatedAngle = rotatedAngle;
    [self setNeedsDisplay];
}

-(void) setBrightColor:(UIColor *)brightColor {
    _brightColor = brightColor;
    [self setNeedsDisplay];
}

-(void) setFaintColor:(UIColor *)faintColor {
    _faintColor = faintColor;
    [self setNeedsDisplay];
}

-(void) setIsRotating:(BOOL)isRotating {
    
    _isRotating = isRotating;
    
    if (_isRotating) {
    
        if (!_rotatingTimer) {
            _rotatingTimer = [[DCTickTimer alloc] init];
            _rotatingTimer.delegate = self;
            [_rotatingTimer setRangeFrom:0 to:1 changedInDuration:60];
            [_rotatingTimer start];
        }
    }
    else {
        if (_rotatingTimer) {
            [_rotatingTimer stop];
            _rotatingTimer.delegate = nil;
            _rotatingTimer = nil;
        }
    }
}


-(void) timer:(id)timer didTickWithValue:(float)value {
    self.rotatedAngle += 5;
}

-(void) drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self setRotateTransformInContext:context];
    
    [self setBrightPathInContext:context withAngle:M_PI * 2 * _progress];
    CGContextSetFillColorWithColor(context, _brightColor.CGColor);
    CGContextFillPath(context);
    
    [self setFaintPathInContext:context withAngle:M_PI * 2 * (1 - _progress)];
    CGContextSetFillColorWithColor(context, _faintColor.CGColor);
    CGContextFillPath(context);
}

-(void) setRotateTransformInContext:(CGContextRef) context {
    
    float x = self.frame.size.width / 2;
    float y = self.frame.size.height / 2;

    CGContextTranslateCTM(context, x, y);
    CGContextRotateCTM(context, _rotatedAngle * M_PI / 180);
    CGContextTranslateCTM(context, -x, -y);
}

-(void) setBrightPathInContext:(CGContextRef) context withAngle:(float) angle {
    
    float x = self.frame.size.width / 2;
    float y = self.frame.size.height / 2;
    float r = MIN(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, x + r - _ringWidth, y);
    CGContextAddArc(context, x, y, r - _ringWidth, 0, angle, 0);
    CGContextAddLineToPoint(context, x + r * cos(angle), y + r * sin(angle));
    CGContextAddArc(context, x, y, r, angle, 0, 1);
    CGContextAddLineToPoint(context, x + r - _ringWidth, y);
    CGContextClosePath(context);
}

-(void) setFaintPathInContext:(CGContextRef) context withAngle:(float) angle {
    
    float x = self.frame.size.width / 2;
    float y = self.frame.size.height / 2;
    float r = MIN(self.frame.size.width / 2, self.frame.size.height / 2);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, x + r - _ringWidth, y);
    CGContextAddArc(context, x, y, r - _ringWidth, 0, -angle, 1);
    CGContextAddLineToPoint(context, x + r * cos(-angle), y + r * sin(-angle));
    CGContextAddArc(context, x, y, r, -angle, 0, 0);
    CGContextAddLineToPoint(context, x + r - _ringWidth, y);
    CGContextClosePath(context);
}

@end
