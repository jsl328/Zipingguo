//
//  UserSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "UserSM.h"

@implementation UserSM
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"ID", @"id");
}
@end
