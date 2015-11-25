//
//  FujianCellView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "FujianCellView.h"

@implementation FujianCellView

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(FujianModel *)model{
    name.text = model.noticeAnnexsSM.filename;
    sizeLabel.text = model.noticeAnnexsSM.formatsize;
    NSString *exit = [[model.noticeAnnexsSM.filename componentsSeparatedByString:@"."] lastObject];
    if ([exit isEqualToString:@"docx"] || [exit isEqualToString:@"doc"]) {
        icon.image = [UIImage imageNamed:@"w"];
    }else if ([exit compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame || [exit compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame || [exit compare:@"jpeg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        //不区分大小写比较
        if (model.isBaogao) {
            [icon setUrl:[URLKEY stringByAppendingString:model.noticeAnnexsSM.fileurl] fileName:@"图片110"];
        }else{
            icon.image = [UIImage imageNamed:@"图片t"];

        }
        
        
    }else if ([exit isEqualToString:@"xlsx"] || [exit isEqualToString:@"xls"]) {
        icon.image = [UIImage imageNamed:@"x"];
    }else if ([exit isEqualToString:@"pptx"] || [exit isEqualToString:@"ppt"]) {
        icon.image = [UIImage imageNamed:@"p"];
    }else if ([exit isEqualToString:@"txt"]) {
        icon.image = [UIImage imageNamed:@"t"];
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
