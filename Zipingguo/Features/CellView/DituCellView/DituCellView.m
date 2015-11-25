//
//  DituCellView.m
//  CeshiOA
//
//  Created by jiangshilin on 14-8-8.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "DituCellView.h"

@implementation DituCellView

- (void)bind:(DituCellViewVM *)model{
    NSLog(@"%@",model.jutiXinxi);
    viewVM = model;
    _dizhiXinxiLabel.text = model.dizhiXinxi;
    _jutiXinxiLabel.text = model.jutiXinxi;
    [self size];
}

- (void)size{
    
    _tubiaoImageView.frame = CGRectMake(20, (self.frame.size.height-30)/2, 30, 30);
    
    CGSize nameSize  = [_dizhiXinxiLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(self.frame.size.width-70,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    CGSize addressSize  = [_jutiXinxiLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(self.frame.size.width-70,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    _dizhiXinxiLabel.frame = CGRectMake(60, 10, self.frame.size.width-70, nameSize.height);
    _jutiXinxiLabel.frame = CGRectMake(60, _dizhiXinxiLabel.frame.size.height+_dizhiXinxiLabel.frame.origin.y+5, self.frame.size.width-70, addressSize.height);
    _xianImageView.frame = CGRectMake(20, self.frame.size.height-1, self.frame.size.width-20, 1);
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self size];
}

@end
