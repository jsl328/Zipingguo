//
//  DailyCommentsSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "DailyCommentsSM.h"

@implementation DailyCommentsSM

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"ID", @"id");
    DCField(ap, @"content", @"content");
    DCField(ap, @"createid", @"createid");
    DCField(ap, @"createtime", @"createtime");
    DCField(ap, @"dailypaperid", @"dailypaperid");
    DCField(ap, @"isreply", @"isreply");
    DCField(ap, @"topparid", @"topparid");
    DCField(ap, @"createname", @"createname");
    DCField(ap, @"createimgurl", @"createimgurl");
   
}

@end
