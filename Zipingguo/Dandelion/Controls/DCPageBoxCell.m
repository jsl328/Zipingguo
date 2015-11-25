//
//  DCPageBoxCell.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-27.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCPageBoxCell.h"

@implementation DCPageBoxCell
@synthesize view;
@synthesize dataClass;
@synthesize isInUse;
@synthesize data = _data;

-(void) claimWithData:(id)data {
    isInUse = YES;
    _data = data;
    view.hidden = NO;
    view.content = data;
}

-(void) recycle {
    isInUse = NO;
    view.hidden = YES;
    view.content = nil;
}

@end
