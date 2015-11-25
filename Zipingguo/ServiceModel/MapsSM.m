//
//  MapsSM.m
//  Lvpingguo
//
//  Created by jiangshilin on 14-9-25.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "MapsSM.h"
#import "IAnnotatable.h"
@implementation MapsSM


-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCField(ap, @"chname", @"chname");
    DCField(ap, @"sort", @"sort");
    DCField(ap, @"type", @"type");
    DCField(ap, @"content", @"content");
    
}

@end
