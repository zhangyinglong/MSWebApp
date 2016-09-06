//
//  MSWebViewController.m
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import "MSWebViewController.h"

@interface MSWebViewController () <
#if defined (kMSWebAppSupportWKWebView)
WKUIDelegate, WKNavigationDelegate
#else
UIWebViewDelegate
#endif
>

@property ( nonatomic, strong ) NSURL * URL;

@end

@implementation MSWebViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:_browser];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _browser.frame = self.view.bounds;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void) dealloc {
    if ( _browser ) {
        [_browser loadHTMLString:@"" baseURL:nil];
        MSWebAppWK(
                   {
                       _browser.UIDelegate         = nil;
                       _browser.navigationDelegate = nil;
                   },
                   {
                       _browser.delegate           = nil;
                   });
        [_browser removeFromSuperview];
        _browser = nil;
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark -

#if defined (kMSWebAppSupportWKWebView)

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self startLoad];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    __weak typeof(self) weakself = self;
    [_browser evaluateJavaScript:@"document.title" completionHandler:^(id object, NSError * error) {
        if ( !error ) {
            weakself.title = [NSString stringWithFormat:@"%@", object];
        }
    }];
    [self finishLoad];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // When load failure, auto load 404 page.
    [self load404: @""];
}

#else

- (void) webViewDidStartLoad: (UIWebView *) webView {
    [self startLoad];
}

- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request
  navigationType: (UIWebViewNavigationType) navigationType {
    return YES;
}

- (void) webViewDidFinishLoad: (UIWebView *) webView {
    self.title = [_browser stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self finishLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // When load failure, auto load 404 page.
    [self load404: @""];
}

#endif

// Subclass it.
- (void) load404: (id) content {
    
}

- (void) startLoad {
    
}

- (void) finishLoad {
    
}

#pragma mark -

- (instancetype) initWithURLs: (NSString *) URLs {
    self     = [super init];
    _URL     = [NSURL URLWithString:[URLs stringByRemovingPercentEncoding]];
    MSWebAppWK(
    {
        WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc] init];
        _browser                               = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        _bridge                                = [WKWebViewJavascriptBridge bridgeForWebView:_browser];
    },
    {
        _browser = [[UIWebView alloc] init];
        _bridge  = [WebViewJavascriptBridge bridgeForWebView:_browser];
    });
    if ( self ) {
        [_bridge setWebViewDelegate:self];
        
        // Pre loaded.
        NSURLRequest * request;
        request  = [NSURLRequest requestWithURL:_URL];
        
        [_browser setBackgroundColor:[UIColor whiteColor]];
        [_browser loadRequest:request];
    }
    return self;
}

#pragma mark -

+ (void) enableLogging {
    MSWebAppWK(
    {
        [WKWebViewJavascriptBridge enableLogging];
    },
    {
        [WebViewJavascriptBridge enableLogging];
    });
}

- (void) registerHandler: (NSString*) handlerName handler: (WVJBHandler) handler {
    if ( _bridge ) {
        [_bridge registerHandler:handlerName handler:handler];
    }
}

- (void) callHandler: (NSString*) handlerName {
    if ( _bridge ) {
        [_bridge callHandler:handlerName];
    }
}

- (void) callHandler: (NSString*) handlerName data: (id) data {
    if ( _bridge ) {
        [_bridge callHandler:handlerName data:data];
    }
}

- (void) callHandler: (NSString*) handlerName data: (id) data responseCallback: (WVJBResponseCallback) responseCallback {
    if ( _bridge ) {
        [_bridge callHandler:handlerName data:data responseCallback:responseCallback];
    }
}

@end
