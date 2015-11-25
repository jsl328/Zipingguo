//
//  ZiXunLeiBieSM.m
//  Zipingguo
//
//  Created by sunny on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ZiXunLeiBieSM.h"

@implementation ZiXunLeiBieSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"titleID", @"id");
}
+ (ZiXunLeiBieSM *)getZiXunSMWithTitle:(NSString *)titleName{
    ZiXunLeiBieSM *sm = [[ZiXunLeiBieSM alloc] init];
    sm.title = titleName;
    if ([titleName isEqualToString:@"最新"]) {
        sm.titleID = ZiXun_zuiXinID;
    }else{
        sm.titleID = ZiXun_shouCangID;
    }
    return sm;
}
@end
