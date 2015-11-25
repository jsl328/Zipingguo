//
//  DCItemsBox.m
//  Mulberry
//
//  Created by Bob Li on 13-10-22.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCItemsBox.h"
#import "DCSectionedData.h"
#import "ViewLocater.h"
#import "DCItemsBoxSectionHeader.h"
#import "DCItemsBoxSection.h"
#import "DCViewEffects.h"

@implementation DCItemsBox
@synthesize orientation = _orientation;
@synthesize items = _items;
@synthesize layout = _layout;
@synthesize isRefreshable = _isRefreshable;
@synthesize headerViewTypes = _headerViewTypes;
@synthesize footerViewTypes = _footerViewTypes;
@synthesize cellViewTypes = _cellViewTypes;
@synthesize isEditing = _isEditing;
@synthesize cellBorderCornerRadius;
@synthesize cellBorderColor;
@synthesize cellBorderWidth;
@synthesize delegate = _delegate;

-(id) init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
    _orientation = DCOrientationVertical;
    cellBorderCornerRadius = 0;
    cellBorderColor = [UIColor lightGrayColor];
    cellBorderWidth = 1;
    _cells = [[NSMutableArray alloc] init];
}


-(void) setOrientation:(DCOrientation)orientation {
    
    if (_orientation != orientation) {
        _orientation = orientation;
        _layout.orientation = orientation;
        [self updateLayout];
    }
}

-(void) setDelegate:(id<DCItemsBoxDelegate>)delegate {
    _delegate = delegate;
    [self configTapRecognizer];
}

-(void) configTapRecognizer {
    
    BOOL respondsToHeaderFooterClicks = [_delegate respondsToSelector:@selector(itemsBox:didClickSectionHeaderAtSectionIndex:section:)] || [_delegate respondsToSelector:@selector(itemsBox:didClickSectionFooterAtSectionIndex:section:)];

    if (_isEditing || (_isSectionedData && respondsToHeaderFooterClicks)) {
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

-(void) handleTap:(UITapGestureRecognizer*) recognizer {
    if (!_isEditing) {
        [self handleTapBySelectingSection:recognizer];
    }
}

-(void) handleTapBySelectingSection:(UITapGestureRecognizer*) recognizer {
    
    DCItemsBoxHitTestResult result = [_layout hitTestSectionHeaderFooterWithPoint:[recognizer locationInView:self]];
    
    if (result.isHeader && [_delegate respondsToSelector:@selector(itemsBox:didClickSectionHeaderAtSectionIndex:section:)]) {
        [_delegate itemsBox:self didClickSectionHeaderAtSectionIndex:result.sectionIndex section:[_items objectAtIndex:result.sectionIndex]];
    }
    else if (result.isFooter && [_delegate respondsToSelector:@selector(itemsBox:didClickSectionFooterAtSectionIndex:section:)]) {
        [_delegate itemsBox:self didClickSectionFooterAtSectionIndex:result.sectionIndex section:[_items objectAtIndex:result.sectionIndex]];
    }
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    if (!_isEditing) {
        return;
    }
    
    
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    DCItemsBoxHitTestResult result = [_layout hitTestCellWithPoint:point];
    
    if (result.sectionIndex >= 0) {
        _isDraggingCell = YES;
        _draggingCellIndexPath = [NSIndexPath indexPathForItem:result.itemIndex inSection:result.sectionIndex];
        _dragStartX = point.x;
        _dragStartY = point.y;
        _dragCurrentX = _dragStartX;
        _dragCurrentY = _dragStartY;
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    [super touchesMoved:touches withEvent:event];
    
    if (_isDraggingCell) {
        
        UIView* cell = [_collectionView cellForItemAtIndexPath:_draggingCellIndexPath];
        
        UITouch* touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        
        
        cell.layer.transform = CATransform3DMakeTranslation(point.x - _dragStartX, point.y - _dragStartY, 0);
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    _isDraggingCell = NO;
    UIView* cell = [_collectionView cellForItemAtIndexPath:_draggingCellIndexPath];
    cell.layer.transform = CATransform3DIdentity;
}


-(void) setLayout:(DCItemsBoxLayout*) layout {
 
    _layout = layout;
    _layout.orientation = _orientation;
    
    [_collectionView removeFromSuperview];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView reloadData];
}

-(void) setHeaderViewTypes:(NSArray *)headerViewTypes {
    _headerViewTypes = headerViewTypes;
    for (Class type in headerViewTypes) {
        [_collectionView registerClass:[DCItemsBoxSectionHeader class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:[type description]];
    }
}

-(void) setFooterViewTypes:(NSArray *)footerViewTypes {
    _footerViewTypes = footerViewTypes;
    for (Class type in footerViewTypes) {
        [_collectionView registerClass:[DCItemsBoxSectionHeader class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:[type description]];
    }
}

-(void) setCellViewTypes:(NSArray *)cellViewTypes {
    _cellViewTypes = cellViewTypes;
    for (Class type in cellViewTypes) {
       [_collectionView registerClass:[DCItemsBoxCell class] forCellWithReuseIdentifier:[type description]];
    }
}

-(void) setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    [self configTapRecognizer];
}

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return _isEditing ? self : [super hitTest:point withEvent:event];
}


-(void) setIsRefreshable:(BOOL)isRefreshable {
    _isRefreshable = isRefreshable;
    if (_isRefreshable) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refreshControlDidStartRefresh:) forControlEvents:UIControlEventValueChanged];
        [_collectionView addSubview:_refreshControl];
    }
    else {
        [_refreshControl removeTarget:self action:@selector(refreshControlDidStartRefresh:) forControlEvents:UIControlEventValueChanged];
        [_refreshControl removeFromSuperview];
        _refreshControl = nil;
    }
}

-(void) refreshControlDidStartRefresh:(id) sender {
    if (_delegate && [_delegate respondsToSelector:@selector(itemsBoxDidStartPullRefresh:)]) {
        [_delegate itemsBoxDidStartPullRefresh:self];
    }
}

-(void) endRefreshing {
    if (_isRefreshable && _refreshControl.refreshing) {
        [_refreshControl endRefreshing];
    }
}

-(void) setItems:(NSArray *)items {
    
    _items = items;
    _isSectionedData = items.count > 0 && [[items objectAtIndex:0] conformsToProtocol:@protocol(DCSectionedData)];
    
    if (!_cellViewTypes) {
        id firstItem = [self findFirstItem];
        if (firstItem) {
            self.cellViewTypes = @[[ViewLocater viewClassForViewModel:firstItem]];
        }
    }
    
    if (_isSectionedData) {
        
        id <DCSectionedData> section = [_items objectAtIndex:0];
        
        if (!_headerViewTypes && [section respondsToSelector:@selector(header)]) {
            self.headerViewTypes = @[[ViewLocater viewClassForViewModel:section.header]];
        }
        
        if (!_footerViewTypes && [section respondsToSelector:@selector(footer)]) {
            self.footerViewTypes = @[[ViewLocater viewClassForViewModel:section.footer]];
        }
    }
    
    
    _layout.sections = [[NSMutableArray alloc] init];
    for (int i = 1; i <= (_isSectionedData ? _items.count : 1); i++) {
        [_layout.sections addObject:[[DCItemsBoxSection alloc] init]];
    }
    
    
    _selectedItem = nil;
    _selectedIndexPath = nil;
    _hasSelectedItem = NO;
    
    [self configTapRecognizer];
    
    [_collectionView reloadData];
}

-(id) findFirstItem {
    
    if (_items.count == 0) {
        return nil;
    }
    
    if (_isSectionedData) {
        for (id <DCSectionedData> section in _items) {
            for (id item in section.items) {
                if (![item conformsToProtocol:@protocol(DCSectionedData)]) {
                    return item;
                }
            }
        }
    }
    else {
        return [_items objectAtIndex:0];
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (NSInteger)(_isSectionedData ? ((id <DCSectionedData>)[_items objectAtIndex:section]).items.count : _items.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = _isSectionedData ? [((id <DCSectionedData>)[_items objectAtIndex:indexPath.section]).items objectAtIndex:indexPath.item] : [_items objectAtIndex:indexPath.item];
    Class viewClass = [ViewLocater viewClassForViewModel:item];
    
    DCItemsBoxCell* cell = [_collectionView dequeueReusableCellWithReuseIdentifier:[viewClass description] forIndexPath:indexPath];
    if (!cell.isBorderInitialized) {
        cell.isBorderInitialized = YES;
        cell.borderCornerRadius = cellBorderCornerRadius;
        cell.borderColor = cellBorderColor;
        cell.borderWidth = cellBorderWidth;
    }

    if (cell.content != item) {
        cell.content = item;
        cell.isSelected = item == _selectedItem;
    }
    
    if (!cell.isAdded) {
        cell.isAdded = YES;
        [_cells addObject:cell];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isHeader = [kind isEqualToString:@"UICollectionElementKindSectionHeader"];
    BOOL isFooter = [kind isEqualToString:@"UICollectionElementKindSectionFooter"];
    
    if (isHeader || isFooter) {
        
        id <DCSectionedData> section = ((id <DCSectionedData>)[_items objectAtIndex:indexPath.section]);
        
        id data = isHeader ? section.header : section.footer;
        Class viewClass = [ViewLocater viewClassForViewModel:data];
        
        DCItemsBoxSectionHeader* view = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:[viewClass description] forIndexPath:indexPath];
        
        if (view.content != data) {
            view.content = data;
            view.section = section;
            view.isHeader = isHeader;
        }
        
        return view;
    }
    else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_isSectionedData) {
        return _items.count;
    }
    else {
        return _items.count > 0 ? 1 : 0;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_hasSelectedItem) {
        DCItemsBoxCell* previouslySelectedCell = (DCItemsBoxCell*)[_collectionView cellForItemAtIndexPath:_selectedIndexPath];
        if (previouslySelectedCell) {
            previouslySelectedCell.isSelected = NO;
        }
    }
    
    DCItemsBoxCell* cell = (DCItemsBoxCell*)[_collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelected = YES;
    
    _selectedItem = cell.content;
    _selectedIndexPath = indexPath;
    _hasSelectedItem = YES;
    
    if (_delegate) {
        
        if (_isSectionedData && [_delegate respondsToSelector:@selector(itemsBox:didSelectCellAtCellIndex:inSectionIndex:item:)]) {
            [_delegate itemsBox:self didSelectCellAtCellIndex:_selectedIndexPath.item inSectionIndex:_selectedIndexPath.section item:_selectedItem];
            cell.content = _selectedItem;
        }
        else if (!_isSectionedData && [_delegate respondsToSelector:@selector(itemsBox:didSelectCellAtCellIndex:item:)]) {
            [_delegate itemsBox:self didSelectCellAtCellIndex:_selectedIndexPath.item item:_selectedItem];
            cell.content = _selectedItem;
        }
    }
}

-(void) scrollToSelectedItem {
    if (_hasSelectedItem) {
        [_collectionView scrollToItemAtIndexPath:_selectedIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically + UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

-(id) itemAtIndexPath:(NSIndexPath*) indexPath {

    if (_isSectionedData) {
        return [((DCItemsBoxSection*)[_items objectAtIndex:indexPath.section]).items objectAtIndex:indexPath.item];
    }
    else {
        return [_items objectAtIndex:indexPath.item];
    }

}

-(DCItemsBoxCell*) cellAtIndexPath:(NSIndexPath*) indexPath {
    
    
    id item = [self itemAtIndexPath:indexPath];
    
    for (DCItemsBoxCell* cell in _cells) {
        if (cell.content == item) {
            return cell;
        }
    }
    
    return nil;
}

-(void) insertItem:(id) item atIndexPath:(NSIndexPath*) indexPath {
    
    if (_isSectionedData) {
        id <DCSectionedData> section = [_items objectAtIndex:indexPath.section];
        [(NSMutableArray*)section.items insertObject:item atIndex:indexPath.item];
    }
    else {
        [(NSMutableArray*)_items insertObject:item atIndex:indexPath.item];
    }
    
    
    [self updateLayout];
    [_collectionView reloadData];
}

-(void) removeItemsAtIndexPaths:(NSArray*) indexPaths {
    
    NSMutableArray* cells = [[NSMutableArray alloc] init];
    
    for (NSIndexPath* indexPath in indexPaths) {

        if (_isSectionedData) {
            id <DCSectionedData> section = [_items objectAtIndex:indexPath.section];
            [(NSMutableArray*)section.items removeObjectAtIndex:indexPath.item];
        }
        else {
            [(NSMutableArray*)_items removeObjectAtIndex:indexPath.item];
        }
        
        [cells addObject:[_collectionView cellForItemAtIndexPath:indexPath]];
    }

    [DCViewEffects shrinkViews:cells withDuration:0.3 completeCallback:^{
        [self updateLayout];
        [_collectionView reloadData];
    }];
}

-(void) removeItemAtIndexPath:(NSArray*) indexPath {
    [self removeItemsAtIndexPaths:@[indexPath]];
}

-(void) removeItem:(id)item {
    
    NSIndexPath* indexPath = [self indexPathForItem:item];
    if (indexPath) {
        [self removeItemsAtIndexPaths:@[indexPath]];
    }
}

-(void) removeItems:(NSArray *)items {
    
    NSMutableArray* indexPaths = [[NSMutableArray alloc] init];

    for (id item in items) {
        NSIndexPath* indexPath = [self indexPathForItem:item];
        if (indexPath) {
            [indexPaths addObject:indexPath];
        }
    }
    
    if (indexPaths.count > 0) {
        [self removeItemsAtIndexPaths:indexPaths];
    }
}

-(NSIndexPath*) indexPathForItem:(id) item {
    
    if (_isSectionedData) {
        
        int sectionIndex = 0;
        for (id <DCSectionedData> section in _items) {
            NSInteger index = [section.items indexOfObject:item];
            if (index != NSNotFound) {
                return [NSIndexPath indexPathForItem:index inSection:sectionIndex];
            }
            sectionIndex++;
        }
        
        return nil;
    }
    else {
        NSInteger index = [_items indexOfObject:item];
        return index == NSNotFound ? nil : [NSIndexPath indexPathForItem:index inSection:0];
    }
}


-(void) toggleItemsOfSectionAtIndex:(NSInteger) index animated:(BOOL)animated {
    
    if (!_isSectionedData) {
        return;
    }
    
    DCItemsBoxSection* section = [_layout.sections objectAtIndex:index];
    BOOL isHeaderGluedToTop = section.headerAttributes.frame.origin.y <= _collectionView.contentOffset.y;
    
    section.isItemsHidden = !section.isItemsHidden;
    [self updateLayout];
    
    if (!(section.isItemsHidden && isHeaderGluedToTop)) {
        return;
    }
    
    
    float targetOffset = section.headerLayoutPosition + (index == 0 ? _layout.contentPadding.top : _layout.sectionPadding.top);
    
    float maxOffset = _layout.orientation == DCOrientationVertical ? (_layout.collectionViewContentSize.height - _collectionView.frame.size.height) : (_layout.collectionViewContentSize.width - _collectionView.frame.size.width);
    if (maxOffset < 0) {
        maxOffset = 0;
    }
    
    if (targetOffset < 0) {
        targetOffset = 0;
        animated = NO;
    }
    else if (targetOffset > maxOffset) {
        targetOffset = maxOffset;
        animated = NO;
    }
    
    CGPoint point = _layout.orientation == DCOrientationVertical ? CGPointMake(0, targetOffset) : CGPointMake(targetOffset, 0);
    [_collectionView setContentOffset:point animated:animated];
}

-(void) toggleItemsOfSection: (id <DCSectionedData>) section animated:(BOOL)animated {
    if (_isSectionedData) {
        [self toggleItemsOfSectionAtIndex:[_items indexOfObject:section] animated:animated];
    }
}

-(void) updateLayout {
    _layout.size = _orientation == DCOrientationVertical ? self.frame.size.width : self.frame.size.height;
    [_layout performLayoutWithItems:_items isSectionedData:_isSectionedData];
}


-(void) layoutSubviews {
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
    [self updateLayout];
}

@end
