//
//  WorkpaperAnnexsSM.m
//  Lvpingguo
//
//  Created by linku on 15-1-23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WorkpaperAnnexsSM.h"

@implementation WorkpaperAnnexsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"ID", @"id");
    DCField(ap, @"workpaperid", @"workpaperid");
    DCField(ap, @"filename", @"filename");
    DCField(ap, @"fileurl", @"fileurl");
    DCField(ap, @"filesize", @"filesize");
    DCField(ap, @"imgurl", @"imgurl");
    DCField(ap, @"createtime", @"createtime");
    DCField(ap, @"deleteflag", @"deleteflag");
}

@end
