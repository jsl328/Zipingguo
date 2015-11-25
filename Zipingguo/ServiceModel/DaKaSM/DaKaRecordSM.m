//
//  DaKaRecordSM.m
//  Zipingguo
//
//  Created by sunny on 15/10/27.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DaKaRecordSM.h"

@implementation DaKaRecordSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
     DCField(ap, @"companyID", @"companyid");
     DCField(ap, @"recordID", @"id");
     DCField(ap, @"createDate", @"createdate");
     DCField(ap, @"createID", @"createid");
     DCField(ap, @"nowTime", @"ontime");
     DCField(ap, @"address", @"onaddress");
     DCField(ap, @"week", @"week");
     DCField(ap, @"deleteFlag", @"deleteflag");
    DCField(ap, @"timeStr", @"time");
}

@end
