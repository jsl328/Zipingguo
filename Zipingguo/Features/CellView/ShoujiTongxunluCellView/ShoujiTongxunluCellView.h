//
//  ShoujiTongxunluCellView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/31.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoujiTongxunluModel.h"
@interface ShoujiTongxunluCellView : UITableViewCell
{
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *dianhua;
    __weak IBOutlet UIImageView *xuanzhongImageView;
    
}

+ (id)cellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) ShoujiTongxunluModel *model;

@end
