//
//  MapsTiaoxiuSM.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-10-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "MapsTiaoxiuSM.h"

@implementation MapsTiaoxiuSM
@synthesize kaishiTime,jieshuTime,shiyou;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"shiyou", @"5");
    DCField(ap, @"kaishiTime", @"6");
    DCField(ap, @"jieshuTime", @"7");
}
@end
