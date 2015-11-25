//
//  ActionSheetDialog.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-17.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDialog.h"

@interface ActionSheetDialog : DCDialog <UIActionSheetDelegate> {
    UIActionSheet* _actionSheet;
    id _buttonClickCallback;
}

@property (retain, nonatomic) NSString* title;
@property (retain, nonatomic) NSArray* items;

-(id) initWithCallback:(void (^)(int)) buttonClickCallback;

@end
