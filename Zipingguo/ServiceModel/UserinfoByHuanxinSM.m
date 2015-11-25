//
//  UserinfoByHuanxinSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "UserinfoByHuanxinSM.h"

@implementation UserinfoByHuanxinSM
@synthesize _id;
@synthesize name;
@synthesize phone;
@synthesize imgurl;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"userid");
    DCField(ap, @"name", @"name");
    DCField(ap, @"phone", @"phone");
    DCField(ap, @"imgurl", @"imgurl");
}
@end
