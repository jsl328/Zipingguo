//
//  ViewLocater.m
//  Dandelion
//
//  Created by Bob Li on 13-8-28.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "ViewLocater.h"

static NSMutableDictionary* _mappings;
static NSArray* _viewModelSuffixList;

@implementation ViewLocater

+(void) load {
    _mappings = [[NSMutableDictionary alloc] init];
    _viewModelSuffixList = @[@"VM", @"ViewModel"];
}

+(Class) viewClassForViewModel:(id) viewModel viewSuffix:(NSString *)viewSuffix {

    
    NSString* viewModelClass = [[viewModel class] description];
    
    Class viewClass = [_mappings objectForKey:viewModelClass];

    if (viewClass) {
        return viewClass;
    }
    
    
    if ([viewModel respondsToSelector:@selector(viewType)]) {
        [_mappings setObject:[viewModel performSelector:@selector(viewType)] forKey:viewModelClass];
    }
    else {
        
        NSString* viewModelName = [ViewLocater viewModelNameByStrippingSuffix:viewModelClass];
        
        
        NSString* viewClassName = nil;
        
        if ([[viewModelName substringFromIndex:viewModelName.length - viewSuffix.length] isEqualToString:viewSuffix]) {
            viewClassName = viewModelName;
        }
        else {
            viewClassName = [NSString stringWithFormat:@"%@%@", viewModelName, viewSuffix];
        }
                                   
        if (NSClassFromString(viewClassName)) {
            [_mappings setObject:NSClassFromString(viewClassName) forKey:viewModelClass];
        }
        else {
            [_mappings setObject:[UILabel class] forKey:viewModelClass];
        }
    }
    
    return [_mappings objectForKey:viewModelClass];
}

+(NSString*) viewModelNameByStrippingSuffix: (NSString*) viewModelName {

    for (NSString* suffix in _viewModelSuffixList) {
        if (viewModelName.length > suffix.length) {
            NSString* strippedName = [viewModelName substringFromIndex:viewModelName.length - suffix.length];
            if ([strippedName isEqualToString:suffix]) {
                return [viewModelName substringToIndex:viewModelName.length - suffix.length];
            }
        }
    }
    
    return viewModelName;
}

+(Class) viewClassForViewModel:(id) viewModel {
    return [ViewLocater viewClassForViewModel:viewModel viewSuffix:@"View"];
}

@end
