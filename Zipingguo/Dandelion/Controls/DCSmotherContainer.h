//
//  DCJumpList.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-21.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHandleDirection.h"

@class DCSmotherContainer;

@protocol DCSmotherContainerDelegate <NSObject>

-(void) smotherContainer:(DCSmotherContainer*) smotherContainer didEnterView:(UIView*) view;

-(void) smotherContainer:(DCSmotherContainer*) smotherContainer didLeaveView:(UIView*) view;

@end


@protocol DCSmotherCellView <NSObject>

@optional

-(void) didSmotherEnter;

-(void) didSmotherLeave;

-(BOOL) isSmotherable;

@end



enum DCHighlightBarAnimationMode {
    DCHighlightBarAnimationModeNone = 0,
    DCHighlightBarAnimationModeWhenTouching = 1,
    DCHighlightBarAnimationModeWhenSmothering = 2
};
typedef enum DCHighlightBarAnimationMode DCHighlightBarAnimationMode;


@interface DCSmotherContainer : UIView

@property (retain, nonatomic) UIView* highlightBarView;
@property (nonatomic) DCHighlightBarAnimationMode animationMode;
@property (assign, nonatomic) id <DCSmotherContainerDelegate> delegate;

@end
