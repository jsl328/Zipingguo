//
//  ResultModelOfFeedbackSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-20.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfFeedbackSM.h"

@implementation ResultModelOfFeedbackSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"status", @"status");
    DCField(ap, @"msg", @"msg");
    DCListField(ap, @"entity", @"entity", [FeedbackSM class]);
}

@end

@implementation FeedbackSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    DCField(ap, @"userid", @"userid");
    DCField(ap, @"content", @"content");
    DCField(ap, @"createtime", @"createtime");
}

@end