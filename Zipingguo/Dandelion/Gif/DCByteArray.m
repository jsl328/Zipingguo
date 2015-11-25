//
//  DCByteArray.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCByteArray.h"

@implementation DCByteArray

-(id) initWithSize:(int) size {
    self = [super init];
    if (self) {
        _size = size;
        _array = malloc(sizeof(unsigned char) * size);
        memset(_array, 0, sizeof(unsigned char) * size);
    }
    return self;
}

-(id) initWithSize:(int) size andArray:(unsigned char*) array {
    self = [super init];
    if (self) {
        _size = size;
        _array = array;
    }
    return self;
}

-(unsigned char*) a {
    return _array;
}

-(int) size {
    return _size;
}

-(void) copyFromByteArray:(DCByteArray*) array {
    memcpy(_array, array.a, sizeof(unsigned char) * _size);
}

-(void) free {
    _size = 0;
    if (_array) {
        free(_array);
        _array = nil;
    }
}

@end
