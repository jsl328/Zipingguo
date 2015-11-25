//
//  XitongTongzhiCellView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/13.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "XitongTongzhiCellView.h"

@implementation XitongTongzhiCellView

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (void)setModel:(XitongTongzhiModel *)model{
    neirongWebView.delegate = self;
    [neirongWebView loadHTMLString:model.noticeSM.content baseURL:nil];
    name.text = model.noticeSM.title;
    shijian.text = [[model.noticeSM.time componentsSeparatedByString:@" "]lastObject];
    if (model.isRead != 1) {
        hongdian.hidden = NO;
        shijian.frame = CGRectMake(ScreenWidth - 15 - hongdian.width - shijian.width, shijian.y, shijian.width, shijian.height);
    }else{
        hongdian.hidden = YES;
        shijian.frame = CGRectMake(ScreenWidth - 15 - shijian.width, shijian.y, shijian.width, shijian.height);
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
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
    
    NSString *neirong1 = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *str2 = [[NSString alloc] initWithString:[neirong1 stringByTrimmingCharactersInSet:whiteSpace]];
    
    //    NSLog(@"------%@",touVM.tongzhineirong);
    
    if (str2.length != 0) {
        neirong.text = str2;
    }else{
        neirong.text = @"图片";
    }
}

@end
