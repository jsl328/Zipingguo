//
//  RegCorpCheckCodeSM.m
//  Zipingguo
//
//  Created by fuyonghua on 15/11/3.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RegCorpCheckCodeSM.h"

@implementation RegCorpCheckCodeSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    DCListField(ap, @"data", @"data", [RegCorpCheckCodeDataSM class]);
}

@end

@implementation RegCorpCheckCodeDataSM

- (void)provideAnnotations:(AnnotationProvider *)ap{
    
}

@end