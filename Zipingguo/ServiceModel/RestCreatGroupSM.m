//
//  RestCreatGroupSM.m
//  Lvpingguo
//
//  Created by jiangshilin on 15-1-22.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RestCreatGroupSM.h"

@implementation GroupID
@synthesize groupid;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
	DCField(ap, @"groupid", @"groupid");
}

@end

@implementation RestCreatGroupSM
@synthesize data;
-(void)provideAnnotations:(AnnotationProvider *)ap
{
	//DCField(ap, @"data", @"data");
	DCListField(ap, @"data", @"data",[GroupID class]);
}

@end
