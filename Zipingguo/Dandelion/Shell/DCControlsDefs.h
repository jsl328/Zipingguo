//
//  DCControlsDefs.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-21.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

enum DCMeasureSpecMode {
    DCMeasureSpecAtMost = 0,
    DCMeasureSpecExactly = 1,
    DCMeasureSpecUnspecified = 2
};
typedef enum DCMeasureSpecMode DCMeasureSpecMode;

enum DCOrientation {
    DCOrientationHorizontal = 0,
    DCOrientationVertical = 1
};
typedef enum DCOrientation DCOrientation;

enum DCLayoutDimension {
    DCLayoutWrapContent = -1,
    DCLayoutMatchParent = -2
};
typedef enum DCLayoutDimension DCLayoutDimension;

enum DCHorizontalGravity {
    DCHorizontalGravityLeft = 0,
    DCHorizontalGravityCenter = 1,
    DCHorizontalGravityRight = 2,
    DCHorizontalGravityStretch = 3
};
typedef enum DCHorizontalGravity DCHorizontalGravity;

enum DCVerticalGravity {
    DCVerticalGravityTop = 0,
    DCVerticalGravityCenter = 1,
    DCVerticalGravityBottom = 2
};
typedef enum DCVerticalGravity DCVerticalGravity;

enum DCDockDirection {
    DCDockDirectionNone = 0,
    DCDockDirectionCenter = 1,
    DCDockDirectionLeft = 2,
    DCDockDirectionTop = 3,
    DCDockDirectionRight = 4,
    DCDockDirectionBottom = 5
};
typedef enum DCDockDirection DCDockDirection;

enum DCImageBoxStyle {
    DCImageBoxStyleImageAboveText,
    DCImageBoxStyleImageLeftOfText,
    DCImageBoxStyleImageBelowText,
    DCImageBoxStyleImageRightOfText
};
typedef enum DCImageBoxStyle DCImageBoxStyle;

enum DCImageBoxSelectionMode {
    DCImageBoxSelectionModeNone,
    DCImageBoxSelectionModeSelect,
    DCImageBoxSelectionModeSelectDeselect
};
typedef enum DCImageBoxSelectionMode DCImageBoxSelectionMode;

enum DCAnimationType {
    DCAnimationTypeNone = 0,
    DCAnimationTypeMoveUp = 1,
    DCAnimationTypeMoveDown = 2,
    DCAnimationTypeMoveLeft = 4,
    DCAnimationTypeMoveRight = 8,
    DCAnimationTypeFadeIn = 16,
    DCAnimationTypeFadeOut = 32
};
typedef enum DCAnimationType DCAnimationType;

struct DCMeasureSpec {
    DCMeasureSpecMode mode;
    float size;
};
typedef struct DCMeasureSpec DCMeasureSpec;
