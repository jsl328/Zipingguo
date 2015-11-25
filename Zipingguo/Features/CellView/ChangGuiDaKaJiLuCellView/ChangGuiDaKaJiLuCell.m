//
//  ChangGuiDaKaJiLuCell.m
//  Zipingguo
//
//  Created by sunny on 15/10/19.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ChangGuiDaKaJiLuCell.h"
#import "UILabel+Extension.h"

@implementation ChangGuiDaKaJiLuCell
@synthesize contentLabel,timeLabel;

- (void)awakeFromNib {
    // Initialization code
}
+ (ChangGuiDaKaJiLuCell *)cellForTableView:(UITableView *)tableView{
    ChangGuiDaKaJiLuCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"ChangGuiDaKaJiLuCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setModel:(ChangGuiDaKaJiLuModel *)model{
    if (model) {
        contentLabel.text = [NSString stringWithFormat:@"%@  %@",model.time,model.address];
        [contentLabel addAttributeWithString:contentLabel.text andColorValue:RGBACOLOR(4, 175, 245, 1) andUIFont:[UIFont systemFontOfSize:18] andRangeString:model.time];
//        contentLabel.text = @"08:50  朝阳区建国里88号SOHO现代城D座";
//        [contentLabel addAttributeWithString:contentLabel.text andColorValue:RGBACOLOR(4, 175, 245, 1) andUIFont:[UIFont systemFontOfSize:18] andRangeString:@"08:50"];
//        timeLabel.text = model.time;
//        contentLabel.text = model.address;
    }
    [self layoutIfNeeded];
}
- (void)layoutSubviews{
    [super layoutSubviews];
//    timeLabel.frame = CGRectMake(15, timeLabel.y, 55, timeLabel.height);
//    contentLabel.frame = CGRectMake(CGRectGetMaxX(timeLabel.frame) + 2, contentLabel.y, ScreenWidth - CGRectGetMaxX(timeLabel.frame) - 2 - 10, contentLabel.height);
    contentLabel.frame = CGRectMake(15, contentLabel.y, ScreenWidth - 30, contentLabel.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
