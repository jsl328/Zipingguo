//
//  DCListBoxSection.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-27.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCListBoxSection : NSObject

@property (nonatomic) BOOL isItemsHidden;
@property (nonatomic) float top;
@property (nonatomic) float headerHeight;
@property (nonatomic) float footerHeight;
@property (nonatomic) float contentHeight;
@property (nonatomic) float totalHeight;

@end
