//
//  ZiXunCellModel.h
//  Zipingguo
//
//  Created by sunny on 15/10/12.
//  Copyright © 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZiXunListSM.h"

@interface ZiXunCellModel : NSObject

//@property (nonatomic,retain) NSString * title;
//@property (nonatomic,retain) NSString * content;
//@property (nonatomic,retain) NSString * createid;
//@property (nonatomic,retain) NSString * createtime;
//@property (nonatomic,assign) int status;
//@property (nonatomic,retain) NSString * imgurl;
//@property (nonatomic,retain) NSString * infotypeid;
//@property (nonatomic,retain) NSString * companyid;
//@property (nonatomic,assign) int ishomepage;
//@property(nonatomic,assign)int readamount;
//@property (nonatomic,retain) NSString * time;

@property (nonatomic,retain) NSString * createid;
@property (nonatomic,retain) NSString * ziXunID;
@property (nonatomic,copy) NSString *iconImage;
@property (nonatomic,copy) NSString *titleName;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,assign) int commentCount;
- (void)setModelWithSM:(ZiXunListSubSM *)sm;
@end
