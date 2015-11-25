//
//  ShengpiHeaderViewCell.h
//  Zipingguo
//
//  Created by jiangshilin on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShengPiCellVM.h"
@interface ShengpiHeaderViewCell : UITableViewCell
+(ShengpiHeaderViewCell *)cellForTableview:(UITableView *)tableview;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *zhuangTaiImageView;
@property (nonatomic,strong)ShengPiCellVM *vm;
@end
