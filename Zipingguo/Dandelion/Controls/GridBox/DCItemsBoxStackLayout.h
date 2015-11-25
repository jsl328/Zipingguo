//
//  DCItemsBoxInterleavingStackLayout.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-25.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCItemsBoxLayout.h"

@interface DCItemsBoxStackLayout : DCItemsBoxLayout

@property (nonatomic) float rowGap;
@property (nonatomic) float cellWidth;
@property (nonatomic) float cellHeight;
@property (nonatomic) DCHorizontalGravity cellHorizontalGravity;

@end
