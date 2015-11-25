//
//  DCItemsBoxLayout.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-11.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCSectionedData.h"

struct DCItemsBoxHitTestResult {
    BOOL isHeader;
    BOOL isFooter;
    int sectionIndex;
    int itemIndex;
};
typedef struct DCItemsBoxHitTestResult DCItemsBoxHitTestResult;

@interface DCItemsBoxLayout : UICollectionViewLayout {
    
    NSMutableArray* _attributesList;
    
    CGSize _contentSize;
    
    float _top;
    
    BOOL _isSectionedData;
    
    
    int _startIndex;
    int _endIndex;
    
    int _startSectionIndex;
    int _endSectionIndex;
}

@property (nonatomic) DCOrientation orientation;
@property (nonatomic) int size;
@property (nonatomic) int headerHeight;
@property (nonatomic) int footerHeight;
@property (nonatomic) UIEdgeInsets sectionPadding;
@property (nonatomic) UIEdgeInsets contentPadding;
@property (nonatomic) int sectionGap;
@property (nonatomic) BOOL isHeaderSticky;
@property (nonatomic) BOOL isFooterSticky;

@property (retain, nonatomic) NSMutableArray* sections;


-(DCItemsBoxHitTestResult) hitTestSectionHeaderFooterWithPoint:(CGPoint) point;
-(DCItemsBoxHitTestResult) hitTestCellWithPoint:(CGPoint)point;


-(void) sizeDidChange;

-(void) performLayoutWithItems:(NSArray*) items isSectionedData:(BOOL) isSectionedData;

-(void) populateRectsOfItems:(NSArray*) items toLayoutRects:(NSMutableArray*) layoutRects renderRects:(NSMutableArray*) renderRects;

@end

