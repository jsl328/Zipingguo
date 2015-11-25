//
//  DCPageBox.m
//  DandelionDemo1
//
//  Created by Bob Li on 14-5-27.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCPageBox.h"
#import "DCPageBoxCell.h"
#import "DCDirectionDispatcher.h"
#import "DCContentPresenter.h"

@implementation DCPageBox {

    NSMutableArray* _cells;
    
    float _offset;
    float _touchDownOffset;
    
    float _x;
    
    float _letLooseThreshold;
    
    UIView* _pivotPage;
    UIView* _leftBufferPage;
    UIView* _rightBufferPage;
}

@synthesize items = _items;
@synthesize selectedPageIndex = _selectedPageIndex;

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

    _cells = [[NSMutableArray alloc] init];
    _letLooseThreshold = 20;
}


-(void) setItems:(NSArray *)items {
    
    _items = items;
    [self recycleAllCells];
    
    if (_items.count > 0) {
        self.selectedPageIndex = 0;
    }
}

-(void) setSelectedPageIndex:(int)selectedPageIndex {
    _selectedPageIndex = selectedPageIndex;
    [self recycleOutOfBoundsCells];
    [self showSelectedPage];
}

-(void) showSelectedPage {

    _pivotPage = [self obtainCellWithData:[_items objectAtIndex:_selectedPageIndex]].view;
    _leftBufferPage = _selectedPageIndex == 0 ? nil : [self obtainCellWithData:[_items objectAtIndex:_selectedPageIndex - 1]].view;
    _rightBufferPage = _selectedPageIndex == _items.count - 1 ? nil : [self obtainCellWithData:[_items objectAtIndex:_selectedPageIndex + 1]].view;
    
    [self layoutPages];
}

-(void) layoutPages {
    
    int w = self.frame.size.width;
    int h = self.frame.size.height;

    _pivotPage.frame = CGRectMake(_offset, 0, w, h);
    _leftBufferPage.frame = CGRectMake(-w + _offset, 0, w, h);
    _rightBufferPage.frame = CGRectMake(w + _offset, 0, w, h);
}


-(DCDirectionDecision) decisionFromDirection:(DCMoveDirection) direction touch:(UITouch*) touch xDirection:(int) xDirection yDirection:(int) yDirection {
    return DCDirectionDecisionAccept;
}

-(BOOL) isProperDirection:(DCMoveDirection) direction {
    return direction == DCMoveDirectionLeft || direction == DCMoveDirectionRight;
}

-(void) directionTouchesBegan:(UITouch*) touch {
    _x = [touch locationInView:self].x;
    _touchDownOffset = _offset;
}

-(void) directionTouchesMoved:(UITouch*) touch {
    
    int x = [touch locationInView:self].x;
    
    
    float factor = 1;
    float width = self.frame.size.width;
    
    if ((_selectedPageIndex == 0 && _offset > 0) || (_selectedPageIndex == _items.count - 1 && _offset < 0)) {
        factor = powf((width - ABS(_offset)) / width, 2);
    }
    
    
    _offset += (x - _x) * factor;
    _x = x;
    
    [self layoutPages];
}

-(void) directionTouchesEnded:(UITouch*) touch {

    int targetOffset;
    int targetPageIndex;
    
    if (_offset - _touchDownOffset >= _letLooseThreshold && _selectedPageIndex > 0) {
        targetOffset = _touchDownOffset + self.frame.size.width;
        targetPageIndex = _selectedPageIndex - 1;
    }
    else if (_offset - _touchDownOffset <= -_letLooseThreshold && _selectedPageIndex < _items.count - 1) {
        targetOffset = _touchDownOffset - self.frame.size.width;
        targetPageIndex = _selectedPageIndex + 1;
    }
    else {
        targetOffset = _touchDownOffset;
        targetPageIndex = _selectedPageIndex;
    }
    
    
    float duration = (float)ABS(targetOffset - _offset) * 0.0005;
    _offset = targetOffset;
    
    [UIView animateWithDuration:duration animations:^{
        [self layoutPages];
    } completion:^(BOOL finished) {
        if (targetPageIndex != _selectedPageIndex) {
            _offset = 0;
            self.selectedPageIndex = targetPageIndex;
        }
    }];
}

-(BOOL) sendWindowEvents {
    return YES;
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


-(DCPageBoxCell*) obtainCellWithData:(id) data {

    for (DCPageBoxCell* cell in _cells) {
        if (cell.isInUse && cell.data == data) {
            return cell;
        }
    }
    

    for (DCPageBoxCell* cell in _cells) {
        if (!cell.isInUse && [cell.dataClass isSubclassOfClass:[data class]]) {
            [cell claimWithData:data];
            return cell;
        }
    }
    
    
    DCPageBoxCell* cell = [[DCPageBoxCell alloc] init];
    cell.view = [[DCContentPresenter alloc] init];
    cell.dataClass = [data class];
    [cell claimWithData:data];
    [_cells addObject:cell];
    [self addSubview:cell.view];
    
    return cell;
}

-(void) recycleOutOfBoundsCells {
    
    float width = self.frame.size.width;

    for (DCPageBoxCell* cell in _cells) {
        float x = cell.view.frame.origin.x;
        if (cell.isInUse && (x + width <= -width || x - width >= width)) {
            [cell recycle];
        }
    }
}

-(void) recycleAllCells {

    for (DCPageBoxCell* cell in _cells) {
        [cell recycle];
    }
}


-(void) layoutSubviews {

    [super layoutSubviews];
    [self layoutPages];
}

@end
