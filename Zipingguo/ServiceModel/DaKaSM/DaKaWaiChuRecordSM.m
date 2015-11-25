//
//  DaKaWaiChuSM.m
//  Zipingguo
//
//  Created by sunny on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DaKaWaiChuRecordSM.h"

@implementation DaKaWaiChuRecordSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"content", @"content");
    DCField(ap, @"address", @"address");
    DCField(ap, @"createid", @"createid");
    DCField(ap, @"imgstrs", @"imgstrs");
    DCField(ap, @"sounds", @"sounds");
    DCField(ap, @"positionx", @"positionx");
    DCField(ap, @"positiony", @"positiony");
    DCField(ap, @"companyid", @"companyid");
}
@end
