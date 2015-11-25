//
//  DailyUsersSM.m
//  Lvpingguo
//
//  Created by linku on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "DailyUsersSM.h"

@implementation DailyUsersSM
@synthesize userid;
@synthesize username;
@synthesize type;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"userid", @"userid");
    DCField(ap, @"username", @"username");
    DCField(ap, @"type", @"type");
}
@end
