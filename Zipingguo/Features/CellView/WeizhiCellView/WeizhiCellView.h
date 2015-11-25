//
//  WeizhiCellView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/14.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeizhiModel.h"
@interface WeizhiCellView : UITableViewCell
{
    __weak IBOutlet UILabel *name;
    
    __weak IBOutlet UILabel *jutidizhi;
}

@property (nonatomic, strong) WeizhiModel *model;

+ (id)cellForTableView:(UITableView *)tableView;

@end
