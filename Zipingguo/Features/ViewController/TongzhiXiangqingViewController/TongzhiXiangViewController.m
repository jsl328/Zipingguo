//
//  TongzhiXiangViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "TongzhiXiangViewController.h"
#import "FujianModel.h"
#import "FujianCellView.h"
#import "FujianXiazaiViewController.h"
#import "WenjianYulanViewController.h"
@interface TongzhiXiangViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    NSMutableArray *_dataArray;
    float heightCell;
}
@end

@implementation TongzhiXiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contentWebview.scrollView.scrollEnabled = NO;
    fujianTableView.scrollEnabled = NO;
    contentWebview.delegate = self;
    _dataArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"通知详情";
    [self addItemWithTitle:@"" imageName:@"删除icon.png" selector:
     @selector(rightSelector) location:NO];
    // Do any additional setup after loading the view from its nib.
    fujianTableView.separatorColor = [UIColor clearColor];
    fujianTableView.backgroundColor = Bg_Color;
    
    if (self.isRead == 0) {//红点减一
        /*
        [ServiceShell getDecreaseReddotWithUserid:[AppStore getYongHuID] Key:@"NOTICE" usingCallback:^(DCServiceContext *serviceContext, ResultMode *sm) {
            if (!serviceContext.isSucceeded) {
                return ;
            }
            if (sm.status == 0) {
                NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"xiaoxiJianyi" object:nil];
            }
        }];
         */
    }
    
    
    [self loadData];
    
}

- (void)rightSelector{
    [ServiceShell getMarkNoticeDelWithUserid:[AppStore getYongHuID] Noticeid:self.tongzhiID usingCallback:^(DCServiceContext *context, ResultMode *sm) {
        if (context.isSucceeded && sm.status == 0) {
            self.passValueFromTongzhixiangqing(self.row);
            [self showHint:sm.msg];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:@"删除失败"];
        }
        
    }];
    
}

- (void)loadData{
    [LDialog showWaitBox:@"数据加载中"];
    [ServiceShell getNoticeDetailWithID:self.tongzhiID Userid:[AppStore getYongHuID] usingCallback:^(DCServiceContext *serviceContext, ResultModelOfNoticeDetailSM *detailSM) {
        [LDialog closeWaitBox];
        if (serviceContext.isSucceeded && detailSM.status == 0) {
            
            name.text = detailSM.data.title;
            shijian.text = detailSM.data.time;
            [contentWebview loadHTMLString:detailSM.data.content baseURL:nil];
            [self fujianData:detailSM.data.noticeAnnexs];
        }
    }];
}

- (void)fujianData:(NSArray *)noticeAnnexs{
    
    [_dataArray removeAllObjects];
    for (NoticeAnnexsSM *annexsSM in noticeAnnexs) {
        FujianModel *model = [[FujianModel alloc] init];
        model.noticeAnnexsSM = annexsSM;
        [_dataArray addObject:model];
    }
    [fujianTableView reloadData];
}

#pragma mark 加载数据完毕
#pragma mark

//WebView代理
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    contentWebview.hidden = NO;
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
    
    //根据内容自适应高度
//    NSString *height_str = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
//    heightCell = [height_str floatValue];
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    heightCell = frame.size.height;
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#ffffff'"];
    
    
    NSLog(@"%f",heightCell);
    [self size];
    //    _webView.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, heightCell);
    
}


#pragma mark - table View delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //自动反选
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FujianModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    NSArray *arr = [model.noticeAnnexsSM.fileurl componentsSeparatedByString:@"."];
    NSString* filePath = [[AppContext storageResolver] pathForDownloadedFileFromUrl:[NSString stringWithFormat:@"%@%@",URLKEY,model.noticeAnnexsSM.fileurl] fileName:[arr lastObject]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO]) {
        WenjianYulanViewController *yulan = [[WenjianYulanViewController alloc] init];
        yulan.url = [self yulan:[NSString stringWithFormat:@"%@%@",URLKEY,model.noticeAnnexsSM.fileurl]];
        yulan.biaoti = model.noticeAnnexsSM.filename;
        [self.navigationController pushViewController:yulan animated:YES];
    }else{
        FujianXiazaiViewController *fujian = [[FujianXiazaiViewController alloc] init];
        fujian.noticeAnnexsSM = model.noticeAnnexsSM;
        [self.navigationController pushViewController:fujian animated:YES];
    }
}

#pragma mark - table View DataSource
//重写两个dataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FujianCellView *fujian = [FujianCellView cellForTableView:tableView];
    
    FujianModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    fujian.model = model;
    
    return fujian;
}

- (void)size{
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    name.frame = CGRectMake(15, 13, ScreenWidth-30, 25);
    shijian.frame = CGRectMake(15, name.frame.size.height+name.frame.origin.y, ScreenWidth-30, 20);
    shangfenge.frame = CGRectMake(0, shijian.frame.origin.y+shijian.frame.size.height+9, ScreenWidth, 1);
    contentWebview.frame = CGRectMake(0, shangfenge.frame.origin.y+shangfenge.frame.size.height, ScreenWidth, heightCell);
    [contentWebview sizeToFit];
    fengexiang.frame = CGRectMake(0, contentWebview.frame.size.height+contentWebview.frame.origin.y, ScreenWidth, 1);
    fujianTableView.frame = CGRectMake(0, fengexiang.frame.size.height+fengexiang.frame.origin.y, ScreenWidth, _dataArray.count*64+64);
    
    if (_dataArray.count != 0) {
        scrollView.contentSize = CGSizeMake(ScreenWidth, fujianTableView.frame.origin.y+fujianTableView.frame.size.height);
    }else{
        scrollView.contentSize = CGSizeMake(ScreenWidth, heightCell);
        
    }
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)yulan:(NSString *)url{
    NSArray *arr = [url componentsSeparatedByString:@"."];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    NSString *path=[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"Downloaded/"];
    NSString * pathName = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",DCMD5ForString(url),[arr lastObject]]];
    return pathName;
}

@end
