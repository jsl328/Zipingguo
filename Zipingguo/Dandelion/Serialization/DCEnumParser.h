//
//  DCEnjmParser.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-6-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCEnumParser <NSObject>

-(int) enumValueFromEnumName:(NSString*) enumName memberOfEnumType:(NSString*) enumTypeName;

-(NSString*) enumNameFromEnumValue:(int) enumValue memberOfEnumType:(NSString*) enumTypeName;

@end
