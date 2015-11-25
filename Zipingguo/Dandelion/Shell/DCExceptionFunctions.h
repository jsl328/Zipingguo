//
//  DCExceptionFunctions.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-18.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

NSException* DCAssertExceptionMake(NSString* reason);

NSException* DCTimeoutExceptionMake(NSString* reason);

NSException* DCWebExceptionMake(NSString* reason, NSError* error);

NSException* DCFileNotFoundExceptionMake(NSString* reason);