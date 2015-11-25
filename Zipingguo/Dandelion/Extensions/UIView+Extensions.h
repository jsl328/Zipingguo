//
//  UIView+Extensions.h
//  Dandelion
//
//  Created by Bob Li on 13-4-19.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extensions)

-(void) removeAllSubviews;

-(void) forSubviewsOfClass:(Class) viewClass visit:(void (^)(id)) callback;

-(void) forDescendentViewsOfClass:(Class) viewClass visit:(void (^)(id)) callback;

-(id) viewThatListensProtocol:(Protocol*) protocol;

@end
