//
//  GetYanZhengMaViewController.h
//  Zipingguo
//
//  Created by 韩飞 on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"
@interface GetYanZhengMaViewController : WaiweiParentsViewController<UITextFieldDelegate>
{
    __weak IBOutlet NSLayoutConstraint *viewHeight;
    __weak IBOutlet UITextField *phoneTF;
    __weak IBOutlet UITextField *yanZhengMaTF;
}

@end
