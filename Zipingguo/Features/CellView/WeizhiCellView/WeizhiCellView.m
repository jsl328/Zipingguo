//
//  WeizhiCellView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/14.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WeizhiCellView.h"

@implementation WeizhiCellView

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(WeizhiModel *)model{
    name.text = model.name;
    jutidizhi.text = model.jutidizhi;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
