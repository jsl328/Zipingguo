//
//  ResultModelOfCompanyPersonsSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-3.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfCompanyPersonsSM.h"
#import "DeptPersonsSM.h"
@implementation ResultModelOfCompanyPersonsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [DeptPersonsSM class]);
    
}
@end
