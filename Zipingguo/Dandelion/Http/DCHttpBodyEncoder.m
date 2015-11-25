//
//  DCHttpBodyEncoder.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCHttpBodyEncoder.h"

@implementation DCHttpBodyEncoder
@synthesize dateParser;
@synthesize enumParser;
@synthesize serializeEnumAsInteger;
@synthesize encoding;

-(NSString*) contentTypeForHttpHeader {
    return nil;
}

-(NSData*) bodyDataForObject:(id) object error:(NSError**) error {
    return nil;
}

@end
