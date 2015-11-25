//
//  DCImageHelper.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCByteArray.h"
#import "DCIntArray.h"

@interface DCImageHelper : NSObject

+(DCByteArray*) pixelsRGBADataFromImage:(UIImage*) image size:(CGSize) size;

+(DCIntArray*) pixelsDataFromImage:(UIImage*) image;

+(CGContextRef) createBitmapContextOfSize:(CGSize) size outData:(DCByteArray**) data;

+(UIImage*) createImageFromBitmapContext:(CGContextRef) context;

@end
