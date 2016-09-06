//
//  MSWebAppUtil.h
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1
#undef  kMSWebAppSupportWKWebView
#define kMSWebAppSupportWKWebView
#endif

#if defined (kMSWebAppSupportWKWebView)
#define MSWebAppWK( __wk__, __ui__ ) __wk__
#elif
#define MSWebAppWK( __wk__, __ui__ ) __ui__
#endif

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
