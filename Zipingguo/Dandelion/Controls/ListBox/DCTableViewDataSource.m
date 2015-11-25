//
//  DCTableViewDataSource.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCTableViewDataSource.h"
#import "DCListBoxItemDataSource.h"
#import "BindingContext.h"
#import "DCSectionedData.h"
#import "ListBoxCell.h"

@implementation DCTableViewDataSource
@synthesize listBox;

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([listBox isIndexPathOnNextPageButton:indexPath]) {
        return NO;
    }
    
    
    id item = [listBox itemAtIndexPath:indexPath];
    
    if ([item conformsToProtocol:@protocol(DCListBoxItemDataSource)]) {
        
        id <DCListBoxItemDataSource> dataSource = item;
        
        if ([dataSource respondsToSelector:@selector(isDeletable)] && [dataSource isDeletable]) {
            return YES;
        }
        else if ([dataSource respondsToSelector:@selector(isInsertable)] && [dataSource isInsertable]) {
            return YES;
        }
        else if ([dataSource respondsToSelector:@selector(isMovable)] && [dataSource isMovable]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([listBox isIndexPathOnNextPageButton:indexPath]) {
        return NO;
    }
    
    
    id <DCListBoxItemDataSource> dataSource = [listBox itemAtIndexPath:indexPath];
    
    if ([dataSource respondsToSelector:@selector(isMovable)] && [dataSource isMovable]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([listBox.delegate respondsToSelector:@selector(listBox:didRequestDeleteAtSection:position:)]) {
            [listBox.delegate listBox:listBox didRequestDeleteAtSection:(int)indexPath.section position:(int)indexPath.row];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if ([listBox.delegate respondsToSelector:@selector(listBox:didRequestInsertAtSection:position:)]) {
            [listBox.delegate listBox:listBox didRequestInsertAtSection:(int)indexPath.section position:(int)indexPath.row];
        }
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if ([listBox.delegate respondsToSelector:@selector(listBox:didRequestMovingFromSection:position:toSection:position:)]) {
        [listBox.delegate listBox:listBox didRequestMovingFromSection:(int)sourceIndexPath.section position:(int)sourceIndexPath.row toSection:(int)destinationIndexPath.section position:(int)destinationIndexPath.row];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return listBox.isSectionedData ? listBox.items.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listBox numberOfRowsInSection:(int)section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [listBox cellForRowAtIndexPath:indexPath];
}


@end
