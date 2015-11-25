//
//  DCDrawImageDialogDefaultImpl.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCDrawImageDialogDefaultImpl.h"
#import "DCDrawSurface.h"
#import "DCLocalizedStrings.h"

@implementation DCDrawImageDialogDefaultImpl {
    
    id _closeCallback;
    
    DCDrawImageOverlay* _overlay;
}

-(void) showDialog:(void (^)(void))closeCallback {
    
    _closeCallback = closeCallback;
    
    UIWindow* window = [AppContext window];
    
    _overlay = [[DCDrawImageOverlay alloc] init];
    _overlay.drawImageDialog = self;
    
    [LDialog showBottomOverlay:_overlay withHeight:300 horizontalPadding:10 bottomPadding:10 clickToClose:NO];
}

-(void) overlayDidClose {
    ((void (^)(void))_closeCallback)();
    _closeCallback = nil;
    _overlay = nil;
}

@end


@implementation DCDrawImageOverlay {
    
    DCDrawSurface* _drawSurface;
    
    UIButton* _useButton;
    
    UIButton* _discardButton;
}

@synthesize drawImageDialog;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        float width = [AppContext window].frame.size.width - 20;
        
        _drawSurface = [[DCDrawSurface alloc] init];
        _drawSurface.frame = CGRectMake(0, 0, width - 20, 150);
        [_drawSurface createSurfaceWithSize:CGSizeMake(width - 20, 150)];
        [self addSubview:_drawSurface];
        
        _useButton = [[UIButton alloc] init];
        _useButton.backgroundColor = [UIColor redColor];
        [_useButton setTitle:[DCLocalizedStrings stringForKey:DCStringKeyDefaultDrawDialogUse] forState:UIControlStateNormal];
        _useButton.frame = CGRectMake(width / 4 - 90 / 2, 220, 90, 40);
        [self addSubview:_useButton];
        [_useButton addTarget:self action:@selector(onUseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _discardButton = [[UIButton alloc] init];
        _discardButton.backgroundColor = [UIColor redColor];
        [_discardButton setTitle:[DCLocalizedStrings stringForKey:DCStringKeyDefaultDrawDialogDiscard] forState:UIControlStateNormal];
        _discardButton.frame = CGRectMake(width * 3 / 4 - 90 / 2, 220, 90, 40);
        [self addSubview:_discardButton];
        [_discardButton addTarget:self action:@selector(onDiscardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void) onUseButtonClick:(UIButton*) sender {
    
    NSString* filePath = [[AppContext storageResolver] pathForPickedFile:@"jpg"];
    [_drawSurface saveImageAtFilePath:filePath];
    
    drawImageDialog.drawnImageFilePath = filePath;
    [LDialog closeDialog];
    [drawImageDialog overlayDidClose];
    drawImageDialog = nil;
}

-(void) onDiscardButtonClick:(UIButton*) sender {
    [LDialog closeDialog];
    drawImageDialog.drawnImageFilePath = nil;
    [drawImageDialog overlayDidClose];
    drawImageDialog = nil;
}

@end
