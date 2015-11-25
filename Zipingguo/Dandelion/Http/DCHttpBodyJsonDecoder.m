//
//  DCHttpBodyJsonDecoder.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCHttpBodyJsonDecoder.h"
#import "JsonDeserializer.h"

@implementation DCHttpBodyJsonDecoder

-(id) objectFromData: (NSData*) data forClass: (Class) type error:(NSError**) error {
    
    JsonDeserializer* deserializer = [[JsonDeserializer alloc] init];
    deserializer.dateParser = self.dateParser;
    deserializer.enumParser = self.enumParser;
    deserializer.encoding = self.encoding;
    
    return [deserializer deserialize:data forClass:type error:error];
}

@end
