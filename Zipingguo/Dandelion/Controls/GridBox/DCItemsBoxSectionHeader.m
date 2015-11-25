//
//  GridBoxSectionHeader.m
//  Mulberry
//
//  Created by Bob Li on 13-10-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCItemsBoxSectionHeader.h"
#import "DCItemsBoxTextHeaderView.h"

@implementation DCItemsBoxSectionHeader
@synthesize isHeader;
@synthesize content = _content;
@synthesize section;

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
    _contentPresenter = [[DCContentPresenter alloc] init];
    [self addSubview:_contentPresenter];
    _contentPresenter.stringViewClass = [DCGridBoxTextHeaderView class];
}

-(void) setContent:(id)content {
    if (_content != content) {
        _content = content;
        _contentPresenter.content = content;
    }
}

-(void) layoutSubviews {
    [super layoutSubviews];
    _contentPresenter.frame = self.bounds;
}

@end
