//
//  DCNetworkChecker.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-25.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCNetworkChecker.h"

static NSMutableDictionary* _checkers;

@implementation DCNetworkChecker {

    int _mask;
}

+(void) load {
    _checkers = [[NSMutableDictionary alloc] init];
}

+(id) checkerWithStringOfNetworkTypes:(NSString*) networkTypes {

    int mask = [DCNetworkChecker maskParsedFromNetworkTypes:networkTypes];
    
    NSString* key = [NSString stringWithFormat:@"%d", mask];
    
    DCNetworkChecker* checker = [_checkers objectForKey:key];
    if (!checker) {
    
        checker = [[DCNetworkChecker alloc] init];
        checker->_mask = mask;
        
        [_checkers setObject:checker forKey:key];
    }
    
    return checker;
}

+(int) maskParsedFromNetworkTypes:(NSString*) networkTypes {

    int mask = 0;
    
    for (NSString* networkType in [networkTypes componentsSeparatedByString:@","]) {
        if ([networkType isEqualToString:@"wifi"]) {
            mask += 1;
        }
        else if ([networkType isEqualToString:@"mobile"]) {
            mask += 2;
        }
    }
    
    return mask;
}


-(BOOL) networkTypeMatches:(DCNetworkStatus) networkStatus {

    if (networkStatus == DCNetworkStatusReachableViaWiFi) {
        return (_mask & 1) > 0;
    }
    else if (networkStatus == DCNetworkStatusReachableViaWWAN) {
        return (_mask & 2) > 0;
    }
    else {
        return NO;
    }
}

@end
