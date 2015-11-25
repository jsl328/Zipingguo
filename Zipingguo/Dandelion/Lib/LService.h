//
//  LService.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCServiceContext.h"

@interface LService : NSObject

+(void) request:(NSString*) name with:(NSArray*) parameters returns:(Class) returnType whenDone:(void (^)(DCServiceContext*, id)) callback;

+(void) request:(NSString*) name with:(NSArray*) parameters whenDone:(void (^)(DCServiceContext*)) callback;

+(BOOL) isWaiting;

+(void) stop;

+(NSArray*) serviceMethods;

+(void) downloadFromUrl:(NSString*) url;

+(void) downloadFromUrl:(NSString *)url whenSuccess:(void (^)(NSString*)) successCallback whenFail:(void (^)(void)) failCallback;

@end
