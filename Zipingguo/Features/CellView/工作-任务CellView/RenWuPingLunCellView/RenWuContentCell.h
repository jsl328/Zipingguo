//
//  RenWuContentCell.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/19.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XinJianRenWuModel.h"
@interface RenWuContentCell : UITableViewCell
{
    __weak IBOutlet UILabel *taskLabel;
    __weak IBOutlet UILabel *taskContentLabel;
    __weak IBOutlet UILabel *remarkLabel;
    __weak IBOutlet UILabel *remarkContentLabel;
}
+ (instancetype)cellWithtableView:(UITableView *)tableView;
- (void)bindDataWithModel:(XinJianRenWuModel *)model;
@end
