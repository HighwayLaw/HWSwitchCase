//
//  NSObject+HWSwitchCase.h
//  TestApp
//
//  Created by liuhaiwei on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HWCaseBlock)(void);

@interface NSObject (HWSwitchCase)

- (void)switchInCases:(NSDictionary<id<NSCopying>, HWCaseBlock> *)cases;
- (void)switchInCases:(NSDictionary<id<NSCopying>, HWCaseBlock> *)cases withDefault:(nullable HWCaseBlock)defaultBlock;

@end

NS_ASSUME_NONNULL_END
