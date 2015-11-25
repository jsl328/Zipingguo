//
//  DengluSM.m
//  Zipingguo
//
//  Created by fuyonghua on 15/9/14.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DengluSM.h"
@implementation DengluSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap ,@"data", @"data", [UserDataSM class]);
    DCListField(ap ,@"data1", @"data1", [DengluData1 class]);
    DCListField(ap ,@"data2", @"data2", [DengluData2 class]);

}

@end

@implementation UserDataSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"userinfos", @"userinfos", [UserinfosSM class]);
}

@end

@implementation DengluData1

- (void)provideAnnotations:(AnnotationProvider *)ap{
    
}

@end

@implementation DengluData2

- (void)provideAnnotations:(AnnotationProvider *)ap{
    
}

@end

@implementation UserinfosSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    
}

@end
