//
//  RenwuStores.h
//  Zipingguo
//
//  Created by miao on 15/11/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RenwuDB;
@class RenwuLM;

@interface RenwuStores : NSObject
//没有上传的任务
+(NSArray*)getmeishangchuanrenwu;
//查询是否有重复的ID
+ (BOOL)isSameID:(NSString *)ID;
//updatetime更新时间是否重复
+(BOOL)isupdatetime:(NSString*)updatetime;
//删除某一条记录
+(void)deleteRenwu:(NSString*)ID;
///改变任务状态  1--> 0
+ (void)updateRenWuStatus:(NSString *)renWuID;
@end
