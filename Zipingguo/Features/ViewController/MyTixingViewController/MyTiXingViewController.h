//
//  MyTiXingViewController.h
//  Zipingguo
//
//  Created by Apple on 15/10/23.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

@interface MyTiXingViewController : ParentsViewController

@property (nonatomic, strong) UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
- (IBAction)toolbarClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
