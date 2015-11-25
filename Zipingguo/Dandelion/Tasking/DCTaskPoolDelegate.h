//
//  TaskPoolDelegate.h
//  Dandelion
//
//  Created by Bob Li on 13-4-22.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

@class DCTask;

#import <Foundation/Foundation.h>
#import "DCTask.h"

@protocol DCTaskPoolDelegate <NSObject>

@optional

-(void) taskDidEnqueue: (DCTask*) task;

-(void) taskDidRun: (DCTask*) task;

-(void) taskProgressDidChange: (DCTask*) task;

-(void) taskDidComplete: (DCTask*) task;

@end
