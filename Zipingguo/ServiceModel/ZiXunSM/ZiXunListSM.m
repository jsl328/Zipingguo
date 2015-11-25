//
//  ZiXunListSM.m
//  Zipingguo
//
//  Created by sunny on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunListSM.h"

@implementation ZiXunListSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [ZiXunListSubSM class]);
     DCListField(ap, @"data1", @"data1", [ZiXunListSubSM class]);
}
@end

@implementation ZiXunListSubSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"ziXunID", @"id");
    
}

@end
