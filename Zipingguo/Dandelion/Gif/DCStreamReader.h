//
//  PRStreamReader.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-11.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCStreamReader : NSObject {
    
    NSInputStream* _stream;
}

-(id) initWithInputStream:(NSInputStream*) stream;

-(short) readShort;
-(unsigned char) readByte;
-(int) readBytes:(unsigned char*)block fromIndex:(int) index maxLength:(int) length;

-(void) close;

@end
