//
//  DCMatrix.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-20.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCMatrix : NSObject

-(void) scaleToScaleX:(float) scaleX scaleY:(float) scaleY centerAtPoint:(CGPoint) point;

-(void) translateX:(float) x y:(float) y;

-(void) mapRect:(CGRect) rect1 toRect:(CGRect) rect2;

-(void) applyTransformInContext:(CGContextRef) context;

-(float) scaleX;

-(float) scaleY;

-(CGRect) rectMappedFromRect:(CGRect) rect;

-(CGPoint) pointMappedFromPoint:(CGPoint) point;

-(void) dealloc;

@end
