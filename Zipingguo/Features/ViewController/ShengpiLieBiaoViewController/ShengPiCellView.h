//
//  ShengqingHeshengpiView.h
//  Lvpingguo
//
//  Created by jiangshilin on 14-8-13.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShengPiCellVM.h"
#import "DCImageBox.h"
#import "DCImageSource.h"
#import "ShengPiCellVM.h"
@interface ShengPiCellView : UITableViewCell
+ (id)cellForTableView:(UITableView *)tableView;
@property (strong,nonatomic) ShengPiCellVM *model;
@property (strong, nonatomic) NSString  *dealid;
@property (strong, nonatomic) NSString  *dealName;
@property (strong, nonatomic) IBOutlet UIImageView *zhuangtaiTipian;
@property (strong, nonatomic) IBOutlet UILabel *shengpileixingLabel;
@property (strong, nonatomic) IBOutlet UILabel *jitushijianLabel;
@property (strong, nonatomic) IBOutlet UILabel *shengqingrenLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
