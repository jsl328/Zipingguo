//
//  JJBaseTextField.m
//  JinJiangDuCheng
//
//  Created by Perry on 15/4/8.
//  Copyright (c) 2015年 SmartJ. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

-(void)awakeFromNib{
    [super awakeFromNib];
    [super setFont:[MyFontAdapter adjustFont:self.font]];
}

-(void)setFont:(UIFont *)font{
    [super setFont:[MyFontAdapter adjustFont:font]];
}

@end
