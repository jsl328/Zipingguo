//
//  ControllerViewManager.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-2.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

/*
#import "ControllerViewManager.h"
#import "AppContext.h"

@implementation ControllerViewManager

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

-(UIScrollView*) wrapScrollViewForView: (UIView*) view {
    
    [view removeFromSuperview];
    
    UIScrollView* scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:view];
    return scrollView;
}

-(void) recognizeTap: (UITapGestureRecognizer*) recognizer {
    UIScrollView* scrollView = (UIScrollView*)[AppContext navigationConductor].currentController.view;
    [[scrollView.subviews objectAtIndex:0] endEditing:YES];
}

-(void) revealFirstResponder {

    UIScrollView* scrollView = (UIScrollView*)[AppContext navigationConductor].currentController.view;
    UIView* contentView = [scrollView.subviews objectAtIndex:0];    
    
    UIView* firstResponder = [self firstResponder:contentView];
    if (firstResponder) {
        int targetOffset = firstResponder.frame.origin.y + firstResponder.frame.size.height + 10 - scrollView.frame.size.height;
        if (scrollView.contentOffset.y < targetOffset) {
            scrollView.contentOffset = CGPointMake(0, targetOffset);
        }
    }
}

-(UIView*) firstResponder: (UIView*) view {
    
    if (view.isFirstResponder) {
        return view;
    }
    
    for (UIView *subView in view.subviews) {
        UIView *firstResponder = [self firstResponder:subView];
        
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    
    return nil;
}


-(void) keyboardDidShow:(NSNotification*)notification {

    UIScrollView* scrollView = (UIScrollView*)[AppContext navigationConductor].currentController.view;
    _screenHeight = scrollView.frame.size.height;
    
    CGSize keyboardSize = [self keyboardSizeFromNotification:notification];
    [self setScrollViewHeight:_screenHeight - keyboardSize.height];

    
    
    UIView* contentView = [scrollView.subviews objectAtIndex:0];
    
    _recognizer = [[UITapGestureRecognizer alloc] init];
    [_recognizer addTarget:self action:@selector(recognizeTap:)];
    [contentView addGestureRecognizer:_recognizer];

    [self revealFirstResponder];
}

-(void) keyboardDidHide:(NSNotification*)notification {
    
    [self setScrollViewHeight:_screenHeight];
    
    
    UIScrollView* scrollView = (UIScrollView*)[AppContext navigationConductor].currentController.view;
    [[scrollView.subviews objectAtIndex:0] removeGestureRecognizer:_recognizer];
    
    _recognizer = nil;
}

-(void) keyboardDidChangeFrame:(NSNotification*)notification {
    CGSize keyboardSize = [self keyboardSizeFromNotification:notification];
    [self setScrollViewHeight:_screenHeight - keyboardSize.height];
    [self revealFirstResponder];
}


-(void) setScrollViewHeight: (int) height {
    UIScrollView* scrollView = (UIScrollView*)[AppContext navigationConductor].currentController.view;
    scrollView.frame = CGRectMake(0, 0, scrollView.frame.size.width, height);
}

-(CGSize) keyboardSizeFromNotification: (NSNotification*) notification {
    NSDictionary *info = [notification userInfo];
    return [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}

@end
*/
