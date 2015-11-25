//
//  DaKaSM.m
//  Zipingguo
//
//  Created by sunny on 15/11/2.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DaKaSM.h"

@implementation DaKaSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"daKaSounds", @"sounds", [DaKaSoundsSM class]);
    DCListField(ap, @"imagesStr", @"imgs", [DaKaSoundsSM class]);
    DCField(ap, @"yongHuID", @"createid");
    DCField(ap, @"address", @"attdaddr");
    DCField(ap, @"positionx", @"positionx");
    DCField(ap, @"positiony", @"positiony");
    DCField(ap, @"content", @"content");
    DCField(ap, @"daKaType", @"attdtype");
}
@end

@implementation DaKaSoundsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"soundUrl", @"resurl");
    DCField(ap, @"soundTime", @"spendtime");
}

@end