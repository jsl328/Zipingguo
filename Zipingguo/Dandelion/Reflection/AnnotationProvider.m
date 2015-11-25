//
//  AnnotationContainer.m
//  Nanumanga
//
//  Created by Bob Li on 13-8-30.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "AnnotationProvider.h"

@implementation AnnotationProvider {
    
    NSMutableArray* _classAnnotations;
    
    NSMutableDictionary* _propertyAnnotations;
}


-(id) init {
    self = [super init];
    if (self) {
        _classAnnotations = [[NSMutableArray alloc] init];
        _propertyAnnotations = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) annotateClassWithAnonotation: (Annotation*) annotation {
    [_classAnnotations addObject:annotation];
}

-(void) annotateProperty: (NSString*) propertyName withAnnotation: (Annotation*) annotation {
    NSMutableArray* annotations = [_propertyAnnotations objectForKey:propertyName];
    if (!annotations) {
        annotations = [[NSMutableArray alloc] init];
        [_propertyAnnotations setObject:annotations forKey:propertyName];
    }
    [annotations addObject:annotation];
}


-(NSArray*) annotationsOfClass {
    return _classAnnotations;
}

-(NSArray*) annotationsOfProperty: (NSString*) propertyName {
    return [_propertyAnnotations objectForKey:propertyName];
}


@end
