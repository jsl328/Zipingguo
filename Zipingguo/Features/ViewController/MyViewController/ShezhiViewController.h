//
//  ShezhiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RootViewController.h"
#import "ShezhiHeaderView.h"
#import "WodexinxiViewController.h"
#import "ZhanghaoyuanquanViewController.h"
#import "XiaoxiTixingViewController.h"
#import "GuanyuWomenViewController.h"
#import "BangzhuViewController.h"
#import "MyTiXingViewController.h"

@interface ShezhiViewController : ParentsViewController<ShezhiHeaderViewDelegate,UITableViewDataSource,UITableViewDelegate,EMChatManagerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *tuichuButton;
- (IBAction)buttonClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *footView;
@end
