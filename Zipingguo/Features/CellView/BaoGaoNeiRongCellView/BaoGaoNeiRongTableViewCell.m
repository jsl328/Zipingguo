//
//  BaoGaoNeiRongTableViewCell.m
//  Zipingguo
//
//  Created by lilufeng on 15/10/16.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import "BaoGaoNeiRongTableViewCell.h"
#import "NSString+Ext.h"
@implementation BaoGaoNeiRongTableViewCell
{

    
}
//int _jinriWeb_h;
//int _mingriWeb_h;
+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }

    return cell;
}


- (void)awakeFromNib {
    // Initialization code
//    _jinriWebView.delegate = self;
//    _mingriWebView.delegate = self;
    
    _jinriTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _mingriTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);

    
}

-(void)setModel:(BaoGaoNeiRongTableViewCellModel *)model{
    if (model) {
        _model = model;
        
        switch (model.leixing) {
            case 1://日报
            {
                _jinriLabel.text = @"今日总结";
                _mingriLabel.text = @"明日计划";
            
            }
                break;
            case 2://周报
            {
                _jinriLabel.text = @"本周总结";
                _mingriLabel.text = @"下周计划";

            }
                break;
            case 3://月报
            {
                _jinriLabel.text = @"本月总结";
                _mingriLabel.text = @"下月计划";

            }
                break;

            default:
                break;
        }
        
        
//        [_jinriWebView loadHTMLString:model.jinrihtml baseURL:nil];
//        [_mingriWebView loadHTMLString:model.mingrihtml baseURL:nil];
//        if (!self.isload) {
//            _jinriWebView.delegate = nil;
//            _mingriWebView.delegate = nil;
//            
//        }
        
        _jinriTextView.text = model.jinrihtml;
        _mingriTextView.text = model.mingrihtml;
        [_jinriTextView sizeToFit];
        [_mingriTextView sizeToFit];

//        CGSize size = [model.jinrihtml calculateSize:CGSizeMake(ScreenWidth - 20, FLT_MAX) font:[UIFont systemFontOfSize:13]];
//        _jinriTextView.size = CGSizeMake(ScreenWidth, size.height + 20);
//        CGSize size1 = [model.jinrihtml calculateSize:CGSizeMake(ScreenWidth - 20, FLT_MAX) font:[UIFont systemFontOfSize:13]];
//        _mingriTextView.size = CGSizeMake(ScreenWidth, size1.height + 20);
        
        NSLog(@"里面 %f  %f",_jinriTextView.height,_mingriTextView.height);

        [self layoutSubviews];
        
        
//        NSDictionary *attrsDictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:RGBACOLOR(53, 55, 68, 1)};
//
//        //这是uiTextview加载html的方法，
//        NSAttributedString * attStr = [[NSAttributedString alloc] initWithData:[model.jinrihtml dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil  error:nil];
//        
//        NSMutableAttributedString *muAttStr = [[NSMutableAttributedString alloc]initWithAttributedString:attStr];
//        [muAttStr setAttributes:attrsDictionary range:NSMakeRange(0, attStr.length)];
//        _jinriTextView.attributedText = muAttStr;
//        [_jinriTextView sizeToFit];
//
//        
//        NSAttributedString * attStr1 = [[NSAttributedString alloc] initWithData:[model.mingrihtml dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        NSMutableAttributedString *muAttStr1 = [[NSMutableAttributedString alloc]initWithAttributedString:attStr1];
//        [muAttStr1 setAttributes:attrsDictionary range:NSMakeRange(0, attStr1.length)];
//        _mingriTextView.attributedText = muAttStr1;
//        [_mingriTextView sizeToFit];

    }
//    
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    
//    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
//    if (webView == _jinriWebView) {
//        _jinriWeb_h = [height_str integerValue];
//        _jinriWebView.size = CGSizeMake(ScreenWidth, _jinriWeb_h);
// 
//        
//    }else{
//        _mingriWeb_h = [height_str intValue];
//        _mingriWebView.size = CGSizeMake(ScreenWidth, _mingriWeb_h);
//
//    }
//    
//    [webView sizeToFit];
//    webView.scrollView.scrollEnabled = NO;
//  
//    _model.cellHeight = 100 + _jinriWeb_h + _mingriWeb_h;
//
//    [self layoutSubviews];
//    if (!(_jinriWebView.isLoading || _mingriWebView.isLoading)) {//都加载完成
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"jiazaiwancheng" object:[NSNumber numberWithFloat:_model.cellHeight]];
//
//    }
//   
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{

    [super layoutSubviews];
//    _jinriWebView.frame = CGRectMake(0, _jinriLabel.height + 15, ScreenWidth, _jinriWeb_h + 10);
//    _jinriWebView.scrollView.scrollEnabled = NO;
//    _mingriLabel.frame = CGRectMake(15, CGRectGetMaxY(_jinriWebView.frame) + 15, ScreenWidth, _mingriLabel.height);
//    _mingriWebView.frame = CGRectMake(0, CGRectGetMaxY(_mingriLabel.frame), ScreenWidth, _mingriWeb_h + 10);
//    _mingriWebView.scrollView.scrollEnabled = NO;

    _jinriTextView.frame = CGRectMake(0, CGRectGetMaxY(_jinriLabel.frame) , ScreenWidth, _jinriTextView.height);
    _mingriLabel.frame = CGRectMake(15, CGRectGetMaxY(_jinriTextView.frame) + 5 , ScreenWidth, _mingriLabel.height);
    _mingriTextView.frame =  CGRectMake(0, CGRectGetMaxY(_mingriLabel.frame), ScreenWidth, _mingriTextView.height);

    
}

@end

@implementation BaoGaoNeiRongTableViewCellModel


@end