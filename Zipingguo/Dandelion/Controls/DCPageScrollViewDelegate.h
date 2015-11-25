//
//  DCPageScrollViewDelegate.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-7.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCPageScrollView.h"

@class DCPageScrollView;

@protocol DCPageScrollViewDelegate <NSObject>
-(void) pageScrollView:(DCPageScrollView*) pageScrollView pageIndexDidChangeBySliding:(int) pageIndex;
@end
