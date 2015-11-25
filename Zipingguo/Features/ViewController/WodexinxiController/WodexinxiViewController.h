//
//  WodexinxiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RootViewController.h"

@interface WodexinxiViewController : ParentsViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UIImageView *beijingImageView;
    __weak IBOutlet UIView *shengriView;
    __weak IBOutlet UIBarButtonItem *cancelItem;
    __weak IBOutlet UIBarButtonItem *doneItem;
    __weak IBOutlet UIDatePicker *datePicker;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
