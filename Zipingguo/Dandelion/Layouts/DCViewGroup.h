//
//  DCViewGroup.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-4.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCView.h"

@interface DCViewGroup : DCView {

    NSMutableArray* _layoutParameters;
    
    NSMutableArray* _margins;
    
    
    NSMutableArray* _layoutSizes;
}

@property (nonatomic) int gap;
@property (nonatomic) UIEdgeInsets padding;

-(CGSize) layoutSizeForView:(UIView*) view;
-(void) setLayoutSize:(CGSize) size ForView:(UIView*) view;

-(DCLayoutParams*) layoutParamsForView:(UIView*) view;
-(void) setLayoutParams:(DCLayoutParams*) params forView:(UIView*) view;
-(void) setLayoutParams:(DCLayoutParams*) params forViewAtIndex:(int) index;

-(UIEdgeInsets) marginForView:(UIView*) view;
-(void) setMargin:(UIEdgeInsets) margin forView:(UIView*) view;
-(void) setMargin:(UIEdgeInsets) margin forViewAtIndex:(int) index;
-(void) setMarginForSubviews:(UIEdgeInsets) margin;


-(DCLayoutParams*) newLayoutParams;

-(void) layout:(UIView*) view withRect:(CGRect) rect;

@end
