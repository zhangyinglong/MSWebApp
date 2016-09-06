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

NSString MS_CONST MSWebAppGetOptionSuccess = @"MSWebAppGetOptionSuccess";
NSString MS_CONST MSWebAppGetOptionFailure = @"MSWebAppGetOptionFailure";
NSString MS_CONST MSWebModuleFetchBegin = @"MSWebModuleFetchBegin";
NSString MS_CONST MSWebModuleFetchErr = @"MSWebModuleFetchErr";
NSString MS_CONST MSWebModuleFetchOk = @"MSWebModuleFetchOk";

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
    MSWebAppOp * oldOp         = [MSWebAppOp searchSingleWithWhere:nil orderBy:nil];
    if ( oldOp ) {
        [MSWebApp webApp].net.version = oldOp.version;
    }
    
    [[MSWebApp webApp].net
     getWebAppWithHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
         if ( error || !responseObject ) {
             [[NSNotificationCenter defaultCenter] postNotificationName:MSWebAppGetOptionFailure object:nil];
         } else {             
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
         }
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
    
    // http://um.devdylan.com/mainModule/enter.tpl?a=b&b=c
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
        return [[[MSWebApp webApp].getRegistedClass alloc] initWithURLs:string];
    }
    
    // Validated urls, 可能是配置文件模块, 不需要访问
    if ( !module.urls || !module.urls[paths[1]]) {
        return [[[MSWebApp webApp].getRegistedClass alloc] initWithURLs:string];
    }
    
    NSString * urlWithoutQuery = [[module getCachedPath] stringByAppendingPathComponent:module.urls[paths[1]]];
    NSString * realPath =
    [NSString stringWithFormat:@"%@?%@", [[module getCachedPath] stringByAppendingPathComponent:module.urls[paths[1]]], URL.query?: @"query=none" ];
    
    realURL = [NSURL fileURLWithPath:realPath];
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

@end