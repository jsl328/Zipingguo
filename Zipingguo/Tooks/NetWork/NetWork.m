//
//  NetWork.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-11-19.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "NetWork.h"
#import "Reachability.h"
@implementation NetWork
+ (BOOL) isConnectionAvailable{
    BOOL isExistenceNetwork = NO;
    Reachability* curReach = [Reachability reachabilityForInternetConnection];
    switch ([curReach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    return isExistenceNetwork;
}

+(NETWORK_TYPE)getNetworkTypeFromStatusBar {
 
    UIApplication *app = [UIApplication sharedApplication];
    
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    
    NSNumber *dataNetworkItemView = nil;
  
    for (id subview in subviews) {
       
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            
            dataNetworkItemView = subview;
            
            break;
            
        }
       
    }
    
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    
    nettype = [num intValue];
 
    return nettype;
   
}

@end
