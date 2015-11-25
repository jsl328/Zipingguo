//
//  WoTiJiaoRiBaoDataSM.m
//  Lvpingguo
//
//  Created by linku on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "WoTiJiaoRiBaoDataSM.h"

@implementation WoTiJiaoRiBaoDataSM
@synthesize data;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data", [WotijiaoribaoSM class]);

}
@end
