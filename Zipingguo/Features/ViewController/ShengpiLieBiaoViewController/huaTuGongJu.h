//
//  huaTuGongJu.h
//  jianbihua
//
//  Created by Quanhong on 14-3-27.
//  Copyright (c) 2014年 Quanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface huaTuGongJu : UIBezierPath
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineAlpha;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)setInitialPoint:(CGPoint)firstPoint;
- (void)moveFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

- (void)draw;
@end
