//
//  PingLunTableViewCell.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/15.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "PingLunTableViewCell.h"

@implementation PingLunTableViewCell

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setModel:(PingLunTableViewCellModel *)model{

    if (model) {
        _model = model;
        if (model.huifurenName.length > 0) {//回复
            
            NSString *huifurenName = [NSString stringWithFormat:@" 回复%@",model.huifurenName];
            NSString *tempStr = [model.name stringByAppendingString:huifurenName];
            
            NSMutableAttributedString  *titleAttributedStr = [[NSMutableAttributedString alloc]initWithString:tempStr];
            [titleAttributedStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(95, 115, 154, 1) range:[tempStr rangeOfString:huifurenName]];
            [titleAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:[tempStr rangeOfString:huifurenName]];

            _titleLabel.attributedText = titleAttributedStr;
            
        }else{
            _titleLabel.text = model.name;
        }
     
//        _titleLabel.text = model.name;
        _shijianLabel.text = model.shijian;
        [_touXiangImageView setUrl:model.touxiangUrl fileName:@"头像40.png"];
//        if (model.huifurenName.length > 0) {//回复
//            
//            NSString *aiteName = [NSString stringWithFormat:@"@%@",model.huifurenName];
//            NSString *tempStr = [aiteName stringByAppendingString:model.neiRong];
//            
//            NSMutableAttributedString  *titleAttributedStr = [[NSMutableAttributedString alloc]initWithString:tempStr];
//            [titleAttributedStr addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(4, 175, 245, 1) range:[tempStr rangeOfString:aiteName]];
//            _neiRongLabel.attributedText = titleAttributedStr;
//
//        }else{
//            _neiRongLabel.text = model.neiRong;
//
//        }
//
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate*confromTimesp = [formatter dateFromString:model.shijian];
        _shijianLabel.text = [confromTimesp formattedTime];
        _neiRongLabel.text = model.neiRong;
        [_neiRongLabel sizeToFit];
        
    }
}

- (void)awakeFromNib {
    // Initialization code
    [_touXiangImageView setCircle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation PingLunTableViewCellModel


@end