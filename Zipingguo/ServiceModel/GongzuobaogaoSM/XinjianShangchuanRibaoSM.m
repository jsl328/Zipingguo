//
//  XinjianShangchuanRibaoSM.m
//  Lvpingguo
//
//  Created by linku on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "XinjianShangchuanRibaoSM.h"
#import "DailyUsersSM.h"
@implementation XinjianShangchuanRibaoSM
@synthesize summary;
@synthesize plan;
@synthesize createid;
@synthesize createtime;
//@synthesize dailyUsers;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"papername", @"papername");
    DCField(ap, @"summary", @"summary");
    DCField(ap, @"plan", @"plan");
    DCField(ap, @"createid", @"createid");
    DCField(ap, @"createtime", @"createtime");
//    DCListField(ap, @"dailyUsers", @"dailyUsers", [DailyUsersSM class]);
    DCListField(ap, @"annexlist", @"annexlist", [FujianDataModel class]);

}
@end

@implementation FujianDataModel

-(void)provideAnnotations:(AnnotationProvider *)ap{

}

@end
