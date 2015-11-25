//
//  ApplyDetailSM.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-23.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ApplyDetailSM.h"
#import "ApplyCcsSm.h"
#import "ApplyDetailsSM.h"
#import "ApplyrecordsSM.h"
@implementation ApplyDetailSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"apply", @"apply",[ApplyApprovalSM class]);
    DCListField(ap, @"applyccs", @"applyccs", [ApplyCcsSm class]);
    DCListField(ap, @"applyexts", @"applyexts", [ApplyDetailsSM class]);
    DCListField(ap, @"applyrecords", @"applyrecords", [ApplyrecordsSM class]);
}
@end
