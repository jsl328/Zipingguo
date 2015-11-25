//
//  CustomActionSheet.m
//  ZYActionSheet
//
//  Created by sunny on 15/9/30.
//  Copyright © 2015年 sunny. All rights reserved.
//

#import "CustomActionSheet.h"
#import "FXBlurView.h"

static float cellHeight = 50.0f;
static float margin = 5.0f;
static float myAlpha = 0.1f;

@interface CustomActionSheet ()<UITableViewDataSource,UITableViewDelegate>{
    UIImageView *bgView;
    UITableView *actionSheetTableView;
    NSMutableArray *dataArray;
    
    NSString *_cancelName;
    NSString *_titleName;
    
//    UIView *muHuClearView;
    FXBlurView *blurView;
}

@end

@implementation CustomActionSheet
- (instancetype)initWithTitle:(NSString *)titleName OtherButtons:(NSArray *)array CancleButton:(NSString *)cancleName Rect:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.frame = rect;
        self.hidden = YES;
        dataArray = [@[] mutableCopy];
        _cancelName = @"取消";
        if ([titleName length] > 0) {
            _titleName = titleName;
        }
        if (array != nil) {
            [dataArray addObjectsFromArray:array];
        }
        if (cancleName!= nil) {
            _cancelName = cancleName;
        }
        [self createUI];
       
    }
    return self;
}


- (void)createUI{    
    bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height )];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = RGBACOLOR(0, 0, 0, 1);
    bgView.alpha = 0;
    [self addSubview:bgView];
    bgView.tag = 1000;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [bgView addGestureRecognizer:tgr];
    int temp = [_titleName length] > 0 ?2:1;
    self.actionSheetHeight = (dataArray.count + temp)* cellHeight + margin;
    
    actionSheetTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.frame.size.height , self.frame.size.width, self.actionSheetHeight) style:UITableViewStyleGrouped];
    actionSheetTableView.scrollEnabled = NO;
    actionSheetTableView.delegate = self;
    actionSheetTableView.dataSource = self;
    actionSheetTableView.backgroundColor = [UIColor clearColor];
//    actionSheetTableView.alpha = 0.98;
    [self addSubview:actionSheetTableView];

    // 头
    UIImageView *hearderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, cellHeight)];
    hearderView.image = [UIImage imageNamed:@"弹出提示bg.png"];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, cellHeight)];
    label.textAlignment = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? UITextAlignmentCenter : NSTextAlignmentCenter;
    label.text = _titleName;
    label.backgroundColor= [UIColor clearColor];
    [hearderView addSubview:label];
    if ([label.text length] > 0) {
        actionSheetTableView.tableHeaderView = hearderView;
        actionSheetTableView.tableHeaderView.backgroundColor = [UIColor clearColor];
    }
    
    [actionSheetTableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [dataArray count];
    }else{
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }else{
        return margin;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIImageView *fenGeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, margin)];
//        fenGeImageView.backgroundColor = [UIColor clearColor];
//        fenGeImageView.alpha = 0.98;
        fenGeImageView.image = [UIImage imageNamed:@"取消上分隔.png"];
//        fenGeImageView.backgroundColor = [UIColor clearColor];
        fenGeImageView.backgroundColor = RGBACOLOR(255, 255, 255, 1);
        fenGeImageView.alpha = 0.1;
        return fenGeImageView;
    }
    return nil;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.frame.size.width, cellHeight);
    [button setBackgroundImage:[UIImage imageNamed:@"弹出提示bg.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"弹出提示bg点击.png"] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section == 1) {
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitle:_cancelName forState:UIControlStateNormal];
        button.tag = 1000;
    }else{
        [button setTitleColor:RGBACOLOR(53, 55, 68, 1) forState:UIControlStateNormal];
        [button setTitle:dataArray[indexPath.row] forState:UIControlStateNormal];
        button.tag = 1001+indexPath.row;
    }
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    

    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell addSubview:button];
    return cell;
}

- (void)tapClick:(UITapGestureRecognizer *)tgr{
    [self dismiss];
    if ([self.delegate respondsToSelector:@selector(CustomActionSheetDelegateDidClickCancelButton:)]) {
        [self.delegate CustomActionSheetDelegateDidClickCancelButton:self];
    }
    if (self.actionClick) {
        self.actionCancle();
    }
}
- (void)btnClick:(UIButton *)btn{
    [self dismiss];
    if (btn.tag == 1000) {
        if ([self.delegate respondsToSelector:@selector(CustomActionSheetDelegateDidClickCancelButton:)]) {
            [self.delegate CustomActionSheetDelegateDidClickCancelButton:self];
        }
        if (self.actionClick) {
            self.actionCancle();
        }

    }else{
        if ([self.delegate respondsToSelector:@selector(CustomActionSheetDelegateDidClickIndex:customActionView:)]) {
            
            [self.delegate CustomActionSheetDelegateDidClickIndex:btn.tag -1000 customActionView:self];
        }
        if (self.actionClick) {
            self.actionClick(btn.tag - 1000);
        }
    }

}
#pragma mark - cell边
- (void)layoutSubviews{
    [super layoutSubviews];
    if ([actionSheetTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [actionSheetTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([actionSheetTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [actionSheetTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)showButtons:(ActionSheetClickIndex)buttonIndex cancle:(ActionSheetCancle)cancle{
    [self show];
    self.actionClick = buttonIndex;
    self.actionCancle = cancle;
}
- (void)show{
    
    [UIView animateWithDuration:0.4 animations:^{
        self.hidden = NO;
        bgView.alpha = myAlpha;
        actionSheetTableView.frame = CGRectMake(0, self.frame.size.height - self.actionSheetHeight, self.frame.size.width, self.actionSheetHeight);
    }];

}
- (void)showWithAnimationDuration:(float)duration{
    [UIView animateWithDuration:duration animations:^{
        self.hidden = NO;
        bgView.alpha = myAlpha;
        actionSheetTableView.frame = CGRectMake(0, self.frame.size.height - self.actionSheetHeight, self.frame.size.width, self.actionSheetHeight);
    }];

}
- (void)dismiss{

    [UIView animateWithDuration:0.4 animations:^{
       actionSheetTableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetHeight);
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}
- (void)dismissWithAnimationDuration:(float)duration{
    [UIView animateWithDuration:duration animations:^{
        actionSheetTableView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheetHeight);
        bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}
@end
