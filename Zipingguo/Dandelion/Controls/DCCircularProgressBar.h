//
//  DCCircularProgressBar.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-10.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTickTimer.h"

@interface DCCircularProgressBar : UIView <DCTickTimerDelegate>

@property (nonatomic) float rotatedAngle;
@property (nonatomic) float ringWidth;
@property (nonatomic) float progress;
@property (retain, nonatomic) UIColor* brightColor;
@property (retain, nonatomic) UIColor* faintColor;
@property (nonatomic) BOOL isRotating;

@end
