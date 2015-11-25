//
//  RIliResultModelSM.h
//  Zipingguo
//
//  Created by miao on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@class rililistSM;
@interface RIliResultModelSM : NSObject<IAnnotatable>
@property(nonatomic,assign)int status;
@property(nonatomic,copy)NSString *msg;

@property(nonatomic,retain)NSArray*data;
@end

@interface rililistSM: NSObject<IAnnotatable>
@property (retain, nonatomic) NSArray *tasks;
@property (retain, nonatomic) NSArray *memos;
@property (retain, nonatomic) NSString *time;
@end
@interface tasksSM : NSObject<IAnnotatable>
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString * starttime;
@property(nonatomic,copy)NSString * endtime;
@property(nonatomic,copy)NSString *remindtime;//用来判断是否提醒
@property(nonatomic,copy)NSString * remindmsg;
@property(nonatomic,assign) int importance;
@property(nonatomic,copy)NSString * memo;
@property(nonatomic,assign) int isfinish;
@property(nonatomic,copy)NSString * companyid;
@property(nonatomic,assign) int deleteflag;
@property(nonatomic,copy)NSString * finishid;
@property(nonatomic,copy)NSString * createname;
@property(nonatomic,assign) int type;
@property(nonatomic,copy)NSString * createid;
@property(nonatomic,copy)NSString * createtime;
@property(nonatomic,copy)NSString * rate;
@property(nonatomic,copy)NSString * respcount;
@property(nonatomic,retain)NSArray * imgstrs;
@property(nonatomic,retain)NSArray * taskitems;
@property(nonatomic,retain)NSArray * participants;
@property(nonatomic,retain)NSArray * leaders;
@property(nonatomic,copy)NSString *time;
@end
@interface memosSM : NSObject<IAnnotatable>
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString*createtime;
@property(nonatomic,copy)NSString *endtime;
@property(nonatomic,copy)NSString *remindmsg;
@property(nonatomic,copy)NSString *companyid;



@end