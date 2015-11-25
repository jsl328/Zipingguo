//
//  DCHttpBodyJsonEncoder.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCHttpBodyJsonEncoder.h"
#import "JsonSerializer.h"

@implementation DCHttpBodyJsonEncoder

-(NSString*) contentTypeForHttpHeader {
    return @"application/json";
}

-(NSData*) bodyDataForObject:(id) object error:(NSError**) error {
    
    JsonSerializer* jsonSerializer = [[JsonSerializer alloc] init];
    jsonSerializer.dateParser = self.dateParser;
    jsonSerializer.enumParser = self.enumParser;
    jsonSerializer.serializeEnumAsInteger = self.serializeEnumAsInteger;
    jsonSerializer.encoding = self.encoding;
    
    return [jsonSerializer serialize:object error:error];
}

@end
