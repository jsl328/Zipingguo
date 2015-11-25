//
//  ZhoubiaorenmingData.m
//  Lvpingguo
//
//  Created by miao on 14-10-11.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ZhoubiaorenmingData.h"

@implementation ZhoubiaorenmingData
@synthesize user;
@synthesize weekPapers;
@synthesize dailyPapers;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"user", @"user", [UserSM class]);
     DCListField(ap, @"weekPapers", @"weekPapers", [RibumenweekPapers class]);
     DCListField(ap, @"dailyPapers", @"dailyPapers", [DailyPapers class]);
}
@end
