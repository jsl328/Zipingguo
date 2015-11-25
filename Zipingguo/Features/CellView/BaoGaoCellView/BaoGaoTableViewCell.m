//
//  BaoGaoTableViewCell.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "BaoGaoTableViewCell.h"

@implementation BaoGaoTableViewCell

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
    [_isRead setCircle];
}


- (void)setModel:(BaoGaoTableViewCellVM *)model{
    if (model) {
        _model = model;
        _shijian.text = model.shijian;
        if (model.leixing == 1) {//日报
            _leixing.hidden = YES;
        }else if(model.leixing == 2){//周报
            _leixing.hidden = NO;
            _leixing.image = [UIImage imageNamed:@"周"];
        }else{
            _leixing.hidden = NO;
            _leixing.image = [UIImage imageNamed:@"月"];
        }
        _isRead.hidden = model.isRead;//是否已读
        
        if(model.isCaogao){
        
//            NSString *titleStr = [model.title stringByAppendingString:@" [草稿]"];
            NSString *titleStr = [@"[草稿] " stringByAppendingString:model.title];
            
            NSMutableAttributedString  *titleAttributedStr = [[NSMutableAttributedString alloc]initWithString:titleStr];

//            [titleAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(model.title.length, titleStr.length - model.title.length) ];

            [titleAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[titleStr rangeOfString:@"[草稿] "]];
            _title.attributedText = titleAttributedStr;

        }else{
            _title.text = model.title;

        }
    
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation BaoGaoTableViewCellVM
@end
