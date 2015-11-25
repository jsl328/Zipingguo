//
//  FujianCellView.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FujianModel.h"
@interface FujianCellView : UITableViewCell
{
    __weak IBOutlet UIImageView *icon;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *sizeLabel;
    
}

+ (id)cellForTableView:(UITableView *)tableView;

@property (nonatomic, strong) FujianModel *model;

@end
