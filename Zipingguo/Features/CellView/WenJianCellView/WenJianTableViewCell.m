//
//  WenJianTableViewCell.m
//  Zipingguo
//
//  Created by lilufeng on 15/11/6.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "WenJianTableViewCell.h"

@implementation WenJianTableViewCell

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(WenJianTableViewCellModel *)model{

    _model = model;
    _titleLabel.text = model.title;
    _tuPianImage.image = model.image;
}

- (IBAction)deleteClick:(id)sender{
    if([self.delegate respondsToSelector:@selector(wenJianTableViewCellDelete:)]){
    
        [self.delegate wenJianTableViewCellDelete:_model];
    }
    
}
@end


@implementation WenJianTableViewCellModel



@end