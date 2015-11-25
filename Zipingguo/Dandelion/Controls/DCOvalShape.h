//
//  DCShapeButton.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-26.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCOvalShape : UIControl

@property (nonatomic) int borderWidth;
@property (retain, nonatomic) UIColor* borderColor;
@property (retain, nonatomic) UIColor* normalBackgroundColor;
@property (retain, nonatomic) UIColor* pressedBackgroundColor;

@end
