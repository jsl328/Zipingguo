//
//  BianjiVC.h
//  Lvpingguo
//
//  Created by miao on 14-8-14.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
#import "ParentsViewController.h"
@protocol beizhubijiDelegate <NSObject>

- (void)beizhuneorong:(NSString *)neirong withIndex:(int)flag;

@end

@interface BianjiVC : ParentsViewController<UITextViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray * bijiArr;
}
@property (strong, nonatomic) NSString *ID;
@property (assign, nonatomic) int ispass;
@property (strong, nonatomic) NSString *neirongStr;
@property (strong, nonatomic) NSString *biaotiTitle;
@property (strong, nonatomic) NSString *chuanzhiNeirong;
@property (nonatomic) int indexFlag;
@property (strong, nonatomic) NSString *applyid;
@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *TextView;
@property (nonatomic, strong) id <beizhubijiDelegate>delegate;

@property (nonatomic ,strong) void (^passValueFromShengpi)(int start);

@end
