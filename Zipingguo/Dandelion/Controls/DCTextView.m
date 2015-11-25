//
//  DCTextView.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-18.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCTextView.h"
#import "DCContentPresenter.h"

@implementation DCTextView
@synthesize placeholder = _placeholder;
@synthesize placeholderBackgroundColor;
@synthesize placeholderTextColor;
@synthesize placeholderTextAlignment;
@synthesize placeholderTextGravity = _placeholderTextGravity;
@synthesize placeholderPadding = _placeholderPadding;
@synthesize placeholderFadeinDuration;
@synthesize placeholderFadeoutDuration;

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
    
    _textView = [[UITextView alloc] init];
    [self addSubview:_textView];
    
    _placeholderTextGravity = DCVerticalGravityCenter;
}


-(NSString*) text {
    return _textView.text;
}

-(void) setText:(NSString *)text {
    [_textView setText:text];
}


-(UIColor*) textColor {
    return _textView.textColor;
}

-(void) setTextColor:(UIColor *)textColor {
    _textView.textColor = textColor;
}


-(NSTextAlignment) textAlignment {
    return _textView.textAlignment;
}

-(void) setTextAlignment:(NSTextAlignment)textAlignment {
    _textView.textAlignment = textAlignment;
}


-(void) setPlaceholder:(id)placeholder {

    _placeholder = placeholder;
    
    if (!_container) {
        _container = [[UIView alloc] init];
        [self insertSubview:_container atIndex:0];
        _container.hidden = YES;
    }

    if (!_placeholder) {
        [_placeholderView removeFromSuperview];
        _placeholderView = nil;
    }
    else if ([[placeholder class] isSubclassOfClass:[UIView class]]) {
        [_placeholderView removeFromSuperview];
        _placeholderView = placeholder;
        [_container addSubview:_placeholderView];
    }
    else {
        
        if (![[_placeholderView class] isSubclassOfClass:[DCContentPresenter class]]) {
            [_placeholderView removeFromSuperview];
            _placeholderView = [[DCContentPresenter alloc] init];
            [_container addSubview:_placeholderView];
        }

        DCContentPresenter* cp = (DCContentPresenter*)_placeholderView;
        cp.content = placeholder;
    
        if ([[cp.contentView class] isSubclassOfClass:[UILabel class]]) {
            [self initializePlaceHolderLabel:(UILabel*)cp.contentView];
        }
    }

    [self updatePlaceHolderViewVisibility];
}

-(void) initializePlaceHolderLabel:(UILabel*) label {
    label.numberOfLines = 0;
}


-(BOOL) placeholderIsLabel {
    return [[_placeholder class] isSubclassOfClass:[NSString class]];
}

-(UILabel*) placeholderLabel {
    return (UILabel*)((DCContentPresenter*)_placeholderView).contentView;
}


-(UIColor*) placeholderBackgroundColor {
    return _container.backgroundColor;
}

-(void) setPlaceholderBackgroundColor:(UIColor *)newPlaceholderBackgroundColor {
    _container.backgroundColor = newPlaceholderBackgroundColor;
}


-(UIColor*) placeHolderTextColor {
    return [self placeholderIsLabel] ? [self placeholderLabel].textColor : [UIColor clearColor];
}

-(void) setPlaceHolderTextColor:(UIColor *)newPlaceHolderTextColor {
    if ([self placeholderIsLabel]) {
        [self placeholderLabel].textColor = newPlaceHolderTextColor;
    }
}


-(NSTextAlignment) placeholderTextAlignment {
    return [self placeholderTextAlignment] ? [self placeholderLabel].textAlignment : NSTextAlignmentLeft;
}

-(void) setPlaceholderTextAlignment:(NSTextAlignment)newPlaceholderTextAlignment {
    if ([self placeholderIsLabel]) {
        [self placeholderLabel].textAlignment = newPlaceholderTextAlignment;
    }
}


-(void) setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [self updatePlaceHolderViewVisibility];
}

-(void) setPlaceholderTextGravity:(DCVerticalGravity)placeholderTextGravity {
    _placeholderTextGravity = placeholderTextGravity;
    if ([self placeholderIsLabel]) {
        [super layoutSubviews];
    }
}

-(void) setPlaceholderPadding:(UIEdgeInsets)placeholderPadding {
    _placeholderPadding = placeholderPadding;
    if (_placeholder) {
        [self layoutSubviews];
    }
}


-(void) animatePlaceholderAlpha {
    
    if (!_placeholder) {
        return;
    }
    
    
    BOOL showPlaceholder = _textView.text.length == 0;
    if (_isPlaceholderShown == showPlaceholder) {
        return;
    }
    
    
    _isPlaceholderShown = showPlaceholder;

    if (!_timer) {
        _timer = [[DCTickTimer alloc] init];
        _timer.delegate = self;
    }
  

    float from = _container.alpha;
    float to = showPlaceholder ? 1 : 0;
    
    [_timer setRangeFrom:from to:to changedInDuration:DCMathAbs(from - to) * (showPlaceholder ? self.placeholderFadeinDuration : self.placeholderFadeoutDuration)];
    [_timer start];
    
    _container.hidden = NO;
    _textView.backgroundColor = [UIColor clearColor];
}

-(void) updatePlaceHolderViewVisibility {
    _isPlaceholderShown = _textView.text.length == 0;
    _container.hidden = !_isPlaceholderShown;
    _textView.backgroundColor = _isPlaceholderShown ? [UIColor clearColor] : self.backgroundColor;
}

-(void) timer:(id)timer didTickWithValue:(float)value {
    _container.alpha = value;
}

-(void) timerDidStop:(id)timer {
    [self updatePlaceHolderViewVisibility];
}


-(void) willMoveToWindow:(UIWindow *)newWindow {
    
    [super willMoveToWindow:newWindow];
    
    if (!newWindow) {
        [self unsubscribeToTextChangeNotification];
        [_timer stop];
    }
    else {
        [self subscribeToTextChangeNotification];
    }
}

-(void) subscribeToTextChangeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:_textView];
}

-(void) unsubscribeToTextChangeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) textChanged:(NSNotification*) notification {
    if (notification.object == _textView) {
        [self animatePlaceholderAlpha];
    }
}


-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    _textView.frame = self.bounds;
    _container.frame = self.bounds;
    
    if (![self placeholderIsLabel] || _placeholderTextGravity == DCVerticalGravityCenter) {
        _placeholderView.frame = CGRectMake(_placeholderPadding.left, _placeholderPadding.top, self.frame.size.width - _placeholderPadding.left - _placeholderPadding.right, self.frame.size.height - _placeholderPadding.top - _placeholderPadding.bottom);
        return;
    }
    
    
    UILabel* label = [self placeholderLabel];
    int height = MIN([label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(self.frame.size.width, self.frame.size.height)].height + 1, self.frame.size.height - _placeholderPadding.top - _placeholderPadding.bottom);
    
    if (_placeholderTextGravity == DCVerticalGravityTop) {
        _placeholderView.frame = CGRectMake(_placeholderPadding.left, _placeholderPadding.top, self.frame.size.width - _placeholderPadding.left - _placeholderPadding.right, height);
    }
    else {
        _placeholderView.frame = CGRectMake(_placeholderPadding.left, self.frame.size.height - _placeholderPadding.bottom - height, self.frame.size.width - _placeholderPadding.left - _placeholderPadding.right, height);
    }
}

@end
