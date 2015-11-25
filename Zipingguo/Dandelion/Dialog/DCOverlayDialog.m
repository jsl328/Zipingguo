//
//  DCOverlayDialog.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCOverlayDialog.h"
#import "DCContentPresenter.h"

@implementation DCOverlayDialog {

    UIView* _mask;
    
    DCContentPresenter* _overlay;
}

@synthesize content = _content;
@synthesize size;
@synthesize horizontalGravity;
@synthesize verticalGravity;
@synthesize padding;
@synthesize inAnimation;
@synthesize outAnimation;
@synthesize clickToClose;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.size = CGSizeMake(300, 150);
        self.horizontalGravity = DCHorizontalGravityCenter;
        self.verticalGravity = DCHorizontalGravityCenter;
    }
    return self;
}


-(void) setContent:(id)content {
    _content = content;
    _overlay.content = content;
}

-(void) show {

    _mask = clickToClose ? [[UIControl alloc] init] : [[UIView alloc] init];
    _mask.backgroundColor = [AppContext settings].maskColor;
    _overlay = [[DCContentPresenter alloc] init];
    _overlay.content = _content;
    [_mask addSubview:_overlay];
    
    UIWindow* window = [AppContext window];
    
    [window addSubview:_mask];
    _mask.frame = window.bounds;
    
    if (clickToClose) {
        [(UIControl*)_mask addTarget:self action:@selector(onMaskClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    DCPerformAnimation(inAnimation, YES, _overlay, DCGetFrameInWindow(size, horizontalGravity, verticalGravity, padding), ^{
    });
}

-(void) close {
    
    if (clickToClose) {
        [(UIControl*)_mask removeTarget:self action:@selector(onMaskClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    DCPerformAnimation(outAnimation, NO, _overlay, DCGetFrameInWindow(size, horizontalGravity, verticalGravity, padding), ^{
        [self onCloseComplete];
    });
}

-(void) onCloseComplete {

    [_mask removeFromSuperview];
    _mask = nil;
    [self didClose];
}

-(void) onMaskClick:(id) sender {
    [self close];
}

@end
