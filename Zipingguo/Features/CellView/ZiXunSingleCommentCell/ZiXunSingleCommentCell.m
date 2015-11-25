//
//  ZiXunSingleCommentCell.m
//  Zipingguo
//
//  Created by sunny on 15/11/6.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunSingleCommentCell.h"
#import "UILabel+Extension.h"

@implementation ZiXunSingleCommentCell
@synthesize replyLabel;

- (void)awakeFromNib {
    // Initialization code
}
+ (instancetype)cellForTableView:(UITableView *)tableView{
    ZiXunSingleCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell =  [[[NSBundle mainBundle]loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;

}
- (void)setModel:(ZiXunSingleCommentModel *)model{
    if (model) {
        _model = model;
        
        if (model.isMoreOrLess == NO) {
            NSString *neiRong = [NSString stringWithFormat:@"%@回复%@:%@",model.createname,model.relusername,model.content];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:neiRong];
            [attributedString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(95, 115, 154, 1) range:[neiRong rangeOfString:model.createname]];
            [attributedString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(53, 56, 68, 1) range:[neiRong rangeOfString:@"回复"]];
            [attributedString addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(95, 115, 154, 1) range:[neiRong rangeOfString:model.relusername]];
            replyLabel.attributedText = attributedString;
            CGFloat neiRongHeight =  [replyLabel getLabelSizeWithLabelMaxWidth:ScreenWidth - 95 MaxHeight:MAXFLOAT FontSize:[UIFont systemFontOfSize:12] LabelText:replyLabel.text].height;
            replyLabel.frame = CGRectMake(10, 4, ScreenWidth - 95, neiRongHeight);

        }else{
            
            replyLabel.text = model.createname;
            replyLabel.textColor = RGBACOLOR(95, 115, 154, 1);
            replyLabel.frame = CGRectMake(10, 4, ScreenWidth - 95, 20);
        }
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
