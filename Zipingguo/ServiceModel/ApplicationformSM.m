//
//  ApplicationformSM.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ApplicationformSM.h"

@implementation ApplicationformSM
@synthesize _id,sort,strs,chname,type,flowid;

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"_id", @"id");
    DCField(ap, @"sort", @"sort");
    DCField(ap, @"strs", @"strs");
    DCField(ap, @"chname", @"chname");
    DCField(ap, @"type", @"type");
    DCField(ap, @"flowid", @"flowid");
}
@end
