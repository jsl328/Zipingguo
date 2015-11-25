//
//  RibiaobumenData.m
//  Lvpingguo
//
//  Created by miao on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "RibiaobumenData.h"

@implementation RibiaobumenData
@synthesize department;
@synthesize dailyPapers;
@synthesize weekPapers;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"department", @"department", [Ribaodepartment class]);
    DCListField(ap, @"dailyPapers", @"dailyPapers", [DailyPaperSM class]);
    DCListField(ap, @"weekPapers", @"weekPapers", [RibumenweekPapers class]);
    DCListField(ap, @"workpapers", @"workpapers", [RirenmingdailyPapers class]);
    
}

@end
