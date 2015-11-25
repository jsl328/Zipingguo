//
//  DCLayoutCore.m
//  Nanumanga
//
//  Created by Bob Li on 13-10-19.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCLayoutCore.h"
#import "DCViewGroup.h"
#import "DCView.h"
#import "DCControl.h"
#import "DCContentPresenter.h"

@implementation DCLayoutCore

+(void) setMeasuredSizeWithContentWidth:(float) contentWidth widthSpec:(DCMeasureSpec) widthSpec contentHeight:(float) contentHeight heightSpec:(DCMeasureSpec) heightSpec forView:(UIView *)view {
    
    float width = [DCLayoutCore measuredWidthWithContentWidth:contentWidth measureSpec:widthSpec forView:view];
    float height = [DCLayoutCore measuredHeightWithContentHeight:contentHeight measureSpec:heightSpec forView:view];
    
    if ([view.class isSubclassOfClass:[DCView class]]) {
        ((DCView*)view).measuredSize = CGSizeMake(width, height);
    }
    else if ([view.class isSubclassOfClass:[DCControl class]]) {
        ((DCControl*)view).measuredSize = CGSizeMake(width, height);
    }
    
    if ([[view.superview class] isSubclassOfClass:[DCViewGroup class]]) {
        UIEdgeInsets margin = [((DCViewGroup*)view.superview) marginForView:view];
        [((DCViewGroup*)view.superview) setLayoutSize:CGSizeMake(width + margin.left + margin.right, height + margin.top + margin.bottom) ForView:view];
    }
    else {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, height);
    }
}

+(float) measuredWidthWithContentWidth:(float) contentWidth measureSpec: (DCMeasureSpec) spec forView:(UIView*) view {

    DCLayoutParams* params = [[view.superview class] isSubclassOfClass:[DCViewGroup class]] ? [(DCViewGroup*)view.superview layoutParamsForView:view] : [view performSelector:@selector(layoutParams)];
    float size;
    
    if (spec.mode == DCMeasureSpecExactly) {
        size = spec.size;
    }
    else if (!params) {
        size = contentWidth;
    }
    else if (params.width == DCLayoutMatchParent) {
        if (spec.mode == DCMeasureSpecUnspecified) {
            size = contentWidth;
        }
        else {
            size = spec.size;
        }
    }
    else if (params.width == DCLayoutWrapContent) {
        size = contentWidth;
    }
    else {
        size = params.width;
    }
    
    return size;
}

+(float) measuredHeightWithContentHeight:(float) contentHeight measureSpec: (DCMeasureSpec) spec forView:(UIView*) view {
    
    DCLayoutParams* params = [[view.superview class] isSubclassOfClass:[DCViewGroup class]] ? [(DCViewGroup*)view.superview layoutParamsForView:view] : [view performSelector:@selector(layoutParams)];
    float size;
    
    if (spec.mode == DCMeasureSpecExactly) {
        size = spec.size;
    }
    else if (!params) {
        size = contentHeight;
    }
    else if (params.height == DCLayoutMatchParent) {
        if (spec.mode == DCMeasureSpecUnspecified) {
            size = contentHeight;
        }
        else {
            size = spec.size;
        }
    }
    else if (params.height == DCLayoutWrapContent) {
        size = contentHeight;
    }
    else {
        size = params.height;
    }
    
    return size;
}

+(void) updateLayoutForView: (UIView*) view {
    
    DCMeasureSpec widthSpec;
    DCMeasureSpec heightSpec;
    
    BOOL isTop = ![[view.superview class] isSubclassOfClass:[DCView class]] && ![[view.superview class] isSubclassOfClass:[DCControl class]];
    BOOL isInsideScrollView = isTop && [[view.superview class] isSubclassOfClass:[UIScrollView class]];
    
    if (isTop) {
        
        DCLayoutParams* params;
        
        if ([[view class] isSubclassOfClass:[DCView class]]) {
            params = ((DCView*)view).layoutParams;
        }
        else {
            params = ((DCControl*)view).layoutParams;
        }
        
        
        if (params.width >= 0) {
            widthSpec = DCMeasureSpecMakeExactly(view.frame.size.width);
        }
        else if (params.width == DCLayoutMatchParent) {
            widthSpec = DCMeasureSpecMakeExactly(view.superview.frame.size.width);
        }
        else {
            widthSpec = isInsideScrollView ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(view.superview.frame.size.width);
        }
        
        if (params.height >= 0) {
            heightSpec = DCMeasureSpecMakeExactly(view.frame.size.height);
        }
        else if (params.height == DCLayoutMatchParent) {
            heightSpec = DCMeasureSpecMakeExactly(view.superview.frame.size.height);
        }
        else {
            heightSpec = isInsideScrollView ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(view.superview.frame.size.height);
        }
    }
    else {
        if ([view.class isSubclassOfClass:[DCView class]]) {
            widthSpec = ((DCView*)view).lastTimeWidthSpec;
            heightSpec = ((DCView*)view).lastTimeHeightSpec;
        }
        else {
            widthSpec = ((DCControl*)view).lastTimeWidthSpec;
            heightSpec = ((DCControl*)view).lastTimeHeightSpec;
        }
    }
    
    [DCLayoutCore updateLayoutWithWidthSpec:widthSpec heightSpec:heightSpec forView:view];
    
    if (isInsideScrollView) {
        UIScrollView* scrollView = (UIScrollView*)view.superview;
        scrollView.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height);
    }
}

+(void) updateLayoutWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec: (DCMeasureSpec) heightSpec forView:(UIView*) view {
    if ([view.class isSubclassOfClass:[DCView class]]) {
        [(DCView*)view measureWithWidthSpec:widthSpec heightSpec:heightSpec];
        [(DCView*)view onLayout];
    }
    else {
        [(DCControl*)view measureWithWidthSpec:widthSpec heightSpec:heightSpec];
        [(DCControl*)view onLayout];
    }
}


+(DCMeasureSpec) measureSpecForSize:(float) size withParentSpec:(DCMeasureSpec) spec {
    
    int subviewMode;
    float subviewSize;
    
    if (spec.mode == DCMeasureSpecUnspecified) {
        if (size == DCLayoutWrapContent) {
            subviewMode = DCMeasureSpecUnspecified;
            subviewSize = 0;
        }
        else if (size == DCLayoutMatchParent) {
            subviewMode = DCMeasureSpecUnspecified;
            subviewSize = 0;
        }
        else {
            subviewMode = DCMeasureSpecExactly;
            subviewSize = size;
        }
    }
    else if (spec.mode == DCMeasureSpecAtMost) {
        if (size == DCLayoutWrapContent) {
            subviewMode = DCMeasureSpecAtMost;
            subviewSize = spec.size;
        }
        else if (size == DCLayoutMatchParent) {
            subviewMode = DCMeasureSpecAtMost;
            subviewSize = spec.size;
        }
        else {
            subviewMode = DCMeasureSpecExactly;
            subviewSize = size;
        }
    }
    else {
        if (size == DCLayoutWrapContent) {
            subviewMode = DCMeasureSpecAtMost;
            subviewSize = spec.size;
        }
        else if (size == DCLayoutMatchParent) {
            subviewMode = DCMeasureSpecExactly;
            subviewSize = spec.size;
        }
        else {
            subviewMode = DCMeasureSpecExactly;
            subviewSize = size;
        }
    }
    
    return DCMeasureSpecMake(subviewMode, subviewSize);
}


+(void) measure:(UIView*) view widthSpec:(DCMeasureSpec)widthSpec heightSpec:(DCMeasureSpec)heightSpec {
    
    if ([view.class isSubclassOfClass:[DCView class]]) {
        
        DCView* element = (DCView*)view;
        
        element.lastTimeWidthSpec = widthSpec;
        element.lastTimeHeightSpec = heightSpec;
        
        [element measureWithWidthSpec:widthSpec heightSpec:heightSpec];
    }
    else if ([view.class isSubclassOfClass:[DCControl class]]) {
        
        DCControl* element = (DCControl*)view;
        
        element.lastTimeWidthSpec = widthSpec;
        element.lastTimeHeightSpec = heightSpec;
        
        [element measureWithWidthSpec:widthSpec heightSpec:heightSpec];
    }
    else {
        [DCLayoutCore setMeasuredSizeWithContentWidth:view.intrinsicContentSize.width widthSpec:widthSpec contentHeight:view.intrinsicContentSize.height heightSpec:heightSpec forView:view];
    }
}

+(CGRect) rectOfRect:(CGRect)rect inSize:(CGSize)parentSize withView:(UIView*) view inViewGroup:(DCViewGroup*) viewGroup {
    
    DCLayoutParams* params = [viewGroup layoutParamsForView:view];
    
    UIEdgeInsets margin = [viewGroup marginForView:view];
    rect = CGRectMake(rect.origin.x + margin.left, rect.origin.y + margin.top, rect.size.width - margin.left - margin.right, rect.size.height - margin.top - margin.bottom);
    parentSize = CGSizeMake(parentSize.width - margin.left - margin.right, parentSize.height - margin.top - margin.bottom);
    
    int left;
    if (params.horizontalGravity == DCHorizontalGravityLeft) {
        left = 0;
    }
    else if (params.horizontalGravity == DCHorizontalGravityCenter) {
        left = (parentSize.width - rect.size.width) / 2;
    }
    else {
        left = parentSize.width - rect.size.width;
    }
    
    int top;
    if (params.verticalGravity == DCVerticalGravityTop) {
        top = 0;
    }
    else if (params.verticalGravity == DCVerticalGravityCenter) {
        top = (parentSize.height - rect.size.height) / 2;
    }
    else {
        top = parentSize.height - rect.size.height;
    }
    
    return CGRectMake(rect.origin.x + left, rect.origin.y + top, rect.size.width, rect.size.height);
}

@end
