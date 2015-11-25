//
//  WorkpaperAnnexsSM.h
//  Lvpingguo
//
//  Created by linku on 15-1-23.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAnnotatable.h"
@interface WorkpaperAnnexsSM : NSObject <IAnnotatable>
@property(nonatomic,retain)NSString*ID;
@property(nonatomic,retain)NSString*workpaperid;
@property(nonatomic,retain)NSString*filename;
@property(nonatomic,retain)NSString*fileurl;
@property(nonatomic,retain)NSString*filesize;
@property(nonatomic,retain)NSString*imgurl;
@property(nonatomic,retain)NSString*createtime;
@property(nonatomic,retain)NSString*IDdeleteflag;

@end
