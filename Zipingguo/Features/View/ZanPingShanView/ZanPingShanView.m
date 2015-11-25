//
//  ZanPingShanView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZanPingShanView.h"

@implementation ZanPingShanView

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ZanPingShanView" owner:self options:nil]lastObject];
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


- (void)layoutSubviews{
    [super layoutSubviews];
    _shanchuBtn.frame = CGRectMake(_shanchuBtn.frame.origin.x, _shanchuBtn.frame.origin.y, _shanchuBtn.frame.size.width, _shanchuBtn.frame.size.height);
    
    _pinglunBtn.frame = CGRectMake(self.width-15-_pinglunBtn.frame.size.width, _pinglunBtn.frame.origin.y, _pinglunBtn.frame.size.width, _pinglunBtn.frame.size.height);
    
    _dianzanBtn.frame = CGRectMake(_pinglunBtn.frame.origin.x-_dianzanBtn.frame.size.width, _dianzanBtn.frame.origin.y, _dianzanBtn.frame.size.width, _dianzanBtn.frame.size.height);
    
    _addles.frame = CGRectMake(_shanchuBtn.frame.origin.x+_shanchuBtn.frame.size.width, _addles.frame.origin.y, ScreenWidth-_shanchuBtn.frame.origin.x-_shanchuBtn.frame.size.width- _dianzanBtn.frame.size.width-_pinglunBtn.frame.size.width-10, _addles.frame.size.height);
    
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == _shanchuBtn) {
        [self.delegate shanchuFangfa];
    }else if (sender == _dianzanBtn){
        if (_dianzanBtn.selected) {
            _dianzanBtn.selected = YES;
            [self.delegate quxiaoDianzanFangfa];
        }else{
           _dianzanBtn.selected = NO;
            [self.delegate dianzanFangfa];
        }
    }else if (sender == _pinglunBtn){
        [self.delegate pinglunFangfa];
    }
}

@end
