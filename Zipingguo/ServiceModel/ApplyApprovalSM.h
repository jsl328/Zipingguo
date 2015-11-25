//
//  ApplyApprovalSM.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface ApplyApprovalSM : NSObject<IAnnotatable>

@property (retain, nonatomic) NSString *_id;
@property (retain, nonatomic) NSString *createtime;
@property (retain, nonatomic) NSString *createname;
@property (retain, nonatomic) NSString *createid;
@property (assign, nonatomic) int status;
@property (retain, nonatomic) NSString *flowname;
@property (retain, nonatomic) NSString *companyid;
@property (retain, nonatomic) NSString *deleteflag;
@property (retain, nonatomic) NSString *dealtime;
@property (retain, nonatomic) NSString *dealname;
@property (retain, nonatomic) NSString *dealid;
@property (retain, nonatomic) NSString *jobno;
@property (retain, nonatomic) NSString *statusValue;
@property (retain, nonatomic) NSString *maps;
@property (retain, nonatomic) NSString *flowid;
@property (retain, nonatomic) NSString *ccs;
@property (retain, nonatomic) NSString *time;
@property (retain, nonatomic) NSString *receivetime;
@property (assign, nonatomic) int type;
@end
