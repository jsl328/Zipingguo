//
//  DCNullable.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-12-2.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCNullable.h"

@implementation DCInteger

+(DCInteger*) integerFromInt:(int) value {
    DCInteger* instance = [[DCInteger alloc] init];
    instance.value = value;
    return instance;
}

@end


@implementation DCBoolean

+(DCBoolean*) booleanFromBool:(BOOL) value {
    DCBoolean* instance = [[DCBoolean alloc] init];
    instance.value = value;
    return instance;
}

@end
