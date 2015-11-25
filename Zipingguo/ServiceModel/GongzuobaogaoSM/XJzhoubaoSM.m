//
//  XJzhoubaoSM.m
//  Lvpingguo
//
//  Created by miao on 14-10-8.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "XJzhoubaoSM.h"
#import "DailyUsersSM.h"
@implementation XJzhoubaoSM
@synthesize summary;
@synthesize plan;
@synthesize createid;
@synthesize createtime;
@synthesize dailyUsers;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"summary", @"summary");
    DCField(ap, @"plan", @"plan");
    DCField(ap, @"createid", @"createid");
    DCField(ap, @"createtime", @"createtime");
    DCListField(ap, @"dailyUsers", @"dailyUsers", [DailyUsersSM class]);
}

@end
