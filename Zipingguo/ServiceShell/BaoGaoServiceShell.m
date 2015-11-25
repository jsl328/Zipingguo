//
//  BaoGaoServiceShell.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/22.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "BaoGaoServiceShell.h"

@implementation BaoGaoServiceShell

+ (void) TijiaogeiwoGongzuoWithuserid:(NSString *)userid Papertype:(int)papertype Start:(int)start Count:(int)count createtime:(NSString*)createtime usingCallback:(void(^)(DCServiceContext*,BaoGaoResultSM*))callback{
    [LService request:@"submitYuePaperToMe.action" with:@[userid,[NSNumber numberWithInt:papertype],[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],createtime] returns:[BaoGaoResultSM class] whenDone:callback];
}

+ (void) mySubmitPaperWithCreateid:(NSString *)createid Papertype:(int)papertype Start:(int)start Count:(int)count createtime:(NSString*)createtime usingCallback:(void(^)(DCServiceContext*,BaoGaoResultSM*))callback{
    [LService request:@"mySubmitPaper.action" with:@[createid,[NSNumber numberWithInt:papertype],[NSNumber numberWithInt:start],[NSNumber numberWithInt:count],createtime] returns:[BaoGaoResultSM class] whenDone:callback];
}

+ (void) getPaperDetailWithID:(NSString *)ID Userid:(NSString *)userid usingCallback:(void(^)(DCServiceContext*,ZhoubaoxiangqingSM*))callback{
    [LService request:@"paperDetail.action" with:@[ID,userid] returns:[ZhoubaoxiangqingSM class] whenDone:callback];
}

+ (void) createGongzuoBaogaoWithCreateGongzuoBaogao:(XinjianShangchuanRibaoSM *)gongzuoBaogao usingCallback:(void(^)(DCServiceContext*,XInjianribaoSM*))callback{
    [LService request:@"workpaper.action" with:@[gongzuoBaogao] returns:[XInjianribaoSM class] whenDone:callback];
}

+ (void) getHaveSubmitPaperToMeDeptWithUserid:(NSString *)userid Papertype:(int)papertype usingCallback:(void(^)(DCServiceContext*,BaoGaoSortResultSM *))callback{
    [LService request:@"haveSubmitPaperToMeDept.action" with:@[userid,[NSNumber numberWithInt:papertype]] returns:[BaoGaoSortResultSM class] whenDone:callback];
}

+ (void)getSubmitPaperToMeDeptSortWithUserid:(NSString *)userid Papertype:(int)papertype Deptid:(NSString *)deptid Start:(int)start Count:(int)count usingCallback:(void(^)(DCServiceContext*,BaoGaoResultSM*))callback{
    [LService request:@"submitPaperToMeDeptSort.action1" with:@[userid,[NSNumber numberWithInt:papertype],deptid,[NSNumber numberWithInt:start],[NSNumber numberWithInt:count]] returns:[BaoGaoResultSM class] whenDone:callback];
}

+ (void) getHaveSubmitPaperToMeUnameWithUserid:(NSString *)userid Papertype:(int)papertype usingCallback:(void(^)(DCServiceContext*,BaoGaoSortResultSM *))callback{
    [LService request:@"haveSubmitPaperToMeUname.action" with:@[userid,[NSNumber numberWithInt:papertype]] returns:[BaoGaoSortResultSM class] whenDone:callback];
}

+ (void)getSubmitPaperToMeUnameSortWithUserid:(NSString *)userid Papertype:(int)papertype Createid:(NSString *)createid Start:(int)start Count:(int)count usingCallback:(void(^)(DCServiceContext*,BaoGaoResultSM*))callback{
    [LService request:@"submitPaperToMeUnameSort.action1" with:@[userid,[NSNumber numberWithInt:papertype],createid,[NSNumber numberWithInt:start],[NSNumber numberWithInt:count]] returns:[BaoGaoResultSM class] whenDone:callback];
}

+ (void)commentWorkWithCreateid:(NSString *)createid Content:(NSString *)content WeekPaperid:(NSString *)weekPaperid Isreply:(NSString *)isreply Topparid:(NSString *)topparid IDS:(NSString *)ids usingCallback:(void(^)(DCServiceContext*,RibaopinglunSM*))callback{
    [LService request:@"commentPaper.action" with:@[createid,content,weekPaperid,isreply,topparid,ids] returns:[RibaopinglunSM class] whenDone:callback];
}

@end
