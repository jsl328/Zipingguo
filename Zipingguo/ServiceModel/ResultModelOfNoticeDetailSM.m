//
//  ResultModelOfNoticeDetailSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-2.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfNoticeDetailSM.h"

@implementation ResultModelOfNoticeDetailSM
@synthesize data;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [NoticeSM class]);
}
@end
