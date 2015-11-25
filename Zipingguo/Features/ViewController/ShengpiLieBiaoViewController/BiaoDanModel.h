//
//  BiaoDanModel.h
//  Lvpingguo
//
//  Created by jiangshilin on 15-2-12.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIPlaceHolderTextView.h"
typedef enum : NSUInteger {
    kshengPI=1,       //审批
    kchaoSong,      //抄送
    kDatePicker,    //时间选择器
    ksigleChoice,   //单选
    kdoubleChoice,  //多选
    ktextFiled=6,     //单行输入框
    ktextView,      //多行输入框
    kOther,         //其他
    
} timeType;
#define Origin 500 //
#define NowType 700

@class BiaoDanModel;
@protocol biaodanDelegate <NSObject>
@optional
-(void)textViewbiaodanWithModel:(BiaoDanModel *)model withIndex:(NSInteger)index withTextView:(UIPlaceHolderTextView *)textView;
-(void)biaodanWithModel:(BiaoDanModel *)model withIndex:(NSInteger)index;
@end

@interface BiaoDanModel : NSObject
@property (nonatomic,assign)id<biaodanDelegate> delegate;
@property (nonatomic)float inSuperViewYpoint;
@property (nonatomic)timeType type;
@property (nonatomic)int indexFlag;
@property (nonatomic,strong)NSString *flowid;
@property (nonatomic)float rowHeight;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *content;
@end
