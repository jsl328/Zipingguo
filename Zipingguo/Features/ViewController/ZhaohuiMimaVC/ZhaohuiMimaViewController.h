//
//  ZhaohuiMimaViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface ZhaohuiMimaViewController : WaiweiParentsViewController<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *shoujihao;
    __weak IBOutlet UITextField *yanzhengma;
    __weak IBOutlet UITextField *xinmima;
    __weak IBOutlet UITextField *zaicimima;
    
    __weak IBOutlet UIButton *chongzhiBtn;
    __weak IBOutlet UIButton *chongxinHuoquBtn;
    IBOutlet UILabel *countLabel;
    
}

@property (nonatomic, strong) NSString *shoujihaoHaoma;

@end
