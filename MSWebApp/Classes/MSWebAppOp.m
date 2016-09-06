//
//  MSWebAppOp.m
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import "MSWebAppOp.h"
#import "MSWebAppUtil.h"
#import "MSWebApp.h"
#import "NSObject+LKDBHelper.h"
#import "WPZipArchive.h"

@implementation MSWebAppOp

- (NSMutableDictionary<NSString *,MSWebAppModule *> *) moduleMap {
    if ( !_moduleMap ) {
        _moduleMap = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    [_moduleMap removeAllObjects];
    [_module
     enumerateObjectsUsingBlock:^(MSWebAppModule * obj, NSUInteger idx, BOOL * stop) {
         [_moduleMap setObject:obj forKey:obj.mid];
     }];
    return _moduleMap;
}

- (void) setValue: (id) value
  forUndefinedKey: (NSString *) key {
}

@end

@implementation MSWebAppModule

- (NSString *) getCachedPath {
    return [[MSWebAppUtil getLocalCachePath] stringByAppendingPathComponent:self.mid];
}

- (void) get {
    NSURL       *documentsDirectoryURL;
    NSURL       *U;
    dispatch_source_t sync_sources;
    
    __weak typeof(self) weakSelf = self;
    
    documentsDirectoryURL = [NSURL fileURLWithPath:[MSWebAppUtil getLocalCachePath]];
    U = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@.zip", self.mid]]];
    
    if ( [_sync isEqualToString:@"y"] ) {
        sync_sources = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_global_queue(0, 0));
    }
    [self postStartLoading];
    [[MSWebApp webApp].net
     getModule:_packageurl
     save2:U
     handler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
         if ( !error ) {
             [weakSelf unzipWith:sync_sources];
         } else {
             [weakSelf postLoadedFailure];
             if ( [weakSelf.sync isEqualToString:@"y"] ) {
                 dispatch_source_merge_data(sync_sources, 1);
             }
         }
     } progressHandler:^(CGFloat progress) {
         if ( weakSelf.downloadProgressHandler ) {
             weakSelf.downloadProgressHandler(weakSelf.mid, progress);
         }
     }];
    
    if ( [_sync isEqualToString:@"y"] ) {
        dispatch_resume(sync_sources);
        dispatch_source_set_event_handler(sync_sources, ^{
            // Handler ~
            //int value = dispatch_source_get_data(sync_sources);
        });
    }
}

- (void) unzipWith: (dispatch_source_t) sync_t {
    __weak typeof(self) weakSelf = self;
    NSString * fp                = [[MSWebAppUtil getLocalCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", _mid]];
    
    [WPZipArchive unzipFileAtPath:fp toDestination:[MSWebAppUtil getLocalCachePath] progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
        
    } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
        if ( [weakSelf.sync isEqualToString:@"y"] ) {
            dispatch_source_merge_data(sync_t, 1);
        }
        if ( succeeded ) {
            [[NSFileManager defaultManager] removeItemAtPath:fp error:nil];
            weakSelf.downloaded = YES;
            [weakSelf postLoadedSuccess];
            [[MSWebApp webApp].op saveToDB];
        }
        else [weakSelf postLoadedFailure];
    }];
}

- (void) postStartLoading {
    [[NSNotificationCenter defaultCenter] postNotificationName:MSWebModuleFetchBegin object:self];
}

- (void) postLoadedFailure {
    [[NSNotificationCenter defaultCenter] postNotificationName:MSWebModuleFetchErr object:self];
}

- (void) postLoadedSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:MSWebModuleFetchOk object:self];
}

- (void) setValue: (id) value
  forUndefinedKey: (NSString *) key {
}

@end
