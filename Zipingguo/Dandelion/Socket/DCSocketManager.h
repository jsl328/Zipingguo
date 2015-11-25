//
//  DCSocketManager.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-22.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCSocket.h"

@class DCSocket;

@interface DCSocketManager : NSObject {

    NSMutableArray* _sockets;
}

+(DCSocketManager*) defaultManager;


-(void) removeSocket:(DCSocket*) socket;
-(void) addSocket:(DCSocket*) socket;

-(NSArray*) sockets;

-(void) disconnectAllSockets;
-(void) disposeAllSockets;

@end
