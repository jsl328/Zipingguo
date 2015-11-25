//
//  XuanzeGongsiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XuanzeGongsiViewController.h"
#import "GongsiModel.h"
#import "GongsiCellView.h"
#import "JiechuGongsiViewController.h"
#import "CustomTabbarController.h"
#import "DengluViewController.h"
#import "WanshanZiliaoViewController.h"
#import "ZuZhiKuangJiaViewController.h"
#import "ToolBox.h"
@interface XuanzeGongsiViewController ()
{
    NSMutableArray *_dataArray;
    GongsiModel *gongsiModel;
}
@end

@implementation XuanzeGongsiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    
    gongsiModel = [[GongsiModel alloc] init];
    
    if (self.isDenglu) {
        [self.navigationItem setHidesBackButton:YES];
        [self customBackItemWithImage:nil Color:nil IsHidden:YES];
         [self loadData];
    }else{
        self.shoujihao = [AppStore getYongHuShoujihao];
        self.mima = [AppStore getYongHuMima];
        [ServiceShell DengLu:self.shoujihao Password:self.mima Companyid:@"" usingCallback:^(DCServiceContext *context, DengluSM *itemSM) {
            if (!context.isSucceeded) {
                return ;
            }
            
            if (itemSM.status == 0) {
                if ([itemSM.data1.loginStatus isEqualToString:@"CHOOSE_CORP"]) {
                    self.gongsiArray = (NSMutableArray *)itemSM.data2;
                    [self loadData];
                }
            }
            
        }];
        
        zhuxiaoBtn.hidden = YES;
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                        UITextAttributeFont : [UIFont systemFontOfSize:16]};
        self.navigationItem.title = @"公司环境";
        [self customBackItemWithImage:@"返回icon" Color:RGBACOLOR(4, 175, 245, 1) IsHidden:NO];
        [self.backbtn setFrame:CGRectMake(0,0,18,18)];
        [self.backbtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    gongsiNameTabtlView.separatorColor = Fenge_Color;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    gongsiNameTabtlView.tableFooterView = footerView;
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData{
    _dataArray = [@[] mutableCopy];
    for (int i = 0; i < self.gongsiArray.count; i++) {
        GongsiModel *model = [[GongsiModel alloc] init];
        DengluData2 *data2 = [self.gongsiArray objectAtIndex:i];
        model.data2 = data2;
        if (self.isDenglu) {
            if (i == 0) {
                model.isSelect = YES;
                gongsiModel = model;
            }
        }else{
            if ([data2.companyid isEqualToString:[AppStore getGongsiID]]) {
                model.isSelect = YES;
                gongsiModel = model;
            }
        }
        model.icon = @"选中icon蓝.png";
        model.Isjiechu = NO;
        [_dataArray addObject:model];
    }
    [gongsiNameTabtlView reloadData];
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
    gongsiModel = model;
    [gongsiNameTabtlView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GongsiCellView *gongsiCell = [GongsiCellView cellForTableView:tableView];
    gongsiCell.model = _dataArray[indexPath.row];
    return gongsiCell;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    zhuxiaoBtn.frame = CGRectMake(zhuxiaoBtn.frame.origin.x, self.view.height+20-27-zhuxiaoBtn.frame.size.height, zhuxiaoBtn.frame.size.width, zhuxiaoBtn.frame.size.height);
    
    if ([gongsiNameTabtlView respondsToSelector:@selector(setSeparatorInset:)]) {
        [gongsiNameTabtlView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([gongsiNameTabtlView respondsToSelector:@selector(setLayoutMargins:)]) {
        [gongsiNameTabtlView setLayoutMargins:UIEdgeInsetsZero];
    }
    
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
    if (sender == jiechuBtn) {
        JiechuGongsiViewController *jiechuVC = [[JiechuGongsiViewController alloc] init];
        jiechuVC.shoujihao = self.shoujihao;
        jiechuVC.isDenglu = self.isDenglu;
        jiechuVC.gongsiArray = self.gongsiArray;
        jiechuVC.passValueJiechu = ^(NSMutableArray *gongsiArr){
            self.gongsiArray = gongsiArr;
            [self loadData];
        };
        [self.navigationController pushViewController:jiechuVC animated:YES];
    }else if (sender == zhuxiaoBtn){
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }else if (sender == jinruBtn){
        [LDialog showWaitBox:@"进入公司中"];
        [ServiceShell DengLu:self.shoujihao Password:self.mima Companyid:gongsiModel.data2.companyid usingCallback:^(DCServiceContext *context, DengluSM *itemSM) {
            [LDialog closeWaitBox];
            if (!context.isSucceeded) {
                return ;
            }
            if (itemSM.status == 0) {
                
                if (!self.isDenglu) {
                    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
                        NSLog(@"error%@",error);
                        [self jinruGongsi:itemSM];
                    } onQueue:nil];
                }else{
                    [self jinruGongsi:itemSM];
                }
                
                
            }else{
                [SDialog showTipViewWithText:itemSM.msg hideAfterSeconds:1.5f];
            }
        }];
        
    }
}

- (void)jinruGongsi:(DengluSM *)itemSM{
    [ToolBox baocunYonghuShuju:itemSM.data data2:itemSM.data1 Password:self.mima IsWanshan:NO];
    [AppStore setGongsiID:gongsiModel.data2.companyid];
    [AppStore setCompanyname:gongsiModel.data2.name];
    if ([itemSM.data1.loginStatus isEqualToString:@"LOGIN_SUCCESS"]) {//多公司
        if (itemSM.data1.lackdeptinfo == 1) {//缺少组织架构
            ZuZhiKuangJiaViewController *addGroup = [[ZuZhiKuangJiaViewController alloc] init];
            
            addGroup.isDenglu = self.isDenglu;
            [self.navigationController pushViewController:addGroup animated:YES];
        }else if (itemSM.data1.lackdeptinfo == 0){//正常进入
            
            if (itemSM.data1.lackuserinfo == 1) {//缺少信息，进入完善信息
                WanshanZiliaoViewController *ziliaoVC = [[WanshanZiliaoViewController alloc] init];
                ziliaoVC.userdata = itemSM.data;
                [AppStore setCompanyname:gongsiModel.data2.name];
                ziliaoVC.isDenglu = self.isDenglu;
                [self.navigationController pushViewController:ziliaoVC animated:YES];
            }else if(itemSM.data1.lackuserinfo == 0){//正常进入，登录成功
                [ToolBox baocunYonghuShuju:itemSM.data data2:itemSM.data1 Password:self.mima IsWanshan:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                
            }
        }
        
    }

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.isDenglu) {
        return NO;
    }
    return YES;
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
