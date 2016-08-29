//
//  MSWebViewController.h
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import <UIKit/UIKit.h>
#import "WebViewJavascriptBridge.h"

@interface MSWebViewController : UIViewController

/**
 Instance type, with `Real Can opened URL!`
 */
- (instancetype) initWithURLs: (NSString *) URLs;

/**
 Web container.
 */
@property ( nonatomic, strong ) UIWebView * browser;

/**
 WebView java script bridge instance.
 */
@property ( nonatomic, strong ) WebViewJavascriptBridge * bridge;

#pragma mark - WebViewJavaScript methods.

+ (void) enableLogging;
- (void) registerHandler: (NSString*) handlerName handler: (WVJBHandler) handler;
- (void) callHandler: (NSString*) handlerName;
- (void) callHandler: (NSString*) handlerName data: (id) data;
- (void) callHandler: (NSString*) handlerName data: (id) data responseCallback: (WVJBResponseCallback) responseCallback;

@end
