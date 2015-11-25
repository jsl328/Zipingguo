//
//  GridBoxSectionHeader.h
//  Mulberry
//
//  Created by Bob Li on 13-10-23.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCContentPresenter.h"

@interface DCItemsBoxSectionHeader : UICollectionReusableView {
    DCContentPresenter* _contentPresenter;
}

@property (nonatomic) BOOL isHeader;
@property (assign, nonatomic) id content;
@property (assign, nonatomic) id section;

@end
