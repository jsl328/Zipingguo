//
//  ShengpiHeaderViewCell.m
//  Zipingguo
//
//  Created by jiangshilin on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ShengpiHeaderViewCell.h"

@implementation ShengpiHeaderViewCell
+(ShengpiHeaderViewCell *)cellForTableview:(UITableView *)tableview
{
    ShengpiHeaderViewCell *cell = [tableview dequeueReusableCellWithIdentifier:[[self class] description]];
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
        _nameLabel.text =_vm.flowName;
        _titleLabel.text =_vm.dealTime?_vm.dealTime:@"";
        
        float TW;
        float TH;
        UIImage *image;
        if (_vm.Leixing == 1) {
            image=[UIImage imageNamed:@"通过icon"];
            TW =image.size.width;
            TH =image.size.height;
        }else if (_vm.Leixing ==2){
            image=[UIImage imageNamed:@"未通过icon"];
            TW =image.size.width;
            TH =image.size.height;
        }else{
            image=[UIImage imageNamed:@"待审批icon"];
            TW =image.size.width;
            TH =image.size.height;
        }
        _zhuangTaiImageView.frame =CGRectMake(ScreenWidth-15-TW, (self.frame.size.height-TH)/2, TW, TH);
        _zhuangTaiImageView.image =image;
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.frame =CGRectMake(0, 0, ScreenWidth,68.f);
}

@end
