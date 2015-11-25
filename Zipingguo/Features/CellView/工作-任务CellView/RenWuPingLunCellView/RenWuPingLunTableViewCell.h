//
//  RenWuPingLunTableViewCell.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RenWuPingLunModel.h"

@interface RenWuPingLunTableViewCell : UITableViewCell{
    
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UIImageView *headerImageView;
}
+ (instancetype)cellWithtableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic,copy) NSString *contenString;
- (void)bindData:(RenWuPingLunModel *)model;
@end
