//
//  MSWebAppOp.h
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import <Foundation/Foundation.h>

@class MSWebAppModule;

@interface MSWebAppOp : NSObject

/**
 Version not equal, clean local cache and reDownload all.
 */
@property ( nonatomic, strong ) NSString *version;

/**
 Sub Modules.
 */
@property ( nonatomic, strong ) NSArray < MSWebAppModule* > *module;

/**
 Sub Module map. mid: m
 */
@property ( nonatomic, strong ) NSMutableDictionary < NSString *, MSWebAppModule* > *moduleMap;

@end

@interface MSWebAppModule : NSObject

/**
 Loaded with sync.
 */
@property ( nonatomic, strong ) NSString *sync;

/**
 Module identifier.
 */
@property ( nonatomic, strong ) NSString *mid;

/**
 Where module download from.
 */
@property ( nonatomic, strong ) NSString *packageurl;

/**
 Module version.
 */
@property ( nonatomic, strong ) NSString *version;

/**
 Module tpl map.
 */
@property ( nonatomic, strong ) NSDictionary <NSString *, NSString *> *urls;

/**
 Get local cached Path.
 */
- (NSString *) getCachedPath;

/**
 Get module
 */
- (void) get;

/**
 Download success.
 */
@property ( nonatomic, assign ) BOOL downloaded;

/**
 Download progress
 */
@property ( nonatomic, copy ) void (^downloadProgressHandler)(NSString *mid, CGFloat progress);

/**
 Module desc
 */
@property ( nonatomic, strong ) NSString * desc;

@end
