//
//  RibaopinglunSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "RibaopinglunSM.h"

@implementation RibaopinglunSM
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"ribaopinglun", @"data", [DailyCommentsSM class]);
}
@end
