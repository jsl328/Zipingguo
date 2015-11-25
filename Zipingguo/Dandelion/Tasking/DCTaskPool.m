//
//  TaskPool.m
//  Dandelion
//
//  Created by Bob Li on 13-4-22.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCTaskPool.h"
#import "FileSystem.h"
#import "DCActionTask.h"
#import "DCDownloadTask.h"
#import "NSArray+Extensions.h"
#import "DCSerialTaskPool.h"
#import "DCConcurrentTaskPool.h"


@implementation DCTaskPool {

    NSMutableArray* _delegates;
    
    BOOL _isPaused;
}



static NSObject* _lock;

static DCTaskPool* _serialPool;
static DCTaskPool* _concurrentPool;

+(void) load {
    _lock = [[NSObject alloc] init];
    _concurrentPool = [[DCConcurrentTaskPool alloc] init];
}


// abstract methods

-(void) addTaskToList:(DCTask*) task {
}

-(BOOL) shouldStartTask:(DCTask*) task {
    return NO;
}

-(void) requestQuotaForTask:(DCTask*) task {
}

-(void) releaseQuotaForTask:(DCTask*) task {
}

//


-(id) init {
    self = [super init];
    if (self) {
        _tasks = [[NSMutableArray alloc] init];
        _delegates = [[NSMutableArray alloc] init];
    }
    return self;
}


+(DCTaskPool*) createSerial {
    return [[DCSerialTaskPool alloc] init];
}

+(DCTaskPool*) obtainSerial {
    
    if (!_serialPool) {
        _serialPool = [DCTaskPool createSerial];
    }
    
    return _serialPool;
}

+(DCTaskPool*) obtainConcurrent {
    return _concurrentPool;
}


-(DCTask*) findTaskUsingCondition:(BOOL (^)(DCTask*)) condition {

    @synchronized (_lock) {
        return [_tasks findFirst:condition];
    }
}

-(NSArray*) findTasksUsingCondition:(BOOL (^)(DCTask*)) condition {
    
    NSMutableArray* tasks = [[NSMutableArray alloc] init];
    
    @synchronized (_lock) {
        for (DCTask* task in _tasks) {
            if (condition(task)) {
                [tasks addObject:task];
            }
        }
    }
    
    return tasks;
}


-(void) removeDelegateOfType: (Class) type {

    NSMutableArray* delegates = [[NSMutableArray alloc] init];
    [delegates addObjectsFromArray:_delegates];
    
    for (id delegate in delegates) {
        if ([[delegate class] isSubclassOfClass:type]) {
            [_delegates removeObject:delegate];
        }
    }
}

-(void) addDelegate:(id)delegate {
    [_delegates addObject:delegate];
}

-(void) addTask:(DCTask*) task {
    
    task.state = DCTaskStateQueued;
    task.index = _tasks.count;
    task.taskPool = self;
    
    
    BOOL shouldStart = NO;
    
    @synchronized (_lock) {

        [self addTaskToList:task];
        shouldStart = !_isPaused && [self shouldStartTask:task];
    }

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self invokeTaskDidEnqueue:task];
    });
    
    
    if (shouldStart) {
    
        @synchronized (_lock) {
            task.state = DCTaskStateRunning;
            [self requestQuotaForTask:task];
        }
    
        [self startQueuedTask:task];
    }
}


-(void) pause {
    _isPaused = YES;
}

-(void) resume {
    _isPaused = NO;
    [self startQueuedTasks];
}


-(void) invokeTaskDidEnqueue:(DCTask*) task {
    
    if (!task.isInternal) {
        for (id <DCTaskPoolDelegate> delegate in _delegates) {
            if ([delegate respondsToSelector:@selector(taskDidEnqueue:)]) {
                [delegate taskDidEnqueue:task];
            }
        }
    }
}

-(void) invokeTaskDidRun:(DCTask*) task {
    
    if (!task.isInternal) {
        for (id <DCTaskPoolDelegate> delegate in _delegates) {
            if ([delegate respondsToSelector:@selector(taskDidRun:)]) {
                [delegate taskDidRun:task];
            }
        }
    }
}

-(void) invokeTaskDidComplete:(DCTask*) task {
    
    if (!task.isInternal) {
        for (id <DCTaskPoolDelegate> delegate in _delegates) {
            if ([delegate respondsToSelector:@selector(taskDidComplete:)]) {
                [delegate taskDidComplete:task];
            }
        }
    }
}

-(void) invokeTaskProgressDidChange:(DCTask*) task {
    
    if (!task.isInternal) {
        for (id <DCTaskPoolDelegate> delegate in _delegates) {
            if ([delegate respondsToSelector:@selector(taskProgressDidChange:)]) {
                [delegate taskProgressDidChange:task];
            }
        }
    }
}


-(void) handleTaskComplete:(DCTask *)task isSucceeded:(BOOL) isSucceeded exception:(NSException*) exception {

    task.isSucceeded = isSucceeded;
    task.exception = exception;
    task.state = DCTaskStateCompleted;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [task taskDidComplete];
        [self invokeTaskDidComplete:task];
    });
    
    @synchronized (_lock) {
        
        [self releaseQuotaForTask:task];
        [self removeTask:task];
        
        if ([[self class] isSubclassOfClass:[DCSerialTaskPool class]] && !isSucceeded) {
            [self removeAllTasks];
        }
    }
    
    if (!_isPaused) {
        [self startQueuedTasks];
    }
}

-(void) progressReportedByTask:(DCTask *)task {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [task taskDidProgress];
        [self invokeTaskProgressDidChange:task];
    });
}

-(void) removeTask: (DCTask*) task {
    
    task.state = DCTaskStateCompleted;
    task.taskPool = nil;
    [_tasks removeObject:task];
}

-(void) removeAllTasks {
    
    for (DCTask* task in _tasks) {
        task.state = DCTaskStateCompleted;
        task.taskPool = nil;
    }
    
    [_tasks removeAllObjects];
}

-(void) startQueuedTasks {
    
    NSMutableArray* scheduledTasks = [[NSMutableArray alloc] init];
    
    @synchronized (_lock) {
        while (true) {
            
            DCTask* task = [_tasks findFirst:^BOOL(DCTask* item) {
                return [self shouldStartTask:item];
            }];
            
            if (task) {
                task.state = DCTaskStateRunning;
                [self requestQuotaForTask:task];
                [scheduledTasks addObject:task];
            }
            else {
                break;
            }
        }
    }
    
    if (scheduledTasks.count > 0) {
        for (DCTask* task in scheduledTasks) {
            [self startQueuedTask:task];
        }
    }
}

-(void) startQueuedTask: (DCTask*) task {
    
    task.state = DCTaskStateRunning;
    [self invokeTaskDidRun:task];

    dispatch_async(_queue, ^{
    
        BOOL isSucceeded = NO;
        NSException* ex = nil;
        
        @try {
            [task execute];
            isSucceeded = YES;
        }
        @catch (NSException *exception) {
            ex = exception;
        }
        @finally {
            [self handleTaskComplete:task isSucceeded:isSucceeded exception:ex];
        }
    });
}

@end
