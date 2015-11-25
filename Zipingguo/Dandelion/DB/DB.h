//
//  DB.h
//  Cicada
//
//  Created by sss on 12-11-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "EntityBase.h"

NSMutableDictionary * loginMessage;

@interface DB : NSObject

+(void) setFileName: (NSString*) fileName;

+(void) openConnection;
+(void) closeConnection;

+(void) createDatabase;
+(void) clearEntityTables;

+(sqlite3*) openDatabase;
+(void) closeDatabase:(sqlite3*)databaseHandle;
+(void) executeSql:(NSString*) sql withDatabase:(sqlite3*) databaseHandle;

+(int)executeInsertSql:(NSString*) sql;
+(void)executeSql:(NSString*) sql;

+(int) selectCountWithSql:(NSString*) sql;
+(NSArray*) select:(Class) class withSql:(NSString*) sql;
+(EntityBase*) selectOne:(Class) class withSql:(NSString*) sql;
+(EntityBase*) get:(Class) class withAutoID:(int) autoID;
//+(NSMutableArray*) selectParsable:(Class) class withSql:(NSString*) sql;
+(NSMutableArray*) selectTable:(NSString*) sql withColumnCount:(int) count;

@end
