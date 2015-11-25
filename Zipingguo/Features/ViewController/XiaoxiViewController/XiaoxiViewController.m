
//
//  XiaoxiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XiaoxiViewController.h"
#import "HeaderView.h"
#import "ChatViewController.h"
//jsl...
#import "WeixinQunzuCellView.h"
#import "WeixinQunzuCellVM.h"
#import "UserinfoByHuanxinSM.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "ShengpiLieBiaoViewController.h"
#import "DaKaViewController.h"
#import "XiaoxiXialaView.h"
#import "XinJianBaoGaoViewController.h"
#import "XinJianRenWuViewController.h"
#import "XuanzeRenyuanViewController.h"
#import "UITabBar+Badge.h"
#import <AVFoundation/AVFoundation.h>
#import "TongzhiViewController.h"
#import "RenWuViewController.h"
#import "GongZuoBaoGao2ViewController.h"
#import "ZiXunViewController.h"
#import "XiaoxiViewController+Category.h"
//MH
#import "Shangchuanrenwu.h"
@interface XiaoxiViewController ()<XiaoxiXialaViewDelegate>
{
    NSMutableArray *dataArray;
    
    UIView *bgView;
    NSInteger redCount;
    UIView *headerView;
    
    int Start;
    int Count;
    int beishu;
}
@end

@implementation XiaoxiViewController
@synthesize yonghuArray;
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![NetWork isConnectionAvailable]) {
        headerView = [[HeaderView alloc] init];
        headerView.frame = CGRectMake(0, 0, ScreenWidth, 40);
        _tableView.tableHeaderView = headerView;
    }else{
        _tableView.tableHeaderView = nil;
    }
    [self loadLiaotian];
}

- (void)chushihua{
    [dataArray removeAllObjects];
    [self loadLiaotian];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

//网络状态的变化
- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = headerView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

//网络状态的更新
- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == eEMConnectionDisconnected) {
        _tableView.tableHeaderView = headerView;
        //没网的状态
       
    }
    else{
        //有网状态
         [Shangchuanrenwu meichangchuanrenwuDB];
        _tableView.tableHeaderView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[@"www.baidu.com" url]);
    
    //注册监听环信的sdk...
    [self registerNotifications];
    [self registerBecomeActive];
    self.yonghuArray = [@[] mutableCopy];
    self.yonghuArray = [YonghuStores getAllWithGongsiID:[AppStore getGongsiID]];
    //    [self chushihua];
    dataArray = [@[] mutableCopy];
    [self addItemWithTitle:@"" imageName:@"快捷操作+icon.png" selector:@selector(rightItemClicked) location:NO];
    [self customBackItemIsHidden:YES];
    
    //通讯录获取数据
    [self tongxunluHuoquData];
    
}

#pragma mark 通讯录获取数据

- (void)tongxunluHuoquData{
    
    if (self.yonghuArray.count != 0) {
        //修改用户数据
        [self xiugaishuju];
    }else{
        //获取用户数据
        Start = 0;
        beishu = 0;
        Count = 200;
        [YonghuStores deleteDataInGongSiTongXunLuDataBase];
        [self quanbuData];
    }
}

//从后台回到前台
-(void)reloadData
{
    [self loadLiaotian];
}

- (void)rightItemClicked{
//    if ([self.view.subviews indexOfObject:bgView] == NSNotFound) {
//        [bgView removeFromSuperview];
//        
//        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight)];
//        bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
//        [self.view addSubview:bgView];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeXialaView)];
//        [bgView addGestureRecognizer:tap];
//        
//        XiaoxiXialaView * xialaView = [[XiaoxiXialaView alloc] init];
//        xialaView.frame = CGRectMake(ScreenWidth - 140 - 10, 0, 140, 176);
//        
//        xialaView.delegate = self;
//        [bgView addSubview:xialaView];
//    }else{
//        [bgView removeFromSuperview];
//    }
    
    

    
    [ToolBox showList:@[@"发起聊天",@"快速打卡",@"新建日报",@"新建任务"] images:@[@"发起聊天icon",@"快速打卡icon",@"工作日报icon",@"新建任务icon"] forAlignment:ListViewAlignmentRight callback:^(int index) {
        switch (index) {
            case 0:
            {
                [self xinjianLiaotian];
            }
                break;
            case 1:
            {
                [self kuansuDaka];
            }
                break;

            case 2:
            {
                [self xinjianRibao];

            }
                break;

            case 3:
            {
                [self xinjianRenwu];

            }
                break;
                
            default:
                break;
        }
        
    }];
    
}
#pragma mark 删除下拉view
- (void)removeXialaView{
    [self rightItemClicked];
}


#pragma mark 聊天会话
- (void)loadLiaotian{
    redCount = 0;
    //jsl...
    
    if ([self loadDataSource].count == 0) {
        [_tableView reloadData];
        return;
    }
    
    for (EMConversation *em in [self loadDataSource]) {
        NSLog(@"会话数量:%d",(int)[[self loadDataSource] count]);
        NSLog(@"em.chatter=%@",em.chatter);
        em.enableUnreadMessagesCountEvent =YES;
        
        WeixinQunzuCellVM *model =[[WeixinQunzuCellVM alloc]init];
        model.shijian =[self lastMessageTimeByConversation:em];
        model.liuyanCount =(int)[self unreadMessageCountByConversation:em];
        model.lastLiuyan =[self subTitleMessageByConversation:em];
        model.messageState = [self lastMessageDeliverState:em];
        model.timestamp = [self lastMessageTimestampByConversation:em];
        [model.imageArr removeAllObjects];
        [model.nameArr removeAllObjects];
        [model.idArr removeAllObjects];
        //NSLog(@"----a%ld",(long)em.conversationType);
        if (em.conversationType==eConversationTypeChat) {
            //单人聊天赋值
            if (em.chatter) {
                if ([em.chatter isEqualToString:@"00000100000000000000"] || [em.chatter isEqualToString:@"00000200000000000000"] || [em.chatter isEqualToString:@"00000300000000000000"] || [em.chatter isEqualToString:@"00000400000000000000"] || [em.chatter isEqualToString:@"00000500000000000000"]) {
                    if (model.liuyanCount != 0) {
                        [self.tabBarController.tabBar showBadgeOnItemIndex:3];
                    }
                    //通知、审批、工作报告、任务、资讯
                    model = [self xinxiMokuai:model EM:em];
                    redCount++;
                    [self tihuanMaopaoPaixu:model EMConversation:em];
                    [_tableView reloadData];
                }else{
                    if (yonghuArray.count) {
                        //单聊数据库取值
                        [self danliaoShujukuMokuai:model EM:em];
                        [_tableView reloadData];
                    }else{
                        //单聊网络取值
                        [self danliaoWangluoMokuai:model EM:em];
                    }
                }
            }
        }else{
            NSLog(@"群聊");
            [[EaseMob sharedInstance].chatManager asyncFetchGroupInfo:em.chatter completion:^(EMGroup *group, EMError *error) {
                yonghuArray =[YonghuStores getAllWithGongsiID:[AppStore getGongsiID]];
                if (group.occupants) {
                    if (yonghuArray.count) {
                        //群组数据库取值
                        [self qunliaoShujukuMokuai:model EMGroup:group EM:em];
                        [self tihuanMaopaoPaixu:model EMConversation:em];
                        [_tableView reloadData];
                    }else{
                        //群组网络取值
                        [self qunliaoWangluoMokuai:model EMGroup:group EM:em];
                    }
                }
            } onQueue:nil];
        }
    }
}



#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WeixinQunzuCellVM *object =  (WeixinQunzuCellVM *)[dataArray objectAtIndex:indexPath.row];
    if (object.xinxi) {
        
        EMConversation * _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:object.chatter conversationType:eConversationTypeChat];
        [_conversation markAllMessagesAsRead:YES];
        
        if ([object.chatter isEqualToString:@"00000100000000000000"]) {
            [self chuliXinxi:@"APPLY"];
            //审批
            ShengpiLieBiaoViewController *shenpiVC = [[ShengpiLieBiaoViewController alloc] init];
            shenpiVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:shenpiVC animated:YES];
        }else if ([object.chatter isEqualToString:@"00000300000000000000"]){
            [self chuliXinxi:@"NOTICE"];
            //通知
            TongzhiViewController *tongzhiVC = [[TongzhiViewController alloc] init];
            tongzhiVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:tongzhiVC animated:YES];
        }else if ([object.chatter isEqualToString:@"00000500000000000000"]){
            [self chuliXinxi:@"WORKPAPER"];
            //工作报告
            GongZuoBaoGao2ViewController *gongzuoVC = [[GongZuoBaoGao2ViewController alloc] init];
            gongzuoVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:gongzuoVC animated:YES];
        }else if ([object.chatter isEqualToString:@"00000200000000000000"]){
            [self chuliXinxi:@"INFO"];
            //资讯
            ZiXunViewController *zixunVC = [[ZiXunViewController alloc] init];
            zixunVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:zixunVC animated:YES];
        }else if ([object.chatter isEqualToString:@"00000400000000000000"]){
            [self chuliXinxi:@"TASK"];
            //任务
            RenWuViewController *renwuVC = [[RenWuViewController alloc] init];
            renwuVC.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:renwuVC animated:YES];
        }
    }else{
        ChatViewController *chatView =[[ChatViewController alloc]initWithChatter:object.chatter isGroup:object.chatType==eConversationTypeChat?NO:YES];
        chatView.name = object.name;
        chatView.Renyuanid = object.userid;
        chatView.phonto = object.touxiangStr;
        
        chatView.idArray = object.idArr;
        chatView.nameArray = object.nameArr;
        chatView.imageUrlArray = object.imageArr;
        chatView.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:chatView animated:YES];
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeixinQunzuCellVM *model = dataArray[indexPath.row];
    if (model.chatType == eConversationTypeGroupChat) {
        //群组删除
        BOOL RET =  [[EaseMob sharedInstance].chatManager removeConversationByChatter:model.groupid deleteMessages:YES append2Chat:YES];
        if (RET) {
            [dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else{
        //单聊删除
        NSString *lows;
        if (model.xinxi) {
            lows = model.chatter;
        }else{
           lows =[[model.userid substringToIndex:20] lowercaseString];
        }
        BOOL RET = [[EaseMob sharedInstance].chatManager removeConversationByChatter:lows deleteMessages:YES append2Chat:YES];
        if (RET) {
            [dataArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark - table View DataSource
//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (dataArray.count != 0) {
        return dataArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"dd%d",indexPath.row);
    if (dataArray.count != 0) {
        if (![[dataArray objectAtIndex:indexPath.row] isKindOfClass:[WeixinQunzuCellVM class]]) {
            XiaoxiCell *cell = [XiaoxiCell cellForTableView:tableView];
            XiaoxiModel *model = dataArray[indexPath.row];
            cell.model = model;
            return cell;
        }else{
            //NSArray *dd =(NSArray *)[dataArray objectAtIndex:indexPath.row];
            WeixinQunzuCellVM *object =(WeixinQunzuCellVM *)[dataArray objectAtIndex:indexPath.row];
            WeixinQunzuCellView *weixinView=[WeixinQunzuCellView cellForTableView:tableView];
            weixinView.model = object;
            return weixinView;
        }
    }
    return nil;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, self.view.height);
}

#pragma mark - 新建聊天
- (void)xinjianLiaotian{
//    [self rightItemClicked];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenyuanShuju:) name:@"xuanzhongArray" object:nil];
    
    XuanzeRenyuanViewController *xuanzeVC = [[XuanzeRenyuanViewController alloc] init];
    xuanzeVC.liaotian = YES;
    
    xuanzeVC.endureArray = [@[[AppStore getYongHuID]] mutableCopy];
    
    xuanzeVC.hidesBottomBarWhenPushed = YES;
    xuanzeVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:xuanzeVC];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 快速打卡
- (void)kuansuDaka{
//    [self rightItemClicked];
    
    if ([CLLocationManager locationServicesEnabled]) {
        DaKaViewController *daKaVC = [[DaKaViewController alloc] init];
        daKaVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:daKaVC animated:YES];
    }else{
        [LDialog showMessage:@"请打开您的定位功能"];
    }
    
}
#pragma mark - 新建日报
- (void)xinjianRibao{
//    [self rightItemClicked];
    
    XinJianBaoGaoViewController *xinjianVC = [[XinJianBaoGaoViewController alloc]init];
    xinjianVC.hidesBottomBarWhenPushed = YES;
    xinjianVC.leixing = 1;
    [self.navigationController pushViewController:xinjianVC animated:YES];
}

#pragma mark - 新建任务
- (void)xinjianRenwu{
//    [self rightItemClicked];
    
    XinJianRenWuViewController *xinjianRenwuVC = [[XinJianRenWuViewController alloc] init];
    xinjianRenwuVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:xinjianRenwuVC animated:YES];
}

#pragma mark - 被挤弹出警告
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
            NSLog(@"info%@",info);
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        } onQueue:nil];
    }else if (buttonIndex == 1){
        NSLog(@"d");
        [ServiceShell DengLu:[AppStore getYongHuShoujihao] Password:[AppStore getYongHuMima] Companyid:[AppStore getGongsiID] usingCallback:^(DCServiceContext *context, DengluSM *itemSM){
            if (!context.isSucceeded) {
                return ;
            }
            if (itemSM.status == 0) {
                if ([itemSM.data1.loginStatus isEqualToString:@"LOGIN_SUCCESS"]) {//多公司
                    if (itemSM.data1.lackdeptinfo == 0){//正常进入
                        
                        if(itemSM.data1.lackuserinfo == 0){//正常进入，登录成功
                            [ToolBox baocunYonghuShuju:itemSM.data data2:itemSM.data1 Password:[AppStore getYongHuMima] IsWanshan:YES];
                            [dataArray removeAllObjects];
                            [self loadLiaotian];
                        }
                        
                    }
                }else{
                    [SDialog showTipViewWithText:itemSM.msg hideAfterSeconds:1.5f];
                }
            }
            
        }];
    }
}

#pragma mark - 环信登陆成功相关
-(void)registerNotifications
{
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chushihua) name:@"Chushihuaxiaoxi" object:nil];
    
    //主动退出和解散的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chushihua) name:@"exit" object:nil];
    //被踹的回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chushihua) name:@"GroupLeave" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loignInHuanxin) name:@"logInHuanXinSuccess" object:nil];
}

#pragma mark - 环信登录成功调的方法
-(void)loignInHuanxin
{
    //登陆成功后的callback
    [self loadLiaotian];
}

#pragma mark 后台杀掉进入必须调用
-(void)didUnreadMessagesCountChanged
{
    [self loadLiaotian];
}

#pragma mark 将要接收离线非透传消息的回调
- (void)willReceiveOfflineMessages{
    
}

#pragma mark 接收到离线非透传消息的回调
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self loadLiaotian];
    
}

#pragma mark 离线非透传消息接收..完成的回调
- (void)didFinishedReceiveOfflineMessages{
    
}

#pragma mark 离开群组回调
- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    NSString *tmpStr = group.groupSubject;
    NSString *str;
    if (!tmpStr || tmpStr.length == 0) {
        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *obj in groupArray) {
            if ([obj.groupId isEqualToString:group.groupId]) {
                tmpStr = obj.groupSubject;
                break;
            }
        }
    }
    
    if (reason == eGroupLeaveReason_BeRemoved) {
        //剔除
        str = [NSString stringWithFormat:NSLocalizedString(@"group.beKicked", @"you have been kicked out from the group of \'%@\'"), tmpStr];
    }else if (reason ==eGroupLeaveReason_Destroyed){
        //群主销毁
        str =[NSString stringWithFormat:NSLocalizedString(@"group.destroy", @"dismiss group")];
    }else{
        //自己退出
        str =[NSString stringWithFormat:NSLocalizedString(@"group.leave", @"quit the group")];
    }
    if (str.length > 0) {
        //TTAlertNoTitle(str);
        for (int i= 0; i<dataArray.count; i++) {
            id obj =[dataArray objectAtIndex:i];
            if ([obj isKindOfClass:[WeixinQunzuCellVM class]]) {
                WeixinQunzuCellVM *dm =(WeixinQunzuCellVM *)obj;
                if ([dm.chatter isEqualToString:group.groupId]) {
                    [dataArray removeObjectAtIndex:i];
                    [_tableView reloadData];
                }
            }
        }
    }
}

#pragma mark 修改数据
- (void)xiugaishuju{
    
    NSString *time = [ToolBox jiedangCompanyid:[AppStore getGongsiID]];
    UpdateCompanyPersonsSM *personSM = [[UpdateCompanyPersonsSM alloc] init];
    personSM.companyid = [AppStore getGongsiID];
    personSM.updatedtime = time;
    NSMutableArray *userid = [@[] mutableCopy];
    for (YonghuInfoDB *db in yonghuArray) {
        [userid addObject:db.userid];
    }
    personSM.userid = [userid componentsJoinedByString:@","];
    [ServiceShell getcheckUpdateCompanyPersonsWithUpdateCompanyPersonsSM:personSM Priorityyouxianji:YES usingCallback:^(DCServiceContext *serviceContext, ResultModelOfcheckUpdateCompanyPersonsSM *sm) {
        if (serviceContext.isSucceeded && sm.status == 0) {
            [ToolBox chuliTime:sm.data2 isArchive:YES companyid:[AppStore getGongsiID]];
            for (CheckUpdateCompanyPersonsSM *checkUpdate in sm.data) {
                NSMutableArray *yonghuShuzu = [@[] mutableCopy];
                for (YonghuInfoDB *db in yonghuArray) {
                    [yonghuShuzu addObject:db.userid];
                }
                
                if ([yonghuShuzu containsObject:checkUpdate.userid]) {
                    [YonghuStores updataWithName:checkUpdate.name Letter:checkUpdate.letter Deptid:checkUpdate.deptid Phone:checkUpdate.phone Imgurl:checkUpdate.imgurl Deptname:checkUpdate.deptname zhiwei:checkUpdate.position ID:checkUpdate.userid];
                    
                }else{
                    if (checkUpdate.userid.length >= 20) {
                        [YonghuStores InsertWithUserid:[self panDuanIsNull:checkUpdate.userid] Name:[self panDuanIsNull:checkUpdate.name] Letter:[self panDuanIsNull:checkUpdate.letter] Email:[self panDuanIsNull:checkUpdate.email] Phone:[self panDuanIsNull:checkUpdate.phone] Wechat:[self panDuanIsNull:checkUpdate.wechat] QQ:[self panDuanIsNull:checkUpdate.qq] Birthday:[self panDuanIsNull:@""] Hobby:[self panDuanIsNull:@""] Imgurl:[self panDuanIsNull:checkUpdate.imgurl] Companyid:[AppStore getGongsiID] Position:[self panDuanIsNull:checkUpdate.position] Jobnumber:[self panDuanIsNull:checkUpdate.jobnumber] Deptid:[self panDuanIsNull:checkUpdate.deptid] Deptname:[self panDuanIsNull:checkUpdate.deptname]];
                    }
                    
                }
                
            }
            
            if (sm.data1.count != 0) {
                for (NSString *DelUserid in sm.data1) {
                    [YonghuStores DeleteWithID:DelUserid];
                }
            }
        }
    }];
}

#pragma mark 判断是否为空
- (NSString *)panDuanIsNull:(id)text{
    if (text == nil || [text isEqual:[NSNull null]] || text == NULL) {
        return @"";
    }else{
        return text;
    }
}

#pragma mark 替换与冒泡排序
- (void)tihuanMaopaoPaixu:(WeixinQunzuCellVM *)model EMConversation:(EMConversation *)em{
    // 替换重复的，添加最新的
    NSMutableArray *tempArray = [@[] mutableCopy];
    [tempArray addObject:model];
    for (int i = 0; i < tempArray.count; i++) {
        WeixinQunzuCellVM *tempVM = tempArray[i];
        for (int j = 0; j < dataArray.count; j++) {
            if ([dataArray[j] isKindOfClass:[WeixinQunzuCellVM class]]) {
                WeixinQunzuCellVM *vm = dataArray[j];
                if ([vm.chatter isEqualToString:em.chatter]) {
                    [dataArray replaceObjectAtIndex:j withObject:tempVM];
                }
            }
            
        }
        if ([dataArray indexOfObject:model] == NSNotFound) {
            [dataArray addObject:model];
        }
    }
    
    if (dataArray.count > 1) {
        for (int i = 0; i < dataArray.count; i++) {
            WeixinQunzuCellVM *vm1 = dataArray[i];
            for(int j=i+1;j<dataArray.count;j++){
                WeixinQunzuCellVM *vm2 = dataArray[j];
                if (vm1.timestamp<vm2.timestamp) {
                    WeixinQunzuCellVM *temp = vm1;
                    //                                        vm1 = vm2;
                    //                                        vm2 = temp;
                    [dataArray replaceObjectAtIndex:i withObject:vm2];
                    [dataArray replaceObjectAtIndex:j withObject:temp];
                }
            }
        }
    }
}


- (void)chuliXinxi:(NSString *)msg{
    [ServiceShell getMsgToRedWithUserid:[AppStore getYongHuID] Module:msg usingCallback:^(DCServiceContext *serviceContext, ResultMode *model) {
        [LDialog closeWaitBox];
        if (!serviceContext.isSucceeded) {
            return ;
        }
        
        if (model.status == 0) {
            redCount--;
            if (redCount == 0) {
                [self.tabBarController.tabBar hideBadgeOnItemIndex:3];
            }
        }
    }];
}

#pragma mark 全部
- (void)quanbuData{
    [ServiceShell getCompanyPersonsWithCompanyid:[AppStore getGongsiID] Start:Start Count:Count Priorityyouxianji:YES usingCallback:^(DCServiceContext *serviceContext, ResultModelOfCompanyPersonsSM *PersonsSM) {
        if (!serviceContext.isSucceeded) {
            return ;
        }
        
        if (PersonsSM.data.count != 0) {
            
            if (PersonsSM.data.count != Count){
                [self saveDataInDBWithResultModelOfCompanyPersonsSM:PersonsSM];
                return ;
            }
            [self saveDataInDBWithResultModelOfCompanyPersonsSM:PersonsSM];
            dispatch_queue_t newQueue =dispatch_queue_create("NEW", NULL);
            dispatch_async(newQueue, ^{
                /* vvvvv */
                beishu++;
                Start = Count*beishu;
                if([self respondsToSelector:@selector(quanbuData)])
                    [self quanbuData];
                
            });
        }
        
    }];
}

- (void)saveDataInDBWithResultModelOfCompanyPersonsSM:(ResultModelOfCompanyPersonsSM*)PersonsSM
{
    
    dispatch_queue_t myQueue = dispatch_queue_create("jhon", NULL);
    dispatch_async(myQueue, ^{
        /*由于数据太多有时候会出现，数据库执行失败的情况.
         所以每保存200个休息0.25秒
         */
        for (DeptPersonsSM *sm in PersonsSM.data) {
            [YonghuDB saveToDB:sm];
        }
    });
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == dataArray.count-1) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }else{
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    
}

@end
