//
//  RenWuTableViewCell.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RenWuModel.h"
@interface RenWuTableViewCell : UITableViewCell
{
    __weak IBOutlet UIImageView *iconImageView;
    __weak IBOutlet NSLayoutConstraint *kuanjieRenwu;
    __weak IBOutlet UILabel *firstRenWuNameLabel;
    __weak IBOutlet UILabel *secondRenWuNameLabel;
    __weak IBOutlet UILabel *personNameLabel;
    
    RenWuModel *RenwuModel;
}
- (void)bindDataWithModel:(RenWuModel *)model;

@end
