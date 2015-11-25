//
//  DocumentPreviewDialog.m
//  Nanumanga
//
//  Created by Bob Li on 13-10-20.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#ifdef __USE_PREVIEW_DIALOG

#import "DocumentPreviewDialog.h"

@implementation DocumentPreviewDialog
@synthesize title;
@synthesize filePath;

-(void) showInController:(UIViewController *)controller {
    
    _previewController = [[QLPreviewController alloc] init];
    _previewController.dataSource = self;

    if ([controller.class isSubclassOfClass:[UINavigationController class]]) {
        [(UINavigationController*)controller pushViewController:_previewController animated:YES];
    }
    else {
        [controller presentViewController:_previewController animated:YES completion:nil];
    }
}


- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return [[DocumentPreviewItem alloc] initWithFilePath:self.filePath andTitle:self.title];
}

@end

#endif
