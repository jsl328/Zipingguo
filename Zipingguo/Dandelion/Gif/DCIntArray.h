//
//  DCIntArray.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCIntArray : NSObject {
    int _size;
    int* _array;
}

-(id) initWithSize:(int) size;

-(int*) a;
-(int) size;

-(void) copyFromIntArray:(DCIntArray*) array;

-(void) free;

@end
