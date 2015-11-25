//
//  DCTaskPartition.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-7-17.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCFeatureContext.h"

@implementation DCFeatureItem
@synthesize feature = _feature;
@synthesize quota = _quota;
@synthesize remainingCount = _remainingCount;

-(id) initWithFeature:(DCTaskFeature) feature quota:(int) quota priority:(int) priority {

    self = [super init];
    if (self) {
        _feature = feature;
        _quota = quota;
        _remainingCount = quota;
    }
    return self;
}


-(void) requestQuota {
    _remainingCount--;
    DCAssertBetween(_remainingCount, 0, _quota);
}

-(void) releaseQuota {
    _remainingCount++;
    DCAssertBetween(_remainingCount, 0, _quota);
}

@end


@implementation DCFeatureContext {

    NSArray* _features;
}

-(id) init {
    self = [super init];
    if (self) {
        [self registerFeatureItems];
    }
    return self;
}

-(void) registerFeatureItems {

    _features = @[
    [[DCFeatureItem alloc] initWithFeature:DCTaskFeatureLoadImage quota:10 priority:0],
    [[DCFeatureItem alloc] initWithFeature:DCTaskFeatureLocalShortTask quota:5 priority:0],
    [[DCFeatureItem alloc] initWithFeature:DCTaskFeatureDataRequest quota:2 priority:1],
    [[DCFeatureItem alloc] initWithFeature:DCTaskFeatureStreamDownload quota:2 priority:1],
    [[DCFeatureItem alloc] initWithFeature:DCTaskFeatureStreamUpload quota:2 priority:1],
    [[DCFeatureItem alloc] initWithFeature:DCTaskFeatureLocalLongTask quota:2 priority:1]
    ];
}


-(DCFeatureItem*) itemForFeature:(DCTaskFeature) feature {
    return [_features objectAtIndex:(int)feature];
}

@end
