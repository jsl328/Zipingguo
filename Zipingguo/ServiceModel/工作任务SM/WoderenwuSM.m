//
//  WoderenwuSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "WoderenwuSM.h"

@implementation WoderenwuSM
@synthesize data;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data", [RenwuData class]);
    DCListField(ap, @"data1", @"data1", [RenwuData class]);
}
@end
