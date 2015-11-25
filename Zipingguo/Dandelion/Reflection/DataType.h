//
//  DataType.h
//  Nanumanga
//
//  Created by Bob Li on 13-3-27.
//
//

#import <Foundation/Foundation.h>

#define PrimitiveTypeNone 0
#define PrimitiveTypeInteger 1
#define PrimitiveTypeDouble 2
#define PrimitiveTypeString 3
#define PrimitiveTypeDate 4

@interface DataType : NSObject {
    
    BOOL _isPrimitiveType;
    
    int _primitiveType;
    
    Class _type;
}

-(BOOL) isPrimitiveType;

-(int) primitiveType;

-(Class) type;

//-(id) parse:(id) obj;

-(BOOL) isEqualToDataType: (DataType*) dataType;


+(DataType*) createPrimitiveDataType:(int) type;

+(DataType*) createReferenceDataType:(Class) type;

@end
