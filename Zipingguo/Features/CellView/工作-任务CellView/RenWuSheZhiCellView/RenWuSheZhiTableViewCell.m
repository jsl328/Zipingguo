//
//  RenWuSheZhiTableViewCell.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuSheZhiTableViewCell.h"

@implementation RenWuSheZhiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] firstObject];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
- (void)bindData:(RenWuSheZhiModel *)model{
    iconImageView.hidden = !model.cellState;
    nameLabel.text = model.cellName;
    nameLabel.textColor = RGBACOLOR(53, 55, 68, 1);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
