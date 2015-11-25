//
//  DCDandelionLib.h
//  DandelionDemo
//
//  Created by Bob Li on 14-1-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCLayoutParams.h"
#import "AnnotationProvider.h"

DCLayoutParams* DCLayoutParamsMake(float width, float height);

DCMeasureSpec DCMeasureSpecMake(DCMeasureSpecMode mode, float size);
DCMeasureSpec DCMeasureSpecMakeExactly(float size);
DCMeasureSpec DCMeasureSpecMakeAtMost(float size);
DCMeasureSpec DCMeasureSpecMakeUnspecified();

int DCNumberFromHexChars(char c1, char c2);

CGRect DCRectMake(float p1, float p2, float length1, float length2, DCOrientation orientation);


NSString* DCUUIDMake();

NSString* DCMD5ForString(NSString* s);

float DCMathAbs(float value);

void DCField(AnnotationProvider* ap, NSString* propertyName, NSString* fieldName);
void DCListField(AnnotationProvider* ap, NSString* propertyName, NSString* fieldName, Class itemType);

void DCEnum(AnnotationProvider* ap, NSString* propertyName, NSString* enumName);

CGRect DCGetFrameInWindow(CGSize size, DCHorizontalGravity horizontalGravity, DCVerticalGravity verticalGravity, UIEdgeInsets padding);

void DCPerformAnimation(int animationType, BOOL isIn, UIView* view, CGRect targetFrame, id completeCallback);
