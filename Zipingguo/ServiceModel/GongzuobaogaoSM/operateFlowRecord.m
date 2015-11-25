//
//  operateFlowRecord.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-24.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "operateFlowRecord.h"

@implementation operateFlowRecord
@synthesize status,msg;

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"status", @"status");
    DCField(ap, @"msg", @"msg");
}
@end
