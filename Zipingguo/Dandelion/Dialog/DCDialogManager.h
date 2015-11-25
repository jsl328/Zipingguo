//
//  DCDialogManager.h
//  DandelionDemo
//
//  Created by Bob Li on 14-2-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDialog.h"

@interface DCDialogManager : NSObject {

    NSMutableArray* _dialogs;
}

+(DCDialogManager*) defaultManager;

-(void) addDialog:(DCDialog*) dialog;
-(void) showNextDialog;

-(void) closeDialog;

@end
