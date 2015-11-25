//
//  ToolBox.h
//  Zipingguo
//
//  Created by lilufeng on 15/11/3.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DengluSM.h"
#import "ListView.h"

typedef void(^Dissmiss)();

@interface ToolBox : NSObject
@property (nonatomic,strong) Dissmiss myDissmiss;
/**
 *  时间转化
 *
 *  @param date   时间date
 *  @param istime 是否是时间？yes-- @"yyyy-MM-dd HH:mm:ss"  no -- @"yyyy年MM月dd日"
 *
 *  @return 时间字符串
 */
+ (NSString *)shijianStringWith:(NSDate *)date isTime:(BOOL)istime;

/**
 *  保存用户数据
 */
+ (void)baocunYonghuShuju:(UserDataSM *)sm data2:(DengluData1 *)data1 Password:(NSString *)password IsWanshan:(BOOL)wanshan;

/**
 *  获取数据
 */
+ (void)huoquShuju;

/**
 *  弹出警告
 */

+ (void)Tanchujinggao:(NSString *)msg IconName:(NSString *)iconName;
/**
 *  弹出警告 -- block消失后执行
 *
 *  @param msg      弹出的信息
 *  @param iconName 头像
 *  @param dismiss
 */
+ (void)Tanchujinggao:(NSString *)msg IconName:(NSString *)iconName  DissMiss:(Dissmiss)dismiss;

/**
 *  判断是否为11位纯数字 --- 手机号
 *
 *  @param phoneNumber 手机号
 *
 *  @return YES - 是手机号
 */
+ (BOOL)checkPhoneNumInput:(NSString *)phoneNumber;
/**
 *  判断是否为6位纯数字 --- 验证码
 *
 *  @param phoneNumber 验证码
 *
 *  @return YES - 是验证码
 */
+ (BOOL)checkYanZhengMaInput:(NSString *)number;

/**
 *  解档
 */

+ (NSString *)jiedangCompanyid:(NSString *)companyid;

/**
 *  归档
 */
+ (NSString *)chuliTime:(NSString *)nowTime isArchive:(BOOL)isArchive companyid:(NSString *)companyid;

+ (UIColor *) colorWithHexString: (NSString *)color;

/**
 *  颜色转图片
 *
 *  @param color 颜色
 *
 *  @return 图片
 */
+(UIImage *)imageWithColor:(UIColor *)color;



+(void) showList:(NSArray *)items images:(NSArray *)images forAlignment:(ListViewAlignment)alignment callback:(void (^)(int index)) buttonClickCallback ;

+(void) showList:(NSArray *)items selectedIndex:(NSInteger)index forAlignment:(ListViewAlignment)alignment callback:(void (^)(int index)) buttonClickCallback ;
@end
