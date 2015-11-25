//
//  RenWuPingLunTableViewCell.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuPingLunTableViewCell.h"
#import "UILabel+Extension.h"
#import "NSDate+Category.h"

@implementation RenWuPingLunTableViewCell

+ (instancetype)cellWithtableView:(UITableView *)tableView{
    static NSString *ID = @"RenWuPingLunTableViewCell";
    RenWuPingLunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"RenWuPingLunTableViewCell" owner:nil options:nil].firstObject;
    }
    return cell;
}

-(void)setContenString:(NSString *)contenString{
    _contenString = [contenString copy];
    self.contentLabel.text = contenString;
}

- (void)awakeFromNib {
    // Initialization code
    nameLabel.textColor = RGBACOLOR(53, 55, 68, 1);
    timeLabel.textColor = RGBACOLOR(160, 160, 162, 1);
    self.contentLabel.textColor = RGBACOLOR(160, 160, 162, 1);
    [headerImageView setCircle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)bindData:(RenWuPingLunModel *)model{
    
    nameLabel.text = model.pingLunPersonName;
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headerUrl]];
    if ([model.bName length]) {
        [self setTextColorWithText:model];
    }else{
        self.contentLabel.text = model.content;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:model.time];
    NSArray *timeArray = [model.time componentsSeparatedByString:@" "];
    if ([destDate isToday]) {
        timeLabel.text = [NSString stringWithFormat:@"今天 %@",[[timeArray lastObject] substringToIndex:5]];
    }
    else if([destDate isYesterday]){
        timeLabel.text = [NSString stringWithFormat:@"昨天 %@",[[timeArray lastObject] substringToIndex:5]];
    }else{
        timeLabel.text = model.time;
    }
    
}
- (void)setTextColorWithText:(RenWuPingLunModel *)model{
    
    [self.contentLabel addAttributeWithString:[NSString stringWithFormat:@"@%@ %@",model.bName,model.content] andColorValue:RGBACOLOR(4, 175, 245, 1) andUIFont:self.contentLabel.font andRangeString:[NSString stringWithFormat:@"@%@ ",model.bName]];

}
@end
