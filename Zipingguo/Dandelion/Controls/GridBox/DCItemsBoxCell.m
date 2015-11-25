//
//  GridBoxCell.m
//  Mulberry
//
//  Created by Bob Li on 13-10-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCItemsBoxCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DCItemsBoxCell
@synthesize content = _content;
@synthesize borderCornerRadius = _borderCornerRadius;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize isBorderInitialized;
@synthesize isAdded;

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
    
    self.clipsToBounds = YES;
    
    self.borderCornerRadius = 0;
    self.borderColor = [UIColor lightGrayColor];
    self.borderWidth = 1;
    _isSelected = NO;
    [self updateSelectionColor];
}

-(void) setBorderCornerRadius:(float)borderCornerRadius {
    _borderCornerRadius = borderCornerRadius;
    [self updateBorder];
}

-(void) setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self updateBorder];
}

-(void) setBorderWidth:(int)borderWidth {
    if (_borderWidth != borderWidth) {
        _borderWidth = borderWidth;
        [self updateBorder];
    }
}

-(void) setContent:(id)content {
    if (_content != content) {
        _content = content;
        _contentPresenter.content = content;
    }
}

-(void) setIsSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        [self updateSelectionColor];
    }
}

-(void) updateSelectionColor {
    _contentPresenter.backgroundColor = _isSelected ? [UIColor clearColor] : [UIColor whiteColor];
}

-(void) updateBorder {
    self.layer.cornerRadius = _borderCornerRadius;
    self.layer.borderWidth = _borderWidth;
    self.layer.borderColor = _borderColor.CGColor;
}

-(UIView*) view {
    return _contentPresenter.contentView;
}

-(void) layoutSubviews {
    [super layoutSubviews];
    _contentPresenter.frame = self.bounds;
}

@end
