//
//  MSWebAPI.h
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface MSWebAPI : NSObject

/**
 Wapi session manager.
 */
@property ( nonatomic, strong ) AFURLSessionManager * wapi;

/**
 App type
 */
@property ( nonatomic, strong ) NSString * type;

/**
 Local app version.
 */
@property ( nonatomic, strong ) NSString * version;

/**
 Web app global config.
 */
- (NSURLSessionDataTask *) getWebAppWithHandler: (void (^)(NSURLResponse *response, id responseObject, NSError * error))handler;

/**
 Download Module 2 file url.
 */
- (NSURLSessionDownloadTask *) getModule: (NSString *) packageURL
                                   save2: (NSURL *) url
                                 handler: (void (^)(NSURLResponse *response, NSURL * filePath, NSError * error))handler
                         progressHandler: (void (^)(CGFloat progress)) progressHandler;

@end