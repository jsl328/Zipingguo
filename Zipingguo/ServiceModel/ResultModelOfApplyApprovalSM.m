//
//  ResultModelOfApplyApprovalSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfApplyApprovalSM.h"
#import "ApplyApprovalSM.h"
@implementation ResultModelOfApplyApprovalSM
@synthesize status;
@synthesize data;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"status", @"status");
    DCListField(ap, @"data", @"data", [ApplyApprovalSM class]);
}
@end
