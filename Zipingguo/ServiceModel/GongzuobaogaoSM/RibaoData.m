//
//  RibaoData.m
//  Lvpingguo
//
//  Created by miao on 14-10-9.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "RibaoData.h"

@implementation RibaoData
@synthesize dailyPaper;
@synthesize createuser;
@synthesize approverusers;
@synthesize ccusers;
@synthesize dailyComments;

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"dailyComments", @"dailyComments", [DailyCommentsSM class]);
    DCListField(ap, @"dailyPaper", @"dailyPaper", [DailyPaperSM class]);
    DCListField(ap, @"ccusers", @"ccusers", [CcusersSM class]);
    DCListField(ap, @"approverusers", @"approverusers", [ApproverusersSM class]);
    DCListField(ap, @"createuser", @"createuser", [CreateuserSM class]);
    
}
@end
