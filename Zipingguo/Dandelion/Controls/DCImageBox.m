//
//  DCImageBox.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-19.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCImageBox.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DCImageBox {
    
    DCImageSource* _source;
}

-(id) init {
    self = [super init];
    if (self) {
        [self initializeImageBox];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeImageBox];
    }
    return self;
}

-(void) initializeImageBox {
    self.contentMode = UIViewContentModeScaleAspectFit;
    _source = [[DCImageSource alloc] init];
    _source.delegate = self;
    //    _source.box = self;
}

-(DCImageBox*) source {
    return self;
}

- (void)setUrl:(NSString *)url fileName:(NSString *)fileName{
    
    [self setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:fileName]];
    
}

- (void)setPlaceholder:(UIImage *)placeholder{
    self.image = placeholder;
}

-(void) acceptImage:(UIImage *)image {
    self.image = image;
}

-(void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    [_source ownerWillMoveToWindow:newWindow];
}

@end
