//
//  JinRiDaKaJiLuCell.m
//  Zipingguo
//
//  Created by sunny on 15/10/16.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "JinRiDaKaJiLuCell.h"

@implementation JinRiDaKaJiLuCell
@synthesize timeLabel,addressNameLabel;

+ (JinRiDaKaJiLuCell *)cellForTableView:(UITableView *)tableView{
    JinRiDaKaJiLuCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JinRiDaKaJiLuCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(JinRiDaKaJiLuModel *)model{
    if (model) {
        timeLabel.text = model.time;
        addressNameLabel.text = model.addressName;
    }
    [self layoutSubviews];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    timeLabel.frame = CGRectMake(10, timeLabel.y, 45, timeLabel.height);
    addressNameLabel.frame = CGRectMake(CGRectGetMaxX(timeLabel.frame) + 12, addressNameLabel.y, ScreenWidth - 15 - 10 - CGRectGetMaxX(timeLabel.frame)  - 12, addressNameLabel.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
