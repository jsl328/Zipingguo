//
//  TijiaogeiworibaoliebiaoSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "TijiaogeiworibaoliebiaoSM.h"

@implementation TijiaogeiworibaoliebiaoSM

@synthesize data;


-(void)provideAnnotations:(AnnotationProvider *)ap
{
    DCListField(ap, @"data", @"data", [TjiaowoData class]);

}

@end
