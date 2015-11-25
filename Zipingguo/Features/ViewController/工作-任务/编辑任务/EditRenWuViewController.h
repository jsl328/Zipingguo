//
//  EditRenWuViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/11/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import "ChuangjianRenwuSM.h"
#import "RenWuDetailSM.h"

@interface EditRenWuViewController : ParentsViewController<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UIView *maskView;
    __weak IBOutlet UIView *riQiView;
    __weak IBOutlet UIDatePicker *choseTimePickerView;
    __weak IBOutlet UITableView *baseTableView;
}

@property (nonatomic, strong) RenWuDetailSM *detailSM;

@property (nonatomic ,strong) void (^passValueFromXiugai)(ChuangjianRenwuSM *sm);

@property (nonatomic, strong) NSIndexPath *indexPath;


@end
