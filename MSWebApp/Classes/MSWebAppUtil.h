/*       ___         __  ___  _   ___  ___
  /| /| /___ | /| / /_  /__/ /_| /__/ /__/
 / |/ | ___/ |/ |/ /__ /__/ /  |/    /
 */

#import <Foundation/Foundation.h>
#import "MSWebApp.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1
#undef  kMSWebAppSupportWKWebView
//#define kMSWebAppSupportWKWebView
#endif

#undef  MSWebAppWK
//#if defined (kMSWebAppSupportWKWebView)
//#define MSWebAppWK( __wk__, __ui__ ) __wk__
//#elif
#define MSWebAppWK( __wk__, __ui__ ) __ui__
//#endif

#ifndef __OPTIMIZE__
#define NSLog(...) printf("-> %s\n", [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#endif

#undef  MSLog
#define MSLog(...) if ( [MSWebApp webApp].logging ) NSLog(__VA_ARGS__);

#undef  MS_CONST
#define MS_CONST *const

#undef  kMSWebAppIdentifier
#define kMSWebAppIdentifier @"kMSWebAppIdentifier"

/** WITH URLProtocol identifier*/
FOUNDATION_EXTERN NSString MS_CONST MSURLProtocolIdentifier;
/** POST on config get success, notification.object is `MSWebAppOp`*/
FOUNDATION_EXTERN NSString MS_CONST MSWebAppGetOptionSuccess;
/** POST on config get with error, notification.object is `NSError` or nil*/
FOUNDATION_EXTERN NSString MS_CONST MSWebAppGetOptionFailure;
/** POST on module start download, notification.object is `MSWebAppModule`*/
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchBegin;
/** POST on module downloaded or ziped with error, notification.object is `MSWebAppModule`*/
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchErr;
/** POST on module handler OK, notification.object is `MSWebAppModule`*/
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchOk;
/** POST on module mount progress changed*/
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchProgress;

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

/**
 printf MSWeb App logo.
 */
+ (void) initialized;

/**
 Get mime type
 */
+ (NSString *) mimetypeForResources: (NSString *) resourcesFullName;

@end
