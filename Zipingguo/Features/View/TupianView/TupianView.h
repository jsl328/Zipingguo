//
//  TupianView.h
//  Lvpingguo
//
//  Created by fuyonghua on 14-8-18.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TupianView;
@protocol TupianViewDelegate <NSObject>

- (void)TupianViewDidTap:(TupianView *)tapView;

@optional
- (void)ShanchuTupian:(TupianView *)tupianView1;

@end

@interface TupianView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *tupianImageBox;
@property (weak, nonatomic) IBOutlet UIButton *shanchuBtn;

@property (nonatomic,assign) id<TupianViewDelegate> delegate;
@end
