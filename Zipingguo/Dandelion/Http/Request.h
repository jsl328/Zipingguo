//
//  Request.h
//  Nanumanga
//
//  Created by Bob Li on 13-3-19.
//
//

#import <Foundation/Foundation.h>
#import "ServiceMethod.h"
#import "DCServiceContext.h"
#import "DCUploadTask.h"
#import "DCHttpHeader.h"
#import "DCDataRequestTask.h"

@interface Request : NSObject {
    
    ServiceMethod* _serviceMethod;
    
    Class _returnType;
    
    NSArray* _parameterValues;
    
    DCUploadTask* _uploadTask;
    
    DCDataRequestTask* _downloadTask;
    
    id _callback;
    
    BOOL _isAborted;
    
    
    DCHttpHeader* _header;
}

-(ServiceMethod*) serviceMethod;

-(void) sendWithDataCallback:(void (^)(DCServiceContext*, id)) callback;

-(void) sendWithVoidCallback:(void (^)(DCServiceContext*)) callback;

-(void) setHeaderValue:(NSString*) value forName:(NSString*) name;

-(void) abort;

+(Request*) create:(NSString*) serviceMethodName parameterValues:(NSArray*) parameterValues returnType:(Class) returnType;

@end
