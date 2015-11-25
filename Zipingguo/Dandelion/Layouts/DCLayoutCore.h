//
//  DCLayoutCore.h
//  Nanumanga
//
//  Created by Bob Li on 13-10-19.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCViewGroup.h"

@interface DCLayoutCore : NSObject

+(void) setMeasuredSizeWithContentWidth:(float) contentWidth widthSpec:(DCMeasureSpec) widthSpec contentHeight:(float) contentHeight heightSpec:(DCMeasureSpec) heightSpec forView:(UIView*) view;

+(void) updateLayoutForView:(UIView*) view;

+(void) updateLayoutWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec: (DCMeasureSpec) heightSpec forView:(UIView*) view;

+(DCMeasureSpec) measureSpecForSize:(float) size withParentSpec:(DCMeasureSpec) spec;

+(void) measure:(UIView*) view widthSpec:(DCMeasureSpec)widthSpec heightSpec:(DCMeasureSpec)heightSpec;


+(CGRect) rectOfRect:(CGRect) rect inSize:(CGSize) parentSize withView:(UIView*) view inViewGroup:(DCViewGroup*) viewGroup;

@end
