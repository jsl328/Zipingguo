//
//  DCTextPreview.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-21.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCFileSource.h"

@interface DCScrollTextPreview : UIView <UIScrollViewDelegate, DCFileSourceDelegate>

@property (nonatomic) BOOL isHtml;
@property (retain, nonatomic) UIColor* textColor;
@property (retain, nonatomic) UIColor* highlightColor;
@property (nonatomic) int fontSize;
@property (nonatomic) UIEdgeInsets padding;
@property (nonatomic) BOOL isFontSizeAdjustable;
@property (nonatomic) BOOL isTextSelectable;

-(DCFileSource*) source;

-(void) findText:(NSString*) text;
-(void) cancelFind;

@end
