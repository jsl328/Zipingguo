//
//  DCByteArray.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCByteArray : NSObject {
    int _size;
    unsigned char* _array;
}

-(id) initWithSize:(int) size;
-(id) initWithSize:(int) size andArray:(unsigned char*) array;

-(unsigned char*) a;
-(int) size;

-(void) copyFromByteArray:(DCByteArray*) array;

-(void) free;

@end
