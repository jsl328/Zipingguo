//
//  DCInternalRecordDialog.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-7-24.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCRecordDialogDefaultImpl.h"
#import "DCLocalizedStrings.h"

@implementation DCRecordDialogDefaultImpl {

    id _closeCallback;
    
    DCRecorderViewOverlay* _overlay;
}

-(void) showDialog:(void (^)(void))closeCallback {
    
    _closeCallback = closeCallback;
    
    UIWindow* window = [AppContext window];
    
    _overlay = [[DCRecorderViewOverlay alloc] init];
    _overlay.recordDialog = self;
    [_overlay addSubview:self.volumnMeterView];
    self.volumnMeterView.frame = CGRectMake((window.frame.size.width - 20 - 120) / 2, 90, 120, 120);
    
    [LDialog showBottomOverlay:_overlay withHeight:300 horizontalPadding:10 bottomPadding:10 clickToClose:NO];
}

-(void) setTimeInSeconds:(int)seconds {
    [_overlay setTimeInSeconds:seconds];
}

-(void) setTimeExipired {
    [_overlay setTimeExpired];
}


-(void) overlayDidClose {
    ((void (^)(void))_closeCallback)();
    _closeCallback = nil;
    _overlay = nil;
}

@end



@implementation DCRecorderViewOverlay {
    
    UILabel* _label;
    
    UILabel* _tickLabel;
    
    UIButton* _useButton;
    
    UIButton* _discardButton;
    

    int _tick;
}

@synthesize recordDialog;

- (id)init
{
    self = [super init];
    if (self) {
        
        float width = [AppContext window].frame.size.width - 20;
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        _label = [[UILabel alloc] init];
        _label.text = [DCLocalizedStrings stringForKey:DCStringKeyDefaultRecordDialogPleaseSpeak];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.frame = CGRectMake((width - _label.intrinsicContentSize.width) / 2, 20, _label.intrinsicContentSize.width, _label.intrinsicContentSize.height);
        [self addSubview:_label];
        
        _tickLabel = [[UILabel alloc] init];
        _tickLabel.text = @"00:00";
        _tickLabel.textAlignment = NSTextAlignmentCenter;
        _tickLabel.font = [UIFont systemFontOfSize:45];
        _tickLabel.frame = CGRectMake((width - 200) / 2, 50, 200, _tickLabel.intrinsicContentSize.height);
        [self addSubview:_tickLabel];
        
        _useButton = [[UIButton alloc] init];
        _useButton.backgroundColor = [UIColor redColor];
        [_useButton setTitle:[DCLocalizedStrings stringForKey:DCStringKeyDefaultRecordDialogUse] forState:UIControlStateNormal];
        _useButton.frame = CGRectMake(width / 4 - 90 / 2, 220, 90, 40);
        [self addSubview:_useButton];
        [_useButton addTarget:self action:@selector(onUseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _discardButton = [[UIButton alloc] init];
        _discardButton.backgroundColor = [UIColor redColor];
        [_discardButton setTitle:[DCLocalizedStrings stringForKey:DCStringKeyDefaultRecordDialogDiscard] forState:UIControlStateNormal];
        _discardButton.frame = CGRectMake(width * 3 / 4 - 90 / 2, 220, 90, 40);
        [self addSubview:_discardButton];
        [_discardButton addTarget:self action:@selector(onDiscardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void) setTimeInSeconds:(int) seconds {
    _tickLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)floor((float)seconds / 60), seconds % 60];
}

-(void) setTimeExpired {
    _label.text = [DCLocalizedStrings stringForKey:DCStringKeyDefaultRecordDialogTimeExpired];
}

-(void) close {
    [LDialog closeDialog];
    [recordDialog overlayDidClose];
    recordDialog = nil;
}

-(void) onUseButtonClick:(UIButton*) sender {
    [self close];
}

-(void) onDiscardButtonClick:(UIButton*) sender {
    recordDialog.keepRecordedAudio = NO;
    [self close];
}

@end
