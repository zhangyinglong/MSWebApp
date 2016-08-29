//
//  MSWebViewController.m
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import "MSWebViewController.h"

@interface MSWebViewController () <UIWebViewDelegate>

@property ( nonatomic, strong ) NSURL * URL;

@end

@implementation MSWebViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:_browser];
    self.view.backgroundColor = [UIColor whiteColor];
    _browser.backgroundColor = [UIColor whiteColor];
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
        _browser.delegate = nil;
        [_browser removeFromSuperview];
        _browser = nil;
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark -

- (void) webViewDidStartLoad: (UIWebView *) webView {
    
}

- (BOOL) webView: (UIWebView *) webView shouldStartLoadWithRequest: (NSURLRequest *) request
  navigationType: (UIWebViewNavigationType) navigationType {
    return YES;
}

- (void) webViewDidFinishLoad: (UIWebView *) webView {
    self.title = [_browser stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - 

- (instancetype) initWithURLs: (NSString *) URLs {
    self     = [super init];
    _URL     = [NSURL URLWithString:[URLs stringByRemovingPercentEncoding]];
    _browser = [[UIWebView alloc] init];
    _bridge  = [WebViewJavascriptBridge bridgeForWebView:_browser];
    if ( self ) {
        [_bridge setWebViewDelegate:self];
        
        // Pre loaded.
        NSURLRequest * request;
        request                     = [NSURLRequest requestWithURL:_URL];
        
        [_browser loadRequest:request];
    }
    return self;
}

#pragma mark - 

+ (void) enableLogging {
    [WebViewJavascriptBridge enableLogging];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
