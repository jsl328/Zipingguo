//
//  EditRenWuNameViewController.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

@interface EditRenWuNameViewController : ParentsViewController<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *nameTF;
}

@property (nonatomic, assign) BOOL isXinjian;

@property (nonatomic,strong) void(^editFinish)(NSString *content);
@property (nonatomic,copy) NSString *oldContent;
@property (nonatomic,copy) NSString *renWuID;;

@end
