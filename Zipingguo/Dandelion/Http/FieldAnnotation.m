//
//  JsonFieldAnnotation.m
//  Nanumanga
//
//  Created by Bob Li on 13-8-30.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "FieldAnnotation.h"

@implementation FieldAnnotation
@synthesize fieldName = _fieldName;
@synthesize itemType = _itemType;

-(id) initWithFieldName: (NSString*) fieldName {
    self = [super init];
    if (self) {
        self.fieldName = fieldName;
    }
    return self;
}

-(id) initWithFieldName: (NSString*) fieldName andItemType:(Class) itemType {
    self = [super init];
    if (self) {
        self.fieldName = fieldName;
        self.itemType = itemType;
    }
    return self;
}

@end
