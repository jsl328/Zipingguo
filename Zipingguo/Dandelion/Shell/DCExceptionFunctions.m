//
//  DCExceptionFunctions.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-18.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCExceptionFunctions.h"

NSException* DCAssertExceptionMake(NSString* reason) {
    return [NSException exceptionWithName:@"AssertException" reason:reason userInfo:nil];
}

NSException* DCTimeoutExceptionMake(NSString* reason) {
    return [NSException exceptionWithName:@"TimeoutException" reason:reason userInfo:nil];
}

NSException* DCWebExceptionMake(NSString* reason, NSError* error) {
    return [NSException exceptionWithName:@"WebException" reason:reason userInfo:error.userInfo];
}

NSException* DCFileNotFoundExceptionMake(NSString* reason) {
    return [NSException exceptionWithName:@"FileNotFoundException" reason:reason userInfo:nil];
}