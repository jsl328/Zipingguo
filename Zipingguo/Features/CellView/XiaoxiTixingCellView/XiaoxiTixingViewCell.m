//
//  XiaoxiTixingViewCell.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XiaoxiTixingViewCell.h"

@implementation XiaoxiTixingViewCell

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(XiaoxiTixingModel *)model{
    Model = model;
    name.text = model.optionSM.name;
    
    if (model.optionSM.isReceive == 1) {
        kaiguan.on = YES;
    }else{
        kaiguan.on = NO;
    }

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)switchClick:(UISwitch *)sender {
    if ([Model.optionSM.name isEqualToString:@"聊天"]) {
        [Model.delegate shezhiShifouJieshouxinXiaoxi:Model.optionSM._id switch:kaiguan.on isLiaotian:YES];
    }else{
        [Model.delegate shezhiShifouJieshouxinXiaoxi:Model.optionSM._id switch:kaiguan.on isLiaotian:NO];
    }
}
@end
