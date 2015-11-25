//
//  DCDrawSurface.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDrawSurface.h"
#import "DCImageIO.h"

@implementation DCDrawSurface
@synthesize strokeColor = _strokeColor;
@synthesize strokeThickess = _strokeThickess;

- (id)init
{
    self = [super init];
    if (self) {
        [self setOpaque:NO];
    }
    return self;
}

-(void) createSurfaceWithSize:(CGSize)size {
    
    _size = size;
    
    _colorSpace = CGColorSpaceCreateDeviceRGB();
    _rawData = malloc(_size.width * _size.height * 4);
    
    _context = [DCImageIO createContextWithRawData:_rawData colorSpace:_colorSpace ofSize:_size];
    _image = [DCImageIO createCGImageWithRawData:_rawData colorSpace:_colorSpace ofSize:_size];
    
    self.strokeColor = [UIColor redColor];
    self.strokeThickess = 2;
    [self clearWithBackgroundColor:[UIColor whiteColor]];
}

-(void) setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    CGContextSetStrokeColorWithColor(_context, _strokeColor.CGColor);
}

-(void) setStrokeThickess:(float)strokeThickess {
    _strokeThickess = strokeThickess;
    CGContextSetLineWidth(_context, strokeThickess);
}

-(void) clearWithBackgroundColor:(UIColor*) color {
    CGContextSetFillColorWithColor(_context, color.CGColor);
    CGContextFillRect(_context, CGRectMake(0, 0, _size.width, _size.height));
}

-(void) saveImageAtFilePath:(NSString*) filePath {
    
    int dotPosition = [filePath rangeOfString:@"." options:NSBackwardsSearch].location;
    NSString* extension = [[filePath substringFromIndex:dotPosition + 1] lowercaseString];
    
    if ([extension isEqualToString:@"png"]) {
        [DCImageIO saveCGImageAsPng:_image atFilePath:filePath];
    }
    else if ([extension isEqualToString:@"jpg"]) {
        [DCImageIO saveCGImageAsJpg:_image atFilePath:filePath];
    }
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch* touch = [[event touchesForView:self] anyObject];
    CGPoint point = [touch locationInView:self];
    
    
    if (_hasLastPoint) {
        CGContextMoveToPoint(_context, _lastPoint.x, _lastPoint.y);
        CGContextAddLineToPoint(_context, point.x, point.y);
    }
    
    _lastPoint = point;
    _hasLastPoint = YES;
    
    
    CGContextDrawPath(_context, kCGPathStroke);
    
    [self setNeedsDisplay];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _hasLastPoint = NO;
}

-(void) drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, CGRectMake(0, 0, _size.width, _size.height), _image);
}


-(void) willMoveToWindow:(UIWindow *)newWindow {
    
    [super willMoveToWindow:newWindow];
    
    if (!newWindow) {
        [self dispose];
    }
}

-(void) dispose {
    
    CGColorSpaceRelease(_colorSpace);
    free(_rawData);
    CGContextRelease(_context);
}

-(void) layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

@end
