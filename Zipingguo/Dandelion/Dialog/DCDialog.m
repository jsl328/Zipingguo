//
//  DCDialog.m
//  DandelionDemo
//
//  Created by Bob Li on 14-2-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDialog.h"
#import "DCDialogManager.h"

@implementation DCDialog

-(void) show {
}

-(void) close {
}

-(void) didClose {
    [[DCDialogManager defaultManager] showNextDialog];
}

@end
