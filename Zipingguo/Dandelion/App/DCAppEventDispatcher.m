//
//  DCAppEventDispatcher.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCAppEventDispatcher.h"
#import "DCViewQuery.h"
#import "DCAppDelegate.h"

@implementation DCAppEventDispatcher

+(void) dispatchStopPlayingAudioFile:(NSString*) filePath {
    
    id <DCAppDelegate> target = [DCAppEventDispatcher findTargetWithSelector:@selector(appDidStopPlayingAudioFile:)];
    if (target) {
        [target appDidStopPlayingAudioFile:filePath];
    }
}

+(void) dispatchStartPlayingAudioFile:(NSString*) filePath {
    
    id <DCAppDelegate> target = [DCAppEventDispatcher findTargetWithSelector:@selector(appDidStartPlayingAudioFile:)];
    if (target) {
        [target appDidStartPlayingAudioFile:filePath];
    }
}

+(void) dispatchPlayAudioFile:(NSString*) filePath toTime:(NSTimeInterval) time outOfTotalTime:(NSTimeInterval) totalTime {
    
    id <DCAppDelegate> target = [DCAppEventDispatcher findTargetWithSelector:@selector(appDidPlayAudioFile:toTime:outOfTotalTime:)];
    if (target) {
        [target appDidPlayAudioFile:filePath toTime:time outOfTotalTime:totalTime];
    }
}

+(void) dispatchDidStartDownloadingUrl: (NSString*) url {

    id <DCAppDelegate> target = [DCAppEventDispatcher findTargetWithSelector:@selector(appDidStartDownloadingUrl:)];
    if (target) {
        [target appDidStartDownloadingUrl:url];
    }
}

+(void) dispatchDidDownloadUrl:(NSString*) url toPercent:(float) percent {

    id <DCAppDelegate> target = [DCAppEventDispatcher findTargetWithSelector:@selector(appDidDownloadUrl:toPercent:)];
    if (target) {
        [target appDidStartDownloadingUrl:url];
    }
}

+(void) dispatchDidDownloadUrl: (NSString*) url filePath:(NSString*) filePath limitSize:(int) limitSize {
    
    id <DCAppDelegate> target = [DCAppEventDispatcher findTargetWithSelector:@selector(appDidDownloadUrl:filePath:limitSize:)];
    if (target) {
        [target appDidDownloadUrl:url filePath:filePath limitSize:limitSize];
    }
}

+(void) dispatchDidFailToDownloadUrl: (NSString*) url {

    id <DCAppDelegate> target = [DCAppEventDispatcher findTargetWithSelector:@selector(appDidFailToDownloadUrl:)];
    if (target) {
        [target appDidFailToDownloadUrl:url];
    }
}

+(void) dispatchReceiveErrorMessage:(NSString*) errorMessage {

    id <DCAppDelegate> target = [DCAppEventDispatcher findTargetWithSelector:@selector(appDidReceiveErrorMessage:)];
    if (target) {
        [target appDidReceiveErrorMessage:errorMessage];
    }
}

+(void) dispatchReceiveErrorMessageFromStringKey:(DCStringKey) key {
    [DCAppEventDispatcher dispatchReceiveErrorMessage:[DCLocalizedStrings stringForKey:key]];
}


+(id) findTargetWithSelector:(SEL) selector {
    
    DCViewQuery* viewQuery = [[DCViewQuery alloc] init];
    viewQuery.includeController = YES;
    return [viewQuery firstViewThatConfirmsToProtocol:@protocol(DCAppDelegate) selector:selector];
}

@end
