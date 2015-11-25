//
//  MapsTiaoXiuRSM.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-10-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "MapsTiaoXiuRSM.h"

@implementation MapsTiaoXiuRSM
@synthesize createid,createname,flowid,flowname,companyid,dealid,ccs,maps;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"createid", @"createid");
    DCField(ap, @"createname", @"createname");
    DCField(ap, @"flowid", @"flowid");
    DCField(ap, @"flowname", @"flowname");
    DCField(ap, @"companyid", @"companyid");
    DCField(ap, @"dealid", @"dealid");
    DCField(ap, @"ccs", @"ccs");
    DCListField(ap, @"maps", @"maps", [MapsTiaoxiuSM class]);
}
@end
