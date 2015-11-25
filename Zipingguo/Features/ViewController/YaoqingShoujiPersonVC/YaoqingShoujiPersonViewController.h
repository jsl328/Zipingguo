//
//  YaoqingShoujiPersonViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/31.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface YaoqingShoujiPersonViewController : WaiweiParentsViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    __weak IBOutlet UITableView *shoujiTabelView;
    
    __weak IBOutlet UIButton *yaoqingBtn;
}

@property (nonatomic, assign) BOOL isDenglu;

@property (nonatomic, strong) NSMutableArray *enduleArray;

@end
