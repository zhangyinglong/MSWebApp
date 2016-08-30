//
//  MSWebApp.h
//  Pods
//
//  Created by Dylan on 2016/8/25.
//
//

#import <Foundation/Foundation.h>
#import "WebViewJavascriptBridgeBase.h"
#import "MSWebViewController.h"
#import "MSWebAPI.h"
#import "MSWebAppOp.h"

#undef  MS_CONST
#define MS_CONST *const

FOUNDATION_EXTERN NSString MS_CONST MSWebAppGetOptionSuccess;
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchBegin;
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchErr;
FOUNDATION_EXTERN NSString MS_CONST MSWebModuleFetchOk;

/**
 MSWebApp: Hybrid framework, for local html5.zip updated dynamic.
 */
@interface MSWebApp : NSObject

/**
 Net work api.
 */
@property ( nonatomic, strong ) MSWebAPI * net;

/**
 In used web app option.
 */
@property ( nonatomic, strong ) MSWebAppOp *op;

/**
 Start webApp.
 1. Will query global config file.
 2. Check sub module state, download diff module.
 */
+ (void) startWithType: (NSString *) type;

/**
 Web app instance, web container.
 */
+ (MSWebViewController *) instanceWithTplURL: (NSString *) string;

/**
 If web app need custom user-agent, you need set this !before get instance!.
 `customUserAgentString` should not be long str.
 */
+ (void) setAppUserAgent: (NSString *) customUserAgentString;

/**
 Shared instance.
 */
+ (MSWebApp *) webApp;

/**
 The host that support `POST` request, with `app` and `version` param.
 app means that, what's webApp type, you can sep it.
 version means that, local webApp version.
 */
@property ( nonatomic, strong ) NSString * fullURL;

/**
 Regist webView subClass for use.
 */
@property ( nonatomic ) Class registedClass;

@end

#pragma mark -