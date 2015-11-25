//
//  DCControllerContext.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-10.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCControllerContext.h"
#import "DCNavigationController.h"
#import "DCTabBarController.h"
#import "DCClearUnfinishedDownloadsTask.h"
#import "DCTaskPool.h"
#import "DCWindow.h"

@implementation DCControllerContext
@synthesize rootController;
@synthesize window;

-(void) createNavigationControllerWithInterfaceDirection:(NSString*) direction {

    DCNavigationController* navigationController = [[DCNavigationController alloc] init];
    navigationController.orientationMask = [self orientationMaskFromString:direction];
    rootController = navigationController;
}

-(void) createTabBarControllerWithInterfaceDirection:(NSString*) direction controllers:(NSArray*) controllers images:(NSArray *)images {

    DCTabBarController* tabBarController = [[DCTabBarController alloc] init];
    tabBarController.orientationMask = [self orientationMaskFromString:direction];
    
    
    for (UIViewController* controller in controllers) {
        [tabBarController addChildViewController:controller];
    }
    
    tabBarController.selectedIndex = 0;

    
    for (int i = 0; i <= tabBarController.tabBar.items.count - 1; i++) {
        UITabBarItem* item = (UITabBarItem*)[tabBarController.tabBar.items objectAtIndex:i];
        item.image = [images objectAtIndex:i];
    }
    
    rootController = tabBarController;
}

-(int) orientationMaskFromString:(NSString*) direction {
    
    int mask = 0;
    
    NSArray* homeButtonPositions = [[direction componentsSeparatedByString:@","] map:^id(NSString* item) {
        return [item characterAtIndex:0] == '+' ? [item substringFromIndex:1] : item;
    }];
    
    if ([homeButtonPositions containsObject:@"bottom"]) {
        mask |= UIInterfaceOrientationMaskPortrait;
    }
    
    if ([homeButtonPositions containsObject:@"top"]) {
        mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
    }
    
    if ([homeButtonPositions containsObject:@"left"]) {
        mask |= UIInterfaceOrientationMaskLandscapeLeft;
    }
    
    if ([homeButtonPositions containsObject:@"right"]) {
        mask |= UIInterfaceOrientationMaskLandscapeRight;
    }
    
    return mask;
}


-(void) initWithAppDelegate:(UIResponder <UIApplicationDelegate>*) delegate {
    
    self.window = [[DCWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    delegate.window = self.window;
    
    window.rootViewController = rootController;
    [window makeKeyAndVisible];
    
    [[DCTaskPool obtainConcurrent] addTask:[[DCClearUnfinishedDownloadsTask alloc] init]];
}

-(void) pushController:(UIViewController*) controller {
    [[self navigationController] pushViewController:controller animated:YES];
}

-(void) pushController:(UIViewController*) controller Animated:(BOOL)animated
{
    [[self navigationController] pushViewController:controller animated:animated];
}

-(void) push:(Class) controllerClass willShow:(void (^)(UIViewController*)) callback {
    
    UIViewController* controller = [[controllerClass alloc] initWithNibName:[controllerClass description] bundle:[NSBundle mainBundle]];
    
    if ([controller respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        controller.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    if (callback) {
        callback(controller);
    }
    
    [[self navigationController] pushViewController:controller animated:YES];
}

-(void) pop {
    [[self navigationController] popViewControllerAnimated:YES];
}

-(UINavigationController*) navigationController {
    
    UIViewController* current = rootController;
    
    while (true) {
        
        if ([[current class] isSubclassOfClass:[UINavigationController class]]) {
            return (UINavigationController*)current;
        }
        else if ([[current class] isSubclassOfClass:[UITabBarController class]]) {
            current = ((UITabBarController*)current).selectedViewController;
        }
        else if ([[current class] isSubclassOfClass:[UIViewController class]]) {
            return nil;
        }
    }
    
    return nil;
}

-(UIViewController*) controller {
    
    UIViewController* current = rootController;
    
    while (true) {
        
        if ([[current class] isSubclassOfClass:[UINavigationController class]]) {
            current = ((UINavigationController*)current).topViewController;
        }
        else if ([[current class] isSubclassOfClass:[UITabBarController class]]) {
            current = ((UITabBarController*)current).selectedViewController;
        }
        else if ([[current class] isSubclassOfClass:[UIViewController class]]) {
            return current;
        }
    }
    
    return nil;
}

-(UIViewController*) previousController {

    UINavigationController* navigationController = [self navigationController];
    if (navigationController && navigationController.viewControllers.count > 1) {
        return [navigationController.viewControllers objectAtIndex:navigationController.viewControllers.count - 2];
    }
    else {
        return nil;
    }
}

@end
