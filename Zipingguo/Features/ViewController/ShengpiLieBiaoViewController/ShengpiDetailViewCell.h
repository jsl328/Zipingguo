//
//  ShengpiDetailViewCell.h
//  Zipingguo
//
//  Created by jiangshilin on 15/10/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShengPiCellVM.h"
@interface ShengpiDetailViewCell : UITableViewCell
+(ShengpiDetailViewCell *)cellForTableview:(UITableView *)tableview;
@property (strong,nonatomic) ShengPiCellVM *vm;
@property (strong, nonatomic) IBOutlet UILabel *chNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *ShouQiButton;
- (IBAction)ShouqiAciton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *contentName;
@end
