//
//  ShengpiDetailViewCell.m
//  Zipingguo
//
//  Created by jiangshilin on 15/10/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ShengpiDetailViewCell.h"

@implementation ShengpiDetailViewCell
+(ShengpiDetailViewCell *)cellForTableview:(UITableView *)tableview
{
    ShengpiDetailViewCell *cell;
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setVm:(ShengPiCellVM *)vm
{
    if (vm) {
        _vm =vm;
        _chNameLabel.text =vm.chname;
        _contentName.text = vm.content;
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //NSLog(@"ddd%f",self.frame.size.height);
    _ShouQiButton.hidden = !_vm.isfirst;
    CGRect frame =_ShouQiButton.frame;
    if (_vm.isfirst) {
        frame.size.width =ScreenWidth-65-130.f;
        if (_vm.isSelected) {
            frame =_chNameLabel.frame;
            _chNameLabel.frame =CGRectMake(frame.origin.x, frame.size.height/2, frame.size.width, frame.size.height);
        }
        _contentName.frame =CGRectMake(115, 0, frame.size.width, self.frame.size.height);
    }else{
        frame = _chNameLabel.frame;
        _contentName.frame =CGRectMake(115, 0, ScreenWidth-frame.size.width-frame.origin.x-15, self.frame.size.height);
    }
    
    if (_vm.iszhuanJiao) {
        _contentName.textColor =RGBACOLOR(123., 192., 69., 1);
    }
    
    [_ShouQiButton setTitle:_vm.isSelected?@"展开":@"收起" forState:UIControlStateNormal];
}

- (IBAction)ShouqiAciton:(UIButton *)sender {
    _vm.isSelected = !_vm.isSelected;
    if ([_vm.delegate respondsToSelector:@selector(shengpiVm:)]) {
        [_vm.delegate shengpiVm:_vm];
    }
}
@end
