//
//  DCTableViewSectionDataTextHandler.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCTableViewTextHeaderDataSource.h"
#import "DCSectionedData.h"

@implementation DCTableViewTextHeaderDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <DCSectionedData> sectionData = [self.listBox.items objectAtIndex:section];
    return sectionData.header;
}

@end
