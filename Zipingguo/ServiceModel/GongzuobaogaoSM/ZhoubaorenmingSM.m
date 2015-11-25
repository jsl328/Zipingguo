//
//  ZhoubaorenmingSM.m
//  Lvpingguo
//
//  Created by miao on 14-9-22.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "ZhoubaorenmingSM.h"

@implementation ZhoubaorenmingSM
-(void)provideAnnotations:(AnnotationProvider *)ap
{
    
    DCListField(ap, @"data", @"data", [ZhoubiaorenmingData class]);
   
}
@end
