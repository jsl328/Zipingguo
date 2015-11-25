//
//  TjiaowoData.m
//  Lvpingguo
//
//  Created by miao on 14-10-8.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "TjiaowoData.h"

@implementation TjiaowoData
@synthesize ID;
@synthesize plan;
@synthesize createid;
@synthesize createtime;
@synthesize deptid;
@synthesize summary;
@synthesize companyid;

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
