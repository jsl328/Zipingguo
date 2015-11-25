//
//  ResultModelShangchuanXiangpianSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-23.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelShangchuanWenjianSM.h"

@implementation ResultModelShangchuanWenjianSM


- (void)provideAnnotations:(AnnotationProvider *)ap{

    DCListField(ap, @"data", @"data", [ModelUrlSM class]);
}
@end

@implementation ModelUrlSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"url", @"url");

}
@end