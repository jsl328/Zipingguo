//
//  ZiXunTiJiaoPingPunSM.m
//  Zipingguo
//
//  Created by sunny on 15/11/5.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunTiJiaoPingPunSM.h"

@implementation ZiXunTiJiaoPingPunSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [ZiXunSingleCommentSM class]);
}
@end


//@implementation ZiXunTiJiaoPingPunReturnSM
//
//- (void)provideAnnotations:(AnnotationProvider *)ap{
//    DCField(ap, @"commentID", @"id");
//    DCField(ap, @"ziXunID", @"infoid");
//
//}
//
//@end