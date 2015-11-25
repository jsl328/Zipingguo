//
//  ResultModelOfcheckUpdateCompanyPersonsSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-20.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface ResultModelOfcheckUpdateCompanyPersonsSM : NSObject<IAnnotatable>
@property (nonatomic) int status;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic,strong) NSArray *data1;
@property (nonatomic, strong) NSString *data2;
@end

@interface CheckUpdateCompanyPersonsSM : NSObject<IAnnotatable>
@property (nonatomic, strong) NSString *companyid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *letter;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *sessionid;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *wechat;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *deptid;
@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *jobnumber;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, strong) NSString *weixinuserid;
@property (nonatomic) int userstatus;
@property (nonatomic, strong) NSString *regtype;
@property (nonatomic, strong) NSString *createid;
@property (nonatomic, strong) NSString *createtime;
@property (nonatomic, strong) NSString *updatedtime;
@property (nonatomic, strong) NSString *deptsort;
@property (nonatomic, strong) NSString *isattention;
@property (nonatomic, strong) NSString *roleid;
@property (nonatomic, strong) NSString *rolename;
@property (nonatomic, strong) NSString *groupid;
@property (nonatomic, strong) NSString *companyname;
@property (nonatomic, strong) NSString *deptname;
@property (nonatomic, strong) NSArray *invitephones;
@end
