/*       ___         __  ___  _   ___  ___
  /| /| /___ | /| / /_  /__/ /_| /__/ /__/
 / |/ | ___/ |/ |/ /__ /__/ /  |/    /
 */

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface MSWebAPI : NSObject

/**
 File session manager.
 */
@property ( nonatomic, strong ) AFURLSessionManager * fapi;

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

#pragma mark - 
/**
 Request config API.
 */
+ (void) startApp;

@end
