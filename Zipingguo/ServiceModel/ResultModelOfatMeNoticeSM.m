//
//  ResultModelOfatMeNoticeSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfatMeNoticeSM.h"
@class AtMeNoticeSM;
@implementation ResultModelOfatMeNoticeSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [AtMeNoticeSM class]);
}
@end
@implementation AtMeNoticeSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
}
@end