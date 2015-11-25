//
//  AppDelegate.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "AppDelegate.h"
#import "DCExceptionFunctions.h"
#import "AppDelegate+EaseMob.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "IQKeyboardManager.h"
#import "Base64JiaJieMi.h"

#include "EMCDDeviceManager+Remind.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UMSocialData setAppKey:UMAppKey];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSLog(@"沙盒路径%@",documentsDirectory);
    
     NSLog(@"沙盒路径%@",documentsDirectory);
     NSLog(@"沙盒路径%@",documentsDirectory);
     NSLog(@"沙盒路径%@",documentsDirectory);
    
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;// 默认不启用
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;// 默认不显示工具条
    manager.shouldShowTextFieldPlaceholder = NO;//不显示提示语
    manager.layoutIfNeededOnUpdate = YES;
    
    //百度地图
    [self baiduDituShouquan];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    //读取数据，并进行判断
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *sessionid = [defaults objectForKey:@"sessionid"];
//    [self zhengshiFuwuqi:sessionid];
    [self ceshiFuwuqi:sessionid];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)ceshiFuwuqi:(NSString *)sessionid{
    if (sessionid.length == 0) {
        [self loginStateChange:nil];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }
}

- (void)zhengshiFuwuqi:(NSString *)sessionid{

    if (sessionid.length == 0) {
        [self DengLu:@"18270281020" Pwd:@"123456" GongSiID:@"1"];


    }else{
        [ToolBox huoquShuju];
        [self siginHuanxin];
    }
    CustomTabbarController *tabController = [[CustomTabbarController alloc] init];
    self.window.rootViewController = tabController;
    
}

#pragma mark - 登录
- (void)DengLu:(NSString *)phone Pwd:(NSString *)pwd GongSiID:(NSString *)gongSiID{
    
    [LDialog showWaitBox:@"登录中"];
    [ServiceShell DengLu:phone Password:[Base64JiaJieMi base64_BianMaZiFuChuan:pwd] LoginType:@"IOS" NetType:[self wangluoZhuangtai] Version:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] usingCallback:^(DCServiceContext *context, Denglu2SM *itemSM) {
        [LDialog closeWaitBox];
        if (context.isSucceeded) {
            if (itemSM.status == 0 || itemSM.status == 2) {
                [self baocunShuju:itemSM.xinxiData];
                [self siginHuanxin];
                
            }
        }
    }];
}
#pragma mark 保存数据
- (void)baocunShuju:(GongSiSM *)sm{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"2015-10-09 18:01:01" forKey:@"nowTime"];
    [userDefaults setObject:sm.companyid forKey:@"companyid"];
    [userDefaults setObject:sm.ID forKey:@"userid"];
    if (sm.imgurl != nil) {
        [userDefaults setObject:sm.imgurl forKey:@"imgurl"];
    }else{
        [userDefaults setObject:@"" forKey:@"imgurl"];
    }
    [userDefaults setObject:sm.name forKey:@"name"];
    [userDefaults setObject:sm.position forKey:@"position"];
    [userDefaults setObject:sm.sessionid forKey:@"sessionid"];
    [userDefaults setObject:sm.phone forKey:@"phone"];
    
    [userDefaults synchronize];
    [self huoquShuju2];
}

- (NSString *)wangluoZhuangtai{
    switch ([NetWork getNetworkTypeFromStatusBar]) {
        case NETWORK_TYPE_NONE:
            return @"其它";
            break;
        case NETWORK_TYPE_2G:
            return @"2G";
            break;
        case NETWORK_TYPE_3G:
            return @"3G";
            break;
        case NETWORK_TYPE_4G:
            return @"4G";
        case NETWORK_TYPE_5G:
            return @"5G";
            break;
        case NETWORK_TYPE_WIFI:
            return @"WIFI";
            break;
    }
}

#pragma mark 获取数据
- (void)huoquShuju2{
    
    //读取数据，并进行判断
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *companyid = [defaults objectForKey:@"companyid"];
    NSString *userid = [defaults objectForKey:@"userid"];
    NSString *imgurl = [defaults objectForKey:@"imgurl"];
    NSString *name = [defaults objectForKey:@"name"];
    NSString *position = [defaults objectForKey:@"position"];
    NSString *sessionid = [defaults objectForKey:@"sessionid"];
    NSString *phone = [defaults objectForKey:@"phone"];
    
    [AppStore setGongsiID:companyid];
    [AppStore setYongHuID:userid];
    [AppStore setYonghuImageView:imgurl];
    [AppStore setYongHuMing:name];
    [AppStore setZhiwei:position];
    [AppStore setSessionid:sessionid];
    [AppStore setYongHuShoujihao:phone];
}


- (void)setUMSharedWith:(NSString *)fenXiangUrl{
//    [UMSocialData openLog:YES];
    [UMSocialData setAppKey:UMAppKey];
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:fenXiangUrl];
    [UMSocialWechatHandler setWXAppId:WeiXinAppKey appSecret:WeiXinAppSecret url:fenXiangUrl];
}

#pragma mark - 百度授权
- (void)baiduDituShouquan{
    if([[UIDevice currentDevice].systemVersion floatValue] > 8.0f)
    {
        self.locationManager =[ [CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    mapManager=[[BMKMapManager alloc]init];
    BOOL re=[mapManager start:MAPKIT generalDelegate:self];
    if (!re) {
        NSLog(@"打开地图失败");
    }else{
        NSLog(@"打开百度地图成功");
    }
}

-(void)onGetNetworkState:(int)iError
{
    NSLog(@"返回网络错误%d",iError);
}
-(void)onGetPermissionState:(int)iError
{
    if (iError == 0) {
        NSLog(@"授权成功");
    }else if (iError ==2){
        NSLog(@"网络连接错误");
    }else if (iError ==3){
        NSLog(@"数据错误");
    }else if (iError ==100){
        NSLog(@"搜索结果未找到");
    }else if (iError ==200){
        NSLog(@"定位失败");
    }else if (iError ==300){
        NSLog(@"百度地图API授权Key验证失败");
    }else if (iError ==310){
        NSLog(@" 数据解析失败");
    }else if (iError ==4){
        NSLog(@"<起点或终点选择(有歧义)");
    }
    
}


#pragma mark - 是否登录环信
-(void)siginHuanxin
{
    NSString *username = [self lastLoginUsername];
    if (username && username.length > 0) {
        if (![username isEqualToString:[[[AppStore getYongHuID] substringToIndex:20] lowercaseString]]) {
            [self loginOffHuanxinLogin:YES];
        }else{
            return;
        }
    }else{
        [self loginInHuanxin];
    }
}

#pragma  mark - private 保存最后登录名字
- (void)saveLastLoginUsername
{
    NSString *username = [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:kSDKUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
    }
}
#pragma mark - 退出环信
-(void)loginOffHuanxinLogin:(BOOL)login
{
    //NSLog(@",,,%@",[AppStore getYongHuShoujihao]);
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        //NSLog(@"dd%@",error.description);
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:nil forKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
        [ud synchronize];
        [[EaseMob sharedInstance].chatManager isLoggedIn];
        if (login) {
            [self loginInHuanxin];
        }
    } onQueue:nil];
}

#pragma mark - 登录环信

-(void)loginInHuanxin
{
    NSLog(@"要登陆环信的账号%@",[[AppStore getYongHuID] substringToIndex:20]);
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[[[AppStore getYongHuID] lowercaseString] substringToIndex:20] password:[AppStore getYongHuShoujihao] completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error) {
            //设置是否自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            // 旧数据转换 (如果您的sdk是由2.1.2版本升级过来的，需要家这句话)
            [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
            //获取数据库中数据
            [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
            //获取群组列表
            [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
            //发送自动登陆状态通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logInHuanXinSuccess" object:nil];
            
            //保存最近一次登录用户名
            [self saveLastLoginUsername];
            NSLog(@"登陆的后的信息%@",loginInfo);
        }
        NSLog(@"第一次登陆的后的信息%@",error.description);
    } onQueue:nil];
}


#pragma mark - 友盟相关
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    //#warning SDK方法调用
    //即将进入后台
    [[EaseMob sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //已经进入后台
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
    //#warning SDK方法调用
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    [mapManager stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    [application setApplicationIconBadgeNumber:0];
    
    [mapManager start:MAPKIT generalDelegate:self];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //#warning SDK方法调用
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //#warning SDK方法调用
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - 最后一次登陆的用户名字
- (NSString*)lastLoginUsername
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_%@",kSDKUsername]];
    if (username && username.length > 0) {
        return username;
    }
    return nil;
}

#pragma mark - private判断是否进登录还是主页面

-(void)loginStateChange:(NSNotification *)notification
{
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) {
        
        for (UIViewController *vc in _tabbarVC.navigationController.viewControllers) {
            if ([vc isKindOfClass:[UIViewController class]]) {
                [vc removeFromParentViewController];
            }
        }
        _tabbarVC = [[CustomTabbarController alloc] init];
        [_tabbarVC networkChanged:_connectionState];
        self.window.rootViewController = _tabbarVC;
        [ToolBox huoquShuju];
        [self siginHuanxin];
    }else{
        [self loginOffHuanxinLogin:NO];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"" forKey:@"sessionid"];
        [userDefaults synchronize];
        
        for (UIViewController *vc in _tabbarVC.navigationController.viewControllers) {
            if ([vc isKindOfClass:[UIViewController class]]) {
                [vc removeFromParentViewController];
            }
        }
        _tabbarVC =nil;
        _dengluVC = [[DengluViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_dengluVC];
        
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg白.png"] forBarMetrics:UIBarMetricsDefault];
        nav.navigationBar.shadowImage = [[UIImage alloc] init];
        self.window.rootViewController = nav;
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (_tabbarVC) {
        [_tabbarVC jumpToChatList];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (_tabbarVC) {
        [_tabbarVC didReceiveLocalNotification:notification];
    }
}

@end
