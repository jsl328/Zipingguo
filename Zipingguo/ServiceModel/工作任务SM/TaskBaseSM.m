//
//  TaskBaseSM.m
//  Zipingguo
//
//  Created by 韩飞 on 15/10/23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "TaskBaseSM.h"

@implementation TaskBaseSM
-(void)provideAnnotations:(AnnotationProvider *)ap{
    
    DCListField(ap, @"data", @"data", [TaskBaseDataSM class]);
    
}
@end

@implementation TaskBaseDataSM
-(void)provideAnnotations:(AnnotationProvider *)ap{
    
    DCField(ap, @"_id", @"id");
    
    DCListField(ap, @"leaders", @"leaders", [NSString class]);
    
}
@end