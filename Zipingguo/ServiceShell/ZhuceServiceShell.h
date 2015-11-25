//
//  ZhuceServiceShell.h
//  Zipingguo
//
//  Created by fuyonghua on 15/11/3.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultMode.h"
#import "FirstCreateDeptSM.h"
#import "RegCorpCheckCodeSM.h"
#import "YaoqingSM.h"
#import "YanqingListSM.h"
@interface ZhuceServiceShell : NSObject

/**
 *  1.1.10	注册企业
 *
 *  @param phone 公司名
 *  @param password 密码MD5加密
 *  @param companyname 公司名
 *  @param callback  callback description
 */
+ (void) getRegCorpCheckWithPhone:(NSString *)phone PassWord:(NSString *)passworrd Companyname:(NSString *)companyname UsingCallback:(void (^)(DCServiceContext *context, ResultMode* sm)) callback;

/**
 *  1.1.11	注册企业-校验验证码
 *  @param phone 公司名
 *  @param password 密码MD5加密
 *  @param companyname 公司名
 *  @param code 验证码
 *  @param callback  callback description
 */
+ (void) getRegCorpCheckCodeWithPhone:(NSString *)phone PassWord:(NSString *)passworrd Companyname:(NSString *)companyname Code:(NSString *)code UsingCallback:(void (^)(DCServiceContext *context, RegCorpCheckCodeSM* sm)) callback;

/**
 *  1.1.12	创建组织架构
 *  @param FirstCreateDeptSM POST请求参数
 *  @param callback  callback description
 */
+ (void) getFirstCreateDeptWithFirstCreateDeptSM:(NSMutableArray *)deptSM UsingCallback:(void (^)(DCServiceContext *context, ResultMode* sm)) callback;

/*!
 1.1.13	邀请员工
 */

+ (void)YaoqingWithYaoqingYuangong:(YaoqingYuangongSM *)yaoqingSM usingCallback:(void (^)(DCServiceContext*, YaoqingSM*))callback;

/*!
 1.1.13	邀请记录
 */

+ (void)InviteListWithCompanyid:(NSString *)companyid Userid:(NSString *)userid usingCallback:(void (^)(DCServiceContext*, YaoqingSM*))callback;

/*!
 1.1.14	完善信息(登陆后)
 */

+ (void)FirstLoginPerfectInfoWithPerfectInfo:(FirstLoginPerfectInfoSM *)info usingCallback:(void (^)(DCServiceContext*, ResultMode*))callback;

/*!
 1.1.14	解除企业
 */

+ (void)RelleveCorpUserWithCompanyid:(NSString *)companyid Phone:(NSString *)phone usingCallback:(void (^)(DCServiceContext*, ResultMode*))callback;

/*!
 找回密码
 */
+(void) employeeFindlostPsdWithPhone:(NSString *)phone Password:(NSString *)password Code:(NSString *)code usingCallback:(void (^)(DCServiceContext*, ResultMode*)) callback;

@end
