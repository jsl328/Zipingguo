//
//  ActionSheetDialog.m
//  Nanumanga
//
//  Created by Bob Li on 13-9-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "ActionSheetDialog.h"
#import "AppContext.h"
#import "DCDialogManager.h"

@implementation ActionSheetDialog
@synthesize title;
@synthesize items;

-(id) initWithCallback:(void (^)(int)) buttonClickCallback {
    self = [super init];
    if (self) {
        _buttonClickCallback = buttonClickCallback;
        [[DCDialogManager defaultManager] addDialog:self];
    }
    return self;
}

-(void) show {
    
    _actionSheet = [[UIActionSheet alloc] init];
    
    int destructiveItemIndex = -1;
    int index = 0;
    
    for (NSString* item in self.items) {
        NSString* actualTitle = item;
        if ([[item substringToIndex:1] isEqualToString:@"!"]) {
            destructiveItemIndex = index;
            actualTitle = [item substringFromIndex:1];
        }
        else {
            actualTitle = item;
        }
        [_actionSheet addButtonWithTitle:actualTitle];
        index++;
    }
    
    [_actionSheet addButtonWithTitle:@"取消"];
    [_actionSheet setCancelButtonIndex:items.count];
    
    if (destructiveItemIndex >= 0) {
        [_actionSheet setDestructiveButtonIndex:destructiveItemIndex];
    }
    
    _actionSheet.delegate = self;
    [_actionSheet showInView:[AppContext controller].view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    ((void (^)(int))_buttonClickCallback)(buttonIndex);
    [self closeDialog];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    [self closeDialog];
}

-(void) closeDialog {
    _buttonClickCallback = nil;
    [self didClose];
}

@end
