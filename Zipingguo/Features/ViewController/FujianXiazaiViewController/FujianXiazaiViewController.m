//
//  FujianXiazaiViewController.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/15.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "FujianXiazaiViewController.h"
#import "YulanViewController.h"
#import "DCUrlDownloader.h"
#import "AFNetworking.h"
#import "AFDownloadRequestOperation.h"
#import "WenjianYulanViewController.h"
@interface FujianXiazaiViewController ()
{
    NSArray *arr;
    NSString *strUrl;
    NSString *filePath;
    
    AFDownloadRequestOperation * operation;
    NSOperationQueue * queue;
    NSString * docPath;
    NSString * docTempPath;
    
    NSString *filepath;
    
    NSString *docPathggg;
}
@end

@implementation FujianXiazaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"下载附件";
    
    [self loadData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadData{
    name.text = _noticeAnnexsSM.filename;
    strUrl = [NSString stringWithFormat:@"%@%@",URLKEY,_noticeAnnexsSM.fileurl];
    NSString *exit = [[_noticeAnnexsSM.filename componentsSeparatedByString:@"."] lastObject];
    if ([exit isEqualToString:@"docx"] || [exit isEqualToString:@"doc"]) {
        icon.image = [UIImage imageNamed:@"w"];
    }else if ([exit compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame || [exit compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame || [exit compare:@"jpeg" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        icon.image = [UIImage imageNamed:@"图片t"];
    }else if ([exit isEqualToString:@"xlsx"] || [exit isEqualToString:@"xls"]) {
        icon.image = [UIImage imageNamed:@"x"];
    }else if ([exit isEqualToString:@"pptx"] || [exit isEqualToString:@"ppt"]) {
        icon.image = [UIImage imageNamed:@"p"];
    }else if ([exit isEqualToString:@"txt"]) {
        icon.image = [UIImage imageNamed:@"t"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}

#pragma 按钮
- (IBAction)buttonClick:(UIButton *)sender {

    if (sender == xiazai) {
        
        if (_noticeAnnexsSM != nil) {
            
            NSArray *arr1 = [_noticeAnnexsSM.fileurl componentsSeparatedByString:@"."];
            NSString* filePath1 = [[AppContext storageResolver] pathForDownloadedFileFromUrl:[NSString stringWithFormat:@"%@%@",URLKEY,_noticeAnnexsSM.fileurl] fileName:[arr1 lastObject]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath1 isDirectory:NO]) {
                WenjianYulanViewController *yulan = [[WenjianYulanViewController alloc] init];
                yulan.url = [self yulan:[NSString stringWithFormat:@"%@%@",URLKEY,_noticeAnnexsSM.fileurl]];
                yulan.biaoti = _noticeAnnexsSM.filename;
                [self.navigationController pushViewController:yulan animated:YES];
            }else{
                arr = [_noticeAnnexsSM.fileurl componentsSeparatedByString:@"."];
                [self xiazai:_noticeAnnexsSM];
            }
            
        }

    }
    
    
}

#pragma 下载
-(void)xiazai:(NoticeAnnexsSM*)sm
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Downloaded"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@",path);
    }
    
    NSRange range = [sm.fileurl rangeOfString:@"last"];
    
    if (range.location != NSNotFound) {
        sm.fileurl = [sm.fileurl stringByReplacingCharactersInRange:range withString:@"big"];
    }
    
    NSString*str=[NSString stringWithFormat:@"%@%@",URLKEY,sm.fileurl];
    strUrl = str;
    NSArray *arr1 = [str componentsSeparatedByString:@"."];
    //    NSString *path=[docPathggg stringByAppendingPathComponent:@"Downloaded/"];
    NSString * pathName = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",DCMD5ForString(str),[arr1 lastObject]]];
    
    //    NSURL *url = [NSURL URLWithString:str];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
    
    operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:pathName shouldResume:YES];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", [path stringByAppendingPathComponent:str]);
        self.arrayDict = [NSMutableArray arrayWithContentsOfFile:filepath];
        NSLog(@"filePath,self.arrayDict   %@%@",filepath,self.arrayDict);
        for (NSString *str in self.arrayDict) {
            if ([str isEqualToString:DCMD5ForString(sm.fileurl)]) {
                [self.arrayDict addObject:@""];
            }
        }
        
        NSMutableArray *dictarray = [NSMutableArray array];
        [dictarray addObject:DCMD5ForString(sm.fileurl)];
        
        NSMutableArray *temp = [NSMutableArray array];
        [temp addObjectsFromArray:dictarray];
        [temp addObjectsFromArray:self.arrayDict];
        
        self.arrayDict = temp;
        
        
        [self.arrayDict writeToFile:filepath atomically:YES];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self url:[NSString stringWithFormat:@"%@",url] progressDidChange:1];
            
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
    
    [operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        
        
    }];
    [operation start];
}

-(void) url:(NSString*) url progressDidChange:(float) pro{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([strUrl isEqualToString:url]) {
        {
            if (pro == 1.0) {
                WenjianYulanViewController *yulan = [[WenjianYulanViewController alloc] init];
                yulan.url = [self yulan:strUrl];
                [self.navigationController pushViewController:yulan animated:YES];

            }
        }
    }
}

- (NSString *)yulan:(NSString *)url{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSArray *arr1 = [url componentsSeparatedByString:@"."];
    NSString *path=[[pathArray objectAtIndex:0] stringByAppendingPathComponent:@"Downloaded/"];
    NSString * pathName = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",DCMD5ForString(url),[arr1 lastObject]]];
    
    return pathName;
}

@end
