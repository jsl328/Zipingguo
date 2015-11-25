//
//  JsonSerializer.h
//  Nanumanga
//
//  Created by Bob Li on 13-8-30.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDateParser.h"
#import "DCEnumParser.h"

@interface JsonSerializer : NSObject

@property (retain, nonatomic) DCDateParser* dateParser;
@property (retain, nonatomic) id <DCEnumParser> enumParser;
@property (nonatomic) BOOL serializeEnumAsInteger;
@property (nonatomic) NSStringEncoding encoding;

-(NSData*) serialize: (id) object error:(NSError**) error;

@end
