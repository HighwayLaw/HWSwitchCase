//
//  NSObject+HWSwitchCase.m
//  TestApp
//
//  Created by liuhaiwei on 2021/12/14.
//

#import "NSObject+HWSwitchCase.h"

@implementation NSObject (HWSwitchCase)

- (void)switchInCases:(NSDictionary<id<NSCopying>,HWCaseBlock> *)cases {
    [self switchInCases:cases withDefault:nil];
}

- (void)switchInCases:(NSDictionary<id<NSCopying>,HWCaseBlock> *)cases withDefault:(HWCaseBlock)defaultBlock {
    NSAssert([self conformsToProtocol:@protocol(NSCopying)], @"must confirm to <NSCopying>");
    HWCaseBlock caseBlock = cases[(id<NSCopying>)self];
    if (caseBlock) {
        caseBlock();
    } else if (defaultBlock) {
        defaultBlock();
    }
}
@end
