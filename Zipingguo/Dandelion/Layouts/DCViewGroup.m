//
//  DCViewGroup.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-4.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCViewGroup.h"
#import "DCView.h"
#import "DCControl.h"

@implementation DCViewGroup
@synthesize gap;
@synthesize padding;

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
    _layoutParameters = [[NSMutableArray alloc] init];
    _margins = [[NSMutableArray alloc] init];
    _layoutSizes = [[NSMutableArray alloc] init];
}


-(void) layout:(UIView*) view withRect:(CGRect) rect {
    view.frame = rect;
    if ([view.class isSubclassOfClass:[DCView class]]) {
        [(DCView*)view onLayout];
    }
    else if ([view.class isSubclassOfClass:[DCControl class]]) {
        [(DCControl*)view onLayout];
    }
}


-(void) expandLayoutSizesArrayIfNeeded {
    while (_layoutSizes.count < self.subviews.count) {
        [_layoutSizes addObject:[NSValue valueWithCGSize:CGSizeMake(0, 0)]];
    }
}

-(void) expandLayoutParametersArrayIfNeeded {
    while (_layoutParameters.count < self.subviews.count) {
        [_layoutParameters addObject:[self newLayoutParams]];
    }
}

-(void) expandMarginArrayIfNeeded {
    while (_margins.count < self.subviews.count) {
        [_margins addObject:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
    }
}


-(CGSize) layoutSizeForView:(UIView*) view {
    [self expandLayoutSizesArrayIfNeeded];
    return [[_layoutSizes objectAtIndex:[self.subviews indexOfObject:view]] CGSizeValue];
}

-(void) setLayoutSize:(CGSize) size ForView:(UIView*) view {
    [self expandLayoutSizesArrayIfNeeded];
    [_layoutSizes setObject:[NSValue valueWithCGSize:size] atIndexedSubscript:[self.subviews indexOfObject:view]];
}


-(DCLayoutParams*) newLayoutParams {
    return DCLayoutParamsMake(DCLayoutWrapContent, DCLayoutWrapContent);
}


-(DCLayoutParams*) layoutParamsForView:(UIView*) view {
    
    if ([[view class] isSubclassOfClass:[DCView class]]) {
        return ((DCView*)view).layoutParams;
    }
    else if ([[view class] isSubclassOfClass:[DCControl class]]) {
        return ((DCControl*)view).layoutParams;
    }
    else {
        [self expandLayoutParametersArrayIfNeeded];
        return [_layoutParameters objectAtIndex:[self.subviews indexOfObject:view]];
    }
}

-(void) setLayoutParams:(DCLayoutParams*) params forView:(UIView*) view {
    
    if ([[view class] isSubclassOfClass:[DCView class]]) {
        ((DCView*)view).layoutParams = params;
    }
    else if ([[view class] isSubclassOfClass:[DCControl class]]) {
        ((DCControl*)view).layoutParams = params;
    }
    else {
        [self expandLayoutParametersArrayIfNeeded];
        [_layoutParameters setObject:params atIndexedSubscript:[self.subviews indexOfObject:view]];
    }
}

-(void) setLayoutParams:(DCLayoutParams*) params forViewAtIndex:(int) index {
    [self setLayoutParams:params forView:[self.subviews objectAtIndex:index]];
}


-(UIEdgeInsets) marginForView:(UIView*) view {

    if ([[view class] isSubclassOfClass:[DCView class]]) {
        return ((DCView*)view).margin;
    }
    else if ([[view class] isSubclassOfClass:[DCControl class]]) {
        return ((DCControl*)view).margin;
    }
    else {
        [self expandMarginArrayIfNeeded];
        return [[_margins objectAtIndex:[self.subviews indexOfObject:view]] UIEdgeInsetsValue];
    }
}

-(void) setMargin:(UIEdgeInsets) margin forView:(UIView*) view {

    if ([[view class] isSubclassOfClass:[DCView class]]) {
        ((DCView*)view).margin = margin;
    }
    else if ([[view class] isSubclassOfClass:[DCControl class]]) {
        ((DCControl*)view).margin = margin;
    }
    else {
        [self expandMarginArrayIfNeeded];
        [_margins setObject:[NSValue valueWithUIEdgeInsets:margin] atIndexedSubscript:[self.subviews indexOfObject:view]];
    }
}

-(void) setMargin:(UIEdgeInsets) margin forViewAtIndex:(int) index {
    [self setMargin:margin forView:[self.subviews objectAtIndex:index]];
}

-(void) setMarginForSubviews:(UIEdgeInsets) margin {

    for (int i = 0; i <= self.subviews.count - 1; i++) {
        [self setMargin:margin forViewAtIndex:i];
    }
}

@end
