//
//  CYTimerModel.h
//  CYTimerManager
//
//  Created by CCyber on 2019/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYTimerModel : NSObject
@property (nonatomic, strong) dispatch_source_t timer;
@end

@interface CYDisplayLinkModel : NSObject
@property (nonatomic, copy) dispatch_block_t fireBlock;
@end


NS_ASSUME_NONNULL_END
