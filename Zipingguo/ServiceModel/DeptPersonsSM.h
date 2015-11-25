//
//  DeptPersonsSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-3.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DeptPersonsSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *letter;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *wechat;
@property (retain, nonatomic) NSString *qq;
@property (retain, nonatomic) NSString *birthday;
@property (retain, nonatomic) NSString *constellation;
@property (retain, nonatomic) NSString *hobby;
@property (retain, nonatomic) NSString *imgurl;
@property (retain, nonatomic) NSString *fontsize;
@property (retain, nonatomic) NSString *sessionid;
@property (retain, nonatomic) NSString *companyid;
@property (retain, nonatomic) NSString *position;
@property (assign, nonatomic)int deleteflag;
@property (assign, nonatomic) int status;
@property (retain, nonatomic) NSString *jobnumber;
@property (nonatomic,assign) int isregisterdata;
@property (retain, nonatomic) NSString *createtime;
@property (retain, nonatomic) NSString *deptid;
@property (retain, nonatomic) NSString *deptname;
@property (nonatomic, strong) UserinfosSM *userinfos;
@end
