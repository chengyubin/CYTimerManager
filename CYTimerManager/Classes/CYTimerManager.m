//
//  CYTimerManager.m
//  CYTimerManager
//
//  Created by CCyber on 2019/1/11.
//

#import "CYTimerManager.h"
#import "CYTimerModel.h"
@interface CYTimerManager()
@property (nonatomic) dispatch_queue_t timerQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, CYTimerModel *> *timerDictionary;

@end


@implementation CYTimerManager
+ (instancetype)getInstance {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CYTimerManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timerQueue = dispatch_queue_create("CYTimerManager.Timer", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (BOOL)isRegisteredForKey:(NSString *)key {
    if ([self.timerDictionary objectForKey:key]) {
        return YES;
    }
    return NO;
}

- (void)registerTimerForKey:(NSString *)key fireDate:(NSDate *)fireDate interval:(NSTimeInterval)interval repeat:(BOOL)repeat fireBlock:(dispatch_block_t)fireBlock {
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.timerQueue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, [fireDate timeIntervalSinceNow] * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    __weak __typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        __typeof(weakSelf) strongSelf = weakSelf;

        [fireBlock invoke];
        if (!repeat) {
            [strongSelf unregisterTimerForKey:key];
        }
    });
    dispatch_resume(timer);
    
    CYTimerModel *timerModel = [CYTimerModel new];
    timerModel.timer = timer;
    [self.timerDictionary setObject:timerModel forKey:key];
}

- (void)unregisterTimerForKey:(NSString *)key {
    CYTimerModel *timerModel = [self.timerDictionary objectForKey:key];
    if (timerModel) {
        dispatch_source_cancel(timerModel.timer);
        [self.timerDictionary removeObjectForKey:key];
    }
}


- (void)perform:(dispatch_block_t)block interval:(NSTimeInterval)interval repeatTimes:(NSInteger)repeatTimes until:(BOOL(^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) block();
        if (repeatTimes <= 0) {
            return ;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion && !completion()) {
                [self perform:block interval:interval repeatTimes:repeatTimes-1 until:completion];
            }
        });
    });
}

#pragma mark - Getter
- (NSMutableDictionary<NSString *, CYTimerModel *> *)timerDictionary {
    if (!_timerDictionary) {
        _timerDictionary = [NSMutableDictionary new];
    }
    return _timerDictionary;
}

@end
