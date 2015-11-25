//
//  RibumenweekPapers.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"IAnnotatable.h"
@interface RibumenweekPapers : NSObject<IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*summary;
@property(nonatomic,retain)NSString*plan;
@property(nonatomic,retain)NSString*createid;
@property(nonatomic,retain)NSString*createtime;
@property(nonatomic,retain)NSString*deptid;
@property(nonatomic,retain)NSString*companyid;
@property(nonatomic,retain)NSString*dailyUsers;
@property(nonatomic,retain)NSString*type;
@end
