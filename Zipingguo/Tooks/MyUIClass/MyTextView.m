//
//  MBTextViewWithFontAdapter.m
//  MBFontAdapter
//
//  Created by Perry on 15/6/15.
//  Copyright (c) 2015年 MmoaaY. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView

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
