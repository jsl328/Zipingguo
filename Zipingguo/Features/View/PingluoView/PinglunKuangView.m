//
//  PinglunKuangView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/25.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "PinglunKuangView.h"

@implementation PinglunKuangView


- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PinglunKuangView" owner:self options:nil]lastObject];
    }
    
//    _fabiaoPinglun.maxLength = 
    
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
    if (sender == _yaoqingRenBtn) {
        [self.delegate yaoqingRenyuanFangfa];
    }else if (sender == _fasongBtn){
        [self.delegate fasongFangfaWithDongtaiID:self.ID Isreply:self.Isreply Topparid:self.Topparid];
    }
}

@end
