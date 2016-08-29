//
//  MSWebAppUtil.h
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import <Foundation/Foundation.h>

@interface MSWebAppUtil : NSObject

/**
 Handle op with old op.
 */
+ (void) handlerOp;

/**
 Local root path.
 */
+ (NSString *) getLocalCachePath;

/**
 Clean local cache.
 */
+ (void) cleanLocalCache;

/**
 Clean webView.
 */
+ (void) cleanWebView;

@end
