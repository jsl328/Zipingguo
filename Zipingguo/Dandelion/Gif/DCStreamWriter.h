//
//  PRStreamWriter.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-6.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCStreamWriter : NSObject {

    NSOutputStream* _stream;
}

-(id) initWithOutputStream:(NSOutputStream*) stream;

-(void) writeShort:(short) value;
-(void) writeByte:(unsigned char) value;
-(void) writeString:(NSString*) s;
-(void) writeByteArray:(unsigned char*) array length:(int) length;

-(void) flush;

-(void) close;

@end
