//
//  DCInternalRecordDialog.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRecordDialog.h"

@interface DCRecordDialogDefaultImpl : DCRecordDialog

-(void) overlayDidClose;

@end


@interface DCRecorderViewOverlay : UIView

@property (retain, nonatomic) DCRecordDialogDefaultImpl* recordDialog;

-(void) setTimeInSeconds:(int) seconds;

-(void) setTimeExpired;

@end