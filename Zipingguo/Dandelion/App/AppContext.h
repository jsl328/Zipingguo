//
//  AppContext.h
//  Dandelion
//
//  Created by Bob Li on 13-8-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileStorageResolver.h"
#import "ControllerViewManager.h"
#import "DCWindow.h"
#import "DCAppSettings.h"

@interface AppContext : NSObject

+(FileStorageResolver*) storageResolver;

+(DCWindow*) window;

+(DCAppSettings*) settings;

+(void) createNavigationControllerWithInterfaceDirection:(NSString*) direction;
+(void) createTabBarControllerWithInterfaceDirection:(NSString*) direction controllers:(NSArray*) controllers images:(NSArray*) images;
+(void) initWithAppDelegate:(UIResponder <UIApplicationDelegate>*) delegate;

+(UIViewController*) rootController;
+(UIViewController*) controller;
+(UIViewController*) previousController;

+(void) pushController:(UIViewController*) controller;
+(void) pushController:(UIViewController*) controller Animated:(BOOL)animated;
+(void) push:(Class) controllerClass;
+(void) push:(Class) controllerClass passParametersCallback:(void (^)(UIViewController*)) callback;
+(void) pop;

+(void) removeAllDownloads;
+(void) removeDownloadsForUrls:(NSArray*) urls;

@end
