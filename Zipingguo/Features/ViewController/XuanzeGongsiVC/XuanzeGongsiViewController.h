//
//  XuanzeGongsiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface XuanzeGongsiViewController : WaiweiParentsViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITableView *gongsiNameTabtlView;
    __weak IBOutlet UIButton *jinruBtn;
    __weak IBOutlet UIButton *jiechuBtn;
    __weak IBOutlet UIButton *zhuxiaoBtn;
    
}

@property (nonatomic, assign) BOOL isDenglu;

@property (nonatomic, strong) NSString *shoujihao;

@property (nonatomic, strong) NSString *mima;

@property (nonatomic, strong) NSMutableArray *gongsiArray;

@end
