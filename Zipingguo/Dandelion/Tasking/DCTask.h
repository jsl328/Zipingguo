//
//  BackgroundTask.h
//  Dandelion
//
//  Created by Bob Li on 13-4-22.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

@class DCTaskPool;

#import <Foundation/Foundation.h>
#import "DCTaskPool.h"

enum DCTaskState {
    DCTaskStateCreated,
    DCTaskStateQueued,
    DCTaskStateRunning,
    DCTaskStateCompleted
};
typedef enum DCTaskState DCTaskState;

enum DCTaskFeature {
    DCTaskFeatureLoadImage,
    DCTaskFeatureLocalShortTask,
    DCTaskFeatureDataRequest,
    DCTaskFeatureStreamDownload,
    DCTaskFeatureStreamUpload,
    DCTaskFeatureLocalLongTask
};
typedef enum DCTaskFeature DCTaskFeature;


@interface DCTask : NSObject
@property (nonatomic ,assign)int priority; //优先级1为最高，0默认
@property (assign, nonatomic) DCTaskPool* taskPool;
@property (nonatomic) DCTaskState state;
@property (nonatomic) float progress;
@property (nonatomic) int index;
@property (nonatomic) DCTaskFeature feature;
@property (nonatomic) BOOL isSucceeded;
@property (retain, nonatomic) NSException* exception;
@property (nonatomic) BOOL isInternal;
@property (nonatomic) NSTimeInterval timeout;


-(void) addProgressCallback:(void (^)(void)) callback;

-(void) addCompleteCallback:(void (^)(void)) callback;


-(void) execute;


-(void) taskDidProgress;

-(void) taskDidComplete;


-(void) reportProgress: (double) currentProgress;

@end
