//
//  DCAppEventDispatcher.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCLocalizedStrings.h"

@interface DCAppEventDispatcher : NSObject

+(void) dispatchStopPlayingAudioFile:(NSString*) filePath;

+(void) dispatchStartPlayingAudioFile:(NSString*) filePath;

+(void) dispatchPlayAudioFile:(NSString*) filePath toTime:(NSTimeInterval) time outOfTotalTime:(NSTimeInterval) totalTime;

+(void) dispatchDidStartDownloadingUrl: (NSString*) url;

+(void) dispatchDidDownloadUrl:(NSString*) url toPercent:(float) percent;

+(void) dispatchDidDownloadUrl: (NSString*) url filePath:(NSString*) filePath limitSize:(int) limitSize;

+(void) dispatchDidFailToDownloadUrl: (NSString*) url;

+(void) dispatchReceiveErrorMessage:(NSString*) errorMessage;

+(void) dispatchReceiveErrorMessageFromStringKey:(DCStringKey) key;

@end
