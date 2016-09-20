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
#import "MSMemory.h"

#define kMSURLProtocolRecursiveIdentifier @"com.mswebapp.urlprotocol.recursive"

@interface MSURLProtocol ()

@property ( nonatomic, strong ) NSURLSessionTask *task;
@property ( nonatomic, strong ) AFURLSessionManager *sessionManager;

@end

@implementation MSURLProtocol

+ (void) load {
    if ( [NSURLProtocol registerClass:self] ) {
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSDictionary    *headerFields;
    NSURL           *requestedURL;
    
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
            NSArray     *handledResourceType;
            NSString    *pathExtension;
            
            handledResourceType     = @[@"css", @"js", @"ico", @"png", @"jpg", @"gif", @"mp3", @"mp4"];
            pathExtension           = requestedURL.pathExtension;
            if ( [handledResourceType containsObject:pathExtension] ) {
                MSLog(@"URLProtocol: %@", request.URL);
                return YES;
            }
        }
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest     *result;
    NSURL                   *requestedURL;
    NSString                *fullFilePath;
    NSString                *moduleFilePath;
    
    // Get origin URL, protocol can use this method means resources file lost or errored.
    requestedURL    = request.URL;
    fullFilePath    = requestedURL.path;
    // Get real module id.
    moduleFilePath = [fullFilePath componentsSeparatedByString:[MSWebAppUtil getLocalCachePath]].lastObject;
    MSWebAppModule *module = [self getModuleInRequest:request];
    if ( module && module.files ) {
        NSString    *localFilePath;
        NSString    *remoteFilePath;
        NSURL       *remoteURL;
        
        localFilePath = [moduleFilePath stringByReplacingOccurrencesOfString:module.mid withString:@""];
        // Check use memory cache or not!
        // If NSFileManager has this file and route here, should be load in memory cache.
        if ( [[NSFileManager defaultManager] fileExistsAtPath:fullFilePath] ) {
            MSMemory    *memory;
            
            memory = [MSWebApp webApp].memoryCache;
            // If memory cache has file data, return the origin request.
            if ( memory && [memory datainModule:module.mid key:localFilePath] ) {
                return request;
            }
        }
        // Get remote file
        remoteFilePath = module.files[[self getLocalResourcesKey:request]];
        // Get remote File URL from module files map.
        if ( remoteFilePath ) {
            remoteURL = [NSURL URLWithString:remoteFilePath];
            if ( remoteURL ) {
                result = [NSURLRequest requestWithURL:remoteURL];
                return result;
            }
        }
    }
    return request;
}

+ (MSWebAppModule *) getModuleInRequest: (NSURLRequest *) request {
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
        return [MSWebApp webApp].op.moduleMap[moduleId];
    }
    return nil;
}

+ (NSString *) getLocalResourcesKey: (NSURLRequest *) request {
    NSURL                   *requestedURL;
    NSString                *fullFilePath;
    NSString                *cachedRootPath;
    NSString                *moduleFilePath;
    
    // Get origin URL, protocol can use this method means resources file lost or errored.
    requestedURL    = request.URL;
    fullFilePath    = requestedURL.path;
    cachedRootPath  = [MSWebAppUtil getLocalCachePath];
    // Get real module id.
    moduleFilePath = [fullFilePath componentsSeparatedByString:cachedRootPath].lastObject;
    // Validated module id.
    // Validated module in operation.
    MSWebAppModule *module = [self getModuleInRequest:request];
    if ( module && module.files ) {
        NSString    *localFilePath;
        // Operate the module file path to file absolute path,
        // Should check path is corrected.
        if ( [moduleFilePath hasPrefix:@"/"] ) {
            moduleFilePath = [moduleFilePath substringFromIndex:1];
        }
        return [moduleFilePath stringByReplacingOccurrencesOfString:module.mid withString:@""];
    }
    return nil;
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
    // If memory cached, use the data.
    MSWebAppModule *module = [[self class] getModuleInRequest:recursiveRequest];
    MSMemory *memory = [MSWebApp webApp].memoryCache;
    
    // If memory cache has file data, return the origin request.
    NSString *key = [[self class] getLocalResourcesKey:recursiveRequest];
    NSData *data = [memory datainModule:module.mid key:key];
    
    if ( data && [data isKindOfClass:[NSData class]] ) {
        MSLog(@"%@", @"Loaded from memory cache!");
        // MIME-TYPE
        NSString * mime = [MSWebAppUtil mimetypeForResources:key];
        NSString * contentLength = data? [NSString stringWithFormat:@"%d", data.length]: @"0";
        NSString * cacheControl = @"max-age=315360000,s-maxage=60";
        
        NSMutableDictionary * header = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        [header setObject:mime          forKey:@"Content-Type"];
        [header setObject:contentLength forKey:@"Content-Length"];
        [header setObject:cacheControl  forKey:@"Cache-Control"];
        
        NSHTTPURLResponse * httpResponse = [[NSHTTPURLResponse alloc] initWithURL:[recursiveRequest URL] statusCode:200 HTTPVersion:@"1.1" headerFields:header];
        
        [[self client] URLProtocol:self didReceiveResponse:httpResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [[self client] URLProtocol:self didLoadData:data];
        [[self client] URLProtocolDidFinishLoading:self];
        return ;
    }
    MSLog(@"%@", @"Loaded from remote resource!");
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
