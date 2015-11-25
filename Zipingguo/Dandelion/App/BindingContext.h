//
//  Binder.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindingContext : NSObject

+(void) putViewModel:(id) viewModel andView:(UIView*) view;

+(UIView*) viewForViewModel:(id) viewModel;

+(id) viewModelForView:(UIView*) view;

@end
