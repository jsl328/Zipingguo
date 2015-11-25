//
//  RIliShall.m
//  Zipingguo
//
//  Created by miao on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RIliShall.h"

@implementation RIliShall
// 获取具体某天的任务

+ (void)getThingOfDayWithID:(NSString *)userid  usingCallback:(void(^)(DCServiceContext*,RIliResultModelSM*))callback
{
    
        [LService request:@"getThingOfMonth.action" with:@[userid] returns:[RIliResultModelSM class] whenDone:callback];
    

}
//在日历里删除备忘录
+ (void)ShanchubeiwangluWithID:(NSString *)ID  usingCallback:(void(^)(DCServiceContext*,RIliShanchuSM*))callback
{
    [LService request:@"deleteMemo.action" with:@[ID] returns:[RIliShanchuSM class] whenDone:callback];
    
}

//在日历里创建备忘录
+ (void)ChuangjianbeiwangluWithuserid:(NSString *)userid title:(NSString*)title remindmsg:(NSString*)remindmsg  companyid:(NSString*)companyid content:(NSString*)content endtime:(NSString*)endtime  usingCallback:(void(^)(DCServiceContext*,ChuangjianrilibeiwangSM*))callback;
{
    [LService request:@"createMemo.action" with:@[userid,title,remindmsg,companyid,content,endtime] returns:[ChuangjianrilibeiwangSM class] whenDone:callback];
}
//在日历里修改备忘录
+ (void)XiugaibeiwangluWithID:(NSString *)ID title:(NSString*)title remindmsg:(NSString*)remindmsg content:(NSString*)content endtime:(NSString*)endtime usingCallback:(void(^)(DCServiceContext*,RIliShanchuSM*))callback
{
      [LService request:@"updateMemo.action" with:@[ID,title,remindmsg,content,endtime] returns:[ RIliShanchuSM class] whenDone:callback];
}

@end
