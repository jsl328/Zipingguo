//
//  ZhoubiaoData.m
//  Lvpingguo
//
//  Created by miao on 14-10-10.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "BaoGaoData.h"

@implementation BaoGaoData
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"workpaper", @"workpaper", [WorkPaper class]);
    DCListField(ap, @"createuser", @"createuser", [CreateuserSM class]);
    DCListField(ap, @"approverusers", @"approverusers", [Zhoubaoapproverusers class]);
    DCListField(ap, @"ccusers", @"ccusers", [Zhoubaoccusers class]);
    DCListField(ap, @"workpaperComments", @"workpaperComments", [DailyCommentsSM class]);
//    DCListField(ap, @"workpapers", @"workpapers", [RirenmingdailyPapers class]);
    DCListField(ap, @"workpaperAnnexs", @"workpaperAnnexs", [NoticeAnnexsSM class]);
    
}
@end
