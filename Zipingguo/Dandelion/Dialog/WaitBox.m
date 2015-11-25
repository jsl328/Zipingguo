//
//  WaitBox.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-1.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "WaitBox.h"

static WaitBox* _defaultWaitBox;

@implementation WaitBox {
    
    BOOL _isShown;
    UIView * bgView;
    UIView* _mask;
    
    UIActivityIndicatorView* _activityIndicator;
    
    UILabel* _messageLabel;
}

@synthesize maskColor;
@synthesize message;
@synthesize isSupressed;

+(WaitBox*) defaultWaitBox {
    
    if (!_defaultWaitBox) {
        _defaultWaitBox = [[WaitBox alloc] init];
    }
    
    return _defaultWaitBox;
}

- (id)init
{
    self = [super init];
    if (self) {
        maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        [self createMask];
    }
    return self;
}

-(void) createMask {
    
    bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    _mask = [[UIView alloc] init];
    _mask.backgroundColor = maskColor;
    _messageLabel.backgroundColor=[UIColor clearColor];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [_mask addSubview:_activityIndicator];
    
    _messageLabel = [[UILabel alloc] init];
    [_mask addSubview:_messageLabel];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:_mask];
}

-(void) setMessage:(NSString *)newMessage {
    message = newMessage;
    _messageLabel.text = newMessage;
    [self layoutSubviews];
}

-(void) show {
    
    if (!_isShown && !isSupressed) {
        
        _isShown = YES;
        
        UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
        
        [window addSubview:bgView];
        [_activityIndicator startAnimating];
        [self layoutSubviews];
    }
}

-(void) close {
    
    if (_isShown && !isSupressed) {
        
        _isShown = NO;
        
        [_activityIndicator stopAnimating];
        [bgView removeFromSuperview];
    }
}


-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    
    CGSize messageSize = _messageLabel.text ? _messageLabel.intrinsicContentSize : CGSizeMake(0, 0);
    
    bgView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    _mask.frame = CGRectMake((window.frame.size.width-110)/2, (window.frame.size.height-80)/2, 110, 80);
    _activityIndicator.frame = CGRectMake((_mask.frame.size.width - _activityIndicator.frame.size.width) / 2, (_mask.frame.size.height - _activityIndicator.frame.size.height) / 2-10, _activityIndicator.frame.size.width, _activityIndicator.frame.size.height);
    _messageLabel.frame = CGRectMake((_mask.frame.size.width - messageSize.width) / 2, _activityIndicator.frame.size.height+_activityIndicator.frame.origin.y+10, messageSize.width, messageSize.height);
    _mask.layer.cornerRadius = 5;
    _mask.layer.masksToBounds = YES;
}

@end
