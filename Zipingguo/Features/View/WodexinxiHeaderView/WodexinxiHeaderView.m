//
//  WodexinxiHeaderView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WodexinxiHeaderView.h"

@implementation WodexinxiHeaderView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"WodexinxiHeaderView" owner:self options:nil]lastObject];
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
- (IBAction)touxiangShangchuan:(UIButton *)sender {
    [self.delegate touxiangShangchuan];
}

@end
