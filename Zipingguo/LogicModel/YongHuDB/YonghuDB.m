//
//  YonghuDB.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-30.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "YonghuDB.h"

@implementation YonghuDB

+ (void)saveToDB:(DeptPersonsSM *)sm{
    YonghuInfoDB *infoDB = [[YonghuInfoDB alloc] init];
    [infoDB saveToYonghuDB:sm];
}

@end

@implementation YonghuInfoDB

- (void)saveToYonghuDB:(DeptPersonsSM *)sm{
    self.userid = sm.userid;
    self.name = sm.name;
    self.letter = sm.letter;
    self.email = sm.email;
    self.phone = sm.phone;
    self.wechat = sm.wechat;
    self.qq = sm.qq;
    self.birthday = sm.birthday;
    self.hobby = sm.hobby;
    self.imgurl = sm.imgurl;
    self.companyid = [AppStore getGongsiID];
    self.position = sm.position;
    self.jobnumber = sm.jobnumber;
    self.deptid = sm.deptid;
    self.deptname = sm.deptname;
    
    [self save];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self.userid = [aDecoder decodeObjectForKey:@"userid"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.letter = [aDecoder decodeObjectForKey:@"letter"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.phone = [aDecoder decodeObjectForKey:@"phone"];
    self.wechat = [aDecoder decodeObjectForKey:@"wechat"];
    self.qq = [aDecoder decodeObjectForKey:@"qq"];
    self.birthday = [aDecoder decodeObjectForKey:@"birthday"];
    self.hobby = [aDecoder decodeObjectForKey:@"hobby"];
    self.imgurl = [aDecoder decodeObjectForKey:@"imgurl"];
    self.companyid = [aDecoder decodeObjectForKey:@"companyid"];
    self.position = [aDecoder decodeObjectForKey:@"position"];
    self.jobnumber = [aDecoder decodeObjectForKey:@"jobnumber"];
    self.deptid = [aDecoder decodeObjectForKey:@"deptid"];
    self.deptname = [aDecoder decodeObjectForKey:@"deptname"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{

    [aCoder encodeObject:self.userid forKey:@"userid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.letter forKey:@"letter"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.wechat forKey:@"wechat"];
    [aCoder encodeObject:self.qq forKey:@"qq"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.hobby forKey:@"hobby"];
    [aCoder encodeObject:self.imgurl forKey:@"imgurl"];
    [aCoder encodeObject:self.companyid forKey:@"companyid"];
    [aCoder encodeObject:self.position forKey:@"position"];
    [aCoder encodeObject:self.jobnumber forKey:@"jobnumber"];
    [aCoder encodeObject:self.deptid forKey:@"deptid"];
    [aCoder encodeObject:self.deptname forKey:@"deptname"];
   

}

@end

