//
//  ZiXunCell.h
//  Zipingguo
//
//  Created by sunny on 15/10/12.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiXunCellModel.h"

@interface ZiXunCell : UITableViewCell

@property (nonatomic,strong) ZiXunCellModel *model;

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeAndCommentCout;

+ (ZiXunCell *)cellForTableView:(UITableView *)tableView;



@end
