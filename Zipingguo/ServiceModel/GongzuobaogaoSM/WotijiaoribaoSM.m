//
//  WotijiaoribaoSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "WotijiaoribaoSM.h"

@implementation WotijiaoribaoSM
@synthesize ID;


-(void)provideAnnotations:(AnnotationProvider *)ap
{
     DCField(ap, @"ID", @"id");
     DCField(ap, @"summary", @"summary");
     DCField(ap, @"Plan", @"Plan");
     DCField(ap, @"Createid", @"Createid");
     DCField(ap, @"Createtime", @"Createtime");
     DCField(ap, @"deptid", @"deptid");
     DCField(ap, @"Companyid", @"Companyid");
    DCField(ap, @"createname", @"createname");
    DCListField(ap, @"approverusers", @"approverusers", [ApproverusersSM class]);
    DCListField(ap, @"ccusers", @"ccusers", [CcusersSM class]);
}
@end
