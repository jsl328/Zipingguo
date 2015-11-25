//
//  RootViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

@interface RootViewController : ParentsViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@end
