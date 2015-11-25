//
//  ZhoubiaobumenData.m
//  Lvpingguo
//
//  Created by miao on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ZhoubiaobumenData.h"

@implementation ZhoubiaobumenData
@synthesize department;
@synthesize weekPapers;
@synthesize dailyPapers;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"department", @"department", [Zhoubaodepartment class]);
    DCListField(ap, @"weekPapers", @"weekPapers", [RibumenweekPapers class]);
    DCListField(ap, @"dailyPapers", @"dailyPapers",[DailyPapers class]);
}
@end
