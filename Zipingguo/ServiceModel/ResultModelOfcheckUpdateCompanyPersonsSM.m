//
//  ResultModelOfcheckUpdateCompanyPersonsSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-20.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfcheckUpdateCompanyPersonsSM.h"
@class CheckUpdateCompanyPersonsSM;
@implementation ResultModelOfcheckUpdateCompanyPersonsSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [CheckUpdateCompanyPersonsSM class]);
    DCListField(ap, @"data1", @"data1", [NSString class]);
}
@end

@implementation CheckUpdateCompanyPersonsSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    
}
@end