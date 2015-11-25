//
//  ListCell.h
//  Mulberry
//
//  Created by Bob Li on 13-5-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListBox.h"
#import "DCContentPresenter.h"
#import "DCTickTimer.h"

@interface ListBoxCell : UITableViewCell {
    UIView* _container;
    DCContentPresenter* _contentPresenter;
    NSString* _identifier;
}

@property (assign, nonatomic) ListBox* listBox;
@property (nonatomic) int sectionIndex;
@property (nonatomic) int itemIndex;
@property (assign, nonatomic) UIView* cellView;
@property (assign, nonatomic) id item;
@property (retain, nonatomic) UIColor* selectedColor;
@property (nonatomic) int selectedColorMode;
@property (nonatomic) BOOL isSelected;
@property (retain, nonatomic) DCTickTimer* timer;

-(id) initWithSelectedColor:(UIColor*) color mode:(int) mode;

-(void) bind;

@end
