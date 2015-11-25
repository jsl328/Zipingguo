//
//  MemoContentSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-13.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "MemoContentSM.h"

@implementation groupID

@synthesize groupid;

-(void)provideAnnotations:(AnnotationProvider *)ap{
	DCField(ap, @"groupid", @"groupid");
}

@end

@implementation MemoContentSM
@synthesize _id;
@synthesize userid;
@synthesize content;
@synthesize createtime,flowname;

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    DCField(ap, @"userid", @"userid");
    DCField(ap, @"content", @"content");
    DCField(ap, @"createtime", @"createtime");
    DCField(ap, @"flowname", @"flowname");

	DCListField(ap, @"data", @"data", [groupID class]);
}
@end
