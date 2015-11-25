//
//  DCTableViewTextFooterDataSource.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-18.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCTableViewTextFooterDataSource.h"
#import "DCSectionedData.h"

@implementation DCTableViewTextFooterDataSource

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    id <DCSectionedData> sectionData = [self.listBox.items objectAtIndex:section];
    return sectionData.footer;
}

@end
