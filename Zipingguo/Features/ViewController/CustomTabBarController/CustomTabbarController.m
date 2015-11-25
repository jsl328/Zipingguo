//
//  CustomTabbarController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "CustomTabbarController.h"
#import "RootViewController.h"
#import "UINavigationController+Customer.h"
#import "XiaoxiViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CallViewController.h"
#import "EMCDDeviceManager+Remind.h"
#import "ChatViewController.h"
@interface CustomTabbarController ()
{
    XiaoxiViewController *xiaoVC;
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@property (strong, nonatomic) NSMutableArray *yonghuArrs;
@end

@implementation CustomTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _yonghuArrs =[@[]mutableCopy];
    xiaoVC = [[XiaoxiViewController alloc] init];
    _yonghuArrs =[YonghuStores getAllWithGongsiID:[AppStore getGongsiID]];
    
    //注册环信监听
    [self registerEaseMobNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUntreatedApplyCount) name:@"setupUntreatedApplyCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callControllerClose:) name:@"callControllerClose" object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self createViewControllers];
    
    [self setupUnreadMessageCount];
}

- (void)createViewControllers{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ControllerData" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    //收集视图控制器对象
    NSMutableArray *controllers = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        //取到类名
        NSString *className = [dic objectForKey:@"controllerName"];
        //NSClassFromString 根据类名获取到对应的类
        //Class 为类的泛型     id 为对象的泛型
        Class class = NSClassFromString(className);
        //用不通的类进行alloc init ，得到的对象，可以用它们共同的父类指针来接收，得益于oc的动态运行时机制，会把root按照不通的控制器对象来处理
        RootViewController *root = [[class alloc] init];
        
        //设置标题
        root.title = [dic objectForKey:@"titleName"];
        NSString *imageName = [dic objectForKey:@"imageName"];
        NSString *selectImageName = [imageName stringByAppendingFormat:@"选中"];
        UIImage *Image = [UIImage imageNamed:imageName];
        UIImage *ImageSel = [UIImage imageNamed:selectImageName];
        
        Image = [Image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        ImageSel = [ImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //使用高版本才有的方法之前，要先判断
        if ([root.tabBarItem respondsToSelector:@selector(initWithTitle:image:selectedImage:)]) {
            //ios7
            UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[dic objectForKey:@"titleName"] image:Image selectedImage:ImageSel];
            root.tabBarItem = item;
        }else{
            //ios6
            
            [root.tabBarItem setFinishedSelectedImage:ImageSel withFinishedUnselectedImage:Image];
        }
        //设置title偏移量....
        [root.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0.0, -3.0)];
        
        [root.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: RGBACOLOR(53, 55, 68, 1),UITextAttributeTextShadowColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeFont:[UIFont systemFontOfSize:10.f]} forState:UIControlStateNormal];
        [root.tabBarItem setTitleTextAttributes:@{UITextAttributeTextColor: RGBACOLOR(4, 175, 245, 1),UITextAttributeTextShadowColor: [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeFont:[UIFont systemFontOfSize:10.f]} forState:UIControlStateSelected];
        
        root.tabBarItem.imageInsets =UIEdgeInsetsMake(0, 0, 0, 0);
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:root];
        
        navController.navigationBar.translucent = NO;
        [navController.navigationBar setBackgroundImage:[UIImage imageNamed:@"-bg.png"] forBarMetrics:UIBarMetricsDefault];
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"-bg.png"] forBarMetrics:UIBarMetricsDefault];
            [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:98.f/255.f green:182.f/255.f blue:239.f/255.f alpha:1.f]];
            [[UINavigationBar appearance] setTitleTextAttributes:
             [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@ "Arial Rounded MT Bold" size:18.0], NSFontAttributeName, nil]];
        }
        
        [controllers addObject:navController];
    }
    self.viewControllers = controllers;
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    for (UINavigationController *nvc in self.viewControllers) {
        for (UIViewController *vc in nvc.viewControllers) {
            
            if ([vc isKindOfClass:[XiaoxiViewController class]]) {
                xiaoVC =(XiaoxiViewController *)vc;
                if (unreadCount > 0) {
                    xiaoVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
                }else{
                    xiaoVC.tabBarItem.badgeValue = nil;
                }
            }
        }
    }
//
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
}

- (void)setupUntreatedApplyCount
{
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//        if (unreadCount > 0) {
//            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _contactsVC.tabBarItem.badgeValue = nil;
//        }
//    }
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [xiaoVC networkChanged:connectionState];
}

#pragma mark - call
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    if (!bCanRecord) {
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setting.microphoneNoAuthority", @"No microphone permissions") message:NSLocalizedString(@"setting.microphoneAuthority", @"Please open in \"Setting\"-\"Privacy\"-\"Microphone\".") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alt show];
    }
    
    return bCanRecord;
}

- (void)callOutWithChatter:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        if (![self canRecord]) {
            return;
        }
        
        EMError *error = nil;
        NSString *chatter = [object objectForKey:@"chatter"];
        EMCallSessionType type = [[object objectForKey:@"type"] intValue];
        EMCallSession *callSession = nil;
        if (type == eCallSessionTypeAudio) {
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:50 error:&error];
        }
        else if (type == eCallSessionTypeVideo){
            if (![CallViewController canVideo]) {
                return;
            }
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:50 error:&error];
        }
        
        if (callSession && !error) {
            [[EaseMob sharedInstance].callManager removeDelegate:self];
            
            CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:NO];
            callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:callController animated:NO completion:nil];
        }
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error") message:error.description delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (void)callControllerClose:(NSNotification *)notification
{
    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    [audioSession setActive:YES error:nil];
    //[[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

#pragma mark - IChatManagerDelegate 消息变化
- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
//    [xiaoVC loadLiaotian];
}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    //[self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_simpleBanner) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        //NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        
        
       __block NSString *groupName=nil;
       __block NSString *title;
        NSMutableArray *yonghuArray = [@[] mutableCopy];
        yonghuArray =[YonghuStores getAllWithGongsiID:[AppStore getGongsiID]];
        
        NSMutableArray *subuidArray = [@[]mutableCopy];
        for (YonghuInfoDB *db in yonghuArray) {
            [subuidArray addObject:[db.userid substringToIndex:20]];
        }
        
        if ([subuidArray containsObject:message.messageType == eMessageTypeGroupChat?message.groupSenderName:message.from]) {
            for (YonghuInfoDB *db in yonghuArray) {
                NSString *ID = [[db.userid substringToIndex:20] lowercaseString];
                if ([ID isEqualToString:[message.messageType == eMessageTypeGroupChat?message.groupSenderName:message.from lowercaseString]]) {
                    groupName = db.name;
                    title = db.name;
                    break;
                }
            }
        }else{
            
            if ([message.from isEqualToString:@"00000100000000000000"] || [message.from isEqualToString:@"00000200000000000000"] || [message.from isEqualToString:@"00000300000000000000"] || [message.from isEqualToString:@"00000400000000000000"] || [message.from isEqualToString:@"00000500000000000000"]) {
                title = [self fanhuiXinxi:message.from];
            }else{
                NSString *ID =[message.messageType == eMessageTypeGroupChat?message.groupSenderName:message.from lowercaseString];
                [ServiceShell getUserinfoByHxnameWithAppIds:ID usingCallback:^(DCServiceContext *ser, ResultModelOfUserinfoByHxnameSM *results) {
                    if (results.data.count) {
                        UserinfoByHuanxinSM *sm =[results.data objectAtIndex:0];
                        groupName = sm.name;
                        title =sm.name;
                    }
                }];
            }
        }
        
        if (message.messageType == eMessageTypeGroupChat) {
            if ([message.groupSenderName isEqualToString:@"admin"]) {
                title = @"系统管理员";
            }else{
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager loadAllMyGroupsFromDatabaseWithAppend2Chat:YES];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationChatter]) {
                        title = [NSString stringWithFormat:@"%@(%@)", groupName, group.groupSubject];
                        break;
                    }
                }
            }
        }
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    UIApplication *application = [UIApplication sharedApplication];
     application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）
- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [xiaoVC isConnect:YES];
    }
}

#pragma mark - IChatManagerDelegate 登录状态变化
- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
        [self unRegisterEaseMobNotification];
        
    } onQueue:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100||alertView.tag == 101) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
        alertView.tag = 101;
        [alertView show];
        
        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:NO];
        [self unRegisterEaseMobNotification];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    } onQueue:nil];
}

- (void)didServersChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didAppkeyChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - 自动登录回调
- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        //[self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            //[self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
    [xiaoVC isConnect:YES];
}

#pragma mark - ICallManagerDelegate
//打电话状态的回调
- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error
{
    if (callSession.status == eCallSessionStatusConnected)
    {
        EMError *error = nil;
        do {
            BOOL isShowPicker = [[[NSUserDefaults standardUserDefaults] objectForKey:@"isShowPicker"] boolValue];
            if (isShowPicker) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
            if (![self canRecord]) {
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
#warning 在后台不能进行视频通话
            if(callSession.type == eCallSessionTypeVideo && ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive || ![CallViewController canVideo])){
                error = [EMError errorWithCode:EMErrorInitFailure andDescription:NSLocalizedString(@"call.initFailed", @"Establish call failure")];
                break;
            }
            
            if (!isShowPicker){
                [[EaseMob sharedInstance].callManager removeDelegate:self];
                CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:YES];
                callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:callController animated:NO completion:nil];
                if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]])
                {
                    ChatViewController *chatVc = (ChatViewController *)self.navigationController.topViewController;
                    chatVc.isInvisible = YES;
                }
            }
        } while (0);
        
        if (error) {
            [[EaseMob sharedInstance].callManager asyncEndCall:callSession.sessionId reason:eCallReasonHangup];
            return;
        }
    }
}

#pragma mark - public
- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
        [chatController hideImagePicker];
    }
    else if(xiaoVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:xiaoVC];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.chatter isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMMessageType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case eMessageTypeGroupChat:
                            {
                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.groupSubject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMMessageType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case eMessageTypeGroupChat:
                    {
                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.groupSubject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (xiaoVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:xiaoVC];
    }
}

-(void)didUpdateGroupList:(NSArray *)groupList error:(EMError *)error
{
    //登录导入群组
}

#pragma mark - registerEaseMobNotification
- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

- (NSString *)fanhuiXinxi:(NSString *)chatter{
    if ([chatter isEqualToString:@"00000100000000000000"]) {
        return @"审批";
    }
    if ([chatter isEqualToString:@"00000200000000000000"]) {
        return @"资讯";
    }
    if ([chatter isEqualToString:@"00000300000000000000"]) {
        return @"通知";
    }
    if ([chatter isEqualToString:@"00000400000000000000"]) {
        return @"任务";
    }
    if ([chatter isEqualToString:@"00000500000000000000"]) {
        return @"工件报告";
    }
    return @"";
}

@end
