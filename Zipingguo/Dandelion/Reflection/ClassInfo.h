//
//  ClassInfo.h
//  Nanumanga
//
//  Created by Bob Li on 13-8-29.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PropertyInfo.h"

@interface ClassInfo : NSObject

@property (retain, nonatomic) Class nativeClass;
@property (retain, nonatomic) NSArray* annotations;
@property (retain, nonatomic) NSArray* properties;

+(ClassInfo*) infoForType:(Class) type;

-(PropertyInfo*) propertyOfName:(NSString*) name;

@end
