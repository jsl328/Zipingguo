//
//  DCEnumValue.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCEnumValue.h"
#import "ServiceMetadata.h"

@implementation DCEnumValue
@synthesize value = _value;
@synthesize enumTypeName = _enumTypeName;

-(id) initWithValue:(int) value memberOfEnumType:(NSString*) enumTypeName {

    self = [super init];
    if (self) {
        _value = value;
        _enumTypeName = enumTypeName;
    }
    return self;
}

-(NSString*) enumName {
    return [[ServiceMetadata enumParser] enumNameFromEnumValue:_value memberOfEnumType:_enumTypeName];
}

@end
