//
//  BackgroundTask.m
//  Dandelion
//
//  Created by Bob Li on 13-4-22.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCTask.h"

@implementation DCTask {
    
    NSMutableArray* _progressCallbacks;
    
    NSMutableArray* _completeCallbacks;
}


@synthesize taskPool;
@synthesize state;
@synthesize progress;
@synthesize index;
@synthesize feature;
@synthesize isSucceeded;
@synthesize exception;
@synthesize isInternal;
@synthesize timeout;

-(id) init {
    self = [super init];
    if (self) {
        feature = DCTaskFeatureLocalShortTask;
    }
    return self;
}

-(void) execute {
}


-(void) reportProgress:(double)currentProgress {
    self.progress = currentProgress;
    [taskPool progressReportedByTask:self];
}


-(void) addProgressCallback:(void (^)(void))callback {
    
    if (!_progressCallbacks) {
        _progressCallbacks = [[NSMutableArray alloc] init];
    }
    
    [_progressCallbacks addObject:callback];
}

-(void) addCompleteCallback:(void (^)(void)) callback {
    
    if (!_completeCallbacks) {
        _completeCallbacks = [[NSMutableArray alloc] init];
    }
    
    [_completeCallbacks addObject:callback];
}


-(void) taskDidProgress {
    
    if (_progressCallbacks) {
        
        for (id callback in _progressCallbacks.objectEnumerator) {
            ((void (^)(void))callback)();
        }
    }
}

-(void) taskDidComplete {
    
    if (_completeCallbacks) {
        
        for (id callback in _completeCallbacks.objectEnumerator) {
            ((void (^)(void))callback)();
        }
        
        [_completeCallbacks removeAllObjects];
        _completeCallbacks = nil;
    }
    
    if (_progressCallbacks) {
        
        [_progressCallbacks removeAllObjects];
        _progressCallbacks = nil;
    }
}

@end
