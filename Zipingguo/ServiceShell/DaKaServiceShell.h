//
//  DaKaServiceShell.h
//  Zipingguo
//
//  Created by sunny on 15/10/27.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JinRiJiLuListSM.h"
#import "DaKaWaiChuRecordSM.h"

#import "DaKaSM.h"
#import "DaKaJiLuSM.h"


@interface DaKaServiceShell : NSObject

/**
 *  上传打卡记录 -- 通用常规和外出
 *
 *  @param daKaSM   daKaSM description
 *  @param callback callback description
 */
+ (void)daKaPostWithDaKaSM:(DaKaSM *)daKaSM UsingCallback:(void(^)(DCServiceContext *context,ResultMode *sm))callback;

/**
 *  获取打卡记录 -- 今日，常规，外出通用
 *
 *  @param yongHuID  用户ID
 *  @param daKaType  打卡类型 1-打卡考勤-2-外出
 *  @param isToday   是否为今天  0是全部，1是今日
 *  @param start     从第几个开始
 *  @param countSize 一页多少个
 *  @param callback  callback description
 */

+ (void)daKaGetRecordWithYongHuID:(NSString *)yongHuID DaKaType:(int)daKaType IsToday:(int)isToday Start:(int)start CountSize:(int)countSize UsingCallback:(void(^)(DCServiceContext *context,DaKaJiLuSM *sm))callback;


/**
 *  获取今日打卡记录
 *
 *  @param yongHuID 用户ID
 *  @param callback 今日记录列表
 */
+ (void) getTodayAttendanceRecordWithYongHuID:(NSString *)yongHuID UsingCallback:(void(^)(DCServiceContext *context,JinRiJiLuListSM *sm))callback;

/**
 * 常规打卡
 *
 *  @param yongHuID  用户ID
 *  @param address   地址
 *  @param companyID 公司
 *  @param callback  callback description
 */
+ (void) changGuiDaKaShangChuanWithYongHuID:(NSString *)yongHuID Address:(NSString *)address CompanyID:(NSString *)companyID UsingCallback:(void(^)(DCServiceContext *context,ResultMode *sm))callback;
/**
 *  外出打卡
 *
 *  @param waiChuSM 外出打卡SM
 *  @param callback callback description
 */
+ (void) waiChuDaKaWithWaiChuRecordSM:(DaKaWaiChuRecordSM *)waiChuSM UsingCallback:(void(^)(DCServiceContext *context,ResultMode *sm))callback;

/**
 *  获取常规打卡记录
 *
 *  @param yongHuID  <#yongHuID description#>
 *  @param start     <#start description#>
 *  @param countSize <#countSize description#>
 *  @param isToday   <#isToday description#>
 *  @param callback  <#callback description#>
 */
+ (void) getChangGuiDaKaRecordWithYongHuID:(NSString *)yongHuID Start:(int)start CountSize:(int)countSize IsToday:(int)isToday usingCallback:(void (^)(DCServiceContext *content, JinRiJiLuListSM *sm)) callback;
@end
