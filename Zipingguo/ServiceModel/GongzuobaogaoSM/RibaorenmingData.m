//
//  RibaorenmingData.m
//  Lvpingguo
//
//  Created by miao on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "RibaorenmingData.h"

@implementation RibaorenmingData
@synthesize user;
@synthesize dailyPapers;
@synthesize weekPapers;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"user", @"user", [UserSM class]);
    DCListField(ap, @"dailyPapers", @"dailyPapers", [RirenmingdailyPapers class]);
    DCListField(ap, @"weekPapers", @"weekPapers", [RibumenweekPapers class]);
    DCListField(ap, @"workpapers", @"workpapers", [RirenmingdailyPapers class]);
    DCListField(ap, @"user0", @"user0", [UserSM class]);

    
}
@end
