//
//  ActionTask.m
//  Mulberry
//
//  Created by Bob Li on 13-7-9.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCActionTask.h"

@implementation DCActionTask
@synthesize action;

-(void) execute {
    
    ((void (^)(void))action)();
    action = nil;
}

@end
