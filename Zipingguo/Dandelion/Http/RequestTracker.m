//
//  RequestTracker.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-1.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "RequestTracker.h"
#import "AppContext.h"
#import "WaitBox.h"

static Request* _request;

static BOOL _isWaitingOnRequest;

@implementation RequestTracker

+(void) track: (Request*) request {

    _request = request;
    _isWaitingOnRequest = YES;
    
    if ([_request serviceMethod].showWaitBox) {
        [[WaitBox defaultWaitBox] show];
        [WaitBox defaultWaitBox].message = [_request serviceMethod].message;
    }
}

+(void) remove {
    
    if ([_request serviceMethod].showWaitBox) {
        [[WaitBox defaultWaitBox] close];
    }
    
    _request = nil;
    _isWaitingOnRequest = NO;
}

+(BOOL) isWaitingOnRequest {
    return _isWaitingOnRequest;
}

+(void) abort {
    
    Request* request = _request;
    [RequestTracker remove];
    
    if (request) {
        [request abort];
    }
}

@end
