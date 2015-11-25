//
//  XiaoxiTixingViewCell.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XiaoxiTixingModel.h"
@interface XiaoxiTixingViewCell : UITableViewCell
{
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UISwitch *kaiguan;
    XiaoxiTixingModel *Model;
}

@property (nonatomic, strong) XiaoxiTixingModel *model;

+ (id)cellForTableView:(UITableView *)tableView;

@end
