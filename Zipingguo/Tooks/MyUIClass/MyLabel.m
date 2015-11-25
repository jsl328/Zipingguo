//
//  JJLabel.m
//  JinJiangDuCheng
//
//  Created by Perry on 15/3/23.
//  Copyright (c) 2015年 SmartJ. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    [super setFont:[MyFontAdapter adjustFont:self.font]];
}

-(void)setFont:(UIFont *)font{
    [super setFont:[MyFontAdapter adjustFont:font]];
}

@end
