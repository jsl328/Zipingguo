//
//  DCHttpBodyDecoder.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCHttpBodyDecoder.h"

@implementation DCHttpBodyDecoder
@synthesize dateParser;
@synthesize enumParser;
@synthesize encoding;

-(id) objectFromData: (NSData*) data forClass: (Class) type error:(NSError**) error {
    return nil;
}

@end
