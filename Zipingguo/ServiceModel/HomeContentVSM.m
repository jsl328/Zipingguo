//
//  HomeContentVSM.m
//  Zipingguo
//
//  Created by fuyonghua on 15/11/1.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "HomeContentVSM.h"

@implementation HomeContentVSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [HomeContentVDataSM class]);
}

@end

@implementation HomeContentVDataSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"module", @"modulecode");
}

@end