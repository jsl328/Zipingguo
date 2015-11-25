//
//  BaoGaoListSM.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/29.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface BaoGaoListSM : NSObject<IAnnotatable>

@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*summary;
@property(nonatomic,retain)NSString*plan;
@property(nonatomic,retain)NSString*createtime;
@property(nonatomic,retain)NSString*time;

@property(nonatomic,retain)NSString*deptid;
@property(nonatomic,retain)NSString*companyid;
@property(nonatomic,retain)NSString*createid;
@property(nonatomic,retain)NSString * createname;
@property (nonatomic,retain)NSString * papername;
@property (nonatomic,retain)NSString * weekday;
@property (nonatomic) int papertype;
@property (nonatomic) int isread;

@end
