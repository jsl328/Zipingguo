//
//  DCDrawImageDialog.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCDrawImageDialog : NSObject

@property (retain, nonatomic) NSString* drawnImageFilePath;

-(void) showDialog:(void (^)(void)) closeCallback;

@end
