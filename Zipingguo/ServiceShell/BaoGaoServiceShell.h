//
//  BaoGaoServiceShell.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/22.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "TijiaogeiworibaoliebiaoSM.h"
//#import "WoTiJiaoRiBaoDataSM.h"
#import "ZhoubaoxiangqingSM.h"
#import "XinjianShangchuanRibaoSM.h"
#import "XInjianribaoSM.h"
//#import "RibaobumenSM.h"
//#import "RenyuanDataSM.h"

#import "BaoGaoResultSM.h"
#import "BaoGaoListSM.h"
#import "BaoGaoSortResultSM.h"
#import "RibaopinglunSM.h"
@interface BaoGaoServiceShell : NSObject


/**
 *  1.11.21	提交给我的工作报告列表
 *
 *  @param userid     登录人的id
 *  @param papertype  1-日报-2-周报-3-月报
 *  @param start      从第几个开始
 *  @param count      一页查询多少个
 *  @param createtime 日期格式：2014-09-11 10:46:00
 *  @param callback   callback description
 */
+ (void) TijiaogeiwoGongzuoWithuserid:(NSString *)userid Papertype:(int)papertype Start:(int)start Count:(int)count createtime:(NSString*)createtime usingCallback:(void(^)(DCServiceContext*,BaoGaoResultSM*))callback;

/**
 *  1.11.20	我提交的工作报告列表
 *
 *  @param userid     登录人的id
 *  @param papertype  1-日报-2-周报-3-月报
 *  @param start      从第几个开始
 *  @param count      一页查询多少个
 *  @param createtime 日期格式：2014-09-11 10:46:00
 *  @param callback   BaoGaoResultSM
 */
+ (void) mySubmitPaperWithCreateid:(NSString *)createid Papertype:(int)papertype Start:(int)start Count:(int)count createtime:(NSString*)createtime usingCallback:(void(^)(DCServiceContext*,BaoGaoResultSM*))callback;

/**
 *  1.11.22	工作报告详情
 *
 *  @param ID       日报id
 *  @param userid   查看这个日报的人的userid，传当前userid
 *  @param callback ZhoubaoxiangqingSM
 */
+ (void) getPaperDetailWithID:(NSString *)ID Userid:(NSString *)userid usingCallback:(void(^)(DCServiceContext*,ZhoubaoxiangqingSM*))callback;

/**
 *  1.11.19	新建工作报告
 *
 *  @param gongzuoBaogao XinjianShangchuanRibaoSM
 *  @param callback      XInjianribaoSM
 */
+ (void) createGongzuoBaogaoWithCreateGongzuoBaogao:(XinjianShangchuanRibaoSM *)gongzuoBaogao usingCallback:(void(^)(DCServiceContext*,XInjianribaoSM*))callback;



/**
 *  1.11.29	提交给我的获取部门
 *
 *  @param userid    登录人的id
 *  @param papertype 1-日报-2-周报-3-月报
 *  @param callback  BaoGaoSortResultSM
 */
+ (void) getHaveSubmitPaperToMeDeptWithUserid:(NSString *)userid Papertype:(int)papertype usingCallback:(void(^)(DCServiceContext*,BaoGaoSortResultSM *))callback;

/**
 *  1.11.30	部门排序提交给我的
 *
 *  @param userid    登录人的id
 *  @param papertype 1-日报-2-周报-3-月报
 *  @param deptid    部门id
 *  @param start     从第几个开始
 *  @param count     一页查询多少个
 *  @param callback  callback description
 */
+ (void)getSubmitPaperToMeDeptSortWithUserid:(NSString *)userid Papertype:(int)papertype Deptid:(NSString *)deptid Start:(int)start Count:(int)count usingCallback:(void(^)(DCServiceContext*,BaoGaoResultSM*))callback;

/**
 *  1.11.31	提交给我的获取人名
 *
 *  @param userid    登录人的id
 *  @param papertype 1-日报-2-周报-3-月报
 *  @param callback  callback description
 */
+ (void) getHaveSubmitPaperToMeUnameWithUserid:(NSString *)userid Papertype:(int)papertype usingCallback:(void(^)(DCServiceContext*,BaoGaoSortResultSM *))callback;

/**
 *  1.11.32	人名排序提交给我的
 *
 *  @param userid    登录人的id
 *  @param papertype 1-日报-2-周报-3-月报
 *  @param createid  提交人id，从上一接口中取出的user的id
 *  @param start     从第几个开始
 *  @param count     一页查询多少个
 *  @param callback  callback description
 */
+ (void)getSubmitPaperToMeUnameSortWithUserid:(NSString *)userid Papertype:(int)papertype Createid:(NSString *)createid Start:(int)start Count:(int)count usingCallback:(void(^)(DCServiceContext*,BaoGaoResultSM*))callback;

/**
 *  1.11.23	工作报告评论
 *
 *  @param createid    评论人id
 *  @param content     评论内容
 *  @param weekPaperid 工作报告id
 *  @param isreply     A回复B，存放B评论的id，即为上级评论的id为0则为首次评论
 *  @param topparid    最顶级的评论id（首次评论后台将其设置为当前插入记录的id，即本评论的id，首次评论传0）
 *  @param ids         评论的@的人，应当将这些@的用户的id以英文逗号（’,’）连接，传入本参数
 *  @param callback    RibaopinglunSM
 */
+ (void)commentWorkWithCreateid:(NSString *)createid Content:(NSString *)content WeekPaperid:(NSString *)weekPaperid Isreply:(NSString *)isreply Topparid:(NSString *)topparid IDS:(NSString *)ids usingCallback:(void(^)(DCServiceContext*,RibaopinglunSM*))callback;


@end
