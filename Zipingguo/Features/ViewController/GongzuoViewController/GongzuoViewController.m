//
//  GongzuoViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "GongzuoViewController.h"
#import "GongzuoModel.h"
#import "GongzuoViewCell.h"
#import "UIImageView+EMWebCache.h"
#import "DaKaViewController.h"
#import "GongZuoBaoGao2ViewController.h"
#import "RenWuViewController.h"
#import "ZiXunViewController.h"
#import "TongzhiViewController.h"
#import "UITabBar+Badge.h"
#import "CalendarViewController.h"
#import "Color.h"
#import "CalendarMonthHeaderView.h"
#import "CalendarHomeViewController.h"
#import "ShengpiLieBiaoViewController.h"
@interface GongzuoViewController ()
{
    //原始数据源
    NSMutableArray *_dataArray;
    //    CalendarMonthHeaderView*ch;
    CalendarHomeViewController *chvc;
    
    NSInteger redCount;
    
}
@end

@implementation GongzuoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _dataArray = [[NSMutableArray alloc] init];
    [self lodaData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    if (IOSDEVICE) {
        //iOS7之后的属性，设置为NO，会消除视图控制器对scrollView contentOffset的影响
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

     [self customBackItemIsHidden:YES];

    
    
    _tableView.showsVerticalScrollIndicator = NO;
    
}

- (void)lodaData{
    [_dataArray removeAllObjects];
    NSMutableArray *nameArr = [[NSMutableArray alloc] initWithObjects:@"通知",@"工作报告",@"任务",@"打卡",@"审批",@"资讯",@"日历",nil];
    
    for (int i = 0; i < nameArr.count; i++) {
        GongzuoModel *model = [[GongzuoModel alloc] init];
        
        model.icon = [NSString stringWithFormat:@"%@icon.png",nameArr[i]];
        model.name = nameArr[i];
        model.neirong = @"";
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
    
    [ServiceShell getHomeContentVWithUserid:[AppStore getYongHuID] Companyid:[AppStore getGongsiID] Apitype:@"work" usingCallback:^(DCServiceContext *serviceContext, HomeContentVSM *dataSM) {
        if (!serviceContext.isSucceeded) {
            return ;
        }
        [_dataArray removeAllObjects];
        for (int i = 0; i < nameArr.count; i++) {
            
            GongzuoModel *model = [[GongzuoModel alloc] init];
            
            if (dataSM.status == 0) {
                [self.tabBarController.tabBar showBadgeOnItemIndex:3];
                for (HomeContentVDataSM *SM in dataSM.data) {
                    if (i == 0 && [SM.module isEqualToString:@"NOTICE"]) {
                        model.neirong = SM.latestcontent;
                        model.data = SM;
                    }else if (i == 1 && [SM.module isEqualToString:@"WORKPAPER"]) {
                        model.neirong = SM.latestcontent;
                        model.data = SM;
                    }else if (i == 2 && [SM.module isEqualToString:@"TASK"]) {
                        model.neirong = SM.latestcontent;
                        model.data = SM;
                    }else if (i == 3 && [SM.module isEqualToString:@"ATTENDANCE"]) {
                        model.neirong = SM.latestcontent;
                        model.data = SM;
                    }else if (i == 4 && [SM.module isEqualToString:@"APPLY"]) {
                        model.neirong = SM.latestcontent;
                        model.data = SM;
                    }else if (i == 5 && [SM.module isEqualToString:@"INFO"]) {
                        model.neirong = SM.latestcontent;
                        model.data = SM;
                    }
                    
                }
            }else{
                 [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
                model.neirong = @"";
            }
            model.icon = [NSString stringWithFormat:@"%@icon.png",nameArr[i]];
            model.name = nameArr[i];
            
            [_dataArray addObject:model];
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
    /// tableView 点击cell方法
    GongzuoModel *gongzuoModel = _dataArray[indexPath.row];
    
    if (gongzuoModel.data.module.length != 0) {
        [ServiceShell getMsgToRedWithUserid:[AppStore getYongHuID] Module:gongzuoModel.data.module usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
            if (!serviceContext.isSucceeded) {
                return ;
            }
            
            if (model.status == 0) {
                gongzuoModel.neirong = @"";
                
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"Chushihuaxiaoxi" object:nil];
            }
        }];
    }
    
    switch (indexPath.row) {
        case 0: /// 通知
        {
            TongzhiViewController *tongzhiVC = [[TongzhiViewController alloc] init];
            tongzhiVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tongzhiVC animated:YES];
            
        }
            break;
        case 1: /// 工作报告
        {
            GongZuoBaoGao2ViewController *baogaoVC = [[GongZuoBaoGao2ViewController alloc] init];
            baogaoVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:baogaoVC animated:YES];

        }
            break;
        case 2: /// 任务
        {
            RenWuViewController *renWuVC = [[RenWuViewController alloc] init];
            renWuVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:renWuVC animated:YES];
            
        }
            break;
        case 3://打卡
            
        {
            if ([CLLocationManager locationServicesEnabled]) {
                DaKaViewController *daKaVC = [[DaKaViewController alloc] init];
                daKaVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:daKaVC animated:YES];
            }else{
                [LDialog showMessage:@"请打开您的定位功能"];
            }
        }
            break;
        case 4: //审批
        {
            ShengpiLieBiaoViewController *list =[[ShengpiLieBiaoViewController alloc]init];
            list.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
        case 5: /// 咨询
        {
            ZiXunViewController *ziXunVC = [[ZiXunViewController alloc] init];
            ziXunVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ziXunVC animated:YES];
            
        }
            break;
        case 6: /// 日历
        {
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
            NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
            NSString*riqi=[NSString stringWithFormat:@"%ld", (long)dateComponent.year ];
            
            chvc = [[CalendarHomeViewController alloc]init];
            
            chvc.calendartitle = riqi;
            
            
            chvc.calendarblock = ^(CalendarDayModel *model){
                
                NSLog(@"\n---------------------------");
                NSLog(@"1星期 %@",[model getWeek]);
                NSLog(@"2字符串 %@",[model toString]);
                NSLog(@"3节日  %@",model.holiday);
                
            };
            chvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chvc animated:YES];
            
            
            
        }

        default:
            break;
    }
}

#pragma mark - table View DataSource
//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataArray.count != 0) {
        return _dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GongzuoViewCell *cell = [GongzuoViewCell cellForTableView:tableView];
    GongzuoModel *model;
    if (_dataArray.count != 0) {
       model  = [_dataArray objectAtIndex:indexPath.row];
    }
    cell.model = model;

    return cell;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height-49);
    
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
