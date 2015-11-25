//
//  XuanzeRenyuanCellView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuanzeRenyuanModel.h"
@interface XuanzeRenyuanCellView : UITableViewCell
{
    __weak IBOutlet UIImageView *touxiang;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *zuming;
    __weak IBOutlet UIButton *xuanzhongBtn;
    
}

+ (id)cellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) XuanzeRenyuanModel *model;

@end
