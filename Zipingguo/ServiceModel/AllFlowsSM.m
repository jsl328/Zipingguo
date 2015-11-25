//
//  AllFlowsSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "AllFlowsSM.h"

@implementation AllFlowsSM
@synthesize im;
@synthesize name;
@synthesize infodescription;
@synthesize defaultuserid;
@synthesize deleteflag;
@synthesize companyid;
@synthesize defaultusername;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"im", @"id");
    DCField(ap, @"name", @"name");
    DCField(ap, @"infodescription", @"description");
    DCField(ap, @"defaultuserid", @"defaultuserid");
    DCField(ap, @"deleteflag", @"deleteflag");
    DCField(ap, @"companyid", @"companyid");
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"不存在该键值%@",key);
}
@end
