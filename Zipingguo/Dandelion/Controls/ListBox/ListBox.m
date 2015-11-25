//
//  CellList.m
//  Mulberry
//
//  Created by Bob Li on 13-5-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "ListBox.h"
#import "ListBoxCell.h"
#import "DCDirectionDetector.h"
#import "AppContext.h"
#import "DCListBoxItemDataSource.h"
#import "BindingContext.h"
#import "DCSectionedData.h"
#import "DCTableViewDataSource.h"
#import "DCTableViewTextHeaderDataSource.h"
#import "DCTableViewTextFooterDataSource.h"
#import "DCTableViewTextHeaderFooterDataSource.h"
#import "DCTableViewHeaderDelegate.h"
#import "DCTableViewFooterDelegate.h"
#import "DCTableViewHeaderFooterDelegate.h"
#import "DCListBoxHeaderFooterCell.h"
#import "DCListBoxSection.h"
#import "DCDirectionDispatcher.h"
#import "WaitBox.h"
#import "DCCellHeightDataSource.h"

@implementation ListBox
@synthesize sectionHeaderHeight;
@synthesize sectionFooterHeight;
@synthesize cellHeight;
@synthesize items;
@synthesize delegate = _delegate;
@synthesize isRefreshable = _isRefreshable;
@synthesize isPaginatable = _isPaginatable;
@synthesize selectedCellColor;
@synthesize colorMode;
@synthesize isEditing = _isEditing;
@synthesize isCellDraggable = _isCellDraggable;
@synthesize selectedSectionIndex;
@synthesize selectedItemIndex;
@synthesize cellPadding;
@synthesize pullDownView = _pullDownView;
@synthesize paginationView = _paginationView;
@synthesize pullDownViewHeight;
@synthesize paginationViewHeight;

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) setStyle:(UITableViewStyle) style {
    
    [_tableView removeFromSuperview];
    //_tableView.delegate=self;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:style];
    [self addSubview:_tableView];
    
    [self layoutSubviews];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0)
{
    
}
-(void) setSeparatorColor:(UIColor *)color {
    _tableView.separatorColor = color;
}

-(void) setPullDownView:(UIView *)pullDownView {
    _pullDownView = pullDownView;
    [self insertSubview:pullDownView atIndex:0];
    self.clipsToBounds = _pullDownView != nil;
}


-(void) initialize {
    
    [self setStyle:UITableViewStylePlain];
    
    items = [[NSMutableArray alloc] init];
    cellHeight = [_tableView rowHeight];
    sectionHeaderHeight = [_tableView sectionHeaderHeight];
    sectionFooterHeight = [_tableView sectionFooterHeight];
    selectedCellColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    pullDownViewHeight = 44;
    paginationViewHeight = 44;
    colorMode = DCListBoxCellSelectionColorCustom;
    _tableView.backgroundColor = [UIColor clearColor];
    _cells = [[DCWeakSet alloc] init];
}

-(void) setIsRefreshable:(BOOL)isRefreshable {
    _isRefreshable = isRefreshable;
    if (isRefreshable) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_tableView addSubview:_refreshControl];
        [_refreshControl addTarget:self action:@selector(refreshControlDidStartRefresh:) forControlEvents:UIControlEventValueChanged];
    }
    else {
        [_refreshControl removeFromSuperview];
        _refreshControl = nil;
    }
}

-(void) setPaginationView:(UIView *)paginationView {
    
    _requestNextPageControl = [[RequestNextPageControl alloc] init];
    _requestNextPageControl.frame = CGRectMake(0, 0, self.frame.size.width, paginationViewHeight);
    _requestNextPageControl.delegate = self;
    
    _paginationView = paginationView;
    _requestNextPageControl.paginationView = paginationView;
}

-(void) setPaginationViewText:(NSString*) text {
    
    UILabel* label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    [self setPaginationView:label];
}

-(void) setIsEditing:(BOOL)isEditing {
    
    _isEditing = isEditing;
    
    if (isEditing) {
        [self deselectCell];
    }
    
    [_tableView setEditing:isEditing animated:YES];
}

-(void) deselectCell {
    
    id selectedItem = [self selectedItem];
    selectedSectionIndex = -1;
    selectedItemIndex = -1;
    [self bindItem:selectedItem];
}


-(DCDirectionDecision) decisionFromDirection:(DCMoveDirection)direction touch:(UITouch*) touch xDirection:(int)xDirection yDirection:(int)yDirection {
    
    _directionDecisionScenario = -1;
    
    DCDirectionDecision decision = DCDirectionDecisionDiscard;
    
    if (_pullDownView && (_pullDownOffset > 0 || (_tableView.contentOffset.y == 0 && yDirection == 1))) {
        _directionDecisionScenario = 0;
        decision = DCDirectionDecisionSieze;
    }
    
    if (_handleDragCell && (direction == DCMoveDirectionLeft || direction == DCMoveDirectionRight)) {
        
        CGPoint point = [touch locationInView:self];
        _draggingCell = [self findDraggingCellWithPoint:point];
        id <DCListBoxItemDataSource> item = ((ListBoxCell*)_draggingCell).item;
        
        if (_draggingCell && [item respondsToSelector:@selector(minDragOffset)] && [item respondsToSelector:@selector(maxDragOffset)]) {
            _originalCellOffset = [item dragOffset];
            _directionDecisionScenario = 1;
            decision = DCDirectionDecisionAccept;
        }
    }
    
    return decision;
}

-(BOOL) isProperDirection:(DCMoveDirection)direction {
    
    if (_directionDecisionScenario == 0) {
        return direction == DCMoveDirectionDown;
    }
    else if (_directionDecisionScenario == 1) {
        return _handleDragCell && (direction == DCMoveDirectionLeft || direction == DCMoveDirectionRight);
    }
    else {
        return false;
    }
}

-(void) directionTouchesBegan:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:self];
    
    _touchX = point.x;
    _touchY = point.y;
}

-(void) directionTouchesMoved:(UITouch *)touch {
    
    CGPoint point = [touch locationInView:self];
    
    if (_directionDecisionScenario == 0) {
        [self offsetPullDownView:point.y];
    }
    else {
        [self offsetDraggingCell:point.x];
    }
}

-(void) directionTouchesEnded:(UITouch *)touch {
    
    if (_directionDecisionScenario == 0) {
        [self onPullingRelease];
    }
    else {
        [self onDraggingCellRelease];
    }
}

-(void) onPullingRelease {
    
    int targetOffset;
    
    if (_isPulledOut) {
        targetOffset = _pullDownOffset <= self.pullDownViewHeight - 10 ? 0 : self.pullDownViewHeight;
    }
    else {
        targetOffset = _pullDownOffset >= 10 ? self.pullDownViewHeight : 0;
    }
    
    double duration = ABS(targetOffset - _pullDownOffset) * 0.005;
    _pullDownOffset = targetOffset;
    
    [UIView animateWithDuration:duration animations:^{
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        _isPulledOut = _pullDownOffset == self.pullDownViewHeight;
        if (!_isPulledOut) {
            [self.pullDownView resignFirstResponder];
        }
    }];
}

-(void) onDraggingCellRelease {
    
    id <DCListBoxItemDataSource> item = ((ListBoxCell*)_draggingCell).item;
    
    
    int targetOffset = 0;
    
    if (DCMathAbs([item dragOffset] - _originalCellOffset) < 10) {
        targetOffset = _originalCellOffset;
    }
    else {
        targetOffset = _originalCellOffset == [item maxDragOffset] ? [item minDragOffset] : [item maxDragOffset];
    }
    
    
    if (!_timer) {
        _timer = [[DCTickTimer alloc] init];
        _timer.delegate = self;
    }
    
    
    [_timer setRangeFrom:[item dragOffset] to:targetOffset changedInDuration:DCMathAbs([item dragOffset] - targetOffset) * 0.001];
    [_timer start];
}

-(void) offsetDraggingCell:(float) x {
    
    id <DCListBoxItemDataSource> item = ((ListBoxCell*)_draggingCell).item;
    
    float offset = [item dragOffset] + (x - _touchX);
    
    if (offset < [item minDragOffset]) {
        offset = [item minDragOffset];
    }
    else if (offset > [item maxDragOffset]) {
        offset = [item maxDragOffset];
    }
    
    _touchX += offset - [item dragOffset];
    
    [item setDragOffset:offset];
    [self.delegate listBox:self didDragItem:item offset:offset];
}

-(void) offsetPullDownView:(float) y {
    
    float offset = _pullDownOffset + (y - _touchY);
    
    if (offset < 0) {
        offset = 0;
    }
    else if (offset > self.pullDownViewHeight) {
        offset = self.pullDownViewHeight;
    }
    
    _touchY += offset - _pullDownOffset;
    _pullDownOffset = offset;
    [self layoutSubviews];
}

-(void) timer:(id)timer didTickWithValue:(float)value {
    
    id <DCListBoxItemDataSource> item = ((ListBoxCell*)_draggingCell).item;
    [item setDragOffset:value];
    
    [self.delegate listBox:self didDragItem:item offset:value];
}


-(ListBoxCell*) findDraggingCellWithPoint:(CGPoint) point {
    
    float x = point.x;
    float y = point.y + _tableView.contentOffset.y;
    
    for (ListBoxCell* cell in _cells.objectEnumerator) {
        if (cell.itemIndex >= 0 && x >= cell.frame.origin.x && x <= cell.frame.origin.x + cell.frame.size.width && y >= cell.frame.origin.y && y <= cell.frame.origin.y + cell.frame.size.height) {
            return cell;
        }
    }
    
    return nil;
}

-(void) refreshControlDidStartRefresh:(id) sender {
    if (_delegate && [_delegate respondsToSelector:@selector(listBoxDidStartRefresh:)]) {
        [WaitBox defaultWaitBox].isSupressed = YES;
        [_delegate listBoxDidStartRefresh:self];
    }
    else {
        [self endRefreshing];
    }
}

-(void) requestNextPageControlDidClick {
    if (_delegate && [_delegate respondsToSelector:@selector(listBoxDidRequestPage:)]) {
        _isFetchingNextPage= YES;
        [_delegate listBoxDidRequestPage:self];
    }
    else {
        [self endRequestingNextPage];
    }
}


-(void) endRefreshing {
    [WaitBox defaultWaitBox].isSupressed = NO;
    if (_isRefreshable && _refreshControl.isRefreshing) {
        [_refreshControl endRefreshing];
    }
}

-(void) endRequestingNextPage {
    if (_isPaginatable && _requestNextPageControl.isRefreshing) {
        [_requestNextPageControl endRefreshing];
    }
}


-(void) configTapRecognizer {
    
    BOOL respondsToHeaderFooterClicks = [_delegate respondsToSelector:@selector(listBox:didClickSectionHeaderAtSectionIndex:section:)] || [_delegate respondsToSelector:@selector(listBox:didClickSectionFooterAtSectionIndex:section:)];
    
    if (_isSectionedData && respondsToHeaderFooterClicks) {
        if (!_tapRecognizer) {
            _tapRecognizer = [[UITapGestureRecognizer alloc] init];
            _tapRecognizer.cancelsTouchesInView = NO;
            [self addGestureRecognizer:_tapRecognizer];
            [_tapRecognizer addTarget:self action:@selector(handleTap:)];
        }
    }
    else if (_tapRecognizer) {
        [self removeGestureRecognizer:_tapRecognizer];
        [_tapRecognizer removeTarget:self action:@selector(handleTap:)];
        _tapRecognizer = nil;
    }
}

-(void) setIsCellDraggable:(BOOL)isCellDraggable {
    _isCellDraggable = isCellDraggable;
    [self configSwipe];
}

-(void) configSwipe {
    _handleDragCell = _isCellDraggable && ([_delegate respondsToSelector:@selector(listBox:didDragItem:offset:)] || [_delegate respondsToSelector:@selector(listBox:didReleaseItem:offset:isFling:)]);
}


-(void) handleTap:(UITapGestureRecognizer*) recognizer {
    [self handleTapByHitTestingSectionHeaderFooter:recognizer];
}

-(void) handleTapByHitTestingSectionHeaderFooter:(UITapGestureRecognizer*) recognizer {
    
    CGPoint point = [recognizer locationInView:self];
    UITableViewHeaderFooterView* view = [self hitTestSectionHeaderFooterViewWithPoint:CGPointMake(point.x, point.y + _tableView.contentOffset.y)];
    
    if (!view) {
        return;
    }
    
    
    int sectionIndex = -1;
    BOOL isHeader;
    
    if ([[view class] isSubclassOfClass:[DCListBoxHeaderFooterCell class]]) {
        DCListBoxHeaderFooterCell* cell = (DCListBoxHeaderFooterCell*)view;
        sectionIndex = cell.sectionIndex;
        isHeader = cell.isHeader;
    }
    else {
        for (int i = 0; i <= items.count - 1; i++) {
            
            UIView* header = [_tableView headerViewForSection:i];
            if (header == view) {
                sectionIndex = i;
                isHeader = YES;
                break;
            }
            
            UIView* footer = [_tableView footerViewForSection:i];
            if (footer == view) {
                sectionIndex = i;
                isHeader = NO;
                break;
            }
        }
    }
    
    if (sectionIndex == -1) {
        return;
    }
    
    
    if (isHeader && [_delegate respondsToSelector:@selector(listBox:didClickSectionHeaderAtSectionIndex:section:)]) {
        [_delegate listBox:self didClickSectionHeaderAtSectionIndex:sectionIndex section:[items objectAtIndex:sectionIndex]];
    }
    else if (!isHeader && [_delegate respondsToSelector:@selector(listBox:didClickSectionFooterAtSectionIndex:section:)]) {
        [_delegate listBox:self didClickSectionFooterAtSectionIndex:sectionIndex section:[items objectAtIndex:sectionIndex]];
    }
}

-(UITableViewHeaderFooterView*) hitTestSectionHeaderFooterViewWithPoint:(CGPoint) point {
    
    for (UIView* view in _tableView.subviews) {
        if ([[view class] isSubclassOfClass:[UITableViewHeaderFooterView class]]) {
            if (point.x >= view.frame.origin.x && point.x <= view.frame.origin.x + view.frame.size.width && point.y >= view.frame.origin.y && point.y <= view.frame.origin.y + view.frame.size.height) {
                return (UITableViewHeaderFooterView*)view;
            }
        }
    }
    
    return nil;
}


-(void) toggleItemsOfSectionAtIndex:(NSInteger) sectionIndex animated:(BOOL)animated {
    
    if (!_isSectionedData) {
        return;
    }
    
    DCListBoxSection* section = [_sections objectAtIndex:sectionIndex];
    //    section.isItemsHidden = !section.isItemsHidden;
    
    //    UIView* header = [_tableView headerViewForSection:sectionIndex];
    //    BOOL isHeaderGluedToTop = header.frame.origin.y <= _tableView.contentOffset.y;
    
    [_tableView reloadData];
    
    //    if (section.isItemsHidden && isHeaderGluedToTop) {
    //    if (section.isItemsHidden) {
    //        float height = 0;
    float height = section.top;
    if (sectionIndex > 0) {
        for (int i = 0; i <= sectionIndex - 1; i++) {
            //                DCListBoxSection* s = [_sections objectAtIndex:i];
            //                height += s.headerHeight + s.footerHeight + (s.isItemsHidden ? 0 : s.contentHeight);
            id <DCSectionedData> section = [items objectAtIndex:i];
            height += section.headerHeight;
        }
    }
    
    
    if (height < 0) {
        height = 0;
        animated = NO;
    }
    //        else if (height > _tableView.contentSize.height - _tableView.frame.size.height) {
    //            height = _tableView.contentSize.height - _tableView.frame.size.height;
    //            animated = NO;
    //        }
    
    
    [_tableView setContentOffset:CGPointMake(0, height) animated:animated];
    //    }
}

-(void) toggleItemsOfSection:(id <DCSectionedData>) section animated:(BOOL)animated {
    if (_isSectionedData) {
        [self toggleItemsOfSectionAtIndex:[items indexOfObject:section] animated:animated];
    }
}


-(void) addNewItemsToList {
    
    int itemsAdded = 0;
    
    if (items.count > 0) {
        if (!_isSectionedData) {
            itemsAdded = (int)items.count - _itemsCount;
        }
        else {
            int count = 0;
            for (id <DCSectionedData> section in items) {
                count += section.items.count;
            }
            
            itemsAdded = count - _itemsCount;
        }
    }
    
    _itemsCount += itemsAdded;
    [_tableView reloadData];
}

-(void) setItems:(NSMutableArray*) newItems {
    
    [self endRefreshing];
    [self endRequestingNextPage];
    
    for (ListBoxCell* cell in _cells.objectEnumerator) {
        cell.sectionIndex = -1;
        cell.sectionIndex = -1;
        //        cell.item = nil;
    }
    
    _itemsCount= 0;
    selectedSectionIndex = -1;
    selectedItemIndex = -1;
    items = newItems;
    _isSectionedData = items.count > 0 && [[items objectAtIndex:0] conformsToProtocol:@protocol(DCSectionedData)];
    
    if (_isSectionedData) {
        [self populateSections];
    }
    
    [self setDataSourceAndDelegate];
    [self addNewItemsToList];
    
    [self configTapRecognizer];
}

-(void) populateSections {
    
    _sections = [[NSMutableArray alloc] init];
    float top = 0;
    
    for (int i = 0; i <= items.count - 1; i++) {
        
        DCListBoxSection* section = [[DCListBoxSection alloc] init];
        section.top = top;
        
        if (_hasHeader) {
            section.headerHeight = _hasStringHeader ? _tableView.sectionHeaderHeight : [_tableViewDelegate tableView:_tableView heightForHeaderInSection:i];
        }
        else {
            section.headerHeight = 0;
        }
        
        if (_hasFooter) {
            section.footerHeight = _hasStringFooter ? _tableView.sectionFooterHeight : [_tableViewDelegate tableView:_tableView heightForFooterInSection:i];
        }
        else {
            section.footerHeight = 0;
        }
        
        id <DCSectionedData> s = [items objectAtIndex:i];
        if (s.items.count > 0) {
            
            BOOL vmSpecifiesCellHeight = [[s.items objectAtIndex:0] respondsToSelector:@selector(cellHeight)];
            section.contentHeight = 0;
            
            if (vmSpecifiesCellHeight) {
                for (int item = 0; item <= s.items.count - 1; item++) {
                    section.contentHeight += [_tableViewDelegate tableView:_tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:item inSection:i]];
                }
            }
            else {
                section.contentHeight = s.items.count * cellHeight;
            }
        }
        
        top += section.headerHeight + section.footerHeight + section.contentHeight;
        
        [_sections addObject:section];
    }
}

-(void) setDelegate:(id<ListBoxDelegate>)delegate {
    _delegate = delegate;
    [self configTapRecognizer];
    [self configSwipe];
}

-(void) setDataSourceAndDelegate {
    
    _hasHeader = _isSectionedData && [[items objectAtIndex:0] respondsToSelector:@selector(header)];
    _hasStringHeader = _hasHeader && [[((id <DCSectionedData>)[items objectAtIndex:0]).header class] isSubclassOfClass:[NSString class]];
    BOOL hasObjectHeader = _hasHeader && !_hasStringHeader;
    _hasFooter = _isSectionedData && [[items objectAtIndex:0] respondsToSelector:@selector(footer)];
    _hasStringFooter = _hasFooter && [[((id <DCSectionedData>)[items objectAtIndex:0]).footer class] isSubclassOfClass:[NSString class]];
    BOOL hasObjectFooter = _hasFooter && !_hasStringFooter;
    
    if (!_hasStringHeader && !_hasStringFooter) {
        _tableViewDataSource = [[DCTableViewDataSource alloc] init];
    }
    else if (_hasStringHeader && !_hasStringFooter) {
        _tableViewDataSource = [[DCTableViewTextHeaderDataSource alloc] init];
    }
    else if (!_hasStringHeader && _hasStringFooter) {
        _tableViewDataSource = [[DCTableViewTextFooterDataSource alloc] init];
    }
    else if (_hasStringHeader && _hasStringFooter) {
        _tableViewDataSource = [[DCTableViewTextHeaderFooterDataSource alloc] init];
    }
    
    if (!hasObjectHeader && !hasObjectFooter) {
        _tableViewDelegate = [[DCTableViewDelegate alloc] init];
    }
    else if (hasObjectHeader && !hasObjectFooter) {
        _tableViewDelegate = [[DCTableViewHeaderDelegate alloc] init];
    }
    else if (!hasObjectHeader && hasObjectFooter) {
        _tableViewDelegate = [[DCTableViewFooterDelegate alloc] init];
    }
    else if (hasObjectHeader && hasObjectFooter) {
        _tableViewDelegate = [[DCTableViewHeaderFooterDelegate alloc] init];
    }
    
    _tableViewDataSource.listBox = self;
    _tableView.dataSource = _tableViewDataSource;
    
    _tableViewDelegate.listBox = self;
    _tableView.delegate = _tableViewDelegate;
}


-(id) itemAtRow:(int) row section:(int) section {
    
    if (_isSectionedData) {
        return [((id <DCSectionedData>)[items objectAtIndex:section]).items objectAtIndex:row];
    }
    else {
        return [items objectAtIndex:row];
    }
}

-(id) itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self itemAtRow:(int)indexPath.row section:(int)indexPath.section];
}

-(id) selectedItem {
    return selectedSectionIndex == -1 || selectedItemIndex == -1 ? nil : [self itemAtRow:selectedItemIndex section:selectedSectionIndex];
}


-(void) reloadData {
    
    for (ListBoxCell* cell in _cells.objectEnumerator) {
        cell.sectionIndex = -1;
        cell.itemIndex = -1;
        cell.item = nil;
    }
    
    [_tableView reloadData];
}

-(BOOL) isSectionedData {
    return _isSectionedData;
}

-(void) bindHeaderFooter:(id) item {
    
    UIView* cellView = [BindingContext viewForViewModel:item];
    DCListBoxHeaderFooterCell* cellForItem;
    for (DCListBoxHeaderFooterCell* cell in _cells.objectEnumerator) {
        if ([[cell class] isSubclassOfClass:[DCListBoxHeaderFooterCell class]] && cell.cellView == cellView) {
            cellForItem = cell;
            break;
        }
    }
    
    if (cellForItem) {
        [cellForItem bind];
    }
}

-(void) bindItem:(id) item {
    
    ListBoxCell* cellForItem;
    for (ListBoxCell* cell in _cells.objectEnumerator) {
        if ([[cell class] isSubclassOfClass:[ListBoxCell class]] && cell.item == item) {
            cellForItem = cell;
            break;
        }
    }
    
    if (cellForItem) {
        [cellForItem bind];
    }
}

-(void) bindAllItems {
    for (id item in _cells.objectEnumerator) {
        if ([[item class] isSubclassOfClass:[ListBoxCell class]]) {
            [(ListBoxCell*)item bind];
        }
        else {
            [(DCListBoxHeaderFooterCell*)item bind];
        }
    }
}

-(void) removeItemAtSection:(int) section position:(int) position {
    
    if (_isSectionedData) {
        [(NSMutableArray*)((id <DCSectionedData>)[items objectAtIndex:section]).items removeObjectAtIndex:position];
    }
    else {
        [(NSMutableArray*)items removeObjectAtIndex:position];
    }
    
    _itemsCount--;
    [self reloadData];
}

-(void) moveItemFromSection:(int) fromSection position:(int) fromPosition toSection:(int) toSection position:(int) toPosition {
    
    id item = [self itemAtRow:fromPosition section:fromSection];
    
    if (_isSectionedData) {
        [(NSMutableArray*)((id <DCSectionedData>)[items objectAtIndex:fromSection]).items removeObjectAtIndex:fromPosition];
        [(NSMutableArray*)((id <DCSectionedData>)[items objectAtIndex:toSection]).items insertObject:item atIndex:toPosition];
    }
    else {
        NSMutableArray* itemsArray = (NSMutableArray*)items;
        [itemsArray removeObjectAtIndex:fromPosition];
        [itemsArray insertObject:item atIndex:toPosition];
    }
    
    [self reloadData];
}


-(int) numberOfRowsInSection:(int) section {
    
    NSInteger count;
    
    if (!_isSectionedData) {
        count = items.count;
    }
    else {
        DCListBoxSection* s = [_sections objectAtIndex:section];
        count = !s.isItemsHidden ? ((id <DCSectionedData>)[items objectAtIndex:section]).items.count : 0;
    }
    
    
    if (self.isPaginatable && (!_isSectionedData || section == items.count - 1)) {
        count++;
    }
    
    return (int)count;
}


-(UITableViewCell*) cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isIndexPathOnNextPageButton:indexPath]) {
        return _requestNextPageControl;
    }
    
    
    ListBoxCell* cell = [_tableView dequeueReusableCellWithIdentifier:[[[self itemAtIndexPath:indexPath] class] description]];
    
    BOOL isNewCell = NO;;
    
    if (!cell) {
        isNewCell = YES;
        cell = [[ListBoxCell alloc] initWithSelectedColor:selectedCellColor mode:colorMode];
        cell.listBox = self;
        [_cells addObject:cell];
    }
    
    if (cell.sectionIndex != indexPath.section || cell.itemIndex != indexPath.row) {
        cell.sectionIndex = (int)indexPath.section;
        cell.itemIndex = (int)indexPath.row;
        cell.item = [self itemAtIndexPath:indexPath];
        [cell bind];
    }
    
    if (isNewCell) {
        cell.cellView.backgroundColor = [UIColor clearColor];
    }
    if (_isPaginatable&&_tableView.contentSize.height<=(_tableView.contentOffset.y+self.frame.size.height)) {
        [_requestNextPageControl didClickMaskButton:nil];
    }
    return cell;
}
-(CGFloat) heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    
    if ([self isIndexPathOnNextPageButton:indexPath]) {
        return paginationViewHeight;
    }
    
    
    id item = [self itemAtIndexPath:indexPath];
    
    if ([item conformsToProtocol:@protocol(DCCellHeightDataSource)] && [item respondsToSelector:@selector(cellHeight)]) {
        return ((id <DCCellHeightDataSource>)item).cellHeight;
    }
    else {
        return cellHeight;
    }
}

-(BOOL) isIndexPathOnNextPageButton:(NSIndexPath*) indexPath {
    
    if (_isPaginatable) {
        if (!_isSectionedData) {
            if (indexPath.row == _itemsCount) {
                return YES;
            }
        }
        else {
            if (indexPath.section == _itemsCount - 1 && indexPath.row == ((id <DCSectionedData>)[items objectAtIndex:_itemsCount - 1]).items.count) {
                return YES;
            }
        }
    }
    
    return NO;
}


- (float) heightForHeaderInSection:(int)section {
    
    id <DCSectionedData> sectionData = [items objectAtIndex:section];
    
    if ([sectionData respondsToSelector:@selector(headerHeight)]) {
        return sectionData.headerHeight;
    }
    else {
        return sectionHeaderHeight;
    }
}

- (UIView *) viewForHeaderInSection:(int)section {
    
    id <DCSectionedData> sectionData = [items objectAtIndex:section];
    DCListBoxHeaderFooterCell* cell = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:[[sectionData.header class] description]];
    
    if (!cell) {
        cell = [[DCListBoxHeaderFooterCell alloc] init];
        cell.listBox = self;
        [_cells addObject:cell];
    }
    
    
    if (!cell.isHeader || cell.sectionIndex != section) {
        cell.sectionIndex = section;
        cell.isHeader = YES;
        [cell bind];
    }
    
    return cell;
}

- (float) heightForFooterInSection:(int)section {
    
    id <DCSectionedData> sectionData = [items objectAtIndex:section];
    
    if ([sectionData respondsToSelector:@selector(footerHeight)]) {
        return sectionData.footerHeight;
    }
    else {
        return sectionFooterHeight;
    }
}

- (UIView *) viewForFooterInSection:(int)section {
    
    id <DCSectionedData> sectionData = [items objectAtIndex:section];
    DCListBoxHeaderFooterCell* cell = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:[[sectionData.footer class] description]];
    
    if (!cell) {
        cell = [[DCListBoxHeaderFooterCell alloc] init];
        cell.listBox = self;
        [_cells addObject:cell];
    }
    
    
    if (cell.isHeader || cell.sectionIndex != section) {
        cell.sectionIndex = section;
        cell.isHeader = NO;
        [cell bind];
    }
    
    return cell;
}

-(void) selectRowAtSection:(int)section position:(int)position {
    
    if ([[DCDirectionDispatcher defaultDispatcher] targetFound]) {
        return;
    }
    
    if (_paginationView != nil && [self isIndexPathOnNextPageButton:[NSIndexPath indexPathForRow:position inSection:section]]) {
        return;
    }
    
    
    id selectedItem = self.selectedItem;
    self.selectedSectionIndex = -1;
    self.selectedItemIndex = -1;
    [self bindItem:selectedItem];
    
    self.selectedSectionIndex = section;
    self.selectedItemIndex = position;
    [self bindItem:self.selectedItem];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(listBox:didSelectItem:)]) {
        [self.delegate listBox:self didSelectItem:self.selectedItem];
    }
}


-(void) collapsePullDownView {
    
    _pullDownOffset = 0;
    [self layoutSubviews];
}

-(void) collapsePullDownViewWithDuration:(NSTimeInterval) duration {
    
    [UIView animateWithDuration:duration animations:^{
        [self collapsePullDownView];
    }];
}


-(void) scrollToBottom {
    
    float targetOffset = _tableView.contentSize.height - self.frame.size.height;
    
    if (targetOffset >= 0) {
        _tableView.contentOffset = CGPointMake(0, targetOffset);
    }
}


-(void) willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (!newWindow) {
        [[DCDirectionDispatcher defaultDispatcher] unregisterHandler:self];
    }
    else {
        [[DCDirectionDispatcher defaultDispatcher] registerHandler:self];
    }
}

-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    if (_pullDownView) {
        
        _pullDownView.frame = CGRectMake(0, -self.pullDownViewHeight + _pullDownOffset, self.frame.size.width, self.pullDownViewHeight);
        _tableView.frame = CGRectMake(0, _pullDownOffset, self.frame.size.width, self.frame.size.height);
    }
    else {
        _tableView.frame = self.bounds;
    }
    
    _requestNextPageControl.frame = CGRectMake(0, 0, self.frame.size.width, paginationViewHeight);
}

-(void) refresh {
    [self setItems:items];
}

- (UITableView *)tableView{
    return _tableView;
}

- (void)listboxDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(listBox:didScroll:)]) {
        [self.delegate listBox:self didScroll:scrollView];
    }
}

@end
