//
//  RenwuData.h
//  Lvpingguo
//
//  Created by miao on 14-9-24.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "RenwuData.h"
@interface RenwuData : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*rate;
@property(nonatomic,assign)int respcount;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*title;
@property(nonatomic,retain)NSString*content;
@property(nonatomic,retain)NSString*starttime;
@property(nonatomic,retain)NSString*endtime;
@property(nonatomic,retain)NSString*remindtime;
@property(nonatomic,retain)NSString*remindmsg;
@property(nonatomic,assign)int importance;
@property(nonatomic,retain)NSString*memo;
@property(nonatomic,assign) int isfinish;
@property(nonatomic,retain)NSString*companyid;
@property(nonatomic,assign) int deleteflag;
@property(nonatomic,retain)NSString*finishid;
@property(nonatomic,retain)NSString*createid;
@property(nonatomic,retain)NSString*createname;
@property(nonatomic,retain)NSString*createtime;
@property(nonatomic,retain)NSString*leaders;
@property(nonatomic,retain)NSString*participants;
@property(nonatomic,retain)NSString*updatetime;
@property(nonatomic,retain)NSString*time;


@end
