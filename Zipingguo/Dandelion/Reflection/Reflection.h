//
//  Reflection.h
//  Dandelion
//
//  Created by Bob Li on 13-4-8.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassInfo.h"

@interface Reflection : NSObject

+(NSArray*) loadTypesThatConfirmToProtocol:(Protocol*) protocol;
+(NSArray*) loadTypesThatDeriveFromClass:(Class) class;

@end
