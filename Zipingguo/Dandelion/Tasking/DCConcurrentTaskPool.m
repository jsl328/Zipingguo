//
//  DCConcurrentTaskPool.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-26.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCConcurrentTaskPool.h"
#import "DCFeatureContext.h"

@implementation DCConcurrentTaskPool {

    DCFeatureContext* _featureContext;
}

-(id) init {
    self = [super init];
    if (self) {
        _queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _featureContext = [[DCFeatureContext alloc] init];
    }
    return self;
}


// overrides

-(void) addTaskToList:(DCTask*) task {
    
    BOOL isAdded = NO;
    int priority = [_featureContext itemForFeature:task.feature].priority;
    
    if (_tasks.count > 0) {
        for (int i = 0; i <= _tasks.count - 1; i++) {
            DCTask* t = [_tasks objectAtIndex:i];
            if (priority < [_featureContext itemForFeature:t.feature].priority) {
                [_tasks insertObject:task atIndex:i];
                isAdded = YES;
                break;
            }
        }
    }
    
    if (!isAdded) {
        [_tasks addObject:task];
    }
}

-(BOOL) shouldStartTask:(DCTask*) task {
    
    if (!(task.state == DCTaskStateQueued && [_featureContext itemForFeature:task.feature].remainingCount > 0)) {
        return NO;
    }
    
    for (DCTask* t in _tasks) {
        if (t != task && t.state == DCTaskStateQueued && [_featureContext itemForFeature:t.feature].priority < [_featureContext itemForFeature:task.feature].priority) {
            return NO;
        }
    }
    
    return YES;
}

-(void) requestQuotaForTask:(DCTask*) task {
    [_featureContext itemForFeature:task.feature].remainingCount--;
}

-(void) releaseQuotaForTask:(DCTask*) task {
    [_featureContext itemForFeature:task.feature].remainingCount++;
}

//

@end
