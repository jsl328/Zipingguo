
//
//  ResultMode.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-21.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultMode.h"

@implementation groupInfo

@synthesize result;
@synthesize infogroups;

-(void)provideAnnotations:(AnnotationProvider *)ap{
    
	DCField(ap, @"result", @"result");
	DCField(ap, @"infogroups", @"infogroups");
}

@end

@implementation huanXinToken

@synthesize token;

-(void)provideAnnotations:(AnnotationProvider *)ap
{
	DCField(ap, @"token", @"token");
}

@end


@implementation ResultMode


- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"status", @"status");
    DCField(ap, @"msg", @"msg");
    DCListField(ap, @"data", @"data", [MemoContentSM class]);
    DCListField(ap, @"data1", @"data", [ResultData class]);
    DCListField(ap, @"delData1", @"data1", [AllDynamicSM class]);
    DCListField(ap, @"commentData", @"data", [AllDynamicSM class]);
}
@end

@implementation ResultData

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"ID", @"id");
    
}
@end

