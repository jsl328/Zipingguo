//
//  WotijiaozhoubaoData.m
//  Lvpingguo
//
//  Created by miao on 14-10-8.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "WotijiaozhoubaoData.h"

@implementation WotijiaozhoubaoData
@synthesize ID;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"ID", @"id");
}
@end
