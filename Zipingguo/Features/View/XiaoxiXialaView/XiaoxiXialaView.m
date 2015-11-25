//
//  XiaoxiXialaView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XiaoxiXialaView.h"

@implementation XiaoxiXialaView


- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"XiaoxiXialaView" owner:self options:nil]lastObject];
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
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == liaotian) {
        [self.delegate xinjianLiaotian];
    }else if (sender == daka){
        [self.delegate kuansuDaka];
    }else if (sender == ribao){
        [self.delegate xinjianRibao];
    }else if (sender == renwu){
        [self.delegate xinjianRenwu];
    }
}

@end
