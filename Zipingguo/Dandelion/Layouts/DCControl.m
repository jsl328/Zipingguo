//
//  DCControl.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-7.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCControl.h"
#import "DCViewGroup.h"
#import "DCLayoutCore.h"

@implementation DCControl
@synthesize lastTimeWidthSpec;
@synthesize lastTimeHeightSpec;
@synthesize measuredSize;
@synthesize layoutParams;
@synthesize margin;

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeControl];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeControl];
    }
    return self;
}

-(void) initializeControl {
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

-(void) updateLayout {
    [DCLayoutCore updateLayoutForView:self];
}

-(void) updateLayoutWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec: (DCMeasureSpec) heightSpec {
    [DCLayoutCore updateLayoutWithWidthSpec:widthSpec heightSpec:heightSpec forView:self];
}

@end
