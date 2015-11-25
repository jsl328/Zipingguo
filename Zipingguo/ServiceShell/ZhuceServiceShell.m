//
//  ZhuceServiceShell.m
//  Zipingguo
//
//  Created by fuyonghua on 15/11/3.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZhuceServiceShell.h"

@implementation ZhuceServiceShell

+ (void) getRegCorpCheckWithPhone:(NSString *)phone PassWord:(NSString *)passworrd Companyname:(NSString *)companyname UsingCallback:(void (^)(DCServiceContext *context, ResultMode* sm)) callback{
    [LService request:@"regCorpCheck.action" with:@[phone,passworrd,companyname] returns:[ResultMode class] whenDone:callback];
}

+ (void) getRegCorpCheckCodeWithPhone:(NSString *)phone PassWord:(NSString *)passworrd Companyname:(NSString *)companyname Code:(NSString *)code UsingCallback:(void (^)(DCServiceContext *context, RegCorpCheckCodeSM* sm)) callback{
    [LService request:@"regCorpCheckCode.action" with:@[phone,passworrd,companyname,code] returns:[RegCorpCheckCodeSM class] whenDone:callback];
}

+ (void) getFirstCreateDeptWithFirstCreateDeptSM:(NSMutableArray *)deptSM UsingCallback:(void (^)(DCServiceContext *context, ResultMode* sm)) callback{
    [LService request:@"firstCreateDept.action" with:@[deptSM] returns:[ResultMode class] whenDone:callback];
}

+ (void)YaoqingWithYaoqingYuangong:(YaoqingYuangongSM *)yaoqingSM usingCallback:(void (^)(DCServiceContext*, YaoqingSM*))callback{
    [LService request:@"inviteUser.action" with:@[yaoqingSM] returns:[YaoqingSM class] whenDone:callback];
}

+ (void)InviteListWithCompanyid:(NSString *)companyid Userid:(NSString *)userid usingCallback:(void (^)(DCServiceContext*, YaoqingSM*))callback{
    [LService request:@"inviteList.action" with:@[companyid,userid] returns:[YaoqingSM class] whenDone:callback];
}

+ (void)FirstLoginPerfectInfoWithPerfectInfo:(FirstLoginPerfectInfoSM *)info usingCallback:(void (^)(DCServiceContext*, ResultMode*))callback{
    [LService request:@"firstLoginPerfectInfo.action" with:@[info] returns:[ResultMode class] whenDone:callback];
}

+ (void)RelleveCorpUserWithCompanyid:(NSString *)companyid Phone:(NSString *)phone usingCallback:(void (^)(DCServiceContext*, ResultMode*))callback{
    [LService request:@"relieveCorpUser.action" with:@[phone,companyid] returns:[ResultMode class] whenDone:callback];
}

+(void) employeeFindlostPsdWithPhone:(NSString *)phone Password:(NSString *)password Code:(NSString *)code usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback{
    [LService request:@"findLostPsd.action" with:@[phone,password,code] returns:[ResultMode class] whenDone:callback];
}

@end
