//
//  MSWebAppUtil.m
//  Pods
//
//  Created by Dylan on 2016/8/26.
//
//

#import "MSWebAppUtil.h"
#import "MSWebApp.h"
#import "MSWebAppOp.h"
#import "NSObject+LKDBHelper.h"
#import <sys/utsname.h>
#import "MSURLProtocol.h"

NSString MS_CONST MSURLProtocolIdentifier = @"MSURLProtocolIdentifierNotificationName";
NSString MS_CONST MSWebAppGetOptionSuccess = @"MSWebAppGetOptionSuccessNotificationName";
NSString MS_CONST MSWebAppGetOptionFailure = @"MSWebAppGetOptionFailureNotificationName";
NSString MS_CONST MSWebModuleFetchBegin = @"MSWebModuleFetchBeginNotificationName";
NSString MS_CONST MSWebModuleFetchErr = @"MSWebModuleFetchErrNotificationName";
NSString MS_CONST MSWebModuleFetchOk = @"MSWebModuleFetchOkNotificationName";
NSString MS_CONST MSWebModuleFetchProgress = @"MSWebModuleFetchProgressNotificationName";

@implementation MSWebAppUtil

+ (void) handlerOp {
    // Current Op
    MSWebAppOp * op    = [MSWebApp webApp].op;
    // Get Old Op, And remove from db.
    MSWebAppOp * oldOp = [MSWebAppOp searchSingleWithWhere:nil orderBy:nil];
    // Post notification
    [[NSNotificationCenter defaultCenter] postNotificationName:MSWebAppGetOptionSuccess object:op ?: oldOp];
    if ( !op ) {
        [MSWebApp webApp].op = oldOp;
        return;
    }
    // First use web app
    if ( !oldOp ) {
        [self cleanLocalCache];
        [MSWebAppUtil downloadAll];
        return;
    }
    // Remove old from db
    [MSWebAppOp deleteToDB:oldOp];
    // Full version update
    if ( ![oldOp.version isEqualToString:op.version] ) {
        [self cleanLocalCache];
        [MSWebAppUtil downloadAll];
        return;
    }
    // Check module state. [1]: diff.
    [oldOp.moduleMap
     enumerateKeysAndObjectsUsingBlock:^(NSString * key, MSWebAppModule * obj, BOOL * stop) {
         if ( !op.moduleMap[key] ) {
             [self cleanLocalModule:key];
         } else {
             MSWebAppModule * newObj = op.moduleMap[key];
             if ( ![obj.version isEqualToString:newObj.version] ) {
                 [self cleanLocalModule:key];
             } else {
                 NSString * path = [[MSWebAppUtil getLocalCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", obj.mid]];
                 if ( [[NSFileManager defaultManager] fileExistsAtPath:path] ) {
                     // TODO: file CRC check!
                     newObj.downloaded = YES;
                 }
             }
         }
    }];
    // Download
    [self downloadAll];
}

+ (void) downloadAll {
    [[MSWebApp webApp].op.module
     enumerateObjectsUsingBlock:^(MSWebAppModule * obj, NSUInteger idx, BOOL * stop) {
         obj.downloaded? [obj postLoadedSuccess]: ({
             // Download it when config handled success.
             if ( [obj.initdown isEqualToString:@"y"] )
                 [obj get];
         });
     }];
    
    [[MSWebApp webApp].op saveToDB];
}

+ (NSString *) getLocalCachePath {
    NSString * rootURL = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"mswebapp/"];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:rootURL] ) {
        MSLog(@"Create local root folder!, first use it.%@", @"");
        [[NSFileManager defaultManager] createDirectoryAtPath:rootURL withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return rootURL;
}

+ (void) cleanLocalCache {
    NSError * error = nil;
    MSLog(@"Clean local root folder%@", @"");
    [[NSFileManager defaultManager] removeItemAtPath:[MSWebAppUtil getLocalCachePath] error:&error];
}

+ (void) cleanLocalModule: (NSString *) mid {
    NSError * error = nil;
    MSLog(@"Clean local module: %@", mid);
    [[NSFileManager defaultManager] removeItemAtPath:[[self getLocalCachePath] stringByAppendingPathComponent:mid] error:&error];
}

+ (void) cleanWebView {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) initialized {
    /**
     Create And print local cache folder.
     */
    NSString * localRootCachePath = [self getLocalCachePath];
    MSLog(@"\nWebApp Local root: %@", localRootCachePath);
    /**
     Start get config
     */
    [MSWebAPI startApp];
    /**
     Little help for `UIWebView` memory leak
     */
    [MSWebAppUtil cleanWebView];
}

@end
