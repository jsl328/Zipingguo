//
//  Zipingguo.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/9.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#ifndef Zipingguo_Zipingguo_h
#define Zipingguo_Zipingguo_h

#define MAPKIT @"vl1aTKjqRzjdSmYpS2CRiMdz"

#define UMAppKey (@"5625e74367e58e04dd00046d")
#define QQAppKey (@"sVhYpaynfe49de8G")
#define QQAppID (@"1104918536")
#define WeiXinAppKey (@"wx8b714b5dffca27ae")
#define WeiXinAppSecret (@"e1a41ff9844e6a387ba801939d5702d4")

#define IS_IPHONE_4S ([[UIScreen mainScreen] bounds].size.height == 480)
#define IS_IPHONE_5S ([[UIScreen mainScreen] bounds].size.height == 568)
#define IS_IPHONE_6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define IS_IPHONE_6_PLUS ([[UIScreen mainScreen] bounds].size.height == 1104)

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

#define ScreenWidth [[UIScreen mainScreen]bounds].size.width

#define ScreenHeight [[UIScreen mainScreen]bounds].size.height

#define IOSDEVICE ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define URLKEY @"http://123.57.7.202/fileupload/FileDownloadServlet?path="

#define Khuanxin_dis @"dis_push_Zipingguo"

#define Khuanxin_dev @"dev_push_Zipingguo"

#define HuanXin_appkey @"lianyou#yami"


#define NavHeight (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ?  64 : 44)
#define Bg_Color RGBACOLOR(248,248,248,1)

#define Fenge_Color RGBACOLOR(226, 226, 226, 1)

#define deptGrayColor [UIColor colorWithRed:53.f/255.f green:55.f/255.f blue:68.f/255.f alpha:1.f];

#define lightColor [UIColor colorWithRed:160.f/255.f green:160.f/255.f blue:162.f/255.f alpha:1.f];

#define BlueColor [UIColor colorWithRed:98.f/255.f green:182.f/255.f blue:239.f/255.f alpha:1.f];

#define ShareApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])
/**
 * @breif  非空判断OC字符串
 */
#define FeiKongPanDuanNSString(object) \
[(object) isKindOfClass:[NSNull class]]?@"":(object)

#define fenXiangURL (@"http://123.57.7.202")

#endif
