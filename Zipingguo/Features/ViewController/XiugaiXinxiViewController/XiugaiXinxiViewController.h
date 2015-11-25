//
//  XiugaiXinxiViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

typedef void (^ReturnValueBlock)(NSString *value);

@interface XiugaiXinxiViewController : ParentsViewController
@property (nonatomic, strong) NSString *titleText;
@property (nonatomic, copy) ReturnValueBlock returnValue;
@property (nonatomic, strong) NSString *chuanzhiStr;
@property (weak, nonatomic) IBOutlet UIView *xiugaiView;
@property (weak, nonatomic) IBOutlet UITextField *xiugaiXinxi;

-(void)returnText:(ReturnValueBlock)value;

@end
