//
//  RibaotaolunDataSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "RibaotaolunDataSM.h"

@implementation RibaotaolunDataSM
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"ID", @"id");
}
@end
