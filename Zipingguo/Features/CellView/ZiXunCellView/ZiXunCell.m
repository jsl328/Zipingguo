//
//  ZiXunCell.m
//  Zipingguo
//
//  Created by sunny on 15/10/12.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunCell.h"

@implementation ZiXunCell
@synthesize iconImageView,titleNameLabel,timeAndCommentCout;

+ (ZiXunCell *)cellForTableView:(UITableView *)tableView{
    ZiXunCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZiXunCell" owner:self options:nil] lastObject];
    }
    return cell;
}
- (void)setModel:(ZiXunCellModel *)model{
    if (model) {
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLKEY,model.iconImage]] placeholderImage:[UIImage imageNamed:@"图片222.png"]];
        titleNameLabel.text = model.titleName;
        if (model.time.length == 19) {
            //        _shijian.text = [model.shijian substringToIndex:16];
            titleNameLabel.text=[NSString stringWithFormat:@"%@          评论:(%d)",[model.time substringToIndex:16],model.commentCount];
        }else{
            timeAndCommentCout.text=[NSString stringWithFormat:@"%@          评论:(%d)",model.time,model.commentCount];
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
