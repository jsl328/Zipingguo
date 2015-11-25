//
//  ChuangjianRenwuSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ChuangjianRenwuSM.h"
#import "RenWuServiceShell.h"
#import "RenwuStores.h"

@implementation ChuangjianRenwuSM
@synthesize participants;
@synthesize leaders;
@synthesize title;
@synthesize content;
@synthesize endtime;
@synthesize remindmsg;
@synthesize importance;
@synthesize memo;
@synthesize createid;
@synthesize companyid;
@synthesize ID;
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"ID", @"id");
}
- (void)setSMWithDB:(RenwuDB *)db
{
  
    self.title=db.title;
    self.content=db.content;
    self.importance=db.importance;
    self.memo=db.memo;
    self.remindmsg=db.remindmsg;
    self.endtime=db.endtime;
    self.type=db.type;
    //participants,leaders将负责人参与人的字符串转换成数组;
    self.participants=[db.participants componentsSeparatedByString:@","];
    self.leaders=[db.leaders componentsSeparatedByString:@","];
    self.createid=db.createid;
    self.companyid=db.companyid;
    self.ID=db.ID;
    [RenWuServiceShell xinjianrenwuWithCreateid:self usingCallback:^(DCServiceContext *context, TaskBaseSM *sm) {
        if (context.isSucceeded==YES&&sm.status==0) {
           [RenwuStores updateRenWuStatus:self.ID];
            
        }
    }];
}
@end
