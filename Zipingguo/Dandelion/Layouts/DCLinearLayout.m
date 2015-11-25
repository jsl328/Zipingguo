//
//  DCLinearLayout.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-4.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCLinearLayout.h"
#import "DCLayoutCore.h"

@implementation DCLinearLayout
@synthesize orientation = _orientation;

- (id)init
{
    self = [super init];
    if (self) {
        self.orientation = DCOrientationVertical;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        self.orientation = DCOrientationVertical;
    }
    return self;
}

-(void) setOrientation:(DCOrientation)orientation {
    _orientation = orientation;
    if (_orientation == DCOrientationHorizontal) {
        self.layoutParams = DCLayoutParamsMake(DCLayoutWrapContent, DCLayoutMatchParent);
    }
    else {
        self.layoutParams = DCLayoutParamsMake(DCLayoutMatchParent, DCLayoutWrapContent);
    }
}

-(void) measureWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec {
    
    if (_orientation == DCOrientationHorizontal) {
        [self measureHorizontalWithWidthSpec:widthSpec heightSpec:heightSpec];
    }
    else {
        [self measureVerticalWithWidthSpec:widthSpec heightSpec:heightSpec];
    }
}

-(void) measureHorizontalWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec {
    
    int contentWidth = self.padding.left + self.padding.right;
    int contentHeight = self.padding.top + self.padding.bottom;
    
    float remainingWidth = widthSpec.size - self.padding.left - self.padding.right;
    
    for (int i = 0; i <= self.subviews.count - 1; i++) {
        
        UIView* view = [self.subviews objectAtIndex:i];
        DCLayoutParams* params = [self layoutParamsForView:view];
        
        DCMeasureSpec subviewWidthSpec = [DCLayoutCore measureSpecForSize:params.width withParentSpec:widthSpec.mode == DCMeasureSpecUnspecified ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(remainingWidth)];
        DCMeasureSpec subviewHeightSpec = [DCLayoutCore measureSpecForSize:params.height withParentSpec:heightSpec.mode == DCMeasureSpecUnspecified ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(heightSpec.size - self.padding.top - self.padding.bottom)];
        
        [self measure:view widthSpec:subviewWidthSpec heightSpec:subviewHeightSpec];
        
        CGSize size = [self layoutSizeForView:view];
        
        
        int viewWidth = size.width + (i < self.subviews.count - 1 ? self.gap : 0);
        
        contentWidth += viewWidth;
        if (contentHeight < size.height + self.padding.top + self.padding.bottom) {
            contentHeight = size.height + self.padding.top + self.padding.bottom;
        }
        
        remainingWidth -= viewWidth;
    }
    
    [self setMeasuredSizeWithContentWidth:contentWidth widthSpec:widthSpec contentHeight:contentHeight heightSpec:heightSpec];
}

-(void) measureVerticalWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec {
    
    int contentWidth = self.padding.left + self.padding.right;
    int contentHeight = self.padding.top + self.padding.bottom;
    
    float remainingHeight = heightSpec.size - self.padding.top - self.padding.bottom;
    
    for (int i = 0; i <= self.subviews.count - 1; i++) {
     
        UIView* view = [self.subviews objectAtIndex:i];
        DCLayoutParams* params = [self layoutParamsForView:view];
        
        DCMeasureSpec subviewWidthSpec = [DCLayoutCore measureSpecForSize:params.width withParentSpec:widthSpec.mode == DCMeasureSpecUnspecified ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(widthSpec.size - self.padding.left - self.padding.right)];
        DCMeasureSpec subviewHeightSpec = [DCLayoutCore measureSpecForSize:params.height withParentSpec:heightSpec.mode == DCMeasureSpecUnspecified ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(remainingHeight)];
        
        [self measure:view widthSpec:subviewWidthSpec heightSpec:subviewHeightSpec];
        
        CGSize size = [self layoutSizeForView:view];
        int viewHeight = size.height + (i < self.subviews.count - 1 ? self.gap : 0);
        
        contentHeight += viewHeight;
        if (contentWidth < size.width + self.padding.left + self.padding.right) {
            contentWidth = size.width + self.padding.left + self.padding.right;
        }
        
        remainingHeight -= viewHeight;
    }
    
    [self setMeasuredSizeWithContentWidth:contentWidth widthSpec:widthSpec contentHeight:contentHeight heightSpec:heightSpec];
}


-(void) onLayout {
    if (_orientation == DCOrientationHorizontal) {
        [self onLayoutHoriontal];
    }
    else {
        [self onLayoutVertical];
    }
}

-(void) onLayoutHoriontal {
    
    int height = 0;
    for (UIView* view in self.subviews) {
        CGSize size = [self layoutSizeForView:view];
        if (height < size.height) {
            height = size.height;
        }
    }
    

    float left = self.padding.left;
    
    for (UIView* view in self.subviews) {
        CGSize size = [self layoutSizeForView:view];
        [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(left, self.padding.top, size.width, size.height) inSize:CGSizeMake(size.width, height) withView:view inViewGroup:self]];
        left += size.width + self.gap;
    }
}

-(void) onLayoutVertical {
    
    int width = 0;
    for (UIView* view in self.subviews) {
        CGSize size = [self layoutSizeForView:view];
        if (width < size.width) {
            width = size.width;
        }
    }
    
    float top = self.padding.top;
    for (UIView* view in self.subviews) {
        CGSize size = [self layoutSizeForView:view];
        [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(self.padding.left, top, size.width, size.height) inSize:CGSizeMake(width, size.height) withView:view inViewGroup:self]];
        top += size.height + self.gap;
    }
}

@end
