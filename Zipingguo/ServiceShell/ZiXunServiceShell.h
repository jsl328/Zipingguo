//
//  ZiXunServiceShell.h
//  Zipingguo
//
//  Created by sunny on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZiXunLeiBieListSM.h"
#import "ZiXunListSM.h"
#import "ZiXunXiangQingSM.h"
#import "ZiXunShouCangSM.h"
#import "ZiXunQuXiaoShouCangSM.h"
#import "ZiXunZanSM.h"
#import "ZiXunTiJiaoPingPunSM.h"
#import "ZiXunPingLunResultSM.h"

@interface ZiXunServiceShell : NSObject
/**
 *  获取资讯列表的标题数组
 *
 *  @param companyID 公司名
 *  @param callback  callback description
 */
+ (void) getZiXunLeiBieListWithCompanyID:(NSString *)companyID UsingCallback:(void (^)(DCServiceContext *context, ZiXunLeiBieListSM* sm)) callback;
/**
 *  获取最新资讯列表
 *
 *  @param start    其实数
 *  @param countSize    一次请求个数
 *  @param callback <#callback description#>
 */
+ (void)getZuiXinZiXunListWithStartIndex:(int)startIndex PageSize:(int)pageSize usingCallback:(void (^)(DCServiceContext *context, ZiXunListSM* sm)) callback;

/**
 *  获取收藏的咨询列表
 *
 *  @param userID   用户ID
 *  @param callback callback description
 */
+ (void)getShouCangZiXunListWithYongHuID:(NSString *)yongHuID StartIndex:(int)startIndex PageSize:(int)pageSize UsingCallback:(void (^)(DCServiceContext*context, ZiXunListSM* sm)) callback;
/**
 *  获取普通类别下的资讯列表
 *
 *  @param yongHuID   类别ID
 *  @param startIndex 起始数
 *  @param pageSize   页面大小
 *  @param callback   
 */
+ (void)getCommenZiXunListWithLeiBieID:(NSString *)leiBieID startIndex:(int)startIndex PageSize:(int)pageSize usingCallback:(void (^)(DCServiceContext *context, ZiXunListSM *sm)) callback;
/**
 *  资讯添加收藏
 *
 *  @param yongHuID 用户ID
 *  @param ziXunID  资讯ID
 *  @param callback callback description
 */
+ (void)shouCangZiXunWithYongHuID:(NSString *)yongHuID ZiXunID:(NSString *)ziXunID UsingCallback:(void (^)(DCServiceContext*context, ZiXunShouCangSM *sm)) callback;
/**
 *  资讯取消收藏
 *
 *  @param yongHuID 用户ID
 *  @param ziXunID  资讯ID
 *  @param callback callback description
 */
+ (void)quXiaoShouCangWithYongHuID:(NSString *)yongHuID ZiXunID:(NSString *)ziXunID UsingCallback:(void (^)(DCServiceContext*context, ZiXunQuXiaoShouCangSM *sm)) callback;

/**
 *  点赞
 *
 *  @param yongHuID   用户ID
 *  @param ziXunID    资讯ID
 *  @param createName 创建人
 *  @param callback   <#callback description#>
 */
+ (void)dianZanWithYongHuID:(NSString *)yongHuID ZiXunID:(NSString *)ziXunID CreateName:(NSString *)createName UsingCallback:(void (^)(DCServiceContext *context, ZiXunZanSM *sm)) callback;

+ (void)quXiaoZanWithYongHuID:(NSString *)yongHuID ZiXunID:(NSString *)ziXunID UsingCallback:(void (^)(DCServiceContext *context, ZiXunZanSM *sm)) callback;


/**
 *  获取资讯详情
 *
 *  @param ziXunID  资讯ID
 *  @param yongHuID 用户ID
 *  @param callback callback description
 */
+ (void) getZiXunXiangQingWithZiXunID:(NSString *)ziXunID YongHuID:(NSString *)yongHuID usingCallback:(void (^)(DCServiceContext *context, ZiXunXiangQingSM *sm)) callback;

/**
 *  资讯提交评论
 *
 *  @param yongHuID 用户ID
 *  @param content  评论/回复内容
 *  @param ziXunID  咨询ID
 *  @param isReply  A回复B，存放B评论的id，即为上级评论的id为0则为首次评论
 *  @param toParid  最顶级的评论id（首次评论后台将其设置为当前插入记录的id，即本评论的id，首次评论为空）
 *  @param atIDs    评论的@的人，应当将这些@的用户的id以英文逗号（’,’）连接，传入本参数
 *  @param callback callback description
 */
+ (void)ziXunTiJiaoPingLunWithYongHuID:(NSString *)yongHuID Content:(NSString *)content ZiXunID:(NSString *)ziXunID IsReply:(NSString *)isReply TopParid:(NSString *)topParid ATIDs:(NSString *)atIDs UsingCallback:(void (^)(DCServiceContext *context, ZiXunTiJiaoPingPunSM *sm)) callback;

/**
 *  获取资讯评论列表
 *
 *  @param ziXunID  资讯ID
 *  @param callback 
 */
+ (void)ziXunPingLunListWithZiXunID:(NSString *)ziXunID UsingCallback:(void (^)(DCServiceContext *context, ZiXunPingLunResultSM *sm)) callback;
/**
 *  用户删除自己的评论
 *
 *  @param yongHuID 用户id
 *  @param ziXunID  资讯id
 *  @param callback callback description
 */
+ (void)ziXunPingLunDeleteWithYongHuID:(NSString *)yongHuID PingLunID:(NSString *)pingLunID UsingCallback:(void (^)(DCServiceContext *context, ResultMode *sm)) callback;

@end
