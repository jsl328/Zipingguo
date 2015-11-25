//
//  DCImageFrame.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-23.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCImageFrame.h"

//#import <QuartzCore/QuartzCore.h>

@implementation DCImageFrame {

    UIImage* _image;
    
    DCImageSource* _source;
}

@synthesize shape = _shape;
@synthesize cornerRadius = _cornerRadius;
@synthesize borderColor = _borderColor;
@synthesize borderWidth = _borderWidth;
@synthesize filteredColor = _filteredColor;

-(id) init {
    self = [super init];
    if (self) {
        [self initializeImageFrame];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeImageFrame];
    }
    return self;
}

-(void) initializeImageFrame {
    self.contentMode = UIViewContentModeScaleAspectFit;
    _shape = DCImageFrameShapeRectangle;
    _source = [[DCImageSource alloc] init];
    _source.delegate = self;
    [self setOpaque:NO];
}

-(void) acceptImage:(UIImage *)image {
    _image = image;
    [self setNeedsDisplay];
}

-(DCImageSource*) source {
    return _source;
}

-(void) drawRect:(CGRect)rect {
    
    if (!_image) {
        return;
    }
    
    
    CGRect sourceRect = [self sourceRect];
    CGRect targetRect = [self targetRect];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    [self setClipPathInContext:context containedInRect:targetRect];
    CGContextClip(context);
    
    
    BOOL drawBorder = _borderColor && _borderWidth > 0;
    
    if (drawBorder) {
        CGContextSaveGState(context);
    }
    
    
    [self setTransformInContext:context thatMapsRect:sourceRect toRect:targetRect];
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextDrawImage(context, CGRectMake(0, 0, _image.size.width, _image.size.height), _image.CGImage);
    
    
    if (drawBorder) {
        CGContextRestoreGState(context);
    }
    
    if (_filteredColor) {
        CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        CGContextSetFillColorWithColor(context, _filteredColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        CGContextSetBlendMode(context, kCGBlendModeCopy);
    }
    
    if (drawBorder) {
        [self setBorderPathInContext:context containedInRect:targetRect];
        CGContextSetFillColorWithColor(context, _borderColor.CGColor);
        CGContextEOFillPath(context);
    }
}

-(CGRect) sourceRect {

    float left;
    float top;
    float width;
    float height;
    
    if (_shape == DCImageFrameShapeCircle) {
        width = MIN(_image.size.width, _image.size.height);
        height = width;
    }
    else {
        width = _image.size.width;
        height = _image.size.height;
    }
    
    left = (_image.size.width - width) / 2;
    top = (_image.size.height - height) / 2;
    
    return CGRectMake(left, top, width, height);
}

-(CGRect) targetRect {

    float left;
    float top;
    float width;
    float height;
    
    if (_shape == DCImageFrameShapeCircle) {
        width = MIN(self.frame.size.width, self.frame.size.height);
        height = width;
    }
    else {
    
        if (_image.size.width / _image.size.height > self.frame.size.width / self.frame.size.height) {
            width = self.frame.size.width;
            height = width * (_image.size.height / _image.size.width);
        }
        else {
            height = self.frame.size.height;
            width = height * (_image.size.width / _image.size.height);
        }
    }
    
    left = (self.frame.size.width - width) / 2;
    top = (self.frame.size.height - height) / 2;
    
    return CGRectMake(left, top, width, height);
}

-(void) setClipPathInContext:(CGContextRef) context containedInRect:(CGRect) rect {

    if (_shape == DCImageFrameShapeRectangle) {
        
        CGContextMoveToPoint(context, rect.origin.x + _cornerRadius, rect.origin.y);
        CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, _cornerRadius);
        CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y + rect.size.height, _cornerRadius);
        CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y, _cornerRadius);
        CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y, _cornerRadius);
    }
    else {
        CGContextAddEllipseInRect(context, rect);
    }
}

-(void) setBorderPathInContext:(CGContextRef) context containedInRect:(CGRect) rect {
    
    if (_shape == DCImageFrameShapeRectangle) {
        
        CGContextMoveToPoint(context, rect.origin.x + _cornerRadius, rect.origin.y);
        CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, _cornerRadius);
        CGContextAddArcToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y + rect.size.height, _cornerRadius);
        CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x, rect.origin.y, _cornerRadius);
        CGContextAddArcToPoint(context, rect.origin.x, rect.origin.y, rect.origin.x + rect.size.width, rect.origin.y, _cornerRadius);
        
        CGContextMoveToPoint(context, rect.origin.x + _cornerRadius + _borderWidth, rect.origin.y + _borderWidth);
        CGContextAddArcToPoint(context, rect.origin.x + rect.size.width - _borderWidth, rect.origin.y + _borderWidth, rect.origin.x + rect.size.width - _borderWidth, rect.origin.y + rect.size.height - _borderWidth, _cornerRadius);
        CGContextAddArcToPoint(context, rect.origin.x + rect.size.width - _borderWidth, rect.origin.y + rect.size.height - _borderWidth, rect.origin.x + _borderWidth, rect.origin.y + rect.size.height - _borderWidth, _cornerRadius);
        CGContextAddArcToPoint(context, rect.origin.x + _borderWidth, rect.origin.y + rect.size.height - _borderWidth, rect.origin.x + _borderWidth, rect.origin.y + _borderWidth, _cornerRadius);
        CGContextAddArcToPoint(context, rect.origin.x + _borderWidth, rect.origin.y + _borderWidth, rect.origin.x + rect.size.width - _borderWidth, rect.origin.y + _borderWidth, _cornerRadius);
    }
    else {
        CGContextAddEllipseInRect(context, rect);
        CGContextAddEllipseInRect(context, CGRectMake(rect.origin.x + _borderWidth, rect.origin.y + _borderWidth, rect.size.width - _borderWidth * 2, rect.size.height - _borderWidth * 2));
    }
}

-(void) setTransformInContext:(CGContextRef) context thatMapsRect:(CGRect) sourceRect toRect:(CGRect) targetRect {

    float scaleX = targetRect.size.width / sourceRect.size.width;
    float scaleY = targetRect.size.height / sourceRect.size.height;
 
    CGContextTranslateCTM(context, targetRect.origin.x - sourceRect.origin.x, targetRect.origin.y - sourceRect.origin.y);
    CGContextScaleCTM(context, scaleX, -scaleY);
    CGContextTranslateCTM(context, sourceRect.origin.x * (1 - scaleX) / scaleX, -(sourceRect.origin.y * (1 - scaleY) + sourceRect.origin.y * scaleY * 2 + targetRect.size.height) / scaleY);
}

-(void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [_source ownerWillMoveToWindow:newWindow];
}

@end

