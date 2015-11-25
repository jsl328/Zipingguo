//
//  ResultModelOfSubDeptAndMemberUserSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-11-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeptPersonsSM.h"
@class SubDeptAndMemberUserSM;
@interface ResultModelOfSubDeptAndMemberUserSM : NSObject<IAnnotatable>
@property (nonatomic, strong) SubDeptAndMemberUserSM *data;
@end

@interface SubDeptAndMemberUserSM : NSObject<IAnnotatable>
@property (nonatomic, strong) NSString *_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int isleaf;
@property (nonatomic, strong) NSString *parid;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *companyid;
@property (nonatomic, strong) NSString *sort;
@property (nonatomic, strong) NSArray *subdepts;
@property (nonatomic, strong) NSArray *users;
@end
