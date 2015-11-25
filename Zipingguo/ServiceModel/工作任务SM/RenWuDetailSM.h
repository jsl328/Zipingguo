//
//  RenWuDetailSM.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@class ParticipantsSM,LeadersSM,TaskSM,TaskcommentsSM,TaskitemsSM,TaskimgsSM,TaskDetailData;
@interface RenWuDetailSM : NSObject<IAnnotatable>

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, assign) int status;

@property (nonatomic, strong) TaskDetailData *data;

@end

@interface TaskDetailData : NSObject<IAnnotatable>

@property (nonatomic, strong) NSArray *participants;/**<参与人数组*/

@property (nonatomic, strong) NSArray *leaders;/**<负责人数组*/

@property (nonatomic, strong) TaskSM *task;/**<任务详情*/

@property (nonatomic, strong) NSArray *taskcomments;/**<任务评论*/

@property (nonatomic, strong) NSArray *taskitems;

@property (nonatomic, strong) NSArray *taskimgs;

@end

@interface ParticipantsSM : NSObject<IAnnotatable>

@property (nonatomic, copy) NSString *taskid;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *leaderID;

@property (nonatomic, copy) NSString *remindmsg;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *remindtime;

@property (nonatomic, assign) NSInteger type;

@end

@interface LeadersSM : NSObject<IAnnotatable> /**<负责人model*/

@property (nonatomic, copy) NSString *taskid;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *leaderID;

@property (nonatomic, copy) NSString *remindmsg;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *remindtime;

@property (nonatomic, assign) NSInteger type;

@end

@interface TaskSM : NSObject<IAnnotatable>

@property (nonatomic, copy) NSString *participants;/**<参与人*/

@property (nonatomic, copy) NSString *finishid;/**<完成id*/

@property (nonatomic, copy) NSString *taskitems;

@property (nonatomic, copy) NSString *imgstrs;

@property (nonatomic, copy) NSString *title;/**<任务标题*/

@property (nonatomic, assign) NSInteger isfinish;/**<是否完成*/

@property (nonatomic, copy) NSString *createid;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *updatetime;

@property (nonatomic, copy) NSString *leaders;/**<负责人*/

@property (nonatomic, copy) NSString *starttime;

@property (nonatomic, copy) NSString *endtime;

@property (nonatomic, copy) NSString *remindmsg;/**<提醒*/

@property (nonatomic, copy) NSString *remindtime;/**<提醒时间*/

@property (nonatomic, copy) NSString *memo;/**<备注*/

@property (nonatomic, assign) NSInteger type;/**<任务类型 1-正常任务 2-快捷任务*/

@property (nonatomic, copy) NSString *respcount;

@property (nonatomic, copy) NSString *taskID;/**<任务id*/

@property (nonatomic, assign) NSInteger deleteflag;

@property (nonatomic, copy) NSString *companyid;

@property (nonatomic, assign) NSInteger importance;/**<是否重要 1-普通 2-重要*/

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *createname;

@property (nonatomic, copy) NSString *rate;

@property (nonatomic, copy) NSString *content;/**<任务内容*/

@end

@interface TaskcommentsSM : NSObject<IAnnotatable>

@property (nonatomic, copy) NSString *taskid;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createid;

@property (nonatomic, copy) NSString *commentsID;

@property (nonatomic, copy) NSString *isreply;

@property (nonatomic, copy) NSString *createname;

@property (nonatomic, copy) NSString *createimg;

@property (nonatomic, copy) NSString *reluserid;

@property (nonatomic, copy) NSString *topparid;

@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, copy) NSString *relusername;

@end

@interface TaskitemsSM : NSObject<IAnnotatable>

@end

@interface TaskimgsSM : NSObject<IAnnotatable>

@end
