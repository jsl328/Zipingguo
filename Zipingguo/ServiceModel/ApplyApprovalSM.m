//
//  ApplyApprovalSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ApplyApprovalSM.h"

@implementation ApplyApprovalSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    DCField(ap, @"status", @"status");
}
@end
