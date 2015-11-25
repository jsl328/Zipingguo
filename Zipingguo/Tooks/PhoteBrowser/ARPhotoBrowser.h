//
//  ARPhotoBrowser.h
//  Ariz
//
//  Created by HeHe丶 on 15/4/20.
//  Copyright (c) 2015年 Linku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARPhotoBrowser : UIViewController

- (void)showBrowserWithImages:(NSArray *)imageArray;
- (void)showImageWithIndex:(int)index;

@end
