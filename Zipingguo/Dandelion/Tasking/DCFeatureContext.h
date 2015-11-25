//
//  DCTaskPartition.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-17.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTask.h"

@interface DCFeatureItem : NSObject

@property (nonatomic) DCTaskFeature feature;
@property (nonatomic) int quota;
@property (nonatomic) int remainingCount;
@property (nonatomic) int priority;

-(id) initWithFeature:(DCTaskFeature) feature quota:(int) quota priority:(int) priority;


-(void) requestQuota;

-(void) releaseQuota;

@end


@interface DCFeatureContext : NSObject

-(DCFeatureItem*) itemForFeature:(DCTaskFeature) feature;

@end
