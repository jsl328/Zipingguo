//
//  EnumAnnotation.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-6-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annotation.h"

@interface DCEnumAnnotation : Annotation

@property (retain, nonatomic) NSString* name;

-(id) initWithName:(NSString*) name;

@end
