//
//  DCCamera.m
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-4.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import "DCSelectImageDialog.h"

@implementation DCSelectImageDialog
@synthesize maxDimension;
@synthesize selectedFilePath;


-(BOOL) isCameraAvailable {
    return NO;
}

-(void) openSelectImageDialog:(BOOL) isCamera callback:(void (^)(void))callback {
}


@end
