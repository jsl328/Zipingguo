//
//  DCSocketProtocol.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-25.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCSocketProtocol.h"
#import "DCActionTask.h"

@implementation DCSocketProtocol
@synthesize socket;

- (id)init
{
    self = [super init];
    if (self) {
        _taskPool = [DCTaskPool createSerial];
    }
    return self;
}


-(void) connect {
}

-(void) disconnect {
}

-(void) sendData:(NSData *)data {
}


-(void) connectWithSuccessCallback:(void (^)(void)) successCallback failCallback:(void (^)(void)) failCallback {
    _connectSuccessCallback = successCallback;
    _connectFailCallback = failCallback;
    [self connect];
}

-(void) disconnectWithCallback:(void (^)(void)) completeCallback {
}

-(void) sendData:(NSData*) data withSuccessCallback:(void (^)(void)) successCallback failCallback:(void (^)(void)) failCallback {

    /*
    DCActionTask* task = [[DCActionTask alloc] init];
    [task addSuccessCallback:successCallback];
    [task addFailCallback:failCallback];
    task.action = ^{
        [self sendData:data];
    };
    [_taskPool addTask:task];
     */
}


-(void) onConnect {
    
    socket.state = DCSocketStateConnected;
    
    if (_connectSuccessCallback) {
        ((void (^)(void))_connectSuccessCallback)();
    }
    
    _connectSuccessCallback = nil;
    _connectFailCallback = nil;
}

-(void) onFailToConnect {

    socket.state = DCSocketStateDisconnected;
    
    if (_connectFailCallback) {
        ((void (^)(void))_connectFailCallback)();
    }
    
    _connectSuccessCallback = nil;
    _connectFailCallback = nil;
}

-(void) onDisconnect {
    
    socket.state = DCSocketStateDisconnected;
    
    if (socket.delegate && [socket.delegate respondsToSelector:@selector(socketDidLoseConnection:)]) {
        [socket.delegate socketDidLoseConnection:socket];
    }
}

-(void) onReceiveData:(NSData*) data {
    
    if (data.length == 0) {
        return;
    }
    
    if (socket.delegate && [socket.delegate respondsToSelector:@selector(socket:didReceiveData:)]) {
        [socket.delegate socket:self didReceiveData:data];
    }
}

-(void) onSendData {
    //[_taskPool reportSuccessForFirstTaskInPool];
}

@end
