//
//  DCSocketManager.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-22.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCSocketManager.h"

static DCSocketManager* _instance;

@implementation DCSocketManager

+(DCSocketManager*) defaultManager {
    
    if (!_instance) {
        _instance = [[DCSocketManager alloc] init];
    }
    
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _sockets = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void) removeSocket:(DCSocket *)socket {
    [_sockets removeObject:socket];
}

-(void) addSocket:(DCSocket*) socket {
    [_sockets addObject:socket];
}


-(NSArray*) sockets {
    return [[NSArray alloc] initWithArray:_sockets];
}

-(void) disconnectAllSockets {
    for (DCSocket* socket in _sockets) {
        [socket disconnect];
    }
}

-(void) disposeAllSockets {
    [self disconnectAllSockets];
    [_sockets removeAllObjects];
}

@end
