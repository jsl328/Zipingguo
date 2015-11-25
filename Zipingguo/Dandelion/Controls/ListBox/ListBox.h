//
//  CellList.h
//  Mulberry
//
//  Created by Bob Li on 13-5-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListBoxDelegate.h"
#import "RequestNextPageControl.h"
#import "DCWeakSet.h"
#import "DCTableViewDataSource.h"
#import "DCTableViewDelegate.h"
#import "DCHandleDirection.h"
#import "DCTickTimer.h"
#import "Interpolator.h"

@class DCTableViewDataSource;
@class DCTableViewDelegate;

enum DCListBoxCellSelectionColor {
    DCListBoxCellSelectionColorBlue = 0,
    DCListBoxCellSelectionColorGray = 1,
    DCListBoxCellSelectionColorNone = 2,
    DCListBoxCellSelectionColorCustom = 3
};
typedef enum DCListBoxCellSelectionColor DCListBoxCellSelectionColor;

enum DCListBoxRequirePageMode {
    DCListBoxRequirePageModeManual = 0,
    DCListBoxRequirePageModeAutomatic = 1
};
typedef enum DCListBoxRequirePageMode DCListBoxRequirePageMode;

enum DCListBoxSlideCellMode {
    DCListBoxSlideCellModeDisabled = 0,
    DCListBoxSlideCellModeSingle = 1,
    DCListBoxSlideCellModeMultiple = 2
};
typedef enum DCListBoxSlideCellMode DCListBoxSlideCellMode;


@interface ListBox : UIView <RequestNextPageControlDelegate, DCHandleDirection, DCTickTimerDelegate, UIScrollViewDelegate> {
    
    UITableView* _tableView;
    
     UIRefreshControl* _refreshControl;
    
    BOOL _isRefreshable;

    BOOL _hasHeader;
    BOOL _hasFooter;
    
    BOOL _hasStringHeader;
    BOOL _hasStringFooter;
    
    float _pullDownOffset;
    BOOL _isPulledOut;
    
    float _touchX;
    float _touchY;
    
    RequestNextPageControl* _requestNextPageControl;
    
    DCTickTimer* _timer;
    
    int _originalCellOffset;
    
    id _draggingCell;
    BOOL _handleDragCell;
    
    int _directionDecisionScenario;
    
    BOOL _hasEnoughItemsForPagination;
    
    
    UITapGestureRecognizer* _tapRecognizer;

    int _itemsCount;
    BOOL _isFetchingNextPage;
    
    BOOL _isPullingDown;
    
    BOOL _isRefreshing;
    
    DCTableViewDataSource* _tableViewDataSource;
    DCTableViewDelegate* _tableViewDelegate;
    
    BOOL _isSectionedData;
    
    NSMutableArray* _sections;
    
    DCWeakSet* _cells;
}

- (UITableView *)tableView;

@property (retain, nonatomic) NSArray* items;
@property (assign, nonatomic) id <ListBoxDelegate> delegate;

@property (retain, nonatomic) UIView* pullDownView;
@property (retain, nonatomic) UIView* paginationView;

@property (nonatomic) int sectionHeaderHeight;
@property (nonatomic) int sectionFooterHeight;
@property (nonatomic) int cellHeight;
@property (nonatomic) int pullDownViewHeight;
@property (nonatomic) int paginationViewHeight;
@property (nonatomic) UIEdgeInsets cellPadding;

@property (nonatomic) BOOL isRefreshable;
@property (nonatomic) BOOL isPaginatable;
@property (nonatomic) BOOL isEditing;
@property (nonatomic) DCListBoxSlideCellMode slideCellMode;
@property (nonatomic) DCListBoxRequirePageMode requirePageMode;
@property (retain, nonatomic) Interpolator* slideInterpolator;
@property (nonatomic) BOOL isCellDraggable;
@property (nonatomic) int selectedSectionIndex;
@property (nonatomic) int selectedItemIndex;

@property (nonatomic) UIColor* selectedCellColor;
@property (nonatomic) DCListBoxCellSelectionColor colorMode;

-(void) setStyle:(UITableViewStyle) style;
-(void) setSeparatorColor:(UIColor*) color;
-(void) setPaginationViewText:(NSString*) text;

-(BOOL) isSectionedData;
-(id) selectedItem;
-(id) itemAtIndexPath:(NSIndexPath*) indexPath;
-(id) itemAtRow:(int) row section:(int) section;


-(void) selectRowAtSection:(int) section position:(int) position;
-(void) scrollToItem:(id) item animated:(BOOL) animated;
-(void) scrollToBottom;
-(void) endRefreshing;
-(void) endRequestingNextPage;
-(void) refresh;
-(void) bindHeaderFooter:(id) item;
-(void) bindItem:(id) item;
-(void) bindAllItems;

-(void) toggleItemsOfSectionAtIndex:(NSInteger) sectionIndex animated:(BOOL) animated;
-(void) toggleItemsOfSection:(id <DCSectionedData>) section animated:(BOOL) animated;

-(void) removeItemAtSection:(int) section position:(int) position;
-(void) moveItemFromSection:(int) fromSection position:(int) fromPosition toSection:(int) toSection position:(int) toPosition;

-(UIView*) headerForSection:(id <DCSectionedData>) section;
-(UIView*) footerForSection:(id <DCSectionedData>) section;
-(UIView*) cellForItem:(id) item;


// Internal methods.

-(int) numberOfRowsInSection:(int) section;
-(UITableViewCell*) cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(CGFloat) heightForRowAtIndexPath:(NSIndexPath*) indexPath;

-(BOOL) isIndexPathOnNextPageButton:(NSIndexPath*) indexPath;

- (float) heightForHeaderInSection:(int)section;
- (UIView *) viewForHeaderInSection:(int)section;
- (float) heightForFooterInSection:(int)section;
- (UIView *) viewForFooterInSection:(int)section;

-(void) didScroll;
-(void) willBeginDecelerating;

-(void) offsetPullDownViewDirectly:(float) scrollY;

-(void) onPullingRelease;
- (void)listboxDidScroll:(UIScrollView *)scrollView;
//

@end
