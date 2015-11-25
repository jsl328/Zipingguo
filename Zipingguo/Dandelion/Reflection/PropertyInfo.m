//
//  PropertyInfo.m
//  Dandelion
//
//  Created by Bob Li on 13-4-8.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "PropertyInfo.h"
#import "NSArray+Extensions.h"

@implementation PropertyInfo
@synthesize name;
@synthesize type;
@synthesize annotations;

-(id) initWithPropertyName: (NSString*) propertyName andAttributes:(NSString *)attributes {
    self = [super init];
    if (self) {
        self.name = propertyName;
        [self setTypeFromAttributes:attributes];
    }
    return self;
}

-(void) setTypeFromAttributes:(NSString*) attributes {
    
    if ([attributes rangeOfString:@"T@"].location == 0) {
        
        NSInteger positionOfRightQuote = [[attributes substringFromIndex:3] rangeOfString:@"\""].location;
        NSString* typeName = [attributes substringWithRange:NSMakeRange(3, positionOfRightQuote)];
        
        if ([typeName isEqualToString:@"NSString"]) {
            type = [DataType createPrimitiveDataType:PrimitiveTypeString];
        }
        else if ([typeName isEqualToString:@"NSDate"]) {
            type = [DataType createPrimitiveDataType:PrimitiveTypeDate];
        }
        else {
            type = [DataType createReferenceDataType:NSClassFromString(typeName)];
        }
    }
    else if ([attributes rangeOfString:@"Tc"].location == 0) {
        type = [DataType createPrimitiveDataType:PrimitiveTypeInteger];
    }
    else if ([attributes rangeOfString:@"Ti"].location == 0) {
        type = [DataType createPrimitiveDataType:PrimitiveTypeInteger];
    }
    else if ([attributes rangeOfString:@"TB"].location == 0) {
        type = [DataType createPrimitiveDataType:PrimitiveTypeInteger];
    }
    else if ([attributes rangeOfString:@"Tl"].location == 0) {
        type = [DataType createPrimitiveDataType:PrimitiveTypeInteger];
    }
    else if ([attributes rangeOfString:@"Tq"].location == 0) {
        type = [DataType createPrimitiveDataType:PrimitiveTypeInteger];
    }
    else if ([attributes rangeOfString:@"Tf"].location == 0) {
        type = [DataType createPrimitiveDataType:PrimitiveTypeDouble];
    }
    else if ([attributes rangeOfString:@"Td"].location == 0) {
        type = [DataType createPrimitiveDataType:PrimitiveTypeDouble];
    }
}

-(Annotation*) annotationOfType: (Class) annotaionType {
    return [annotations findFirst:^BOOL(Annotation* item) {
        return [item.class isSubclassOfClass:annotaionType];
    }];
}

@end
