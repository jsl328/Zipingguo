//
//  ZiXunPingLunResultSM.m
//  Zipingguo
//
//  Created by sunny on 15/11/17.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunPingLunResultSM.h"

@implementation ZiXunPingLunResultSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [ZiXunCommentSM class]);
}
@end

@implementation ZiXunCommentSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"commentID", @"id");
    DCField(ap, @"ziXunID", @"infoid");
     DCListField(ap, @"childComments", @"childComments", [ZiXunSingleCommentSM class]);
}

@end

@implementation ZiXunSingleCommentSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"commentID", @"id");
    DCField(ap, @"ziXunID", @"infoid");
}

@end