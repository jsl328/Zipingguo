//
//  DownloadTask.m
//  Mulberry
//
//  Created by Bob Li on 13-7-9.
//  Copyright (c) 2013年 Bob Li. All rights reserved.
//

#import "DCDownloadTask.h"
#import "FileSystem.h"

@implementation DCDownloadTask {
    

    NSMutableURLRequest* _request;
    
    NSURLConnection* _connection;
    
    int _receivedDataLength;
    
    NSError* _error;
    
    int _statusCode;
    
    
    BOOL _isFinished;
}

@synthesize url;

@synthesize responseContentLength;
@synthesize body;
@synthesize contentType;
@synthesize httpMethod;
@synthesize useCookie;
@synthesize globalHeader;
@synthesize requestHeader;
@synthesize requestEncodingName;


// abstract methods

-(void) onDownloadStart {
}

-(void) writeData:(NSData*) data {
}

-(void) onDownloadComplete {
}

//


-(id) init {
    self = [super init];
    if (self) {
        httpMethod = @"GET";
        self.feature = DCTaskFeatureStreamDownload;
    }
    return self;
}


-(void) execute {
    
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:self.timeout];
    
    [_request setHTTPMethod:httpMethod];
    
    if (body) {
        [_request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        [_request setHTTPBody:body];
    }

    if (useCookie) {
        [self addCookieToRequest:_request];
    }
    
    if (globalHeader) {
        [globalHeader applyToRequest:_request];
    }
    
    if (requestHeader) {
        [requestHeader applyToRequest:_request];
    }
    
    
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
    

    while (!_isFinished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    
    if (_error) {
//        @throw DCWebExceptionMake(@"Download exception", _error);
    }
}

-(void) addCookieToRequest:(NSMutableURLRequest*) request {
    
    NSArray * cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:request.URL];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [request setAllHTTPHeaderFields:headers];
}

-(void) storeCookiesForResponse:(NSHTTPURLResponse*) response {
        
    NSArray * cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:cookies forURL:response.URL mainDocumentURL:nil];
}

-(NSError*) error {
    return _error;
}

-(int) statusCode {
    return _statusCode;
}

#pragma mark - https?

-(void) connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {

    
//    /* Extract the server certificate for trust validation
//     */
//    NSURLProtectionSpace *protectionSpace = [challenge protectionSpace];
//    assert(protectionSpace);
//    SecTrustRef trust = [protectionSpace serverTrust];
//    assert(trust);
//    CFRetain(trust); // Make sure this thing stays around until we're done with it
//    NSURLCredential *credential = [NSURLCredential credentialForTrust:trust];
//    
//    
//    /* On iOS
//     * we need to convert it to 'der' certificate. It can be done easily through Terminal as follows:
//     * $ openssl x509 -in certificate.pem -outform der -out rootcert.der
//     */
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"rootcert" ofType:@"der"];
//    assert(path);
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    assert(data);
//    
//    /* Set up the array of certificates, we will authenticate against and create credentials */
//    SecCertificateRef rtCertificate = SecCertificateCreateWithData(NULL, CFBridgingRetain(data));
//    const void *array[1] = { rtCertificate };
//    CFArrayRef trustedCerts = CFArrayCreate(NULL, array, 1, &kCFTypeArrayCallBacks);
//    CFRelease(rtCertificate); // for completeness, really does not matter
//    
//    /* Build up the trust anchor using our root cert */
//    int err;
//    SecTrustResultType trustResult = 0;
//    err = SecTrustSetAnchorCertificates(trust, trustedCerts);
//    if (err == noErr) {
//        err = SecTrustEvaluate(trust, &trustResult);
//    }
//    CFRelease(trust); // OK, now we're done with it
//    
//    
//    /* http://developer.apple.com/library/mac/#qa/qa1360/_index.html
//     */
//    BOOL trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultConfirm) || (trustResult == kSecTrustResultUnspecified));
//    
//    // Return based on whether we decided to trust or not
//    if (trusted) {
//        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//    } else {
//        [[challenge sender] cancelAuthenticationChallenge:challenge];
//    }
}

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


-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {

    _connection = nil;
    
    [self onDownloadComplete];
    
    _error = error;
    _isFinished = YES;
}

-(void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _statusCode = ((NSHTTPURLResponse*)response).statusCode;
    
    if (useCookie) {
        [self storeCookiesForResponse:(NSHTTPURLResponse*)response];
    }
    
    responseContentLength = (int)[response expectedContentLength];
    if (responseContentLength == NSURLResponseUnknownLength) {
        responseContentLength = -1;
    }
}

-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    [self writeData:data];
    
    _receivedDataLength += data.length;
    
    if (responseContentLength > 0) {
        [self reportProgress: (double)_receivedDataLength / responseContentLength];
    }
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self onDownloadComplete];
    
    _connection = nil;
    _isFinished = YES;
}

@end
