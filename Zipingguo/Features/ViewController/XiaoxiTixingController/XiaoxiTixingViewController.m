//
//  XiaoxiTixingViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/11.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XiaoxiTixingViewController.h"
#import "XiaoxiTixingViewCell.h"
#import "XiaoxiTixingModel.h"
@interface XiaoxiTixingViewController ()<XiaoxiTixingModelDelegate>
{
    NSMutableArray *dataArray;
}
@end

@implementation XiaoxiTixingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息提醒";
    // Do any additional setup after loading the view from its nib.
    dataArray = [[NSMutableArray alloc] init];
    [self creatData];
}

- (void)creatData{
    [LDialog showWaitBox:@"数据加载中"];
    [ServiceShell getOptionWithUserid:[AppStore getYongHuID] UserCompanyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfGetOptionSM *optionSM) {
        [LDialog closeWaitBox];
        if (serviceContext.isSucceeded && optionSM.status == 0) {
            for (OptionSM *sm in optionSM.data) {
                XiaoxiTixingModel *model = [[XiaoxiTixingModel alloc] init];
                model.optionSM = sm;
                [dataArray addObject:model];
            }
            [_tableView reloadData];
        }else{
            [ToolBox Tanchujinggao:@"获取数据失败" IconName:nil];
        }
        
    }];
}

#pragma mark - tabelviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSLog(@"子类必须重写此方法");
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XiaoxiTixingViewCell *cell = [XiaoxiTixingViewCell cellForTableView:tableView];
    XiaoxiTixingModel *model = [dataArray objectAtIndex:indexPath.row];
    model.delegate = self;
    cell.model = model;
    
    return cell;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)shezhiShifouJieshouxinXiaoxi:(NSString *)msgoptionid switch:(BOOL)isOn isLiaotian:(BOOL)liaotian{
    if (liaotian) {
        EMPushNotificationOptions *option= [[EaseMob sharedInstance].chatManager pushNotificationOptions];

        //NSLog(@"option=%@",option.noDisturbStatus);
        
        if (isOn == 1) {
            //NSLog(@"接收");
            option.noDisturbStatus =ePushNotificationNoDisturbStatusClose;
            option.noDisturbingStartH = -1;
            option.noDisturbingEndH = -1;
            
        }else{
            // NSLog(@"不接收");
            option.noDisturbStatus =ePushNotificationNoDisturbStatusDay;
            option.noDisturbingStartH = 0;
            option.noDisturbingEndH =24;
        }
        //设置通知提醒
        [[EaseMob sharedInstance].chatManager asyncUpdatePushOptions:option completion:^(EMPushNotificationOptions *options, EMError *error) {
            if (!error) {
                NSLog(@"设置消息提醒成功");
            }
        } onQueue:nil];
        
        //更新服务器数据
        [ServiceShell getUsermsgOptionWithUserid:[AppStore getYongHuID] Msgoptionid:msgoptionid Status:[NSString stringWithFormat:@"%d",isOn] usingCallback:^(DCServiceContext *serviceContext, ResultMode *optionSM) {
            if (serviceContext.isSucceeded && optionSM.status == 0) {
                [ToolBox Tanchujinggao:optionSM.msg IconName:@"提醒_成功icon.png"];
            }else{
                [ToolBox Tanchujinggao:@"设置失败" IconName:nil];
            }
        }];
    }else{
        [ServiceShell getUsermsgOptionWithUserid:[AppStore getYongHuID] Msgoptionid:msgoptionid Status:[NSString stringWithFormat:@"%d",isOn] usingCallback:^(DCServiceContext *serviceContext, ResultMode *optionSM) {
            if (optionSM.status == 0) {
                if (serviceContext.isSucceeded && optionSM.status == 0) {
                    [ToolBox Tanchujinggao:optionSM.msg IconName:@"提醒_成功icon.png"];
                }else{
                    [ToolBox Tanchujinggao:@"设置失败" IconName:nil];
                }
            }
        }];
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
