//
//  PRStreamReader.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-11.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCStreamReader.h"

@implementation DCStreamReader

-(id) initWithInputStream:(NSInputStream*) stream {
    self = [super init];
    if (self) {
        _stream = stream;
        [_stream open];
    }
    return self;
}

/**
 * Reads next 16-bit value, LSB first
 */
-(short) readShort {
    // read 16-bit value, LSB first
    return [self readByte] | ([self readByte] << 8);
}

-(unsigned char) readByte {
    unsigned char buffer[1];
    [_stream read:buffer maxLength:1];
    return buffer[0];
}

-(int) readBytes:(unsigned char*)block fromIndex:(int) index maxLength:(int) length {
    return [_stream read:block + index maxLength:length];
}

-(void) close {
    [_stream close];
}

@end
