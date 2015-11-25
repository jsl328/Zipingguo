//
//  PropertyInfo.h
//  Dandelion
//
//  Created by Bob Li on 13-4-8.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataType.h"
#import "Annotation.h"

@interface PropertyInfo : NSObject

@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) DataType* type;
@property (retain, nonatomic) NSArray* annotations;

-(id) initWithPropertyName: (NSString*) propertyName andAttributes:(NSString*) attributes;

-(Annotation*) annotationOfType: (Class) annotaionType;

@end
