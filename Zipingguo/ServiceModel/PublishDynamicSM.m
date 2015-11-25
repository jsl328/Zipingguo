//
//  PublishDynamicSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-24.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "PublishDynamicSM.h"

@implementation PublishDynamicSM

@synthesize spendtimes;
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"content", @"content");
    DCField(ap, @"address", @"address");
    DCField(ap, @"createid", @"createid");
    DCField(ap, @"imgstrs", @"imgstrs");
    DCField(ap, @"atusers", @"atusers");
    DCField(ap, @"sounds", @"sounds");
    DCField(ap, @"spendtimes", @"spendtimes");
    DCField(ap, @"positionx", @"positionx");
    DCField(ap, @"positiony", @"positiony");
    DCField(ap, @"companyid", @"companyid");
    
}
@end
