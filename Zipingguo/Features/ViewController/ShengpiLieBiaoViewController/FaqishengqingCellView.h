//
//  FaqishengqingCellView.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-8-15.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListBox.h"
#import "FaqishengqingCellVM.h"
@interface FaqishengqingCellView : UITableViewCell
+ (id)cellForTableView:(UITableView *)tableView;
@property (strong,nonatomic) FaqishengqingCellVM *model;
@property (strong, nonatomic) IBOutlet UILabel *neibieLabel;
@end
