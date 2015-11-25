//
//  WeekPaper.h
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"

@interface WorkPaper : NSObject<IAnnotatable>

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *papername;
@property (nonatomic, copy) NSString *plan;
@property (nonatomic, copy) NSString *createid;
@property (nonatomic, copy) NSString *createtime;
@property (nonatomic, copy) NSString *deptid;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *weekUsers;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *weekday;

@end
