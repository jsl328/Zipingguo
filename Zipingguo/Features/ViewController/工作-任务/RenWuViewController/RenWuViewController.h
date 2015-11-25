//
//  RenWuViewController.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

@interface RenWuViewController : ParentsViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    __weak IBOutlet UITableView *fenPeiTableView;
    __weak IBOutlet UITableView *myTableView;
}
@end
