//
//  RenWuDetailTopView.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuDetailTopView.h"

@implementation RenWuDetailTopView
{
    NSMutableArray *valueLabelArray;
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RenWuDetailTopView" owner:self options:nil]firstObject];
    }
    return self;
}
- (void)bindData{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    for (int i=0; i<6; i++) {
        UIView *view = [self viewWithTag:10+i];
        UILabel *label = (UILabel *)view;
        label.textColor = RGBACOLOR(160, 160, 162, 1);
    }
    for (int i=0; i<6; i++) {
        UIView *view = [self viewWithTag:100+i];
        UILabel *label = (UILabel *)view;
        label.textColor = RGBACOLOR(53, 55, 68, 1);
    }
    UIView *view = [self viewWithTag:1000];
    UILabel *label = (UILabel *)view;
    label.textColor = RGBACOLOR(53, 55, 68, 1);
    
    UIView *view1 = [self viewWithTag:1002];
    UILabel *label1 = (UILabel *)view1;
    label1.textColor = RGBACOLOR(160, 160, 162, 1);
    
    UIView *view2 = [self viewWithTag:1002];
    UILabel *label2 = (UILabel *)view2;
    label2.textColor = RGBACOLOR(53, 55, 68, 1);
    
    UIView *view3 = [self viewWithTag:1002];
    UILabel *label3 = (UILabel *)view3;
    label3.textColor = RGBACOLOR(160, 160, 162, 1);
}
@end
