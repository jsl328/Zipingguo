//
//  YanqingListSM.m
//  Zipingguo
//
//  Created by fuyonghua on 15/11/5.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "YanqingListSM.h"

@implementation YanqingListSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [YaoqingListDataSM class]);
}

@end

@implementation YaoqingListDataSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    
}

@end