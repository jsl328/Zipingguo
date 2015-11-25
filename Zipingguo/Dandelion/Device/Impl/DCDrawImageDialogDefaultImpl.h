//
//  DCDrawImageDialogDefaultImpl.h
//  AmaranthDemo
//
//  Created by Bob Li on 14-8-6.
//  Copyright (c) 2014年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDrawImageDialog.h"

@interface DCDrawImageDialogDefaultImpl : DCDrawImageDialog

@end


@interface DCDrawImageOverlay : UIView

@property (retain, nonatomic) DCDrawImageDialogDefaultImpl* drawImageDialog;

@end