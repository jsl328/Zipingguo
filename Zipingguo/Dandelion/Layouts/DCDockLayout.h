//
//  DCDockLayout.h
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCViewGroup.h"

@interface DCDockLayout : DCViewGroup

@property (nonatomic) DCOrientation orientation;
@property (nonatomic) int centerViewIndex;

@end
