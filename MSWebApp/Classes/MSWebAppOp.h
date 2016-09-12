/*       ___         __  ___  _   ___  ___
  /| /| /___ | /| / /_  /__/ /_| /__/ /__/
 / |/ | ___/ |/ |/ /__ /__/ /  |/    /
 */

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
 Is WebApp download it when load config success.
 y -> download;
 n -> do nothing, only save then module object to operation, but when in use, will load it.
 if you only want to use it when visit, set initdown to n, and sync to y is the best choose.
 */
@property ( nonatomic, strong ) NSString *initdown;

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
 Module file map,
 File absolute path : File remote path, Now, it's simply.
 */
@property ( nonatomic, strong ) NSDictionary <NSString *, NSString *> *files;

/**
 Get local cached Path.
 */
- (NSString *) getCachedPath;

/**
 Get module
 */
- (void) get;

/**
 Reset module, set downloaded flag to `NO`, reset and reget.
 */
- (void) reset;

/**
 Download success.
 */
@property ( nonatomic, assign ) BOOL downloaded;

/**
 Progress
 */
@property ( nonatomic, assign ) CGFloat mountProgress;

/**
 Module desc
 */
@property ( nonatomic, strong ) NSString * desc;

#pragma mark - private methods

/**
 Send success notification, used for util.
 */
- (void) postLoadedSuccess;

@end
