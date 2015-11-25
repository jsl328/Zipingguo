//
//  DCUploadTask.m
//  DandelionDemo
//
//  Created by Bob Li on 13-12-12.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCUploadTask.h"
#import "FileSystem.h"
#import "DCFile.h"

@implementation DCUploadTask {

    NSMutableURLRequest* _request;
    
    NSURLConnection* _connection;
    
    int _uploadedDataLength;
    
    int _fileLength;
    
    NSOutputStream* _responseStream;
    
    
    BOOL _isFinished;
}

@synthesize url;
@synthesize filePath;
@synthesize responseData;
@synthesize error = _error;
@synthesize httpMethod = _httpMethod;
@synthesize statusCode;

- (id)init
{
    self = [super init];
    if (self) {
        self.httpMethod = @"POST";
    }
    return self;
}

-(void) execute {

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        @throw DCFileNotFoundExceptionMake([NSString stringWithFormat:@"File not found at %@", filePath]);
        return;
    }
    
    
    _fileLength = [DCFile fileAtPath:filePath].length;
    _uploadedDataLength = 0;
    
    _responseStream = [NSOutputStream outputStreamToMemory];
    [_responseStream open];
    
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [_request setHTTPMethod:_httpMethod];
    [_request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [_request setHTTPBody:[NSData dataWithContentsOfFile:filePath]];
    
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
    

    while (!_isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
    if (_error) {
        @throw DCWebExceptionMake(@"Upload exception", _error);
    }
}

#pragma mark - conectionDelegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        [[challenge sender]  useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
    }
    
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    statusCode = (int)((NSHTTPURLResponse*)response).statusCode;
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    _connection = nil;
    
    _error = error;
    _isFinished = YES;
}

-(void) connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {

    _uploadedDataLength = (int)totalBytesWritten;
    
    if (_fileLength > 0) {
        [self reportProgress:(float)_uploadedDataLength / _fileLength];
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseStream write:[data bytes] maxLength:data.length];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    responseData = [_responseStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
    [_responseStream close];
    
    _connection = nil;
    _isFinished = YES;
}

@end
