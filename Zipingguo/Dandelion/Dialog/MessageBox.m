//
//  DialogHelper.m
//  Dandelion
//
//  Created by Bob Li on 13-8-29.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "MessageBox.h"
#import "DCDialogManager.h"

@implementation MessageBox

-(id) initWithMessage: (NSString*) message {
    self = [super init];
    if (self) {
        _message = message;
        _button = MessageBoxButtonOK;
    }
    return self;
}

-(id) initWithMessage: (NSString *)message positiveCallback: (void (^)(void)) positiveCallback negativeCallback: (void (^)(void)) negativeCallback  button: (int) button {
    
    self = [super init];
    if (self) {
        
        _positiveCallback = positiveCallback;
        _negativeCallback = negativeCallback;
    
        _message = message;
        _button = button;
    }
    return self;
}

//fyh
-(id) initWithMessage: (NSString *)message negativeCallback: (void (^)(void)) negativeCallback positiveCallback: (void (^)(void)) positiveCallback button: (int) button Type:(BOOL)type{
    self = [super init];
    if (self) {
        
        _negativeCallback = positiveCallback;
        _positiveCallback = negativeCallback;
        
        _message = message;
        _button = button;
        
        isType = type;
        
    }
    return self;
}


-(void) show {
    
    _alertView = [[UIAlertView alloc] init];
    _alertView.message = _message;
    _alertView.delegate = self;
    
    [self addButton:_button];
    
    [_alertView show];
}

-(void) addButton:(int) button {

    if (button == MessageBoxButtonOK) {
        [_alertView addButtonWithTitle:@"确定"];
    }
    else if (button == MessageBoxButtonOKCancel) {
        if (isType) {
            [_alertView addButtonWithTitle:@"取消"];
            [_alertView addButtonWithTitle:@"确定"];
        }else{
            [_alertView addButtonWithTitle:@"确定"];
            [_alertView addButtonWithTitle:@"取消"];
        }
    }
    else if (button == MessageBoxButtonYesNo) {
        [_alertView addButtonWithTitle:@"是"];
        [_alertView addButtonWithTitle:@"否"];
    }
}


-(void) closeDialog {
    _positiveCallback = nil;
    _negativeCallback = nil;
    [self didClose];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0 && _positiveCallback) {
        ((void (^)(void))_positiveCallback)();
    }
    else if (buttonIndex == 1 && _negativeCallback) {
        ((void (^)(void))_negativeCallback)();
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self closeDialog];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    [self closeDialog];
}

@end
