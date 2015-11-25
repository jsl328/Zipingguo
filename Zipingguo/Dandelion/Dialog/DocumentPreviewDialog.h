//
//  DocumentPreviewDialog.h
//  Nanumanga
//
//  Created by Bob Li on 13-10-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#ifdef __USE_PREVIEW_DIALOG

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>
#import "DocumentPreviewItem.h"

@interface DocumentPreviewDialog : NSObject <QLPreviewControllerDataSource> {
    QLPreviewController* _previewController;
    DocumentPreviewItem* _previewItem;
}

@property (retain, nonatomic) NSString* title;
@property (retain, nonatomic) NSString* filePath;

-(void) showInController:(UIViewController*) controller;

@end

#endif