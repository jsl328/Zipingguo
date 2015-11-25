//
//  DCImageHelper.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCImageHelper.h"
#import "DCByteArray.h"

@implementation DCImageHelper

+(DCByteArray*) pixelsRGBADataFromImage:(UIImage*) image size:(CGSize)size {
    
    DCByteArray *rawData;
    CGContextRef context = [DCImageHelper createBitmapContextOfSize:size outData:&rawData];
    
    
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), image.CGImage);
    CGContextRelease(context);
    
    for (int i = 0; i <= size.height * size.width * 4 - 1; i += 4) {
        float factor = (float)rawData.a[i + 3] / 255;
        if (factor > 0) {
            rawData.a[i] /= factor;
            rawData.a[i + 1] /= factor;
            rawData.a[i + 2] /= factor;
        }
    }
    
    return rawData;
}

/*
+(DCByteArray*) pixelsRGBADataFromImage:(UIImage*) image size:(CGSize)size {

    CGImageRef imageRef = [image CGImage];
    int width = size.width;
    int height = size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);

    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    for (int i = 0; i <= height * width * 4 - 1; i += 4) {
        float factor = (float)rawData[i + 3] / 255;
        if (factor > 0) {
            rawData[i] /= factor;
            rawData[i + 1] /= factor;
            rawData[i + 2] /= factor;
        }
    }
    
    return [[DCByteArray alloc] initWithSize:height * width * 4 andArray:rawData];
}*/

+(DCIntArray*) pixelsDataFromImage:(UIImage*) image {

    DCByteArray* rgba = [DCImageHelper pixelsRGBADataFromImage:image size:image.size];
    DCIntArray* pixels = [[DCIntArray alloc] initWithSize:image.size.width * image.size.height];
    
    
    int index = 0;
    for (int i = 0; i <= rgba.size - 1; i += 4) {
        pixels.a[index] = (rgba.a[i] << 16) + (rgba.a[i + 1] << 8) + (rgba.a[i + 2]) + (rgba.a[i + 3] << 24);
        index++;
    }
    
    [rgba free];
    
    return pixels;
}

+(CGContextRef) createBitmapContextOfSize:(CGSize) size outData:(DCByteArray**) data {

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    *data = [[DCByteArray alloc] initWithSize:size.height * size.width * 4];
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * size.width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate((*data).a, size.width, size.height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

+(UIImage*) createImageFromBitmapContext:(CGContextRef) context {
    CGImageRef toCGImage = CGBitmapContextCreateImage(context);
    return [[UIImage alloc] initWithCGImage:toCGImage];
}

@end
