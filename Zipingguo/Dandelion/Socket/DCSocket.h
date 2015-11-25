//
//  DCSocket.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DCSocketDelegate.h"

enum DCSocketState {
    DCSocketStateInitialized = 0,
    DCSocketStateConnected = 1,
    DCSocketStateDisconnected = 2
};
typedef enum DCSocketState DCSocketState;

@interface DCSocket : NSObject {

    id _protocol;
}


@property (assign, nonatomic) DCSocketState state;
@property (nonatomic) NSStringEncoding encoding;
@property (assign, nonatomic) id <DCSocketDelegate> delegate;

-(void) connectWithSuccessCallback:(void (^)(void)) successCallback failCallback:(void (^)(void)) failCallback;

-(void) disconnect;

-(void) dispose;


-(void) sendData:(NSData*) data withSuccessCallback:(void (^)(void)) successCallback failCallback:(void (^)(void)) failCallback;


+(DCSocket*) tcpSocketConnectedToHost:(NSString*) host onPort:(int) port;

@end

