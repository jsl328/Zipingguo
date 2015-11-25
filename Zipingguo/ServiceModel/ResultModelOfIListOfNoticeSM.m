//
//  ResultModelOfIListOfNoticeSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-2.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfIListOfNoticeSM.h"

@implementation ResultModelOfIListOfNoticeSM
@synthesize data;
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [NoticeSM class]);
    DCListField(ap, @"data1", @"data1", [NoticeSM class]);
}
@end

@implementation NoticeSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    DCField(ap, @"content", @"content");
    DCField(ap, @"createtime", @"createtime");
    DCField(ap, @"title", @"title");
    DCField(ap, @"companyid", @"companyid");
    DCField(ap, @"deleteflay", @"deleteflay");
    DCListField(ap, @"noticeAnnexs", @"noticeAnnexs", [NoticeAnnexsSM class]);
    DCField(ap, @"isRead", @"isRead");
    DCField(ap, @"isCollect", @"isCollect");
}
@end

@implementation NoticeAnnexsSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
}
@end