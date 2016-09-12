//
//  MSURLProtocol.m
//  Pods
//
//  Created by Dylan on 2016/9/7.
//
//

#import "MSURLProtocol.h"
#import "MSWebAppUtil.h"
#import "MSFileCRC.h"

#define kMSURLProtocolRecursiveIdentifier @"com.mswebapp.urlprotocol.recursive"

@interface MSURLProtocol ()

@property ( nonatomic, strong ) NSURLSessionTask *task;
@property ( nonatomic, strong ) AFURLSessionManager *sessionManager;

@end

@implementation MSURLProtocol

+ (void) load {
    if ( [NSURLProtocol registerClass:self] ) {
        MSLog(@"WebApp Started URLProtocol for Resources filter");
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSDictionary    *headerFields;
    NSURL           *requestedURL;
    
    MSLog(@"%@", request.URL);
    
    headerFields = [NSDictionary dictionaryWithDictionary:request.allHTTPHeaderFields?:@{}];
    requestedURL = request.URL;
    
    if ( [self propertyForKey:kMSURLProtocolRecursiveIdentifier inRequest:request] ) {
        return NO;
    }
    // Validated URL And MSWebApp Requests.
    if ( [[headerFields valueForKey:kMSWebAppIdentifier] isEqualToString:MSURLProtocolIdentifier] ) {
        // Now, we have no need to do something with MSWebApp's requests, so return NO;
        return NO;
    }
    // Validated host of `requestedURL` is `File URL` And Path Contained web app cached path.
    if ( [requestedURL isFileURL] ) {
        NSString    *cachedRootPath;
        
        cachedRootPath = [MSWebAppUtil getLocalCachePath];
        // Notice: Other plug-in or modules get the webApp cached path with `URLRequest`
        // will hander by this protocol.
        if ( [requestedURL.path containsString:cachedRootPath] ) {
            // If local file is missed or modified, change the resources to remote server request.
            // Only handler resources loaded. like css, js lost.
            NSArray     *handledResourceType;
            NSString    *pathExtension;
            NSString    *fullFilePath;
            
            handledResourceType     = @[@"css", @"js", @"less", @"sass"];
            pathExtension           = requestedURL.pathExtension;
            fullFilePath            = requestedURL.path;
            
            if ( [handledResourceType containsObject:pathExtension] ) {
                // File CRC is can't validated,
                // Notice: File md5 and crc will cost a lot of times when file is big
                // unsigned short c = [MSFileCRC crcForFile:fullFilePath];
                // File is losted.
                if ( ![[NSFileManager defaultManager] fileExistsAtPath:fullFilePath] ) {
                    return YES;
                }
            }
            return NO;
        }
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest     *result;
    NSURL                   *requestedURL;
    NSString                *fullFilePath;
    NSString                *cachedRootPath;
    NSString                *moduleId;
    NSString                *moduleFilePath;
    
    // Get origin URL, protocol can use this method means resources file lost or errored.
    requestedURL    = request.URL;
    fullFilePath    = requestedURL.path;
    cachedRootPath  = [MSWebAppUtil getLocalCachePath];
    // Get real module id.
    moduleFilePath = [fullFilePath componentsSeparatedByString:cachedRootPath].lastObject;
    NSArray *paths  = [moduleFilePath componentsSeparatedByString:@"/"];
    for ( NSString * p in paths) {
        if ( ![p isEqualToString:@""] ) {
            moduleId = p;
            break;
        }
    }
    // Validated module id.
    if ( moduleId ) {
        // Validated module in operation.
        MSWebAppModule *module = [MSWebApp webApp].op.moduleMap[moduleId];
        if ( module && module.files ) {
            NSString    *localFilePath;
            NSString    *remoteFilePath;
            NSURL       *remoteURL;
            // Operate the module file path to file absolute path,
            // Should check path is corrected.
            if ( [moduleFilePath hasPrefix:@"/"] ) {
                moduleFilePath = [moduleFilePath substringFromIndex:1];
            }
            localFilePath = [moduleFilePath stringByReplacingOccurrencesOfString:moduleId withString:@""];
            remoteFilePath = module.files[localFilePath];
            // Get remote File URL from module files map.
            if ( remoteFilePath ) {
                remoteURL = [NSURL URLWithString:remoteFilePath];
                if ( remoteURL ) {
                    result = [NSURLRequest requestWithURL:remoteURL];
                    return result;
                }
            }
        }
    }
    return request;
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                 cachedResponse:(NSCachedURLResponse *)cachedResponse
                         client:(id<NSURLProtocolClient>)client {
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if ( self ) {
        // Session manager, with HTTPResponseSerializer.
        _sessionManager =
        [[AFURLSessionManager alloc]
         initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

- (void)startLoading {
    NSMutableURLRequest     *recursiveRequest;
    // change request to mutable, for set recursive identifier for the request.
    recursiveRequest    = [[self request] mutableCopy];
    // Set identifier
    [MSURLProtocol setProperty:@YES forKey:kMSURLProtocolRecursiveIdentifier inRequest:recursiveRequest];
    // Build a new task for request.
    // Weakify self for block usage.
    __weak typeof(self) weaks = self;
    // New task for request resource from remote url.
    self.task =
    [_sessionManager
     dataTaskWithRequest:recursiveRequest
     completionHandler:^(NSURLResponse * response, id responseObject, NSError * error) {
         // Finish this task
         if (error == nil) {
             // Indicates to an NSURLProtocolClient that the protocol
             // implementation has finished loading successfully.
             [[weaks client] URLProtocolDidFinishLoading:weaks];
         } else {
             // Indicates to an NSURLProtocolClient that the protocol
             // implementation has `failed` to load.
             [[weaks client] URLProtocol:weaks didFailWithError:error];
         }
    }];
    // Sets a block to be executed when an HTTP request is attempting to perform a redirection to a different URL,
    // as handled by the `NSURLSessionTaskDelegate` method `URLSession:willPerformHTTPRedirection:newRequest:completionHandler:`.
    [_sessionManager
     setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession * session, NSURLSessionTask * task, NSURLResponse * response, NSURLRequest * request) {
         NSMutableURLRequest *    redirectRequest;
         
         redirectRequest = [request mutableCopy];
         [[weaks class] removePropertyForKey:kMSURLProtocolRecursiveIdentifier inRequest:redirectRequest];
         // Indicates to an NSURLProtocolClient that a redirect has
         // occurred.
         [[weaks client] URLProtocol:weaks wasRedirectedToRequest:redirectRequest redirectResponse:response];
         // Cancel current task
         [weaks.task cancel];
         [[weaks client] URLProtocol:weaks didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
         return redirectRequest;
    }];
    // Receive response.
    // TODO: Should check `Cache-Control`, `no-store` in headerField. Now, set always allowed load.
    [_sessionManager
     setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * session, NSURLSessionDataTask * dataTask, NSURLResponse * response) {
         // Indicates to an NSURLProtocolClient that the protocol
         // implementation has created an NSURLResponse for the current load.
         [[weaks client] URLProtocol:weaks didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
         return NSURLSessionResponseAllow;
    }];
    // Did receive data here.
    [_sessionManager
     setDataTaskDidReceiveDataBlock:^(NSURLSession *session, NSURLSessionDataTask *dataTask, NSData *data) {
         // Indicates to an NSURLProtocolClient that the protocol
         // implementation has loaded URL data.
         [[weaks client] URLProtocol:weaks didLoadData:data];
    }];
    // Send task.
    [self.task resume];
}

- (void)stopLoading {
    if ( self.task != nil ) {
        [self.task cancel];
        self.task = nil;
    }
}

@end
