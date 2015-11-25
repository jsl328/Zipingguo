//
//  ShezhiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ShezhiViewController.h"
#import "ShezhiViewCell.h"
#import "ShezhiModel.h"
#import "XuanzeGongsiViewController.h"
#import "YaoqingViewController.h"
#import "DengluViewController.h"
@interface ShezhiViewController ()<UIAlertViewDelegate>
{
    NSMutableArray *dataArray;
    
    BOOL isQingkong;
    NSString *huancun;
}
@end

@implementation ShezhiViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
    [self initUI];
    [self initData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customBackItemIsHidden:YES];
    _tableView.backgroundColor = Bg_Color;
    _tableView.separatorColor = Fenge_Color;
    
}

- (void)initUI{
    ShezhiHeaderView *shezhiHeader = [[ShezhiHeaderView alloc] init];
    shezhiHeader.delegate = self;
    shezhiHeader.name.text = [AppStore getYongHuMing];
    shezhiHeader.zhiwei.text = [AppStore getZhiwei];
    [shezhiHeader.imageView setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,[AppStore getYonghuImageView]] fileName:@"头像100.png" Width:shezhiHeader.imageView.frame.size.width];
    shezhiHeader.frame = CGRectMake(0, 0, ScreenWidth, 76);
    
    shezhiHeader.layer.masksToBounds = YES;
    shezhiHeader.layer.borderColor = Fenge_Color.CGColor;
    shezhiHeader.layer.borderWidth = 0.5;
    
    _tableView.tableHeaderView = shezhiHeader;
    
    

}

- (void)initData
{
    
    NSArray *sectionOne;
    NSArray *sectionTwo;
    NSArray *sectionThree;
    
    if ([AppStore isAdmin]) {
        if ([AppStore getCorpnums]) {
            sectionOne = [[NSArray alloc]initWithObjects:@"账号安全",@"公司环境",@"邀请员工", nil];
            sectionTwo = [[NSArray alloc]initWithObjects:@"消息提醒",@"我的提醒",@"清除缓存",nil];
            sectionThree = [[NSArray alloc]initWithObjects:@"关于我们",@"帮助",nil];
            
            dataArray = [[NSMutableArray alloc]initWithObjects:sectionOne,sectionTwo,sectionThree, nil];
        }else{
            sectionOne = [[NSArray alloc]initWithObjects:@"账号安全",@"邀请员工", nil];
            sectionTwo = [[NSArray alloc]initWithObjects:@"消息提醒",@"我的提醒",@"清除缓存",nil];
            sectionThree = [[NSArray alloc]initWithObjects:@"关于我们",@"帮助",nil];
            
            dataArray = [[NSMutableArray alloc]initWithObjects:sectionOne,sectionTwo,sectionThree, nil];
        }
    }else{
        
        if ([AppStore getCorpnums]) {
            sectionOne = [[NSArray alloc]initWithObjects:@"账号安全",@"公司环境", nil];
            sectionTwo = [[NSArray alloc]initWithObjects:@"消息提醒",@"我的提醒",@"清除缓存",nil];
            sectionThree = [[NSArray alloc]initWithObjects:@"关于我们",@"帮助",nil];
            
            dataArray = [[NSMutableArray alloc]initWithObjects:sectionOne,sectionTwo,sectionThree, nil];
        }else{
            sectionOne = [[NSArray alloc]initWithObjects:@"账号安全",@"消息提醒",@"我的提醒",@"清除缓存", nil];
            sectionTwo = [[NSArray alloc]initWithObjects:@"关于我们",@"帮助",nil];
            dataArray = [[NSMutableArray alloc]initWithObjects:sectionOne,sectionTwo, nil];
        }
        
        
    }
    
    [_tableView reloadData];
    
    _tableView.tableFooterView = _footView;
}

#pragma mark - tabelviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    if ([AppStore isAdmin]) {
        if (section == 2) {
            return 50;
        }
    }else{
        if ([AppStore getCorpnums]) {
            if (section == 2) {
                return 50;
            }
        }else{
            if (section == 1) {
                return 50;
            }
        }
    }
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataArray.count) {
        return dataArray.count;
    }
    return 0;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([AppStore isAdmin]) {
        if ([AppStore getCorpnums]) {
            if (section == 0) {
                return 3;
            }else if(section == 1){
                return 3;
            }else if(section == 2){
                return 2;
            }
        }else{
            if (section == 0) {
                return 2;
            }else if(section == 1){
                return 3;
            }else if(section == 2){
                return 2;
            }
        }
    }else{
        
        if ([AppStore getCorpnums]) {
            if (section == 0) {
                return 2;
            }else if(section == 1){
                return 3;
            }else if(section == 2){
                return 2;
            }
        }else{
            if (section == 0) {
                return 4;
            }else if(section == 1){
                return 2;
            }
        }
        
    }
    
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShezhiViewCell *cell = [ShezhiViewCell cellForTableView:tableView];
    
    if ([AppStore isAdmin]) {
        if (indexPath.section == 1) {
            if (indexPath.row == 2) {
                [self huancun:cell];
            }
        }
    }else{
        
        if ([AppStore getCorpnums]) {
            if (indexPath.section == 1) {
                if (indexPath.row == 2) {
                    [self huancun:cell];
                }
            }
        }else{
            if (indexPath.section == 0) {
                if (indexPath.row == 3) {
                    [self huancun:cell];
                }
            }
        }
        
    }
    
    if (dataArray.count) {
        NSString *name = dataArray[indexPath.section][indexPath.row];
        //    cell.backgroundColor = [UIColor whiteColor];
        cell.biaoti.text = name;
        cell.icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon.png",name]];
    }
    
    return cell;
}

- (void)huancun:(ShezhiViewCell *)cell{
    cell.jiantou.hidden = YES;
    float cache = [[SDImageCache sharedImageCache] getSize]/(1024.0*1024.0);
    NSString *caches = [NSString stringWithFormat:@"%.2fM",cache];
    huancun = caches;
    if ([caches isEqualToString:@"0.00M"]) {
        cell.huancun.text = @"";
    }else{
        cell.huancun.text = caches;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([AppStore isAdmin]) {
        if ([AppStore getCorpnums]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    [self zhanghaoAnquan];
                }else if (indexPath.row == 1){
                    [self qiehuanGongsi];
                }else if (indexPath.row == 2){
                    [self yaoqingYuangong];
                }
            }else if(indexPath.section == 1){
                if (indexPath.row == 0) {
                    [self xiaoxiTixing];
                }else if (indexPath.row == 1){
                    [self wodeTixing];
                }else if (indexPath.row == 2){
                    [self qingchuHuancun];
                }
            }else if(indexPath.section == 2){
                if (indexPath.row == 0) {
                    [self guanyuWomen];
                }else if (indexPath.row == 1){
                    [self bangzhu];
                }
            }
        }else{
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    [self zhanghaoAnquan];
                }else if (indexPath.row == 1){
                    [self qiehuanGongsi];
                }
            }else if(indexPath.section == 1){
                if (indexPath.row == 0) {
                    [self xiaoxiTixing];
                }else if (indexPath.row == 1){
                    [self wodeTixing];
                }else if (indexPath.row == 2){
                    [self qingchuHuancun];
                }
            }else if(indexPath.section == 2){
                if (indexPath.row == 0) {
                    [self guanyuWomen];
                }else if (indexPath.row == 1){
                    [self bangzhu];
                }
            }
        }
    }else{
        
        if ([AppStore getCorpnums]) {
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    [self zhanghaoAnquan];
                }else if (indexPath.row == 1){
                    [self qiehuanGongsi];
                }
            }else if(indexPath.section == 1){
                if (indexPath.row == 0) {
                    [self xiaoxiTixing];
                }else if (indexPath.row == 1){
                    [self wodeTixing];
                }else if (indexPath.row == 2){
                    [self qingchuHuancun];
                }
            }else if(indexPath.section == 2){
                if (indexPath.row == 0) {
                    [self guanyuWomen];
                }else if (indexPath.row == 1){
                    [self bangzhu];
                }
            }
        }else{
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    [self zhanghaoAnquan];
                }else if (indexPath.row == 1){
                    [self xiaoxiTixing];
                }else if (indexPath.row == 2){
                    [self wodeTixing];
                }else if (indexPath.row == 3){
                    [self qingchuHuancun];
                }
            }else if(indexPath.section == 1){
                if (indexPath.row == 0) {
                    [self guanyuWomen];
                }else if (indexPath.row == 1){
                    [self bangzhu];
                }
            }
        }
        
    }
    
}

#pragma mark 账号与安全
- (void)zhanghaoAnquan{
    ZhanghaoyuanquanViewController *zhanghao = [[ZhanghaoyuanquanViewController alloc] init];
    zhanghao.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:zhanghao animated:YES];
}

#pragma mark 切换公司
- (void)qiehuanGongsi{
    
    XuanzeGongsiViewController *gongsiHuanjing = [[XuanzeGongsiViewController alloc] init];
    
    gongsiHuanjing.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gongsiHuanjing animated:YES];
}

#pragma mark 邀请好友
- (void)yaoqingYuangong{
    YaoqingViewController *yaoqingVC = [[YaoqingViewController alloc] init];
    
    yaoqingVC.isDenglu = NO;
    
    yaoqingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:yaoqingVC animated:YES];
}

#pragma mark 消息提醒
- (void)xiaoxiTixing{
    XiaoxiTixingViewController *tixing = [[XiaoxiTixingViewController alloc] init];
    tixing.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tixing animated:YES];
}

#pragma mark 我的提醒
- (void)wodeTixing{
    MyTiXingViewController *myTixing = [[MyTiXingViewController alloc] init];
    myTixing.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myTixing animated:YES];
}

#pragma mark 清除缓存
- (void)qingchuHuancun{
    isQingkong = YES;
    [[SDImageCache sharedImageCache] clearDisk];
    if (![huancun isEqualToString:@"0.00M"]) {
        [ToolBox Tanchujinggao:[NSString stringWithFormat:@"已清除缓存%@",huancun] IconName:nil];
    }
    [self initData];
}

#pragma mark 关于我们
- (void)guanyuWomen{
    GuanyuWomenViewController *guanyuwomen = [[GuanyuWomenViewController alloc] init];
    guanyuwomen.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:guanyuwomen animated:YES];
}

#pragma mark 帮助
- (void)bangzhu{
    BangzhuViewController *bangzhu = [[BangzhuViewController alloc] init];
    bangzhu.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bangzhu animated:YES];
}

#pragma mark 个人信息
- (void)gerenxinTiaozhuan{
    NSLog(@"个人信息");
    WodexinxiViewController *xinxi = [[WodexinxiViewController alloc] init];
    xinxi.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xinxi animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
    _tuichuButton.layer.masksToBounds = YES;
    _tuichuButton.layer.borderColor = Fenge_Color.CGColor;
    _tuichuButton.layer.borderWidth = 0.5;
    
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

- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == self.tuichuButton) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出登录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];

    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {        
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
            [self hideHud];
            if (error && error.errorCode != EMErrorServerNotLogin) {
            }
            else{
                [[EaseMob sharedInstance].chatManager removeDelegate:self];
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
            }
        } onQueue:nil];    }
}
@end
