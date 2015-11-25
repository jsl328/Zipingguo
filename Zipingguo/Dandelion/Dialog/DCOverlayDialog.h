//
//  DCOverlayDialog.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDialog.h"

@interface DCOverlayDialog : DCDialog

@property (retain, nonatomic) id content;
@property (nonatomic) CGSize size;
@property (nonatomic) DCHorizontalGravity horizontalGravity;
@property (nonatomic) DCVerticalGravity verticalGravity;
@property (nonatomic) UIEdgeInsets padding;
@property (nonatomic) int inAnimation;
@property (nonatomic) int outAnimation;
@property (nonatomic) BOOL clickToClose;

@end
