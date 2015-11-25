//
//  ResultModelOfAllFlowSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfAllFlowSM.h"
#import "AllFlowsSM.h"
@implementation ResultModelOfAllFlowSM
@synthesize data;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [AllFlowsSM class]);
}
@end
