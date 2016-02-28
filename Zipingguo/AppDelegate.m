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
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

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
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //已经进入后台
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{


}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
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
