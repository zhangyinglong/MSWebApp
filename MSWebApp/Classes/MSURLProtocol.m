//
//  MSURLProtocol.m
//  Pods
//
//  Created by Dylan on 2016/9/7.
//
//

#import "MSURLProtocol.h"

@implementation MSURLProtocol

+ (void) load {
    [NSURLProtocol registerClass:self];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
//    NSLog(@"%@\n%@\n\n", request.URL, request.allHTTPHeaderFields);
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest * result;
    
    // 处理Request
    result = [request mutableCopy];
    return result;
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                 cachedResponse:(NSCachedURLResponse *)cachedResponse
                         client:(id<NSURLProtocolClient>)client {
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if ( !self ) {
        NSLog(@"Initialized %@ failure!", request.URL);
    }
    return self;
}

- (void)startLoading {
    
}

- (void)stopLoading {
    
}

@end
