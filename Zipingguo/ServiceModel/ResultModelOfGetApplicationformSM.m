//
//  ResultModelOfGetApplicationformSM.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfGetApplicationformSM.h"

@implementation ResultModelOfGetApplicationformSM
@synthesize data,data1;

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data", [ApplicationformSM class]);
    DCField(ap, @"data1", @"data1");
}
@end
