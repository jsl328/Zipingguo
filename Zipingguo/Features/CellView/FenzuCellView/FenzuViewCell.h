//
//  FenzuViewCell.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/10.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FenzuModel.h"
@interface FenzuViewCell : UITableViewCell
@property (nonatomic, strong) FenzuModel *model;
@property (weak, nonatomic) IBOutlet UILabel *biaoti;
@property (weak, nonatomic) IBOutlet UIImageView *jiantou;

+ (id)cellForTableView:(UITableView *)tableView;
@end
