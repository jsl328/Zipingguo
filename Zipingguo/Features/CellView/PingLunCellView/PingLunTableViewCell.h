//
//  PingLunTableViewCell.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/15.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PingLunTableViewCellModel;
@interface PingLunTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *touXiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *neiRongLabel;
@property (weak, nonatomic) IBOutlet UILabel *shijianLabel;
@property (nonatomic, strong) PingLunTableViewCellModel *model;
+ (id)cellForTableView:(UITableView *)tableView;

@end

@interface PingLunTableViewCellModel : NSObject
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *touxiangUrl;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *createid;

@property (nonatomic,copy) NSString *huifurenName;
@property (nonatomic,copy) NSString *neiRong;
@property (nonatomic,copy) NSString *shijian;
@property (nonatomic,copy) NSString *topparid;
@property (nonatomic,assign) float cellHeight;

@end