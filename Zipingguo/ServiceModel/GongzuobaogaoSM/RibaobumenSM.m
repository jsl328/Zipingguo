//
//  RibaoanbumenSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "RibaobumenSM.h"

@implementation RibaobumenSM
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data", [RibiaobumenData class]);
}
@end
