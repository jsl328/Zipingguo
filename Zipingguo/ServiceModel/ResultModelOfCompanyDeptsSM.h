//
//  ResultModelOfCompanyDeptsSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-2.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@class CompanyDeptsSM;

@interface ResultModelOfCompanyDeptsSM : NSObject<IAnnotatable>
@property (strong, nonatomic) NSArray *data;
@end

@interface CompanyDeptsSM : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *companyid;
@property (retain, nonatomic) NSString * _id;
@property (retain, nonatomic) NSString *code;
@property (retain, nonatomic) NSString *name;
@property (nonatomic) int isleaf;
@property (retain, nonatomic) NSString *parid;
@property (retain, nonatomic) NSString *memo;
@property (nonatomic,assign) int sort;
@property (nonatomic) int deleteflag;
@property (retain, nonatomic) NSString *path;
@property (retain, nonatomic) NSString *sortstr;
@property (retain, nonatomic) NSString *subdepts;
@property (retain, nonatomic) NSString *users;
@end


