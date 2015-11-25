//
//  ResultModelOfCompanyDeptsSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-2.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfCompanyDeptsSM.h"

@implementation ResultModelOfCompanyDeptsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [CompanyDeptsSM class]);
}
@end

@implementation CompanyDeptsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    DCField(ap, @"name", @"name");
    DCField(ap, @"isleaf", @"isleaf");
    DCField(ap, @"parid", @"parid");
    DCField(ap, @"memo", @"memo");
    DCField(ap, @"companyid", @"companyid");
    DCField(ap, @"sort", @"sort");
    DCField(ap, @"subdepts", @"subdepts");
}
@end

