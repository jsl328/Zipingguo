//
//  DCTableViewSectionHandler.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCTableViewHeaderDelegate.h"
#import "DCSectionedData.h"
#import "DCListBoxHeaderFooterCell.h"
#import "DCSectionedData.h"

@implementation DCTableViewHeaderDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.listBox heightForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.listBox viewForHeaderInSection:section];
}

@end
