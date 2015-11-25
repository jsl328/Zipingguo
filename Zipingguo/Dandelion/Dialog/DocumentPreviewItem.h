//
//  DocumentPreviewItem.h
//  Nanumanga
//
//  Created by Bob Li on 13-10-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#ifdef __USE_PREVIEW_DIALOG

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface DocumentPreviewItem : NSObject <QLPreviewItem>

@property(readonly) NSURL * previewItemURL;
@property(readonly) NSString * previewItemTitle;

-(id) initWithFilePath:(NSString*) filePath andTitle:(NSString*) title;

@end

#endif