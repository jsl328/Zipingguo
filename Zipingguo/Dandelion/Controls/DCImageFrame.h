//
//  DCImageFrame.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-4-23.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCImageSource.h"

enum DCImageFrameShape {
    DCImageFrameShapeRectangle = 0,
    DCImageFrameShapeOval = 1,
    DCImageFrameShapeCircle = 2
};
typedef enum DCImageFrameShape DCImageFrameShape;


@interface DCImageFrame : UIView <DCImageSourceDelegate>

-(DCImageSource*) source;

@property (nonatomic) DCImageFrameShape shape;
@property (nonatomic) float cornerRadius;
@property (nonatomic) UIColor* borderColor;
@property (nonatomic) float borderWidth;
@property (nonatomic) UIColor* filteredColor;

@end
