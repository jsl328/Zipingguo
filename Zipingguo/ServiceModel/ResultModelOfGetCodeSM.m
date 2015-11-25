//
//  ResultModelOfGetCodeSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-16.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfGetCodeSM.h"

@implementation ResultModelOfGetCodeSM
@synthesize status;
@synthesize msg;
@synthesize data;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"status", @"status");
    DCField(ap, @"msg", @"msg");
    DCField(ap, @"data", @"data");
}
@end
