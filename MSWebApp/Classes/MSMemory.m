//
//  MSMemory.m
//  Pods
//
//  Created by Dylan on 2016/9/13.
//
//

#import "MSMemory.h"
#import "MSWebAppUtil.h"

@interface MSMemory ()

@property ( nonatomic, strong ) NSMutableDictionary *memoryCache;

@end

@implementation MSMemory

/*!
 @code
                {
                    mid: {
                        "enter.tpl": [NSData data],
                        "/js/mui.min.js": [NSData data]
                    },
                    mid: {}
                }
 @endcode
 */

- (instancetype) init {
    self            = [super init];
    _memoryCache    = [NSMutableDictionary dictionaryWithCapacity:1];
    if ( !self ) {
        MSLog(@"%@", @"MSMemory initialized with error!");
    }
    return self;
}

- (void) pushModule: (NSString *) mid {
    if ( !_memoryCache[mid] ) {
        MSLog(@"Push Module %@ in memory cache!", mid);
    } else {
        MSLog(@"Update Module %@ in memory cache!", mid);
    }
    
    NSMutableDictionary     *moduleCache;
    MSWebAppModule          *module;
    
    moduleCache = [NSMutableDictionary dictionaryWithCapacity:1];
    module      = [MSWebApp webApp].op.moduleMap[mid];
    
    if ( module ) {
        // Recursive push data in module cache.
        // Push tplId->data in this cached dict
        for ( NSString *tplId  in module.urls ) {
            NSString *realFilePath =
            [[module getCachedPath] stringByAppendingPathComponent:module.urls[tplId]];
            if ( [[NSFileManager defaultManager] fileExistsAtPath:realFilePath] ) {
                [moduleCache setObject:[NSData dataWithContentsOfFile:realFilePath]?:[NSData data] forKey:tplId];
            }
        }
        // Push fileId->fileRealData in thie cached dict
        for ( NSString *fileId  in module.files) {
            NSString *realFilePath =
            [[module getCachedPath] stringByAppendingPathComponent:fileId];
            if ( [[NSFileManager defaultManager] fileExistsAtPath:realFilePath] ) {
                [moduleCache setObject:[NSData dataWithContentsOfFile:realFilePath]?:[NSData data] forKey:fileId];
            }
        }
    }
    // Add this module's data to _memory cache.
    [_memoryCache setObject:moduleCache forKey:mid];
}

- (void) popModule: (NSString *) mid {
    if ( [_memoryCache.allKeys containsObject:mid] ) {
        MSLog(@"Remove Module %@ from memory cache", mid);
        [_memoryCache removeObjectForKey:mid];
    }
}

- (void) removeAll {
    [_memoryCache removeAllObjects];
}

- (NSData *) datainModule: (NSString *) mid key: (NSString *) key {
    NSMutableDictionary *cachedModule = _memoryCache[mid];
    // Ret data.
    if ( cachedModule ) {
        return [cachedModule objectForKey:key];
    }
    return nil;
}

- (BOOL) setData: (NSData *) data forKey: (NSString *) key inModule: (NSString *) mid {
    NSMutableDictionary *cachedModule = _memoryCache[mid];
    if ( cachedModule ) {
        [cachedModule setObject:data?:[NSData data] forKey:key];
    }
    return NO;
}

- (NSUInteger) cost {
    NSData *data = [NSJSONSerialization dataWithJSONObject:_memoryCache options:NSJSONWritingPrettyPrinted error:nil];
    return data? data.length: 0;
}

@end
