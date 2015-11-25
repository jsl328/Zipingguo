//
//  DCTableViewFooterDelegate.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-18.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCTableViewFooterDelegate.h"

@implementation DCTableViewFooterDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self.listBox heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self.listBox viewForFooterInSection:section];
}

@end
