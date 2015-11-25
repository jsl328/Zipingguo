//
//  ZiXunSingleCommentCell.h
//  Zipingguo
//
//  Created by sunny on 15/11/6.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiXunSingleCommentModel.h"

@interface ZiXunSingleCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *replyLabel;
+ (instancetype)cellForTableView:(UITableView *)tableView;
@property (nonatomic,strong) ZiXunSingleCommentModel *model;
@end
