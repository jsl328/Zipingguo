//
//  DCItemsBoxDelegate.h
//  DandelionDemo1
//
//  Created by Bob Li on 14-2-17.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCSectionedData.h"
#import "DCItemsBox.h"

@class DCItemsBox;

@protocol DCItemsBoxDelegate <NSObject>

@optional

-(void) itemsBoxDidStartPullRefresh:(DCItemsBox*) itemsBox;

-(void) itemsBox:(DCItemsBox*) itemsBox didSelectCellAtCellIndex:(int) cellIndex item:(id) item;

-(void) itemsBox:(DCItemsBox*) itemsBox didSelectCellAtCellIndex:(int) cellIndex inSectionIndex:(int) sectionIndex item:(id) item;

-(void) itemsBox:(DCItemsBox*) itemsBox didClickSectionHeaderAtSectionIndex:(int) sectionIndex section:(id <DCSectionedData>) section;

-(void) itemsBox:(DCItemsBox*) itemsBox didClickSectionFooterAtSectionIndex:(int) sectionIndex section:(id <DCSectionedData>) section;

@end
