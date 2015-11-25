//
//  DongtaiCellView.m
//  Zipingguo
//
//  Created by fuyonghua on 15/10/21.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "DongtaiCellView.h"
#import "UILabel+Extension.h"
#import "DCUrlDownloader.h"
#import "EMAudioPlayerUtil.h"

@implementation DongtaiCellView

+ (id)cellForTableView:(UITableView *)tableView{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[self class] description]];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setModel:(DongtaiModel *)model{
    _model = model;
    
    if (model.dynamicSM.dynamic.isrelation == 0) {
        guanzhuBtn.hidden = NO;
        quxiaoGuanzhuBtn.hidden = YES;
    }else if(model.dynamicSM.dynamic.isrelation == 1){
        guanzhuBtn.hidden = YES;
        quxiaoGuanzhuBtn.hidden = NO;
    }
    
    name.text = model.dynamicSM.dynamic.createname;
    [touxiang setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,model.dynamicSM.dynamic.createurl] fileName:@"头像80.png" Width:touxiang.frame.size.width];
    
    //单机
    UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapOne.numberOfTapsRequired = 1;
    
    [touxiang addGestureRecognizer:singleTapOne];
    
    
    time.text = model.dynamicSM.dynamic.time;
    neirong.text = model.dynamicSM.dynamic.content;
    
    for (UIView *subView in self.contentView.subviews) {
        if ([subView isKindOfClass:[TupianView class]]) {
            [subView removeFromSuperview];
        }
        if ([subView isKindOfClass:[YuyinView class]]) {
            [subView removeFromSuperview];
        }
        if ([subView isKindOfClass:[WeizhiView class]]) {
            [subView removeFromSuperview];
        }
        if ([subView isKindOfClass:[ZanPingShanView class]]) {
            [subView removeFromSuperview];
        }
        if ([subView isKindOfClass:[ZanView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (_model.dynamicSM.dysounds.count != 0) {
        for (DysoundsSM *sm in _model.dynamicSM.dysounds) {
            
            NSString *strUrl = [NSString stringWithFormat:@"%@%@",URLKEY,sm.soundurl];
            NSArray *arr = [sm.soundurl componentsSeparatedByString:@"."];
            NSString* filePath = [[AppContext storageResolver] pathForDownloadedFileFromUrl:strUrl fileName:[arr lastObject]];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO]) {
                [[DCUrlDownloader defaultDownloader] downloadUrl:strUrl fileName:[arr lastObject] limitSize:-1];
            }
        }
    }
    
    [self sizeofClass];
}

#pragma mark 内容大小
- (void)sizeofClass{
    
    float width = ScreenWidth-85;
    CGSize contentSize  = [neirong.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(width,MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    //调整各个控件的frame,将计算好的size给到infoLabel
    neirong.frame = CGRectMake(neirong.x, neirong.y,width, contentSize.height);
    CGRect rect;
    rect.origin.y = 64.0;
    rect.size.height = 0;
    if (neirong.text.length != 0) {
        [self createYuyin:neirong.frame];
    }else{
        [self createYuyin:rect];
    }
}
#pragma mark 语音
- (void)createYuyin:(CGRect)rect{
    yuyinViewArray = [[NSMutableArray alloc] init];
    float yuyinHeight = 26.0;
    float yuyinWidth = 77.0;
    float panding = 5;
    for (int i = 0; i < _model.dynamicSM.dysounds.count; i++) {
        DysoundsSM *dysoundsSM = [_model.dynamicSM.dysounds objectAtIndex:i];
        yuyinView = [[YuyinView alloc] init];
        yuyinView.miaoshuLabel.text = [NSString stringWithFormat:@"%@''",dysoundsSM.spendtime];
        yuyinView.soundurl = [NSString stringWithFormat:@"%@%@",URLKEY,dysoundsSM.soundurl];
        yuyinView.frame = CGRectMake(70, rect.origin.y+rect.size.height+panding+i*(yuyinHeight+panding), yuyinWidth, yuyinHeight);
        yuyinView.delegate = self;
        yuyinView.guanbiBtn.hidden = YES;
        
        yuyinView.bofangBtn.tag = i;
        [yuyinViewArray addObject:yuyinView];
        
        [self.contentView addSubview:yuyinView];
    }
    
    if (_model.dynamicSM.dysounds.count != 0) {
        [self createTupian:yuyinView.frame];
    }else{
        [self createTupian:rect];
    }
    
}
#pragma mark 图片
- (void)createTupian:(CGRect)rect{
    
    tupianUrlArray = [@[]mutableCopy];
    
    photos = [@[]mutableCopy];
    tpArray = [@[]mutableCopy];
    tupianArray = [@[]mutableCopy];
    
    CGRect f;
    for (int i = 0; i < _model.dynamicSM.dyimgs.count; i++) {
        DyimgsSM *imgsSM = [_model.dynamicSM.dyimgs objectAtIndex:i];
        float imageWidth = (ScreenWidth-85-10)/3.0;
        float imageHeight = (ScreenWidth-85-10)/3.0;
        float panding = 5.0;
        TupianView * imageView = [[TupianView alloc] init];
        imageView.shanchuBtn.hidden = YES;
        imageView.delegate = self;
        imageView.frame = CGRectMake(i%3*(imageWidth+panding)+70, rect.origin.y+rect.size.height+panding+i/3*(imageHeight+5), imageWidth, imageHeight);
        f = imageView.frame;
        [imageView.tupianImageBox setUrl:[NSString stringWithFormat:@"%@%@",URLKEY,imgsSM.imgurl] fileName:@"图片110.png"];
        
        NSString *imageUrl = [imgsSM.imgurl stringByReplacingOccurrencesOfString:@"last" withString:@"big"];
        [tpArray addObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URLKEY,imageUrl]]];
//        [tpArray addObject:imageView.tupianImageBox.image];
        [tupianArray addObject:imageView];
        
        [self.contentView addSubview:imageView];
    }
    
    if (_model.dynamicSM.dyimgs.count != 0) {
        [self createZanPingShan:f];
    }else {
        [self createZanPingShan:rect];
    }
    
    
}
#pragma mark 位置
- (void)createWeizhi:(CGRect)rect{
    weizhiView = [[WeizhiView alloc] init];
    weizhiView.shanchuBtn.hidden = YES;
    if ([_model.dynamicSM.dynamic.address isEqualToString:@""]) {
        _model.dynamicSM.dynamic.address = @"";
    }else if(_model.dynamicSM.dynamic.address != nil){
        weizhiView.weizhi.text = _model.dynamicSM.dynamic.address;
    }
    float panding = 5.0;
    weizhiView.shuxian.hidden = YES;
    weizhiView.frame = CGRectMake(70, rect.origin.y+rect.size.height+panding, ScreenWidth-85, 26);
    if (![_model.dynamicSM.dynamic.address isEqualToString:@""]) {
        [self.contentView addSubview:weizhiView];
    }
    
    if (_model.dynamicSM.dynamic.address.length != 0) {
        [self createZanPingShan:weizhiView.frame];
    }else{
        [self createZanPingShan:rect];
    }
}
#pragma mark 赞评删
- (void)createZanPingShan:(CGRect)rect{
    zanpingShanView = [[ZanPingShanView alloc] init];
    zanpingShanView.delegate = self;
    zanpingShanView.frame = CGRectMake(0, rect.origin.y+rect.size.height, ScreenWidth, 40);
    zanpingShanView.addles.text = weizhiView.weizhi.text = _model.dynamicSM.dynamic.address;
    if ([_model.dynamicSM.dynamic.createid isEqualToString:[AppStore getYongHuID]]) {
        zanpingShanView.shanchuBtn.hidden = NO;
    }else{
        zanpingShanView.shanchuBtn.hidden = YES;
    }
    
    if (_model.dynamicSM.dypraises.count != 0) {
        [zanpingShanView.dianzanBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)_model.dynamicSM.dypraises.count] forState:UIControlStateNormal];
        
        if (_model.dynamicSM.dynamic.ispraise == 1) {
            zanpingShanView.dianzanBtn.selected = YES;
        }
    }
    
    if (_model.dynamicSM.dycomments.count != 0) {
        [zanpingShanView.pinglunBtn setTitle:[NSString stringWithFormat:@"%d",_model.dynamicSM.commentscount] forState:UIControlStateNormal];
        
    }
    
    [self.contentView addSubview:zanpingShanView];
    
//    [self createZanPing:zanpingShanView.frame];
    [self createZan:zanpingShanView.frame];
    
}

- (void)createZan:(CGRect)rect{
    if (_model.dynamicSM.dypraises.count != 0) {
        zanpingView = [[ZanView alloc] init];
        NSMutableArray *zanName = [@[]mutableCopy];
        for (int i = 0; i < _model.dynamicSM.dypraises.count; i++) {
            if (i <= 5) {
                DypraisesSM *praisesSM;
                
                if (i < 5) {
                    praisesSM = [_model.dynamicSM.dypraises objectAtIndex:i];
                    [zanName addObject:praisesSM.createname];
                    zanpingView.zanName.text = [zanName componentsJoinedByString:@","];
                }else{
                    zanpingView.zanName.text = [NSString stringWithFormat:@"%@等%ld人",[zanName componentsJoinedByString:@","],(unsigned long)_model.dynamicSM.dypraises.count];
                }
                
            }
            
        }
        [zanpingView.zanName addAttributeWithString:zanpingView.zanName.text andColorValue:RGBACOLOR(52, 55, 68, 1) andUIFont:zanpingView.zanName.font andRangeString:[NSString stringWithFormat:@"等%ld人",(unsigned long)_model.dynamicSM.dypraises.count]];
        
        zanpingView.frame = CGRectMake(15, rect.origin.y+rect.size.height, ScreenWidth-2*15, 40);
        [self.contentView addSubview:zanpingView];
    }
    
    if (_model.dynamicSM.dypraises.count != 0) {
        [self createPing:zanpingView.frame];
    }else{
        [self createPing:rect];
    }
}

- (void)createPing:(CGRect)rect{
    listBox.delegate = self;
    for (UIView *subView in listBox.subviews) {
        if ([subView isKindOfClass:[UITableView class]]) {
            UITableView *tab = (UITableView *)subView;
            tab.scrollEnabled = NO;
        }
    }
    
    
    [dataArray removeAllObjects];
    [listBox setSeparatorColor:[UIColor clearColor]];
    [listBox setSelectedCellColor:RGBACOLOR(223, 229, 237, 1)];
    viewHeight = 0.0;
    if (_model.dynamicSM.dycomments.count != 0) {
        dataArray = [@[]mutableCopy];
        float pingLunHeight = 0.0;
        for (int i = 0; i < _model.dynamicSM.dycomments.count; i++) {
            
            DycommentsSM *SM = [_model.dynamicSM.dycomments objectAtIndex:i];
            DongtaiPinglunCellVM *pinglunCellVM = [[DongtaiPinglunCellVM alloc] init];
            
            if (i < 3) {
               
                pinglunCellVM.model = SM;
                
                if (i == 0) {
                    pinglunCellVM.isIcon = YES;
                }else{
                    pinglunCellVM.isIcon = NO;
                }
                NSString *content;
                if ([SM.isreply isEqualToString:@"0"]) {
                    content = [NSString stringWithFormat:@"%@: %@",SM.createname,SM.content];
                }else{
                    content = [NSString stringWithFormat:@"%@回复%@: %@",SM.createname,SM.relusername,SM.content];
                }
                
                CGSize pinglunsize = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(ScreenWidth-2*15-79, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                if(SM.content.length != 0)
                    pinglunCellVM.cellHeight = pinglunsize.height+10;
                
                [self viewHeight:pinglunsize.height+10];
                pinglunCellVM.content = content;
            }
            if (i == 3) {
                pinglunCellVM.last = YES;
                pinglunCellVM.cellHeight = 30;
                [self viewHeight:30];
                
                pinglunCellVM.content = [NSString stringWithFormat:@"查看全部%d条评论",_model.dynamicSM.commentscount];
            }
            [dataArray addObject:pinglunCellVM];
        }
        listBox.items = dataArray;
        pingLunHeight += 13;
        listBox.frame = CGRectMake(15, rect.origin.y+rect.size.height, ScreenWidth-2*15, viewHeight);

        listBox.hidden = NO;
        
        fengeXian.frame = CGRectMake(15, listBox.frame.origin.y+listBox.frame.size.height+13, ScreenWidth-15, 1);
        NSLog(@"gaodu%f",_model.height);
    }else{
        listBox.hidden = YES;
        fengeXian.frame = CGRectMake(15, rect.origin.y+rect.size.height+13, ScreenWidth-15, 1);
        
    }
    fengeXian.backgroundColor = Fenge_Color;
}

- (void)viewHeight:(float)size5{
    viewHeight += size5;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    xinxiView.frame = CGRectMake(0, 0, ScreenWidth, 52);
    guanzhuBtn.frame = CGRectMake(self.frame.size.width-15-guanzhuBtn.frame.size.width, guanzhuBtn.frame.origin.y, guanzhuBtn.frame.size.width, guanzhuBtn.frame.size.height);
    quxiaoGuanzhuBtn.frame = CGRectMake(self.frame.size.width-15-quxiaoGuanzhuBtn.frame.size.width, quxiaoGuanzhuBtn.frame.origin.y, quxiaoGuanzhuBtn.frame.size.width, quxiaoGuanzhuBtn.frame.size.height);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark 按钮
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender == guanzhuBtn) {
        guanzhuBtn.hidden = YES;
        quxiaoGuanzhuBtn.hidden = NO;
        [_model.delegate guanzhuFangfa:_model.dynamicSM.dynamic.createid];
    }else if (sender == quxiaoGuanzhuBtn){
        guanzhuBtn.hidden = NO;
        quxiaoGuanzhuBtn.hidden = YES;
        [_model.delegate quxiaoguanzhuFangfa:_model.dynamicSM.dynamic.createid];
    }
}

#pragma mark 代理
- (void)shanchuFangfa{
    [_model.delegate shanchuFangfa:_model.dynamicSM.dynamic._id DongtaiModel:_model];
}

- (void)dianzanFangfa{

    [_model.delegate zanFangfa:_model.dynamicSM.dynamic._id DongtaiModel:_model];
}

- (void)quxiaoDianzanFangfa{

    [_model.delegate quxiaoZanFangfa:_model.dynamicSM.dynamic._id DongtaiModel:_model];
}

- (void)pinglunFangfa{
    
    [_model.delegate pinglunFangfa:_model.dynamicSM.dynamic._id DongtaiModel:_model];
}

- (void)TupianViewDidTap:(TupianView *)tapView{
    
    for(int i = 0;i < [tupianArray count];i++)
    {
        TupianView *imageBox = [tupianArray objectAtIndex:i];
        if([imageBox isEqual:tapView])
        {
            [_model.delegate pengYouQuanCellView:tpArray DidSelectedWithIndex:i];
            break;
        }
    }
}

- (void)listBox:(ListBox *)listBox didSelectItem:(id)data{
    DongtaiPinglunCellVM *pinglunCellVM = (DongtaiPinglunCellVM *)data;
    if (!pinglunCellVM.last) {
        [_model.delegate huofuPinglun:pinglunCellVM DongtaiModel:_model];
    }else{
        [_model.delegate jinXiangqingWithAllDynamicSM:_model.dynamicSM DongtaiModel:_model];
    }
}

- (void)BofangYuyin:(YuyinView *)luyinView{
    /*
    if ([EMAudioPlayerUtil isPlaying]) {
        if (yuyinView.yinliangImageView.isAnimating == YES) {
            [EMAudioPlayerUtil stopCurrentPlaying];
            [yuyinView.yinliangImageView stopAnimating];
            if (yuyinView.soundurl != luyinView.soundurl) {
                [self BofangYuyin:luyinView];
            }
        }else{
            [EMAudioPlayerUtil stopCurrentPlaying];
            [yuyinView.yinliangImageView stopAnimating];
            [self BofangYuyin:luyinView];
        }
    }else{
        [luyinView.yinliangImageView startAnimating];
        [_model.delegate bofangYuyin:luyinView];
    }
     */
    [_model.delegate bofangYuyin:luyinView];
    
}

- (void)bofangFangfa:(NSInteger)TAG Yuyin:(YuyinView *)luyinView{
    YuyinView *yuyin = [yuyinViewArray objectAtIndex:TAG];
    if ([EMAudioPlayerUtil isPlaying]) {
        [EMAudioPlayerUtil stopCurrentPlaying];
        [yuyinView.yinliangImageView stopAnimating];
        if (yuyinView.yinliangImageView.isAnimating == YES) {
            
            if (TAG != yuyinView.tag) {
                [self bofangFangfa:TAG Yuyin:luyinView];
            }
        }else{
            [self bofangFangfa:TAG Yuyin:luyinView];
        }

    }else{
        yuyinView = yuyin;
        yuyinView.tag = TAG;
        [luyinView.yinliangImageView startAnimating];
        [_model.delegate bofangYuyin:luyinView];
    }
}

//单手势
-(void)handleSingleTap:(UIGestureRecognizer *)ges
{
    [_model.delegate tiaozhuanGerenxinxi:_model.dynamicSM.dynamic.createid];
    
    
}


@end
