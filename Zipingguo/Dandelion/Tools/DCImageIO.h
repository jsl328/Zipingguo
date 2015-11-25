//
//  DCImageIO.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCImageIO : NSObject

+(CGContextRef) createContextWithRawData:(unsigned char*) rawData colorSpace:(CGColorSpaceRef) colorSpace ofSize:(CGSize) size;

+(CGImageRef) createCGImageWithRawData:(unsigned char*) rawData colorSpace:(CGColorSpaceRef) colorSpace ofSize:(CGSize) size;

+(void) saveCGImageAsJpg:(CGImageRef) imageRef atFilePath:(NSString*) filePath;

+(void) saveCGImageAsPng:(CGImageRef) imageRef atFilePath:(NSString*) filePath;


+(UIImage*) downsampledImageFromImage:(UIImage*) image withSizeNoMoreThan:(int) size;

+(void) downsampleImageAtFilePath:(NSString*) filePath toSizeNoMoreThan:(int) size;

+(UIImage*) downsampledImageFromImage:(UIImage*) image withDimensionNoMoreThan:(int) dimension;

@end

