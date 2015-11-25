//
//  RenWuSheZhiViewController.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

@interface RenWuSheZhiViewController : ParentsViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *sheZhiTableView;
}

@property (nonatomic,copy) NSString *vcTitle;
@property (nonatomic,copy) NSString *valueName;;
@property (nonatomic,copy) NSString *renWuID;;

@property (nonatomic,strong) void (^subTitle)(NSString *name);
@end
