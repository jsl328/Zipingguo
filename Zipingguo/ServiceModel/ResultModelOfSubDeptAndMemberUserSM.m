//
//  ResultModelOfSubDeptAndMemberUserSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-11-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfSubDeptAndMemberUserSM.h"

@implementation ResultModelOfSubDeptAndMemberUserSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [SubDeptAndMemberUserSM class]);
}
@end

@implementation SubDeptAndMemberUserSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    DCListField(ap, @"subdepts", @"subdepts", [CompanyDeptsSM class]);
    DCListField(ap, @"users", @"users", [DeptPersonsSM class]);
    
}
@end