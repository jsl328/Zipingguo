//
//  DB.m
//  Cicada
//
//  Created by sss on 12-11-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DB.h"
#import "EntityMetadata.h"
#import "EntityLibrary.h"
#import "ClassInfo.h"
#import "NSArray+Extensions.h"

#define NOWVERSION @"now_app_version"

static NSString* _fileName;
static sqlite3* _database;
static BOOL _opened;

@implementation DB


+(void)throwException:(NSString*)message {
    
    NSException* ex = [NSException
                       exceptionWithName:@"DataAccessException"
                       reason:message
                       userInfo:nil];
    
    @throw ex;
}

+(void) openConnection {
    _database = [DB openDatabase];
    _opened = YES;
    NSLog(@"BEGIN TRANSACTION");
    [DB executeSql:@"BEGIN TRANSACTION"];
}

+(void) closeConnection {
    [DB executeSql:@"COMMIT TRANSACTION"];
    NSLog(@"COMMIT TRANSACTION");
    [DB closeDatabase:_database];
    _opened = NO;
    _database=nil;
}

+(void) setFileName: (NSString*) fileName {
    _fileName = fileName;
}

+(void) createDatabase
{
    sqlite3* databaseHandle = _opened ? _database : [DB openDatabase];
    
    BOOL succeeded = YES;
    
    
    
    char *error;
    
    for (EntityMetadata* entity in [EntityLibrary entities]) {
        
        NSString* sql = [entity createTableStatement];
        
        succeeded = sqlite3_exec(databaseHandle, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK;
        
        if (!succeeded) {
            [DB throwException:[NSString stringWithUTF8String:error]];
        }
    }
    
    
    if (!succeeded) {
        [DB throwException:[NSString stringWithUTF8String:error]];
    }
    
    
    if (!_opened) {
        sqlite3_close(databaseHandle);
    }
    
    
}

+(void) clearEntityTables
{
    sqlite3* databaseHandle = _opened ? _database : [DB openDatabase];
    
    
    BOOL succeeded = YES;
    
    char *error;
    
    for (EntityMetadata* entity in [EntityLibrary entities]) {
        
        NSString* sql = [entity clearTableStatement];
        
        succeeded = sqlite3_exec(databaseHandle, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK;
        
        if (!succeeded) {
            [DB throwException:[NSString stringWithUTF8String:error]];
        }
    }
    
    
    if (!_opened) {
        sqlite3_close(databaseHandle);
    }
}

+(sqlite3*) openDatabase {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:_fileName];
    NSString *nowVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:NOWVERSION] isEqualToString:nowVersion]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath isDirectory:NO]) {
            [[NSFileManager defaultManager] removeItemAtPath:databasePath error:nil];
        }
        [[NSUserDefaults standardUserDefaults] setObject:nowVersion forKey:NOWVERSION];
    }
    
    sqlite3* databaseHandle;
    
    
    if (sqlite3_open([databasePath UTF8String], &databaseHandle) != SQLITE_OK) {
        [DB throwException:@"Failed to open database."];
    }
    
    return databaseHandle;
}

+(void) closeDatabase:(sqlite3*)databaseHandle {
    sqlite3_close(databaseHandle);
}

+(void) executeSql:(NSString*) sql withDatabase:(sqlite3*) databaseHandle {
    
    char *error;
    
    BOOL succeeded = sqlite3_exec(databaseHandle, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK;
    
    if (!succeeded) {
        [DB throwException:[NSString stringWithUTF8String:error]];
    }
}

+(int) selectCountWithSql:(NSString*) sql {
    
    sqlite3* databaseHandle = _opened ? _database : [DB openDatabase];
    
    
    int count = 0;
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(databaseHandle, [sql UTF8String], -1, &statement, NULL) !=
        SQLITE_OK){
        NSLog(@"Error, failed to prepare statement, handle error here.");
    }
    
    if (sqlite3_step(statement) == SQLITE_ROW) {
        count = sqlite3_column_int(statement, 0);
    }
    
    if(sqlite3_finalize(statement) != SQLITE_OK){
        NSLog(@"Failed to finalize data statement, error handling here.");
    }
    if (!_opened) {
        sqlite3_close(databaseHandle);
    }
    return count;
}

+(int) executeInsertSql:(NSString*) sql {
    
    NSLock* syncronizeLock = [[NSLock alloc] init];
    BOOL isLocked = [syncronizeLock tryLock];
    
    sqlite3* databaseHandle = _opened ? _database : [DB openDatabase];
    BOOL succeeded = YES;
    
    char *error;
    succeeded = sqlite3_exec(databaseHandle, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK;
    int autoID = sqlite3_last_insert_rowid(databaseHandle);
    
    if (!succeeded) {
        NSString * str=[NSString stringWithFormat:@"数据库执行失败  error %@",[NSString stringWithUTF8String:error]];
        NSLog(@"%@",str);
    }
    
    if (!_opened) {
        sqlite3_close(databaseHandle);
    }
    
    if (isLocked) {
        [syncronizeLock unlock];
    }
    
    return autoID;
}

+(void) executeSql:(NSString*) sql {
    
    sqlite3* databaseHandle = _opened ? _database : [DB openDatabase];
    BOOL succeeded = YES;
    
    
    NSLog(@"%@", sql);
    
    char *error;
    succeeded = sqlite3_exec(databaseHandle, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK;
    
    if (!succeeded) {
        NSString * str=[NSString stringWithFormat:@"数据库执行失败  error %@",[NSString stringWithUTF8String:error]];
        //        NSAssert(succeeded==YES,str);
        NSLog(@"%@",str);
    }
    
    if (!_opened) {
        sqlite3_close(databaseHandle);
    }
}

+(NSArray*) select:(Class) class withSql:(NSString*) sql {
    
    sqlite3* databaseHandle = _opened ? _database : [DB openDatabase];
    
    EntityMetadata* m = [EntityLibrary entityforType:[class description]];
    
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(databaseHandle, [sql UTF8String], -1, &statement, NULL) !=
        SQLITE_OK){
        NSLog(@"Error, failed to prepare statement, handle error here. %@", sql);
    }
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        EntityBase* item = [class new];
        [m populateEntity:item withStatement:statement];
        
        [items addObject:item];
    }
    if(sqlite3_finalize(statement) != SQLITE_OK){
        NSLog(@"Failed to finalize data statement, error handling here.");
    }
    if (!_opened) {
        sqlite3_close(databaseHandle);
    }
    
    return items;
}

+(EntityBase*) selectOne:(Class) class withSql:(NSString*) sql {
    NSArray* items = [DB select:class withSql:sql];
    return items.count == 0 ? nil : [items objectAtIndex:0];
}

+(EntityBase*) get:(Class) class withAutoID:(int) autoID {
    EntityMetadata* m = [EntityLibrary entityforType:[class description]];
    return [self selectOne:class withSql:[m getWithAutoIDStatementForAutoID:autoID]];
}


+(NSMutableArray*) selectTable:(NSString*) sql withColumnCount:(int) count {
    
    sqlite3* databaseHandle = _opened ? _database : [DB openDatabase];
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(databaseHandle, [sql UTF8String], -1, &statement, NULL) !=
        SQLITE_OK){
        NSLog(@"Error, failed to prepare statement, handle error here.");
    }
    
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        NSMutableArray* row = [[NSMutableArray alloc] init];
        
        for (int i = 0; i <= count - 1; i++) {
            [row addObject:[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)]];
        }
        
        [items addObject:row];
    }
    if(sqlite3_finalize(statement) != SQLITE_OK){
        NSLog(@"Failed to finalize data statement, error handling here.");
    }
    
    if (!_opened) {
        sqlite3_close(databaseHandle);
    }
    
    return items;
}

@end
