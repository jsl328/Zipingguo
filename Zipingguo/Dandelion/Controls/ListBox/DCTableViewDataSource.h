//
//  DCTableViewDataSource.h
//  DandelionDemo
//
//  Created by Bob Li on 13-12-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListBox.h"

@interface DCTableViewDataSource : NSObject <UITableViewDataSource>

@property (assign, nonatomic) ListBox* listBox;

@end
