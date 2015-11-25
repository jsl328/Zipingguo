//
//  JiRiJiLuListSM.m
//  Zipingguo
//
//  Created by sunny on 15/10/27.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "JinRiJiLuListSM.h"
#import "DaKaRecordSM.h"

@implementation JinRiJiLuListSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [DaKaRecordSM class]);
}
@end
