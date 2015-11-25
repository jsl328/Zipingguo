//
//  AppStore.h
//  QingLian
//
//  Created by fyh on 14-6-20.
//  Copyright (c) 2014年 lianyou. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString *strYonghuID;
static NSString *strYongHuMing;
static NSString *strShouJiHao;
static NSString *strYonghuMima;
static NSString *strZhiwei;
static NSString *strDanwei;
static NSString *strGongsiID;
static NSString *strYonghuImageString;
static NSString *strSessionid;
static NSString *strQunzuid;
static NSString *strQunzuMing;
static NSString *strToken;
static NSString *strToSuperUserToken;
static NSString *strFlag;
static NSString *BaogaoXaila;
static NSString *JobNumber;
static NSString *Companyname;
static BOOL isAdmin;
///是否是从首页 知识库跳转到 企业文件夹
static BOOL isHomeToQiYe;
static BOOL xiugiBiaoti;
static BOOL XiugiQunMing;
static BOOL strCorpnums;
static NSString *strBackgroundimg;
static NSString *strDetpid;
@interface AppStore : NSObject

///记录 App版本
//+ (BOOL)updateCurrentVersion;

//+ (void)checkUpdate:(void(^)(BOOL))callback;

/**
 *  设置用户ID
 *
 *  @param ID 用户ID
 */
+ (void)setYongHuID:(NSString *)ID;
+ (NSString *)getYongHuID;

+ (void)setGongsiID:(NSString *)ID;
+ (NSString *)getGongsiID;

+ (void)setQunzuID:(NSString *)ID;
+ (NSString *)getQunzuID;

+ (void)setQunzuMing:(NSString *)qunzuMing;
+ (NSString *)getQunzuMing;

+ (void)setYonghuImageView:(NSString *)imageView;
+ (NSString *)getYonghuImageView;
/**
 *  设置用户名
 *
 *  @param yongHuMing 用户名
 */
+ (void)setYongHuMing:(NSString *)yongHuMing;
+ (NSString *)getYongHuMing;

+ (void)setZhiwei:(NSString *)zhiwei;
+ (NSString *)getZhiwei;

+ (void)setSessionid:(NSString *)sessionid;
+ (NSString *)getSessionid;

+ (void)setDanwei:(NSString *)danwei;
+ (NSString *)getDanwei;

+ (void)setYongHuShoujihao:(NSString *)shoujihao;
+ (NSString *)getYongHuShoujihao;

+ (void)setYongHuMima:(NSString *)mima;
+ (NSString *)getYongHuMima;

+ (void)setToken:(NSString *)token;
+ (NSString *)getToken;

+ (void)setSuperUserToken:(NSString *)token;
+ (NSString *)getSuperUserToken;

+(void)setFlag:(NSString *)flag;
+(NSString *)getflag;

+(void)setBaogaoXaila:(NSString*)baogaoxiala;
+(NSString*)getBaogaoXaila;

+ (void)setIsHomeToQiYe:(BOOL)toQiYe;

+ (BOOL)isHomeToQiYe;

+ (void)setIsAdmin:(BOOL)admin;

+ (BOOL)isAdmin;

+ (void)setXiugai:(BOOL)isXiugai;

+ (BOOL)isXiugai;

+ (void)setXiugaiQunming:(BOOL)isXiugaiQunming;

+ (BOOL)isXiugaiQunming;

+(void)setJobNumber:(NSString*)jobnumber;
+(NSString*)getJobNumber;

+(void)setBackgroundimg:(NSString*)backgroundimg;
+(NSString*)getBackgroundimg;

+(void)setCompanyname:(NSString*)companyname;
+(NSString*)getCompanyname;

+(void)setCorpnums:(BOOL)corpnums;
+(int)getCorpnums;

+(void)setDeptid:(NSString *)deptid;
+(NSString *)getDeptid;

@end
