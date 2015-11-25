//
//  BaoGaoResultSM.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/29.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "BaoGaoResultSM.h"
@implementation BaoGaoResultSM

-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data", [BaoGaoListSM class]);
    
}

@end
