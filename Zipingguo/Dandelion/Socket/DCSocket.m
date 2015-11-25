//
//  DCSocket.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCSocket.h"
#import "DCSocketProtocol.h"
#import "DCTcpSocketProtocol.h"
#import "DCSocketManager.h"

@implementation DCSocket
@synthesize state;
@synthesize encoding;
@synthesize delegate;

-(id) init {
    self = [super init];
    if (self) {
        state = DCSocketStateInitialized;
        encoding = NSUTF8StringEncoding;
    }
    return self;
}

-(void) connectWithSuccessCallback:(void (^)(void)) successCallback failCallback:(void (^)(void)) failCallback {
    if (state == DCSocketStateInitialized || state == DCSocketStateDisconnected) {
        [((DCSocketProtocol*)_protocol) connectWithSuccessCallback:successCallback failCallback:failCallback];
    }
}

-(void) disconnect {
    if (state & DCSocketStateConnected) {
        [((DCSocketProtocol*)_protocol) disconnect];
        state = DCSocketStateDisconnected;
    }
}

-(void) dispose {
    [self disconnect];
    [[DCSocketManager defaultManager] removeSocket:self];
}


-(void) sendData:(NSData*) data withSuccessCallback:(void (^)(void)) successCallback failCallback:(void (^)(void)) failCallback {
    if (state == DCSocketStateConnected) {
        [((DCSocketProtocol*)_protocol) sendData:data withSuccessCallback:successCallback failCallback:failCallback];
    }
}


+(DCSocket*) tcpSocketConnectedToHost:(NSString *)host onPort:(int)port {
    DCSocket* socket = [[DCSocket alloc] init];
    socket->_protocol = [[DCTcpSocketProtocol alloc] initWithHost:host port:port];
    ((DCTcpSocketProtocol*)socket->_protocol).socket = socket;
    [[DCSocketManager defaultManager] addSocket:socket];
    return socket;
}

@end

