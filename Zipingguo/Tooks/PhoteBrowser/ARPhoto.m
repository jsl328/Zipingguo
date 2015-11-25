//
//  ARPhoto.m
//  Ariz
//
//  Created by HeHe丶 on 15/4/20.
//  Copyright (c) 2015年 Linku. All rights reserved.
//

#import "ARPhoto.h"

@implementation ARPhoto

- (id)initWithImage:(UIImage *)image {
    if ((self = [super init])) {
        _photoType = ARPhotoTypeImage;
        _image = image;
    }
    return self;
}

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        _photoType = ARPhotoTypeURL;
        _photoURL = [url copy];
    }
    return self;
}


@end
