//
//  XiaoxiCell.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiaoxiModel.h"
@interface XiaoxiCell : UITableViewCell
{
    __weak IBOutlet UIImageView *icon;
    __weak IBOutlet UILabel *biaoti;
    __weak IBOutlet UILabel *neirong;
    __weak IBOutlet UILabel *shijian;
    __weak IBOutlet UILabel *weidu;
}

+ (id)cellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) XiaoxiModel *model;

@end
