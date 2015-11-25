//
//  EntityLibrary.m
//  Cicada
//
//  Created by sss on 12-11-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



#import "EntityLibrary.h"
#import "EntityBase.h"
#import "Reflection.h"
#import "PropertyInfo.h"
#import "DB.h"


static NSMutableDictionary* _entityDictionary;
static NSMutableArray* _entityList;

@implementation EntityLibrary

+(NSMutableArray*) entities {
    return _entityList;
}


+(EntityMetadata*) entityforType:(NSString*) type {
    return (EntityMetadata*)[_entityDictionary objectForKey:type];
}

+(void) load {
    
    _entityDictionary = [[NSMutableDictionary alloc] init];
    _entityList = [[NSMutableArray alloc] init];
    
    
    for (Class entityType in [Reflection loadTypesThatDeriveFromClass:[EntityBase class]]) {
        
        EntityMetadata* m = [[EntityMetadata alloc] init];
        
        [m setEntityType:entityType];
        [m populateFields];
        
        [_entityDictionary setObject:m forKey:[entityType description]];
        [_entityList addObject:m];
    }
    
    
    [DB setFileName:@"Database.db"];
    [DB createDatabase];
}

@end