//
//  YaoqingViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/30.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface YaoqingViewController : WaiweiParentsViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIButton *shoujiTXyaoqingBtn;
    __weak IBOutlet UIButton *yaoqingBtn;
    __weak IBOutlet UITextField *shoujiHao;
    __weak IBOutlet UITableView *yaoqingTableView;
}

@property (nonatomic, assign) BOOL isDenglu;

@end
