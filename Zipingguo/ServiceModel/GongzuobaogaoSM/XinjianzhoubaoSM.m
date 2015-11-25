//
//  XinjianzhoubaoSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "XinjianzhoubaoSM.h"

@implementation XinjianzhoubaoSM
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data", [ZhoubaoDataSM class]);
}
@end
