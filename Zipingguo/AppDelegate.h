//
//  AppDelegate.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMNetworkMonitorDefs.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI/BMapKit.h>
#import "EaseMob.h"
#import "DengluViewController.h"
#import "CustomTabbarController.h"
#import "ToolBox.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate,EMChatManagerDelegate>
{
    EMConnectionState _connectionState;
    BMKMapManager *mapManager;
}
@property (strong, nonatomic) CustomTabbarController *tabbarVC;
@property (strong, nonatomic) DengluViewController *dengluVC;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
// 分享授权
- (void)setUMSharedWith:(NSString *)fenXiangUrl;
@end
