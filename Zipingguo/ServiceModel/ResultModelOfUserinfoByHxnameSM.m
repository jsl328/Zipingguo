//
//  ResultModelOfUserinfoByHxnameSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfUserinfoByHxnameSM.h"

@implementation ResultModelOfUserinfoByHxnameSM
@synthesize data;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [UserinfoByHuanxinSM class]);
}
@end
