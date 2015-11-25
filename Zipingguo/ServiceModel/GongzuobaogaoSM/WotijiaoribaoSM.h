//
//  WotijiaoribaoSM.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"IAnnotatable.h"
#import "ApproverusersSM.h"
#import "CcusersSM.h"
@interface WotijiaoribaoSM : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*summary;
@property(nonatomic,retain)NSString*plan;
@property(nonatomic,retain)NSString*createid;
@property(nonatomic,retain)NSString*createtime;
@property(nonatomic,retain)NSString*time;

@property(nonatomic)int papertype;
@property(nonatomic,retain)NSString*papername;
@property(nonatomic,retain)NSString*deptid;
@property(nonatomic,retain)NSString*companyid;
@property(nonatomic,retain)NSString*createname;
@property(nonatomic,retain)NSString*weekday;
@property(nonatomic,retain)NSArray*approverusers;
@property(nonatomic,retain)NSArray*ccusers;
@property (nonatomic,assign) int isread;
@end
