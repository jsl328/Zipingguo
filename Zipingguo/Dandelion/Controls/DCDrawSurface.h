//
//  DCDrawSurface.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCDrawSurface : UIView {
    
    CGColorSpaceRef _colorSpace;
    
    unsigned char* _rawData;
    
    CGContextRef _context;
    
    CGImageRef _image;
    
    CGPoint _lastPoint;
    
    BOOL _hasLastPoint;
    
    CGSize _size;
}

@property (nonatomic) float strokeThickess;
@property (retain, nonatomic) UIColor* strokeColor;

-(void) createSurfaceWithSize:(CGSize) size;

-(void) clearWithBackgroundColor:(UIColor*) color;

-(void) saveImageAtFilePath:(NSString*) filePath;

@end
