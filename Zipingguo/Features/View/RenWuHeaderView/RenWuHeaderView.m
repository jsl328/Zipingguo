//
//  RenWuHeaderView.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuHeaderView.h"

@implementation RenWuHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"RenWuHeaderView" owner:self options:nil]firstObject];
    }
    return self;
}
- (void)awakeFromNib{
    firstLabel.textColor = RGBACOLOR(140, 140, 140, 1);
    secondLabel.textColor = RGBACOLOR(140, 140, 140, 1);
}
-(void)setSection:(NSInteger)section{
    if (section==0) {
        secondLabel.hidden = YES;
        self.backgroundColor = RGBACOLOR(243, 243, 243, 1);
    }else{
        firstLabel.hidden = YES;
        iconImageView.hidden = YES;
        self.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    }
}
- (IBAction)addButtonClick:(id)sender {
    if (self.addRenWu) {
        self.addRenWu();
    }
}
@end
