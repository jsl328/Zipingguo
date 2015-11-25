//
//  DCAssertFunctions.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-18.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCAssertFunctions.h"

void DCAssertBetween(int value, int from, int to) {
    
    if (value < from || value > to) {
        @throw DCAssertExceptionMake([NSString stringWithFormat:@"value should be between %d and %d, actually %d", from, to, value]);
    }
}

