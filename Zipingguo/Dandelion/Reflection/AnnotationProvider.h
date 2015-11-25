//
//  AnnotationContainer.h
//  Nanumanga
//
//  Created by Bob Li on 13-8-30.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Annotation.h"

@interface AnnotationProvider : NSObject


-(void) annotateClassWithAnonotation: (Annotation*) annotation;

-(void) annotateProperty: (NSString*) propertyName withAnnotation: (Annotation*) annotation;



-(NSArray*) annotationsOfClass;

-(NSArray*) annotationsOfProperty: (NSString*) propertyName;

@end
