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
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[MSWebAppUtil getLocalCachePath]];
    NSURL *U = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@.zip", self.mid]]];
    
    if ( [_sync isEqualToString:@"y"] ) {
        NSData * zipData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:_packageurl]];
        if ( zipData ) {
            [[NSFileManager defaultManager] removeItemAtURL:U error:nil];
            if ( [zipData writeToURL:U atomically:YES] ) {
                [self unzip];
                return;
            }
        }
        [self postLoadedFailure];
    } else {
        __weak typeof(self) weakSelf = self;
        [[MSWebApp webApp].net
         getModule:_packageurl
         save2:U
         handler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
             if ( !error ) {
                 [weakSelf unzip];
             } else {
                 [weakSelf postLoadedFailure];
             }
         } progressHandler:^(CGFloat progress) {
             if ( weakSelf.downloadProgressHandler ) {
                 weakSelf.downloadProgressHandler(weakSelf.mid, progress);
             }
         }];
    }
}

- (void) unzip {
    __weak typeof(self) weakSelf = self;
    NSString * fp = [[MSWebAppUtil getLocalCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", _mid]];
    [WPZipArchive unzipFileAtPath:fp toDestination:[MSWebAppUtil getLocalCachePath] progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
        
    } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
        if ( succeeded ) {
            [[NSFileManager defaultManager] removeItemAtPath:fp error:nil];
            weakSelf.downloaded = YES;
            [weakSelf postLoadedSuccess];
            [[MSWebApp webApp].op saveToDB];
        }
        else [weakSelf postLoadedFailure];
    }];
}

- (void) postLoadedFailure {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MSWebModuleFetchErr" object:_mid];
}

- (void) postLoadedSuccess {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MSWebModuleFetchOk" object:_mid];
}

- (void) setValue: (id) value
  forUndefinedKey: (NSString *) key {
}

@end
