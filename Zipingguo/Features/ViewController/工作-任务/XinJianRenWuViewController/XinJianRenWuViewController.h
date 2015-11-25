//
//  XinJianRenWuViewController.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "ChuangjianRenwuSM.h"
@interface XinJianRenWuViewController : ParentsViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UIView *maskView;
    __weak IBOutlet UIView *riQiView;
    __weak IBOutlet UIDatePicker *choseTimePickerView;
    __weak IBOutlet UITableView *baseTableView;
}

@property (nonatomic ,strong) void (^passValueFromXinjian)(ChuangjianRenwuSM *sm);

@end
