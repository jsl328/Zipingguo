//
//  CreateApplySM.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "CreateApplySM.h"

@implementation CreateApplySM


- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    DCField(ap, @"createid", @"createid");
    DCField(ap, @"createname", @"createname");
    DCField(ap, @"flowid", @"flowid");
    DCField(ap, @"flowname", @"flowname");
    DCField(ap, @"companyid", @"companyid");
    DCField(ap, @"dealid", @"dealid");
    DCField(ap, @"ccs", @"ccs");
    DCListField(ap, @"applyexts", @"applyexts", [MapsSM class]);
}
@end
