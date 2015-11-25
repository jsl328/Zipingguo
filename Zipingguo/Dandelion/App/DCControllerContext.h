//
//  DCControllerContext.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-10.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCControllerContext : NSObject

@property (retain, nonatomic) UIViewController* rootController;
@property (retain, nonatomic) DCWindow* window;

-(void) createNavigationControllerWithInterfaceDirection:(NSString*) direction;

-(void) createTabBarControllerWithInterfaceDirection:(NSString*) direction controllers:(NSArray*) controllers images:(NSArray*) images;

-(void) initWithAppDelegate:(UIResponder <UIApplicationDelegate>*) delegate;

-(UIViewController*) controller;

-(UIViewController*) previousController;

-(void) pushController:(UIViewController*) controller;

-(void) pushController:(UIViewController*) controller Animated:(BOOL)animated;

-(void) push:(Class) controllerClass willShow:(void (^)(UIViewController*)) callback;

-(void) pop;

@end
