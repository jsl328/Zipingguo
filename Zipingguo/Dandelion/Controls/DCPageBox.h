//
//  DCPageBox.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-27.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHandleDirection.h"

@interface DCPageBox : UIView <DCHandleDirection>

@property (retain, nonatomic) NSArray* items;
@property (nonatomic) int selectedPageIndex;

@end
