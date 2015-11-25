//
//  DCCamera.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-4.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCSelectImageDialog : NSObject

@property (nonatomic) int maxDimension;
@property (retain, nonatomic) NSString* selectedFilePath;


// abstract methods

-(BOOL) isCameraAvailable;

-(void) openSelectImageDialog:(BOOL) isCamera callback:(void (^)(void)) callback;

//

@end
