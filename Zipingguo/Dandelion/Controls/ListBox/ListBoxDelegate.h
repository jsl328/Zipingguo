//
//  TableListViewLitener.h
//  Mulberry
//
//  Created by Bob Li on 13-5-28.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListBox.h"
#import "DCSectionedData.h"

@class ListBox;

@protocol ListBoxDelegate <NSObject>

@optional

-(void) listBox:(ListBox*) listBox didSelectItem:(id) data;

-(void) listBox:(ListBox*) listBox didDragItem:(id) data offset:(float) offset;

-(void) listBox:(ListBox*) listBox didReleaseItem:(id) data offset:(float) offset isFling:(BOOL) isFling;

-(void) listBoxDidStartRefresh:(ListBox*) listBox;

-(void) listBoxDidRequestPage:(ListBox*) listBox;

-(void) listBox:(ListBox*) listBox didRequestDeleteAtSection:(int) section position:(int) position;

-(void) listBox:(ListBox*) listBox didRequestInsertAtSection:(int) section position:(int) position;

-(void) listBox:(ListBox*) listBox didRequestMovingFromSection:(int) fromSection position:(int) fromPosition toSection:(int) toSection position:(int) toPosition;

-(void) listBox:(ListBox*) listBox didClickSectionHeaderAtSectionIndex:(int) sectionIndex section:(id <DCSectionedData>) section;

-(void) listBox:(ListBox*) listBox didClickSectionFooterAtSectionIndex:(int) sectionIndex section:(id <DCSectionedData>) section;

- (void)listBox:(ListBox *)listBox didScroll:(UIScrollView *)scrollView;

@end
