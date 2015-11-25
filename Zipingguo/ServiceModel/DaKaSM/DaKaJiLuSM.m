//
//  DaKaJiLuSM.m
//  Zipingguo
//
//  Created by sunny on 15/11/3.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DaKaJiLuSM.h"

@implementation DaKaJiLuSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [SingleDayListSM class]);
}
@end


@implementation SingleDayListSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
     DCListField(ap, @"list", @"list", [SingleDaySM class]);
}

@end

@implementation SingleDaySM

- (void)provideAnnotations:(AnnotationProvider *)ap{
     DCListField(ap, @"sounds", @"sounds", [DaKaImageSoundSM class]);
     DCListField(ap, @"imgs", @"imgs", [DaKaImageSoundSM class]);
}

@end

@implementation DaKaImageSoundSM

- (void)provideAnnotations:(AnnotationProvider *)ap{

}

@end