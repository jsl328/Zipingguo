//
//  ListCell.m
//  Mulberry
//
//  Created by Bob Li on 13-5-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "ListBoxCell.h"

@implementation ListBoxCell
@synthesize listBox;
@synthesize sectionIndex;
@synthesize itemIndex;
@synthesize cellView;
@synthesize item = _item;
@synthesize selectedColor;
@synthesize selectedColorMode;
@synthesize isSelected;

-(id) initWithSelectedColor:(UIColor*) color mode:(int) mode {
    self = [super init];
    if (self) {
        
        selectedColor = color;
        selectedColorMode = mode;
        [self intializeSelectionMode];
        
        sectionIndex = -1;
        itemIndex = -1;
        
        _container = [[UIView alloc] init];
        [self addSubview:_container];
        
        self.backgroundColor = [UIColor clearColor];
         _contentPresenter.backgroundColor = [UIColor clearColor];
        
        _contentPresenter = [[DCContentPresenter alloc] init];
       
        [_container addSubview:_contentPresenter];
    }
    return self;
}

-(NSString*) reuseIdentifier {
    return _identifier;
}


-(void) intializeSelectionMode {

    switch (selectedColorMode) {
    
        case DCListBoxCellSelectionColorBlue:
            self.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
            
        case DCListBoxCellSelectionColorGray:
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
            
        default:
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
    }
}

-(void) bind {
    
    if (sectionIndex == -1 || itemIndex == -1) {
        return;
    }

    id item = [listBox itemAtRow:itemIndex section:sectionIndex];
    _identifier = [[item class] description];
    
    if (sectionIndex == listBox.selectedSectionIndex && itemIndex == listBox.selectedItemIndex && selectedColorMode == DCListBoxCellSelectionColorCustom) {
        _container.backgroundColor = selectedColor;
    }
    else {
        _container.backgroundColor = [UIColor clearColor];
    }
    
    
    _contentPresenter.content = item;
    cellView = _contentPresenter.contentView;
}

-(void) layoutSubviews {
    
    [super layoutSubviews];
    
    UIEdgeInsets padding = listBox.cellPadding;
    
    _container.frame = self.bounds;
    _contentPresenter.frame = CGRectMake(padding.left, padding.top, self.frame.size.width - padding.left - padding.right, self.frame.size.height - padding.top - padding.bottom);
}

@end
