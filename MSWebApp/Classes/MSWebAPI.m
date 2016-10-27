//
//  MSWebAPI.m
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import "MSWebAPI.h"
#import "MSWebApp.h"
#import "NSObject+LKDBHelper.h"
#import "MSURLProtocol.h"

@implementation MSWebAPI

- (instancetype) init {
	self = [super init];
	// Ignore local cached data configuration.
	NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
	// Set protocol for this session.
	configuration.protocolClasses = @[ [MSURLProtocol class] ];
	configuration.requestCachePolicy         = NSURLRequestReloadIgnoringLocalCacheData;
	
	// Web api initialized, Default use JSONResponseSerializer
	_wapi                                    = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	_wapi.responseSerializer                 = [AFJSONResponseSerializer serializer];
	
	// File api initialized, Default use HTTPResponseSerializer
	_fapi                                    = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
	_fapi.responseSerializer                 = [AFHTTPResponseSerializer serializer];
	if ( self ) {
		
	}
	return self;
}

- (NSURLSessionDataTask *) getWebAppWithHandler: (void (^)(NSURLResponse *response, id responseObject, NSError * error))handler {
	NSMutableURLRequest *buildingRequest;
	id                   param;
	NSError             *error;
	// Value check
	param = @{
						
						@"app"    : _type ?: @"",
						@"version": _version ?: @""
						
						};
	
	buildingRequest = [[AFHTTPRequestSerializer serializer]
										 requestWithMethod:@"POST"
										 URLString:[MSWebApp webApp].fullURL
										 parameters:param error:&error];
	// Build request with error.
	if ( error ) {
		handler(nil, nil, error);
		return nil;
	}
	[buildingRequest addValue:MSURLProtocolIdentifier forHTTPHeaderField:kMSWebAppIdentifier];
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
	// Build request with error.
	if ( error ) {
		handler(nil, nil, error);
		return nil;
	}
	[buildingRequest addValue:MSURLProtocolIdentifier forHTTPHeaderField:kMSWebAppIdentifier];
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

+ (void) startApp {
	MSWebAppOp * oldOp = [MSWebAppOp searchSingleWithWhere:nil orderBy:nil];
	if ( oldOp ) {
		[MSWebApp webApp].net.version = oldOp.version;
	}
	/**
	 Future: Moving request to utils.
	 */
	[[MSWebApp webApp].net
	 getWebAppWithHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
		 if ( error || !responseObject ) {
			 [[NSNotificationCenter defaultCenter] postNotificationName:MSWebAppGetOptionFailure object:error];
		 } else {
			 [MSWebApp webApp].op = [[MSWebAppOp alloc] init];
			 MSWebAppOp * o = [MSWebApp webApp].op;
			 o.version = responseObject[@"app"][@"version"];
			 __block NSMutableArray * arr = [NSMutableArray arrayWithCapacity:1];
			 [responseObject[@"app"][@"module"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
				 MSWebAppModule *m = [[MSWebAppModule alloc] init];
				 [m setValuesForKeysWithDictionary:obj];
				 [arr addObject:m];
			 }];
			 o.module = [NSArray arrayWithArray:arr];
			 [MSWebAppUtil handlerOp];
		 }
	 }];
}

@end
