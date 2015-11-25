//
//  JiechuGongsiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "JiechuGongsiViewController.h"
#import "GongsiModel.h"
#import "GongsiCellView.h"

@interface JiechuGongsiViewController ()
{
    NSMutableArray *_dataArray;
    GongsiModel *gongsiModel;
    NSString *companyid;
    NSInteger row;
}
@end

@implementation JiechuGongsiViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    // Do any additional setup after loading the view from its nib.
    
    gongsiModel = [[GongsiModel alloc] init];
    
    if (self.isDenglu) {
        [self customBackItemWithImage:@"back-icon黄.png" Color:RGBACOLOR(252, 164, 38, 1) IsHidden:NO];
    }else{
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                        UITextAttributeFont : [UIFont systemFontOfSize:16]};
        self.navigationItem.title = @"解除关联";
        [self customBackItemWithImage:@"返回icon" Color:RGBACOLOR(4, 175, 245, 1) IsHidden:NO];
        [self.backbtn setFrame:CGRectMake(0,0,18,18)];
        [self.backbtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    gongsiTableView.tableFooterView = footerView;
    
    gongsiTableView.separatorColor = Fenge_Color;
    
    [self loadData];
}

#pragma mack 数据Data
- (void)loadData{
    _dataArray = [@[] mutableCopy];
    for (int i = 0; i < self.gongsiArray.count; i++) {
        GongsiModel *model = [[GongsiModel alloc] init];
        DengluData2 *data2 = [self.gongsiArray objectAtIndex:i];
        model.data2 = data2;
        model.isSelect = NO;
        model.icon = @"未选圆.png";
        model.Isjiechu = YES;
        gongsiModel = model;
        [_dataArray addObject:model];
    }
    [gongsiTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    gongsiModel.isSelect = NO;
    GongsiModel *model = _dataArray[indexPath.row];
    model.isSelect = YES;
    model.selIcon = @"选中圆.png";
    gongsiModel = model;
    row = indexPath.row;
    companyid = model.data2.companyid;
    [gongsiTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GongsiCellView *gongsiCell = [GongsiCellView cellForTableView:tableView];
    gongsiCell.model = _dataArray[indexPath.row];
    return gongsiCell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == jiechu) {
        if (_dataArray.count == 1) {
            [ToolBox Tanchujinggao:@"公司不能全部解除" IconName:@""];
            return;
        }
        
        if (companyid.length == 0) {
            [ToolBox Tanchujinggao:@"请选择公司进行解除" IconName:@""];
            return;
        }
        
        [LDialog showWaitBox:@"解除公司中"];
        [ZhuceServiceShell RelleveCorpUserWithCompanyid:companyid Phone:self.shoujihao usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
            [LDialog closeWaitBox];
            if (serviceContext.isSucceeded && model.status == 0) {
                [ToolBox Tanchujinggao:@"您已成功解除关联" IconName:@"提醒_成功icon.png"];
                [_dataArray removeObjectAtIndex:row];
                [_gongsiArray removeObjectAtIndex:row];
                [gongsiTableView reloadData];
                self.passValueJiechu(self.gongsiArray);
            }
        }];
        
    }
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    tipLabel.frame = CGRectMake(0, 0, ScreenWidth, 50);
    
    if ([gongsiTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [gongsiTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([gongsiTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [gongsiTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
