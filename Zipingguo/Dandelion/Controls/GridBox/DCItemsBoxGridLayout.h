//
//  DCItemsBoxGridLayout.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-11.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCItemsBoxColumnedLayout.h"

@interface DCItemsBoxGridLayout : DCItemsBoxColumnedLayout

@property (nonatomic) float itemGap;
@property (nonatomic) float rowGap;
@property (nonatomic) float rowHeight;

@end
