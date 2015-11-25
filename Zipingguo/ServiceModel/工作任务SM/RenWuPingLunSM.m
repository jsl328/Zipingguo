//
//  RenWuPingLunSM.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/26.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RenWuPingLunSM.h"

@implementation RenWuPingLunSM
-(void)provideAnnotations:(AnnotationProvider *)ap{
//    DCField(ap, @"data", @"data");
    DCListField(ap, @"data", @"data", [RenWuPingLunData class]);
}
@end


@implementation RenWuPingLunData
-(void)provideAnnotations:(AnnotationProvider *)ap{
    
}
@end
