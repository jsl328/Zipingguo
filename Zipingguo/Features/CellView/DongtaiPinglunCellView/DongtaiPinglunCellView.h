//
//  DongtaiPinglunCellView.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-6.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCImageFrame.h"
#import "DongtaiPinglunCellVM.h"


@interface DongtaiPinglunCellView : UIView
{
    DongtaiPinglunCellVM *cellVM;
    __weak IBOutlet UIImageView *icon;
    __weak IBOutlet UILabel *content;
}

@end
