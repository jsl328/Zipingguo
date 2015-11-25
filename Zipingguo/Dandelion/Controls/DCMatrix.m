//
//  DCMatrix.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-20.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCMatrix.h"

@implementation DCMatrix {
    
    float _values[9];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setAsIdentity];
    }
    return self;
}

-(void) setAsIdentity {
    
    memset(_values, 0, 8 * sizeof(float));
    
    [self setValue:1 atRow:0 column:0];
    [self setValue:1 atRow:1 column:1];
}

-(void) scaleToScaleX:(float) scaleX scaleY:(float) scaleY centerAtPoint:(CGPoint) point {
    
    float previousScaleX = [self scaleX];
    float previousScaleY = [self scaleY];
    
    [self setValue:scaleX atRow:0 column:0];
    [self setValue:scaleY atRow:1 column:1];
    
    [self translateX:-point.x * (scaleX - previousScaleX) y: -point.y * (scaleY - previousScaleY)];
}

-(void) translateX:(float) x y:(float) y {
    [self setValue:[self valueAtRow:0 column:2] + x atRow:0 column:2];
    [self setValue:[self valueAtRow:1 column:2] + y atRow:1 column:2];
}

-(void) mapRect:(CGRect) rect1 toRect:(CGRect) rect2 {
    
    [self setAsIdentity];
    
    [self scaleToScaleX:(float)rect2.size.width / rect1.size.width scaleY:(float)rect2.size.height / rect1.size.height centerAtPoint:CGPointMake(0, 0)];
    [self translateX:rect2.origin.x - rect1.origin.x y:rect2.origin.y - rect1.origin.y];
}

-(void) applyTransformInContext:(CGContextRef)context {
    
    CGContextTranslateCTM(context, [self valueAtRow:0 column:2], [self valueAtRow:1 column:2]);
    CGContextScaleCTM(context, [self valueAtRow:0 column:0], [self valueAtRow:1 column:1]);
}

-(float) scaleX {
    return [self valueAtRow:0 column:0];
}

-(float) scaleY {
    return [self valueAtRow:1 column:1];
}


-(void) setValue:(float) value atRow:(int) row column:(int) column {
    _values[row * 3 + column] = value;
}

-(float) valueAtRow:(int) row column:(int) column {
    return _values[row * 3 + column];
}


-(void) dealloc {
    free(_values);
}

-(CGRect) rectMappedFromRect:(CGRect) rect {
    
    CGPoint p1 = [self pointMappedFromPoint:rect.origin];
    CGPoint p2 = [self pointMappedFromPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
    
    return CGRectMake(p1.x, p1.y, p2.x - p1.x, p2.y - p1.y);
}

-(CGPoint) pointMappedFromPoint:(CGPoint) point {
    
    return CGPointMake([self valueAtRow:0 column:0] * point.x + [self valueAtRow:0 column:1] * point.y + [self valueAtRow:0 column:2], [self valueAtRow:1 column:0] * point.x + [self valueAtRow:1 column:1] * point.y + [self valueAtRow:1 column:2]);
}

@end
