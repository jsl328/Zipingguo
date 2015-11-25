//
//  DownloadShceduler.m
//  Dandelion
//
//  Created by Bob Li on 13-8-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCUrlDownloader.h"
#import "DCFileDownloadTask.h"
#import "AppContext.h"
#import "DCTaskPool.h"
#import "FileSystem.h"
#import "DCViewQuery.h"
#import "DCAppDelegate.h"

@implementation DCUrlDownloader {
    
    NSMutableArray* _delegates;
}

@synthesize enableAppDelegate;


static DCUrlDownloader* _defaultDownloader;

+(DCUrlDownloader*) defaultDownloader {
    
    if (!_defaultDownloader) {
        _defaultDownloader = [[DCUrlDownloader alloc] init];
    }
    
    return _defaultDownloader;
}

-(id) init {
    
    self = [super init];
    
    [[DCTaskPool obtainConcurrent] removeDelegateOfType:[DCUrlDownloader class]];
    [[DCTaskPool obtainConcurrent] addDelegate:self];
    
    _delegates = [[NSMutableArray alloc] init];
    
    return self;
}


-(void) addDelegate:(id <DCUrlDownloaderDelegate>) delegate {
    [_delegates addObject:delegate];
}

-(void) removeDelegate:(id <DCUrlDownloaderDelegate>) delegate {
    [_delegates removeObject:delegate];
}


-(void) downloadUrl:(NSString*) url fileName:(NSString*) fileName limitSize:(int) limitSize {
    [self downloadUrl:url fileName:fileName limitSize:limitSize completeCallback:nil failCallback:nil];
}

-(void) downloadUrl:(NSString*) url fileName:(NSString*) fileName limitSize:(int) limitSize completeCallback:(void (^)(NSString*)) completeCallback failCallback:(void (^)(void)) failCallback {

    NSString* targetFilePath = [[AppContext storageResolver] pathForDownloadedFileFromUrl:url fileName:fileName];

    DCFileDownloadTask* task = [self taskDownloadingUrl:url];
    
    if (!task) {
        
        task = [[DCFileDownloadTask alloc] init];
        task.url = url;
        task.fileName = fileName;
        task.limitSize = limitSize;
        task.targetFilePath = targetFilePath;
        
        [[DCTaskPool obtainConcurrent] addTask:task];
    }
    
    
    __unsafe_unretained DCTask* weakTask = task;
    
    [task addCompleteCallback:^{
        
        if (weakTask.isSucceeded) {
            if (completeCallback) {
                completeCallback(targetFilePath);
            }
        }
        else if (failCallback) {
            failCallback();
        }
    }];
}


-(void) taskDidRun: (DCTask*) task {
    
    if ([[task class] isSubclassOfClass:[DCDownloadTask class]]) {
        
        DCDownloadTask* downloadTask = (DCDownloadTask*)task;
        
        for (id <DCUrlDownloaderDelegate> delegate in _delegates) {
            if ([delegate respondsToSelector:@selector(urlDownloadDidStart:)]) {
                [delegate urlDownloadDidStart:downloadTask.url];
            }
        }
    
        if (enableAppDelegate) {
            id <DCAppDelegate> delegate = [self findTargetWithSelector:@selector(appDidStartDownloadingUrl:)];
            if (delegate) {
                [delegate appDidStartDownloadingUrl:downloadTask.url];
            }
        }
    }
}

-(void) taskProgressDidChange: (DCTask*) task {
    
    if ([[task class] isSubclassOfClass:[DCFileDownloadTask class]]) {
        
        DCFileDownloadTask* downloadTask = (DCFileDownloadTask*)task;
        
        for (id <DCUrlDownloaderDelegate> delegate in _delegates) {
            if ([delegate respondsToSelector:@selector(url:progressDidChange:)]) {
                [delegate url:downloadTask.url progressDidChange:task.progress];
            }
        }
        
        if (enableAppDelegate) {
            id <DCAppDelegate> delegate = [self findTargetWithSelector:@selector(appDidDownloadUrl:toPercent:)];
            if (delegate) {
                [delegate appDidDownloadUrl:downloadTask.url toPercent:task.progress];
            }
        }
    }
}

-(void) taskDidComplete: (DCTask*) task {
    
    if ([[task class] isSubclassOfClass:[DCFileDownloadTask class]]) {
        
        DCFileDownloadTask* downloadTask = (DCFileDownloadTask*)task;
        
        if (task.isSucceeded) {
            
            for (id <DCUrlDownloaderDelegate> delegate in _delegates) {
                if ([delegate respondsToSelector:@selector(urlDownloadDidSucceed:fileName:limitSize:)]) {
                    [delegate urlDownloadDidSucceed:downloadTask.url fileName:downloadTask.fileName limitSize:downloadTask.limitSize];
                }
            }
            
            if (enableAppDelegate) {
                id <DCAppDelegate> delegate = [self findTargetWithSelector:@selector(appDidDownloadUrl:filePath:limitSize:)];
                if (delegate) {
                    [delegate appDidDownloadUrl:downloadTask.url filePath:downloadTask.targetFilePath limitSize:downloadTask.limitSize];
                }
            }
        }
        else {
            
            for (id <DCUrlDownloaderDelegate> delegate in _delegates) {
                if ([delegate respondsToSelector:@selector(urlDownloadDidFail:)]) {
                    [delegate urlDownloadDidFail:downloadTask.url];
                }
            }
            
            if (enableAppDelegate) {
                id <DCAppDelegate> delegate = [self findTargetWithSelector:@selector(appDidFailToDownloadUrl:)];
                if (delegate) {
                    [delegate appDidFailToDownloadUrl:downloadTask.url];
                }
            }
        }
    }
}

-(id) findTargetWithSelector:(SEL) selector {
    
    DCViewQuery* viewQuery = [[DCViewQuery alloc] init];
    viewQuery.includeController = YES;
    return [viewQuery firstViewThatConfirmsToProtocol:@protocol(DCAppDelegate) selector:selector];
}


-(DCFileDownloadTask*) taskDownloadingUrl:(NSString*) url {

    return (DCFileDownloadTask*)[[DCTaskPool obtainConcurrent] findTaskUsingCondition:^BOOL(DCTask* item) {
        return [item.class isSubclassOfClass:[DCFileDownloadTask class]] && [((DCFileDownloadTask*)item).url isEqualToString:url];
    }];
}

-(BOOL) isDownloadingUrl:(NSString *)url {
    return [self taskDownloadingUrl:url] != nil;
}

@end
