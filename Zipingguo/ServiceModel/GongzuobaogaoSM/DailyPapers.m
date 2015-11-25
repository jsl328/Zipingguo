//
//  DailyPapers.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "DailyPapers.h"

@implementation DailyPapers
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"ID", @"id");
}
@end
