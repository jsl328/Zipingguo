//
//  DCImageBox.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-19.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCImageSource.h"

@interface DCImageBox : UIImageView <DCImageSourceDelegate>

-(DCImageBox*) source;

@property (retain, nonatomic) UIImage* placeholder;

- (void)setUrl:(NSString *)url fileName:(NSString *)fileName;

@end
