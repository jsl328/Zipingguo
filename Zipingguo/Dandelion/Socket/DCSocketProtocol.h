//
//  DCSocketProtocol.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-25.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCSocket.h"
#import "DCTaskPool.h"
#import "DCActionTask.h"

@interface DCSocketProtocol : NSObject {
    
    id _connectSuccessCallback;
    id _connectFailCallback;

    DCTaskPool* _taskPool;
}

@property (assign, nonatomic) DCSocket* socket;

-(void) connect;
-(void) disconnect;
-(void) sendData:(NSData*) data;

-(void) connectWithSuccessCallback:(void (^)(void)) successCallback failCallback:(void (^)(void)) failCallback;

-(void) disconnectWithCallback:(void (^)(void)) completeCallback;

-(void) sendData:(NSData*) data withSuccessCallback:(void (^)(void)) successCallback failCallback:(void (^)(void)) failCallback;


-(void) onConnect;
-(void) onDisconnect;
-(void) onFailToConnect;
-(void) onReceiveData:(NSData*) data;
-(void) onSendData;

@end
