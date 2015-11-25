//
//  AppSettings.m
//  AmaranthDemo
//
//  Created by Sofia Work on 14-8-21.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCAppSettings.h"
#import "DCRecorderImpl.h"
#import "DCRecordDialogDefaultImpl.h"
#import "DCSelectImageDialogDefaultImpl.h"
#import "DCPlayerImpl.h"
#import "DCDrawImageDialogDefaultImpl.h"
#import "DCVolumnMeterViewDefaultImpl.h"

@implementation DCAppSettings {
    
    DCRecorder* _recorder;
    
    DCRecordDialog* _recordDialog;
    
    DCSelectImageDialog* _selectImageDialog;
    
    DCPlayer* _player;
    
    DCDrawImageDialog* _drawImageDialog;
}

@synthesize maskColor;
@synthesize animationPixelsPerSecond;
@synthesize recorderClass = _recorderClass;
@synthesize recordDialogClass = _recordDialogClass;
@synthesize selectImageDialogClass = _selectImageDialogClass;
@synthesize playerClass = _playerClass;
@synthesize drawImageDialogClass = _drawImageDialogClass;
@synthesize volumnMeterViewClass;

-(DCRecorder*) recorder {
    
    if (!_recorder) {
        _recorder = [[_recorderClass alloc] init];
    }
    
    return _recorder;
}

-(DCRecordDialog*) recordDialog {
    
    if (!_recordDialog) {
        _recordDialog = [[_recordDialogClass alloc] init];
    }
    
    return _recordDialog;
}

-(DCSelectImageDialog*) selectImageDialog {
    
    if (!_selectImageDialog) {
        _selectImageDialog = [[_selectImageDialogClass alloc] init];
    }
    
    return _selectImageDialog;
}

-(DCPlayer*) player {
    
    if (!_player) {
        _player = [[_playerClass alloc] init];
    }
    
    return _player;
}

-(DCDrawImageDialog*) drawImageDialog {
    
    if (!_drawImageDialog) {
        _drawImageDialog = [[_drawImageDialogClass alloc] init];
    }
    
    return _drawImageDialog;
}

-(UIView*) volumnMeterView {
    return volumnMeterViewClass ? [[volumnMeterViewClass alloc] init] : nil;
}


-(void) setRecorderClass:(Class)recorderClass {
    _recorderClass = recorderClass;
    _recorder = nil;
}

-(void) setRecordDialogClass:(Class)recordDialogClass {
    _recordDialogClass = recordDialogClass;
    _recordDialog = nil;
}

-(void) setSelectImageDialogClass:(Class)selectImageDialogClass {
    _selectImageDialogClass = selectImageDialogClass;
    _selectImageDialog = nil;
}

-(void) setPlayerClass:(Class)playerClass {
    _playerClass = playerClass;
    _player = nil;
}

-(void) setDrawImageDialogClass:(Class)drawImageDialogClass {
    _drawImageDialogClass = drawImageDialogClass;
    _drawImageDialog = nil;
}

+(DCAppSettings*) defaultSettings {
    
    DCAppSettings* settings = [[DCAppSettings alloc] init];
    settings.maskColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    settings.animationPixelsPerSecond = 600;
    settings.recorderClass = [DCRecorderImpl class];
    settings.recordDialogClass = [DCRecordDialogDefaultImpl class];
    settings.selectImageDialogClass = [DCSelectImageDialogDefaultImpl class];
    settings.playerClass = [DCPlayerImpl class];
    settings.drawImageDialogClass = [DCDrawImageDialogDefaultImpl class];
    settings.volumnMeterViewClass = [DCVolumnMeterViewDefaultImpl class];
    return settings;
}

-(NSTimeInterval) durationForPixelDistance:(float) d {
    return d / animationPixelsPerSecond;
}

@end
