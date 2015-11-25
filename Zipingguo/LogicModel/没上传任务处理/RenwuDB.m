//
//  RenwuDB.m
//  Zipingguo
//
//  Created by miao on 15/11/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenwuDB.h"
#import "RenwuLM.h"
@implementation RenwuDB

-(void)initWithLM:(RenwuLM*)lm
{
    self.ISshangchuan=lm.ISshangchuan;
    self.title=lm.title;
    self.content=lm.content;
    self.importance=lm.importance;
    self.memo=lm.memo;
    self.remindmsg=lm.remindmsg;
    self.endtime=lm.endtime;
    self.type=lm.type;
    self.participants=lm.participants;
    self.leaders=lm.leaders;
    self.createid=lm.createid;
    self.companyid=lm.companyid;
    self.ID=lm.ID;
    self.updatetime=lm.updatetime;
    
}
@end
