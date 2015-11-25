//
//  GongzuoViewCell.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "GongzuoViewCell.h"

@implementation GongzuoViewCell
+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(GongzuoModel *)model{
    icon.image = [UIImage imageNamed:model.icon];
    biaoti.text = model.name;
    if (model.neirong.length != 0) {
        neirong.text = model.neirong;
        weidu.hidden = NO;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    weidu.frame = CGRectMake(neirong.frame.size.width+neirong.frame.origin.x, weidu.frame.origin.y, weidu.frame.size.width, weidu.frame.size.width);

}

@end
