//
//  ShezhiViewCell.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShezhiViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *biaoti;
@property (weak, nonatomic) IBOutlet UILabel *huancun;
@property (weak, nonatomic) IBOutlet UIImageView *jiantou;

+ (id)cellForTableView:(UITableView *)tableView;

@end
