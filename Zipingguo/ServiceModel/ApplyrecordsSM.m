//
//  ApplyrecordsSM.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ApplyrecordsSM.h"

@implementation ApplyrecordsSM

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"_id", @"id");
}
@end
