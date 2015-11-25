//
//  AppContext.m
//  Dandelion
//
//  Created by Bob Li on 13-8-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "AppContext.h"
#import "DefaultStorageResolver.h"
#import "DCControllerContext.h"
#import "DCWindow.h"
#import "DCImageCache.h"

static DCControllerContext* _controllerContext;

static FileStorageResolver* _storageResolver;

static DCAppSettings* _settings;


@implementation AppContext

+(void) initialize {
    _controllerContext = [[DCControllerContext alloc] init];
    _storageResolver = [[DefaultStorageResolver alloc] init];
    _settings = [DCAppSettings defaultSettings];
}

+(FileStorageResolver*) storageResolver {
    return _storageResolver;
}


+(void) createNavigationControllerWithInterfaceDirection:(NSString*) direction {
    [_controllerContext createNavigationControllerWithInterfaceDirection:direction];
}

+(void) createTabBarControllerWithInterfaceDirection:(NSString*) direction controllers:(NSArray*) controllers images:(NSArray*) images {
    [_controllerContext createTabBarControllerWithInterfaceDirection:direction controllers:controllers images:(NSArray*) images];
}

+(void) initWithAppDelegate:(UIResponder <UIApplicationDelegate>*) delegate {
    [_controllerContext initWithAppDelegate:delegate];
}

+(DCWindow*) window {
    return _controllerContext.window;
}

+(DCAppSettings*) settings {
    return _settings;
}

+(UIViewController*) rootController {
    return _controllerContext.rootController;
}

+(UIViewController*) controller {
    return [_controllerContext controller];
}

+(UIViewController*) previousController {
    return [_controllerContext previousController];
}

+(void) pushController:(UIViewController*) controller {
    [_controllerContext pushController:controller];
}

+(void) pushController:(UIViewController*) controller Animated:(BOOL)animated
{
    [_controllerContext pushController:controller Animated:animated];
}

+(void) push:(Class) controllerClass {
    [_controllerContext push:controllerClass willShow:nil];
}

+(void) push:(Class) controllerClass passParametersCallback:(void (^)(UIViewController*)) callback {
    [_controllerContext push:controllerClass willShow:callback];
}

+(void) pop {
    [_controllerContext pop];
}


+(void) removeAllDownloads {
    [[DCImageCache defaultCache] removeAllItems];
    [_storageResolver removeAllDownloads];
}

+(void) removeDownloadsForUrls:(NSArray*) urls {
    [[DCImageCache defaultCache] removeItemsForFiles:[urls map:^id(NSString* item) {
        return [[AppContext storageResolver] pathForDownloadedFileFromUrl:item fileName:nil];
    }]];
    [_storageResolver removeDownloadsForUrls:urls];
}

@end
