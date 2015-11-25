//
//  ShengpiLieBiaoViewController.h
//  Zipingguo
//
//  Created by jiangshilin on 15/10/16.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "FaqiShengQingViewController.h"
#import "ShengPiCellVM.h"
#import "ShengPiCellView.h"
@interface ShengpiLieBiaoViewController : ParentsViewController<FaqiShengqingDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mTableView;

@end
