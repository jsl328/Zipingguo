//
//  PiYueRenTableViewCell.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/16.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "PiYueRenTableViewCell.h"

@implementation PiYueRenTableViewCell

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

-(void)setModel:(PiYueRenTableViewCellModel *)model{
    if (model) {
        _model = model;
        _titleLabel.text = model.title;
        NSString *name = [model.name componentsJoinedByString:@" "];
        _xingmingLabel.text = name;
        _xingmingLabel.size = CGSizeMake(ScreenWidth - 125, model.cellHeight - 28);
        if (model.isCanShouQi) {//是否可以收起
            _shouqiBtn.hidden = NO;
            if(model._isShouQi){//收起状态
                [_shouqiBtn setTitle:@"展开" forState:UIControlStateNormal];
            }else{
                [_shouqiBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
        }else{
            _shouqiBtn.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _xingmingLabel.size = CGSizeMake(ScreenWidth - 125, _model.cellHeight - 28);

}
- (IBAction)shouqiClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"收起"]) {
        if ([_delegate respondsToSelector:@selector(shouqiOrZhankaiChaoSongRen:)]) {
            [_delegate shouqiOrZhankaiChaoSongRen:YES];
        }
        [sender setTitle:@"展开" forState:UIControlStateNormal];
    }else{
        if ([_delegate respondsToSelector:@selector(shouqiOrZhankaiChaoSongRen:)]) {
            [_delegate shouqiOrZhankaiChaoSongRen:NO];
        }
        [sender setTitle:@"收起" forState:UIControlStateNormal];
    }
}
@end


@implementation PiYueRenTableViewCellModel


@end