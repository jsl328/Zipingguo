//
//  ClassInfo.m
//  Nanumanga
//
//  Created by Bob Li on 13-8-29.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "ClassInfo.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import "PropertyInfo.h"
#import "IAnnotatable.h"
#import "AnnotationProvider.h"
#import "NSArray+Extensions.h"
#import "FieldAnnotation.h"

static NSMutableDictionary* _items;

@implementation ClassInfo
@synthesize nativeClass;
@synthesize annotations;
@synthesize properties;

+(ClassInfo*) infoForType:(Class)type {
    
    if (!_items) {
        _items = [[NSMutableDictionary alloc] init];
    }
    
    NSString* key = [type description];
    ClassInfo* classInfo = [_items objectForKey:key];
    
    if (!classInfo) {
        classInfo = [[ClassInfo alloc] init];
        [classInfo populateWithType:type];
        [_items setObject:classInfo forKey:key];
    }
    
    return classInfo;
}

-(void) populateWithType:(Class) type {
    nativeClass = type;
    [self collectMetadata];
}

-(void) collectMetadata {
    
    NSMutableArray* propertyList = [[NSMutableArray alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *objcProperties = class_copyPropertyList(nativeClass, &outCount);
    for (i = 0; i <= outCount - 1; i++) {
        PropertyInfo* property = [self createPropertyInfo:objcProperties[i]];
        if (property != nil) {
            [propertyList addObject:property];
        }
    }
    free(objcProperties);
    
    properties = propertyList;
    
    
    [self extractAnnotations];
}

-(PropertyInfo*) createPropertyInfo: (objc_property_t) property {
    
    const char *propertyNameString = property_getName(property);
    NSString * s = [NSString stringWithUTF8String:property_getAttributes(property)];
    NSArray * sub = [s componentsSeparatedByString:@","];
    if (sub.count == 0) {
        return nil;
    }
    NSString * last = [sub lastObject];
    if (![last hasPrefix:@"V"]) {
        return nil;
    }
    if(!propertyNameString) {
        return nil;
    }
    else {
        return [[PropertyInfo alloc] initWithPropertyName:[NSString stringWithUTF8String:propertyNameString] andAttributes:s];
    }
}

-(void) extractAnnotations {
    
    id metadataObj = [[nativeClass alloc] init];
    
    if (![metadataObj conformsToProtocol:@protocol(IAnnotatable)]) {
        return;
    }
    
    id <IAnnotatable> annotatable = (id <IAnnotatable>)metadataObj;
    
    AnnotationProvider* provider = [[AnnotationProvider alloc] init];
    [annotatable provideAnnotations:provider];
    
    
    annotations = [provider annotationsOfClass];
    
    for (PropertyInfo* propertyInfo in properties) {
        if ([provider annotationsOfProperty:propertyInfo.name]) {
            propertyInfo.annotations = [provider annotationsOfProperty:propertyInfo.name];
        }
        else {
            propertyInfo.annotations = [[NSArray alloc] init];
        }
    }
}

-(PropertyInfo*) propertyOfName:(NSString*) name {
    
    for (PropertyInfo* property in properties) {
        if ([property.name isEqualToString:name]) {
            return property;
        }
    }
    
    return nil;
}

@end
