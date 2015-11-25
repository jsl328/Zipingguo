//
//  DataType.m
//  Nanumanga
//
//  Created by Bob Li on 13-3-27.
//
//

#import "DataType.h"


@implementation DataType

-(BOOL) isPrimitiveType {
    return _isPrimitiveType;
}

-(int) primitiveType {
    return _primitiveType;
}

-(Class) type {
    return _type;
}

/*
 -(id) parse:(id) obj {
 
 if (!_isPrimitiveType) {
 if ([_type isSubclassOfClass:[NSString class]]) {
 return [NSString stringWithString:obj];
 }
 else  {
 return obj;
 }
 }
 else {
 if (_primitiveType == PrimitiveTypeInteger) {
 return [NSNumber numberWithInt:[obj intValue]];
 }
 else if (_primitiveType == PrimitiveTypeDouble) {
 return [NSNumber numberWithInt:[obj doubleValue]];
 }
 }
 
 return nil;
 }*/

-(BOOL) isEqualToDataType: (DataType*) dataType {
    if (_isPrimitiveType != dataType->_isPrimitiveType) {
        return NO;
    }
    else if (_isPrimitiveType) {
        return _primitiveType == dataType->_primitiveType;
    }
    else {
        return [_type isSubclassOfClass:dataType->_type];
    }
}


+(DataType*) createPrimitiveDataType:(int) type {
    
    DataType* dataType = [[DataType alloc] init];
    
    dataType->_isPrimitiveType = YES;
    dataType->_primitiveType = type;
    
    return dataType;
}

+(DataType*) createReferenceDataType:(Class) type {
    
    DataType* dataType = [[DataType alloc] init];
    dataType->_type = type;
    dataType->_primitiveType = PrimitiveTypeNone;
    
    return dataType;
}


@end
