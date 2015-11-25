//
//  XinJianBaoGaoViewController.h
//  Zipingguo
//
//  Created by lilufeng on 15/10/10.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"

@interface XinJianBaoGaoViewController : ParentsViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic) int leixing;//1-日报 2-周报 3-月报



@end
