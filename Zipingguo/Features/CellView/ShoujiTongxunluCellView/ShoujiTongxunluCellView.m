//
//  ShoujiTongxunluCellView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/31.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ShoujiTongxunluCellView.h"

@implementation ShoujiTongxunluCellView

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(ShoujiTongxunluModel *)model{
    
    if (model.endure) {
        xuanzhongImageView.image = [UIImage imageNamed:model.endueIcon];
        
    }else{
        if (model.isSelect) {
            xuanzhongImageView.image = [UIImage imageNamed:model.selIcon];
            
        }else{
            xuanzhongImageView.image = [UIImage imageNamed:model.icon];
        }
    }
    
    name.text = model.name;
    dianhua.text = model.phone;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
