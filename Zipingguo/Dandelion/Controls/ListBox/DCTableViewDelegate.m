//
//  DCTableViewDelegateHandler.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCTableViewDelegate.h"
#import "DCListBoxItemDataSource.h"
#import "DCCellHeightDataSource.h"

@implementation DCTableViewDelegate
@synthesize listBox;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [listBox heightForRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = [listBox itemAtIndexPath:indexPath];
    
    if ([item conformsToProtocol:@protocol(DCListBoxItemDataSource)]) {
        
        id <DCListBoxItemDataSource> dataSource = item;
        
        if ([dataSource respondsToSelector:@selector(isDeletable)] && [dataSource isDeletable]) {
            return UITableViewCellEditingStyleDelete;
        }
        else if ([dataSource respondsToSelector:@selector(isInsertable)] && [dataSource isInsertable]) {
            return UITableViewCellEditingStyleInsert;
        }
    }
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [listBox selectRowAtSection:(int)indexPath.section position:(int)indexPath.row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [listBox listboxDidScroll:scrollView];
}

@end
