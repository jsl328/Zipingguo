//
//  DCDocumentPreview.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDocumentPreview.h"
#import "DCDirectionDispatcher.h"

@implementation DCDocumentPreview {

    DCFileSource* _source;
    
    UIWebView* _webView;
    
    float _scale;
}

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
    
    _scale = 1;
    
    _webView = [[UIWebView alloc] init];
    [self addSubview:_webView];
    _webView.scalesPageToFit = YES;
    _webView.scrollView.delegate = self;
 
    _source = [[DCFileSource alloc] init];
    _source.delegate = self;
}

-(DCFileSource*) source {
    return _source;
}

-(void) acceptFile:(NSString *)filePath {

    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
}

-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _scale = scale;
}


-(DCDirectionDecision) decisionFromDirection:(DCMoveDirection) direction touch:(UITouch*) touch xDirection:(int) xDirection yDirection:(int) yDirection {
    
    if (direction == DCMoveDirectionLeft || direction == DCMoveDirectionRight) {
        return _scale == 1 ? DCDirectionDecisionDiscard : DCDirectionDecisionSieze;
    }
    else {
        return DCDirectionDecisionSieze;
    }
}

-(BOOL) isProperDirection:(DCMoveDirection) direction {
    return direction == DCMoveDirectionUp || direction == DCMoveDirectionDown;
}

-(void) directionTouchesBegan:(UITouch*) touch {
}

-(void) directionTouchesMoved:(UITouch*) touch {
}

-(void) directionTouchesEnded:(UITouch*) touch {
}


-(BOOL) sendWindowEvents {
    return YES;
}

-(BOOL) acceptMultipleTouches {
    return YES;
}


-(void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    
    if (!newWindow) {
        [[DCDirectionDispatcher defaultDispatcher] unregisterHandler:self];
    }
    else {
        [[DCDirectionDispatcher defaultDispatcher] registerHandler:self];
    }
}

-(void) layoutSubviews {
    _webView.frame = self.bounds;
}

@end
