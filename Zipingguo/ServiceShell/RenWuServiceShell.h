//
//  RenWuServiceShell.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskBaseSM.h"
#import "WoderenwuSM.h"
#import "RenWuDetailSM.h"
#import "ChuangjianRenwuSM.h"
#import "RenWuPingLunSM.h"



typedef NS_ENUM(NSInteger, RenWuColumn) { /**<任务字段枚举*/
    RenWuColumn_Title=0,/**<任务标题*/
    RenWuColumn_RemindMsg,/**<提醒信息*/
    RenWuColumn_Endtime,/**<截止时间*/
    RenWuColumn_Importance,/**<重要度*/
    RenWuColumn_Content,/**<任务内容*/
    RenWuColumn_Memo /**<任务备注*/
};

@interface RenWuServiceShell : NSObject
/**
 *  获取我的任务列表
 *
 *  @param createid 用户id
 *  @param start    开始页码
 *  @param count    每页数量
 *  @param type     任务类型 0-我的任务 1-我分配的任务
 */
+(void)getMyRenWuListWithcreateid:(NSString *)createid start:(int)start count:(int)count type:(NSInteger )type usingCallback:(void (^)(DCServiceContext*context, WoderenwuSM*sm)) callback;
/**
 *  获取任务详情
 *
 *  @param id       任务id
 *  @param createid 用户id
 */
+(void)getRenWuDetailWithID:(NSString *)id createid:(NSString*)createid usingCallback:(void (^)(DCServiceContext*context, RenWuDetailSM*sm)) callback;/**<获取任务详情*/
/**
 *  创建快捷任务
 *
 *  @param title    任务标题
 *  @param createid 用户id
 */
+(void)addKuaiJieTaskWithTitle:(NSString *)title createid:(NSString*)createid usingCallback:(void (^)(DCServiceContext*context, TaskBaseSM*sm)) callback;/**<创建快捷任务*/
/**
 *  完成任务
 *
 *  @param id 任务id
 */
+(void)markTaskStateWithID:(NSString *)id isFinish:(BOOL)isFinish usingCallback:(void (^)(DCServiceContext*context, ResultMode*sm))  callback;/**<标记任务为已完成完成*/
/**
 *  新建任务
 *
 *  @param publishDynamicSN 
 */
+(void) xinjianrenwuWithCreateid:(ChuangjianRenwuSM *)publishDynamicSN
                   usingCallback:(void (^)(DCServiceContext*context, TaskBaseSM*sm)) callback;/**<新建任务*/
/**
 *  发布任务评论
 *
 *  @param createid 用户id
 *  @param content  评论内容
 *  @param taskid   任务id
 *  @param isreply  A回复B，存放B评论的id，即为上级评论的id
 *  @param topparid 最顶级的评论id
 *  @param ids      评论的@的人，应当将这些@的用户的id以英文逗号（’,’）连接，传入本参数
 */
+(void)renWuPingLunWithcreateid:(NSString *)createid content:(NSString*)content taskid:(NSString*)taskid
                        isreply:(NSString*)isreply topparid:(NSString*)topparid IDS:(NSString *)ids
                        usingCallback:(void (^)(DCServiceContext*context,RenWuPingLunSM *sm)) callback;
/**
 *  更新任务详情的某个字段
 *
 *  @param key      字段名
 *  @param value    修改的值
 *  @param id       任务id
 *  @param createid 用户id
 */
+(void)upDateRenWuValueWithColumn:(RenWuColumn)column value:(NSString*)value id:(NSString *)id createid:(NSString*)createid usingCallback:(void (^)(DCServiceContext*context, ResultMode*sm))  callback;

/**
 *  编辑负责人或者参与人
 *
 *  @param taskid   任务id
 *  @param type    负责人为1 参与人为2
 *  @param ids     人员id以英文,分隔
 *
 */
+(void)upDateRenWuCanYuPersonWithTaskid:(NSString *)taskid Type:(int)type IDS:(NSString *)ids usingCallback:(void (^)(DCServiceContext*context, ResultMode*sm))  callback;

/**
 *  删除任务
 *
 *  @param ID 任务id
 */
+(void)shanChuRenWuWithID:(NSString *)ID usingCallback:(void (^)(DCServiceContext*context,ResultMode*sm)) callback;

/**
 *  删除自己评论的任务
 *
 *  @param ID 任务id
 */

+(void)ShanshurenupinglunWithCreateid:(NSString *)createid ID:(NSString *)id usingCallback:(void (^)(DCServiceContext*context,ResultMode*sm))  callback;

/**
 *  编辑任务
 *
 *  @param publishDynamicSN
 */
+(void)updateTaskWithCreateid:(ChuangjianRenwuSM *)publishDynamicSN
                   usingCallback:(void (^)(DCServiceContext*context, TaskBaseSM*sm)) callback;/**<编辑任务*/

@end
