//
//  RenWuSheZhiTableViewCell.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RenWuSheZhiModel.h"

@interface RenWuSheZhiTableViewCell : UITableViewCell
{
    __weak IBOutlet UILabel *nameLabel;
    
    __weak IBOutlet UIImageView *iconImageView;
}
- (void)bindData:(RenWuSheZhiModel *)model;
@end
