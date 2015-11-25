//
//  ResultModelOfGetOptionSM.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-9-20.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ResultModelOfGetOptionSM.h"
@implementation ResultModelOfGetOptionSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [OptionSM class]);
}
@end

@implementation OptionSM
- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCField(ap, @"_id", @"id");

}
@end
