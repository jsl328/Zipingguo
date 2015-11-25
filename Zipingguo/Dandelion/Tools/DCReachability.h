//
//  DCNetworkConnectivity.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-25.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    DCNetworkStatusNotReachable = 0,
    DCNetworkStatusNoInformation,
    DCNetworkStatusReachableViaWiFi,
    DCNetworkStatusReachableViaWWAN,
} DCNetworkStatus;


@interface DCReachability : NSObject

@property (nonatomic) DCNetworkStatus lastNetworkStatus;

/*!
 * Use to check the reachability of a given host name.
 */
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/*!
 * Use to check the reachability of a given IP address.
 */
+ (instancetype)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

/*!
 * Checks whether the default route is available. Should be used by applications that do not connect to a particular host.
 */
+ (instancetype)reachabilityForInternetConnection;

/*!
 * Checks whether a local WiFi connection is available.
 */
+ (instancetype)reachabilityForLocalWiFi;

/*!
 * Start listening for reachability notifications on the current run loop.
 */
- (BOOL)startNotifier;
- (void)stopNotifier;

- (DCNetworkStatus)currentReachabilityStatus;

/*!
 * WWAN may be available, but not active until a connection has been established. WiFi may require a connection for VPN on Demand.
 */
- (BOOL)connectionRequired;


@end