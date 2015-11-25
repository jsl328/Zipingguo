//
//  DaKaModel.h
//  Zipingguo
//
//  Created by sunny on 15/10/9.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DaKaModel : NSObject

/// 地址
//@property (nonatomic,strong) 
@property (nonatomic,copy) NSString *addressName;
@property (nonatomic,copy) NSString *detailAddress;
@property (nonatomic,assign) float positionx;
@property (nonatomic,assign) float positiony;
@property (nonatomic,assign) BOOL isSelect;
@property (nonatomic,assign) float cellHeight;

/**
 *  通过传入字符串获得label高度
 *
 *  @param text 传入字符串
 *
 *  @return 返回label高度
 */
//- (float)getLabelFrameWithText:(NSString *)text;
@end
