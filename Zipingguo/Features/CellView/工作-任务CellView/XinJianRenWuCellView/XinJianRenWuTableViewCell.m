//
//  XinJianRenWuTableViewCell.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XinJianRenWuTableViewCell.h"

@implementation XinJianRenWuTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
   
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] firstObject];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)bindDataWithModel:(XinJianRenWuModel *)model{
    titleNameLabel.text = model.cellName;
    valueLabel.text = model.cellValue;
    if ([model.cellName isEqualToString:@"重要度"]) {
        if ([model.cellValue isEqualToString:@"重要"]) {
            valueLabel.textColor = RGBACOLOR(248, 83, 111, 1);
        }else{
            valueLabel.textColor = RGBACOLOR(123, 192, 69, 1);
        }
    }else{
        valueLabel.textColor = RGBACOLOR(53, 55, 68, 1);
    }
    if (model.width>0)
        lineImageView.hidden = YES;
    else
        lineImageView2.hidden = YES;
    iconImageView.hidden = !model.isCanEdit;
    if (model.isCanEdit)
        leftConstraint.constant = -20;
    else
        leftConstraint.constant = 0;
}
- (void)awakeFromNib {
    // Initialization code
    titleNameLabel.textColor = RGBACOLOR(160, 160, 162, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
