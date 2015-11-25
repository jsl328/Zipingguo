//
//  ARPhoto.h
//  Ariz
//
//  Created by HeHe丶 on 15/4/20.
//  Copyright (c) 2015年 Linku. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ARPhotoTypeImage,
    ARPhotoTypeURL
} ARPhotoType;


@interface ARPhoto : NSObject

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSURL *photoURL;

@property (nonatomic,assign) ARPhotoType photoType;
- (id)initWithImage:(UIImage *)image;
- (id)initWithURL:(NSURL *)url;

@end
