//
//  ZuDetailViewController.h
//  Zipingguo
//
//  Created by jiangshilin on 15/11/6.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "ParentsViewController.h"
#import <UIKit/UIKit.h>
#import "DCItemsBox.h"
#import "DCItemsBoxGridLayout.h"
//#import "LiaotianJiarenViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "XiugaiXinxiViewController.h"
#import "EMGroup.h"
#import "EaseMob.h"
#import "EMRemarkImageView.h"
#import "ZuyuanXinxiCellVM.h"
#import <BaiduMapAPI/BMKLocationService.h>
#import "ChatViewController.h"
#import "CustomActionSheet.h"
typedef enum : NSUInteger {
    kDelete=0,  //加人
    kAdd,       //减人
    kExit,      //主动退出
    kExtion,    //主动解散
} CertificationType;
@protocol ZuDetailControllerBackRefresh <NSObject>
@optional
-(void)changeGroupSubject:(NSString *)subject withFlag:(NSString *)flagStr;
-(void)BackRefresh;
@end

@interface ZuDetailViewController : ParentsViewController<EMChatManagerDelegate,UIAlertViewDelegate,ZuyuanXinxiCellVMDelegate,CustomActionSheetDelegate>
{
    NSMutableArray *dataArray;
    NSMutableArray *AllMembersID; //维护当前页面的所有成员的id号码
    
    NSMutableArray *TouxiangArray;
    NSMutableArray *idArray;
    
    NSString *ower;
    EMGroupStyle groupStyle;
    
    CustomActionSheet *actionSheet;
    NSArray *membersArray;
    NSMutableArray *xuanrenArray;
    DCItemsBox *itemsBox;
    NSMutableArray *nameArray;
    NSMutableArray *_xuanzhongArray;
    EMGroup *gr;
    
    NSString *groupid;
    CertificationType certication;
    NSMutableArray *yonghuArr;
}
- (instancetype)initWithGroupId:(NSString *)chatGroupId;
@property (nonatomic, assign) EMConversationType ConversationType;
@property (nonatomic,assign) id<ZuDetailControllerBackRefresh>delegate;
@property (nonatomic, strong) NSString *touxiang;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSArray *huanxinArr;
@property (nonatomic, strong) NSString *groupID;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSString *titelText;
@property (nonatomic, strong) NSString *chatter;
@property (nonatomic, strong) EMConversation *converSation;

@property (weak, nonatomic) IBOutlet UIView *itemsView;
@property (weak, nonatomic) IBOutlet UIView *zuyuanXinxiView;
@property (strong, nonatomic) IBOutlet UIView *qingKongView;
@property (strong, nonatomic) IBOutlet UIButton *ClearAction;
@property (strong, nonatomic) IBOutlet UIButton *exitionAction;
@property (strong, nonatomic) IBOutlet UILabel *zuMingChengLabel;
@property (strong, nonatomic) IBOutlet UIButton *XiugaiMingchengBtn;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (nonatomic ,strong) void (^removeAllConverstionMessage)(void);
- (IBAction)buttonClick:(UIButton *)sender;
@end
