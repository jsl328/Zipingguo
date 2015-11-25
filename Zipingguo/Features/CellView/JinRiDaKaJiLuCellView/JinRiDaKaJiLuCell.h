//
//  JinRiDaKaJiLuCell.h
//  Zipingguo
//
//  Created by sunny on 15/10/16.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JinRiDaKaJiLuModel.h"

@interface JinRiDaKaJiLuCell : UITableViewCell

@property (nonatomic, strong) JinRiDaKaJiLuModel *model;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressNameLabel;

+ (JinRiDaKaJiLuCell *)cellForTableView:(UITableView *)tableView;

@end
