//
//  DCImageIO.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCImageIO.h"
#import <ImageIO/ImageIO.h>

@implementation DCImageIO

+(CGContextRef) createContextWithRawData:(unsigned char *)rawData colorSpace:(CGColorSpaceRef)colorSpace ofSize:(CGSize)size {

    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * size.width;
    NSUInteger bitsPerComponent = 8;
    return CGBitmapContextCreate(rawData, size.width, size.height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
}

+(CGImageRef) createCGImageWithRawData:(unsigned char*) rawData colorSpace:(CGColorSpaceRef) colorSpace ofSize:(CGSize) size {
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                              rawData,
                                                              size.width * size.height * 4,
                                                              NULL);
    
    
    size_t kComponentsPerPixel = 4;
    size_t kBitsPerComponent = sizeof(unsigned char) * 8;
    
    return CGImageCreate(size.width,
                           size.height,
                           kBitsPerComponent,
                           kBitsPerComponent * kComponentsPerPixel,
                           kComponentsPerPixel * size.width,
                           colorSpace,
                           kCGBitmapByteOrderDefault,
                           provider,
                           NULL, NO, kCGRenderingIntentDefault);
}

+(void) saveCGImageAsJpg:(CGImageRef) imageRef atFilePath:(NSString*) filePath {
    
    UIImage* invertedImage = [DCImageIO UIImageInvertedVeticallyFromCGImage:imageRef];
    [UIImageJPEGRepresentation(invertedImage, 1.0) writeToFile:filePath atomically:YES];
    UIGraphicsEndImageContext();
}

+(void) saveCGImageAsPng:(CGImageRef) imageRef atFilePath:(NSString*) filePath {
    
    UIImage* invertedImage = [DCImageIO UIImageInvertedVeticallyFromCGImage:imageRef];
    [UIImagePNGRepresentation(invertedImage) writeToFile:filePath atomically:YES];
    UIGraphicsEndImageContext();
}

+(UIImage*) downsampledImageFromImage:(UIImage*) image withSizeNoMoreThan:(int) size {

    float scale = (float)(image.size.width * image.size.height * 4) / size;
    
    if (scale < 1) {
        return image;
    }
    
    
    int width = floor(image.size.width / sqrtf(scale));
    int height = floor(image.size.height / sqrtf(scale));

    return [DCImageIO scaledImageFromImage:image toSize:CGSizeMake(width, height)];
}

+(void) downsampleImageAtFilePath:(NSString*) filePath toSizeNoMoreThan:(int) size {
    
    int fileType;
    
    if ([[filePath lowercaseString] endsWithString:@"png"]) {
        fileType = 0;
    }
    else if ([[filePath lowercaseString] endsWithString:@"jpg"]) {
        fileType = 1;
    }
    else {
        return;
    }
    
    

    UIImage* image = [UIImage imageWithContentsOfFile:filePath];
    
    float scale = (float)(image.size.width * image.size.height * 4) / size;
    
    if (scale < 1) {
        return;
    }
    
    
    int width = floor(image.size.width / sqrtf(scale));
    int height = floor(image.size.height / sqrtf(scale));
    
    UIImage* targetImage = [DCImageIO scaledImageFromImage:image toSize:CGSizeMake(width, height)];
    

    if (fileType == 0) {
        [DCImageIO saveCGImageAsPng:targetImage.CGImage atFilePath:filePath];
    }
    else if (fileType == 1) {
        [DCImageIO saveCGImageAsPng:targetImage.CGImage atFilePath:filePath];
    }
}


+(UIImage*) UIImageInvertedVeticallyFromCGImage:(CGImageRef) imageRef {
    
    NSInteger width = CGImageGetWidth(imageRef);
    NSInteger height = CGImageGetHeight(imageRef);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    return UIGraphicsGetImageFromCurrentImageContext();
}


+(UIImage*) downsampledImageFromImage:(UIImage*) image withDimensionNoMoreThan:(int) dimension {
    
    int imageWidth = image.size.width;
    int imageHeight = image.size.height;
    
    if (dimension >= image.size.width && dimension >= image.size.height) {
        return image;
    }
    
    
    int width;
    int height;
    
    if (imageWidth >= imageHeight) {
        width = dimension;
        height = (int)((double)width * imageHeight / imageWidth);
    }
    else {
        height = dimension;
        width = (int)((double)height * imageWidth / imageHeight);
    }
    
    
    return [DCImageIO scaledImageFromImage:image toSize:CGSizeMake(width, height)];
}

+(UIImage*) scaledImageFromImage:(UIImage*) image toSize:(CGSize) size {
    
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    
    [image drawInRect: CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *compressedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return compressedImage;
}

@end
