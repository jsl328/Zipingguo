//
//  DCGrisBoxSection.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCItemsBoxSection.h"

@implementation DCItemsBoxSection
@synthesize isItemsHidden;
@synthesize hasHeader;
@synthesize headerAttributes;
@synthesize headerLayoutPosition;
@synthesize headerRenderPosition;
@synthesize headerLength;
@synthesize hasFooter;
@synthesize footerAttributes;
@synthesize footerLayoutPosition;
@synthesize footerRenderPosition;
@synthesize footerLength;
@synthesize maxCellLength;
@synthesize items;
@synthesize contentRenderTop;
@synthesize contentLength;

-(void) reset {
    hasHeader = NO;
    headerAttributes= nil;
    headerLayoutPosition = 0;
    headerRenderPosition = 0;
    headerLength = 0;
    hasFooter = 0;
    footerAttributes = 0;
    footerLayoutPosition = 0;
    footerRenderPosition = 0;
    footerLength = 0;
    maxCellLength = 0;
    items = nil;
    contentRenderTop = 0;
    contentLength = 0;
}

@end
