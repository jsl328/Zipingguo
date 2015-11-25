//
//  RIliShall.h
//  Zipingguo
//
//  Created by miao on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIliResultModelSM.h"
#import "LService.h"
#import "RIliShanchuSM.h"
#import "ChuangjianrilibeiwangSM.h"
@interface RIliShall : NSObject

 
// 获取具体某天的任务

+ (void)getThingOfDayWithID:(NSString *)userid  usingCallback:(void(^)(DCServiceContext*,RIliResultModelSM*))callback;

//deleteMemo.action
//在日历里删除备忘录
+ (void)ShanchubeiwangluWithID:(NSString *)ID  usingCallback:(void(^)(DCServiceContext*,RIliShanchuSM*))callback;
//在日历里创建备忘录
+ (void)ChuangjianbeiwangluWithuserid:(NSString *)userid title:(NSString*)title remindmsg:(NSString*)remindmsg  companyid:(NSString*)companyid content:(NSString*)content endtime:(NSString*)endtime  usingCallback:(void(^)(DCServiceContext*,ChuangjianrilibeiwangSM*))callback;
//updateMemo.action
//在日历里修改备忘录
+ (void)XiugaibeiwangluWithID:(NSString *)ID title:(NSString*)title remindmsg:(NSString*)remindmsg content:(NSString*)content endtime:(NSString*)endtime usingCallback:(void(^)(DCServiceContext*,RIliShanchuSM*))callback;

@end
