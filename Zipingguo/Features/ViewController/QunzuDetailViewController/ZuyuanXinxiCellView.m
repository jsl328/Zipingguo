//
//  ZuyuanXinxiCellView.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-15.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ZuyuanXinxiCellView.h"

@implementation ZuyuanXinxiCellView
@synthesize cellView;
- (void)bind:(ZuyuanXinxiCellVM *)model{
    cellView = model;
    _shanchuButton.hidden = !model.anNiuZhuangtai;
    
    if (model.shanrenZhuangtai == NO && model.jiarenZhuangtai == NO) {
        [_touxiangImageFrame setUrl:model.touxiangString fileName:@"头像80.png" Width:_touxiangImageFrame.frame.size.width];
        _nameLabel.text = model.name;
        _nameLabel.hidden = NO;
        _touxiangImageFrame.hidden = NO;
        _tianjiaChengyuanButton.hidden = YES;
        _shanjianButton.hidden = YES;
    }else if (model.shanrenZhuangtai) {
        //删人按钮
        _nameLabel.hidden = YES;
        _touxiangImageFrame.hidden = YES;
        //_shanjianButton.center = CGPointMake(self.center.x, self.center.y);
        _shanjianButton.hidden = NO;
        _shanchuButton.hidden = YES;
    }else if (model.jiarenZhuangtai) {
        //加人按钮
        _nameLabel.hidden = YES;
        _touxiangImageFrame.hidden = YES;
        _tianjiaChengyuanButton.hidden = NO;
        //_tianjiaChengyuanButton.center = CGPointMake(self.center.x, self.center.y);
        _shanchuButton.hidden = YES;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];

}

- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == _tianjiaChengyuanButton) {
        [cellView.delegate jiarenFangfa];
    }else if (sender == _shanjianButton){
        [cellView.delegate shanrenFangfa];
    }else if (sender == _shanchuButton){
        [cellView.delegate yichuFangfa:cellView.key];
        //[cellView.delegate shanchu:cellView];
    }
}
@end
