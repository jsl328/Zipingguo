//
//  DCFrameworkElement.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-7.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCView : UIView

@property (nonatomic) DCMeasureSpec lastTimeWidthSpec;
@property (nonatomic) DCMeasureSpec lastTimeHeightSpec;
@property (nonatomic) CGSize measuredSize;
@property (retain, nonatomic) DCLayoutParams* layoutParams;
@property (nonatomic) UIEdgeInsets margin;

-(void) measureWithWidthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec;
-(void) onLayout;


-(void) setMeasuredSizeWithContentWidth:(float) contentWidth widthSpec:(DCMeasureSpec) widthSpec contentHeight:(float) contentHeight heightSpec:(DCMeasureSpec) heightSpec;

-(void) layoutAtPoint:(CGPoint) point;
-(void) layoutAtPoint:(CGPoint) point withWidthSpec:(DCMeasureSpec) widthSpec heightSpec: (DCMeasureSpec) heightSpec;


-(void) measure:(UIView*) view widthSpec:(DCMeasureSpec) widthSpec heightSpec:(DCMeasureSpec) heightSpec;

@end
