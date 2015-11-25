//
//  DCTcpSocketProtocol.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-25.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCTcpSocketProtocol.h"

@implementation DCTcpSocketProtocol
@synthesize host = _host;
@synthesize port = _port;


-(id) initWithHost:(NSString *)host port:(int)port {
    self = [super init];
    if (self) {
        _host = host;
        _port = port;
        [self initialize];
    }
    return self;
}

-(void) initialize {
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)_host, _port, &readStream, &writeStream);
    
    _inputStream = (__bridge NSInputStream *)readStream;
    _outputStream = (__bridge NSOutputStream *)writeStream;
}

-(void) connect {
    
    _inputStream.delegate = self;
    _outputStream.delegate = self;
    
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [_inputStream open];
    [_outputStream open];
}


-(void) disconnect {
    
    [_inputStream close];
    [_outputStream close];
    
    _inputStream.delegate = nil;
    _outputStream.delegate = nil;
}


-(void) sendData:(NSData*) data {
    [_outputStream write:data.bytes maxLength:data.length];
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
	switch (eventCode) {
            
		case NSStreamEventOpenCompleted:
            if (aStream == _inputStream) {
                self.socket.state |= DCSocketStateConnected;
                [self onConnect];
            }
			break;
            
		case NSStreamEventHasBytesAvailable:
            [self onReceiveData:[self dataFromReadStream]];
			break;
            
        case NSStreamEventHasSpaceAvailable:
            if (aStream == _outputStream) {
                if (self.socket.state == DCSocketStateConnected) {
                    [self onSendData];
                }
            }
            break;
            
		case NSStreamEventErrorOccurred:
            if (aStream == _inputStream) {
                [self onFailToConnect];
            }
			break;
            
		case NSStreamEventEndEncountered:
            [self onDisconnect];
			break;
            
		default:
            break;
	}
}

-(NSData*) dataFromReadStream {
    
    uint8_t buffer[1024];
    
    NSMutableData* data = [[NSMutableData alloc] initWithLength:0];
    
    while (true) {
        
        int length = [_inputStream read:buffer maxLength:1024];
        
        if (length > 0) {
            [data appendBytes: (const void *)buffer length:length];
        }
        
        if (length < 1024) {
            break;
        }
    }

    return data;
}


@end
