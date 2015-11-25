//
//  DongtaiXialaView.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-6.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "DongtaiXialaView.h"

@implementation DongtaiXialaView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"DongtaiXialaView" owner:self options:nil]lastObject];
    }
    return self;
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == _quanbudongtaiButton) {
        [self.delegate quanbuDongtaiFangfa];
    }else if (sender == _yaoqingwodedongtaiButton) {
        [self.delegate yaoQingWodeDongtaiFangfa];
    }else if (sender == _wodeguanzhuButton){
        [self.delegate wodeGuanzhuFangfa];
    }else if(sender == _wodedongtaiButton){
        [self.delegate wodeDongtaiFangfa];
    }else if(sender == _woshoucangdeButton){
        [self.delegate woshoucangdeFangfa];
    }
}
@end
