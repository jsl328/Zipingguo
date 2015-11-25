//
//  IAnnotatable.h
//  Nanumanga
//
//  Created by Bob Li on 13-8-29.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnnotationProvider.h"

@protocol IAnnotatable <NSObject>

-(void) provideAnnotations: (AnnotationProvider*) ap;

@end
