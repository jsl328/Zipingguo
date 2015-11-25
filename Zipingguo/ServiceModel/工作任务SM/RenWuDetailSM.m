//
//  RenWuDetailSM.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuDetailSM.h"

@implementation RenWuDetailSM
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data", [TaskDetailData class]);
}
@end

@implementation TaskDetailData
-(void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"task", @"task", [TaskSM class]);
    DCListField(ap, @"taskimgs", @"taskimgs", [TaskimgsSM class]);
    DCListField(ap, @"taskitems", @"taskitems", [TaskitemsSM class]);
    DCListField(ap, @"taskcomments", @"taskcomments", [TaskcommentsSM class]);
    DCListField(ap, @"leaders", @"leaders", [LeadersSM class]);
    DCListField(ap, @"participants", @"participants", [ParticipantsSM class]);
}

@end

@implementation ParticipantsSM
-(void)provideAnnotations:(AnnotationProvider *)ap{
    
}
@end

@implementation LeadersSM
-(void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"leaderID", @"id");
}
@end

@implementation TaskSM
-(void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"taskID", @"id");
}
@end

@implementation TaskcommentsSM
-(void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"commentsID", @"id");
}
@end

@implementation TaskitemsSM
-(void)provideAnnotations:(AnnotationProvider *)ap{
    
}
@end

@implementation TaskimgsSM
-(void)provideAnnotations:(AnnotationProvider *)ap{
    
}
@end
