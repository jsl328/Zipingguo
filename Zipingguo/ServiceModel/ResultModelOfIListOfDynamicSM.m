//
//  ResultModelOfIListOfDynamicSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-1.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfIListOfDynamicSM.h"

@implementation ResultModelOfIListOfDynamicSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [AllDynamicSM class]);
    
    DCListField(ap, @"dynamicSM", @"data", [AllDynamicSM class]);
    
    DCListField(ap, @"delData1", @"data1", [AllDynamicSM class]);
    
}

@end

@implementation AllDynamicSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"dynamic", @"dynamic", [DynamicSM class]);
    DCListField(ap, @"dypraises", @"dypraises", [DypraisesSM class]);
    DCListField(ap, @"dycomments", @"dycomments", [DycommentsSM class]);
    DCListField(ap, @"dyimgs", @"dyimgs", [DyimgsSM class]);
    DCListField(ap, @"dyaboutusrs", @"dyaboutusrs", [DyaboutusrsSM class]);
    DCListField(ap, @"dysounds", @"dysounds", [DysoundsSM class]);
    
}
@end

@implementation DynamicSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    
}
@end

@implementation DypraisesSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    
}
@end

@implementation DycommentsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    
}
@end

@implementation DyimgsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    
}
@end

@implementation DyaboutusrsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    
}
@end

@implementation DysoundsSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");
    
}
@end
