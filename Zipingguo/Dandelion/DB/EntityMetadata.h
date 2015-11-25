//
//  EntityMetadata.h
//  Cicada
//
//  Created by sss on 12-11-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "EntityBase.h"

#define EntityPropertyTypeString 0
#define EntityPropertyTypeInteger 1
#define EntityPropertyTypeReal 2
#define EntityPropertyTypePrimaryKey 3

@interface EntityMetadata : NSObject {
    
    NSMutableArray* properties;
    NSMutableArray* types;
    
    NSMutableString* insertStatement;
}

@property (nonatomic, retain) Class entityType;

-(void) populateFields;

-(NSString*) createTableStatement;
-(NSString*) clearTableStatement;
-(NSMutableString*) insertStatementForEntity:(EntityBase*) entity;
-(NSMutableString*) updateStatementForEntity:(EntityBase*) entity withFields:(NSArray*) fields;
-(NSString*) getWithAutoIDStatementForAutoID:(int) autoID;

-(void) populateEntity:(EntityBase*) entity withStatement:(sqlite3_stmt*) statement;

@end
