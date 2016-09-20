//
//  MSWebApp.m
//  Pods
//
//  Created by Dylan on 2016/8/25.
//
//

#import "MSWebApp.h"
#import "MSWebAppUtil.h"
#import "MSMemory.h"

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
            app.memoryCache = [[MSMemory alloc] init];
        }
    });
    return app;
}

+ (void) startWithType: (NSString *) type {
    [MSWebApp webApp].net.type = type;
    [MSWebAppUtil initialized];
}

+ (MSWebViewController *) instanceWithTplURL: (NSString *) string {
    // Get file URL from http str.
    NSURL   *URL;
    NSURL   *realURL;
    
    URL = [NSURL URLWithString:string];
    
    if ( !URL ) {
        return nil;
    }
    if ( ![URL.host isEqualToString:[NSURL URLWithString:[MSWebApp webApp].fullURL].host] ) {
        return [[[MSWebApp webApp].getRegistedClass alloc] initWithURLs:string];
    }
    
    // Validate path
    if ( !URL.path || URL.path.length <= 1) {
        return [[[MSWebApp webApp].getRegistedClass alloc] initWithURLs:string];
    }
    
    NSArray * paths = [[URL.path substringFromIndex:1] componentsSeparatedByString:@"/"];
    if ( paths.count != 2 ) {
        return [[[MSWebApp webApp].getRegistedClass alloc] initWithURLs:string];
    }
    
    // Validated tpl rule.
    if ( ![paths[1] hasSuffix:@".tpl"] ) {
        return [[[MSWebApp webApp].getRegistedClass alloc] initWithURLs:string];
    }
    
    // Validated module
    NSString * mid = paths[0];
    MSWebAppModule * module = [MSWebApp webApp].op.moduleMap[mid];
    if ( !module ) {
        return [[[MSWebApp webApp].getRegistedClass alloc] initWithURLs:string];
    }
    
    // Validated download state.
    if ( !module.downloaded ) {
        [module get];
    }
    
    // Validated urls
    if ( !module.urls || !module.urls[paths[1]]) {
        return [[[MSWebApp webApp].getRegistedClass alloc] initWithURLs:string];
    }
    // Build real file path to visit the website.
    NSString * urlWithoutQuery = [[module getCachedPath] stringByAppendingPathComponent:module.urls[paths[1]]];
    NSString * realPath =
    [NSString stringWithFormat:@"%@?%@", [[module getCachedPath] stringByAppendingPathComponent:module.urls[paths[1]]], URL.query?: @"query=none" ];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:urlWithoutQuery] ) {
        // Lose file, reset module download state.
        [module reset];
    }
    realURL = [NSURL fileURLWithPath:realPath];
    
    [[MSWebApp webApp].memoryCache pushModule:module.mid];
    return [[[MSWebApp webApp].getRegistedClass alloc] initWithURLs:realURL.absoluteString];
}

+ (void) setAppUserAgent: (NSString *) customUserAgentString {
    @autoreleasepool {
        UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString* userAgent    = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        NSString *ua           = [NSString stringWithFormat:@"%@ %@",
                        userAgent,
                        customUserAgentString];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
    }
}

- (Class) getRegistedClass {
    if ( !_registedClass ) {
        return [MSWebViewController class];
    }
    if ( ![_registedClass isSubclassOfClass:[MSWebViewController class]] ) {
        return [MSWebViewController class];
    }
    return _registedClass;
}

+ (void) enableLogging {
    [MSWebApp webApp]->_logging = YES;
}

@end
