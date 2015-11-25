//
//  TaskBaseSM.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TaskBaseDataSM;
@interface TaskBaseSM : NSObject<IAnnotatable>
@property (nonatomic, assign) int status;

@property (nonatomic, strong) NSString *msg;

@property (nonatomic, strong) TaskBaseDataSM *data;

@end

@interface TaskBaseDataSM : NSObject<IAnnotatable>
@property (nonatomic, strong) NSString *companyid;

@property (nonatomic, strong) NSString *_id;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) NSString *starttime;

@property (nonatomic, strong) NSString *endtime;

@property (nonatomic, strong) NSString *remindtime;

@property (nonatomic, strong) NSString *remindmsg;

@property (nonatomic, strong) NSString *importance;

@property (nonatomic, strong) NSString *memo;

@property (nonatomic, assign) int isfinish;

@property (nonatomic, assign) int deleteflag;

@property (nonatomic, assign) int type;

@property (nonatomic, strong) NSString *createid;

@property (nonatomic, strong) NSString *createtime;

@property (nonatomic, strong) NSString *createname;

@property (nonatomic, strong) NSString *updatetime;

@property (nonatomic, assign) int respcount;

@property (nonatomic, strong) NSString *imgstrs;

@property (nonatomic, strong) NSString *taskitems;

@property (nonatomic, strong) NSString *participants;

@property (nonatomic, strong) NSArray *leaders;

@property (nonatomic, assign) int isread;

@property (nonatomic, strong) NSString *time;

@end