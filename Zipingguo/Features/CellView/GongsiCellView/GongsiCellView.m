//
//  GongsiCellView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "GongsiCellView.h"

@implementation GongsiCellView

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(GongsiModel *)model{
    gongsiName.text = model.data2.name;
    
    if (model.Isjiechu) {
        xuanzhongImageView.hidden = NO;
        
        if (model.isSelect) {
            xuanzhongImageView.image = [UIImage imageNamed:model.selIcon];

        }else{
            xuanzhongImageView.image = [UIImage imageNamed:model.icon];
        }
        
    }else{
        xuanzhongImageView.image = [UIImage imageNamed:model.icon];
        
        if (model.isSelect) {
            xuanzhongImageView.hidden = NO;
        }else{
            xuanzhongImageView.hidden = YES;
        }
    }
 
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
