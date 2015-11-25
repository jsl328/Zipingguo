//
//  Binder.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "BindingContext.h"

static NSMapTable* _viewModelToViewMapping;
static NSMapTable* _viewToViewModelMapping;

@implementation BindingContext

+(void) load {
    _viewModelToViewMapping = [NSMapTable weakToWeakObjectsMapTable];
    _viewToViewModelMapping = [NSMapTable weakToWeakObjectsMapTable];
}

+(void) putViewModel:(id) viewModel andView:(UIView*) view {
    [_viewModelToViewMapping setObject:view forKey:viewModel];
    [_viewToViewModelMapping setObject:viewModel forKey:view];
}

+(UIView*) viewForViewModel:(id) viewModel {
    return [_viewModelToViewMapping objectForKey:viewModel];
}

+(id) viewModelForView:(UIView*) view {
    return [_viewToViewModelMapping objectForKey:view];
}

@end
