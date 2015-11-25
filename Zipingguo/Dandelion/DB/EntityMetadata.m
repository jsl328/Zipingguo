//
//  EntityMetadata.m
//  Cicada
//
//  Created by sss on 12-11-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EntityMetadata.h"
#import "sqlite3.h"
#import "Reflection.h"
#import "PropertyInfo.h"
#import "ClassInfo.h"

@implementation EntityMetadata
@synthesize entityType;

static NSString *const STRING_INSERT_INTO = @"INSERT INTO %@(";
static NSString *const STRING_TWO_PLACEHOLDERS = @"%@%@";
static NSString *const STRING_COMMA = @", ";
static NSString *const STRING_RIGHT_PARENTHESE = @")";
static NSString *const STRING_RIGHT_VALUES = @" VALUES(";
static NSString *const STRING_EMPTY = @"";
static NSString *const STRING_STRING_WITH_PLACEHOLDER = @"'%@'%@";


-(EntityMetadata*) init {
    
    self = [super init];
    
    properties = [[NSMutableArray alloc] init];
    types = [[NSMutableArray alloc] init];
    
    insertStatement = [[NSMutableString alloc] init];
    
    return self;
}


-(void) populateFields {
    [self populateFieldsOfType:[EntityBase class]];
    [self populateFieldsOfType:entityType];
}

-(void) populateFieldsOfType: (Class) type {
    
    for (PropertyInfo* property in [ClassInfo infoForType:type].properties) {
        [self addProperty:property.name withType:[EntityMetadata propertyTypeFromEntityPropertyInfo:property]];
    }
}

+(int) propertyTypeFromEntityPropertyInfo: (PropertyInfo*) propertyInfo {
    
    if ([propertyInfo.name isEqualToString:@"autoID"]) {
        return EntityPropertyTypePrimaryKey;
    }
    else if (!propertyInfo.type.isPrimitiveType && [propertyInfo.type.type isSubclassOfClass:[NSString class]]) {
        return EntityPropertyTypeString;
    }
    else if (propertyInfo.type.isPrimitiveType && propertyInfo.type.primitiveType == PrimitiveTypeInteger) {
        return EntityPropertyTypeInteger;
    }
    else if (propertyInfo.type.isPrimitiveType && propertyInfo.type.primitiveType == PrimitiveTypeDouble) {
        return EntityPropertyTypeReal;
    }
    
    return EntityPropertyTypeString;
}


-(void) addProperty:(NSString*) propertyName withType:(int)type {
    [properties addObject:propertyName];
    [types addObject:[NSNumber numberWithInt:type]];
}


+(NSString*) getSqlType:(int) type {
    
    if (type == EntityPropertyTypeString) {
        return @"TEXT";
    }
    else if (type == EntityPropertyTypeInteger) {
        return @"INTEGER";
    }
    else if (type == EntityPropertyTypeReal) {
        return @"REAL";
    }
    else {
        return @"INTEGER PRIMARY KEY AUTOINCREMENT";
    }
}

-(NSString*) createTableStatement {
    
    NSString* tableName = [entityType description];
    NSString* sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (", tableName];
    
    for (int i = 0; i <= properties.count - 1; i++) {
        
        sql = [sql stringByAppendingFormat:@"%@ %@%@", [properties objectAtIndex:i], [EntityMetadata getSqlType:[[types objectAtIndex:i] intValue]], (i < properties.count - 1) ? @", " : @")"];
    }
    
    //    printf("%s", [sql UTF8String]);
    return sql;
}

-(NSString*) clearTableStatement {
    
    return [NSString stringWithFormat:@"DROP TABLE %@", [entityType description]];
}


-(NSMutableString*) insertStatementForEntity:(EntityBase*) entity {
    
    
    NSRange range;
    range.location = 0;
    range.length = insertStatement.length;
    
    [insertStatement deleteCharactersInRange:range];
    
    [insertStatement appendFormat:STRING_INSERT_INTO, [[self entityType] description]];
    
    
    int count = 0;
    
    for (NSString* property in properties) {
        
        count++;
        
        if ([[types objectAtIndex:count - 1] intValue] == EntityPropertyTypePrimaryKey) {
            continue;
        }
        
        [insertStatement appendFormat:STRING_TWO_PLACEHOLDERS, property, (count < [properties count]) ? STRING_COMMA : STRING_RIGHT_PARENTHESE];
    }
    
    
    [insertStatement appendString:STRING_RIGHT_VALUES];
    
    count = 0;
    
    for (NSString* property in properties) {
        
        count++;
        
        int propertyType = [[types objectAtIndex:count - 1] intValue];
        
        if (propertyType == EntityPropertyTypePrimaryKey) {
            continue;
        }
        else if (propertyType == EntityPropertyTypeString) {
            NSString* value = [[entity valueForKey:property] stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            if ([value length] == 0) {
                value = STRING_EMPTY;
            }
            [insertStatement appendFormat:STRING_STRING_WITH_PLACEHOLDER, value, (count < [properties count]) ? STRING_COMMA : STRING_RIGHT_PARENTHESE];
        }
        else if (propertyType == EntityPropertyTypeInteger) {
            int value = [[entity valueForKey:property] intValue];
            [insertStatement appendFormat:@"%d%@", value, (count < [properties count]) ? STRING_COMMA : STRING_RIGHT_PARENTHESE];
        }
        else {
            double value = [[entity valueForKey:property] doubleValue];
            [insertStatement appendFormat:@"%f%@", value, (count < [properties count]) ? STRING_COMMA : STRING_RIGHT_PARENTHESE];
        }
    }
    
    return insertStatement;
}

-(NSMutableString*) updateStatementForEntity:(EntityBase*) entity withFields:(NSArray*) fields {
    
    NSMutableString* statement = [[NSMutableString alloc] init];
    
    [statement appendFormat:@"UPDATE %@ SET ", [[self entityType] description]];
    
    
    int updateFieldCount = fields ? fields.count : properties.count - 1;
    int fieldIndex = 0;
    
    for (int i = 0; i <= properties.count - 1; i++) {
        
        NSString* property = [properties objectAtIndex:i];
        int propertyType = [[types objectAtIndex:i] intValue];
        
        if ((!fields || [fields containsObject:property]) && propertyType != EntityPropertyTypePrimaryKey) {
            if (propertyType == EntityPropertyTypeString) {
                NSString* value = [entity valueForKey:property];
                if ([value length] == 0) {
                    value = STRING_EMPTY;
                }
                [statement appendFormat:@"%@='%@'%@", property, value, (fieldIndex < updateFieldCount - 1) ? @"," : @""];
            }
            else if (propertyType == EntityPropertyTypeInteger) {
                int value = [[entity valueForKey:property] intValue];
                [statement appendFormat:@"%@=%d%@", property, value, (fieldIndex < updateFieldCount - 1) ? @"," : @""];
            }
            else {
                double value = [[entity valueForKey:property] doubleValue];
                [statement appendFormat:@"%@=%f%@", property, value, (fieldIndex < updateFieldCount - 1) ? @"," : @""];
            }
            
            fieldIndex++;
        }
    }
    
    [statement appendFormat:@" WHERE autoID=%d", entity.autoID];
    
    return statement;
}

-(NSString*) getWithAutoIDStatementForAutoID:(int) autoID {
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE autoID=%d LIMIT 1", [entityType description], autoID];
}

-(void) populateEntity:(EntityBase*) entity withStatement:(sqlite3_stmt*) statement {
    
    int columnCount = sqlite3_column_count(statement);
    
    for (int i = 0; i <= columnCount - 1; i++) {
        
        id value;
        int propertyType = [[types objectAtIndex:i] intValue];
        
        if (propertyType == EntityPropertyTypeString) {
            value = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, i)];
        }
        else if (propertyType == EntityPropertyTypeInteger) {
            value = [NSNumber numberWithInt:sqlite3_column_int(statement, i)];
        }
        else {
            value = [NSNumber numberWithDouble:sqlite3_column_double(statement, i)];
        }
        
        [entity setValue:value forKey: [properties objectAtIndex:i]];
    }
}

@end
