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
#import "MSMemory.h"

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

@interface MSWebAppModule () {
	
}

@property ( nonatomic, assign ) BOOL mounting;

@end

@implementation MSWebAppModule

- (NSString *) getCachedPath {
	return [[MSWebAppUtil getLocalCachePath] stringByAppendingPathComponent:self.mid];
}

- (void) reset {
	self.downloaded = NO;
	[self get];
}

- (void)setDownloaded:(BOOL)downloaded {
	_downloaded = downloaded;
	[[MSWebApp webApp].op saveToDB];
}

- (void)setMountProgress:(CGFloat)mountProgress {
	_mountProgress = mountProgress;
	[self postProgress];
}

- (BOOL) syncDownload {
	return [self.sync isEqualToString:@"y"];
}

- (void) get {
	// Now is downloading the module.
	if ( _mounting ) {
		return ;
	}
	NSURL             *documentsDirectoryURL;
	NSURL             *U;
	
	__weak typeof(self) weakSelf = self;
	
	documentsDirectoryURL = [NSURL fileURLWithPath:[MSWebAppUtil getLocalCachePath]];
	U = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@.zip", self.mid]]];
	
	// post start download notification.
	[self postStartLoading];
	if ( [self syncDownload] ) {
		NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_packageurl]];
		if ( data ) {
			NSString *filePath =
			[[MSWebAppUtil getLocalCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", self.mid]];
			if ( [data writeToFile:filePath atomically:YES] ) {
				weakSelf.mountProgress = 1 * 0.7;
				[self unzip];
				return;
			}
		}
		[weakSelf postLoadedFailure];
		return;
	}
	
	// async download and zip module.
	[[MSWebApp webApp].net
	 getModule:_packageurl
	 save2:U
	 handler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
		 if ( !error ) {
			 MSLog(@"Download success! unzipping mid: %@", weakSelf.mid);
			 [weakSelf unzip];
		 } else {
			 MSLog(@"Download failure! mid: %@", weakSelf.mid);
			 [weakSelf postLoadedFailure];
		 }
	 } progressHandler:^(CGFloat progress) {
		 weakSelf.mountProgress = progress * 0.7;
	 }];
}

- (void) unzip {
	__weak typeof(self) weakSelf = self;
	NSString * fp                = [[MSWebAppUtil getLocalCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip", _mid]];
	
	[WPZipArchive
	 unzipFileAtPath:fp
	 toDestination:[MSWebAppUtil getLocalCachePath]
	 progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
		 weakSelf.mountProgress = (entryNumber * 1.0 / total) * 0.3 + 0.7;
	 } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
		 if ( succeeded ) {
			 [[NSFileManager defaultManager] removeItemAtPath:fp error:nil];
			 weakSelf.downloaded = YES;
			 [weakSelf postLoadedSuccess];
		 }
		 else {
			 [weakSelf postLoadedFailure];
		 }
	 }];
}

- (void) postStartLoading {
	_mounting = YES;
	self.mountProgress = 0.0;
	MSLog(@"Begin mount module: %@", _mid);
	[[NSNotificationCenter defaultCenter] postNotificationName:MSWebModuleFetchBegin object:self];
}

- (void) postLoadedFailure {
	[[MSWebApp webApp].memoryCache popModule:self.mid];
	_mounting = NO;
	self.mountProgress = 0.0;
	MSLog(@"Mount failure! mid: %@", _mid);
	[[NSNotificationCenter defaultCenter] postNotificationName:MSWebModuleFetchErr object:self];
}

- (void) postLoadedSuccess {
	// Set memory cache.
	[[MSWebApp webApp].memoryCache pushModule:self.mid];
	_mounting = NO;
	self.mountProgress = 1.0;
	MSLog(@"Mount module Succeed! mid: %@", _mid);
	[[NSNotificationCenter defaultCenter] postNotificationName:MSWebModuleFetchOk object:self];
}

- (void) postProgress {
	[[NSNotificationCenter defaultCenter] postNotificationName:MSWebModuleFetchProgress object:self];
}

- (void) setValue: (id) value
	forUndefinedKey: (NSString *) key {
}

@end
