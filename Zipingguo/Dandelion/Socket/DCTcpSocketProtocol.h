//
//  DCTcpSocketProtocol.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-25.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCSocketProtocol.h"

@interface DCTcpSocketProtocol : DCSocketProtocol <NSStreamDelegate> {

    NSInputStream* _inputStream;
    NSOutputStream* _outputStream;
}

@property (retain, nonatomic) NSString* host;
@property (nonatomic) int port;

-(id) initWithHost:(NSString *)host port:(int)port;

@end
