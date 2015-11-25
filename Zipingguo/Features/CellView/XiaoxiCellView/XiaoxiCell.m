//
//  XiaoxiCell.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XiaoxiCell.h"

@implementation XiaoxiCell

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(XiaoxiModel *)model{
    if ([model.dataSM.module isEqualToString:@"APPLY"]) {
        icon.image = [UIImage imageNamed:@"审批icon2.png"];
        biaoti.text = @"审批";
    }else if ([model.dataSM.module isEqualToString:@"NOTICE"]){
        icon.image = [UIImage imageNamed:@"通知icon2.png"];
        biaoti.text = @"通知";
    }else if ([model.dataSM.module isEqualToString:@"WORKPAPER"]){
        icon.image = [UIImage imageNamed:@"工作报告icon2.png"];
        biaoti.text = @"工作报告";
    }else if ([model.dataSM.module isEqualToString:@"INFO"]){
        icon.image = [UIImage imageNamed:@"资讯icon2.png"];
        biaoti.text = @"资讯";
    }else if ([model.dataSM.module isEqualToString:@"TASK"]){
        icon.image = [UIImage imageNamed:@"任务icon2.png"];
        biaoti.text = @"任务";
    }
    
    weidu.text = model.dataSM.unreadnum > 10 ?@"10+":[NSString stringWithFormat:@"%d",model.dataSM.unreadnum];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate*confromTimesp = [model.dataSM.latesttime formatterTime:model.dataSM.latesttime];
    
    shijian.text = [confromTimesp formattedTime];
    neirong.text = model.dataSM.latestcontent;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
