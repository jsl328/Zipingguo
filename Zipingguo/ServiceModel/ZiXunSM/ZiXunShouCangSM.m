//
//  ZiXunShouCangSM.m
//  Zipingguo
//
//  Created by sunny on 15/11/2.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunShouCangSM.h"

@implementation ZiXunShouCangSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [ZiXunShouCangSubSM class]);
}

@end

@implementation ZiXunShouCangSubSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"ziXunID", @"id");
}

@end
