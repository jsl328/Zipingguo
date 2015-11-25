//
//  DLDrawerView.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-2.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHandleDirection.h"

#define DCDrawerViewDirectionNotSet 0
#define DCDrawerViewDirectionLeft 1
#define DCDrawerViewDirectionRight 2

enum DCDrawerLocation {
    DCDrawerLocationLeft = 0,
    DCDrawerLocationRight = 1,
    DCDrawerLocationLeftAndRight = 2
};
typedef enum DCDrawerLocation DCDrawerLocation;


@class DCDrawerView;


@protocol DCDrawerViewDelegate <NSObject>

@optional

-(void) drawerViewWillCollapse:(DCDrawerView*) drawerView;

-(void) drawerViewDidCollapse:(DCDrawerView*) drawerView;

-(void) drawerViewWillExpand:(DCDrawerView*) drawerView;

-(void) drawerViewDidExpand:(DCDrawerView*) drawerView;

@end


@interface DCDrawerProperties : NSObject {
    
    int _location;
    
    DCDrawerView* _drawerView;
    
    float _maskColorRed;
    float _mackColorGreen;
    float _mackColorBlue;
    float _maskColorAlpha;
}

@property (nonatomic) float width;
@property (retain, nonatomic) UIColor* maskColor;
@property (nonatomic) float handleWidth;
@property (nonatomic) float interleavePercent;
@property (nonatomic) float letLooseThreshold;
@property (nonatomic) float pixelsPerSecond;
@property (nonatomic) BOOL isDragEnabled;

-(id) initWithDrawerView:(DCDrawerView*) drawerView location:(int) location;

-(BOOL) isMaskColorVisible;

-(BOOL) isExpanded;

-(void) expand;
-(void) collapse;

-(UIColor*) maskColorAppliedWithPercent:(float) percent;

@end


@interface DCDrawerView : UIView <DCHandleDirection> {
    
    int _currentDirection;
    
    float _offset;
    
    BOOL _isLeftDrawerExpanded;
    BOOL _isRightDrawerExpanded;
    
    int _x;
    
    int _firstMoveDirection;
    
    
    DCDrawerProperties* _left;
    DCDrawerProperties* _right;
    
    float _currentOffset;
    
    BOOL _isDragging;
    
    UIView* _leftDrawer;
    UIView* _content;
    UIView* _rightDrawer;
    
    UIView* _leftDrawerMask;
    UIView* _rightDrawerMask;
}

@property (nonatomic) DCDrawerLocation drawerLocation;
@property (nonatomic) BOOL isFullSlidable;
@property (nonatomic) float drawnOutScale;
@property (assign, nonatomic) id <DCDrawerViewDelegate> delegate;

-(DCDrawerProperties*) left;
-(DCDrawerProperties*) right;

-(void) createMaskViewForDrawerAtLocaion:(int) location;

-(BOOL) isLeftDrawerExpanded;
-(BOOL) isRightDrawerExpanded;

-(void) expandLeftDrawer;
-(void) expandRightDrawer;

-(void) collapseDrawer;

@end
