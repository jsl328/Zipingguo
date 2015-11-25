//
//  JJBaseButton.m
//  JinJiangDuCheng
//
//  Created by Perry on 15/4/8.
//  Copyright (c) 2015年 SmartJ. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.titleLabel setFont:[MyFontAdapter adjustFont:self.titleLabel.font]];
}

@end
