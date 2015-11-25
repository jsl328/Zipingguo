//
//  UIView+Frame.h
//  lvdongqing
//
//  Created by lilufeng on 15/8/19.
//  Copyright (c) 2015年 LinkU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

// 直接获取view的x轴坐标
@property (nonatomic, assign) CGFloat x;
// 直接获取view的y轴坐标
@property (nonatomic, assign) CGFloat y;
// 直接获取view的中心点x坐标
@property (nonatomic, assign) CGFloat centerX;
// 直接获取view的中心点y轴坐标
@property (nonatomic, assign) CGFloat centerY;
// 直接获取view宽度
@property (nonatomic, assign) CGFloat width;
// 直接获取view高度
@property (nonatomic, assign) CGFloat height;
// 直接获取view大小尺寸
@property (nonatomic,assign) CGSize size;

- (void)setCircle;/**<设置为圆形*/
- (void)setBianKuangWithCornerRadius:(int)cornerRadius andBorderWidth:(float)borderWidth andColor:(UIColor*)color;/**<设置圆角属性*/

@end
