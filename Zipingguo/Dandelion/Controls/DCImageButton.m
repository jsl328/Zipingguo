//
//  DCImageTextControl.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-3-28.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCImageButton.h"

@implementation DCImageButton
@synthesize contentGravity = _contentGravity;
@synthesize style = _style;
@synthesize selectionMode;
@synthesize padding = _padding;
@synthesize gapBetweenImageAndText = _gapBetweenImageAndText;
@synthesize imageLayoutParams = _imageLayoutParams;
@synthesize groupIndex;

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
        self.style = DCImageBoxStyleImageLeftOfText;
    }
    return self;
}

-(id) initWithStyle:(DCImageBoxStyle)style {
    self = [super init];
    if (self) {
        [self initialize];
        self.style = style;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
        self.style = DCImageBoxStyleImageLeftOfText;
    }
    return self;
}


-(void) initialize {
    
    self.clipsToBounds = YES;

    _imageView = [[UIImageView alloc] init];
    _label = [[UILabel alloc] init];
    
    _textColor = _label.textColor;
    
    [self addSubview:_imageView];
    [self addSubview:_label];
    
    _style = DCImageBoxStyleImageLeftOfText;
    _gapBetweenImageAndText = 10;
    _imageLayoutParams = DCLayoutParamsMake(50, 50);
    [self measureContent];
    [self layoutParams];
}

-(void) setStyle:(DCImageBoxStyle)style {
    _style = style;
    [self measureContent];
    [self layoutSubviews];
}

-(void) setPadding:(UIEdgeInsets)padding {
    _padding = padding;
    [self layoutSubviews];
}

-(void) setGapBetweenImageAndText:(float)gapBetweenImageAndText {
    _gapBetweenImageAndText = gapBetweenImageAndText;
    [self layoutSubviews];
}

-(void) setImageLayoutParams:(DCLayoutParams *)imageLayoutParams {
    _imageLayoutParams = imageLayoutParams;
    [self layoutSubviews];
}

-(CGSize) intrinsicContentSize {
    return CGSizeMake(_contentSize.width + _padding.left + _padding.right, _contentSize.height + _padding.top + _padding.bottom);
}


-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    _backgroundImageView.frame = self.bounds;
    
    float left = 0;
    float top = (self.frame.size.height - _contentSize.height) / 2;
    
    if (_contentGravity == DCHorizontalGravityLeft) {
        left = _padding.left;
    }
    else if (_contentGravity == DCHorizontalGravityCenter) {
        left = (self.frame.size.width - _contentSize.width) / 2;
    }
    else if (_contentGravity == DCHorizontalGravityRight) {
        left = self.frame.size.width - _padding.right - _contentSize.width;
    }
    else if (_contentGravity == DCHorizontalGravityStretch) {
        left = _padding.left;
    }
    
    [self layoutInRect:CGRectMake(left, top, _contentSize.width, _contentSize.height)];
}

-(void) layoutInRect:(CGRect) rect {

    CGSize imageViewSize = [self sizeForImageView];
    
    if (_style == DCImageBoxStyleImageLeftOfText) {
        _imageView.frame = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - imageViewSize.height) / 2, imageViewSize.width, imageViewSize.height);
        _label.frame = CGRectMake(rect.origin.x + imageViewSize.width + _gapBetweenImageAndText, rect.origin.y + (rect.size.height - _textSize.height) / 2, _textSize.width, _textSize.height);
    }
    else if (_style == DCImageBoxStyleImageRightOfText) {
        _label.frame = CGRectMake(rect.origin.x, rect.origin.y + (rect.size.height - _textSize.height) / 2, _textSize.width, _textSize.height);
        _imageView.frame = CGRectMake(rect.origin.x + _textSize.width + _gapBetweenImageAndText, rect.origin.y + (rect.size.height - imageViewSize.height) / 2, imageViewSize.width, imageViewSize.height);
    }
    else if (_style == DCImageBoxStyleImageAboveText) {
        _imageView.frame = CGRectMake(rect.origin.x + (rect.size.width - imageViewSize.width) / 2, rect.origin.y, imageViewSize.width, imageViewSize.height);
        _label.frame = CGRectMake(rect.origin.x + (rect.size.width - _textSize.width) / 2, rect.origin.y + imageViewSize.height + _gapBetweenImageAndText, _textSize.width, _textSize.height);
    }
    else if (_style == DCImageBoxStyleImageBelowText) {
        _label.frame = CGRectMake(rect.origin.x + (rect.size.width - _textSize.width) / 2, rect.origin.y, _textSize.width, _textSize.height);
        _imageView.frame = CGRectMake(rect.origin.x + (rect.size.width - imageViewSize.width) / 2, rect.origin.y + _textSize.height + _gapBetweenImageAndText, imageViewSize.width, imageViewSize.height);
    }
}


-(BOOL) isHorizontal {
    return _style == DCImageBoxStyleImageLeftOfText || _style == DCImageBoxStyleImageRightOfText;
}

-(void) measureContent {
    
    if (_contentGravity == DCHorizontalGravityStretch) {
        _contentSize = CGSizeMake(self.frame.size.width - _padding.left - _padding.right, self.frame.size.height - _padding.top - _padding.bottom);
    }
    
    
    CGSize imageViewSize = [self sizeForImageView];

    float width;
    float height;
    
    if ([self isHorizontal]) {
        width = imageViewSize.width + _gapBetweenImageAndText + _textSize.width;
        height = MAX(imageViewSize.height, _textSize.height);
    }
    else {
        width = MAX(imageViewSize.width, _textSize.width);
        height = imageViewSize.height + _gapBetweenImageAndText + _textSize.height;
    }
    
    _contentSize = CGSizeMake(width, height);
}

-(CGSize) sizeForImageView {

    float desiredWidth = _imageLayoutParams.width;
    float desiredHeight = _imageLayoutParams.height;
    
    float imageWidth = _imageView.image.size.width;
    float imageHeight = _imageView.image.size.height;
    
    float actualWidth = desiredWidth == DCLayoutWrapContent ? imageWidth : desiredWidth;
    float actualHeight = desiredHeight == DCLayoutWrapContent ? imageHeight : desiredHeight;

    return CGSizeMake(actualWidth, actualHeight);
}


-(void) setText:(NSString*) text {
    _label.text = text;
    _textSize = [_label.text sizeWithFont:_label.font];
    [self measureContent];
    [self layoutSubviews];
}

-(void) setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    [self updateImage];
    [self updateLabelTextColor];
    [self updateBackgroundImage];
    
    if (selected) {
        [self deselectOtherImageButtonsInGroup];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void) setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateImage];
    [self updateLabelTextColor];
    [self updateBackgroundImage];
}

-(void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateImage];
    [self updateLabelTextColor];
    [self updateBackgroundImage];
}

-(void) deselectOtherImageButtonsInGroup {

    for (UIView* view in self.superview.subviews) {
        if ([[view class] isSubclassOfClass:[DCImageButton class]] && view != self) {
            
            DCImageButton* button = (DCImageButton*)view;
            
            if (button.groupIndex == groupIndex) {
                [button setSelected:NO];
            }
        }
    }
}


-(void) setBackgroundImage:(UIImage*) image {

    _backgroundImage = image;
    [self configureImageView];
    
    if (self.state == UIControlStateNormal) {
        [self updateBackgroundImage];
    }
}

-(void) setPressedBackgroundImage:(UIImage*) image {

    _pressedBackgroundImage = image;
    [self configureImageView];
    
    if (self.state & UIControlStateHighlighted) {
        [self updateBackgroundImage];
    }
}

-(void) setDisabledBackgroundImage:(UIImage*) image {
    
    _disabledBackgroundImage = image;
    [self configureImageView];
    
    if (self.state & UIControlStateDisabled) {
        [self updateBackgroundImage];
    }
}

-(void) setSelectedBackgroundImage:(UIImage*) image {
    
    _selectedBackgroundImage = image;
    [self configureImageView];
    
    if (self.state & UIControlStateSelected) {
        [self updateBackgroundImage];
    }
}

-(void) configureImageView {

    BOOL needsImageView = _backgroundImage || _pressedBackgroundImage || _disabledBackgroundImage || _selectedBackgroundImage;
    
    if (needsImageView) {
        if (!_backgroundImageView) {
            _backgroundImageView = [[UIImageView alloc] init];
            [self insertSubview:_backgroundImageView atIndex:0];
            [self layoutSubviews];
        }
    }
    else if (_backgroundImageView) {
        [_backgroundImageView removeFromSuperview];
        _backgroundImageView = nil;
    }
}


-(void) setImage:(UIImage*) image {
    
    _image = image;
    
    if (self.state == UIControlStateNormal) {
        [self updateImage];
    }
}

-(void) setPressedImage:(UIImage*) image {

    _pressedImage = image;
    
    if (self.state & UIControlStateHighlighted) {
        [self updateImage];
    }
}

-(void) setDisabledImage:(UIImage*) image {

    _disabledImage = image;
    
    if (self.state & UIControlStateDisabled) {
        [self updateImage];
    }
}

-(void) setSelectedImage:(UIImage*) image {

    _selectedImage = image;
    
    if (self.state & UIControlStateSelected) {
        [self updateImage];
    }
}


-(void) setTextColor:(UIColor*) color {
    
    _textColor = color;
    
    if (self.state == UIControlStateNormal) {
        [self updateLabelTextColor];
    }
}

-(void) setPressedTextColor:(UIColor*) color {
    
    _pressedTextColor = color;
    
    if (self.state & UIControlStateHighlighted) {
        [self updateLabelTextColor];
    }
}

-(void) setDisabledTextColor:(UIColor*) color {
    
    _disabledTextColor = color;
    
    if (self.state & UIControlStateDisabled) {
        [self updateLabelTextColor];
    }
}

-(void) setSelectedTextColor:(UIColor*) color {
    
    _selectedTextColor = color;
    
    if (self.state & UIControlStateSelected) {
        [self updateLabelTextColor];
    }
}


-(void) updateImage {

    UIImage* image = [self imageForCurrentState];
    
    if (_imageView.image != image) {
        _imageView.image = image;
        [self measureContent];
        [self layoutSubviews];
    }
}

-(UIImage*) imageForCurrentState {

    UIImage* image = nil;
    
    if (self.state == UIControlStateNormal) {
        image = _image;
    }
    else if (self.state & UIControlStateDisabled) {
        image = _disabledImage;
    }
    else if (self.state & UIControlStateHighlighted) {
        image = _pressedImage;
    }
    else if (self.state & UIControlStateSelected) {
        image = _selectedImage;
    }
    
    if (!image) {
        image = self.state & UIControlStateSelected ? _selectedImage : _image;
    }
    
    return image;
}


-(void) updateLabelTextColor {
    _label.textColor = [self textColorForCurrentState];
}

-(UIColor*) textColorForCurrentState {
    
    UIColor* color = nil;
    
    if (self.state == UIControlStateNormal) {
        color = _textColor;
    }
    else if (self.state & UIControlStateDisabled) {
        color = _disabledTextColor;
    }
    else if (self.state & UIControlStateHighlighted) {
        color = _pressedTextColor;
    }
    else if (self.state & UIControlStateSelected) {
        color = _selectedTextColor;
    }
    
    if (!color) {
        color = self.state & UIControlStateSelected ? _selectedTextColor : _textColor;
    }
    
    return color;
}


-(void) updateBackgroundImage {
    _backgroundImageView.image = [self backgroundImageForCurrentState];
}

-(UIImage*) backgroundImageForCurrentState {
    
    UIImage* image = nil;
    
    if (self.state == UIControlStateNormal) {
        image = _backgroundImage;
    }
    else if (self.state & UIControlStateDisabled) {
        image = _disabledBackgroundImage;
    }
    else if (self.state & UIControlStateHighlighted) {
        image = _pressedBackgroundImage;
    }
    else if (self.state & UIControlStateSelected) {
        image = _selectedBackgroundImage;
    }
    
    if (!image) {
        image = self.state & UIControlStateSelected ? _selectedBackgroundImage : _backgroundImage;
    }
    
    return image;
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    if (!self.enabled) {
        return;
    }
    
    
    [self setHighlighted:YES];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    [self setHighlighted:NO];
    
    
    if (!self.enabled || selectionMode == DCImageBoxSelectionModeNone) {
        return;
    }
    
    
    UITouch* touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    
    
    if (p.x >= 0 && p.y >= 0 && p.x <= self.frame.size.width && p.y <= self.frame.size.height) {
        
        if (selectionMode == DCImageBoxSelectionModeSelect) {
            [self setSelected:YES];
        }
        else if (selectionMode == DCImageBoxSelectionModeSelectDeselect) {
            [self setSelected:!self.isSelected];
        }
    }
}

@end
