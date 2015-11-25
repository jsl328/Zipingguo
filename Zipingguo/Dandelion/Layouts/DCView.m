//
//  DCFrameworkElement.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-7.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCView.h"
#import "DCViewGroup.h"
#import "DCLayoutCore.h"

@implementation DCView
@synthesize lastTimeWidthSpec;
@synthesize lastTimeHeightSpec;
@synthesize measuredSize;
@synthesize layoutParams;
@synthesize margin;


-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeView];
    }
    return self;
}

-(void) initializeView {
    layoutParams = DCLayoutParamsMake(DCLayoutWrapContent, DCLayoutWrapContent);
}


-(void) measureWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec {
}

-(void) onLayout {
}


-(void) measure:(UIView*) view widthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec {
    [DCLayoutCore measure:view widthSpec:widthSpec heightSpec:heightSpec];
}

-(void) setMeasuredSizeWithContentWidth:(float) contentWidth widthSpec:(DCMeasureSpec) widthSpec contentHeight:(float) contentHeight heightSpec:(DCMeasureSpec) heightSpec {
    [DCLayoutCore setMeasuredSizeWithContentWidth:contentWidth widthSpec:widthSpec contentHeight:contentHeight heightSpec:heightSpec forView:self];
}

-(void) layoutAtPoint:(CGPoint) point {
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    [DCLayoutCore updateLayoutForView:self];
}

-(void) layoutAtPoint:(CGPoint) point withWidthSpec:(DCMeasureSpec) widthSpec heightSpec: (DCMeasureSpec) heightSpec {
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
    [DCLayoutCore updateLayoutWithWidthSpec:widthSpec heightSpec:heightSpec forView:self];
}

@end
