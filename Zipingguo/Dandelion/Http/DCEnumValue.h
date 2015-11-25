//
//  DCEnumValue.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCEnumValue : NSObject

@property (nonatomic) int value;
@property (retain, nonatomic) NSString* enumTypeName;

-(id) initWithValue:(int) value memberOfEnumType:(NSString*) enumTypeName;

-(NSString*) enumName;

@end
