//
//  ZiXunXiangQingViewController.m
//  Zipingguo
//
//  Created by sunny on 15/10/12.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

// 左右边距
#define margin 15
// 上边距
#define marginH 12
// 底部view高度
#define bottomViewH 49

#import "ZiXunXiangQingViewController.h"
#import "UILabel+Extension.h"
#import "CustomActionSheet.h"
#import "UMSocial.h"
#import "ZiXunPingLunViewController.h"
#import "ZiXunServiceShell.h"

@interface ZiXunXiangQingViewController ()<UIWebViewDelegate>{
    float webViewHeight;
    
    ZiXunXiangQingSM *xiangQingSM;
    NSString *fenXiangContent;
}

@end

@implementation ZiXunXiangQingViewController
@synthesize ziXunID,ziXunCellModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"资讯详情";
    bgScrollView.hidden = YES;
    bgScrollView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    contentWebView.scrollView.scrollEnabled = NO;
    contentWebView.userInteractionEnabled = NO;
    contentWebView.backgroundColor = [UIColor whiteColor];
    [self loadData];
    
}
- (void)loadData{
    if ([NetWork isConnectionAvailable]) {
        [ZiXunServiceShell getZiXunXiangQingWithZiXunID:ziXunID YongHuID:[AppStore getYongHuID] usingCallback:^(DCServiceContext *context, ZiXunXiangQingSM *sm) {
            if (context.isSucceeded) {
                bgScrollView.hidden = NO;
                xiangQingSM = sm;
                [self fillDataWith:sm];
            }
        }];
    }
}
- (void)fillDataWith:(ZiXunXiangQingSM *)sm{
    ZiXunContentSM *contentSM = sm.data;
    // 已收藏过
    if (contentSM.iscollect == 1) {
        shouCangBtn.selected = YES;
    }
    // 已赞
    if (contentSM.ispraise == 1) {
        dianZanBtn.selected = YES;
    }
    
    titleNameLabel.text = contentSM.title;
    titleNameLabel.frame = CGRectMake(margin, marginH, ScreenWidth - 2 * margin, [titleNameLabel getLabelSizeWithLabelMaxWidth: ScreenWidth - 2 * margin MaxHeight:MAXFLOAT FontSize:[UIFont systemFontOfSize:16] LabelText:titleNameLabel.text].height);
    detailLabel.frame = CGRectMake(titleNameLabel.x, CGRectGetMaxY(titleNameLabel.frame) + 5, ScreenWidth - 2 * margin, detailLabel.height);
    detailLabel.text = [NSString stringWithFormat:@"%@    阅读(%d)    赞(%d)",contentSM.time,contentSM.readamount,contentSM.praisecount];
    lineImageView.frame = CGRectMake(0, CGRectGetMaxY(detailLabel.frame) + marginH - 1, ScreenWidth, 1);
    lineImageView.hidden = NO;
    NSString *tipStr;
    if ([contentSM.memo length]> 0 && contentSM.memo != nil && contentSM.memo != NULL && ![contentSM.memo isEqual:[NSNull null]]) {
        tipStr = [NSString stringWithFormat:@"注:%@",contentSM.memo];
    }
    if ([tipStr length] <= 0) {
        midView.hidden = YES;
    }else{
        midView.hidden = NO;
        tipLabel.text = tipStr;
        float h =  [tipLabel getLabelSizeWithLabelMaxWidth:ScreenWidth - 2*margin MaxHeight:MAXFLOAT FontSize:[UIFont systemFontOfSize:12] LabelText:tipLabel.text].height;
        tipLabel.frame = CGRectMake(margin, margin, ScreenWidth - 2*margin, h);
    }
    NSString *str = [contentSM.content stringByReplacingOccurrencesOfString:@"width: 1142px" withString:[NSString stringWithFormat:@"width: %fpx",ScreenWidth]];
    
    NSString *str2 = [contentSM.content stringByReplacingOccurrencesOfString:@"width: 636.015625px" withString:[NSString stringWithFormat:@"width: %fpx",ScreenWidth - 20]];
    
    NSRange strRange1 = [contentSM.content rangeOfString:@"width: 1142px"];
    NSRange strRange2 = [contentSM.content rangeOfString:@"width: 636.015625px"];
    
    if (strRange1.location != NSNotFound) {
        [contentWebView loadHTMLString:str baseURL:nil];
    }else if(strRange2.location != NSNotFound){
        [contentWebView loadHTMLString:str2 baseURL:nil];
    }else{
        [contentWebView loadHTMLString:str baseURL:nil];
    }
    
}

#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //拦截网页图片  并修改图片大小
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var maxwidth=300;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "myimg.width = maxwidth;"
     "myimg.height = (maxwidth*myimg.height)/myimg.width;"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    // webView高度
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webViewHeight = frame.size.height;
    webView.hidden = NO;
    // 背景色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#ffffff'"];
    // 禁止长按
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    if ([tipLabel.text length] <= 0) {
        midView.hidden = YES;
    }else{
        midView.hidden = NO;
    }
    
    // 获取文章内容，纯文本
    [webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function getAllText() {"
     "var allPele = document.getElementsByTagName('p');"
     "var alltext = '';"
     "for (var i = 0; i < allPele.length; i++) {"
     "alltext += allPele[i].textContent;}"
     "return alltext;"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    NSString *neirong = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    fenXiangContent = [[NSString alloc] initWithString:[neirong stringByTrimmingCharactersInSet:whiteSpace]];
    [self viewDidLayoutSubviews];
}

#pragma mark - action
- (IBAction)bottomBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    BOOL isShouCangOrZan = sender.selected;
    if ([sender isEqual:shouCangBtn]) {
        [self shouCang:isShouCangOrZan];
    }else if ([sender isEqual:fenXiangBtn]){
        [self fenXiang];
    }else if ([sender isEqual:pingLunBtn]){
        [self pingLun];
    }else if ([sender isEqual:dianZanBtn]){
        [self dianZan:isShouCangOrZan];
    }
}
- (void)shouCang:(BOOL)isShouCang{
    if (isShouCang == YES) {
        [ZiXunServiceShell shouCangZiXunWithYongHuID:[AppStore getYongHuID] ZiXunID:ziXunID UsingCallback:^(DCServiceContext *context, ZiXunShouCangSM *sm) {
            if (sm.status == 0) {
                [self showHint:@"收藏成功"];
                self.actionCallback(@"收藏");
            }
        }];
    }else{
        [ZiXunServiceShell quXiaoShouCangWithYongHuID:[AppStore getYongHuID] ZiXunID:ziXunID UsingCallback:^(DCServiceContext *context, ZiXunQuXiaoShouCangSM *sm) {
            if (sm.status == 0) {
                [self showHint:@"取消收藏成功"];
                self.actionCallback(@"取消收藏");
            }
        }];
    }
    
}
- (void)fenXiang{
    // 设置分享授权 -- 回调地址
    [ShareApp setUMSharedWith:[NSString stringWithFormat:@"%@/yamiapi/wechat/consultation/shareconsult.jsp?id=%@",fenXiangURL,ziXunID]];
    CustomActionSheet *customActionSheet = [[CustomActionSheet alloc] initWithTitle:nil OtherButtons:@[@"分享到微信朋友圈",@"分享到QQ空间",@"分享到微信",@"分享到QQ好友"] CancleButton:@"取消" Rect:CGRectMake(0, 0,ScreenWidth, ScreenHeight)];
//    customActionSheet.delegate = self;
    [self setMoHuViewWithHeight:customActionSheet.actionSheetHeight];
    [ShareApp.window addSubview:customActionSheet];
//    [customActionSheet show];
    [self showMoHuView];
    [customActionSheet showButtons:^(NSInteger index) {
        NSString *fenXiangStyle;
        switch (index) {
            case 0:
                
                return;
            case 1:{
                // 微信朋友圈
                fenXiangStyle = UMShareToWechatTimeline;
            }
                break;
            case 2:{
                // QQ空间
                fenXiangStyle = UMShareToQzone;
            }
                break;
            case 3:{
                // 微信好友
                fenXiangStyle = UMShareToWechatSession;
            }
                break;
            case 4:{
                // QQ好友
                fenXiangStyle = UMShareToQQ;
            }
                break;
                
            default:
                break;
        }
        [self fenXiang:fenXiangStyle];
        [self hideMoHuView];
    } cancle:^{
        [self hideMoHuView];
    }];
    
}



- (void)pingLun{
    ZiXunPingLunViewController *vc = [[ZiXunPingLunViewController alloc] init];
    vc.ziXunID = ziXunID;
    vc.ziXunCellModel = ziXunCellModel;
    vc.pingLunChange = ^(ZiXunCellModel *ziXunCellModel){
        self.actionCallback(@"评论");
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dianZan:(BOOL)isZan{
    if (isZan == YES) {
        [ZiXunServiceShell dianZanWithYongHuID:[AppStore getYongHuID] ZiXunID:ziXunID CreateName:[AppStore getYongHuMing] UsingCallback:^(DCServiceContext *context, ZiXunZanSM *sm) {
            if (context.isSucceeded && sm.Status == 0) {
                [self showHint:@"点赞成功"];
                xiangQingSM.data.praisecount ++;
                detailLabel.text = [NSString stringWithFormat:@"%@    阅读(%d)    赞(%d)",xiangQingSM.data.time,xiangQingSM.data.readamount,xiangQingSM.data.praisecount];
                self.actionCallback(@"赞");
            }
        }];

    }else{
        [ZiXunServiceShell quXiaoZanWithYongHuID:[AppStore getYongHuID] ZiXunID:ziXunID UsingCallback:^(DCServiceContext *context, ZiXunZanSM *sm) {
            [self showHint:@"已取消赞"];
            if (context.isSucceeded && sm.Status == 0) {
                xiangQingSM.data.praisecount --;
                detailLabel.text = [NSString stringWithFormat:@"%@    阅读(%d)    赞(%d)",xiangQingSM.data.time,xiangQingSM.data.readamount,xiangQingSM.data.praisecount];
                
                self.actionCallback(@"赞");
            }
        }];
    }
    
}
#pragma mark - actionSheetDelegate
//- (void)CustomActionSheetDelegateDidClickCancelButton:(CustomActionSheet *)customActionSheet{
//    [self hideMoHuView];
//}
//- (void)CustomActionSheetDelegateDidClickIndex:(NSInteger)indexButton customActionView:(CustomActionSheet *)customActionSheet{
//    [self hideMoHuView];
//    NSString *fenXiangStyle;
//    switch (indexButton) {
//        case 0:
//        
//            return;
//        case 1:{
//            // 微信朋友圈
//            fenXiangStyle = UMShareToWechatTimeline;
//            }
//            break;
//        case 2:{
//            // QQ空间
//            fenXiangStyle = UMShareToQzone;
//        }
//            break;
//        case 3:{
//            // 微信好友
//            fenXiangStyle = UMShareToWechatSession;
//        }
//            break;
//        case 4:{
//            // QQ好友
//            fenXiangStyle = UMShareToQQ;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    [self fenXiang:fenXiangStyle];
//}
- (void)fenXiang:(NSString *)fenXiangStyle{

    // 设置图片链接
    if ([fenXiangStyle isEqualToString:UMShareToSms] || [fenXiangStyle isEqualToString:UMShareToSina]) {
        [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"%@/yamiapi/wechat/consultation/shareconsult.jsp?id=%@",fenXiangURL,ziXunID];
    }
    // 分享的标题
    [UMSocialData defaultData].extConfig.title = xiangQingSM.data.title;
    // 设置分享的图片
    
    
    if (![fenXiangStyle isEqualToString:UMShareToSms]) {
        if (self.fenXiangImage == nil || self.fenXiangImage.length == 0 || [self.fenXiangImage isEqual:[NSNull null]] || self.fenXiangImage == NULL) {
            UIImage *fenXiangImage = [UIImage imageNamed:@"背景.png"];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[fenXiangStyle] content:fenXiangContent image:fenXiangImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }else{
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:[NSString stringWithFormat:@"%@%@",URLKEY,self.fenXiangImage]];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[fenXiangStyle] content:fenXiangContent image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"分享成功！");
                }
            }];
        }
    }
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    bgScrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight - bottomViewH);
    topView.frame = CGRectMake(0, 0, ScreenWidth, CGRectGetMaxY(detailLabel.frame) + marginH);
    contentWebView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth, webViewHeight);
    if (midView.hidden == YES) {
        midView.frame = CGRectMake(0, ScreenHeight, 0, 0);
    }else{
        midView.frame = CGRectMake(0, CGRectGetMaxY(contentWebView.frame), ScreenWidth, tipLabel.height + 2 * margin);
    }
    if (CGRectGetMaxY(contentWebView.frame) + CGRectGetHeight(midView.frame) <= bgScrollView.height) {
        bgScrollView.contentSize = CGSizeMake(ScreenWidth, bgScrollView.height + 1);
    }else{
        bgScrollView.contentSize = CGSizeMake(ScreenWidth, CGRectGetMaxY(contentWebView.frame) + CGRectGetHeight(midView.frame));
    }
    bottomView.frame = CGRectMake(0, self.view.height - bottomViewH, ScreenWidth, bottomViewH);
    int btnW = ScreenWidth/4;
    shouCangBtn.frame = CGRectMake(0, 0, btnW, shouCangBtn.height);
    fenXiangBtn.frame = CGRectMake(btnW, 0, ScreenWidth/2 - btnW, shouCangBtn.height);
    pingLunBtn.frame = CGRectMake(CGRectGetMaxX(fenXiangBtn.frame), 0, btnW, shouCangBtn.height);
    dianZanBtn.frame = CGRectMake(CGRectGetMaxX(pingLunBtn.frame), 0, ScreenWidth/2 - btnW, shouCangBtn.height);
}

@end
