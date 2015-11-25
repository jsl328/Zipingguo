//
//  WotijiaozhoubaoSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "WotijiaozhoubaoSM.h"

@implementation WotijiaozhoubaoSM
@synthesize data;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data", [WotijiaozhoubaoData class]);
}
@end
