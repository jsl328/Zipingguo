//
//  GridBoxCell.h
//  Mulberry
//
//  Created by Bob Li on 13-10-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCContentPresenter.h"
#import "DCItemsBox.h"

@interface DCItemsBoxCell : UICollectionViewCell {

    DCContentPresenter* _contentPresenter;
}

@property (retain, nonatomic) id content;
@property (nonatomic) float borderCornerRadius;
@property (retain, nonatomic) UIColor* borderColor;
@property (nonatomic) int borderWidth;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) BOOL isBorderInitialized;
@property (nonatomic) BOOL isAdded;

-(UIView*) view;

@end
