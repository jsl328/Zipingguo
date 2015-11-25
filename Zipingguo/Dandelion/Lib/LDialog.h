//
//  DialogLib.h
//  Dandelion
//
//  Created by Bob Li on 13-8-29.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBox.h"
#import "DCControlsDefs.h"
@interface LDialog : NSObject

+(void) showMessage: (NSString*) message;

+(void) showMessage: (NSString*) message ok: (void (^)(void)) ok;

+(void) showMessageOKCancel: (NSString*) message ok: (void (^)(void)) ok cancel: (void (^)(void)) cancel;

+(void) showMessageCancelOK: (NSString*) message ok: (void (^)(void)) ok cancel: (void (^)(void)) cancel;

+(void) showMessageYesNo: (NSString*) message yes: (void (^)(void)) yes no: (void (^)(void)) no;

+(void) showActionSheet:(NSArray*) items callback:(void (^)(int)) buttonClickCallback;

+(void) showCenterredOverlay:(id) content withSize:(CGSize) size clickToClose:(BOOL) clickToClose;

+(void) showBottomOverlay:(id) content withHeight:(float) height horizontalPadding:(float) horizontalPadding bottomPadding:(float) bottomPadding clickToClose:(BOOL) clickToClose;

+(void) showOverlay:(id) content withSize:(CGSize) size horizontalGravity:(DCHorizontalGravity) horiontalGravity verticalGravity:(DCVerticalGravity) verticalGravity padding:(UIEdgeInsets) padding clickToClose:(BOOL) clickToClose inAnimation:(DCAnimationType) inAnimation outAnimation:(DCAnimationType) outAnimation;

+(void) showCenterredToast:(id) content withSize:(CGSize) size;

+(void) showBottomToast:(id) content withHeight:(float) height horizontalPadding:(float) horizontalPadding bottomPadding:(float) bottomPadding;

+(void) showToast:(id) content withSize:(CGSize) size horizontalGravity:(DCHorizontalGravity) horiontalGravity verticalGravity:(DCVerticalGravity) verticalGravity padding:(UIEdgeInsets) padding inAnimation:(DCAnimationType) inAnimation outAnimation:(DCAnimationType) outAnimation;

+(void) closeDialog;

+(void) showWaitBox:(NSString*) message;

+(void) closeWaitBox;

#ifdef __USE_PREVIEW_DIALOG

+(void) showDocumentPreviewWithTitle:(NSString*) title filePath:(NSString*) filePath;

#endif

@end
