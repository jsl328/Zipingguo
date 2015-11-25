//
//  RequestNextPageControl.h
//  Nanumanga
//
//  Created by Bob Li on 13-9-10.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestNextPageControlDelegate.h"

@interface RequestNextPageControl : UITableViewCell {
    UIButton* _maskButton;
    UIActivityIndicatorView* _activityIndicator;
    BOOL _isRefreshing;
}

@property (assign, nonatomic) id <RequestNextPageControlDelegate> delegate;

-(void) setPaginationView:(UIView*) view;

-(BOOL) isRefreshing;

-(void) endRefreshing;
-(void) didClickMaskButton:(id)sender;
@end
