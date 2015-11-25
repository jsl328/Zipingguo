//
//  JsonSerializer.m
//  Nanumanga
//
//  Created by Bob Li on 13-8-30.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "JsonSerializer.h"
#import "PropertyInfo.h"
#import "ClassInfo.h"
#import "FieldAnnotation.h"
#import "DCEnumAnnotation.h"
#import "DCNullable.h"

@implementation JsonSerializer {

    PropertyInfo* _currentProperty;
}

@synthesize dateParser;
@synthesize enumParser;
@synthesize serializeEnumAsInteger;
@synthesize encoding;

-(NSData*) serialize: (id) object error:(NSError**) error {
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:[self serializeValue:object] options:0 error:error];
    
    if (encoding == NSUTF8StringEncoding) {
        return data;
    }
    
    
    NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [s dataUsingEncoding:encoding];
}


-(id) serializeValue:(id) value {
    
    if (!value) {
        return nil;
    }
    else if ([[value class] isSubclassOfClass:[NSNumber class]]) {

        DCEnumAnnotation* enumAnnotation = (DCEnumAnnotation*)[_currentProperty annotationOfType:[DCEnumAnnotation class]];
        
        if (enumAnnotation) {
            return serializeEnumAsInteger ? value : [enumParser enumNameFromEnumValue:[value intValue] memberOfEnumType:enumAnnotation.name];
        }
        else {
            return value;
        }
    }
    else if ([[value class] isSubclassOfClass:[NSString class]]) {
        return value;
    }
    else if ([[value class] isSubclassOfClass:[NSDate class]]) {
        return [self.dateParser stringFromDate:(NSDate*)value];
    }
    else if ([[value class] isSubclassOfClass:[DCInteger class]]) {
        return [NSNumber numberWithInt:((DCInteger*)value).value];
    }
    else if ([[value class] isSubclassOfClass:[DCBoolean class]]) {
        return [NSNumber numberWithBool:((DCBoolean*)value).value];
    }
    else if ([[value class] isSubclassOfClass:[NSArray class]]) {
        return [self serializeArray:(NSArray*)value];
    }
    else if ([[value class] isSubclassOfClass:[NSDictionary class]]) {
        return [self serializeDictionary:(NSDictionary*)value];
    }
    else {
        return [self serializeObject:value];
    }
}

-(NSArray*) serializeArray:(NSArray*) array {
    NSMutableArray* jsonArray = [[NSMutableArray alloc] init];
    for (id item in array) {
        [jsonArray addObject:[self serializeValue:item]];
    }
    return jsonArray;
}

-(NSMutableDictionary*) serializeDictionary:(NSDictionary*) dictionary {
    NSMutableDictionary* jsonDictionary = [[NSMutableDictionary alloc] init];
    for (NSString* key in [dictionary keyEnumerator]) {
        [jsonDictionary setObject:[self serializeValue:[dictionary objectForKey:key]] forKey:key];
    }
    return jsonDictionary;
}

-(id) serializeObject:(id) object {
    
    ClassInfo* class = [ClassInfo infoForType:[object class]];

    NSMutableDictionary* json = [[NSMutableDictionary alloc] init];
    
    
    for (PropertyInfo* propertyInfo in class.properties) {
        
        _currentProperty = propertyInfo;
        
        NSObject* value = [object valueForKey:propertyInfo.name];
        
        
        FieldAnnotation* fieldAnnotation = (FieldAnnotation*)[propertyInfo annotationOfType:[FieldAnnotation class]];
        NSString* fieldName = fieldAnnotation ? fieldAnnotation.fieldName : propertyInfo.name;
        
        if (value) {
            [json setObject:[self serializeValue:value] forKey:fieldName];
        }
    }
    
    return json;
}

@end
