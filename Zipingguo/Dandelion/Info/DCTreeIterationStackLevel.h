//
//  DCTreeInterationStackLevel.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-1.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCTreeIterationStackLevel : NSObject

@property (retain, nonatomic) id node;
@property (retain, nonatomic) NSArray* subNodes;
@property (nonatomic) int subNodeIndex;

@end
