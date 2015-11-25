//
//  BodyTableViewCell.m
//  Zipingguo
//
//  Created by jiangshilin on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "BodyTableViewCell.h"

@implementation BodyTableViewCell
+(BodyTableViewCell *)cellForTableview:(UITableView *)tableview
{
    BodyTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setVm:(ShengPiCellVM *)vm
{
    if (vm) {
        _vm = vm;
        if (!_vm.istime) {
            _contentLabel.frame =CGRectMake(15, 30., ScreenWidth-30,_vm.cellHeight);
        }else{
            _contentLabel.frame =CGRectMake(115, 12, ScreenWidth-160,21.f);
        }
        _titleLabel.text = _vm.title;
        _contentLabel.text = _vm.content;
    }
    [self setNeedsLayout];
}
@end
