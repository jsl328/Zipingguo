//
//  DCFrameLayout.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-16.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCFrameLayout.h"
#import "DCLayoutCore.h"

@implementation DCFrameLayout

-(id) init {
    self = [super init];
    if (self) {
        self.layoutParams = DCLayoutParamsMake(DCLayoutMatchParent, DCLayoutMatchParent);
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layoutParams = DCLayoutParamsMake(DCLayoutMatchParent, DCLayoutMatchParent);
    }
    return self;
}

-(DCLayoutParams*) newLayoutParams {
    return DCLayoutParamsMake(DCLayoutMatchParent, DCLayoutMatchParent);
}

-(void) measureWithWidthSpec:(DCMeasureSpec)widthSpec heightSpec:(DCMeasureSpec)heightSpec {

    int contentWidth = self.padding.left + self.padding.right;
    int contentHeight = self.padding.top + self.padding.bottom;
    
    for (UIView* view in self.subviews) {
        
        DCLayoutParams* params = [self layoutParamsForView:view];
    
        DCMeasureSpec viewWidthSpec = [DCLayoutCore measureSpecForSize:params.width withParentSpec:widthSpec.mode == DCMeasureSpecUnspecified ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(widthSpec.size - self.padding.left - self.padding.right)];
        DCMeasureSpec viewHeightSpec = [DCLayoutCore measureSpecForSize:params.height withParentSpec:heightSpec.mode == DCMeasureSpecUnspecified ? DCMeasureSpecMakeUnspecified() : DCMeasureSpecMakeAtMost(heightSpec.size - self.padding.top - self.padding.bottom)];
    
        [self measure:view widthSpec:viewWidthSpec heightSpec:viewHeightSpec];
        CGSize size = [self layoutSizeForView:view];
        
        if (contentWidth < size.width + self.padding.left + self.padding.right) {
            contentWidth = size.width + self.padding.left + self.padding.right;
        }
        
        if (contentHeight < size.height + self.padding.top + self.padding.bottom) {
            contentHeight = size.height + self.padding.top + self.padding.bottom;
        }
    }
    
    
    [self setMeasuredSizeWithContentWidth:contentWidth widthSpec:widthSpec contentHeight:contentHeight heightSpec:heightSpec];
}

-(void) onLayout {
    
    for (UIView* view in self.subviews) {
        
        CGSize size = [self layoutSizeForView:view];
        
        [self layout:view withRect:[DCLayoutCore rectOfRect:CGRectMake(0, 0, size.width, size.height) inSize:self.measuredSize withView:view inViewGroup:self]];
    }
}

@end
