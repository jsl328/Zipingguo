//
//  LianXiRenXiangQingViewController.m
//  Zipingguo
//
//  Created by sunny on 15/9/28.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "LianXiRenXiangQingViewController.h"
#import "LianXiRenXiangQingCell.h"
#import <MessageUI/MessageUI.h>
#import "CustomActionSheet.h"
#import "ChatViewController.h"
#import "FXBlurView.h"
#import "XingzuoVM.h"


@interface LianXiRenXiangQingViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,CustomActionSheetDelegate>{
    UITableView *myTableView;
    NSMutableArray *dataArray;
    NSArray *xiangQingTitleArray;
    DeptPersonsSM *personsSM;
    FXBlurView *blurView;
}

@end

@implementation LianXiRenXiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联系人详情";
    xiangQingTitleArray = @[@[@"没用的"],@[@"联系电话",@"电子邮件"],@[@"微信号",@"QQ号",@"生日",@"星座",@"爱好"]];
    dataArray = [@[] mutableCopy];
    [self createTableView];
    [self loadData];
}
- (void)loadData{
    [LDialog showWaitBox:@"数据加载中"];
    [ServiceShell getPersonDetailWithUserid:_ID usingCallback:^(DCServiceContext *serviceContext, ResultModelOfPersonDetailSM *personDetailSM1){
        [LDialog closeWaitBox];
        if (serviceContext.isSucceeded&&personDetailSM1.status == 0) {
            personsSM = personDetailSM1.data;
    
            // 第一个cell
            LianXiRenModel *model = [[LianXiRenModel alloc] init];
            model.name = [self panDuanIsNull:personsSM.name];
            model.buMen = [self panDuanIsNull:personsSM.deptname];
            model.position = [self panDuanIsNull:personsSM.position];
            model.touXiangIamgeUrl = [self panDuanIsNull:personsSM.imgurl];
            NSMutableArray *mArr1 = [NSMutableArray arrayWithObjects:model, nil];
            
            // 中间cell
            NSMutableArray *mArr2 = [NSMutableArray arrayWithObjects:[self panDuanIsNull:personsSM.phone],[self panDuanIsNull:personsSM.email], nil];
            
            // 最后cell
            NSString *xingZuo;
            NSString *shengRi;
            if ([self panDuanIsNull:personDetailSM1.data.userinfos.birthday].length != 0) {
                NSString *month = [personDetailSM1.data.userinfos.birthday substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [personDetailSM1.data.userinfos.birthday substringWithRange:NSMakeRange(8, 2)];
                xingZuo = [XingzuoVM chuanzhiNum:[NSString stringWithFormat:@"%@%@",month,day]];
                shengRi = [personDetailSM1.data.userinfos.birthday substringWithRange:NSMakeRange(0, 10)];
            }else{
                shengRi = @"";
                xingZuo = @"";
            }
            NSMutableArray *mArr3 = [NSMutableArray arrayWithObjects:[self panDuanIsNull:personsSM.wechat],[self panDuanIsNull:personsSM.qq],shengRi,xingZuo,[self panDuanIsNull:personDetailSM1.data.userinfos.hobby], nil];
            [dataArray addObject:mArr1];
            [dataArray addObject:mArr2];
            [dataArray addObject:mArr3];
            
            [myTableView reloadData];
        }
    }];
}
- (void)createTableView{
    myTableView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorColor = Fenge_Color;
    [self.view addSubview:myTableView];
    
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, ScreenWidth, 116);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(15, 36, ScreenWidth - 30, 44);
    [btn setTitle:@"发起聊天" forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"发起聊天button.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"发起聊天button-点击.png"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(faQiLiaoTianBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btn];
    
    if (!self.danliao) {
        if (![self.ID isEqualToString:[AppStore getYongHuID]]) {
            myTableView.tableFooterView = footerView;
        }
    }    
}
#pragma mark - tableDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [xiangQingTitleArray[section] count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [xiangQingTitleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        LianXiRenXiangQingCell *cell = [LianXiRenXiangQingCell cellForTableView:tableView];
        if (dataArray.count != 0 && [dataArray[indexPath.section] count] != 0) {
            cell.model = dataArray[indexPath.section][indexPath.row];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
 
    }else{
        static NSString *cellName = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
        }
        cell.detailTextLabel.textColor = RGBACOLOR(160, 160, 162, 1);
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        if (dataArray.count != 0 && [dataArray[indexPath.section] count] != 0) {
            cell.detailTextLabel.text = dataArray[indexPath.section][indexPath.row];
        }
        cell.textLabel.text = xiangQingTitleArray[indexPath.section][indexPath.row];
        if (indexPath.section == 1 ) {
            if (indexPath.row == 0) {
               cell.detailTextLabel.textColor = RGBACOLOR(4, 175, 245, 1);
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 72.0f;
    }else {
        return 44.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }else{
        return 15.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (dataArray.count == 0 || dataArray[indexPath.section][indexPath.row] == nil || dataArray[indexPath.section][indexPath.row] == NULL || [dataArray[indexPath.section][indexPath.row] isEqual:[NSNull null]] || [dataArray[indexPath.section][indexPath.row] length] == 0) {
            [SDialog showTipViewWithText:@"该用户没有手机号" hideAfterSeconds:1];
            return;
        }
        CustomActionSheet *customActionSheet = [[CustomActionSheet alloc] initWithTitle:dataArray[indexPath.section][indexPath.row] OtherButtons:@[@"拨打电话",@"发送短信"] CancleButton:@"取消" Rect:CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight )];
        customActionSheet.delegate = self;
        [self setMoHuViewWithHeight:customActionSheet.actionSheetHeight];
        [ShareApp.window addSubview:customActionSheet];
        [customActionSheet show];
        [self showMoHuView];
    }
}

#pragma mark - action
- (void)faQiLiaoTianBtnClick{
    ChatViewController *chatView =[[ChatViewController alloc]initWithChatter:[_ID substringToIndex:20] isGroup:NO];
    chatView.name = personsSM.name;
    chatView.Renyuanid = personsSM.userid;
    chatView.phonto = personsSM.imgurl;
    [self.navigationController pushViewController:chatView animated:YES];
}

#pragma mark - action
- (void)daDianHua:(NSString *)phoneNO{
    if ([phoneNO length] > 0) {
        
        NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phoneNO];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
    }
   
}
- (void)faDuanXin:(NSString *)phoneNO{
    if ([phoneNO length] > 0) {
        
        NSString *smsUrl = [NSString stringWithFormat:@"sms://%@",phoneNO];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:smsUrl]];
    }

}

#pragma mark - actionSheetDelegate
- (void)CustomActionSheetDelegateDidClickIndex:(NSInteger)indexButton customActionView:(CustomActionSheet *)customActionSheet{
    
    if (indexButton == 1) {
        [self daDianHua:personsSM.phone];
    }else{
        [self faDuanXin:personsSM.phone];
    }
    
    [self hideMoHuView];
}
- (void)CustomActionSheetDelegateDidClickCancelButton:(CustomActionSheet *)customActionSheet{
    [self hideMoHuView];
}
#pragma mark - layout
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    myTableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    if ([myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTableView setLayoutMargins:UIEdgeInsetsZero];
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

- (NSString *)panDuanIsNull:(id)text{
    if (text == nil || [text isEqual:[NSNull null]] || text == NULL) {
        return @"";
    }else{
        return text;
    }
}

@end
