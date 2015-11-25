//
//  DCToastView.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-22.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCToast : NSObject

@property (retain, nonatomic) id content;
@property (nonatomic) CGSize size;
@property (nonatomic) DCHorizontalGravity horizontalGravity;
@property (nonatomic) DCVerticalGravity verticalGravity;
@property (nonatomic) UIEdgeInsets padding;
@property (nonatomic) int inAnimation;
@property (nonatomic) int outAnimation;

-(void) showShort;

-(void) showLong;

@end
