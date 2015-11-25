//
//  RequestTracker.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-1.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"

@interface RequestTracker : NSObject

+(void) track: (Request*) request;

+(void) remove;

+(BOOL) isWaitingOnRequest;

+(void) abort;

@end
