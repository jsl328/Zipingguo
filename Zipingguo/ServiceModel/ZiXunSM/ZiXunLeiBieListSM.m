//
//  ZiXunListSM.m
//  Zipingguo
//
//  Created by sunny on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunLeiBieListSM.h"

@implementation ZiXunLeiBieListSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
     DCListField(ap, @"data", @"data", [ZiXunLeiBieSM class]);
}
@end
