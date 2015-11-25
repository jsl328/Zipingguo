//
//  DCListBoxHeaderCell.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListBox.h"
#import "DCContentPresenter.h"

@interface DCListBoxHeaderFooterCell : UITableViewHeaderFooterView {
    DCContentPresenter* _contentPresenter;
    NSString* _identifier;
}

@property (assign, nonatomic) ListBox* listBox;
@property (nonatomic) int sectionIndex;
@property (assign, nonatomic) UIView* cellView;
@property (nonatomic) BOOL isHeader;

-(void) bind;

@end
