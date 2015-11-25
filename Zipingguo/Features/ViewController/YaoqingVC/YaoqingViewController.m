//
//  YaoqingViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/30.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "YaoqingViewController.h"
#import "YaoqingShoujiPersonViewController.h"
#import "WanshanZiliaoViewController.h"
@interface YaoqingViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation YaoqingViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if (self.isDenglu) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;// 默认不显示工具条
    
    dataArray = [@[] mutableCopy];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;// 默认不显示工具条
    
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    yaoqingTableView.separatorColor = Fenge_Color;
    
    if (IOSDEVICE) {
        [self setAutomaticallyAdjustsScrollViewInsets:YES];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
    }
    [self addItemWithTitle:@"完成" imageName:nil selector:@selector(RightSelector) location:NO];
    if (self.isDenglu) {
        self.backbtn.hidden = YES;
    
    }else{
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                                                        UITextAttributeFont : [UIFont systemFontOfSize:16]};
        
        [self customBackItemWithImage:@"返回icon" Color:RGBACOLOR(4, 175, 245, 1) IsHidden:NO];
        [self.backbtn setFrame:CGRectMake(0,0,18,18)];
        [self.backbtn setTitle:@"" forState:UIControlStateNormal];
        
        [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
       
    }
    
     self.navigationItem.title = @"请邀请员工到您的企业";
    // Do any additional setup after loading the view from its nib.
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    yaoqingTableView.tableFooterView = footerView;
    
    
}

- (void)RightSelector{
    if (self.isDenglu) {
        WanshanZiliaoViewController *wanshanZiliaoVC = [[WanshanZiliaoViewController alloc] init];
        wanshanZiliaoVC.isDenglu = self.isDenglu;
        [self.navigationController pushViewController:wanshanZiliaoVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)loadData{
    [ZhuceServiceShell InviteListWithCompanyid:[AppStore getGongsiID] Userid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *context, YaoqingSM *listSM) {
        for (NSString *sm in listSM.data) {
            [dataArray addObject:sm];
        }
        [yaoqingTableView reloadData];
    }];
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

#pragma mark tableView代理

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    headerView.backgroundColor = RGBACOLOR(244, 247, 252, 1);
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 50, 20)];
    headerLabel.text = @"邀请记录";
    headerLabel.textColor = RGBACOLOR(160, 160, 162, 1);
    headerLabel.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count != 0) {
        return dataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"yaoqingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[dataArray[indexPath.row] componentsSeparatedByString:@","] firstObject];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = RGBACOLOR(53, 55, 68, 1);
    
    return cell;
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == shoujiTXyaoqingBtn) {
        YaoqingShoujiPersonViewController *yaoqing = [[YaoqingShoujiPersonViewController alloc] init];
        yaoqing.isDenglu = self.isDenglu;
        [dataArray addObject:[AppStore getYongHuShoujihao]];
        yaoqing.enduleArray = dataArray;
        [self.navigationController pushViewController:yaoqing animated:YES];
    }else if(yaoqingBtn){
        
        if (shoujiHao.text.length != 11) {
            [ToolBox Tanchujinggao:@"您输入的手机号有误，请重新输入" IconName:nil];
            return;
        }
        
        [shoujiHao resignFirstResponder];
        NSMutableArray *phoneArray = [@[] mutableCopy];
        [phoneArray addObject:shoujiHao.text];
        YaoqingYuangongSM *yaoqingSM =[[YaoqingYuangongSM alloc] init];
        yaoqingSM.companyid = [AppStore getGongsiID];
        yaoqingSM.userid = [AppStore getYongHuID];
        yaoqingSM.invitephones = phoneArray;
        [ZhuceServiceShell YaoqingWithYaoqingYuangong:yaoqingSM usingCallback:^(DCServiceContext *serviceContext, YaoqingSM *model) {
            if (serviceContext.isSucceeded && model.status == 0) {
                
                if (model.data.count != 0) {
                    [ToolBox Tanchujinggao:[NSString stringWithFormat:@"%@已被邀请",[model.data componentsJoinedByString:@","]] IconName:nil];
                }else{
                    [dataArray addObject:shoujiHao.text];
                    [yaoqingTableView reloadData];
                    [ToolBox Tanchujinggao:model.msg IconName:@"提醒_成功icon.png"];
                }
                shoujiHao.text = @"";
            }
        }];
    }
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if ([yaoqingTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [yaoqingTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([yaoqingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [yaoqingTableView setLayoutMargins:UIEdgeInsetsZero];
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
