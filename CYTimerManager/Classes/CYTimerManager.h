//
//  CYTimerManager.h
//  CYTimerManager
//
//  Created by CCyber on 2019/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYTimerManager : NSObject
+ (instancetype)getInstance;

- (BOOL)isRegisteredForKey:(NSString *)key;

- (void)registerTimerForKey:(NSString *)key fireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval repeat:(BOOL)repeat fireBlock:(dispatch_block_t)fireBlock;

- (void)unregisterTimerForKey:(NSString *)key;

- (void)perform:(dispatch_block_t)block interval:(NSTimeInterval)interval repeatTimes:(NSInteger)repeatTimes until:(BOOL(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
