//
//  CreateuserSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "CreateuserSM.h"

@implementation CreateuserSM
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"ID", @"id");
    DCField(ap, @"name", @"name");
}
@end
