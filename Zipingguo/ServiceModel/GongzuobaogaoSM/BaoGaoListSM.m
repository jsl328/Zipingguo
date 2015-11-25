//
//  BaoGaoListSM.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/29.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "BaoGaoListSM.h"

@implementation BaoGaoListSM

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
    DCField(ap, @"papertype", @"papertype");
    
}

@end
