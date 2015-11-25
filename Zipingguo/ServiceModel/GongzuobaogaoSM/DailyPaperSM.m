//
//  DailyPaperSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "DailyPaperSM.h"

@implementation DailyPaperSM
-(void)provideAnnotations:(AnnotationProvider *)ap
{
     DCField(ap, @"ID", @"id");
     DCField(ap, @"summary", @"summary");
     DCField(ap, @"plan", @"plan");
     DCField(ap, @"createid", @"createid");
     DCField(ap, @"createtime", @"createtime");
     DCField(ap, @"deptid", @"deptid");
     DCField(ap, @"companyid", @"companyid");
     DCField(ap, @"dailyUsers", @"dailyUsers");
    DCField(ap, @"type", @"type");
}
@end
