//
//  DCTextView.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-18.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTickTimer.h"

@interface DCTextView : UIView <DCTickTimerDelegate> {
    
    DCTickTimer* _timer;
    
    BOOL _isPlaceholderShown;
    
    UITextView* _textView;

    UIView* _container;
    
    UIView* _placeholderView;
}

@property (retain, nonatomic) id placeholder;
@property (retain, nonatomic) UIColor* placeholderBackgroundColor;
@property (retain, nonatomic) UIColor* placeholderTextColor;
@property (nonatomic) NSTextAlignment placeholderTextAlignment;
@property (nonatomic) DCVerticalGravity placeholderTextGravity;
@property (nonatomic) UIEdgeInsets placeholderPadding;
@property (nonatomic) NSTimeInterval placeholderFadeinDuration;
@property (nonatomic) NSTimeInterval placeholderFadeoutDuration;

@property (retain, nonatomic) NSString* text;
@property (retain, nonatomic) UIColor* textColor;
@property (nonatomic) NSTextAlignment textAlignment;

@end
