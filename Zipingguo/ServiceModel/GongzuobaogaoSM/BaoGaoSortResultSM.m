//
//  BaoGaoSortResultSM.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/30.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "BaoGaoSortResultSM.h"

@implementation BaoGaoSortResultSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [CompanyDeptsSortSM class]);
}
@end



@implementation CompanyDeptsSortSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"ID", @"id");
}

@end

