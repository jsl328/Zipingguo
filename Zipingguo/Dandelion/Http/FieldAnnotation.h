//
//  JsonFieldAnnotation.h
//  Nanumanga
//
//  Created by Bob Li on 13-8-30.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annotation.h"

@interface FieldAnnotation : Annotation

@property (retain, nonatomic) NSString* fieldName;
@property (retain, nonatomic) Class itemType;

-(id) initWithFieldName: (NSString*) fieldName;
-(id) initWithFieldName: (NSString*) fieldName andItemType:(Class) itemType;

@end
