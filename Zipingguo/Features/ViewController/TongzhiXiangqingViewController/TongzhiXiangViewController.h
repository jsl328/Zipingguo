//
//  TongzhiXiangViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

@interface TongzhiXiangViewController : ParentsViewController
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *shijian;
    __weak IBOutlet UIImageView *shangfenge;
    __weak IBOutlet UIWebView *contentWebview;
    
    __weak IBOutlet UIImageView *fengexiang;
    __weak IBOutlet UITableView *fujianTableView;
}

@property (nonatomic ,strong) void (^passValueFromTongzhixiangqing)(NSUInteger row);

@property (nonatomic, assign) NSUInteger row;

@property (nonatomic, strong) NSString *tongzhiID;

@property (nonatomic) int isRead;

@end
