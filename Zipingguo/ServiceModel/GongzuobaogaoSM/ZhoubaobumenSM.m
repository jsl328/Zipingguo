//
//  ZhoubaobumenSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ZhoubaobumenSM.h"

@implementation ZhoubaobumenSM

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data",[ZhoubiaobumenData class]);
    
}
@end

@implementation BumenSM

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data",[ZhoubiaobumenData class]);
    
}
@end