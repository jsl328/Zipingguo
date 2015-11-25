//
//  RIliResultModelSM.m
//  Zipingguo
//
//  Created by miao on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RIliResultModelSM.h"

@implementation RIliResultModelSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    
    DCListField(ap, @"data", @"data", [rililistSM class]);
}

@end

@implementation rililistSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"time", @"time");
    DCListField(ap, @"memos", @"memos", [memosSM class]);
    DCListField(ap, @"tasks", @"tasks", [tasksSM class]);

}

@end
@implementation tasksSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
      DCField(ap, @"ID", @"id");
}

@end
@implementation memosSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
       DCField(ap, @"ID", @"id");
    
}


@end