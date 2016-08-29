//
//  MSWebAPI.m
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import "MSWebAPI.h"
#import "MSWebApp.h"

@implementation MSWebAPI

- (instancetype) init {
    self = [super init];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy         = NSURLRequestReloadIgnoringLocalCacheData;
    _wapi                                    = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    _wapi.responseSerializer                 = [AFJSONResponseSerializer serializer];
    if ( self ) {
        
    }
    return self;
}

- (NSURLSessionDataTask *) getWebAppWithHandler: (void (^)(NSURLResponse *response, id responseObject, NSError * error))handler {
    NSMutableURLRequest *buildingRequest;
    id                   param;
    NSError             *error;
    
    param = @{
              
              @"app"    : _type ?: @"",
              @"version": _version ?: @""
              
              };
    
    buildingRequest = [[AFHTTPRequestSerializer serializer]
                       requestWithMethod:@"POST"
                       URLString:[MSWebApp webApp].fullURL
                       parameters:param error:&error];
    NSURLSessionDataTask * dataTask =
    [_wapi
     dataTaskWithRequest:buildingRequest
     completionHandler:handler];
    [dataTask resume];
    return dataTask;
}

- (NSURLSessionDownloadTask *) getModule: (NSString *) packageURL
                                   save2: (NSURL *) url
                                 handler: (void (^)(NSURLResponse *response, NSURL * filePath, NSError * error))handler
                         progressHandler: (void (^)(CGFloat progress)) progressHandler {
    NSMutableURLRequest *buildingRequest;
    id                   param;
    NSError             *error;
    
    param = nil;
    buildingRequest = [[AFHTTPRequestSerializer serializer]
                       requestWithMethod:@"GET"
                       URLString:packageURL
                       parameters:param error:&error];
    NSURLSessionDownloadTask * downloadTask =
    [_wapi
     downloadTaskWithRequest:buildingRequest
     progress:^(NSProgress * downloadProgress) {
         progressHandler(downloadProgress.fractionCompleted);
    } destination:^NSURL * (NSURL * targetPath, NSURLResponse * response) {
         return url;
    } completionHandler:handler];
    [downloadTask resume];
    return downloadTask;
}

@end
