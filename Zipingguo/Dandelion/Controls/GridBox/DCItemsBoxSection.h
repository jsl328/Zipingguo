//
//  DCGrisBoxSection.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-12.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCItemsBoxSection : NSObject

@property (nonatomic) BOOL isItemsHidden;

@property (nonatomic) BOOL hasHeader;
@property (retain, nonatomic) UICollectionViewLayoutAttributes* headerAttributes;
@property (nonatomic) float headerLayoutPosition;
@property (nonatomic) float headerRenderPosition;
@property (nonatomic) float headerLength;

@property (nonatomic) BOOL hasFooter;
@property (retain, nonatomic) UICollectionViewLayoutAttributes* footerAttributes;
@property (nonatomic) float footerLayoutPosition;
@property (nonatomic) float footerRenderPosition;
@property (nonatomic) float footerLength;

@property (nonatomic) float maxCellLength;

@property (retain, nonatomic) NSArray* items;
@property (nonatomic) float contentRenderTop;
@property (nonatomic) float contentLength;

-(void) reset;

@end
