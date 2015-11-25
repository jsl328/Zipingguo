//
//  BodyTableViewCell.h
//  Zipingguo
//
//  Created by jiangshilin on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShengPiCellVM.h"
@interface BodyTableViewCell : UITableViewCell
+(BodyTableViewCell *)cellForTableview:(UITableView *)tableview;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong)ShengPiCellVM *vm;
@end
