//
//  RenwuData.m
//  Lvpingguo
//
//  Created by miao on 14-9-24.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "RenwuData.h"

@implementation RenwuData
@synthesize ID;
@synthesize title;
@synthesize content;
@synthesize starttime;
@synthesize endtime;
@synthesize remindtime;
@synthesize importance;
@synthesize memo;
@synthesize isfinish;
@synthesize companyid;
@synthesize deleteflag;
@synthesize finishid;
@synthesize type;
@synthesize createid;
@synthesize createtime;
@synthesize rate;
@synthesize respcount;
@synthesize createname;
@synthesize leaders;
@synthesize participants;
@synthesize updatetime;

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"ID", @"id");
    DCField(ap, @"title", @"title");
    DCField(ap, @"content", @"content");
    DCField(ap, @"starttime", @"starttime");
    DCField(ap, @"endtime", @"endtime");
    DCField(ap, @"remindtime", @"remindtime");
    DCField(ap, @"importance", @"importance");
    DCField(ap, @"memo", @"memo");
    DCField(ap, @"isfinish", @"isfinish");
    DCField(ap, @"companyid", @"companyid");
    DCField(ap, @"createname", @"createname");
    DCField(ap, @"deleteflag", @"deleteflag");
    DCField(ap, @"finishid", @"finishid");
    DCField(ap, @"type", @"type");
    DCField(ap, @"createid", @"createid");
    DCField(ap, @"createtime", @"createtime");
    DCField(ap, @"rate", @"rate");
    DCField(ap, @"respcount", @"respcount");
    DCField(ap, @"leaders", @"leaders");
    DCField(ap, @"participants", @"participants");
    DCField(ap, @"updatetime", @"updatetime");
}
@end
