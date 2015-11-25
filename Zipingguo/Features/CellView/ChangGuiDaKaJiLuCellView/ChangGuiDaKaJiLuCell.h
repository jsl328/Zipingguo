//
//  ChangGuiDaKaJiLuCell.h
//  Zipingguo
//
//  Created by sunny on 15/10/19.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangGuiDaKaJiLuModel.h"

@interface ChangGuiDaKaJiLuCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) ChangGuiDaKaJiLuModel *model;

+ (ChangGuiDaKaJiLuCell *)cellForTableView:(UITableView *)tableView;
@end
