//
//  HuaTuView.h
//  jianbihua
//
//  Created by Quanhong on 14-3-27.
//  Copyright (c) 2014年 Quanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "huaTuGongJu.h"
@interface HuaTuView : UIView
{
    UIColor *lineColor;
    CGFloat lineWidth;
    CGFloat lineAlpha;
    huaTuGongJu *gongJu;
}
@property (nonatomic, strong) NSMutableArray *pathArray;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isHua;
- (void)clear;
@end
