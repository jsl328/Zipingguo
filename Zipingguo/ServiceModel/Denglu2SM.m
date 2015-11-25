//
//  Denglu2SM.m
//  Zipingguo
//
//  Created by fuyonghua on 15/11/1.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "Denglu2SM.h"

@implementation Denglu2SM

- (void)provideAnnotations:(AnnotationProvider *)ap{
//    DCListField(ap ,@"data", @"data", [GongSiSM class]);
    DCListField(ap ,@"xinxiData", @"data", [GongSiSM class]);
}

@end

@implementation GongSiSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap ,@"ID", @"id");
}

@end
