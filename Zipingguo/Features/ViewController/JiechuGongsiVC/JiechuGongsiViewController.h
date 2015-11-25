//
//  JiechuGongsiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface JiechuGongsiViewController : WaiweiParentsViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UILabel *tipLabel;
    __weak IBOutlet UITableView *gongsiTableView;
    __weak IBOutlet UIButton *jiechu;
    
}

@property (nonatomic, strong) NSString *shoujihao;

@property (nonatomic, assign) BOOL isDenglu;

@property (nonatomic, strong) NSMutableArray *gongsiArray;

@property (nonatomic ,strong) void (^passValueJiechu)(NSMutableArray *gongSiArray);

@end
