//
//  DCISelectableView.h
//  Nanumanga
//
//  Created by Bob Li on 13-10-18.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCISelectableView <NSObject>

@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isSelectable;

@end
