//
//  YaoqingSM.m
//  Zipingguo
//
//  Created by fuyonghua on 15/11/3.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "YaoqingSM.h"

@implementation YaoqingSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [NSString class]);
}

@end
