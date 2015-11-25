//
//  ItemsBox.h
//  Mulberry
//
//  Created by Bob Li on 13-10-22.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCItemsBoxDelegate.h"
#import "DCItemsBoxLayout.h"
#import "DCItemsBoxCell.h"

@class DCItemsBoxCell;

@interface DCItemsBox : UIView <UICollectionViewDataSource, UICollectionViewDelegate> {
    
    
    NSMutableArray* _cells;

    UICollectionView* _collectionView;
    BOOL _isSectionedData;
    
    UIRefreshControl* _refreshControl;
    
    UITapGestureRecognizer* _tapRecognizer;
    
    id _selectedItem;
    NSIndexPath* _selectedIndexPath;
    BOOL _hasSelectedItem;
    
    
    BOOL _isDraggingCell;
    NSIndexPath* _draggingCellIndexPath;
    
    int _dragStartX;
    int _dragStartY;
    
    int _dragCurrentX;
    int _dragCurrentY;
}

@property (nonatomic) DCOrientation orientation;

@property (retain, nonatomic) NSArray* items;
@property (retain, nonatomic) DCItemsBoxLayout* layout;
@property (nonatomic) BOOL isRefreshable;
@property (retain, nonatomic) NSArray* headerViewTypes;
@property (retain, nonatomic) NSArray* footerViewTypes;
@property (retain, nonatomic) NSArray* cellViewTypes;
@property (nonatomic) BOOL isEditing;

@property (nonatomic) float cellBorderCornerRadius;
@property (nonatomic) UIColor* cellBorderColor;
@property (nonatomic) int cellBorderWidth;

@property (assign, nonatomic) id <DCItemsBoxDelegate> delegate;

-(void) endRefreshing;

-(void) scrollToSelectedItem;

-(DCItemsBoxCell*) cellAtIndexPath:(NSIndexPath*) indexPath;

-(void) insertItem:(id) item atIndexPath:(NSIndexPath*) indexPath;

-(void) removeItemAtIndexPath:(NSIndexPath*) indexPath;
-(void) removeItem:(id) item;
-(void) removeItems:(NSArray*) items;


-(void) toggleItemsOfSectionAtIndex:(int) index animated:(BOOL)animated;

-(void) toggleItemsOfSection: (id <DCSectionedData>) section animated:(BOOL)animated;

@end
