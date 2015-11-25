//
//  ZiXunServiceShell.m
//  Zipingguo
//
//  Created by sunny on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunServiceShell.h"

@implementation ZiXunServiceShell

+ (void) getZiXunLeiBieListWithCompanyID:(NSString *)companyID UsingCallback:(void (^)(DCServiceContext *, ZiXunLeiBieListSM *))callback{
    [LService request:@"getInfoType.action" with:@[companyID] returns:[ZiXunLeiBieListSM class] whenDone:callback];
}
+ (void)getZuiXinZiXunListWithStartIndex:(int)startIndex PageSize:(int)pageSize usingCallback:(void (^)(DCServiceContext *, ZiXunListSM *))callback{
    [LService request:@"getNewInfoList.action" with:@[[NSNumber numberWithInt:startIndex],[NSNumber numberWithInt:pageSize]] returns:[ZiXunListSM class] whenDone:callback];
}
+ (void)getShouCangZiXunListWithYongHuID:(NSString *)yongHuID StartIndex:(int)startIndex PageSize:(int)pageSize UsingCallback:(void (^)(DCServiceContext *, ZiXunListSM *))callback{
    [LService request:@"collectInfoList.action" with:@[yongHuID,[NSNumber numberWithInt:startIndex],[NSNumber numberWithInt:pageSize]] returns:[ZiXunListSM class] whenDone:callback];
}
+ (void)getCommenZiXunListWithLeiBieID:(NSString *)leiBieID startIndex:(int)startIndex PageSize:(int)pageSize usingCallback:(void (^)(DCServiceContext *, ZiXunListSM *))callback{
    [LService request:@"getInfoByType.action" with:@[leiBieID,[NSNumber numberWithInt:startIndex],[NSNumber numberWithInt:pageSize]] returns:[ZiXunListSM class] whenDone:callback];
}
+ (void)shouCangZiXunWithYongHuID:(NSString *)yongHuID ZiXunID:(NSString *)ziXunID UsingCallback:(void (^)(DCServiceContext *, ZiXunShouCangSM *))callback{
    [LService request:@"collectInfo.action" with:@[yongHuID ,ziXunID] returns:[ZiXunShouCangSM class] whenDone:callback];
}
+ (void)quXiaoShouCangWithYongHuID:(NSString *)yongHuID ZiXunID:(NSString *)ziXunID UsingCallback:(void (^)(DCServiceContext *, ZiXunQuXiaoShouCangSM *))callback{
    [LService request:@"cancelcollect.action1" with:@[yongHuID,ziXunID] returns:[ZiXunQuXiaoShouCangSM class] whenDone:callback];
}
+ (void)dianZanWithYongHuID:(NSString *)yongHuID ZiXunID:(NSString *)ziXunID CreateName:(NSString *)createName UsingCallback:(void (^)(DCServiceContext *, ZiXunZanSM *))callback{
    [LService request:@"praise.action" with:@[yongHuID,ziXunID,createName] returns:[ZiXunZanSM class] whenDone:callback];
}
+ (void)quXiaoZanWithYongHuID:(NSString *)yongHuID ZiXunID:(NSString *)ziXunID UsingCallback:(void (^)(DCServiceContext *, ZiXunZanSM *))callback{
     [LService request:@"cancelPraise.action" with:@[yongHuID,ziXunID] returns:[ZiXunZanSM class] whenDone:callback];
}
+ (void)getZiXunXiangQingWithZiXunID:(NSString *)ziXunID YongHuID:(NSString *)yongHuID usingCallback:(void (^)(DCServiceContext *, ZiXunXiangQingSM *))callback{
    [LService request:@"getInfoDetail.action" with:@[ziXunID,yongHuID] returns:[ZiXunXiangQingSM class] whenDone:callback];
}

+ (void)ziXunTiJiaoPingLunWithYongHuID:(NSString *)yongHuID Content:(NSString *)content ZiXunID:(NSString *)ziXunID IsReply:(NSString *)isReply TopParid:(NSString *)topParid ATIDs:(NSString *)atIDs UsingCallback:(void (^)(DCServiceContext *, ZiXunTiJiaoPingPunSM *))callback{
    [LService request:@"comment.action" with:@[yongHuID,content,ziXunID,isReply,topParid,atIDs] returns:[ZiXunTiJiaoPingPunSM class] whenDone:callback];
}
+ (void)ziXunPingLunListWithZiXunID:(NSString *)ziXunID UsingCallback:(void (^)(DCServiceContext *, ZiXunPingLunResultSM *))callback{
    [LService request:@"getInfoCommentList.action" with:@[ziXunID] returns:[ZiXunPingLunResultSM class] whenDone:callback];
}
+ (void)ziXunPingLunDeleteWithYongHuID:(NSString *)yongHuID PingLunID:(NSString *)pingLunID UsingCallback:(void (^)(DCServiceContext *, ResultMode *))callback{
    [LService request:@"infoDel.action" with:@[yongHuID,pingLunID] returns:[ZiXunPingLunResultSM class] whenDone:callback];
}
@end
