//
//  TaskPool.h
//  Dandelion
//
//  Created by Bob Li on 13-4-22.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTask.h"
#import "DCTaskPoolDelegate.h"

@interface DCTaskPool : NSObject {

    NSMutableArray* _tasks;
    
    dispatch_queue_t _queue;
}


// abstract methods

-(void) addTaskToList:(DCTask*) task;

-(BOOL) shouldStartTask:(DCTask*) task;

-(void) requestQuotaForTask:(DCTask*) task;

-(void) releaseQuotaForTask:(DCTask*) task;

//


-(void) pause;

-(void) resume;


-(void) progressReportedByTask: (DCTask*) task;


+(DCTaskPool*) createSerial;

+(DCTaskPool*) obtainSerial;
+(DCTaskPool*) obtainConcurrent;


-(DCTask*) findTaskUsingCondition:(BOOL (^)(DCTask*)) condition;

-(NSArray*) findTasksUsingCondition:(BOOL (^)(DCTask*)) condition;


-(void) removeDelegateOfType: (Class) type;

-(void) addDelegate: (id) delegate;

-(void) addTask:(DCTask*) task;

-(void) removeTask: (DCTask*) task;

-(void) removeAllTasks;

-(void) invokeTaskProgressDidChange:(DCTask*) task;

@end
