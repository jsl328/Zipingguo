//
//  DCIntArray.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCIntArray.h"

@implementation DCIntArray

-(id) initWithSize:(int) size {
    self = [super init];
    if (self) {
        _size = size;
        _array = malloc(sizeof(int) * size);
        memset(_array, 0, sizeof(int) * size);
    }
    return self;
}

-(int*) a {
    return _array;
}

-(int) size {
    return _size;
}

-(void) copyFromIntArray:(DCIntArray*) array {
    memcpy(_array, array.a, sizeof(int) * _size);
}

-(void) free {
    _size = 0;
    if (_array) {
        free(_array);
        _array = nil;
    }
}

@end
