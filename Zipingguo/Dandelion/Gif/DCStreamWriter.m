//
//  PRStreamWriter.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-6.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCStreamWriter.h"

@implementation DCStreamWriter

-(id) initWithOutputStream:(NSOutputStream*) stream {
    self = [super init];
    if (self) {
        _stream = stream;
        [_stream open];
    }
    return self;
}

/**
 * Write 16-bit value to output stream, LSB first
 */
-(void) writeShort:(short) value {
    [self writeByte:value & 0xff];
    [self writeByte:(value >> 8) & 0xff];
}

-(void) writeByte:(unsigned char) byte {
    uint8_t buffer[1];
    buffer[0] = byte;
    [_stream write:(const uint8_t*)buffer maxLength:1];
}

-(void) writeString:(NSString*) s {
    int length = [s lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char* buffer = [s UTF8String];
    [_stream write:(unsigned char*)buffer maxLength:length];
}

-(void) writeByteArray:(unsigned char*) array length:(int) length {
    [_stream write:array maxLength:length];
}

-(void) flush {
}

-(void) close {
    [_stream close];
}

@end
