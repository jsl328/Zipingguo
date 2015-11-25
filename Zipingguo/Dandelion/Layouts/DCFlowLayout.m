//
//  DCFlowLayout.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-21.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCFlowLayout.h"
#import "DCLayoutCore.h"

@implementation DCFlowLayout

-(id) init {
    self = [super init];
    if (self) {
        self.layoutParams = DCLayoutParamsMake(DCLayoutMatchParent, DCLayoutWrapContent);
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layoutParams = DCLayoutParamsMake(DCLayoutMatchParent, DCLayoutWrapContent);
    }
    return self;
}

-(void) measureWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec {
    
    int contentWidth = self.padding.left + self.padding.right;
    int contentHeight = self.padding.top + self.padding.bottom;
    
    int left = self.padding.left;
    int rowHeight = 0;

    int remainingHeight = heightSpec.size - self.padding.top - self.padding.bottom;

    for (UIView* view in self.subviews) {
        
        DCLayoutParams* params = [self layoutParamsForView:view];
        
        DCMeasureSpec subviewWidthSpec = [DCLayoutCore measureSpecForSize:params.width withParentSpec:widthSpec.mode == DCMeasureSpecUnspecified ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(widthSpec.size - self.padding.left - self.padding.right)];
        DCMeasureSpec subviewHeightSpec = [DCLayoutCore measureSpecForSize:params.height withParentSpec:heightSpec.mode == DCMeasureSpecUnspecified ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(remainingHeight)];
        
        [self measure:view widthSpec:subviewWidthSpec heightSpec:subviewHeightSpec];
        
        CGSize size = [self layoutSizeForView:view];
        
        if (rowHeight < size.height) {
            rowHeight = size.height;
        }
        
        if (widthSpec.mode != DCMeasureSpecUnspecified && left + size.width + self.gap > widthSpec.size - self.padding.right) {
            left = self.padding.left;
            contentHeight += rowHeight + self.gap;
            remainingHeight -= rowHeight + self.gap;
            rowHeight = size.height;
        }

        
        left += size.width + self.gap;
        
        if (contentWidth < left) {
            contentWidth = left;
        }
    }

    
    if (rowHeight > 0) {
        contentHeight += rowHeight;
    }
    
    [self setMeasuredSizeWithContentWidth:contentWidth widthSpec:widthSpec contentHeight:contentHeight heightSpec:heightSpec];
}

-(void) onLayout {
    
    float left = self.padding.left;
    float top = self.padding.top;
    float rowHeight = 0;
    
    for (UIView* view in self.subviews) {
        
        CGSize size = [self layoutSizeForView:view];
        
        if (rowHeight < size.height) {
            rowHeight = size.height;
        }
        
        if (left + size.width + self.gap > self.measuredSize.width - self.padding.right) {
            left = self.padding.left;
            top += rowHeight + self.gap;
            rowHeight = 0;
        }
        
        [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(left, top, size.width, size.height) inSize:CGSizeMake(size.width, size.height) withView:view inViewGroup:self]];
        left += size.width + self.gap;
    }
}

@end
