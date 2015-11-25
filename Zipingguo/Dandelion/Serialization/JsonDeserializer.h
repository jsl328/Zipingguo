//
//  JsonDeserializer.h
//  Nanumanga
//
//  Created by Bob Li on 13-8-30.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDateParser.h"
#import "DCEnumParser.h"

@interface JsonDeserializer : NSObject

@property (retain, nonatomic) DCDateParser* dateParser;
@property (retain, nonatomic) id <DCEnumParser> enumParser;
@property (nonatomic) NSStringEncoding encoding;

-(id) deserialize: (NSData*) data forClass: (Class) type error:(NSError**) error;

@end
