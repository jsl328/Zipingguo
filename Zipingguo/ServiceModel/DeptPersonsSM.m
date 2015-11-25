//
//  DeptPersonsSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-3.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "DeptPersonsSM.h"
@implementation DeptPersonsSM


-(void) provideAnnotations:(AnnotationProvider*) ap {
//    DCField(ap, @"userid", @"id");
    DCField(ap, @"userid", @"userid");
    DCListField(ap, @"userinfos", @"userinfos", [UserinfosSM class]);
}
@end
