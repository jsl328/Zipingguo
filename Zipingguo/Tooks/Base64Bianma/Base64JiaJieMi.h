//
//  Base64JiaJieMi.h
//  FengHuang
//
//  Created by fei on 14-3-5.
//  Copyright (c) 2014年 Crow. All rights reserved.
//


#define BASE64_BianMa_String(ziFuChuan)  [Base64JiaJieMi base64_BianMaZiFuChuan:ziFuChuan]
#define BASE64_JieMa_String(ziFuChuan)  [Base64JiaJieMi base64_JieMaZiFuChuan:ziFuChuan]

#define Base64_bianMa_DataToString(data)  [Base64JiaJieMi base64_bianMa_DataToStringS:data]
#define Base64_bianMa_StringToDatas(string)  [Base64JiaJieMi base64_bianMa_StringToDatas:string]


#import <Foundation/Foundation.h>

@interface Base64JiaJieMi : NSObject

+ (NSString *)base64_BianMaZiFuChuan:(NSString *)ziFuChuan;
+ (NSString *)base64_JieMaZiFuChuan:(NSString *)ziFuChuan;

+ (NSString *)base64_bianMa_DataToStringS:(NSData *)data;
+ (NSData *)base64_bianMa_StringToDatas:(NSString *)string;


@end
