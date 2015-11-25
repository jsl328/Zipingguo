//
//  ZiXunXiangQingSM.m
//  Zipingguo
//
//  Created by sunny on 15/10/30.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunXiangQingSM.h"

@implementation ZiXunXiangQingSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [ZiXunContentSM class]);
}
@end

@implementation ZiXunContentSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"ziXunID", @"ID");
}

@end
