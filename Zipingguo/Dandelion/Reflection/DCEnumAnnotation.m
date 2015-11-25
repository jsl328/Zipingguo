//
//  DCEnumAnnotation.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-6-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCEnumAnnotation.h"

@implementation DCEnumAnnotation
@synthesize name = _name;

-(id) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

@end
