//
//  YonghuStores.m
//  Lvpingguo
//
//  Created by fuyonghua on 14-10-30.
//  Copyright (c) 2014年 fuyonghua. All rights reserved.
//

#import "YonghuStores.h"
#import "DB.h"
#import "YonghuDB.h"
@implementation YonghuStores

+ (YonghuInfoDB *)getWithAutoID:(int)autoID{
    return (YonghuInfoDB *)[DB get:[YonghuInfoDB class] withAutoID:autoID];
}

+ (NSMutableArray *)getAll{
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:[DB select:[YonghuInfoDB class] withSql:@"select * from YonghuInfoDB"]];
    return array;
}
+ (NSMutableArray *)getAllWithGongsiID:(NSString *)gongsi{
    
    NSString *sql = [NSString stringWithFormat:@"select * from YonghuInfoDB Where companyid = '%@'",gongsi];
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:[DB select:[YonghuInfoDB class] withSql:sql]];
    return array;
}

+ (NSMutableArray *)getAllWithGongsiID:(NSString *)gongsi Deptid:(NSString *)deptid{
    NSString *sql = [NSString stringWithFormat:@"select * from YonghuInfoDB Where companyid = '%@' and deptid = '%@'",gongsi,deptid];
    
    NSMutableArray * array = [[NSMutableArray alloc]initWithArray:[DB select:[YonghuInfoDB class] withSql:sql]];
    return array;
}

+ (YonghuInfoDB *)getDanLiaoTouXiangWithChatter:(NSString *)chatter{
    if (chatter.length == 0) {
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"select *from YonghuInfoDB Where substr(upper(userid),1,%lu)='%@'",(unsigned long)chatter.length,chatter.uppercaseString];
    NSArray *yonghus = [DB select:[YonghuInfoDB class] withSql:sql];
    if (yonghus.count) {
        return yonghus.firstObject;
    }
    return nil;
}
+ (NSArray *)searchWithString:(NSString *)string{
    return [DB select:[YonghuInfoDB class] withSql:[NSString stringWithFormat:@"SELECT * FROM YonghuInfoDB WHERE name like '%%%@%%'", string]];
}

+ (void)InsertWithUserid:(NSString *)userid Name:(NSString *)name Letter:(NSString *)letter Email:(NSString *)email Phone:(NSString *)phone Wechat:(NSString *)wechat QQ:(NSString *)qq Birthday:(NSString *)birthday Hobby:(NSString *)hobby Imgurl:(NSString *)imgurl Companyid:(NSString *)companyid Position:(NSString *)position Jobnumber:(NSString *)jobnumber  Deptid:(NSString *)deptid Deptname:(NSString *)deptname{
    [DB executeSql:[NSString stringWithFormat:@"insert into YonghuInfoDB('userid','name','letter','email','phone','wechat','qq','birthday','hobby','imgurl','companyid','position','jobnumber','deptid','deptname') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",userid,name,letter,email,phone,wechat,qq,birthday,hobby,imgurl,companyid,position,jobnumber,deptid,deptname]];
}

+ (void)updataWithName:(NSString *)name Letter:(NSString *)letter Deptid:(NSString *)deptid Phone:(NSString *)phone Imgurl:(NSString *)imgurl Deptname:(NSString *)deptname zhiwei:(NSString *)zhiwei ID:(NSString *)ID{
    [DB executeSql:[NSString stringWithFormat:@"update YonghuInfoDB set name = '%@',letter = '%@',deptid = '%@',phone = '%@',imgurl = '%@',deptname = '%@',position = '%@' where userid = '%@'",name,letter,deptid,phone,imgurl,deptname,zhiwei,ID]];
}

+ (void)DeleteWithID:(NSString *)ID{
    [DB executeSql:[NSString stringWithFormat:@"delete from YonghuInfoDB where userid = '%@'",ID]];
}

+ (void)deleteDataInGongSiTongXunLuDataBase;
{
    [DB executeSql:[NSString stringWithFormat:@"delete from YonghuInfoDB where companyid = '%@'",[AppStore getGongsiID]]];
}

+ (void)gengXintouxiang:(NSString *)ID imageURL:(NSString*)imageURL
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE YonghuInfoDB SET imgurl = '%@' WHERE userid='%@'",imageURL,ID];
    [DB executeSql:sql];

}

@end
