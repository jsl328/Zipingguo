//
//  RenWuTableViewCell.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuTableViewCell.h"

#import "UILabel+Extension.h"

@implementation RenWuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] firstObject];
    }
    return self;
}

- (void)bindDataWithModel:(RenWuModel *)model{
    
    [self setUIColorWith:model];
}
- (void)setUIColorWith:(RenWuModel *)model{
    NSString *imageName;
    RenwuModel = model;
    // 已完成
    if (model.isFinish) {
        if (model.isZhongYao == 2)imageName = @"重要icon灰"; else imageName = @"普通icon灰";
        secondRenWuNameLabel.textColor = RGBACOLOR(208, 208, 209, 1);
        firstRenWuNameLabel.textColor = RGBACOLOR(208, 208, 209, 1);
        personNameLabel.textColor = RGBACOLOR(208, 208, 209, 1);
        
    }else{
        if (model.isZhongYao == 2)imageName = @"重要icon"; else imageName = @"普通icon";
        secondRenWuNameLabel.textColor = RGBACOLOR(53, 55, 68, 1);
        firstRenWuNameLabel.textColor = RGBACOLOR(53, 55, 68, 1);
        personNameLabel.textColor = RGBACOLOR(160, 160, 162, 1);
        
    }
    iconImageView.image = [UIImage imageNamed:imageName];
    if (model.type ==1 ) {
        firstRenWuNameLabel.text = model.renWuName;
        personNameLabel.text = [NSString stringWithFormat:@"%@分配",model.personName];
        secondRenWuNameLabel.hidden = YES;
        personNameLabel.hidden = NO;
        firstRenWuNameLabel.hidden = NO;
    }else{
        secondRenWuNameLabel.text = model.renWuName;
        kuanjieRenwu.constant = -iconImageView.width;
        iconImageView.hidden = YES;
        secondRenWuNameLabel.hidden = NO;
        personNameLabel.hidden = YES;
        firstRenWuNameLabel.hidden = YES;
    }
    [self layoutSubviews];

}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 修改cell删除键背景色
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            UIView *bView = (UIView *)[subView.subviews firstObject];
            if (!RenwuModel.isFinish) {
                bView.backgroundColor = RGBACOLOR(4, 175, 245, 1);// 修改背景颜色
            }else{
                bView.backgroundColor = [UIColor redColor];// 修改背景颜色
            }
            for (UIView *view in bView.subviews) {
                if ([NSStringFromClass([view class]) isEqualToString:@"UIButtonLabel"]) {
                    UILabel *label = (UILabel *)view;
                    [label setFont:[UIFont systemFontOfSize:14]];// 修改字体大小
                    label.textColor = [UIColor whiteColor];
                }
            }
        }
    }
}
@end
