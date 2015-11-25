//
//  DCNetworkChecker.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-25.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCReachability.h"

@interface DCNetworkChecker : NSObject

+(id) checkerWithStringOfNetworkTypes:(NSString*) networkTypes;

-(BOOL) networkTypeMatches:(DCNetworkStatus) networkStatus;

@end
