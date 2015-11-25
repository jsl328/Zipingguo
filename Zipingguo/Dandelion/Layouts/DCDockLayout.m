//
//  DCDockLayout.m
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDockLayout.h"
#import "DCLayoutCore.h"

@implementation DCDockLayout
@synthesize orientation;
@synthesize centerViewIndex;

-(DCLayoutParams*) newLayoutParams {
    
    DCLayoutParams* params;
    
    if (orientation == DCOrientationHorizontal) {
        params = DCLayoutParamsMake(DCLayoutWrapContent, DCLayoutMatchParent);
    }
    else {
        params = DCLayoutParamsMake(DCLayoutMatchParent, DCLayoutWrapContent);
    }
    
    return params;
}

-(void) measureWithWidthSpec:(DCMeasureSpec)widthSpec heightSpec:(DCMeasureSpec)heightSpec {
    
    if (orientation == DCOrientationHorizontal) {
        [self measureHorizontalWithWidthSpec:widthSpec heightSpec:heightSpec];
    }
    else {
        [self measureVerticalWithWidthSpec:widthSpec heightSpec:heightSpec];
    }
}

-(void) measureHorizontalWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec {
    
    float remainingWidth = widthSpec.size - self.padding.left - self.padding.right;
    int dockViewCount = 0;
    
    
    for (int i = 0; i <= self.subviews.count - 1; i++) {
        
        if (i == centerViewIndex) {
            continue;
        }
        
        
        UIView* view = [self.subviews objectAtIndex:i];
        DCLayoutParams* params = [self layoutParamsForView:view];
        
        DCMeasureSpec subviewWidthSpec = [DCLayoutCore measureSpecForSize:params.width withParentSpec:DCMeasureSpecMakeAtMost(remainingWidth)];
        DCMeasureSpec subviewHeightSpec = [DCLayoutCore measureSpecForSize:params.height withParentSpec:DCMeasureSpecMakeAtMost(heightSpec.size - self.padding.top - self.padding.bottom)];
        
        [self measure:view widthSpec:subviewWidthSpec heightSpec:subviewHeightSpec];
        
        CGSize size = [self layoutSizeForView:view];
        
        remainingWidth -= size.width + self.gap;
        dockViewCount++;
    }
    
    
    remainingWidth -= (self.subviews.count - dockViewCount - 1) * self.gap;
    

    UIView* view = [self.subviews objectAtIndex:centerViewIndex];
    DCLayoutParams* params = [self layoutParamsForView:view];
    
    DCMeasureSpec subviewWidthSpec = [DCLayoutCore measureSpecForSize:params.width withParentSpec:DCMeasureSpecMakeAtMost(remainingWidth * params.weight)];
    DCMeasureSpec subviewHeightSpec = [DCLayoutCore measureSpecForSize:params.height withParentSpec:DCMeasureSpecMakeAtMost(heightSpec.size - self.padding.top - self.padding.bottom)];
    
    [self measure:view widthSpec:subviewWidthSpec heightSpec:subviewHeightSpec];
    
    CGSize size = [self layoutSizeForView:view];
    
    remainingWidth -= size.width + self.gap;
    dockViewCount++;

    
    [self setMeasuredSizeWithContentWidth:widthSpec.size widthSpec:widthSpec contentHeight:heightSpec.size heightSpec:heightSpec];
}

-(void) measureVerticalWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec {
    
    float remainingHeight = heightSpec.size - self.padding.top - self.padding.bottom;
    int dockViewCount = 0;
    
    for (int i = 0; i <= self.subviews.count - 1; i++) {
        
        if (i == centerViewIndex) {
            continue;
        }
        
        
        UIView* view = [self.subviews objectAtIndex:i];
        DCLayoutParams* params = [self layoutParamsForView:view];

        DCMeasureSpec subviewWidthSpec = [DCLayoutCore measureSpecForSize:params.width withParentSpec:DCMeasureSpecMakeAtMost(widthSpec.size - self.padding.left - self.padding.right)];
        DCMeasureSpec subviewHeightSpec = [DCLayoutCore measureSpecForSize:params.height withParentSpec:DCMeasureSpecMakeAtMost(remainingHeight)];
        
        [self measure:view widthSpec:subviewWidthSpec heightSpec:subviewHeightSpec];
        
        CGSize size = [self layoutSizeForView:view];
        
        remainingHeight -= size.height + self.gap;
        dockViewCount++;
    }
    
    
    remainingHeight -= (self.subviews.count - dockViewCount - 1) * self.gap;
    
        
    UIView* view = [self.subviews objectAtIndex:centerViewIndex];
    DCLayoutParams* params = [self layoutParamsForView:view];
    
    
    DCMeasureSpec subviewWidthSpec = [DCLayoutCore measureSpecForSize:params.width withParentSpec:DCMeasureSpecMakeAtMost(widthSpec.size - self.padding.left - self.padding.right)];
    DCMeasureSpec subviewHeightSpec = [DCLayoutCore measureSpecForSize:params.height withParentSpec:DCMeasureSpecMakeAtMost(remainingHeight * params.weight)];
    
    [self measure:view widthSpec:subviewWidthSpec heightSpec:subviewHeightSpec];
    
    CGSize size = [self layoutSizeForView:view];
    
    remainingHeight -= size.height + self.gap;

    
    [self setMeasuredSizeWithContentWidth:widthSpec.size widthSpec:widthSpec contentHeight:heightSpec.size heightSpec:heightSpec];
}


-(void) onLayout {
    if (orientation == DCOrientationHorizontal) {
        [self onLayoutHorizontal];
    }
    else {
        [self onLayoutVertical];
    }
}

-(void) onLayoutHorizontal {
    
    float left = self.padding.left;
    float right = self.measuredSize.width - self.padding.right;
    float height = self.measuredSize.height - self.padding.top - self.padding.bottom;

    if (centerViewIndex > 0) {
        for (int i = 0; i <= centerViewIndex - 1; i++) {
            
            UIView* view = [self.subviews objectAtIndex:i];
            CGSize size = [self layoutSizeForView:view];
            
            [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(left, self.padding.top, size.width, size.height) inSize:CGSizeMake(size.width, height) withView:view inViewGroup:self]];
            left += size.width + self.gap;
        }
    }
    
    if (centerViewIndex < self.subviews.count - 1) {
        for (int i = self.subviews.count - 1; i >= centerViewIndex + 1; i--) {
            
            UIView* view = [self.subviews objectAtIndex:i];
            CGSize size = [self layoutSizeForView:view];
            
            [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(right - size.width, self.padding.top, size.width, size.height) inSize:CGSizeMake(size.width, height) withView:view inViewGroup:self]];
            right -= size.width + self.gap;
        }
    }
    
    
    UIView* view = [self.subviews objectAtIndex:centerViewIndex];
    CGSize size = [self layoutSizeForView:view];
    
    [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(left, self.padding.top, size.width, size.height) inSize:CGSizeMake(size.width, height) withView:view inViewGroup:self]];
    left += size.width + self.gap;
}

-(void) onLayoutVertical {
    
    float top = self.padding.top;
    float bottom = self.measuredSize.height - self.padding.bottom;
    float width = self.measuredSize.width - self.padding.left - self.padding.right;
    
    if (centerViewIndex > 0) {
        for (int i = 0; i <= centerViewIndex - 1; i++) {
            
            UIView* view = [self.subviews objectAtIndex:i];
            CGSize size = [self layoutSizeForView:view];

            [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(self.padding.left, top, size.width, size.height) inSize:CGSizeMake(width, size.height) withView:view inViewGroup:self]];
            top += size.height + self.gap;
        }
    }
    
    if (centerViewIndex < self.subviews.count - 1) {
        for (int i = self.subviews.count - 1; i >= centerViewIndex + 1; i--) {
            
            UIView* view = [self.subviews objectAtIndex:i];
            CGSize size = [self layoutSizeForView:view];
            
            [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(self.padding.left, bottom - size.height, size.width, size.height) inSize:CGSizeMake(width, size.height) withView:view inViewGroup:self]];
            bottom -= size.height + self.gap;
        }
    }
    

    UIView* view = [self.subviews objectAtIndex:centerViewIndex];
    CGSize size = [self layoutSizeForView:view];
    
    [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(self.padding.left, top, size.width, size.height) inSize:CGSizeMake(width, size.height) withView:view inViewGroup:self]];
    top += size.height + self.gap;
}

@end
