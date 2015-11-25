//
//  EntityBase.m
//  Cicada
//
//  Created by sss on 12-11-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EntityBase.h"
#import "DB.h"
#import "EntityMetadata.h"
#import "EntityLibrary.h"
#import "PropertyInfo.h"
#import "ClassInfo.h"

@implementation EntityBase
@synthesize autoID;

-(void) save {
    [self save:nil];
}

-(void) save:(NSArray*) fields {
    
    EntityMetadata* m = [EntityLibrary entityforType:[[self class] description]];
    
    if (autoID == 0) {
        autoID = [DB executeInsertSql:[m insertStatementForEntity:self]];
    }
    else {
        [DB executeSql:[m updateStatementForEntity:self withFields:fields]];
    }
}


-(id) valueFromOriginalValue:(id) value originalProperty:(PropertyInfo*) originalPropety property:(PropertyInfo*) property {
    
    if ([property.type isEqualToDataType:originalPropety.type]) {
        return value;
    }
    
    if (originalPropety.type.primitiveType == PrimitiveTypeDate && property.type.primitiveType == PrimitiveTypeInteger) {
        return [NSNumber numberWithLong:((NSDate*)value).timeIntervalSince1970];
    }
    else if (property.type.primitiveType == PrimitiveTypeDate && originalPropety.type.primitiveType == PrimitiveTypeInteger) {
        return [[NSDate alloc] initWithTimeIntervalSince1970:[value longValue]];
    }
    else {
        return value;
    }
}

-(void) populate:(id) object1 with:(id) object2 {
    
    ClassInfo* classInfo1 = [ClassInfo infoForType:[object1 class]];
    ClassInfo* classInfo2 = [ClassInfo infoForType:[object2 class]];
    
    for (PropertyInfo* propertyOfObject2 in classInfo2.properties) {
        
        PropertyInfo* propertyOfObject1 = [classInfo1.properties findFirst:^BOOL(PropertyInfo* item) {
            return [item.name isEqualToString:propertyOfObject2.name];
        }];
        
        if (propertyOfObject1) {
            id valueOfPropertyOfObject2 = [object2 valueForKey:propertyOfObject2.name];
            [object1 setValue:[self valueFromOriginalValue:valueOfPropertyOfObject2 originalProperty:propertyOfObject2 property:propertyOfObject1] forKey:propertyOfObject1.name];
        }
    }
}

-(void) populateWith:(id) object {
    [self populate:self with:object];
}

-(void) populateTo:(id) object {
    [self populate:object with:self];
}

@end
