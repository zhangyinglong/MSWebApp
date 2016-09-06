//
//  MSWebViewController.h
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import <UIKit/UIKit.h>
#import "MSWebAppUtil.h"

#if defined (kMSWebAppSupportWKWebView)
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
#else
#import "WebViewJavascriptBridge.h"
#endif

@interface MSWebViewController : UIViewController

/**
 Instance type, with `Real Can opened URL!`
 */
- (instancetype) initWithURLs: (NSString *) URLs;

#if defined (kMSWebAppSupportWKWebView)
/**
 WK Web container.
 */
@property ( nonatomic, strong ) WKWebView * browser;
/**
 WK WebView java script bridge instance.
 */
@property ( nonatomic, strong ) WKWebViewJavascriptBridge * bridge;
#else
/**
 Web container.
 */
@property ( nonatomic, strong ) UIWebView * browser;
/**
 WebView java script bridge instance.
 */
@property ( nonatomic, strong ) WebViewJavascriptBridge * bridge;
#endif

#pragma mark - WebViewJavaScript methods.

+ (void) enableLogging;
- (void) registerHandler: (NSString*) handlerName handler: (WVJBHandler) handler;
- (void) callHandler: (NSString*) handlerName;
- (void) callHandler: (NSString*) handlerName data: (id) data;
- (void) callHandler: (NSString*) handlerName data: (id) data responseCallback: (WVJBResponseCallback) responseCallback;

#pragma mark - SubClassing methods.

- (void) load404: (id) content;
- (void) startLoad;
- (void) finishLoad;

@end
