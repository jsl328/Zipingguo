//
//  DCDialogManager.m
//  DandelionDemo
//
//  Created by Bob Li on 14-2-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDialogManager.h"

static DCDialogManager* _instance;

@implementation DCDialogManager

+(DCDialogManager*) defaultManager {
    
    if (!_instance) {
        _instance = [[DCDialogManager alloc] init];
    }
    
    return _instance;
}

-(id) init {
    self = [super init];
    if (self) {
        _dialogs = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addDialog:(DCDialog*) dialog {
    [_dialogs addObject:dialog];
    if (_dialogs.count == 1) {
        [(DCDialog*)[_dialogs objectAtIndex:0] show];
    }
}

-(void) showNextDialog {
    
    [_dialogs removeObjectAtIndex:0];
    
    if (_dialogs.count > 0) {
        [(DCDialog*)[_dialogs objectAtIndex:0] show];
    }
}

-(void) closeDialog {
    if (_dialogs.count > 0) {
        [(DCDialog*)[_dialogs objectAtIndex:0] close];
    }
}

@end
