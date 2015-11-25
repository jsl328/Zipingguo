//
//  RenyuanDataSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 15-2-2.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenyuanDataSM.h"
#import "RirenmingdailyPapers.h"
@implementation RenyuanDataSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [RirenmingdailyPapers class]);
}

@end
