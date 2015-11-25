//
//  DCRatingControl.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-3-29.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCRatingControl : UIControl {

    CGSize _contentSize;
    
    NSMutableArray* _images;
    
    UIImage* _emptyImage;
    UIImage* _fullImage;
    
    float _touchX;
}

@property (nonatomic) int countOfStars;
@property (nonatomic) float value;
@property (nonatomic) CGSize sizeOfCell;
@property (nonatomic) float gapBetweenStars;

-(void) setEmptyImage:(UIImage*) image;
-(void) setFullImage:(UIImage*) image;
-(void) setImage:(UIImage*) image forPercent:(float) percent;

@end
