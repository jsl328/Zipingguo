//
//  Request.m
//  Nanumanga
//
//  Created by Bob Li on 13-3-19.
//
//

#import "Request.h"
#import "ServiceMetadata.h"
#import "DataType.h"
#import "ClassInfo.h"
#import "NSArray+Extensions.h"
#import "RequestTracker.h"
#import "DCFile.h"
#import "DCTaskPool.h"
#import "DCUploadTask.h"
#import "DCDownloadTask.h"
#import "DCTaskPool.h"

@implementation Request

-(void) sendWithDataCallback:(void (^)(DCServiceContext *, id))callback {
    [self send:callback];
}

-(void) sendWithVoidCallback:(void (^)(DCServiceContext *))callback {
    [self send:callback];
}

-(void) send:(id) callback {
    
    if (_serviceMethod.isExclusive && [RequestTracker isWaitingOnRequest]) {
        return;
    }
    
    _callback = callback;
    
    
    if (!_serviceMethod.checkNetwork) {
        [self send];
    }
    else {
        
        DCNetworkStatus networkStatus = [ServiceMetadata reachability].currentReachabilityStatus;
        
        if (networkStatus == DCNetworkStatusNoInformation) {
            [self send];
        }
        else if (networkStatus == DCNetworkStatusNotReachable) {
            [self requestFailedWithException:_serviceMethod.noNetworkMessage reason:DCServiceErrorReasonNetwork];
        }
        else if (![_serviceMethod.networkChecker networkTypeMatches:networkStatus]) {
            [self requestFailedWithException:_serviceMethod.networkTypeMismatchMessage reason:DCServiceErrorReasonNetwork];
        }
        else if (_serviceMethod.checkPayedNetwork && networkStatus == DCNetworkStatusReachableViaWWAN) {
            [LDialog showMessageOKCancel:_serviceMethod.usePayedNetworkMessage ok:^{
                [self send];
            } cancel:^{
                [self requestFailedWithException:nil reason:DCServiceErrorReasonInquireDenied];
            }];
        }
        else {
            [self send];
        }
    }
}

-(void) requestFailedWithException:(NSString*) exception reason:(DCServiceErrorReason) errorReason {
    
    DCServiceContext* serviceContext = [[DCServiceContext alloc] init];
    serviceContext.message = exception;
    serviceContext.errorReason = errorReason;
    
    [self requestDidComplete:nil serviceContext:serviceContext];
}

-(ServiceMethod*) serviceMethod {
    return _serviceMethod;
}

-(void) send {
    
    if (_serviceMethod.isExclusive) {
        [RequestTracker track:self];
    }
    
    
    NSString* providedUrl = [ServiceMetadata providedUrlForUrlID:_serviceMethod.urlID];
    
    NSString* url = [_serviceMethod getUrlWithValues:_parameterValues providedUrl:providedUrl serializeEnumAsInteger:[ServiceMetadata urlSerializeEnumAsInteger] enumParser:[ServiceMetadata enumParser] dateParser:[ServiceMetadata createUrlDateParser]];
    
    if (_parameterValues.count > 0 && [[[_parameterValues lastObject] class] isSubclassOfClass:[DCFile class]]) {
        [self sendUploadFileRequest:url];
    }
    else {
        [self submitDownloadTask:url];
    }
}

-(void) abort {
    _isAborted = YES;
    [self requestFailedWithException:nil reason:DCServiceErrorReasonAbort];
}


-(void) sendUploadFileRequest: (NSString*) url {
    
    DCFile* file = [_parameterValues lastObject];
    
    _uploadTask = [[DCUploadTask alloc] init];
    _uploadTask.httpMethod = _serviceMethod.method;
    _uploadTask.filePath = file.path;
    _uploadTask.url = url;
    _uploadTask.feature = DCTaskFeatureStreamUpload;
    
    __unsafe_unretained DCUploadTask* weakTask = _uploadTask;
    [weakTask addCompleteCallback:^{
        [self requestDidCompleteWithData:_uploadTask.responseData error:_uploadTask.error statusCode:_uploadTask.statusCode];
        _uploadTask = nil;
    }];
    
    
    [[DCTaskPool obtainConcurrent] addTask:_uploadTask];
}

-(void) setHeaderValue:(NSString*) value forName:(NSString*) name {
    
    if (!_header) {
        _header = [[DCHttpHeader alloc] init];
        _header.isEnabled = YES;
    }
    
    [_header setHeaderValue:value forName:name];
}


-(void) submitDownloadTask:(NSString*) url {
    
    
    _downloadTask = [[DCDataRequestTask alloc] init];
    
    _downloadTask.url = url;
    if (_serviceMethod.isLoggingEnabled) {
        NSLog(@"%@", url);
    }
    
    
    if (_serviceMethod.postsData) {
        
        NSError* encodingError = nil;
        
        DCHttpBodyEncoder* encoder = [ServiceMetadata createEncoder];
        encoder.encoding = [ServiceMetadata encoderEncoding];
        
        NSData* body = [_serviceMethod postDataWithParameterValues:_parameterValues withEncoder:encoder error:&encodingError];
        
        
        if (encodingError) {
            NSLog(@"encoding error:%@", encodingError.localizedDescription);
        }
        else if (_serviceMethod.isLoggingEnabled) {
            NSLog(@"%@", [[NSString alloc] initWithData:body encoding:[ServiceMetadata encoderEncoding]]);
        }
        
        
        _downloadTask.contentType = [encoder contentTypeForHttpHeader];;
        _downloadTask.body = body;
        
        if (encodingError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self requestFailedWithException:_serviceMethod.encodeErrorMessage reason:DCServiceErrorReasonEncode];
            });
            return;
        }
    }
    
    _downloadTask.timeout = _serviceMethod.timeout;
    _downloadTask.httpMethod = _serviceMethod.method;
    _downloadTask.useCookie = _serviceMethod.isCookieEnabled;
    _downloadTask.requestEncodingName = [ServiceMetadata encoderEncodingName];
    
    if ([ServiceMetadata globalHeader]) {
        
        if (_serviceMethod.isLoggingEnabled) {
            [[ServiceMetadata globalHeader] printLog:@"global header"];
        }
        
        _downloadTask.globalHeader = [ServiceMetadata globalHeader];
    }
    
    if (_header) {
        
        if (_serviceMethod.isLoggingEnabled) {
            [_header printLog:@"request header"];
        }
        
        _downloadTask.requestHeader = _header;
    }
    
    __unsafe_unretained DCDownloadTask* weakTask = _downloadTask;
    [weakTask addCompleteCallback:^{
        [self taskDidComplete];
    }];
    
    [[DCTaskPool obtainConcurrent] addTask:_downloadTask];
}

-(void) taskDidComplete {
    
    if (_serviceMethod.isLoggingEnabled) {
        NSLog(@"%@", [[NSString alloc] initWithData:[_downloadTask returnedData] encoding:NSUTF8StringEncoding]);
    }
    
    [self requestDidCompleteWithData:_downloadTask.returnedData error:_downloadTask.error statusCode:_downloadTask.statusCode];
}

-(void) requestDidCompleteWithData:(NSData*) data error:(NSError*) error statusCode:(int) statusCode {
    
    id parsedData = nil;
    DCServiceContext* serviceContext = [[DCServiceContext alloc] init];
    serviceContext.httpCode = statusCode;
    
    if (error != nil) {
        serviceContext.message = error.code == -1001 ? _serviceMethod.timeoutMessage : _serviceMethod.fallbackMessage;
        serviceContext.errorReason = error.code == -1001 ? DCServiceErrorReasonTimeout : DCServiceErrorReasonHttp;
    }
    else if (statusCode != 200) {
        
        NSString* message = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
        
        serviceContext.message = message && message.length <= 200 ? message : _serviceMethod.fallbackMessage;
        serviceContext.errorReason = DCServiceErrorReasonHttp;
    }
    else  {
        
        serviceContext.isSucceeded = YES;
        
        if (_returnType) {
            parsedData = [self parseObjectFromData:data serviceContext:&serviceContext];
        }
    }
    
    
    [self requestDidComplete:parsedData serviceContext:serviceContext];
}

-(id) parseObjectFromData:(NSData*) data serviceContext:(DCServiceContext**) serviceContext {
    
    NSError* error;
    id object = [[ServiceMetadata createDecoder] objectFromData:data forClass:_returnType error:&error];
    
    if (error) {
        
        NSLog(@"decoding error:%@", error.localizedDescription);
        
        *serviceContext = [[DCServiceContext alloc] init];
        (*serviceContext).message = _serviceMethod.decodeErrorMessage;
        (*serviceContext).errorReason = DCServiceErrorReasonDecode;
    }
    
    return object;
}

-(void) requestDidComplete:(id) parsedData serviceContext:(DCServiceContext*) serviceContext {
    
    if (_isAborted) {
        return;
    }
    
    
    [RequestTracker remove];
    
    if (_returnType) {
        ((void (^)(DCServiceContext*, id))_callback)(serviceContext, parsedData);
    }
    else {
        ((void (^)(DCServiceContext*))_callback)(serviceContext);
    }
    
    if (!serviceContext.isSucceeded && _serviceMethod.showErrorMessage) {
        if (serviceContext.message) {
            [LDialog showMessage:serviceContext.message];
        }
    }
    
    _callback = nil;
}


+(Request*) create:(NSString*) serviceMethodName parameterValues:(NSArray*) parameterValues returnType:(Class) returnType {
    
    Request* request = [[Request alloc] init];
    request->_returnType = returnType;
    request->_serviceMethod = [ServiceMetadata findMethod:serviceMethodName];
    request->_parameterValues = parameterValues;
    return request;
}

@end
