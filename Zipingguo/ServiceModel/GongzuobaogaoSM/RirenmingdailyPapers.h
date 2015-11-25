//
//  RirenmingdailyPapers.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface RirenmingdailyPapers : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*summary;
@property(nonatomic,retain)NSString*plan;
@property(nonatomic,retain)NSString*createid;
@property(nonatomic,retain)NSString*createtime;
@property(nonatomic,retain)NSString*deptid;
@property(nonatomic,retain)NSString*companyid;
@property(nonatomic,retain)NSString*dailyUsers;
@property(nonatomic)int type;
@property(nonatomic)int papertype;
@property(nonatomic,retain)NSString*papername;
@property(nonatomic)int isread;
@property(nonatomic,retain)NSString*readuserid;
@property(nonatomic,retain)NSString*approveruserids;
@property(nonatomic,retain)NSString*ccuserids;
@property(nonatomic,retain)NSString*createname;
@property(nonatomic,retain)NSString*weekday;
@property(nonatomic,retain)NSString*annexlist;

@end
