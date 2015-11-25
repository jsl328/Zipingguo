//
//  XuanzeBumenViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/18.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XuanzeBumenViewController.h"
#import "FenzuModel.h"
#import "FenzuViewCell.h"
#import "ZibuMenViewController.h"
@interface XuanzeBumenViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation XuanzeBumenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.titleText;
    dataArray = [[NSMutableArray alloc] init];
    [self loadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData{
    [ServiceShell getCompanyDeptsWithCompanyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfCompanyDeptsSM *companyDeptsSM){
        for (CompanyDeptsSM *deptsSM in companyDeptsSM.data) {
            FenzuModel *model = [[FenzuModel alloc] init];
            model.deptsSM = deptsSM;
            [dataArray addObject:model];
        }
        [_tableView reloadData];
    }];
}

#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FenzuModel *model = [dataArray objectAtIndex:indexPath.row];
    if (model.deptsSM.isleaf == 1) {
        _passValueFromXuanze(model.deptsSM.name,model.deptsSM._id);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        ZibuMenViewController *ziBumen = [[ZibuMenViewController alloc] init];
        ziBumen.titleText = model.deptsSM.name;
        ziBumen.ID = model.deptsSM._id;
        [self.navigationController pushViewController:ziBumen animated:YES];
    }
    /// tableView 点击cell方法
}

#pragma mark - table View DataSource
//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FenzuViewCell *fenzuCell = [FenzuViewCell cellForTableView:tableView];
    FenzuModel *model = [dataArray objectAtIndex:indexPath.row];
    fenzuCell.model = model;
    if (model.deptsSM.isleaf == 1) {
        fenzuCell.jiantou.hidden = YES;
    }
    return fenzuCell;
 
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
