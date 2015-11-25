//
//  DengluViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface DengluViewController : WaiweiParentsViewController<UITextFieldDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *shoujihao;
    __weak IBOutlet UITextField *mima;
    __weak IBOutlet UIButton *dengluBtn;
    __weak IBOutlet UIButton *wangjiMimaBtn;
    __weak IBOutlet UIButton *zhuceBtn;
}
@end
