//
//  DialogHelper.h
//  Dandelion
//
//  Created by Bob Li on 13-8-29.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDialog.h"

#define MessageBoxButtonOK 0
#define MessageBoxButtonOKCancel 1
#define MessageBoxButtonYesNo 2

@interface MessageBox : DCDialog <UIAlertViewDelegate> {
    
    UIAlertView* _alertView;

    id _positiveCallback;
    
    id _negativeCallback;
    
    NSString* _message;
    
    int _button;
    
    BOOL isType;
}

-(id) initWithMessage: (NSString*) message;

-(id) initWithMessage: (NSString *)message positiveCallback: (void (^)(void)) positiveCallback negativeCallback: (void (^)(void)) negativeCallback button: (int) button;

-(id) initWithMessage: (NSString *)message negativeCallback: (void (^)(void)) negativeCallback positiveCallback: (void (^)(void)) positiveCallback button: (int) button Type:(BOOL)type;

@end
