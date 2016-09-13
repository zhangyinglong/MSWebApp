//
//  MSMemory.h
//  Pods
//
//  Created by Dylan on 2016/9/13.
//
//

#import <Foundation/Foundation.h>

@interface MSMemory : NSObject
/**
 Data in module with key. Explain key: should be tplId or fileKey.
 The memory cache is a simple map, key <-> data.
 */
- (NSData *) datainModule: (NSString *) mid key: (NSString *) key;
/**
 Store or update value.
 */
- (BOOL) setData: (NSData *) data forKey: (NSString *) key inModule: (NSString *) mid;
/**
 Push module, load all module files to memory for use.
 */
- (void) pushModule: (NSString *) mid;
/**
 Pop module, remove all in memory data about this.
 */
- (void) popModule: (NSString *) mid;
/**
 Remove all memory modules.
 */
- (void) removeAll;

/**
 Now this memory cache costed.
 */
- (NSUInteger) cost;

@end
