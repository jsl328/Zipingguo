//
//  RenwuLM.m
//  Zipingguo
//
//  Created by miao on 15/11/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenwuLM.h"
#import "RenwuStores.h"

@implementation RenwuLM

-(void)initWithDB:(RenwuDB*)db
{
    self.ID=db.ID;
    self.ISshangchuan=db.ISshangchuan;
    self.title=db.title;
    self.content=db.content;
    self.importance=db.importance;
    self.memo=db.memo;
    self.remindmsg=db.remindmsg;
    self.endtime=db.endtime;
    self.type=db.type;
    self.participants=db.participants;
    self.leaders=db.leaders;
    self.createid=db.createid;
    self.companyid=db.companyid;
 

}

-(void)initWithSM:(ChuangjianRenwuSM*)sm
{

    self.ID=sm.ID;
    self.title=sm.title;
    self.content=sm.content;
    self.importance=sm.importance;
    self.memo=sm.memo;
    self.remindmsg=sm.remindmsg;
    self.endtime=sm.endtime;
    self.type=sm.type;
    //participants,leaders将负责人参与人的数组转换成字符串;
    self.participants=[sm.participants componentsJoinedByString:@","];
    self.leaders=[sm.leaders componentsJoinedByString:@","];
    self.createid=sm.createid;
    self.companyid=sm.companyid;
   

}

-(void)save
{
   
    if ([RenwuStores isSameID:self.ID]) {
        if ([RenwuStores isupdatetime:self.updatetime]) {
            return;
        }else
        {
            [RenwuStores deleteRenwu:self.ID];
        }
    }
    RenwuDB*db=[[RenwuDB alloc]init];
    [db initWithLM:self];
    [db save];
    
}
@end
