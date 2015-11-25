//
//  ShengpiDetailViewController.h
//  Zipingguo
//
//  Created by jiangshilin on 15/10/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "ShengPiCellVM.h"
@interface ShengpiDetailViewController : ParentsViewController<UITableViewDataSource,UITableViewDelegate,ShengPiCellVMDelegate>
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) IBOutlet UIButton *Pizhunbtn;
@property (strong, nonatomic) IBOutlet UIButton *bupizhunBtn;
@property (strong, nonatomic) IBOutlet UIButton *zhuanjianBtn;
- (IBAction)ButtonOnClick:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIView *dibuView;
@property (strong, nonatomic) IBOutlet UIButton *shanchuBtn;
@property (strong, nonatomic) IBOutlet UITableView *BodyTableView;
@property(strong,nonatomic) ShengPiCellVM *vm;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic ,strong) void (^passValueFromShanchu)(NSInteger row);
@property (nonatomic ,strong) void (^passValueFromShenpi)(int start);
@end
