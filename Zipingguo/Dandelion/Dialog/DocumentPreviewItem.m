//
//  DocumentPreviewItem.m
//  Nanumanga
//
//  Created by Bob Li on 13-10-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#ifdef __USE_PREVIEW_DIALOG

#import "DocumentPreviewItem.h"

@implementation DocumentPreviewItem
@synthesize previewItemTitle;
@synthesize previewItemURL;

-(id) initWithFilePath:(NSString*) filePath andTitle:(NSString *)title {
    self = [super init];
    if (self) {
        previewItemURL = [NSURL fileURLWithPath:filePath];
        previewItemTitle = title;
    }
    return self;
}

@end

#endif
