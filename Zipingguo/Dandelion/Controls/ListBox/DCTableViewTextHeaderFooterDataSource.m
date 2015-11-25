//
//  DCTableViewTextHeaderFooterDataSource.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-18.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCTableViewTextHeaderFooterDataSource.h"
#import "DCSectionedData.h"

@implementation DCTableViewTextHeaderFooterDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <DCSectionedData> sectionData = [self.listBox.items objectAtIndex:section];
    return sectionData.header;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    id <DCSectionedData> sectionData = [self.listBox.items objectAtIndex:section];
    return sectionData.footer;
}

@end
