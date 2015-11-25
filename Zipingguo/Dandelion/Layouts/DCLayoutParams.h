//
//  DCLayoutParams.h
//  DandelionDemo
//
//  Created by Bob Li on 14-2-7.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCLayoutParams : NSObject
@property (nonatomic) float width;
@property (nonatomic) float height;
@property (nonatomic) DCHorizontalGravity horizontalGravity;
@property (nonatomic) DCVerticalGravity verticalGravity;
@property (nonatomic) float weight;

@end
