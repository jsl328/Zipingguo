//
//  ApplyDetail2SM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-4.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ApplyDetailsSM.h"

@implementation ApplyDetailsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
}
@end
