//
//  AppSettings.h
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-21.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCRecorder.h"
#import "DCRecordDialog.h"
#import "DCSelectImageDialog.h"
#import "DCPlayer.h"
#import "DCDrawImageDialog.h"

@interface DCAppSettings : NSObject

@property (retain, nonatomic) UIColor* maskColor;
@property (nonatomic) float animationPixelsPerSecond;

@property (retain, nonatomic) Class recorderClass;
@property (retain, nonatomic) Class recordDialogClass;
@property (retain, nonatomic) Class selectImageDialogClass;
@property (retain, nonatomic) Class playerClass;
@property (retain, nonatomic) Class drawImageDialogClass;
@property (retain, nonatomic) Class volumnMeterViewClass;


+(DCAppSettings*) defaultSettings;

-(NSTimeInterval) durationForPixelDistance:(float) d;

-(DCRecorder*) recorder;
-(DCRecordDialog*) recordDialog;
-(DCSelectImageDialog*) selectImageDialog;
-(DCPlayer*) player;
-(DCDrawImageDialog*) drawImageDialog;
-(UIView*) volumnMeterView;

@end
