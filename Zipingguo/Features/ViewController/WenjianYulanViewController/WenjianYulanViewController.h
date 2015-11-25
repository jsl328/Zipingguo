//
//  QunzuYulanViewController.h
//  Lvpingguo
//
//  Created by linku on 14-9-26.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCDocumentPreview.h"
#import "DCImagePreview.h"
#import "DCFunctions.h"
#import "ParentsViewController.h"
@interface WenjianYulanViewController : ParentsViewController
{
    
    __weak IBOutlet UIWebView *webView;
}
@property (nonatomic, strong)NSString * url;
@property (nonatomic, strong) NSString *biaoti;
@property (nonatomic) BOOL isCreate;
@end
