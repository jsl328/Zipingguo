//
//  YonghuStores.h
//  Zipingguo
//
//  Created by fuyonghua on 14-10-30.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YonghuStores : NSObject

+ (YonghuInfoDB *)getWithAutoID:(int)autoID;
//获取全部
+ (NSMutableArray *)getAll;

//根据公司id来查
+ (NSMutableArray *)getAllWithGongsiID:(NSString *)gongsi;

//根据公司id,deptid来查
+ (NSMutableArray *)getAllWithGongsiID:(NSString *)gongsi Deptid:(NSString *)deptid;

//根据userid拿头像
+ (YonghuInfoDB *)getDanLiaoTouXiangWithChatter:(NSString *)chatter;

+ (NSArray *)searchWithString:(NSString *)string;
//删除
+ (void)DeleteWithID:(NSString *)ID;
//插入
+ (void)InsertWithUserid:(NSString *)userid Name:(NSString *)name Letter:(NSString *)letter Email:(NSString *)email Phone:(NSString *)phone Wechat:(NSString *)wechat QQ:(NSString *)qq Birthday:(NSString *)birthday Hobby:(NSString *)hobby Imgurl:(NSString *)imgurl Companyid:(NSString *)companyid Position:(NSString *)position Jobnumber:(NSString *)jobnumber  Deptid:(NSString *)deptid Deptname:(NSString *)deptname;
//更新
+ (void)updataWithName:(NSString *)name Letter:(NSString *)letter Deptid:(NSString *)deptid Phone:(NSString *)phone Imgurl:(NSString *)imgurl Deptname:(NSString *)deptname zhiwei:(NSString *)zhiwei ID:(NSString *)ID;
//全部删除
+ (void)deleteDataInGongSiTongXunLuDataBase;

//更新头像
+ (void)gengXintouxiang:(NSString *)ID imageURL:(NSString*)imageURL;
@end
