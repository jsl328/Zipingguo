//
//  Reflection.m
//  Dandelion
//
//  Created by Bob Li on 13-4-8.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "Reflection.h"
#import <objc/runtime.h>
#import <dlfcn.h>
#import <mach-o/ldsyms.h>
#import "PropertyInfo.h"

@implementation Reflection

+(NSArray*) loadTypesThatConfirmToProtocol:(Protocol*) protocol {
    return [self loadTypes:^(Class c) {
        return [c conformsToProtocol:protocol];
    }];
}

+(NSArray*) loadTypesThatDeriveFromClass:(Class) class {
    return [self loadTypes:^(Class c) {
        return (BOOL)([c isSubclassOfClass:class] && ![[c description] isEqualToString:[class description]]);
    }];
}

+(NSArray*) loadTypes:(BOOL (^)(Class)) condition {
    
    NSMutableArray* entityTypes = [[NSMutableArray alloc] init];
    
    unsigned int count;
    const char **classes;
    Dl_info info;
    
    dladdr(&_mh_execute_header, &info);
    classes = objc_copyClassNamesForImage(info.dli_fname, &count);
    
    for (int i = 0; i < count; i++) {
        const char* className = classes[i];
        if (className[0] == 'U' && className[1] == 'I') {
            continue;
        }
        Class class = NSClassFromString ([NSString stringWithCString:classes[i] encoding:NSUTF8StringEncoding]);
        
        if (condition(class)) {
            [entityTypes addObject:class];
        }
    }
    
    return entityTypes;
}

@end
