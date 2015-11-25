//
//  DCImageTextControl.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-3-28.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCControl.h"

@interface DCImageButton : DCControl {
    
    UIImageView* _backgroundImageView;

    UIImageView* _imageView;
    
    UILabel* _label;
    
    UIImage* _backgroundImage;
    UIImage* _pressedBackgroundImage;
    UIImage* _disabledBackgroundImage;
    UIImage* _selectedBackgroundImage;
    
    UIImage* _image;
    UIImage* _pressedImage;
    UIImage* _disabledImage;
    UIImage* _selectedImage;
    
    UIColor* _textColor;
    UIColor* _pressedTextColor;
    UIColor* _disabledTextColor;
    UIColor* _selectedTextColor;
    
    CGSize _textSize;
    CGSize _contentSize;
}

@property (nonatomic) DCHorizontalGravity contentGravity;
@property (nonatomic) DCImageBoxStyle style;
@property (nonatomic) DCImageBoxSelectionMode selectionMode;
@property (nonatomic) UIEdgeInsets padding;
@property (nonatomic) float gapBetweenImageAndText;
@property (nonatomic) DCLayoutParams* imageLayoutParams;
@property (nonatomic) int groupIndex;

-(id) initWithStyle:(DCImageBoxStyle) style;

-(void) setText:(NSString*) text;

-(void) setBackgroundImage:(UIImage*) image;
-(void) setPressedBackgroundImage:(UIImage*) image;
-(void) setDisabledBackgroundImage:(UIImage*) image;
-(void) setSelectedBackgroundImage:(UIImage*) image;

-(void) setImage:(UIImage*) image;
-(void) setPressedImage:(UIImage*) image;
-(void) setDisabledImage:(UIImage*) image;
-(void) setSelectedImage:(UIImage*) image;

-(void) setTextColor:(UIColor*) color;
-(void) setPressedTextColor:(UIColor*) color;
-(void) setDisabledTextColor:(UIColor*) color;
-(void) setSelectedTextColor:(UIColor*) color;

@end
