//
//  DCShapeButton.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-26.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCOvalShape.h"
#import <QuartzCore/QuartzCore.h>

@implementation DCOvalShape {

    CGMutablePathRef _path;

    CGPoint _point;
}

@synthesize borderWidth;
@synthesize borderColor;
@synthesize normalBackgroundColor;
@synthesize pressedBackgroundColor;


- (id)init
{
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
    [self setOpaque:NO];
    borderWidth = 1;
}


-(void) setClip {

    CGMutablePathRef prevPath = _path;
    
    _path = CGPathCreateMutable();
    CGPathAddEllipseInRect(_path, &CGAffineTransformIdentity, self.bounds);
    
    if (prevPath) {
        CGPathRelease(prevPath);
    }
}

-(void) setHighlighted:(BOOL)highlighted {
    
    if (!highlighted || CGPathContainsPoint(_path, &CGAffineTransformIdentity, _point, NO)) {
        [super setHighlighted:highlighted];
        [self setNeedsDisplay];
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    _point = [[touches anyObject] locationInView:self];
    [super touchesBegan:touches withEvent:event];
}

-(void) drawRect:(CGRect)rect {
    
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
   
    CGContextSetAllowsAntialiasing(context, YES);
    
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
    CGContextSetLineWidth(context, borderWidth);
    CGContextSetFillColorWithColor(context, self.state == UIControlStateHighlighted ? pressedBackgroundColor.CGColor : normalBackgroundColor.CGColor);
    
    
    CGContextAddEllipseInRect(context, self.bounds);
    CGContextFillPath(context);
    
    if (borderWidth > 0) {
    
        int offset = borderWidth % 2 == 0 ? borderWidth / 2 : floor((float)borderWidth / 2);
    
        CGContextBeginPath(context);
        CGContextAddEllipseInRect(context, CGRectMake(offset, offset, self.frame.size.width - offset * 2 - 0.5, self.frame.size.height - offset * 2 - 0.5));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

-(void) layoutSubviews {

    [super layoutSubviews];
    [self setClip];
}

@end
