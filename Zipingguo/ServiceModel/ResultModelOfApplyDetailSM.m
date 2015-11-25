//
//  ResultModelOfApplyDetailSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfApplyDetailSM.h"

@implementation ResultModelOfApplyDetailSM
@synthesize data;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data",[ApplyDetailSM class]);
}
@end
