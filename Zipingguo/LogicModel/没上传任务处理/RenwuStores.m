//
//  RenwuStores.m
//  Zipingguo
//
//  Created by miao on 15/11/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenwuStores.h"
#import "RenwuDB.h"
#import "RenwuLM.h"
#import "DB.h"
@implementation RenwuStores

//没有上传的任务
+(NSArray*)getmeishangchuanrenwu
{
    NSString*createid=[AppStore getYongHuID];
    NSString*companyid=[AppStore getGongsiID];
    NSString*sql=[NSString stringWithFormat:@"select*from RenwuDB where ISshangchuan=1 and createid='%@' and companyid='%@'",createid,companyid];
    NSArray*arr=[DB select:[RenwuDB class] withSql:sql];
    
    return arr;
}
//查询是否有重复的ID
+ (BOOL)isSameID:(NSString *)ID{
    
    NSString*createid=[AppStore getYongHuID];
    NSString*companyid=[AppStore getGongsiID];
    NSString * sql = [NSString stringWithFormat:@"select*from RenwuDB where ID='%@' and createid='%@' and companyid='%@'",ID,createid,companyid];
    NSArray * arr = [DB select:[RenwuDB class] withSql:sql];
    return arr.count;
}
//updatetime更新时间是否重复
+(BOOL)isupdatetime:(NSString*)updatetime
{
    NSString*createid=[AppStore getYongHuID];
    NSString*companyid=[AppStore getGongsiID];
    NSString *sql=[NSString stringWithFormat:@"select*from RenwuDB where updatetime='%@' and createid='%@' and companyid='%@'",updatetime,createid,companyid];
    NSArray*arr=[DB select:[RenwuDB class] withSql:sql];
    
    return arr.count;
}
//删除某一条记录
+(void)deleteRenwu:(NSString*)ID
{
    NSString*createid=[AppStore getYongHuID];
    NSString*companyid=[AppStore getGongsiID];
    NSString*sql=[NSString stringWithFormat:@"delete  FROM RenwuDB WHERE ID='%@' and createid='%@' and companyid='%@'",ID,createid,companyid];
    [DB executeSql:[NSString stringWithFormat:sql, ID]];
}
//改变任务状态  1--> 0
+ (void)updateRenWuStatus:(NSString *)renWuID{
    
    NSString*createid=[AppStore getYongHuID];
    NSString*companyid=[AppStore getGongsiID];
    NSString * sql = [NSString stringWithFormat:@"update RenwuDB set ISshangchuan=0 where ID = '%@' and createid='%@' and companyid='%@' ",renWuID,createid,companyid];

    [DB executeSql:sql];
}

@end
