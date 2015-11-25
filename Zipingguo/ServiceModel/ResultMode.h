
//
//  ResultMode.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-21.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
#import "MemoContentSM.h"
#import "RestCreatGroupSM.h"
@class ResultData;
@class AddData;
@class AllDynamicSM;
@interface groupInfo : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *result;
@property (retain, nonatomic) NSString *infogroups;
@end

@interface huanXinToken : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *token;
@end

@interface ResultMode : NSObject<IAnnotatable>

@property (nonatomic) int status;
@property (retain, nonatomic) NSString *msg;

@property (retain, nonatomic) MemoContentSM *data;

@property (retain, nonatomic) ResultData *data1;

@property (retain, nonatomic) AddData *data2;

@property (nonatomic, strong) AllDynamicSM *delData1;

@property (nonatomic, strong) AllDynamicSM *commentData;

@property (retain, nonatomic) NSString *ID;
@property (retain, nonatomic) NSString *flowid;
@property (retain, nonatomic) NSString *dealid;
@property (retain, nonatomic) NSString *companyid;
@property (retain, nonatomic) NSString *flowname;
@property (retain, nonatomic) NSString *createname;
@property (retain, nonatomic) NSString *createid;

@end

@interface ResultData : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *ID;
@property (retain, nonatomic) NSString *createdate;
@property (retain, nonatomic) NSString *createid;
@property (retain, nonatomic) NSString *offaddress;
@property (retain, nonatomic) NSString *ontime;
@property (retain, nonatomic) NSString *offtime;
@property (retain, nonatomic) NSString *onaddress;
@property (retain, nonatomic) NSString *week;
@property (retain, nonatomic) NSString *companyid;
@property (retain, nonatomic) NSString *memo;
@property (retain, nonatomic) NSString *deleteflag;
@property (retain, nonatomic) NSString *time;
@end

@interface AddData : NSObject<IAnnotatable>
@property (retain, nonatomic) NSString *ID;
@property (retain, nonatomic) NSString *overdueid;
@property (retain, nonatomic) NSString *customerid;
@property (retain, nonatomic) NSString *customername;

@end