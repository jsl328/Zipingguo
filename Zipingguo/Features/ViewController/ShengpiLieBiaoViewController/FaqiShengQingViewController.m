//
//  FaqiShengQingViewController.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-8-15.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "FaqiShengQingViewController.h"
#import "MutipleSlectFormViewController.h"
#import "SDialog.h"
#import "FaqishengqingCellView.h"
#import "UIViewController+BarButtonItemPostion.h"
@interface FaqiShengQingViewController ()
{
    NSMutableArray *itemArray;
}
@end

@implementation FaqiShengQingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self setExtendedLayoutIncludesOpaqueBars:NO];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor =Fenge_Color;
    self.title = @"发起申请";
    itemArray=[[NSMutableArray alloc]init];
    [self loadData];
}

-(void)loadData
{
    //NSLog(@"发起申请传companyid号:%@",[AppStore getGongsiID]);
    if (![NetWork isConnectionAvailable]) {
        [SDialog showTipViewWithText:@"当前网络不稳定" hideAfterSeconds:1.5f];
        return;
    }
    [ServiceShell getAllFlowWithCompanyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfAllFlowSM *allFlowSM) {
        if (allFlowSM.data.count >0) {
            for (int i=0; i<allFlowSM.data.count; i++) {
                AllFlowsSM *sm=[allFlowSM.data objectAtIndex:i];
                
                FaqishengqingCellVM *vm=[[FaqishengqingCellVM alloc]init];
                vm.tempArr=allFlowSM.data;
                vm.biaoti=sm.name;
                //_id号吗
                vm.ID=sm.im;
                vm.deaulfDealRenID=sm.defaultuserid;
                vm.deaulftRenName = sm.defaultusername;
                vm.companyID=sm.companyid;
                [itemArray addObject:vm];
            }
            [_tableView reloadData];
        }else{
            [SDialog showTipViewWithText:@"请联系企业管理员在后台设置" hideAfterSeconds:1.5f];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self sizeTodRact];
    return itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FaqishengqingCellView *cell =[FaqishengqingCellView cellForTableView:tableView];
    cell.model = [itemArray objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[itemArray objectAtIndex:indexPath.row] isKindOfClass:[FaqishengqingCellVM class]]) {
        FaqishengqingCellVM *vm =[itemArray objectAtIndex:indexPath.row];
        MutipleSlectFormViewController *mutli =[[MutipleSlectFormViewController alloc]init];
        mutli.transformModel = vm;
        mutli.flowid  = vm.ID;
        mutli.titleStr = vm.biaoti;
        [self.navigationController pushViewController:mutli animated:YES];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}
-(void)sizeTodRact
{
    _tableView.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight-NavHeight);
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
