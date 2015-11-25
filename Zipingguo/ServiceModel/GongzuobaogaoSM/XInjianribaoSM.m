//
//  XInjianribaoSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "XInjianribaoSM.h"

@implementation XInjianribaoSM
@synthesize status;
@synthesize msg;
@synthesize data;

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"status", @"status");
    DCField(ap, @"msg", @"msg");
    DCListField(ap, @"data", @"entity", [DataSM class]);
}
@end
