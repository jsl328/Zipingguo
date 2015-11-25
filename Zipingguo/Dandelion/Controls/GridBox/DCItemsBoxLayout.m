//
//  DCItemsBoxLayout.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-11.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCItemsBoxLayout.h"
#import "DCItemsBoxSection.h"
#import "DCItemsBoxLayoutAttributes.h"

@implementation DCItemsBoxLayout
@synthesize orientation;
@synthesize size = _size;
@synthesize headerHeight;
@synthesize footerHeight;
@synthesize sectionPadding;
@synthesize contentPadding;
@synthesize sectionGap;
@synthesize isHeaderSticky;
@synthesize isFooterSticky;
@synthesize sections;

-(id) init {
    self = [super init];
    if (self) {
        orientation = DCOrientationVertical;
        headerHeight = 21;
        footerHeight = 21;
        sections = [[NSMutableArray alloc] init];
        _attributesList = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) setSize:(int)size {
    if (_size != size) {
        _size = size;
        [self sizeDidChange];
    }
}

-(DCItemsBoxHitTestResult) hitTestSectionHeaderFooterWithPoint:(CGPoint)point {

    
    DCItemsBoxHitTestResult result;
    result.sectionIndex = -1;
    result.isHeader = NO;
    result.isFooter = NO;
    
    float x = point.x + self.collectionView.contentOffset.x;
    float y = point.y + self.collectionView.contentOffset.y;

    for (int i = _startSectionIndex; i <= _endSectionIndex; i++) {
        
        DCItemsBoxSection* section = [sections objectAtIndex:i];
        
        CGRect headerRect = section.headerAttributes.frame;
        if (x >= headerRect.origin.x && x <= headerRect.origin.x + headerRect.size.width && y >= headerRect.origin.y && y <= headerRect.origin.y + headerRect.size.height) {
            result.isHeader = YES;
            result.sectionIndex = i;
            break;
        }
        
        CGRect footerRect = section.footerAttributes.frame;
        if (x >= footerRect.origin.x && x <= footerRect.origin.x + footerRect.size.width && y >= footerRect.origin.y && y <= footerRect.origin.y + footerRect.size.height) {
            result.isFooter = YES;
            result.sectionIndex = i;
            break;
        }
    }
    
    return result;
}

-(DCItemsBoxHitTestResult) hitTestCellWithPoint:(CGPoint)point {

    
    DCItemsBoxHitTestResult result;
    result.sectionIndex = -1;
    
    float x = point.x + self.collectionView.contentOffset.x;
    float y = point.y + self.collectionView.contentOffset.y;
    
    for (int i = _startIndex; i <= _endIndex; i++) {
        
        DCItemsBoxLayoutAttributes* attributes = [_attributesList objectAtIndex:i];
        if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
  
            float px1;
            float px2;
            float rx1;
            float rx2;
            float size1;
            float size2;
            
            if (orientation == DCOrientationVertical) {
                px1 = x;
                px2 = y;
                rx1 = attributes.frame.origin.x;
                rx2 = attributes.frame.origin.y;
                size1 = attributes.frame.size.width;
                size2 = attributes.frame.size.height;
            }
            else {
                px1 = y;
                px2 = x;
                rx1 = attributes.frame.origin.y;
                rx2 = attributes.frame.origin.x;
                size1 = attributes.frame.size.height;
                size2 = attributes.frame.size.width;
            }
        
            
            if (px1 >= rx1 && px1 <= rx1 + size1 && px2 >= rx2 && px2 <= rx2 + size2) {
                result.sectionIndex = attributes.indexPath.section;
                result.itemIndex = attributes.indexPath.item;
                break;
            }
        }
    }
    
    return result;
}



-(void) sizeDidChange {
}

+ (Class)layoutAttributesClass {
    return [DCItemsBoxLayoutAttributes class];
}


-(void) performLayoutWithItems:(NSArray*) items isSectionedData:(BOOL) isSectionedData {
    
    _isSectionedData = isSectionedData;
    
    [_attributesList removeAllObjects];
    
    float currentSectionGap = contentPadding.top;
    _top = 0;
    
    int sectionIndex = 0;
    
    if (isSectionedData) {
        for (id <DCSectionedData> section in items) {

            DCItemsBoxSection* sectionAttributes = [sections objectAtIndex:sectionIndex];
            [sectionAttributes reset];
            
            if ([section respondsToSelector:@selector(header)]) {
                
                DCItemsBoxLayoutAttributes* attributes = [DCItemsBoxLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
                attributes.zIndex = 1;
                
                int length = [section respondsToSelector:@selector(headerHeight)] ? section.headerHeight: headerHeight;
                
                attributes.layoutRect = CGRectMake(0, _top, _size, length + currentSectionGap);
                attributes.frame = DCRectMake(0, _top + currentSectionGap, _size, length, orientation);
                
                [_attributesList addObject:attributes];
                
                
                sectionAttributes.hasHeader = YES;
                sectionAttributes.headerAttributes = attributes;
                sectionAttributes.headerLayoutPosition = _top;
                sectionAttributes.headerRenderPosition = _top +currentSectionGap;
                sectionAttributes.headerLength = length;

                _top += length + currentSectionGap;
            }
            
            
            if (!sectionAttributes.isItemsHidden) {
                [self performLayoutWithItems:section.items inSection:sectionAttributes sectionIndex:sectionIndex];
            }
            
            sectionAttributes.contentRenderTop = _top - sectionAttributes.contentLength;
            
            
            if ([section respondsToSelector:@selector(footer)]) {
                
                sectionAttributes.contentLength += sectionPadding.bottom;

                DCItemsBoxLayoutAttributes* attributes = [DCItemsBoxLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex]];
                attributes.zIndex = 1;
                
                
                int length = [section respondsToSelector:@selector(footerHeight)] ? section.footerHeight: footerHeight;
                
                attributes.layoutRect = CGRectMake(0, _top, _size, length + sectionPadding.bottom);
                attributes.frame = DCRectMake(0, _top, _size, length, orientation);
                [_attributesList addObject:attributes];
                
                
                sectionAttributes.hasFooter = YES;
                sectionAttributes.footerAttributes = attributes;
                sectionAttributes.footerLayoutPosition = _top;
                sectionAttributes.footerRenderPosition = _top + sectionPadding.bottom;
                sectionAttributes.footerLength = length;
                
                _top += length + sectionPadding.bottom;
            }
            else {
                sectionAttributes.contentLength += sectionGap;
            }

    
            currentSectionGap = sectionGap;
            sectionIndex++;
        }
    }
    else if (sections.count == 1) {
        DCItemsBoxSection* sectionAttributes = [sections objectAtIndex:0];
        [sectionAttributes reset];
        [self performLayoutWithItems:items inSection:sectionAttributes sectionIndex:0];
    }

    _contentSize = orientation == DCOrientationVertical ? CGSizeMake(_size, _top + contentPadding.bottom) : CGSizeMake(_top + contentPadding.bottom, _size);
    [self invalidateLayout];
}

-(void) performLayoutWithItems:(NSArray *)items inSection:(DCItemsBoxSection*)sectionAttributes sectionIndex:(int) sectionIndex {

    sectionAttributes.items = items;
    
    int sectionContentLength = 0;
    int itemIndex = 0;
    
    NSMutableArray* layoutRects = [[NSMutableArray alloc] init];
    NSMutableArray* renderRects = [[NSMutableArray alloc] init];
    [self populateRectsOfItems:items toLayoutRects:layoutRects renderRects:renderRects];
    
    if (layoutRects.count > 0) {
        for (int i = 0; i <= layoutRects.count - 1; i++) {
            
            CGRect layoutRect = ((NSValue*)[layoutRects objectAtIndex:i]).CGRectValue;
            CGRect renderRect = ((NSValue*)[renderRects objectAtIndex:i]).CGRectValue;
            
            sectionContentLength = MAX(sectionContentLength, layoutRect.origin.y + layoutRect.size.height);
            sectionAttributes.maxCellLength = MAX(sectionAttributes.maxCellLength, renderRect.size.height);
            
            
            DCItemsBoxLayoutAttributes* attributes = [DCItemsBoxLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:itemIndex inSection:sectionIndex]];
            attributes.frame = DCRectMake(renderRect.origin.x, renderRect.origin.y + _top, renderRect.size.width, renderRect.size.height, orientation);
            attributes.layoutRect = CGRectMake(layoutRect.origin.x, layoutRect.origin.y + _top, layoutRect.size.width, layoutRect.size.height);
            
            
            [_attributesList addObject:attributes];
            itemIndex++;
        }
    }
    
    sectionAttributes.contentLength = sectionContentLength;
    _top += sectionContentLength;
}

-(void) populateRectsOfItems:(NSArray*) items toLayoutRects:(NSMutableArray*) layoutRects renderRects:(NSMutableArray*) renderRects {
}


- (CGSize)collectionViewContentSize {
    return _contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    
    float contentOffset;
    float viewportLength;
    
    if (orientation == DCOrientationVertical) {
        if (isHeaderSticky || isFooterSticky) {
            contentOffset = self.collectionView.contentOffset.y;
            viewportLength = self.collectionView.frame.size.height;
        }
        else {
            contentOffset = rect.origin.y;
            viewportLength = rect.size.height;
        }
    }
    else {
        if (isHeaderSticky || isFooterSticky) {
            contentOffset = self.collectionView.contentOffset.x;
            viewportLength = self.collectionView.frame.size.width;
        }
        else {
            contentOffset = rect.origin.x;
            viewportLength = rect.size.width;
        }
    }
    

    int startIndex = [self indexOfAttributesUsingBinarySearchWithPosition:contentOffset];
    if (startIndex == -1) {
        startIndex = 0;
    }
    
    
    DCItemsBoxLayoutAttributes* startItem = [_attributesList objectAtIndex:startIndex];
    float maxCellLength = ((DCItemsBoxSection*)[sections objectAtIndex:startItem.indexPath.section]).maxCellLength;
    
    int adjustdStartIndex = -1;
    for (int i = startIndex - 1; i >= 0; i--) {
        
        DCItemsBoxLayoutAttributes* attributes = [_attributesList objectAtIndex:i];
        if (attributes.representedElementCategory != UICollectionElementCategoryCell) {
            break;
        }
        
        if ((orientation == DCOrientationVertical ? startItem.frame.origin.y : startItem.frame.origin.x) - (orientation == DCOrientationVertical ? attributes.frame.origin.y : attributes.frame.origin.x) >= maxCellLength) {
            break;
        }
        
        if (attributes.layoutRect.origin.y <= contentOffset && attributes.layoutRect.origin.y + attributes.layoutRect.size.height >= contentOffset) {
            adjustdStartIndex = i;
        }
    }
    
    if (adjustdStartIndex >= 0) {
        startIndex = adjustdStartIndex;
    }
    
    
    int endIndex = [self indexOfAttributesUsingBinarySearchWithPosition:contentOffset + viewportLength];
    if (endIndex == -1) {
        endIndex = _attributesList.count - 1;
    }
    
    int adjustedEndIndex = _attributesList.count - 1;
    for (int i = endIndex + 1; i <= _attributesList.count - 1; i++) {
        DCItemsBoxLayoutAttributes* attributes = [_attributesList objectAtIndex:i];
        if ((orientation == DCOrientationVertical ? attributes.frame.origin.y : attributes.frame.origin.x) >= contentOffset + viewportLength) {
            adjustedEndIndex = i - 1;
            break;
        }
    }
    
    endIndex = adjustedEndIndex;
    
    
    _startIndex = startIndex;
    _endIndex = endIndex;
    
    
    NSMutableArray* attributesList = [[NSMutableArray alloc] init];
    for (int i = startIndex; i <= endIndex; i++) {
        DCItemsBoxLayoutAttributes* attributes = [_attributesList objectAtIndex:i];
        
        float top = orientation == DCOrientationVertical ? attributes.frame.origin.y : attributes.frame.origin.x;
        float bottom = orientation == DCOrientationVertical ? (attributes.frame.origin.y + attributes.frame.size.height) : (attributes.frame.origin.x + attributes.frame.size.width);
        
        if (attributes.representedElementCategory == UICollectionElementCategoryCell && (bottom > contentOffset || top < contentOffset + viewportLength)) {
            [attributesList addObject:attributes];
        }
    }
    
    if (!_isSectionedData) {
        return attributesList;
    }
    
    
    int firstSectionIndex = ((DCItemsBoxLayoutAttributes*)([_attributesList objectAtIndex:startIndex])).indexPath.section;
    int lastSectionIndex = ((DCItemsBoxLayoutAttributes*)([_attributesList objectAtIndex:endIndex])).indexPath.section;
    
    if (firstSectionIndex > 0 && isHeaderSticky) {
        DCItemsBoxSection* precedingSection = [sections objectAtIndex:firstSectionIndex - 1];
        if (contentOffset < precedingSection.headerRenderPosition + precedingSection.headerLength + precedingSection.contentLength) {
            firstSectionIndex--;
        }
    }
    
    
    _startSectionIndex = firstSectionIndex;
    _endSectionIndex = lastSectionIndex;

    
    for (int i = firstSectionIndex; i <= lastSectionIndex; i++) {
        
        DCItemsBoxSection* section = [sections objectAtIndex:i];
        
        if (section.hasHeader) {

            float y = section.headerRenderPosition;
            if (self.isHeaderSticky && i == firstSectionIndex && contentOffset >= section.headerRenderPosition) {
                y = MIN(contentOffset, section.headerRenderPosition + section.contentLength);
            }
            
            section.headerAttributes.frame = DCRectMake(contentPadding.left, y, _size - contentPadding.left - contentPadding.right, section.headerLength, orientation);
            
            if (y + section.headerLength >= contentOffset || y < contentOffset + viewportLength) {
                [attributesList addObject:section.headerAttributes];
            }
        }
        
        if (section.hasFooter && contentOffset >= section.contentRenderTop - viewportLength) {
            
            float y = section.footerRenderPosition;
            if (self.isFooterSticky && i == lastSectionIndex && contentOffset <= section.footerRenderPosition) {
  
                float contentBottom = contentOffset + viewportLength;

                /*
                contentBottom == section.contentRenderTop => section.footerHeight;
                contentBottom == section.contentRenderTop + section.footerHeight => 0;
                */
                
                y = MIN(contentOffset + viewportLength - section.footerLength + MAX(0, section.footerLength - (contentBottom - section.contentRenderTop)), section.footerRenderPosition);
            }
            
            
            section.footerAttributes.frame = DCRectMake(contentPadding.left, y, _size - contentPadding.left - contentPadding.right, section.footerLength, orientation);
            
            if (y + section.footerLength >= contentOffset || y < contentOffset + viewportLength) {
                [attributesList addObject:section.footerAttributes];
            }
        }
    }
    
    
    return attributesList;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    return nil;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath {
    return nil;
}


-(int) indexOfAttributesUsingBinarySearchWithPosition:(int) position {

    int min = 0;
    int max = _attributesList.count - 1;
    
    while (true) {
    
        int pivot = (min + max) / 2;
        DCItemsBoxLayoutAttributes* item = [_attributesList objectAtIndex:pivot];
        
        if (item.layoutRect.origin.y <= position && item.layoutRect.origin.y + item.layoutRect.size.height >= position) {
            return pivot;
        }
        else if (item.layoutRect.origin.y < position) {
            min = pivot + 1;
        }
        else {
            max = pivot - 1;
        }
        
        if (min > max) {
            return -1;
        }
    }
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return isHeaderSticky || isFooterSticky;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [((DCItemsBoxSection*)[sections objectAtIndex:indexPath.section]).items objectAtIndex:indexPath.item];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    DCItemsBoxSection* section = [sections objectAtIndex:indexPath.section];
    
    if ([kind isEqualToString:@"UICollectionElementKindSectionHeader"]) {
        return section.headerAttributes;
    }
    else if ([kind isEqualToString:@"UICollectionElementKindSectionFooter"]) {
        return section.footerAttributes;
    }
    
    return nil;
}

@end
