//
//  DCPageScrollView.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-4.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCPageScrollViewDelegate.h"
#import "DCHandleDirection.h"

@interface DCPageScrollView : UIView <DCHandleDirection> {

    int _x;
    
    int _offset;
    
    int _slideDirection;
    
    
    UIView* _viewsContainer;
    
    UIPageControl* _pageControl;
    
    
    int _pageIndexToLeft;
    int _pageIndexToRight;
    
    UIView* _separatorLine1;
    UIView* _separatorLine2;
    
    NSMutableArray* _pages;
    
    UIView* _leftView;
    UIView* _centerView;
    UIView* _rightView;
}

@property (nonatomic) int pageIndex;
@property (nonatomic) BOOL showDots;
@property (retain, nonatomic) id <DCPageScrollViewDelegate> delegate;
@property (nonatomic) BOOL showSeparatorLineWhileSliding;

-(void) addPage:(UIView*) page;

-(void) clearPages;

-(void) initialize;

@end
