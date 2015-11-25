//
//  Denglu2SM.h
//  Zipingguo
//
//  Created by fuyonghua on 15/11/1.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GongSiSM;
@interface Denglu2SM : NSObject<IAnnotatable>

@property (nonatomic,assign) int status;
@property (nonatomic,strong) NSString *msg;
//@property (nonatomic,strong) NSArray *data;

@property (nonatomic,strong) GongSiSM *xinxiData;

@end

@interface GongSiSM : NSObject<IAnnotatable>

@property (nonatomic,strong) NSString *companyid;
@property (nonatomic,strong) NSString *ID;
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

@end