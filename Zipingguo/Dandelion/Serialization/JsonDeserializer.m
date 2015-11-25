//
//  JsonDeserializer.m
//  Nanumanga
//
//  Created by Bob Li on 13-8-30.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "JsonDeserializer.h"
#import "DataType.h"
#import "FieldAnnotation.h"
#import "DCEnumAnnotation.h"
#import "PropertyInfo.h"
#import "ClassInfo.h"
#import "DCLocalizedStrings.h"

@implementation JsonDeserializer {

    PropertyInfo* _currentProperty;
}


@synthesize dateParser;
@synthesize enumParser;
@synthesize encoding;

-(id) deserialize: (NSData*) data forClass: (Class) type error:(NSError**) error {
    
    NSData* convertedData;
    
    if (encoding == NSUTF8StringEncoding) {
        convertedData = data;
    }
    else {
        NSString* s = [[NSString alloc] initWithData:data encoding:encoding];
        convertedData = [s dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    if (convertedData.length == 0) {
        *error = [DCLocalizedStrings errorForKey:DCStringKeyJsonStringEmpty];
        return nil;
    }
    else {
        
        int firstByte = ((char*)convertedData.bytes)[0];
        
        if (firstByte != '{' && firstByte != '[') {
            *error = [DCLocalizedStrings errorForKey:DCStringKeyJsonStringInvalid];
            return nil;
        }
    }
    
    
    id json = [NSJSONSerialization JSONObjectWithData:convertedData options:NSJSONReadingAllowFragments error:error];
    
    if (*error) {
        *error = [DCLocalizedStrings errorForKey:DCStringKeyJsonParsingError];
        return nil;
    }
    else {
        return [self parseJson:json dataType:[DataType createReferenceDataType:type]];
    }
}

-(id) parseJson: (id) json dataType:(DataType*) dataType {

    if (!json || [[json class] isSubclassOfClass:[NSNull class]]) {
        return nil;
    }
    else if ([[json class] isSubclassOfClass:[NSArray class]]) {
        return [self parseJsonArray:(NSArray*)json dataType:dataType];
    }
    else if ([[json class] isSubclassOfClass:[NSString class]] || [[json class] isSubclassOfClass:[NSNumber class]]) {
        return json;
    }
    else if (!dataType.isPrimitiveType) {
        return [self parseJsonObject:json dataType:dataType];
    }
    else if (dataType.primitiveType == PrimitiveTypeInteger) {
        
        DCEnumAnnotation* enumAnnotation = (DCEnumAnnotation*)[_currentProperty annotationOfType:[DCEnumAnnotation class]];
        
        if (enumAnnotation) {
            return [[json class] isSubclassOfClass:[NSNumber class]] ? json : [NSNumber numberWithInt:[enumParser enumValueFromEnumName:(NSString*)json memberOfEnumType:enumAnnotation.name]];
        }
        else {
            return json;
        }
    }
    else if (dataType.primitiveType == PrimitiveTypeDate) {
        return [self.dateParser dateFromString:(NSString*)json];
    }
    else {
        return json;
    }
}

-(NSArray*) parseJsonArray:(NSArray*) items dataType:(DataType*) dataType  {
    
    NSMutableArray* list = [[NSMutableArray alloc] init];
    
    for (id item in items) {
        [list addObject:[self parseJson:item dataType:dataType]];
    }
    
    return list;
}

-(id) parseJsonObject:(id) jsonObject dataType:(DataType*) dataType  {
    
    ClassInfo* classInfo = [ClassInfo infoForType:dataType.type];
    
    id item = [[dataType.type alloc] init];
    
    
    for (PropertyInfo* propertyInfo in classInfo.properties) {
        
        _currentProperty = propertyInfo;

        FieldAnnotation* fieldAnnotation = (FieldAnnotation*)[propertyInfo annotationOfType:[FieldAnnotation class]];
        
        id jsonFieldValue = [jsonObject objectForKey:fieldAnnotation ? fieldAnnotation.fieldName : propertyInfo.name];
        DataType* propertyType = [propertyInfo.type.type isSubclassOfClass:[NSArray class]] ? [DataType createReferenceDataType:fieldAnnotation.itemType] : propertyInfo.type;
        
        id parsedValue = [self parseJson:jsonFieldValue dataType:propertyType];
        
        if (parsedValue) {
            [item setValue:parsedValue forKey:propertyInfo.name];
        }
    }
    
    return item;
}

@end
