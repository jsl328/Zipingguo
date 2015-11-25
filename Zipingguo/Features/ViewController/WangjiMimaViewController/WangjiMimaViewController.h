//
//  WangjiMimaViewController.h
//  Zipingguo
//
//  Created by fuyonghua on 15/10/28.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "WaiweiParentsViewController.h"

@interface WangjiMimaViewController : WaiweiParentsViewController<UITextFieldDelegate>
{
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UITextField *shoujihao;
    __weak IBOutlet UIButton *tijiaoBtn;
    
}
@end
