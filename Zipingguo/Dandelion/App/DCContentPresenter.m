//
//  DCContentPresenter.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCContentPresenter.h"
#import "UIView+Extensions.h"
#import "ViewLocater.h"
#import "BindingContext.h"

@implementation DCContentPresenter
@synthesize content = _content;
@synthesize stringViewClass;

-(id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

-(id) initWithContent:(id)content {
    self = [super init];
    if (self) {
        [self setContent:content];
    }
    return self;
}

-(void) setContent:(id) newContent {
    
    if (!newContent || [[_content class] isSubclassOfClass:[newContent class]]) {
        _content = newContent;
        [self bind];
        return;
    }
    
    
    _content = newContent;
    
    if ([[_content class] isSubclassOfClass:[UIView class]]) {
        _view = (UIView*)_content;
        _viewType = DCViewTypeUIView;
    }
    else if ([[_content class] isSubclassOfClass:[NSString class]] && stringViewClass) {
        _viewType = DCViewTypeBindable;
        _view = [[stringViewClass alloc] init];
    }
    else {
        Class viewClass = [ViewLocater viewClassForViewModel:_content viewSuffix:@"View"];
        
        if ([viewClass isSubclassOfClass:[UILabel class]]) {
            _viewType = DCViewTypeUILabel;
            _view = [[UILabel alloc] init];
            _view.backgroundColor = [UIColor clearColor];
        }
        else {       
            [self loadXibForView:viewClass];
            if ([_view respondsToSelector:@selector(bind:)]) {
                _viewType = DCViewTypeBindable;
            }
            else {
                _viewType = DCViewTypeUIView;
            }
        }
    }
    
    [self removeAllSubviews];
    [self addSubview:_view];
    
    if ([_view respondsToSelector:@selector(initialize)]) {
        [_view performSelector:@selector(initialize)];
    }
    
    
    [self bind];
}

-(void) loadXibForView: (Class) viewClass {
    NSString* xibFileName = [viewClass description];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:xibFileName ofType:@"nib"]];
    if (!exists) {
        _view = [[viewClass alloc] init];
    }
    else {
        _view = [[NSBundle mainBundle] loadNibNamed:xibFileName owner:self options:nil].lastObject;
    }
}

-(UIView*) contentView {
    return _view;
}

-(void) bind {
    
    if (_viewType == DCViewTypeUILabel) {
        ((UILabel*)_view).text = [_content description];
    }
    else if (_viewType == DCViewTypeBindable) {
        [_view performSelector:@selector(bind:) withObject:_content];
        [BindingContext putViewModel:_content andView:_view];
    }
}

-(void) layoutSubviews {
    [super layoutSubviews];
    _view.frame = self.bounds;
}

@end
