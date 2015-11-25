//
//  CurrentDevice.m
//  ZiRobot
//
//  Created by 阿布都沙拉木吾斯曼 on 15/4/29.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "CurrentDevice.h"
#include <sys/sysctl.h>
@implementation CurrentDevice

#pragma mark -获取设备型号

+ (NSString *)getCurrentDeviceType
{
    int mib[2];
    size_t len;
    char *machine;
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return  platform;
}

+ (BOOL)GetDeviceType
{
    BOOL isBigger = NO;
    NSString *str = [self getCurrentDeviceType];
    NSArray *arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"iPhone,"]];
    NSMutableArray *mArr = [[NSMutableArray alloc]initWithArray:arr];
    [mArr removeObject:@""];
    
    int index = (int)[mArr indexOfObject:@"7"];
    if(index<mArr.count)
        isBigger = YES;
    return isBigger;
}

+ (NSString *)GetDeviceName
{
    NSString *name=[self getCurrentDeviceType];
    name =[self platname:name];
    return name;
}

+ (NSString *)platname:(NSString *)platform
{
     if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
     if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
     if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
     if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
     if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
     if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
     if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
     if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
     if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
     if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5";
     if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5";
     if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5";
     if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5";
     if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
     if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
     else{
         return nil;
     }
}

 /*
  
  if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
  if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
  if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
  if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
  if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
  if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
  if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
  if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
  if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
  if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
  if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
  if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
  if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
  if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
  if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
  
  */

@end
