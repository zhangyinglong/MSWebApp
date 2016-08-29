//
//  MSWebApp.m
//  Pods
//
//  Created by Dylan on 2016/8/25.
//
//

#import "MSWebApp.h"
#import "MSWebAppUtil.h"
#import "NSObject+LKDBHelper.h"

@interface MSWebApp ()

@end

@implementation MSWebApp

+ (MSWebApp *) webApp {
    static MSWebApp        *app;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !app ) {
            app = [[MSWebApp alloc] init];
            app.net = [[MSWebAPI alloc] init];
        }
    });
    return app;
}

+ (void) startWithType: (NSString *) type {
    [MSWebApp webApp].net.type = type;
    MSWebAppOp * oldOp = [MSWebAppOp searchSingleWithWhere:nil orderBy:nil];
    if ( oldOp ) {
        [MSWebApp webApp].net.version = oldOp.version;
    }
    
    [[MSWebApp webApp].net
     getWebAppWithHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
         [MSWebApp webApp].op = [[MSWebAppOp alloc] init];
         MSWebAppOp * o = [MSWebApp webApp].op;
         o.version = responseObject[@"app"][@"version"];
         __block NSMutableArray * arr = [NSMutableArray arrayWithCapacity:1];
         [responseObject[@"app"][@"module"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
             MSWebAppModule *m = [[MSWebAppModule alloc] init];
             [m setValuesForKeysWithDictionary:obj];
             [arr addObject:m];
         }];
         o.module = [NSArray arrayWithArray:arr];
         [MSWebAppUtil handlerOp];
    }];
    [MSWebAppUtil cleanWebView];
}

+ (MSWebViewController *) instanceWithTplURL: (NSString *) string {
    // Get file URL from http str.
    NSURL   *URL;
    NSURL   *realURL;
    
    URL = [NSURL URLWithString:string];
    
    if ( !URL ) {
        return nil;
    }
    
    // http://tpl.zhaogeshi.com/mainModule/enter.tpl?a=b&b=c
    if ( ![URL.host isEqualToString:[NSURL URLWithString:[MSWebApp webApp].fullURL].host] ) {
        return [[MSWebViewController alloc] initWithURLs:string];
    }
    
    // Validate path
    NSArray * paths = [[URL.path substringFromIndex:1] componentsSeparatedByString:@"/"];
    if ( paths.count != 2 ) {
        return [[MSWebViewController alloc] initWithURLs:string];
    }
    
    // Validated tpl rule.
    if ( ![paths[1] hasSuffix:@".tpl"] ) {
        return [[MSWebViewController alloc] initWithURLs:string];
    }
    
    // Validated module
    NSString * mid = paths[0];
    MSWebAppModule * module = [MSWebApp webApp].op.moduleMap[mid];
    if ( !module ) {
        return [[MSWebViewController alloc] initWithURLs:string];
    }
    
    // Validated download state.
    if ( !module.downloaded ) {
        [module get];
        return [[MSWebViewController alloc] initWithURLs:string];
    }
    
    // Validated urls, 可能是配置文件模块, 不需要访问
    if ( !module.urls || !module.urls[paths[1]]) {
        return [[MSWebViewController alloc] initWithURLs:string];
    }
    
    NSString * urlWithoutQuery = [[module getCachedPath] stringByAppendingPathComponent:module.urls[paths[1]]];
    NSString * realPath =
    [NSString stringWithFormat:@"%@?%@", [[module getCachedPath] stringByAppendingPathComponent:module.urls[paths[1]]], URL.query?: @"query=none" ];
    
    realURL = [NSURL fileURLWithPath:realPath];
    
    if ( [[MSWebApp webApp].registedClass isSubclassOfClass:[MSWebViewController class]] ) {
        return [[[MSWebApp webApp].registedClass alloc] initWithURLs:realURL.absoluteString];
    } else {
        return [[MSWebViewController alloc] initWithURLs:realURL.absoluteString];
    }
}

+ (void) setAppUserAgent: (NSString *) customUserAgentString {
    @autoreleasepool {
        UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *ua = [NSString stringWithFormat:@"%@ %@",
                        userAgent,
                        customUserAgentString];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
    }
}

- (Class) registedClass {
    if ( !_registedClass ) {
        return [MSWebViewController class];
    }
}

@end
