//
//  WaitBox.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-1.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaitBox : UIView

@property (retain, nonatomic) UIColor* maskColor;
@property (retain, nonatomic) NSString* message;

@property (nonatomic) BOOL isSupressed;

+(WaitBox*) defaultWaitBox;

-(void) show;
-(void) close;

@end
