//
//  DialogLib.m
//  Dandelion
//
//  Created by Bob Li on 13-8-29.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "LDialog.h"
#import "MessageBox.h"
#import "AppContext.h"
#import "WaitBox.h"
#import "ActionSheetDialog.h"
#import "DCDialogManager.h"
#import "DCOverlayDialog.h"
#import "DCToast.h"

#ifdef __USE_PREVIEW_DIALOG
#import "DocumentPreviewDialog.h"
#endif

@implementation LDialog

+(void) showMessage: (NSString*) message {
    [[DCDialogManager defaultManager] addDialog:[[MessageBox alloc] initWithMessage:message]];
}

+(void) showMessage: (NSString*) message ok: (void (^)(void)) ok {
    [[DCDialogManager defaultManager] addDialog:[[MessageBox alloc] initWithMessage:message positiveCallback:ok negativeCallback:nil button:MessageBoxButtonOK]];
}

+(void) showMessageOKCancel: (NSString*) message ok: (void (^)(void)) ok cancel: (void (^)(void)) cancel {
    [[DCDialogManager defaultManager] addDialog:[[MessageBox alloc] initWithMessage:message positiveCallback:ok negativeCallback:cancel button:MessageBoxButtonOKCancel]];
}

+(void) showMessageCancelOK: (NSString*) message ok: (void (^)(void)) ok cancel: (void (^)(void)) cancel{
    [[DCDialogManager defaultManager] addDialog:[[MessageBox alloc] initWithMessage:message negativeCallback:cancel positiveCallback:ok button:MessageBoxButtonOKCancel Type:YES]];
    
}

+(void) showMessageYesNo: (NSString*) message yes: (void (^)(void)) yes no: (void (^)(void)) no {
    [[DCDialogManager defaultManager] addDialog:[[MessageBox alloc] initWithMessage:message positiveCallback:yes negativeCallback:no button:MessageBoxButtonYesNo]];
}

+(void) showActionSheet:(NSArray*) items callback:(void (^)(int)) buttonClickCallback {
    
    ActionSheetDialog* actionSheetDialog = [[ActionSheetDialog alloc] initWithCallback:buttonClickCallback];
    actionSheetDialog.items = items;
    [[DCDialogManager defaultManager] addDialog:actionSheetDialog];
}

+(void) showCenterredOverlay:(id) content withSize:(CGSize) size clickToClose:(BOOL) clickToClose {
    [LDialog showOverlay:content withSize:size horizontalGravity:DCHorizontalGravityCenter verticalGravity:DCVerticalGravityCenter padding:UIEdgeInsetsZero clickToClose:clickToClose inAnimation:DCAnimationTypeFadeIn outAnimation:DCAnimationTypeFadeOut];
}

+(void) showBottomOverlay:(id) content withHeight:(float) height horizontalPadding:(float) horizontalPadding bottomPadding:(float) bottomPadding clickToClose:(BOOL) clickToClose {
    [LDialog showOverlay:content withSize:CGSizeMake([AppContext window].frame.size.width - horizontalPadding * 2, height) horizontalGravity:DCHorizontalGravityCenter verticalGravity:DCVerticalGravityBottom padding:UIEdgeInsetsMake(0, horizontalPadding, bottomPadding, horizontalPadding) clickToClose:clickToClose inAnimation:DCAnimationTypeMoveUp + DCAnimationTypeFadeIn outAnimation:DCAnimationTypeMoveDown + DCAnimationTypeFadeOut];
}

+(void) showOverlay:(id) content withSize:(CGSize) size horizontalGravity:(DCHorizontalGravity) horiontalGravity verticalGravity:(DCVerticalGravity) verticalGravity padding:(UIEdgeInsets) padding clickToClose:(BOOL) clickToClose inAnimation:(DCAnimationType) inAnimation outAnimation:(DCAnimationType) outAnimation {

    DCOverlayDialog* overlayDialog = [[DCOverlayDialog alloc] init];
    overlayDialog.content = content;
    overlayDialog.size = size;
    overlayDialog.horizontalGravity = horiontalGravity;
    overlayDialog.verticalGravity = verticalGravity;
    overlayDialog.padding = padding;
    overlayDialog.inAnimation = inAnimation;
    overlayDialog.outAnimation = outAnimation;
    overlayDialog.clickToClose = clickToClose;
    [[DCDialogManager defaultManager] addDialog:overlayDialog];
}

+(void) showCenterredToast:(id) content withSize:(CGSize) size {
    [LDialog showToast:content withSize:size horizontalGravity:DCHorizontalGravityCenter verticalGravity:DCVerticalGravityCenter padding:UIEdgeInsetsZero inAnimation:DCAnimationTypeFadeIn outAnimation:DCAnimationTypeFadeOut];
}

+(void) showBottomToast:(id) content withHeight:(float) height horizontalPadding:(float) horizontalPadding bottomPadding:(float) bottomPadding {
    [LDialog showToast:content withSize:CGSizeMake([AppContext window].frame.size.width - horizontalPadding * 2, height) horizontalGravity:DCHorizontalGravityCenter verticalGravity:DCVerticalGravityBottom padding:UIEdgeInsetsMake(0, horizontalPadding, bottomPadding, horizontalPadding) inAnimation:DCAnimationTypeMoveUp + DCAnimationTypeFadeIn outAnimation:DCAnimationTypeMoveDown + DCAnimationTypeFadeOut];
}

+(void) showToast:(id) content withSize:(CGSize) size horizontalGravity:(DCHorizontalGravity) horiontalGravity verticalGravity:(DCVerticalGravity) verticalGravity padding:(UIEdgeInsets) padding inAnimation:(DCAnimationType) inAnimation outAnimation:(DCAnimationType) outAnimation {

    DCToast* toast = [[DCToast alloc] init];
    toast.content = content;
    toast.size = size;
    toast.horizontalGravity = horiontalGravity;
    toast.verticalGravity = verticalGravity;
    toast.padding = padding;
    toast.inAnimation = inAnimation;
    toast.outAnimation = outAnimation;
    [toast showShort];
}

+(void) closeDialog {
    [[DCDialogManager defaultManager] closeDialog];
}

+(void) showWaitBox:(NSString*) message {
    [[WaitBox defaultWaitBox] show];
    [WaitBox defaultWaitBox].message = message;
}

+(void) closeWaitBox {
    [[WaitBox defaultWaitBox] close];
}

#ifdef __USE_PREVIEW_DIALOG

+(void) showDocumentPreviewWithTitle:(NSString*) title filePath:(NSString*) filePath {
    DocumentPreviewDialog* dialog = [[DocumentPreviewDialog alloc] init];
    dialog.title = title;
    dialog.filePath = filePath;
    [dialog showInController:[AppContext navigationConductor].navigationController];
}

#endif

@end
