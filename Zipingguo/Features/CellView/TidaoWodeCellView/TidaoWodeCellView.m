//
//  TidaoWodeCellView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/13.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "TidaoWodeCellView.h"
#import "UILabel+Extension.h"
@implementation TidaoWodeCellView

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(TidaoWodeModel *)model{
    [touxiang setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,model.atMeNoticeSM.createurl] fileName:@"头像100.png" Width:touxiang.frame.size.width];
    NSString *leixing;
    if (model.atMeNoticeSM.moduletype == 1) {
        leixing = @"动态";
    }else if(model.atMeNoticeSM.moduletype == 2){
        leixing = @"任务";
    }else if(model.atMeNoticeSM.moduletype == 5){
        leixing = @"资讯";
    }else if(model.atMeNoticeSM.moduletype == 6){
        leixing = @"工作报告";
    }else if(model.atMeNoticeSM.moduletype == 7){
        leixing = @"外出打卡";
    }
    model.name = [NSString stringWithFormat:@"%@  在%@中@你",model.atMeNoticeSM.createname,leixing];
    name.text = model.name;
    neirong.text = model.atMeNoticeSM.content;
    shijian.text = model.atMeNoticeSM.time;
    
    
    if (leixing.length != 0 && model.atMeNoticeSM.createname.length != 0) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]
                                                 initWithString:model.name];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:RGBACOLOR(53, 55, 68, 1)
                           range:[model.name rangeOfString:model.atMeNoticeSM.createname]];
        
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:RGBACOLOR(4, 175, 245, 1)
                           range:[model.name rangeOfString:leixing]];
        
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:14]
                           range:[model.name rangeOfString:model.atMeNoticeSM.createname]];
        name.attributedText = attrString;

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
