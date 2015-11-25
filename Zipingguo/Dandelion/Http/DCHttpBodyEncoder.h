//
//  DCHttpBodyEncoder.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDateParser.h"
#import "DCEnumParser.h"

@interface DCHttpBodyEncoder : NSObject

@property (retain, nonatomic) DCDateParser* dateParser;
@property (retain, nonatomic) id <DCEnumParser> enumParser;
@property (nonatomic) BOOL serializeEnumAsInteger;
@property (nonatomic) NSStringEncoding encoding;

-(NSString*) contentTypeForHttpHeader;
-(NSData*) bodyDataForObject:(id) object error:(NSError**) error;

@end
