//
//  DengluSM.h
//  Zipingguo
//
//  Created by fuyonghua on 15/9/14.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserDataSM;
@class DengluData1;
@class DengluData2;
@class UserinfosSM;
@interface DengluSM : NSObject<IAnnotatable>

@property (nonatomic,assign) int status;

@property (nonatomic,strong) NSString *msg;

@property (nonatomic,strong) UserDataSM *data;//登录成功返回的user

@property (nonatomic,strong) DengluData1 *data1;//返回app权限

@property (nonatomic, strong) NSArray *data2;

@end

@interface DengluData1 : NSObject<IAnnotatable>

@property (nonatomic,strong) NSString *loginStatus;//登录状态
@property (nonatomic,strong) NSString *role;//角色
@property (nonatomic,assign) int lackdeptinfo;//是否缺少组织架构
@property (nonatomic,assign) int lackuserinfo;//用户账号是否缺少关键信息
@property (nonatomic,assign) int corpnum;//判断企业数量

@end

@interface UserDataSM : NSObject<IAnnotatable>

@property (nonatomic,strong) NSString *companyid;
@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *letter;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *wechat;
@property (nonatomic,strong) NSString *qq;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *constellation;
@property (nonatomic,strong) NSString *hobby;
@property (nonatomic,strong) NSString *imgurl;
@property (nonatomic,strong) NSString *sessionid;
@property (nonatomic,strong) NSString *position;
@property (nonatomic,strong) NSString *jobnumber;
@property (nonatomic,strong) NSString *isregisterdata;
@property (nonatomic,strong) NSString *deptid;
@property (nonatomic,strong) NSString *deptname;
@property (nonatomic,strong) NSString *createtime;
@property (nonatomic,strong) NSString *companyname;
@property (nonatomic,strong) NSString *deptsort;
@property (nonatomic,strong) NSString *isattention;
@property (nonatomic,strong) NSString *roleid;
@property (nonatomic,strong) NSString *rolename;
@property (nonatomic,strong) NSString *groupid;
@property (nonatomic,strong) NSString *time;
@property (nonatomic, strong) UserinfosSM *userinfos;
@end

@interface DengluData2 : NSObject<IAnnotatable>

@property (nonatomic,strong) NSString *companyid;//公司id
@property (nonatomic,strong) NSString *name;//公司名称

@end


@interface UserinfosSM : NSObject<IAnnotatable>

@property (nonatomic, strong) NSString *userinfoid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *constellation;
@property (nonatomic, strong) NSString *hobby;
@property (nonatomic, assign) int gender;
@property (nonatomic, strong) NSString *pinyinfull;
@property (nonatomic, strong) NSString *pinyinfirst;

@end
