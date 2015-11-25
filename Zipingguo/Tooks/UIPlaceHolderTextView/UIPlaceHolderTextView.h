//
//  UIPlaceHolderTextView.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/14.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) int maxLength;

-(void)textChanged:(NSNotification*)notification;

@end
