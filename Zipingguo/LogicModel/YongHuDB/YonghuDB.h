//
//  YonghuDB.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-30.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "EntityBase.h"
#import "EntityBase.h"
#import "IAnnotatable.h"
@class YonghuInfoDB;
@interface YonghuDB : NSObject

+ (void)saveToDB:(id)sm;

@property (nonatomic, strong) YonghuInfoDB *infoDB;

@end

@interface YonghuInfoDB : EntityBase<NSCoding>

- (void)saveToYonghuDB:(id)sm;

@property (retain, nonatomic) NSString *userid;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *letter;
@property (retain, nonatomic) NSString *email;
@property (retain, nonatomic) NSString *phone;
@property (retain, nonatomic) NSString *wechat;
@property (retain, nonatomic) NSString *qq;
@property (retain, nonatomic) NSString *birthday;
@property (retain, nonatomic) NSString *hobby;
@property (retain, nonatomic) NSString *imgurl;
@property (retain, nonatomic) NSString *companyid;
@property (retain, nonatomic) NSString *position;
@property (retain, nonatomic) NSString *jobnumber;
@property (retain, nonatomic) NSString *deptid;
@property (retain, nonatomic) NSString *deptname;

@end
