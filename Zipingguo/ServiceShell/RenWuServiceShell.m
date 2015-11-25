//
//  RenWuServiceShell.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuServiceShell.h"

@implementation RenWuServiceShell

+(void)getMyRenWuListWithcreateid:(NSString *)createid start:(int)start count:(int)count type:(NSInteger )type usingCallback:(void (^)(DCServiceContext*context, WoderenwuSM*sm)) callback
{
    NSString*Start=[NSString stringWithFormat:@"%d",start];
    NSString*Count=[NSString stringWithFormat:@"%d",count];
    if (type==0)
        [LService request:@"getMyTasks.action" with:@[createid,Start,Count] returns:[WoderenwuSM class] whenDone:callback];
    else
        [LService request:@"getMyAllotTask.action" with:@[createid,Start,Count] returns:[WoderenwuSM class] whenDone:callback];
}
+(void)getRenWuDetailWithID:(NSString *)renWuId createid:(NSString*)createid usingCallback:(void (^)(DCServiceContext*context, RenWuDetailSM*sm)) callback/**<获取任务详情*/{
    [LService request:@"taskDetail.action" with:@[renWuId,createid] returns:[RenWuDetailSM class] whenDone:callback];
}
+(void)addKuaiJieTaskWithTitle:(NSString *)title createid:(NSString*)createid usingCallback:(void (^)(DCServiceContext*context, TaskBaseSM*sm)) callback/**<创建快捷任务*/{
      [LService request:@"createQuickTask.action" with:@[title,createid,[AppStore getGongsiID]] returns:[TaskBaseSM class] whenDone:callback];
}
+(void)markTaskStateWithID:(NSString *)id isFinish:(BOOL)isFinish usingCallback:(void (^)(DCServiceContext*, ResultMode*))  callback/**<标记任务为已完成完成*/{
    if(isFinish){
        [LService request:@"markFinish.action" with:@[id] returns:[ResultMode class] whenDone:callback];
    }else
        [LService request:@"markUnfinish.action" with:@[id] returns:[ResultMode class] whenDone:callback];

}
+(void) xinjianrenwuWithCreateid:(ChuangjianRenwuSM *)publishDynamicSN usingCallback:(void (^)(DCServiceContext*, TaskBaseSM*)) callback/**<新建任务*/{
    [LService request:@"createTask.action" with:@[publishDynamicSN] returns:[TaskBaseSM class] whenDone:callback];
}

+(void)renWuPingLunWithcreateid:(NSString *)createid content:(NSString*)content taskid:(NSString*)taskid
                        isreply:(NSString*)isreply topparid:(NSString*)topparid IDS:(NSString *)ids
                  usingCallback:(void (^)(DCServiceContext*context,RenWuPingLunSM *sm))callback{
    /**<添加任务评论*/
    [LService request:@"commentTask.action" with:@[createid,content,taskid,isreply,topparid,ids] returns:[RenWuPingLunSM class] whenDone:callback];
   
}
/**<修改任务详情的某一项*/
+(void)upDateRenWuValueWithColumn:(RenWuColumn)column value:(NSString*)value id:(NSString *)id createid:(NSString*)createid usingCallback:(void (^)(DCServiceContext*context, ResultMode*sm))callback{
    NSArray *array = @[@"title",@"remindmsg",@"endtime",@"importance",@"content",@"memo"];
    [LService request:@"updateTaskColumn.action" with:@[id,array[column],value,createid] returns:[ResultMode class] whenDone:callback];
}

+(void)upDateRenWuCanYuPersonWithTaskid:(NSString *)taskid Type:(int)type IDS:(NSString *)ids usingCallback:(void (^)(DCServiceContext*context, ResultMode*sm))  callback{
     [LService request:@"updateDuty.action" with:@[ids,taskid,[NSNumber numberWithInt:type]] returns:[ResultMode class] whenDone:callback];
}

/**
 *  删除任务
 *
 *  @param ID 任务id
 */
+(void)shanChuRenWuWithID:(NSString *)ID usingCallback:(void (^)(DCServiceContext*context,ResultMode*sm)) callback{
    [LService request:@"delTask.action" with:@[ID] returns:[ResultMode class] whenDone:callback];
}

//任务评论删除
+(void)ShanshurenupinglunWithCreateid:(NSString *)createid ID:(NSString *)id usingCallback:(void (^)(DCServiceContext*, ResultMode*))callback
{
    [ LService request:@"delTaskcomment.action" with:@[createid,id] returns:[HPResultSM class] whenDone:callback];
    
}

+(void)updateTaskWithCreateid:(ChuangjianRenwuSM *)publishDynamicSN
                usingCallback:(void (^)(DCServiceContext*context, TaskBaseSM*sm)) callback{
    [LService request:@"updateTask.action" with:@[publishDynamicSN] returns:[TaskBaseSM class] whenDone:callback];
}

@end
