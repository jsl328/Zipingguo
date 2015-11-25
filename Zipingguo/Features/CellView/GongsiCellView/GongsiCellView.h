//
//  GongsiCellView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GongsiModel.h"
@interface GongsiCellView : UITableViewCell
{
    __weak IBOutlet UILabel *gongsiName;
    __weak IBOutlet UIImageView *xuanzhongImageView;
    
}

+ (id)cellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) GongsiModel *model;

@end
