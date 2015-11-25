//
//  DCTextPreview.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-21.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCScrollTextPreview.h"
#import "DCLabel.h"
#import "DCDirectionDispatcher.h"

@implementation DCScrollTextPreview {

    DCLabel* _label;
    
    UIScrollView* _scrollView;
    
    float _scrollPosition;
    
    NSString* _searchText;
    
    UIPinchGestureRecognizer* _pinchRecognizer;
    
    DCFileSource* _source;
}

@synthesize isHtml;
@synthesize textColor = _textColor;
@synthesize highlightColor = _highlightColor;
@synthesize fontSize = _fontSize;
@synthesize padding = _padding;
@synthesize isFontSizeAdjustable = _isFontSizeAdjustable;
@synthesize isTextSelectable = _isTextSelectable;

- (id)init
{
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

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _label = [[DCLabel alloc] init];
    [_scrollView addSubview:_label];
    
    _source = [[DCFileSource alloc] init];
    _source.delegate = self;
}

-(DCFileSource*) source {
    return _source;
}

-(void) acceptFile:(NSString *)filePath {
    
    if (!filePath) {
        [_label setText:@"" isHtml:NO];
    }
    else {
        NSError* error;
        [_label setText:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error] isHtml:isHtml];
    }
}

-(void) setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [_label setTextColor:textColor];
}

-(void) setHighlightColor:(UIColor *)highlightColor {
    _highlightColor = highlightColor;
    [_label setHighlightColor:highlightColor];
}

-(void) setFontSize:(int)fontSize {
    _fontSize = fontSize;
    [_label setFontSize:fontSize];
    [self layoutSubviews];
}

-(void) setPadding:(UIEdgeInsets)padding {
    _padding = padding;
    [self layoutSubviews];
}

-(void) setIsFontSizeAdjustable:(BOOL)isFontSizeAdjustable {

    if (isFontSizeAdjustable) {
        if (!_pinchRecognizer) {
            _pinchRecognizer = [[UIPinchGestureRecognizer alloc] init];
            _pinchRecognizer.cancelsTouchesInView = NO;
            [_pinchRecognizer addTarget:self action:@selector(onPinch:)];
            [self addGestureRecognizer:_pinchRecognizer];
        }
    }
    else {
        if (_pinchRecognizer) {
            [_pinchRecognizer removeTarget:self action:@selector(onPinch:)];
            [self removeGestureRecognizer:_pinchRecognizer];
            _pinchRecognizer = nil;
        }
    }
}

-(void) setIsTextSelectable:(BOOL)isTextSelectable {
    _isTextSelectable = isTextSelectable;
    _label.isTextSelectable = isTextSelectable;
}

-(void) onPinch:(UIPinchGestureRecognizer*) recognizer {

    int fontSize = (float)_fontSize * sqrt(recognizer.scale);
    
    if (fontSize < 12) {
        fontSize = 12;
    }
    else if (fontSize > 75) {
        fontSize = 75;
    }
    
    self.fontSize = fontSize;
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView {

    _scrollPosition = scrollView.contentOffset.y;
    _label.topOffset = _scrollPosition;
    [self updateInternalPosition];
}

-(void) updateInternalPosition {

    _label.frame = CGRectMake(_padding.left, _padding.top + _scrollPosition, self.frame.size.width - _padding.left - _padding.right, self.frame.size.height - _padding.top - _padding.bottom);
}

-(void) findText:(NSString*) text {
    _searchText = text;
    [_label findText:text];
}

-(void) cancelFind {
    _searchText = nil;
    [_label cancelFind];
}

-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    [self updateInternalPosition];
    [_label layout:self.frame.size.width - _padding.left - _padding.right];
    
    _scrollView.frame = self.bounds;
    _scrollView.contentSize = CGSizeMake(self.frame.size.width, _label.documentSize.height + _padding.top + _padding.bottom);
    
    if (_searchText) {
        [_label findText:_searchText];
    }
}

@end
