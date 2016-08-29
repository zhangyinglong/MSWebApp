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
    __weak typeof(self) weakSelf = self;
    
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:[MSWebAppUtil getLocalCachePath]];
    NSURL *U = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@.zip", self.mid]]];
    
    // NSLog(@"开始下载模块: %@", _mid);
    [[MSWebApp webApp].net
     getModule:_packageurl
     save2:U
     handler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
         if ( !error ) {
             // Unzip
             // NSLog(@"模块: %@ 下载成功, 开始解压", _mid);
             NSString * fp = [[MSWebAppUtil getLocalCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", self.mid]];
             [WPZipArchive unzipFileAtPath:fp toDestination:[MSWebAppUtil getLocalCachePath] progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                 
             } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                 if ( succeeded ) {
                     // NSLog(@"<%@> 解压成功", self.mid);
                     [[NSFileManager defaultManager] removeItemAtPath:fp error:nil];
                     weakSelf.downloaded = YES;
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"MSWebModuleFetchOk" object:weakSelf.mid];
                     [[MSWebApp webApp].op saveToDB];
                 }
                 // else NSLog(@"<%@> 解压失败: error: %@", self.mid, error.localizedDescription);
             }];
         } else {
             // NSLog(@"模块: %@ 下载失败, 开始解压", _mid);
         }
     } progressHandler:^(CGFloat progress) {
         if ( weakSelf.downloadProgressHandler ) {
             weakSelf.downloadProgressHandler(weakSelf.mid, progress);
         }
     }];
}

- (void) setValue: (id) value
  forUndefinedKey: (NSString *) key {
}

@end
